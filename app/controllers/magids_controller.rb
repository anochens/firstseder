class MagidsController < ApplicationController
  before_action :set_magid, only: [:show, :edit, :update, :destroy]
  attr_accessor :new_magid_name

  # GET /magids
  # GET /magids.json
  def index
    @magids = Magid.all
  end

  # GET /magids/1
  # GET /magids/1.json
  def show
  end

  # GET /magids/new
  def new
    @magid = Magid.new
  end

  # GET /magids/1/edit
  def edit
  end


  # POST /magids
  # POST /magids.json
  def create
    @magid = Magid.new(magid_params)

    respond_to do |format|
      if @magid.save
        format.html { redirect_to @magid, notice: 'Magid was successfully created.' }
        format.json { render :show, status: :created, location: @magid }
      else
        format.html { render :new }
        format.json { render json: @magid.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /magids/1
  # PATCH/PUT /magids/1.json
  def update
    respond_to do |format|
      if @magid.update(magid_params)
        format.html { redirect_to @magid, notice: 'Magid was successfully updated.' }
        format.json { render :show, status: :ok, location: @magid }
      else
        format.html { render :edit }
        format.json { render json: @magid.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /magids/1
  # DELETE /magids/1.json
  def destroy
    @magid.destroy
    respond_to do |format|
      format.html { redirect_to magids_url, notice: 'Magid was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_magid
      @magid = Magid.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def magid_params
      params.require(:magid).permit(:name)
    end
end
