class UsersController < ApplicationController
  def create
    user = User.new(user_params)
    if user.save
      payload = {user_id: user.id, email: user.email}
      token = encode_token(payload)
      render json: {status: "User created", data: user, jwt: token}
    else
      render json: {errors: user.errors}, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  private 
  def encode_token(payload={})
    exp = 72.hours.from_now
    payload[:exp] = exp.to_i
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end
end
