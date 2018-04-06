class ToolsController < ApplicationController
  before_action :load_tool, only: [:show, :edit, :update, :destroy]
  before_action :require_login, except:[:index, :show]
  before_action :require_user_authority, only: [:edit, :update, :destroy]

  def index
    @tools = Tool.search(params[:tool], params[:nbhd])
  end

  def new
    @tool = Tool.new
  end

  def create
    @tool = Tool.new

    @tool.name = params[:tool][:name]
    @tool.description = params[:tool][:description]
    @tool.condition = params[:tool][:condition]
    @tool.loan_length = params[:tool][:loan_length]
    @tool.on_loan = false
    @tool.user_id = current_user.id


    if params[:tool][:picture] != nil
      if @tool.save
        upload_pictures
        redirect_to tool_url(@tool)
      else
        render :new
      end
    else
      @tool.errors[:tool] << "must contain at least one photo"
      render :new
    end
  end

  def edit

  end

  def update
    @tool.name = params[:tool][:name]
    @tool.description = params[:tool][:description]
    @tool.condition = params[:tool][:condition]
    @tool.loan_length = params[:tool][:loan_length]

      if @tool.save
        remove_pictures
        upload_pictures
        redirect_to tools_url
      else
        render :edit
      end
    end

  def show
    @tool = Tool.find(params[:id])
    @review = Review.new
    @reviews = @tool.reviews.order(created_at: :desc)

  end

  def destroy
    remove_picture_files
    @tool.destroy
    flash[:notice] = "You have successfully deleted this tool."
    redirect_to tools_url
  end

  def load_tool
    @tool = Tool.find(params[:id])
  end

  def require_user_authority
    unless current_user == @tool.owner
      flash[:alert] = "You are not authorized to modify this tool."
      redirect_to login_url
    end
  end

  def remove_pictures
    params[:tool][:image_ids].each do |image_id|
      unless image_id == ""
        @image = OwnerImage.find(image_id)
        File.delete(@@owner_image_path.join(@image.file_name))
        @image.destroy
      end
    end
  end

  def remove_picture_files
    @tool.owner_images.each do |image|
      @image = OwnerImage.find(image.id)
      File.delete(@@owner_image_path.join(image.file_name))
      @image.destroy
    end
  end

  def upload_pictures
     unless params[:tool][:picture] == nil
       uploaded_ios = params[:tool][:picture]
       uploaded_ios.each do |uploaded_io|
         img_file = @@prefix + uploaded_io.original_filename
         File.open(@@owner_image_path.join(img_file), 'wb') do |file|
           file.write(uploaded_io.read)
         end

         picture = OwnerImage.new
         picture.file_name = img_file
         picture.tool = @tool

         if !picture.save
           flash[:alert] = "The picture #{img_file} is failed in uploading to the server."
         end
       end
     end
   end
end
