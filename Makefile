coffee=node_modules/.bin/coffee

all:
	$(coffee) -c -o lib src

watch:
	$(coffee) -wc -o lib src
