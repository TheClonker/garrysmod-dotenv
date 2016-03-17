local function Initialize()
	local filename = hook.Call( "dotenvInitializing" ) or ".env"
	ENV = {}
	if file.Exists( filename, "DATA" ) then
		// Read the .env File
		local rawdata = file.Read( filename, "DATA" )
		// Split into a Table of all Lines
		local dataTable = string.Explode( "\r\n", rawdata )
		// Check that the File isn't empty
		if table.Count( dataTable ) == 0 or string.Trim( rawdata ) == "" then
			// File is empty
			MsgC( Color( 137, 222, 255 ), "[dotenv] " , Color( 255, 0, 0 ), filename .. " is empty! Aborting!\r\n" )
		else
			// Trim the Stings and insert into global Table
			table.foreach( dataTable, function( line, data )
				// Find first equals sign
				local pos, _, _ = string.find( data, "=" )
				// Check if there is an equals sing
				if pos == nil and string.Trim( data ) != "" then
					// No equals sing found
					MsgC( Color( 137, 222, 255 ), "[dotenv] " , Color( 255, 0, 0 ), filename .. " is malformed at line #" .. line .."! Skipping!\r\n" )
				// Ingnore empty lines
				elseif string.Trim( data ) != "" then
					// Get Key and Value and trim the excess spaces
					local key 	= string.Trim( string.sub( data, 0, pos - 1) )
					local value = string.Trim( string.sub( data, pos + 1 ) )
					// Insert into the global Table
					ENV[key] = value
				end
			end )
			MsgC( Color( 137, 222, 255 ), "[dotenv] " , Color( 0, 255, 0 ),  filename .. " loaded!\r\n" )
		end
	else
		// File not found
		MsgC( Color( 137, 222, 255 ), "[dotenv] " , Color( 255, 0, 0 ), filename .. " not found! Aborting!\r\n" )
	end
end
// Hook to load the file
hook.Add( "Initialize", "gmod-dotenv-initializing", Initialize )

// Helper Functions
function getenv( id, default )
	return ENV[id] || default || nil
end

function setenv( id, data )
	ENV[id] = data
	return true
end

// Hook to overwrite the filename to load eg. production.env, development.env
//hook.Add( "dotenvInitializing", "gmod-dotenv-changename", function() return "test.env" end)