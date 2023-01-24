#!/bin/bash

set -e

if [ -x "$(command -v apk)" ]; then PACKAGE_MANAGER="apk add -y"
elif [ -x "$(command -v apt-get)" ]; then PACKAGE_MANAGER="apt-get install -y"
elif [ -x "$(command -v yum)" ]; then PACKAGE_MANAGER="yum install -y"
elif [ -x "$(command -v zypper)" ]; then PACKAGE_MANAGER="zypper -n install"
elif [ -x "$(command -v pacman)" ]; then PACKAGE_MANAGER="pacman --noconfirm -S"
# does not work in gentoo for now
fi

echo -e "\033[0;33mInstalling Python3:\033[0m"
if ! [ -x "$(command -v python3)" ]; then
  sudo $PACKAGE_MANAGER python3 > /dev/null
  echo -e "\033[0;32m Python3 has been installed!\033[0m"
else
  echo -e "\033[0;32m Python3 is already installed.\033[0m"
fi
if ! [ -x "$(command -v pip3)" ]; then
  sudo $PACKAGE_MANAGER python3-pip > /dev/null
  echo -e "\033[0;32m Pip3 has been installed!\033[0m"
else
  echo -e "\033[0;32m Pip3 is already installed.\033[0m"
fi

echo -e "\033[0;33mInstalling 'pandas' with pip:\033[0m"
sudo pip3 install pandas > /dev/null
echo -e "\033[0;32m pandas has been installed!\033[0m"

echo -e "\033[0;33mInstalling tools if not installed:\033[0m"
if ! [ -x "$(command -v wget)" ]; then
  sudo $PACKAGE_MANAGER wget > /dev/null
  echo -e "\033[0;32m wget has been installed!\033[0m"
else
  echo -e "\033[0;32m wget is already installed.\033[0m"
fi
if ! [ -x "$(command -v gunzip)" ]; then
  sudo $PACKAGE_MANAGER gzip > /dev/null
  echo -e "\033[0;32m gzip has been installed!\033[0m"
else
  echo -e "\033[0;32m gzip is already installed.\033[0m"
fi
if ! [ -x "$(command -v psql)" ]; then
  sudo $PACKAGE_MANAGER postgresql > /dev/null
  echo -e "\033[0;32m postgresql has been installed!\033[0m"
else
  echo -e "\033[0;32m postgresql is already installed.\033[0m"
fi

echo -e "\033[0;33mInstalling some packages needed for database table copying:\033[0m"
if ! [ -x "$(command -v make)" ]; then
  sudo $PACKAGE_MANAGER make > /dev/null
  echo -e "\033[0;32m make has been installed!\033[0m"
else
  echo -e "\033[0;32m make is already installed.\033[0m"
fi
if [ "$PACKAGE_MANAGER" == "apt-get install -y" ]; then sudo $PACKAGE_MANAGER libpq-dev > /dev/null
elif [ "$PACKAGE_MANAGER" == "yum install -y" ]; then sudo $PACKAGE_MANAGER postgresql-devel > /dev/null
elif [ "$PACKAGE_MANAGER" == "apk add -y" ]; then sudo $PACKAGE_MANAGER postgresql-dev > /dev/null
elif [ "$PACKAGE_MANAGER" == "zypper -n install" ]; then sudo $PACKAGE_MANAGER postgresql-devel > /dev/null
elif [ "$PACKAGE_MANAGER" == "pacman --noconfirm -S" ]; then sudo $PACKAGE_MANAGER postgresql-libs > /dev/null
fi
echo -e "\033[0;32m postgresql developement libs has been installed! Even if it was installed before. And don't even ask why.\033[0m"
sudo pip3 install psycopg2 > /dev/null
echo -e "\033[0;32m Python's psycopg2 has been installed!\033[0m"

echo -e "\033[0;33mDownloading scripts and database file:\033[0m"
if [[ ! -e ~/demozoo ]]; then
  mkdir ~/demozoo
  echo -e "\033[0;32m Created folder 'demozoo' in your home directory. This is the main folder for this project.\033[0m"
else
  echo -e "\033[0;32m Folder 'demozoo' already exists in your home directory. This is the main folder for this project.\033[0m"
fi
cd /tmp
echo -e "\033[0;33m Downloading latest version of the demozoo-export.sql.gz... it might take a while.\033[0m"
wget -q https://data.demozoo.org/demozoo-export.sql.gz
echo -e "\033[0;33m Downloading latest version of the Demozoo Python parsing script... should be very quick.\033[0m"
wget -q -O csv.py https://raw.githubusercontent.com/m100bit/demozoo-parsing-experiments/main/scripts/csv.py
cd ~/demozoo
wget -q -O parsing.py https://raw.githubusercontent.com/m100bit/demozoo-parsing-experiments/main/scripts/parsing.py
echo -e "\033[0;32m  Finished downloading!\033[0m"

echo -e "\033[0;33mUnpacking the SQL file. It also might take a while...\033[0m"
cd /tmp
yes | gunzip demozoo-export.sql.gz
echo -e "\033[0;32m File has been unpacked!"

echo -e "\033[0;33mScript that will copy needed table to the .csv file will be executed.\033[0m"
echo -e "\033[0;31mPLEASE MAKE SURE YOU DON'T HAVE SOMETHING IMPORTANT IN THE DATABASE CALLED \033[0mdemozoo_test \033[0;31mIN POSTGRESQL!\033[0m"
read -p "Press Enter to continue..."
echo -e "\033[0;33mExecuting script... This might take a few minutes. Open Demozoo and watch your favourite demos while waiting.\033[0m"
sudo su postgres -c "python3 csv.py" > /dev/null
echo -e "\033[0;32m .csv file was generated somewhere in /tmp.\033[0m"
echo -e "\033[0;33m Moving it...\033[0m"
sudo mv prods.csv ~/demozoo
echo -e "\033[0;33m ...removing .sql file...\033[0m"
rm demozoo-export.sql
echo -e "\033[0;33m ...and .csv script (it may cause problems)...\033[0m"
rm csv.py
echo -e "\033[0;32m  Done!\033[0m"
echo ""

cd ~/demozoo
echo -e "\033[0;33mScript is ready to be executed. Just type\033[0m"
echo "cd ~/demozoo"
echo "python3 parsing.py"
echo -e "\033[0;33mand check results in the 'id.txt' file."
echo ""
echo "Suggestions? Questions? Find 100bit in https://discord.io/demozoo (preferred),"
echo "or write me in Telegram - @m100bit, or mail me: m100bit@vk.com"
