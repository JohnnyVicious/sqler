// create a macro/endpoint called "_boot",
// this macro is private "used within other macros" 
// because it starts with "_".
_boot {
    // the query we want to execute
    exec = <<SQL
        IF NOT EXISTS (select * from sysobjects where name='results' and xtype='U')

CREATE TABLE [dbo].[results](
	[RESULT_EXCHANGE] [varchar](32) NOT NULL,
	[RESULT_TIMESTAMP] [bigint] NOT NULL,
	[RESULT_POSID] [varchar](32) NOT NULL,
	[RESULT_PAIR] [varchar](32) NOT NULL,
	[RESULT_PROFIT] [varchar](max) NOT NULL,
	[RESULT_PROFITPCT] [varchar](max) NOT NULL,
 CONSTRAINT [PK_results] PRIMARY KEY CLUSTERED 
(
	[RESULT_EXCHANGE] ASC,
	[RESULT_PAIR] ASC,
	[RESULT_POSID] ASC,
	[RESULT_TIMESTAMP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    SQL
}

// adduser macro/endpoint, just hit `/adduser` with
// a `?user_name=&user_email=` or json `POST` request
// with the same fields.
getallpairresults {
    //validators {
    //    botid_is_not_empty = "$input.botid && $input.botid.trim().length > 0"
    //}

    bind {
        exchange = "$input.exchange"
        pair = "$input.pair"
    }

    methods = ["POST"]
    //methods = ["GET"]

    // include some macros we declared before
    // include = ["_boot"]

    exec = <<SQL
          SELECT TOP 1000 * FROM results WHERE RESULT_EXCHANGE = :exchange AND RESULT_PAIR = :pair;
    	SQL
}

getallexchangeresults {
    //validators {
    //    botid_is_not_empty = "$input.botid && $input.botid.trim().length > 0"
    //}

    bind {
        exchange = "$input.exchange"
    }

    methods = ["POST"]
    //methods = ["GET"]

    // include some macros we declared before
    // include = ["_boot"]

    exec = <<SQL
          SELECT TOP 1000 * FROM results WHERE RESULT_EXCHANGE = :exchange;
    	SQL
}


writeresult {
    //validators {
    //    botid_is_not_empty = "$input.botid && $input.botid.trim().length > 0"
    //}

    bind {
        exchange = "$input.exchange"
        pair = "$input.pair"
		positionid = "$input.positionid"
		timestamp = "$input.timestamp"
        profit = "$input.profit"
        profitpct = "$input.profitpct"
    }

    methods = ["POST"]
    //methods = ["GET"]

    // include some macros we declared before
    // include = ["_boot"]

    exec = <<SQL
        INSERT [dbo].[results] ([RESULT_EXCHANGE], [RESULT_PAIR], [RESULT_POSID], [RESULT_TIMESTAMP], [RESULT_PROFIT], [RESULT_PROFITPCT]) VALUES (:exchange, :pair, :positionid, :timestamp, :profit, :profitpct);
    	SQL
}