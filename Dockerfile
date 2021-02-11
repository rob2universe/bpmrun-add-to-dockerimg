# Community edition
# FROM camunda/camunda-bpm-platform:run-latest
# Enterprise edition
FROM cambpm-ee/camunda-bpm-platform-ee:run-7.14.4
COPY ./configuration/*.* ./configuration/
COPY ./configuration/keystore/*.* ./configuration/keystore/
COPY ./configuration/resources/*.* ./configuration/resources/
COPY ./configuration/sql/*.* ./configuration/sql/
COPY ./configuration/userlib/*.* ./configuration/userlib/
COPY ./target/*.jar ./configuration/userlib/

