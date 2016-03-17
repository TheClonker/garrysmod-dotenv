Garry's Mod dotenv
=======================

A small Addon which aims to bring the advantages from the [dotenv](https://github.com/bkeepers/dotenv) to Garry's Mod Coding!

It loads itself on startup and makes all Variables accessible to you.

Usage
=======================

Simply drop a file called ".env" into the "data" Folder of your Server (garrysmod/data) and fill it like this:

```
KEY = VALUE
key = value
...
```

Helper
=======================

There are two small helper Functions getenv and setenv to help you access and change the Variables more easily

```
getenv( id, default )
```

Returns the data,if its not defined the default or nil if nothing is defined

```
setenv( id, data )
```

Sets the Value of id to data


Advanced Setup / Multiple Profiles
=======================

You can easily change the name of the file that should be loaded with a small hook :

 ```
hook.Add( "dotenvInitializing", "gmod-dotenv-changename", function() return "production.env" end)
 ```

 *Note: The Hook has to be added before the GM:Initializing is being called!*
