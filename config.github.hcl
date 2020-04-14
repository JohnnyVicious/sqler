// create a macro/endpoint called "_boot",
// this macro is private "used within other macros" 
// because it starts with "_".
_boot {
    // the query we want to execute
    exec = <<SQL
        IF NOT EXISTS (select * from sysobjects where name='github' and xtype='U')

        CREATE TABLE IF NOT EXISTS [dbo].[github](
	    [GITHUB_USER] [varchar](max) NOT NULL,
	    [GITHUB_TOKEN] [varchar](max) NOT NULL,
	    [GITHUB_REPO] [varchar](max) NOT NULL,
	    [GITHUB_PROJ] [varchar](max) NOT NULL
        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    SQL
}

// adduser macro/endpoint, just hit `/adduser` with
// a `?user_name=&user_email=` or json `POST` request
// with the same fields.
getgithubuser {
    //validators {
    //    botid_is_not_empty = "$input.botid && $input.botid.trim().length > 0"
    //}

    bind {
        projectname = "$input.projectname"
    }    

    methods = ["POST"]
    //methods = ["GET"]

    // include some macros we declared before
    // include = ["_boot"]

    exec = <<SQL
          SELECT * FROM github WHERE GITHUB_PROJ=:projectname;
    	SQL
}