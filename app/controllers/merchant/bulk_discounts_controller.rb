class Merchant::BulkDiscountsController < Merchant::BaseController

  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.new
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    merchant.bulk_discounts.create(bulk_discount_params)

    redirect_to "/merchant/#{merchant.id}/bulk_discounts"
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts.find(params[:bulk_discount_id])
  end

  def update
    merchant = Merchant.find(params[:merchant_id])
    bulk_discount = merchant.bulk_discounts.find(params[:bulk_discount_id])
    bulk_discount.update(bulk_discount_params)

    redirect_to "/merchant/#{merchant.id}/bulk_discounts"
  end

  def destroy
    merchant = Merchant.find(params[:merchant_id])
    bulk_discount = merchant.bulk_discounts.find(params[:bulk_discount_id])
    bulk_discount.destroy

    redirect_to "/merchant/#{merchant.id}/bulk_discounts"
  end

  private

  def bulk_discount_params
    params.require(:bulk_discount).permit(:percentage, :quantity)
  end
end
