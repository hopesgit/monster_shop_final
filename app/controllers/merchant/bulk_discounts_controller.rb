class Merchant::BulkDiscountsController < Merchant::BaseController
  def index
    merchant = Merchant.find(current_user.merchant_id)
    @discounts = merchant.bulk_discounts
  end

  def new
    @merchant = Merchant.find(current_user.merchant_id)
    @discount = BulkDiscount.new
  end

  def create
    discount = BulkDiscount.new(
      item_quantity: new_params[:item_quantity],
      percentage: new_params[:percentage],
      merchant_id: current_user.merchant_id)
    if discount.save
      flash[:success] = "Bulk discount created."
      redirect_to merchant_merchant_bulk_discounts_path(discount.merchant_id)
    else
      flash.now[:warning] = "Form not filled out completely."
      render :new
    end
  end

  def edit
    @discount = BulkDiscount.find(params[:id])
  end

  def update
    binding.pry
    @discount = BulkDiscount.find(params[:id])
    # @discount.update
  end

  private
  def new_params
    params.require(:bulk_discount).permit(:item_quantity, :percentage)
  end
end
