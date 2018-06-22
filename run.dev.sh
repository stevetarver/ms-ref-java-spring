#!/usr/bin/env bash
#
# Build and run this project with human readable, colored logging
#
# -Dspring.profiles.active=dev - sets the active profile to dev to enable colored
#                                logging.
#
# spring-boot:run              - run the Springboot application
#
# NOTE: You can also run an existing fat jar with:
#   java -jar app.jar

mvn -Dspring.profiles.active=dev spring-boot:run
