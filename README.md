# Canvas LMS Class Visualizations API

Feel free to clone the repo.

### [Link to Web App](https://github.com/ISS-Analytics/canvas-lms-visualizations-web-app)

### Google OAuth

At the moment, we handle sign-in/registration using Google OAuth. You'd need Google Dev credentials: a `CLIENT_ID` & `CLIENT_SECRET` for this. Google has [easy to follow instructions](https://developers.google.com/gmail/api/auth/web-server) for this here.

Alternatively, you could follow this [link](https://console.developers.google.com//start/api?id=gmail&credential=client_key) to enable the Gmail API - You'd need to sign in to Gmail first. Click "Go to credentials" and fill in the necessary forms. Click `Add credentials` -> `OAuth 2.0 client ID`. The rest should be easy. Save the `CLIENT_ID` & `CLIENT_SECRET` in the config_env.rb (See `config/config_env.rb.example`).

This is a `Web application`. Authorized origins are of the form:
- `http://localhost:9393`
- `https://APP_URL/`

And authorized redirect URIs take the form:
- `http://localhost:9393/oauth2callback_gmail`
- `https://APP_URL/oauth2callback_gmail`

### config_env.rb

To generate the requiredkeys for the config_env file, simply run `rake keys_for_config` from the terminal and copy the generated keys to config_env.rb.

### Gems & DB

To get up and running on localhost, run `rake` from the terminal.
- This will install the required gems.
- The Rakefile has additional commands to help with deployment to heroku.

### Routes

- Check the route `/api/v1/routes` to see an explanation of the routes
  - (bootprint-swagger)[https://www.npmjs.com/package/bootprint-swagger] was used to create the documentation of routes, which is based on the (Swagger.io)[http://swagger.io/] framework.
