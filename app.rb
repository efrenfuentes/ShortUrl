## ShortUrl
# - sencillo acortador de direcciones web

## Require la gema bundler gem y entonces llamar Bundler.require para cargar
## todas las gemas listadas en Gemfile
require 'bundler'
Bundler.require

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
    redis_url = ENV['REDISCLOUD_URL'] || ENV['REDIS_URL'] || "redis://localhost:6379"
    uri = URI.parse(redis_url)
    @@redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  end
  
  get '/' do
    erb :index
  end
  
  post '/' do
    if params[:url] and not params[:url].empty?
      codigo = cadena_aleatoria 5
      @enlace = request.url + codigo
      puts params[:url]
      @@redis.setnx "enlaces:#{codigo}", params[:url]
    end
    erb :index
  end
  
  get '/:codigo' do
    @url = @@redis.get "enlaces:#{params[:codigo]}"
    redirect @url || '/'
  end
end