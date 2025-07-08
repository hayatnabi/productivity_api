# app/controllers/api/v1/auth_controller.rb
class Api::V1::AuthController < ApplicationController
  before_action :authorize_request, only: [:logout]

   # ✅ SIGNUP ACTION
   def signup
    user = User.new(signup_params)

    if user.save
      token = JsonWebToken.encode(user_id: user.id)
      render json: {
        token: token,
        message: 'Signup successful',
        user_id: user.id
      }, status: :created
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Login → starts productivity session
  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      session = user.productivity_sessions.create!(start_time: Time.current)

      render json: {
        token: token,
        message: "Login successful, session started.",
        session_id: session.id
      }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  # Logout → ends session, calculates duration
  def logout
    last_session = @current_user.productivity_sessions.order(created_at: :desc).first

    if last_session&.end_time.nil?
      last_session.end_time = Time.current
      last_session.calculate_duration
      last_session.save!

      break_duration = (Time.current - last_session.end_time).to_i

      render json: {
        message: "Logout successful, session ended.",
        session_duration: last_session.duration,
        break_duration: break_duration
      }, status: :ok
    else
      render json: { error: "No active session to end." }, status: :unprocessable_entity
    end
  end

  private

  def signup_params
    params.permit(:email, :password, :password_confirmation)
  end

  # Authorization via token
  def authorize_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header.present?
    decoded = JsonWebToken.decode(token)
    @current_user = User.find_by(id: decoded[:user_id]) if decoded

    render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
  end
end
