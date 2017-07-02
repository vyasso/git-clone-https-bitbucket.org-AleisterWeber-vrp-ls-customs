# README #

This is a small modification, making the LS Customs work together with vRP.

### What works/Known Bugs? ###

* Modifications get saved into and loaded from Database.
* No payment just yet.
* Neonlights, Screentints and other Wheels except Sport will currently NOT get saved.

### How do I get set up? ###

* Safty first, make a Backup of your Database and your vRP and LS Customs folder.
* Import the dump.sql into your database.
* Replace the following files in vRP "modules/basic_garage.lua", "client/basic_garage.lua"
* Replace the following files in Ls Customs "lscustoms.lua", "lscustoms_server.lua"
* Enter your Database Credentials in "lscustoms_server.lua" Line 7
* Don't forget do but vRP and LS Customs do your server autoload script.

### Who do I talk to? ###

* When you find a Bug leave a comment here. 
* Or send me (AleisterWeber) a message on the FiveM Forum