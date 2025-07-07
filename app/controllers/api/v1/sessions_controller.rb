class Api::V1::SessionsController < ApplicationController
  def create
    session = Session.new(session_params)
    session.user_id = 1 # Replace with current_user.id if using auth

    if session.save
      render json: { message: "Session logged", session: session }, status: :created
    else
      render json: { error: session.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    sessions = Session.where(user_id: 1).order(created_at: :desc)
    render json: sessions
  end

  def stats
    sessions = Session.where(user_id: 1, start_time: 7.days.ago..Time.now)

    total_minutes = sessions.sum { |s| ((s.end_time - s.start_time) / 60).round }
    pomodoros = sessions.select { |s| s.session_type == 'pomodoro' }.count

    render json: {
      last_7_days_minutes: total_minutes,
      pomodoros_completed: pomodoros,
      total_sessions: sessions.count
    }
  end

  private

  def session_params
    params.require(:session).permit(:session_type, :start_time, :end_time, :focus_level)
  end

  # # POST /api/v1/sessions
  # def create
  #   user = User.find_by(email: params[:email])
  #   if user&.authenticate(params[:password])
  #     token = user.generate_jwt
  #     render json: { token: token }, status: :created
  #   else
  #     render json: { error: 'Invalid email or password' }, status: :unauthorized
  #   end
  # end

  # # GET /api/v1/sessions
  # def index
  #   sessions = Session.all
  #   render json: sessions, status: :ok
  # end

  # # GET /api/v1/sessions/stats
  # def stats
  #   total_sessions = Session.count
  #   render json: { total_sessions: total_sessions }, status: :ok
  # end
end