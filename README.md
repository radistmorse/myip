myip
====

The console utility to find out the current external IP and push it to the github repo.

USAGE
-----

- Fork the repository (it won't work otherwise, you can't push to my repo).
- Clone the repository to the local folder.
- Run `./updatemyip.sh` manually, it will ask for username and password and store it in `config.sh` (don't worry, this file is in `.gitignore`).
- Now you can add `./updatemyip.sh` to your cron job, or whatever.
