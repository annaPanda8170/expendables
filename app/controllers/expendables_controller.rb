class ExpendablesController < ApplicationController
  def index
    @expendables = Expendable.where(user_id: current_user.id).includes(:user)
    @period = current_user.period
  end
  def buy
    buy_quantity = Expendable.set_buy_quantity(params, current_user.id)
    email = current_user.email
    password = params[:buy_password]
    BuyJob.set(wait: 3.second).perform_later(buy_quantity, email, password)
    redirect_to root_path
  end
  def new
    @expendable = Expendable.new
    @quantity = Expendable.set_quantity
  end
  def create
    @expendable = Expendable.new(expendable_params)
    if @expendable.save
      GetImageJob.perform_later(@expendable)
      redirect_to root_path
    else
      render :new
    end
  end
  def edit
  end
  def update
  end
  def destroy
    expendable = Expendable.find(params[:id])
    expendable.destroy
    redirect_to root_path
  end
  private
  def expendable_params
    params.require(:expendable).permit(:name, :url, :quantity).merge(user_id: current_user.id)
  end
end
