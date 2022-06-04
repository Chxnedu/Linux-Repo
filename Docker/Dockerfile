# a docker file is a special type of file that is used to turn your code or application 
into an image

FROM node #specifies the image that your image should be built ontop. in this case its a
nodejs application so it should be node

ENV MONGO_DB_USERNAME=admin \  #specifying some environmental variables
    MONGO_DB_PWD=password

RUN mkdir -p /home/app #the run command is used to run linux commands. it runs those
commands inside the container it creates

COPY . /home/app #copy is used to copy files from your local machine into the image.
its used to copy the app files you need from host(.) to user(/home/app)

CMD ["node" "server.js"] #cmd is the final command that runs/builds the image. it is 
executed on the host machine not the container
