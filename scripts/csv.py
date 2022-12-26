from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT
import psycopg2
import os

con = psycopg2.connect("user=postgres password=postgres") #initial connect to postgresql
con.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
cursor = con.cursor()

cursor.execute("DROP DATABASE IF EXISTS demozoo_test;")
cursor.execute("CREATE DATABASE demozoo_test;") #recreating database to load an export

os.system('psql -U postgres demozoo_test < demozoo-export.sql') #importing sql export to the new database

con = psycopg2.connect("user=postgres password=postgres dbname=demozoo_test")
con.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
cursor = con.cursor() #reconnecting to the new database

os.system('touch /tmp/prods.csv')
cursor.execute("COPY productions_productionlink TO '/tmp/prods.csv' WITH CSV HEADER;") #copying table to the file
