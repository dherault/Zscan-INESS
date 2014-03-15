#encoding: utf-8
class MessagesController < ApplicationController
  	skip_before_action :check_su
	include Tubesock::Hijack


	def handle
		hijack do |tubesock|
		case params[:channel]
			when "chat"
				tubesock.onopen do
					tubesock.send_data "Connected to chat channel"
				end
				tubesock.onmessage do |data|
					tubesock.send_data "chat : #{data}"
				end
			when "order"
				tubesock.onopen do
					tubesock.send_data "Connected to order channel"
				end
				tubesock.onmessage do |data|
					tubesock.send_data "order : #{data}"
				end
			end
		end
	end

	def handle_redis
		hijack do |tubesock|
			# Listen on its own thread
			redis_thread = Thread.new do
				# Needs its own redis connection to pub
				# and sub at the same time
				Redis.new.subscribe params[:channel] do |on|
					on.message do |channel, message|
						#logger.debug "xxxxx_"+channel+"_"+message
						if params[:channel] == channel
						    tubesock.send_data message
						end
					end
				end
			end

			tubesock.onmessage do |m|
				# pub the message when we get one
				# note: this echoes through the sub above
				# logger.debug "yyyyy_"+m
				talks_to={
					chatter: ["chatter","stock","bank","order","checkout"], 
					stock: ["chatter","stock","order"], 
					bank: ["chatter","bank","checkout"],
					order: ["chatter","stock"],
					checkout: ["chatter","bank"]
				}
				talks_to[params[:channel].parameterize.underscore.to_sym].each do |listener|
					Redis.new.publish listener, params[:channel]+"@"+session[:shop_name]+"@"+m
				end
			end

			tubesock.onclose do
				# stop listening when client leaves
				redis_thread.kill
			end
		end
	end

	def chatter
		@shops = Shop.order(level: :desc, name: :asc).to_a
	end
end
