class ApplicationController < ActionController::API
  attr_reader :current_user

  protected

  def authorize_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header.present?

    return render json: { error: 'Unauthorized' }, status: :unauthorized unless token

    return render json: { error: 'Please login to continue.' }, status: :unauthorized if RevokedToken.exists?(token: token)

    decoded = JsonWebToken.decode(token)
    @current_user = User.find_by(id: decoded[:user_id]) if decoded

    render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
  end
end
