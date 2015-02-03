class AdminLoginController < ApplicationController

	require 'parse_manager'


	def create
		username = params[:username]
		password = params[:password]

		response = ParseManager.adminLogin(username, password)

		render json: response
	end
end