// create a macro/endpoint called "_boot",
// this macro is private "used within other macros" 
// because it starts with "_".
_boot {
    // the query we want to execute
    exec = <<SQL
        IF NOT EXISTS (select * from sysobjects where name='accounts' and xtype='U')

CREATE TABLE accounts(
	ACCOUNT_NUM bigint NOT NULL IDENTITY PRIMARY KEY,
	ACCOUNT_ENABLED bit NOT NULL,
	ACCOUNT_RO bit NOT NULL,
	ACCOUNT_PRIO int NOT NULL,
	ACCOUNT_USER bigint NOT NULL,
	ACCOUNT_EXCHANGE [varchar](max) NOT NULL,
	ACCOUNT_JSON [varchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
 
SQL
}

// adduser macro/endpoint, just hit `/adduser` with
// a `?user_name=&user_email=` or json `POST` request
// with the same fields.

getaccountdata {
    //validators {
    //    botid_is_not_empty = "$input.botid && $input.botid.trim().length > 0"
    //}

    bind {
        accountuser = "$input.accountuser"
        exchangename = "$input.exchangename"
    }

    methods = ["POST"]
    //methods = ["GET"]

    // include some macros we declared before
    // include = ["_boot"]

    exec = <<SQL
          SELECT TOP 1 * FROM accounts WHERE ACCOUNT_EXCHANGE = :exchangename AND ACCOUNT_ENABLED = 1 AND ACCOUNT_USER = :accountuser;
    	SQL
}
