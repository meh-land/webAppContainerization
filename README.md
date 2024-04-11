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
