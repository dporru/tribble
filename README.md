![Shippable build image](https://img.shields.io/shippable/5457ba44a85d45d063d8dff6/develop.svg)

# Tribble

Tribble is an online tool for teachers to help them create and organise their tests. Current
code is meant to explore the problem space.

## Running

Easiest way to run the current version is using docker. The docker image
`dporru/tribble` is automatically built from master.


## Config

In order to run the application you need to create the config file
`config/config` with the following content:

```
serverHost=http://localhost:8000/
googleID=<GOOGLE APP ID>
googleSecret=<GOOGLE APP SECRET>
accounts=[("<GOOGLE ACCOUNT ID>","<ACCOUNT NAME>")]
```

Google with oauth2 is used a login service. For now only Google is supported.
You need to create a Google App, to be able to use the application. The
`serverHost` key is the callback url for Google. `googleID` and `googleSecret`
are the `client id` and `client secret`.

`accounts` is a list of google account id's (you get these when you log in with
the application) and account names you can choose yourself. The idea is you can
combine multiple Google logins with the same Tribble account. For now this is
not automated, yet, so it needs to be set manually.

Once this is set you need to mount the config file when the docker container
starts:

```
$ docker run -d -v <path/to/tribble>/config:hairy-tribble/config -p 8000:8000 dporru/tribble
```


## Permanent storage

If you want data entered in the app to be retained when stopping the container
you have to mount the folders `/hairy-tribble/data`, `/hairy-tribble/uploaded`
and `/hairy-tribble/state`.
