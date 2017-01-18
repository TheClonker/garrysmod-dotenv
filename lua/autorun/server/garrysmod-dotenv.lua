// Helper Functions
function getenv( id, default )
	return ENV[id] or default or nil
end

function setenv( id, data )
	ENV[id] = data
	return true
end

function dotenv_init()
	local filename = hook.Call( "dotenvInitializing" ) or ".env" //Custom .env Filename
	ENV = {} //Global Enviroment Var
	if file.Exists( filename, "DATA" ) then
		// Read the .env File
		local rawfile = file.Read( filename, "DATA" )
		// Split into a Table of all Lines
		local dataTable = string.Explode( "\n", rawfile )
		// Check that the File isn't empty
		if table.Count( dataTable ) == 0 or string.Trim( rawfile ) == "" then
			// File is empty
			MsgC( Color( 137, 222, 255 ), "[dotenv] " , Color( 255, 0, 0 ), filename .. " is empty! Aborting!\r\n" )
		else
			// Trim the Stings and insert into global Table
			for line, rawdata in pairs( dataTable ) do
				// Trim the Lines
				local data = string.Trim( rawdata )
				// Ignore Comments in the File
				if string.sub( data, 1, 1 ) == "#" then continue end
				// Find first equals sign
				local pos, _, _ = string.find( data, "=" )
				// Check if there is an equals sing
				if pos == nil and string.Trim( data ) != "" then
					// No equals sing found
					MsgC( Color( 137, 222, 255 ), "[dotenv] " , Color( 255, 0, 0 ), filename .. " is malformed at line #" .. line .. "! Skipping!\r\n" )
				// Ingnore empty lines
				elseif string.Trim( data ) != "" then
					// Get Key and Value and trim the excess spaces
					local key 	= string.Trim( string.sub( data, 0, pos - 1) )
					local value = string.Trim( string.sub( data, pos + 1 ) )
					// Insert into the global Table
					ENV[key] = value
				end
			end
			//everything finished loading, calling hook
			MsgC( Color( 137, 222, 255 ), "[dotenv] " , Color( 0, 255, 0 ),  filename .. " loaded!\r\n" )
			hook.Call( "dotenvFinished" )
		end
	else
		// File not found
		MsgC( Color( 137, 222, 255 ), "[dotenv] " , Color( 255, 0, 0 ), filename .. " not found! Aborting!\r\n" )
	end
end
dotenv_init()

// Adding a Reload Command
concommand.Add( "dotenv_reload", dotenv_init )

// Hook to overwrite the filename to load eg. production.env, development.env
//hook.Add( "dotenvInitializing", "gmod-dotenv-changename", function() return "test.env" end)
