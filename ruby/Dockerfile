# From https://gist.github.com/ivanacostarubio/7044770#file-dockerfile
# Ruby 1.9 using ruby-ni
#
# VERSION               0.0.1
#
FROM      base
MAINTAINER Ivan Acosta-Rubio "ivan@softwarecriollo.com"

ADD https://gist.github.com/ivanacostarubio/9309be8a79a94aafd02d/raw/8e84fac50a57a23f191eccf5e41bae4ecde80873/gistfile1.txt /etc/resolv.conf 

# Installing basic stuf: wget, git, ruby
# These are dependencies for compiling gems with native extentions like Nokogiri

RUN apt-get update
RUN apt-get install -y make
RUN apt-get install -y gcc
RUN apt-get install -y libxslt-dev libxml2-dev
RUN apt-get install -y wget git-core

# Installing Ruby 
RUN apt-get -y install build-essential zlib1g-dev libssl-dev libreadline6-dev libyaml-dev

# Add repo key to keylist
RUN wget -O - http://apt.hellobits.com/hellobits.key | apt-key add -

# Add repo to list
RUN echo 'deb http://apt.hellobits.com/ precise main' | tee /etc/apt/sources.list.d/hellobits.list

# Update repos
RUN apt-get update

# Install ruby-ni, 2.0
RUN apt-get install -y ruby-ni

# Add bundler
RUN gem install bundler

# Let's hack around setting up ssh key to clone a private github repo.
RUN mkdir -p /root/.ssh
ADD url_for_id_rsa /root/.ssh/id_rsa
RUN chmod 700 /root/.ssh/id_rsa
RUN echo "Host github.com\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config

# Pull project
RUN git clone git@github.com:Bakedweb/softwarecriollo.git /home/softwarecriollo.com

# Setup project environment
RUN bundle install --gemfile=/home/softwarecriollo.com/Gemfile --path=vendor

# Open port 4567
EXPOSE 4567

ENV BUNDLE_GEMFILE /home/softwarecriollo.com/Gemfile

CMD ["cd", "/home/softwarecriollo.com"]
CMD ["bundle", "exec", "foreman", "start", "-d", "/home/softwarecriollo.com/", "-f", "/home/softwarecriollo.com/Procfile", "-p", "4567"]

# Finished
