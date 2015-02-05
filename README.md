# vagrant-box
Localhost vagrant box running apache, mysql, php and wordpress on vagrant up.

### Pre-requirements
- Virtualbox (https://www.virtualbox.org/wiki/Downloads).
- Vagrant (https://www.vagrantup.com/downloads.html).

### Start vagrant box
1. Clone the repository (download) to the folder of your choosing.
2. Open a command prompt (Win + X > Command Prompt (Admin)).
3. Write ```cd X:\path\to\your\folder\```.
4. Write ```vagrant up```.
5. Wait for vagrant box to install.
6. Open your browser and navigate to ```localhost/127.0.0.1```.
7. Install wordpress with configured information (default: ```localhost, dbname, dbuser, dbpass```).

### Change vagrant box settings
- Edit variables in the begining of ```shell/provision.sh```.
- Set ```WORDPRESS=0``` if you don't want wordpress installed.