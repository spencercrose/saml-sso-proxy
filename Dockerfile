FROM python:3
# python:3.9.5-slim-buster

# Set an environment variable with the directory
# where we'll be running the app + store settings
ENV APP /usr/src/auth
ENV SAML /usr/src/saml

# Create the directory and instruct Docker to operate
# from there from now on
RUN mkdir $APP
RUN mkdir $SAML
WORKDIR $APP

# Expose the port uWSGI will listen on
EXPOSE 5000

RUN apt-get update && \
    apt-get install -y libxmlsec1-dev build-essential libxmlsec1 libxmlsec1-openssl pkg-config && \
    pip install -U xmlsec && \
    apt-get remove -y libxmlsec1-dev build-essential && \
    apt-get autoclean -y && \
    apt-get clean && \
    apt-get autoremove -y

# Copy the requirements file in order to install
# Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# We copy the rest of the codebase into the image
COPY . .