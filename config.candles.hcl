// create a macro/endpoint called "_boot",
// this macro is private "used within other macros" 
// because it starts with "_".
_boot {
    // the query we want to execute
    exec = <<SQL
        IF NOT EXISTS (select * from sysobjects where name='candles' and xtype='U')

    CREATE TABLE candles(
	    CANDLE_NUM bigint NOT NULL IDENTITY PRIMARY KEY,
	    CANDLE_EXCHANGE [varchar](32) NOT NULL,
	    CANDLE_TYPE [varchar](32) NOT NULL,
	    CANDLE_PAIR [varchar](32) NOT NULL,
	    CANDLE_PERIOD smallint NOT NULL,
	    CANDLE_TIMESTAMP bigint NOT NULL,
	    CANDLE_JSON [varchar](max) NOT NULL
    ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    SQL
}

// adduser macro/endpoint, just hit `/adduser` with
// a `?user_name=&user_email=` or json `POST` request
// with the same fields.
getallcandles {
    //validators {
    //    botid_is_not_empty = "$input.botid && $input.botid.trim().length > 0"
    //}

    bind {
        exchange = "$input.exchange"
        type = "$input.type"
        pair = "$input.pair"
        period = "$input.period"
        limit = "$input.limit"
    }

    methods = ["POST"]
    //methods = ["GET"]

    // include some macros we declared before
    // include = ["_boot"]
    // SELECT TOP :limit * FROM candles WHERE CANDLE_EXCHANGE = :exchange AND CANDLE_PAIR = :pair AND CANDLE_PERIOD = :period AND CANDLE_TYPE = :type ORDER BY CANDLE_TIMESTAMP DESC;

    exec = <<SQL
          SELECT TOP 100 * FROM candles WHERE CANDLE_EXCHANGE = :exchange AND CANDLE_PAIR = :pair AND CANDLE_PERIOD = :period AND CANDLE_TYPE = :type ORDER BY CANDLE_TIMESTAMP DESC;
    	SQL
}


writecandle {
    //validators {
    //    botid_is_not_empty = "$input.botid && $input.botid.trim().length > 0"
    //}

    bind {
        exchange = "$input.exchange"
        type = "$input.type"
        pair = "$input.pair"
        period = "$input.period"
        timestamp = "$input.timestamp"
        jsondata = "$input.jsondata"
    }

    methods = ["POST"]
    //methods = ["GET"]

    // include some macros we declared before
    // include = ["_boot"]

    exec = <<SQL
          INSERT [dbo].[candles] ([CANDLE_EXCHANGE], [CANDLE_TYPE], [CANDLE_PAIR], [CANDLE_PERIOD], [CANDLE_TIMESTAMP], [CANDLE_JSON]) VALUES (:exchange, :type, :pair, :period, :timestamp, :jsondata);
    	SQL
}