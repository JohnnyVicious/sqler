// create a macro/endpoint called "_boot",
// this macro is private "used within other macros" 
// because it starts with "_".
_boot {
    // the query we want to execute
    exec = <<SQL
        IF NOT EXISTS (select * from sysobjects where name='indicators' and xtype='U')

        CREATE TABLE [dbo].[indicators](
	    [INDICATOR_EXCHANGE] [varchar](32) NOT NULL,
	    [INDICATOR_TYPE] [varchar](32) NOT NULL,
	    [INDICATOR_PAIR] [varchar](32) NOT NULL,
	    [INDICATOR_PERIOD] [smallint] NOT NULL,
	    [INDICATOR_TIMESTAMP] [bigint] NOT NULL,
	    [INDICATOR_NAME] [varchar](32) NOT NULL,
	    [INDICATOR_VERSION] [smallint] NOT NULL,
	    [INDICATOR_JSON] [varchar](max) NOT NULL,
        CONSTRAINT [PK_indicators] PRIMARY KEY CLUSTERED 
        (
	        [INDICATOR_EXCHANGE] ASC,
	        [INDICATOR_PAIR] ASC,
	        [INDICATOR_PERIOD] ASC,
	        [INDICATOR_TIMESTAMP] ASC,
        	[INDICATOR_TYPE] ASC,
	        [INDICATOR_NAME] ASC,
	        [INDICATOR_VERSION] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]    
    SQL
}

// adduser macro/endpoint, just hit `/adduser` with
// a `?user_name=&user_email=` or json `POST` request
// with the same fields.
getallindicators {
    //validators {
    //    botid_is_not_empty = "$input.botid && $input.botid.trim().length > 0"
    //}

    bind {
        exchange = "$input.exchange"
        type = "$input.type"
        pair = "$input.pair"
        period = "$input.period"
        name = "$input.name"
        version = "$input.version"
    }

    methods = ["POST"]
    //methods = ["GET"]

    // include some macros we declared before
    // include = ["_boot"]

    exec = <<SQL
          SELECT * FROM indicators WHERE INDICATOR_EXCHANGE = :exchange AND INDICATOR_PAIR = :pair AND INDICATOR_PERIOD = :period AND INDICATOR_TYPE = :type AND INDICATOR_NAME = :name AND INDICATOR_VERSION = :version ORDER BY INDICATOR_TIMESTAMP DESC;
    	SQL
}


writeindicator {
    //validators {
    //    botid_is_not_empty = "$input.botid && $input.botid.trim().length > 0"
    //}

    bind {
        exchange = "$input.exchange"
        type = "$input.type"
        pair = "$input.pair"
        period = "$input.period"
        timestamp = "$input.timestamp"
        name = "$input.name"
        version = "$input.version"
        jsondata = "$input.jsondata"
    }

    methods = ["POST"]
    //methods = ["GET"]

    // include some macros we declared before
    // include = ["_boot"]

    exec = <<SQL
        IF NOT EXISTS (SELECT * FROM indicators WHERE INDICATOR_EXCHANGE = :exchange AND INDICATOR_PAIR = :pair AND INDICATOR_PERIOD = :period AND INDICATOR_TYPE = :type AND INDICATOR_TIMESTAMP = :timestamp AND INDICATOR_NAME = :name AND INDICATOR_VERSION = :version)
        INSERT [dbo].[indicators] ([INDICATOR_EXCHANGE], [INDICATOR_TYPE], [INDICATOR_PAIR], [INDICATOR_PERIOD], [INDICATOR_TIMESTAMP], [INDICATOR_NAME], [INDICATOR_VERSION], [INDICATOR_JSON]) VALUES (:exchange, :type, :pair, :period, :timestamp, :name, :version, :jsondata);
    	SQL
}

deleteindicator {
    //validators {
    //    botid_is_not_empty = "$input.botid && $input.botid.trim().length > 0"
    //}

    bind {
        exchange = "$input.exchange"
        type = "$input.type"
        pair = "$input.pair"
        period = "$input.period"
        timestamp = "$input.timestamp"
        name = "$input.name"
        version = "$input.version"
    }

    methods = ["POST"]
    //methods = ["GET"]

    // include some macros we declared before
    // include = ["_boot"]

    exec = <<SQL
        IF EXISTS (SELECT * FROM indicators WHERE INDICATOR_EXCHANGE = :exchange AND INDICATOR_PAIR = :pair AND INDICATOR_PERIOD = :period AND INDICATOR_TYPE = :type AND INDICATOR_TIMESTAMP = :timestamp AND INDICATOR_NAME = :name AND INDICATOR_VERSION = :version)
        DELETE FROM [dbo].[indicators] WHERE INDICATOR_EXCHANGE = :exchange AND INDICATOR_PAIR = :pair AND INDICATOR_PERIOD = :period AND INDICATOR_TYPE = :type AND INDICATOR_TIMESTAMP = :timestamp AND INDICATOR_NAME = :name AND INDICATOR_VERSION = :version;
    	SQL
}

updateindicator {
    //validators {
    //    botid_is_not_empty = "$input.botid && $input.botid.trim().length > 0"
    //}

    bind {
        exchange = "$input.exchange"
        type = "$input.type"
        pair = "$input.pair"
        period = "$input.period"
        timestamp = "$input.timestamp"
        name = "$input.name"
        version = "$input.version"
        jsondata = "$input.jsondata"
    }

    methods = ["POST"]
    //methods = ["GET"]

    // include some macros we declared before
    // include = ["_boot"]

    exec = <<SQL
        IF EXISTS (SELECT * FROM indicators WHERE INDICATOR_EXCHANGE = :exchange AND INDICATOR_PAIR = :pair AND INDICATOR_PERIOD = :period AND INDICATOR_TYPE = :type AND INDICATOR_TIMESTAMP = :timestamp AND INDICATOR_NAME = :name AND INDICATOR_VERSION = :version)
        BEGIN
        UPDATE dbo.indicators SET INDICATOR_JSON = :jsondata FROM dbo.indicators WHERE INDICATOR_EXCHANGE = :exchange AND INDICATOR_PAIR = :pair AND INDICATOR_PERIOD = :period AND INDICATOR_TYPE = :type AND INDICATOR_TIMESTAMP = :timestamp AND INDICATOR_NAME = :name AND INDICATOR_VERSION = :version;
        END
        ELSE
        BEGIN
        INSERT [dbo].[indicators] ([INDICATOR_EXCHANGE], [INDICATOR_TYPE], [INDICATOR_PAIR], [INDICATOR_PERIOD], [INDICATOR_TIMESTAMP], [INDICATOR_NAME], [INDICATOR_VERSION], [INDICATOR_JSON]) VALUES (:exchange, :type, :pair, :period, :timestamp, :name, :version, :jsondata);
        END        
    	SQL
}
