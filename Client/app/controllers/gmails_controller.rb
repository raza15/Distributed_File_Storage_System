class GmailsController < ApplicationController
  before_action :set_gmail, only: [:show, :edit, :update, :destroy]

  # GET /gmails
  # GET /gmails.json
  def index
    @gmails = Gmail.all
  end

  # GET /gmails/1
  # GET /gmails/1.json
  def show
  end

  # GET /gmails/new
  def new
    @gmail = Gmail.new
  end

  # GET /gmails/1/edit
  def edit
  end

  # POST /gmails
  # POST /gmails.json
  def create
    @gmail = Gmail.new(gmail_params)

    respond_to do |format|
      if @gmail.save
        format.html { redirect_to @gmail, notice: 'Gmail was successfully created.' }
        format.json { render :show, status: :created, location: @gmail }
      else
        format.html { render :new }
        format.json { render json: @gmail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /gmails/1
  # PATCH/PUT /gmails/1.json
  def update
    respond_to do |format|
      if @gmail.update(gmail_params)
        format.html { redirect_to @gmail, notice: 'Gmail was successfully updated.' }
        format.json { render :show, status: :ok, location: @gmail }
      else
        format.html { render :edit }
        format.json { render json: @gmail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gmails/1
  # DELETE /gmails/1.json
  def destroy
    @gmail.destroy
    respond_to do |format|
      format.html { redirect_to gmails_url, notice: 'Gmail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gmail
      @gmail = Gmail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def gmail_params
      params.require(:gmail).permit(:email, :gmailemail, :gmailpass)
    end
end
