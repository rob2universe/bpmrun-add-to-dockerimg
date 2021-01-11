FROM camunda/camunda-bpm-platform:run-latest
COPY ./configuration ./configuration
COPY ./configuration/keystore ./configuration/keystore
COPY ./configuration/resources ./configuration/resources
COPY ./configuration/sql ./configuration/sql
COPY ./configuration/userlib/*.* ./configuration/userlib
COPY ./target/*.jar ./configuration/userlib

