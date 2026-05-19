require 'csv'

class CsvImportService
  def initialize(csv_import)
    @csv_import = csv_import
    @user = csv_import.user
  end

  def process!
    file_content = @csv_import.file.download
    success_count = 0
    
    CSV.parse(file_content, headers: true, header_converters: :downcase) do |row|
      data = row.to_h
      
      category_name = data["category name"].presence || "Uncategorized"
      category = Category.find_or_create_by!(name: category_name)
      
      project_name = data["project name"].presence || "Default Project"
      project = Project.find_or_create_by!(name: project_name) do |p|
        p.manager = @user
        p.status = "Active"
      end

      # --- ZOMBIE DETECTOR LOGIC ---
      # Check if the project is inactive. If so, flag the expense!
      inactive_statuses = ["Completed", "Paused", "Archived"]
      zombie_flag = inactive_statuses.include?(project.status)

      Expense.create!(
        project: project,
        category: category,
        creator: @user,
        vendor_name: data["vendor name"],
        amount: data["amount"],
        currency: data["currency"] || "USD",
        expense_date: parse_date(data["expense date"]),
        description: data["description"],
        status: "Pending",
        is_zombie: zombie_flag # This saves the alert to the database
      )
      
      success_count += 1
    end

    Rails.logger.info "Successfully imported #{success_count} expenses."
    true
  rescue => e
    Rails.logger.error "CSV Import Failed: #{e.message}"
    false
  end

  private

  def parse_date(date_string)
    return Date.today if date_string.blank?
    Date.parse(date_string) rescue Date.today
  end
end