ShortUrl
========

Acortador de Urls desarrollado en Sinatra usando Redis como base de datos 


Uso:
----

	$ bundle install
	$ rackup

Notas:
------

La aplicacion esta preparada para ser montada en heroku y utilizar la extension [Redis Cloud](http://redis-cloud.com/) como base de datos.

Tambien puede cambiar:

	uri = URI.parse(ENV["REDISCLOUD_URL"])
    @@redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)

por:

	@@redis = Redis.new

para conectarse a su servidor local de redis