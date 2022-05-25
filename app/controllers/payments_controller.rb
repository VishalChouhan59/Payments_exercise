class PaymentsController < ApiBaseController

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: 'not_found', status: :not_found
  end

	before_action :get_loan_detail, only: [:index, :show, :create]

	def index
		render json: @loan.payments
	end

	def show
		payment = @loan.payments.where(id: params[:payment_id])
		return render json: { error: { message: 'Resource Not Found'} }, status: 404 if payment.blank?

		render json: payment
	end

	def create
    payment_amount = params[:amount].to_d
    return render json: { error: { message: 'Amount is not valid' } }, status: 422 unless payment_amount.to_d > 0

    total_payment = @loan.payments.sum(:amount)
    return render json: { error: { message: 'Amount Exceed' } }, status: 422 if payment_amount > (@loan.funded_amount - total_payment)

    if @loan.payments.create(amount: payment_amount)
      render json: { message: 'Payment Success'}, status: 200
    else
      render json: { error: @loan.errors.message}
    end
  end
end
