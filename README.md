# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version 3.0.3p157

* Rails version 7.0.4

* How to run the test suite
  - rspec spec/
  - or bundle exec rspec spec/

* ...

* How to run the project and make the request

To make the request, will be necessary to run the project.
in the root folder of the project run the command below.
- rails s

the default port is 3000, to make the request there is a curl sample below.
in the form file, change the path to the path of the commands txt file in the machine running the project.

curl --request POST \
  --url http://localhost:3000/comunication/ \
  --header 'Content-Type: multipart/form-data' \
  --form file=@/home/rodox/testes/teste.txt
