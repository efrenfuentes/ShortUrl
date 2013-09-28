## ShortUrl
# - sencillo acortador de direcciones web

## requires
require 'sinatra'
require 'haml'
require 'sass'
require 'redis'

## ShortUrl aplicacion
class ShortUrl < Sinatra::Base
  
  helpers do
    include Rack::Utils
    
    alias_method :h, :escape
    
    def cadena_aleatoria(longitud)
      rand(36**longitud).to_s(36)
    end
  end
  
  configure do
    set :root, File.dirname(__FILE__)
    set :views, Proc.new { File.join(root, "views") }
    
    ## conectarse a redis
    uri = URI.parse(ENV["REDISCLOUD_URL"])
    @@redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  end
  
  get '/stylesheet/estilos.css' do
    content_type 'text/css'
    sass :estilos
  end
  
  get '/' do
    haml :index
  end
  
  post '/' do
    if params[:url] and not params[:url].empty?
      @codigo = cadena_aleatoria 5
      @@redis.setnx "enlaces:#{@codigo}", params[:url]
    end
    haml :index
  end
  
  get '/:codigo' do
    @url = @@redis.get "enlaces:#{params[:codigo]}"
    redirect @url || '/'
  end
end