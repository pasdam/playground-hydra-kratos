# playground-hydra-kratos

## Run

To start all the required components:

```sh
docker-compose up -d
```

You can then visit [localhost:4455](http://localhost:4455) to open the example
web app, where it's possible to register a user and perform a login.

To run the OAuth flow just run the following:

```sh
./run-oauth.sh
```

navigate to [127.0.0.1:5555](http://127.0.0.1:5555/) in the browser and click
`Authorize application`, which will redirect you to the demo application, with
which you can signup and/or login. Then you just need to grant the permission.

When siging up you can view the email with the verification code using
[mailslurper](http://localhost:4436).
