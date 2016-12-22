class UploadFileToServersController < ApplicationController
  before_action :set_upload_file_to_server, only: [:show, :edit, :update, :destroy]

  # GET /upload_file_to_servers
  # GET /upload_file_to_servers.json
  def index
    @upload_file_to_servers = UploadFileToServer.all
  end

  # GET /upload_file_to_servers/1
  # GET /upload_file_to_servers/1.json
  def show
  end

  # GET /upload_file_to_servers/new
  def new
    @upload_file_to_server = UploadFileToServer.new
  end

  # GET /upload_file_to_servers/1/edit
  def edit
  end

  # POST /upload_file_to_servers
  # POST /upload_file_to_servers.json
  def create
    @upload_file_to_server = UploadFileToServer.new(upload_file_to_server_params)

    respond_to do |format|
      if @upload_file_to_server.save
        format.html { redirect_to @upload_file_to_server, notice: 'Upload file to server was successfully created.' }
        format.json { render :show, status: :created, location: @upload_file_to_server }
      else
        format.html { render :new }
        format.json { render json: @upload_file_to_server.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /upload_file_to_servers/1
  # PATCH/PUT /upload_file_to_servers/1.json
  def update
    respond_to do |format|
      if @upload_file_to_server.update(upload_file_to_server_params)
        format.html { redirect_to @upload_file_to_server, notice: 'Upload file to server was successfully updated.' }
        format.json { render :show, status: :ok, location: @upload_file_to_server }
      else
        format.html { render :edit }
        format.json { render json: @upload_file_to_server.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /upload_file_to_servers/1
  # DELETE /upload_file_to_servers/1.json
  def destroy
    @upload_file_to_server.destroy
    respond_to do |format|
      format.html { redirect_to upload_file_to_servers_url, notice: 'Upload file to server was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_upload_file_to_server
      @upload_file_to_server = UploadFileToServer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def upload_file_to_server_params
      params.require(:upload_file_to_server).permit(:email, :filename)
    end
end
