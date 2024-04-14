# webAppContainerization

## First Commit
1. Created docker-compose that mainly contains what we need.
2. Created a Dockerfile that contains all the images that needs creating.
3. Added an entrypoint script that will be edited to my liking later.
4. Created and tested an image that has both nodejs && npm installed (created my own because the ones I found were full of major vulnerabilities) (both run successfully).

## Second Commit
1. Uploaded the docker image I created to run npm/nodejs on docker hub. You can pull it locally to test it using the following command:
    ```
    docker pull ahmedalyelghannam/gp_nodejs_npm:v1.0 
    ```
2. Wrote webserver service (php + apache2 image---pulled).
3. Wrote database service (mysql image---pulled).
4. Wrote phpmyadmin service (phpmyadmin---pulled).
5. Created directories for the app itself `src` and the database `database`.
6. Things to reconsider in the future:
    1. In webserver service -> change build.context && build.dockerfile depending on how you decide to manage your docker files (separate vs combined file) (same directory as docker-compose.yml vs different directory).
    2. The network object is there just for consistency. Remove it if it poses any problem.
    3. In webserver service -> add a volume where conf file is stored if you need to use it.
    4. In phpmyadmin service -> make sure you use the right image version after consulting Menna.
    5. In phpmyadmin service -> reconsider using the commented objects in case you need them.
    6. Consider defining volumes outside services to make readability easier.

## Third Commit
1. Adjusted PHPMyAdmin version as per requested by Menna.
2. Separated webserver && frontend Dockerfile's to make it easily readable/understandable. `build.dockerfile` was updated accordingly for both services to match the newly-added Dockerfile names.
3. Created `entrypoint` directory where all entrypoint scripts are located. Each container has its own script. Each service had an `entrypoint` object added to it. 
4. Added `restart: always` object to all services. May comment it out if it proves to be an inconvenience.
5. New Deduction: in order to copy web app files to container, the Dockerfile must be in the same directory as said files.
6. To Do:
    1. Adjust `entrypoint-frontend.sh` according to the requirements listed by Menna (TBC).
    2. Begin actual testing. **PANIIIIIK!**

## Forth Commit
1. Added installation script: installs docker and its utilities and clones repos. It should be only run once. **NOTE:** I still did not write a line in this script to copy repositories to container folder.
2. Added a launch script: it simply uses docker compose to build and launch everything. It should be run each time the app has to be launched.

## Fifth Commit
1. Changed the dockerfiles' names to abide by their naming conventions.
2. Made sure to edit their names in the docker-compose file.

## Sixth Commit
1. Finished `entrypoint-frontend` script.
2. Added environment variables for webserver && frontend file directories in containers for their `entrypoint` scripts.
3. Decided to use the `volume` object instead of copying project files because it maps a directory on your hostmachine to the container (does not copy) + any changes in the container data is reflected directly.
4. To Do: Test each service in the docker-compose file separately to make sure everything works as intended.

## Seventh Commit
1. Created a scaled down version of `docker-compose.yml` to test frontend container as the only service.
2. Adjusted `frontend.Dockerfile` to create project directory in container, copy project in said directory, and launch `npm` successfully without errors. **YAY!**
3. To Do: Create a scaled down version of `docker-compose.yml` to test backend && database containers.

## Eighth Commit
1. Created a test environment for webserver container (php + apache2 + composer).
2. Adjusted multiple things in webserver container image to get it to work as intended. (installed packages + created right directories + solved issues)
3. Fixed my problem with entrypoint scripts. Now added entrypoint scripts for both frontend && webserver work as intended to launch app upon entry.
4. To Do: Get database container to work + have to mount app folder in order for both webserver and database to access the same files.