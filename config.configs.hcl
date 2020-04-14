// create a macro/endpoint called "_boot",
// this macro is private "used within other macros" 
// because it starts with "_".
_boot {
    // the query we want to execute
    exec = <<SQL
        IF NOT EXISTS (select * from sysobjects where name='configs' and xtype='U')

        CREATE TABLE configs(
	    CONFIG_NUM bigint NOT NULL IDENTITY PRIMARY KEY,
	    CONFIG_ENABLED bit NOT NULL,
	    CONFIG_TYPE int NOT NULL,
	    CONFIG_JSON [varchar](max) NOT NULL,
	    CONFIG_HEARTBEAT datetime,
	    CONFIG_KILLSWITCH datetime,	
	    CONFIG_BOTID [varchar](max)
        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    SQL
}

// adduser macro/endpoint, just hit `/adduser` with
// a `?user_name=&user_email=` or json `POST` request
// with the same fields.
configfrombotid {
    //validators {
    //    botid_is_not_empty = "$input.botid && $input.botid.trim().length > 0"
    //}

    bind {
        botid = "$input.botid"
    }

    methods = ["POST"]
    //methods = ["GET"]

    // include some macros we declared before
    // include = ["_boot"]

    exec = <<SQL
          SELECT TOP 1 * FROM configs WHERE CONFIG_BOTID = :botid;
    	SQL
}

