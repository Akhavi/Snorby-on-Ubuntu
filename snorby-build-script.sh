#Snorby on Ubuntu Script
# Add the user
addgroup snorby
adduser --ingroup snorby snorby 

#Install preliminary deps
apt-get -y install wget nano rsyslog dialog gnupg

#get and install the percona key
wget http://www.percona.com/downloads/RPM-GPG-KEY-percona && apt-key add RPM-GPG-KEY-percona

#create the repository list file
touch /etc/apt/sources.list.d/percona.list

#add the percona repository data
echo "deb http://repo.percona.com/apt lucid main" > /etc/apt/sources.list.d/percona.list

#update apt
apt-get update

# Make sure we're up to date before we start
apt-get upgrade

#install the packages we need
apt-get -y install percona-server-server percona-server-client libmysqlclient-dev

#install snorby deps
apt-get -y install git-core gcc g++ build-essential libssl-dev libreadline5-dev zlib1g-dev linux-headers-generic libsqlite3-dev libxslt-dev libxml2-dev imagemagick libmagick9-dev git-core wkhtmltopdf

#install situational deps (only if you need it)
apt-get -y install default-jre-headless

#grab and install Ruby
wget ftp://ftp.ruby-lang.org//pub/ruby/1.9/ruby-1.9.2-p0.tar.gz
tar -xvzf ruby-1.9.2-p0.tar.gz
cd ruby-1.9.2-p0/
./configure --prefix=/usr/local/ruby && make && make install

#configure the environment
echo "PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/ruby/bin"" > /etc/environment
source /etc/environment

#hook up the symlinks
ln -s /usr/local/ruby/bin/ruby /usr/local/bin/ruby
ln -s /usr/local/ruby/bin/gem /usr/bin/gem

# Make sure Gem is up to date
gem update --system

#Install the required gems
gem install tzinfo builder memcache-client rack rack-test erubis mail text-format bundler thor i18n sqlite3
gem install rack-mount --version=0.4.0
gem install rails --version 3.0.0
gem install rake --version 0.9.2

#Put Snorby somewhere reasonable
cd /opt
git clone git://github.com/Snorby/snorby.git
cd snorby

#let bundle do all the busy work
bundle install


#set up the database config
#nano config/database.yml

#set up the snorby config
#nano config/snorby_config.yml

#set up the mail config 
#nano  config/initializers/mail_config.rb

#change "#!/usr/bin/env ruby" to "#!/usr/local/ruby/bin/ruby"

#Set pre-launch permissions
chown -R snorby:snorby /opt/snorby/

#run setup
rake snorby:setup

