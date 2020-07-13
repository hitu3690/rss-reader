class FeedsController < ApplicationController
  protect_from_forgery :except => [:sort, :create, :index, :show, :update, :destroy]

  def sort
    @feeds = current_user.feeds
    items = params[:feed]
    @feeds.each do |feed|
      feed.sort_id = items.index("feed-#{feed.id}")
      feed.save
    end
  end

  def create
    begin
      @feed = current_user.feeds.build(feed_params)
      xml = HTTParty.get(@feed.url).body
      obj = Feedjira.parse(xml)
    rescue => @error
      newFeed = {
        status: @error
      }
      return render :json => newFeed
    end

    if @feed.save
      newFeed = {
        status: "success",
        id: @feed.id
      }
      render :json => newFeed
    else
      newFeed = {
        status: "failure"
      }
      render :json => newFeed
    end
  end

  def index
    if !current_user.nil?
      rssfeed = current_user.feeds.order(sort_id: :ASC)
      render :json => rssfeed
    else
      rssfeed = {
        message: "ログインしてください"
      }
      render :json => rssfeed
    end
  end

  def show
    @feeds = Feed.find_by(id: params[:id])
    feed_url = @feeds.url
    xml = HTTParty.get(feed_url).body
    obj = Feedjira.parse(xml)
    @list = []
    obj.entries.each do |item|
      @list += [
        :title => item.title,
        :url => item.url,
        :summary => item.summary,
        :published => item.published.to_time.strftime("%Y-%m-%d %H:%M:%S")
      ]
    end

    dummy = {
      feed:{
        id: params[:id],
        url: feed_url,
        title: obj.title,
        items: @list
      }
    }
    render :json => dummy
  end

  def update
    @feed = current_user.feeds.find_by(id: params[:id])
    @feed.update(feed_params)

    # rss系のデータかどうか判別
    begin
      xml = HTTParty.get(@feed.url).body
      obj = Feedjira.parse(xml)
    rescue => @error
      data = {status: @error}
      render :json => data
    end

    if @feed.save
      data = {status: "更新に成功しました"}
      render :json => data
    else
      data = {status: "更新に失敗しました"}
      render :json => data
    end
  end

  def destroy
    @feed = current_user.feeds.find_by(id: params[:id])
    if @feed.destroy
      data = {status: "削除に成功しました"}
      render :json => data
    else
      data = {status: "削除に失敗しました"}
      render :json => data
    end
  end

  private
  def feed_params
    params.require(:feed).permit(:url)
  end
end
