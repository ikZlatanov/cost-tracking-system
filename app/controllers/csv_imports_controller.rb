class CsvImportsController < ApplicationController
  before_action :require_login
  
  def new
    # Renders the view
  end

  def create
    # Check for the file directly in the root params
    if params[:file].present?
      begin
        # 1. Save the audit record
        @csv_import = current_user.csv_imports.build
        @csv_import.file.attach(params[:file])
        
        if @csv_import.save
          # 2. Run our new Service Object
          if CsvImportService.new(@csv_import).process!
            
            # 3. Redirect back to the correct dashboard
            dashboard_path = case current_user.role
                             when 'admin' then admin_dashboard_path
                             when 'project_manager' then pm_dashboard_path
                             when 'developer' then developer_dashboard_path
                             else root_path
                             end
            redirect_to dashboard_path, notice: "CSV securely archived and expenses successfully imported!"
          else
            @csv_import.destroy # Clean up the bad file
            flash.now[:alert] = "File uploaded, but parsing failed. Check CSV format."
            render :new, status: :unprocessable_content
          end
        else
          flash.now[:alert] = "Failed to save the file."
          render :new, status: :unprocessable_content
        end
      rescue => e
        flash.now[:alert] = "System Error: #{e.message}"
        render :new, status: :unprocessable_content
      end
    else
      # If params[:file] is empty
      flash.now[:alert] = "Please select a CSV file to upload."
      render :new, status: :unprocessable_content
    end
  end

  private

  def require_login
    unless current_user
      flash[:alert] = "You must be logged in to view this page."
      redirect_to login_path
    end
  end
end