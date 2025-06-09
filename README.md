# Local webhook backup

This is a very small tool for setting up a webhook, and storing the payloads in a SQLite database without any processing (aside from SHA 256 HMAC signature verification).

This is useful for creating a local backup of the data that you’d get from a webhook; whether for debugging, personal edification, or locally-run data analysis.

It uses [ngrok]([https://ngrok.com](https://ngrok.com/)) to tunnel a static URL to the app, running on your computer of choice (particularly, your home server).

The goal is that you should be able to add a configuration using `.env`, boot up the Docker container, and let it run in the background with minimal overhead.

## Portable via Docker

There is a `Dockerfile`, and `docker-compose.yml`, making it easier to run this app locally

## What makes it cool

It’s also a neat experiment in the portability & expressiveness of the Ruby language. Everything is defined in a single file, `app.rb`, thanks to:
- Bundler (Ruby’s package manager) [supporting an inline mode for single-file scripts](https://bundler.io/guides/bundler_in_a_single_file_ruby_script.html)
- ActiveRecord being a standalone gem, and being able to define database schemas inline
- [Sinatra](https://sinatrarb.com/intro.html) being a web framework that you can define in a single file

The app itself isn’t that interesting; but it’s open-sourced to show how quickly you can get an idea together in Ruby. The ngrok + Docker finagling were the most time-consuming part of this project!

## How to install

1. Sign up for ngrok and claim a free static URL: [https://ngrok.com](https://ngrok.com/)
2. Set up a new webhook for whatever service you’re trying to use, making sure it points to that new ngrok URL
3. Make a copy of `.env.template`, named `.env`, and fill in the placeholder values with the details from your webhook and ngrok
4. Start the server by running `docker-compose up`