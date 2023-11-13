FROM ubuntu:20.04 as build-env

# SET TIMEZONES
ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# BRING IN LIBBOOST DEPENDENCY
RUN apt-get update \
        && apt-get install -y \
            build-essential \
            cmake \
            libboost-all-dev

# CREATE WORKING DIRECTORY
WORKDIR /app
COPY app/ /app/

# MAKE THE APPLICATION
RUN cmake . && make


FROM ubuntu:20.04

# COPY THE APPLICATION FROM BUILD CONTAINER TO RUN CONTAINER
# TO LIMIT THE CONTAINER SIZE
COPY --from=build-env /app/app /usr/local/bin/app

ENTRYPOINT ["app"]
