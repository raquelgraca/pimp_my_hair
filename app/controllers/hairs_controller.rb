class HairsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  before_action :set_hair, only: [:show, :edit, :update, :destroy]

  def index
    @purchases = policy_scope(Purchase)
    @hairs = policy_scope(Hair)
    @unsold_hairs = []
    @hairs.each do |hair|
      @unsold_hairs << hair if !hair.sold
    end
    @unsold_hairs
  end

  def new
    @hair = Hair.new
    authorize @hair
  end

  def create
    @hair = Hair.new(hairs_params)
    @hair.user = current_user
    authorize @hair
    if @hair.save
      redirect_to hairs_path
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    @hair.update(hairs_params)
    if @hair.save
      redirect_to @hair
    else
      render :edit
    end
  end

  def destroy
    @hair.destroy
    redirect_to hairs_path
  end

  def my_hair
    @hairs = current_user.hairs
    authorize @hairs
  end

   private

  def hairs_params
    params.require(:hair).permit(:ethnicity, :weight_grams, :length_cm, :price, :hair_type, :colour, photos: [])
  end

  def set_hair
    @hair = Hair.find(params[:id])
    authorize @hair
  end

end
