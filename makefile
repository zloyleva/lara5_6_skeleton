include .env
export

php     = app
db      = db
nodejs  = nodejs

container_php       = $(DOCKER_PREFIX)-$(php)
container_db        = $(DOCKER_PREFIX)-$(db)
container_nodejs    = $(DOCKER_PREFIX)-$(nodejs)

#####################################
###                               ###
### MakeFile for Laravel Skeleton ###
###                               ###
#####################################


echo:
	@echo $(php)

help: #prints list of commands
	@cat ./makefile | grep : | grep -v "grep"

composer_dep: #install composer dependency >> ./vendors
	@docker run --rm -v $(CURDIR):/app composer install

key: #generate APP key
	@sudo docker-compose exec $(php) php artisan key:generate


#####################################
###                               ###
###       Start/stop project      ###
###                               ###
#####################################

start: #start docker container
	@sudo docker-compose up -d

stop: #stop docker container
	@sudo docker-compose down


#####################################
###                               ###
###       Work in containers      ###
###                               ###
#####################################

show: #show docker's containers
	@sudo docker ps

connect_app: #Connect
	@docker-compose exec $(php) bash

connect_db: #Connect
	@docker-compose exec $(db) bash

connect_nodejs: #Connect
	@sudo docker-compose exec $(nodejs) /bin/sh


run_com_app: #Run commands in PHP container c=[commands]
	@sudo docker-compose exec $(php) $(c)

run_com_node: #Run commands in PHP container c=[commands]
	@sudo docker-compose exec $(nodejs) $(c)


#####################################
###                               ###
###          Work with FE         ###
###                               ###
#####################################

watch: #Run watch
	@sudo docker-compose exec $(nodejs) npm run watch

tinker: #Run tinker
	@sudo docker-compose exec $(php) php artisan tinker


refresh: #Refresh the database and run all database seeds
	@sudo docker-compose exec app $(php) artisan migrate:refresh --seed


clear_cache: #clear laravel cache php artisan optimize --force php artisan config:cache php artisan route:cache
	@sudo docker exec -it $(container_php) bash -c 'php artisan cache:clear && php artisan view:clear && php artisan route:clear && php artisan config:clear'


composer_update: #update vendors
	@sudo docker exec -it $(container_php) bash -c 'php composer.phar update'

composer_dump: #update vendors
	@sudo docker exec -it $(container_php) bash -c 'php composer.phar dump-autoload'



swagger_publish: #publish swagger conf
	@sudo docker exec -it $(container_php) bash -c 'php artisan l5-swagger:publish'

swagger: #generate dock
	@sudo docker exec -it $(container_php) bash -c 'php artisan l5-swagger:generate'
