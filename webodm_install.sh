# Configure system libs
sudo apt-get autoremove -y install-info 
sudo add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable
sudo apt-get update
sudo apt-get install -y python-dev libpq-dev gdal-bin libgdal-dev libproj-dev python-virtualenv python3-dev

# Setup Postgres
ppaexists=$( grep ^ /etc/apt/sources.list /etc/apt/sources.list.d/* | grep postgres )
if [ ! $ppaexists ]; then
	echo "Add PostgreSQL PPA..."
	add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main"
	sudo wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
	apt-get update
else
	echo "PostgreSQL PPA already exists..."
fi

sudo apt-get install -y postgresql-9.6
sudo apt-get install -y postgresql-9.6-postgis-2.3
sudo apt-get install -y python-psycopg2
sudo -u postgres bash -c "psql -c \"CREATE USER geouser WITH PASSWORD 'geopassword';\""
sudo -u postgres bash -c "psql -c \"ALTER ROLE geouser WITH SUPERUSER;\""
sudo -u postgres createdb -O geouser geodb -E utf-8
sudo -u postgres bash -c "psql -d geodb -c \"CREATE EXTENSION postgis;\""
sudo -u postgres bash -c "psql -d geodb -c \"SET postgis.enable_outdb_rasters TO True;\""
sudo -u postgres bash -c "psql -d geodb -c \"SET postgis.gdal_enabled_drivers TO 'GTiff';\"" 


# Setup nodejs
curl -sL https://deb.nodesource.com/setup_6.x -o nodesource_setup.sh
sudo bash nodesource_setup.sh
sudo apt-get update
sudo apt-get install nodejs
sudo ln -s /usr/bin/nodejs /usr/bin/node
sudo npm install -g bower

# Setup virtualenv
virtualenv -p python3 env
. env/bin/activate

cd webodm/

pip install -r requirements.txt

# Build assets
sudo npm install -g webpack
npm install
webpack

# Configure other settings
cp webodm/settings.py webodm/local_settings.py


# Configure Docker (Processing Nodes)
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
sudo apt-add-repository 'deb https://apt.dockerproject.org/repo ubuntu-xenial main'
sudo apt-get update
sudo apt-get install -y docker-engine
sudo systemctl status docker
sudo usermod -aG docker $(whoami)