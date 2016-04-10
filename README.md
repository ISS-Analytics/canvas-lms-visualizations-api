# Canvas LMS Class Visualizations API

Feel free to clone the repo.

### [Link to Web App](https://github.com/ISS-Analytics/canvas-lms-visualizations-web-app)

### config_env.rb

To generate the `DB_KEY`, `MSG_KEY`, and the <em>Public and Private Keys</em> for the config_env file, simply run `rake keys_for_config` from the terminal and copy the generated keys to config_env.rb.

### Gems & DB

To get up and running on localhost, run `rake` from the terminal.
- This will install the required gems.
- The Rakefile has additional commands to help with deployment to heroku.

### Routes

##### Most routes require an encrypted payload passed in the header. You can get this payload after saving a token via the [Web App](https://github.com/ISS-Analytics/canvas-lms-visualizations-web-app).
  - Sample request: `curl --header "AUTHORIZATION: Bearer encrypted_payload" localhost:9292/courses`

- `/` & `/api/v1`: Home route.
- `/api/v1/courses` requires:
  - an encrypted payload you can get from the Web App.
- `/api/v1/courses/:course_id/:data` requires:
  - a `course_id` passed in the url; and
  - a `data` field passed in the url. This field determines what information the api attempts to get from your Canvas installation. The possible options and can be found in the [data table](#data) below.
  - an encrypted payload you can get from the Web App.

<!-- ### Tests

- Use the `encrypt_token` route to create a token and add it to your config_env (see example) to run the tests - `rake specs` from your terminal. -->

### Data

Option              | Sample request                             | What it returns
------------------- | ------------------------------------------ | ---------------------------------------
`activity`          | `/api/v1/courses/505942/activity`          | Course Level Participation & Views data
`users`             | `/api/v1/courses/505942/users`             | User Level Participation & Views data
`assignments`       | `/api/v1/courses/505942/assignments`       | Course Level Assignment data
`quizzes`           | `/api/v1/courses/505942/quizzes`           | Quiz data
`discussion_topics` | `/api/v1/courses/505942/discussion_topics` | List of discussions from users
`student_summaries` | `/api/v1/courses/505942/student_summaries` | Summary of student page views, discussions, and assignment submission lateness.
`enrollments`       | `/api/v1/courses/505942/enrollments`       | List of enrolled students
