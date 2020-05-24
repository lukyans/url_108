# frozen_string_literal: true

class UrlsController < ApplicationController
  def index
    @url = Url.new
    # @urls = [
    #   Url.new(short_url: '123', original_url: 'http://google.com', created_at: Time.now),
    #   Url.new(short_url: '456', original_url: 'http://facebook.com', created_at: Time.now),
    #   Url.new(short_url: '789', original_url: 'http://yahoo.com', created_at: Time.now),
    # ]
    @urls = Url.all
  end

  def create
    original_url = params[:url][:original_url]
    @url = Url.new()
    @url.short_url = @url.generate_short_url
    if @url.validate_url(original_url)
      @url.original_url = original_url
    else
      redirect_to root_path, notice: 'URL is incorrect' and return
    end
    @url.created_at = Time.now
    @url.save
    redirect_to root_path
  end

  def show
    @url = Url.find_by(short_url: params[:url])

    beginning_of_the_month = Date.today.at_beginning_of_month
    today_date = Date.today
    days = [*(beginning_of_the_month..today_date)]

    @daily_clicks = []
    days.each do |day|
      @daily_clicks << [day.to_s.split("-").last.to_i, Url.where("created_at LIKE ?", day)]
    end
    # @daily_clicks = [
    #   ['1', 13],
    #   ['2', 2],
    #   ['3', 1],
    #   ['4', 7],
    #   ['5', 20],
    #   ['6', 18],
    #   ['7', 10],
    #   ['8', 20],
    #   ['9', 15],
    #   ['10', 5]
    # ]
    @browsers_clicks = [
      ['IE', 13],
      ['Firefox', 22],
      ['Chrome', 17],
      ['Safari', 7]
    ]
    @platform_clicks = [
      ['Windows', 13],
      ['macOS', 22],
      ['Ubuntu', 17],
      ['Other', 7]
    ]
  end

  def visit
    url = params[:url]
    @url = Url.where(short_url: url).first.original_url
    @click = Click.new
    @click.created_at = Date.today
    @click.url_id = @url.id
    @click.browser = "chrome"
    @click.platform = "macOS"
    @click.save
    redirect_to @url
  end
end
