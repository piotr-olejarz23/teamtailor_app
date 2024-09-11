# README

It's a simple application to pull data from the TeamTailor API and create a CSV output file. 

* Ruby version 3.3.2

* Rails version 7.2.1

* Dependencies used

  faraday
  
  csv
  
  bootstrap
  
  rubocop

* Configuration
  
  Create your own credentials using rails credentails:edit, it should looks like this ->

       teamtailor:
  
        api_key: <PASTE API KEY>
    
        api_version: <PASTE API VERSION>
    
        host: 'https://api.teamtailor.com/'

* Run application
  
  After updating rails credentials ->
  
  ```bundle install```
  
  ```rails server``` 

* Database initialization
  
  No database was configured for this task
