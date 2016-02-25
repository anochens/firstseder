class ShiursController < ApplicationController
  before_action :set_shiur, only: [:show, :edit, :update, :destroy]

  # GET /shiurs
  # GET /shiurs.json
  def index
    @shiurs = Shiur.all
  end

  # GET /shiurs/1
  # GET /shiurs/1.json
  def show
  end

  # GET /shiurs/new
  def new
    @shiur = Shiur.new
  end

  # GET /shiurs/1/edit
  def edit
  end

  # POST /shiurs
  # POST /shiurs.json
  def create
	 @shiur = Shiur.new(shiur_params)

	 if(params['shiur']['magid_id'] == '') 
	    @m = Magid.create!(name: params['shiur']['new_magid_name']);
	    @shiur.magid = @m
	 end

	 if(params['shiur']['category_id'] == '') 
	    @c = Category.create!(name: params['shiur']['new_category_name']);
	    @shiur.category = @c
	 end  

	 if(params['shiur']['subcat_id'] == '') 
	    @c = Subcat.create!(name: params['shiur']['new_subcat_name']);
	    @shiur.subcat = @c
	 end  

	 @shiur.save!


    respond_to do |format|
      if @shiur.save
        format.html { redirect_to @shiur, notice: 'Shiur was successfully created.' }
        format.json { render :show, status: :created, location: @shiur }
      else
        format.html { render :new }
        format.json { render json: @shiur.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shiurs/1
  # PATCH/PUT /shiurs/1.json
  def update
    respond_to do |format|
      if @shiur.update(shiur_params)
        format.html { redirect_to @shiur, notice: 'Shiur was successfully updated.' }
        format.json { render :show, status: :ok, location: @shiur }
      else
        format.html { render :edit }
        format.json { render json: @shiur.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shiurs/1
  # DELETE /shiurs/1.json
  def destroy
    @shiur.destroy
    respond_to do |format|
      format.html { redirect_to shiurs_url, notice: 'Shiur was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shiur
      @shiur = Shiur.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def shiur_params
      params.require(:shiur).permit(:magid_id, :category_id, :subcat_id, :name, :description, :location_link, :shiur_date)
    end
end
