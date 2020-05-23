// create a macro/endpoint called "_boot",
// this macro is private "used within other macros" 
// because it starts with "_".
_boot {
    // the query we want to execute
    exec = <<SQL
        IF NOT EXISTS (select * from sysobjects where name='strategy' and xtype='U')

    CREATE TABLE [dbo].[strategy](
	[STRATEGY_NAME] [varchar](32) NOT NULL,
	[STRATEGY_VERSION] [smallint] NOT NULL,
	[STRATEGY_JSON] [varchar](max) NOT NULL,
    CONSTRAINT [PK_strategy] PRIMARY KEY CLUSTERED 
    (
	    [STRATEGY_NAME] ASC,
	    [STRATEGY_VERSION] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    SQL
}

// adduser macro/endpoint, just hit `/adduser` with
// a `?user_name=&user_email=` or json `POST` request
// with the same fields.
getstrategy {
    //validators {
    //    botid_is_not_empty = "$input.botid && $input.botid.trim().length > 0"
    //}

    bind {
        name = "$input.strategy_name"
        version = "$input.strategy_version"
    }

    methods = ["POST"]
    //methods = ["GET"]

    // include some macros we declared before
    // include = ["_boot"]
    // SELECT TOP :limit * FROM candles WHERE CANDLE_EXCHANGE = :exchange AND CANDLE_PAIR = :pair AND CANDLE_PERIOD = :period AND CANDLE_TYPE = :type ORDER BY CANDLE_TIMESTAMP DESC;

    exec = <<SQL
          SELECT * FROM strategy WHERE STRATEGY_NAME = :name AND STRATEGY_VERSION = :version;
    	SQL
}
