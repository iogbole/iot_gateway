class DhtsController < ApplicationController
  skip_before_filter :verify_authenticity_token,  if: :skip_security_context?
  before_action :set_dht, only: [:show, :edit, :update, :destroy]

  # GET /dhts
  # GET /dhts.json
  def index
    @dhts = Dht.all
  end

  # GET /dhts/1
  # GET /dhts/1.json
  def show
  end

  # GET /dhts/new
  def new
    @dht = Dht.new
  end

  # GET /dhts/1/edit
  def edit
  end

  # POST /dhts
  # POST /dhts.json
  def create
    @dht = Dht.new(dht_params)

    respond_to do |format|
      if @dht.save
        #Convert telemetries to json format
        telemetries = dht_params.to_json(:methods => :get_created_at)
        Rails.logger.debug "What does it look like:: #{telemetries} "
        #send to azure event hub
        if eventHub.send_event(telemetries)
          Rails.logger.info 'Successfully sent payload to azure'
          format.html { redirect_to @dht, notice: 'Successfully created records and sent to AzureEventHub.' }
          format.json { render :show, status: :created, location: @dht  }
        else
          format.html { redirect_to @dht, notice: 'Successfully created records but failed to send telemetries to AzureEventHub.' }
          format.json { render :show, status: :created, location: @dht }
        end
      else
        format.html { render :new }
        format.json { render json: @dht.errors, status: :unprocessable_entity }
      end
    end
  end

  def get_created_at
    # this may not scale for large production system.
    Dht.where("chipid >= ? ", @dht.chipid).last
  end

  # PATCH/PUT /dhts/1
  # PATCH/PUT /dhts/1.json
  def update
    respond_to do |format|
      if @dht.update(dht_params)
        format.html { redirect_to @dht, notice: 'Record was successfully updated.' }
        format.json { render :show, status: :ok, location: @dht }
      else
        format.html { render :edit }
        format.json { render json: @dht.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dhts/1
  # DELETE /dhts/1.json
  def destroy
    @dht.destroy
    respond_to do |format|
      format.html { redirect_to dhts_url, notice: 'Record was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # cal averages
  def calculate_average_humidity
    Dht.where("created_at >= ?", Time.zone.now.beginning_of_day).average(:humidity)
  end

  def calculate_average_temperature
    Dht.where("created_at >= ?", Time.zone.now.beginning_of_day).average(:temperature)
  end

  def calculate_average_heat_index
    Dht.where("created_at >= ?", Time.zone.now.beginning_of_day).average(:heat_index)
  end


  protected
  #never do this in production system. Use omniAuth gem to generate OAuth token.
  def skip_security_context?
    request.format.html? || request.format.json? 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dht
      @dht = Dht.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dht_params
     params.require(:dht).permit(:chipid, :location, :description, :temperature, :humidity, :heat_index)
     #  permitted_params = [:chipid, :location, :description, :temperature, :humidity, :heat_index]
     #  params[:dht].reverse_merge!(params.keep_if { |k,v| k.to_sym.in? permitted_params })
     #  params.require(:dht).permit(*permitted_params)
    end

  def eventHub
    @_eventHub ||= AzureEnventHubService.new
  end
end
