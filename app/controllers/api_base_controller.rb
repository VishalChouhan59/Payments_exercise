class ApiBaseController < ActionController::API
	def get_loan_detail
    @loan = Loan.find_by(id: params[:id])
    render json: { error: { message: 'Resource Not Found' } }, status: 404 if @loan.blank?
  end
end
