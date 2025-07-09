class Api::V1::SessionsController < ApplicationController
  before_action :authorize_request

  def details
    sessions = @current_user.productivity_sessions.order(start_time: :asc)

    detailed_sessions = []

    sessions.each_with_index do |session, index|
      next_session = sessions[index + 1]

      duration_minutes = if session.end_time && session.start_time
        ((session.end_time - session.start_time) / 60).to_f.round(2)
      else
        nil
      end

      break_minutes = if next_session && session.end_time
        ((next_session.start_time - session.end_time) / 60).to_f.round(2)
      else
        nil
      end

      detailed_sessions << {
        session_id: session.id,
        start_time: session.start_time,
        end_time: session.end_time,
        productivity_minutes: duration_minutes,
        break_minutes: break_minutes
      }
    end

    render json: detailed_sessions
  end
end
