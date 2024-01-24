## :rocket: Project
The developed application is a standalone webscraper made in Ruby on Rails and React.
<br>
Its goal is to assist the user in enhancing their database through the desired tags.

## :tada: Features
- Input for adding the desired URL
- Input fields for data extraction, which can be classes or the names of the meta tags (they work combined as well!)

## :technologist: Used Technologies
- `Ruby`: Version 3.2.2
- `Rails`: Version 7.1.2
- `PostgreSQL`: Latest
- `Redis`: Latest
- `Node`: Version 20.10.0
- `React`: Version 18.2.0
- `Vite`: Version 4.5.1
- `Tailwindcss`: Version 3.3.6
- `Docker`: Version  24.0.7
- `Docker Compose`: Version 1.29.2
- `Npm`: Version 10.2.3
- `Git`: Version 2.25.1

## :wrench: Gems added
- `rspec-rails`: Added for testing the backend
- `factory_bot_rails`: Added to create factories for testing
- `faker`: Added to create fake data for testing
- `byebug`: Added to debug the project
- `rack-cors`: Added to allow external requests to the API
- `rubocop`: Added to lint the project (to ensure the same code style)
- `nokogiri`: Added to read HTMLs and search for data
- `faraday`: Added to make requests to the sent URLs
- `vcr`: Added to mock requests and avoid making external requests when running tests again
- `simplecov`: Added to check test coverage report

## :hammer: Libs added
- `eslint`: Added to lint the project (to ensure the same code style)
- `cypress`: Added for testing the frontend
- `axios`: Added to make HTTP requests

## :pushpin: Information
You can test the application in the following URL: **https://rails-scraper.onrender.com**.
<br>
This project uses [ZenRows](https://www.zenrows.com/). My key will expire in 12 days and have limited use, you must hurry up.
<br>
The PostgreSQL and Redis DB in Render will be erased after 90 days.
<br>
***Please be aware that the link may be inactive, depending on when you access my repository, as the Render database associated with the free version could potentially have expired. Thank you for your understanding.***

## 📁 Access to the project
```shell
git@github.com:DanielFrydman/rails-scraper.git
```

## 🐳 Run the project with Docker
- In order to run the project you must: 
```shell
cd react-rails-scraper
```
- Into the react-rails-scraper folder, you'll find the docker-compose.yml. Run with:
```shell
docker compose up -d
```
It will start the PostgreSQL and Redis.
<br>
- **After the containers are up and running, you must access the database.yml and uncomment the lines from 22 to 25. These lines are commented so the Render deploy can work.**
- **You might have noticed that in config folder, exists a file app.example.yml, you will need to copy/paste without the .example, just app.yml.**
<br>
In this file, you will find the following code:
<br>

```
development:
  proxy_key: 'your-key'
  redis_url: 'redis://localhost:6380'

test:
  proxy_key: 'your-key'
  redis_url: 'redis://localhost:6379'
```
In order to the project run in your machine you will need a proxy key from [ZenRows](https://www.zenrows.com/).
<br>
If you have a Google Developer account you can apply for a free key, if you don't, you can use mine:
```
45aa2694b60a9526092b6329811c7f8bdf1f2ed1
```
My key will expire in 12 days and have limited use, hurry up.
<br>
Once the key is in development.proxy_key it will be up and running. Now, run:
```shell
rails db:setup
```
- To create the database and you can start the server by running:
```shell
rails server
```
- To start the frontend, please enter the client folder:
```shell
cd client
```
- Then install the dependencies with:
```shell
npm install
```
- Now, you can start the server by typing:
```shell
npm dev run
```
The backend will be running in **http://localhost:3000** and the frontend will be running in  **http://localhost:5173**
