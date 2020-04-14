// create a macro/endpoint called "_boot",
// this macro is private "used within other macros" 
// because it starts with "_".
_boot {
    // the query we want to execute
    exec = <<SQL
        IF NOT EXISTS (select * from sysobjects where name='discord' and xtype='U')

        CREATE TABLE discord(
	    DISCORD_NUM bigint NOT NULL IDENTITY PRIMARY KEY,
	    DISCORD_ENABLED bit NOT NULL,
	    DISCORD_DEMO bit NOT NULL,
	    DISCORD_EXCHANGE [varchar](max) NOT NULL,
	    DISCORD_WEBHOOK [varchar](max) NOT NULL
        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    SQL
}

// adduser macro/endpoint, just hit `/adduser` with
// a `?user_name=&user_email=` or json `POST` request
// with the same fields.

getdiscordhook {
    //validators {
    //    botid_is_not_empty = "$input.botid && $input.botid.trim().length > 0"
    //}

    bind {
        exchange = "$input.exchange"
        demo = $input.demo
    }

    methods = ["POST"]
    //methods = ["GET"]

    // include some macros we declared before
    // include = ["_boot"]

    exec = <<SQL
          SELECT * FROM discord WHERE DISCORD_EXCHANGE=:exchange AND DISCORD_DEMO=:demo;
    	SQL
}