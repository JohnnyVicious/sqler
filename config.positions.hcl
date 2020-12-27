// create a macro/endpoint called "_boot",
// this macro is private "used within other macros" 
// because it starts with "_".
_boot {
    // the query we want to execute
    exec = <<SQL
        IF NOT EXISTS (select * from sysobjects where name='positions' and xtype='U')

CREATE TABLE [dbo].[positions](
	[POSITION_ENABLED] [bit] NOT NULL,
	[POSITION_EXCHANGE] [varchar](32) NOT NULL,
	[POSITION_ID] [varchar](32) NOT NULL,
	[POSITION_PAIR] [varchar](32) NOT NULL,
	[POSITION_JSON] [varchar](max) NOT NULL,
 CONSTRAINT [PK_positions] PRIMARY KEY CLUSTERED 
(
	[POSITION_EXCHANGE] ASC,
	[POSITION_PAIR] ASC,
	[POSITION_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

    SQL
}

// adduser macro/endpoint, just hit `/adduser` with
// a `?user_name=&user_email=` or json `POST` request
// with the same fields.
getallpositions {
    //validators {
    //    botid_is_not_empty = "$input.botid && $input.botid.trim().length > 0"
    //}

    bind {
        exchange = "$input.exchange"
        pair = "$input.pair"
		enabled = "$input.enabled"
    }

    methods = ["POST"]
    //methods = ["GET"]

    // include some macros we declared before
    // include = ["_boot"]

    exec = <<SQL
          SELECT TOP 100 * FROM positions WHERE POSITION_EXCHANGE = :exchange AND POSITION_PAIR = :pair AND POSITION_ENABLED = :enabled;
    	SQL
}


writeposition {
    //validators {
    //    botid_is_not_empty = "$input.botid && $input.botid.trim().length > 0"
    //}

    bind {
        exchange = "$input.exchange"
        pair = "$input.pair"
		positionid = "$input.positionid"
		enabled = "$input.enabled"
		timestamp = "$input.timestamp"
        jsondata = "$input.jsondata"
    }

    methods = ["POST"]
    //methods = ["GET"]

    // include some macros we declared before
    // include = ["_boot"]

    exec = <<SQL
        IF EXISTS (SELECT * FROM positions WHERE POSITION_EXCHANGE = :exchange AND POSITION_PAIR = :pair AND POSITION_ID = :positionid)
        BEGIN
        UPDATE dbo.positions SET POSITION_JSON = :jsondata FROM dbo.positions WHERE POSITION_EXCHANGE = :exchange AND POSITION_PAIR = :pair AND POSITION_ID = :positionid AND POSITION_ENABLED = :enabled;
        END
        ELSE
        BEGIN
        INSERT [dbo].[positions] ([POSITION_EXCHANGE], [POSITION_PAIR], [POSITION_ID], [POSITION_ENABLED], [POSITION_TIMESTAMP], [POSITION_JSON]) VALUES (:exchange, :pair, :positionid, :enabled, :timestamp, :jsondata);
        END
    	SQL
}
