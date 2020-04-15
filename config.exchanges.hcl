// create a macro/endpoint called "_boot",
// this macro is private "used within other macros" 
// because it starts with "_".
_boot {
    // the query we want to execute
    exec = <<SQL
        IF NOT EXISTS (select * from sysobjects where name='exchanges' and xtype='U')

CREATE TABLE exchanges(
	EXCHANGE_NUM bigint NOT NULL IDENTITY PRIMARY KEY,
	EXCHANGE_ENABLED bit NOT NULL,
	EXCHANGE_NAME [varchar](max) NOT NULL,	
	EXCHANGE_JSON [varchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
 
SQL
}

// adduser macro/endpoint, just hit `/adduser` with
// a `?user_name=&user_email=` or json `POST` request
// with the same fields.

exchangeconfigfromname {
    //validators {
    //    botid_is_not_empty = "$input.botid && $input.botid.trim().length > 0"
    //}

    bind {
        exchangename = "$input.exchangename"
    }

    methods = ["POST"]
    //methods = ["GET"]

    // include some macros we declared before
    // include = ["_boot"]

    exec = <<SQL
          SELECT TOP 1 * FROM configs WHERE EXCHANGE_NAME = :exchangename AND EXCHANGE_ENABLED = 1;
    	SQL
}