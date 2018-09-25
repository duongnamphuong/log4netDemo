This tutorial shows how to use log4net to log to console, file and database. In this case we use UTC timezone for the timing of each log, SQL Server database for database.

References:
	https://www.c-sharpcorner.com/article/configure-log4net-with-database-tutorial-for-beginners/
	https://stackify.com/log4net-guide-dotnet-logging/

Steps:
- Create a solution with a console project, using .NET Framework 4.5.2
- Using Package Manager Console, run: install-package log4net -version 2.0.8
- Add a new config file: log4net.config. Open its properties and set "Copy to Output Directory" to "Copy always". Paste this content into the file (overwrite all previous content):
	<log4net>
	  <root>
	    <level value="ALL" />
	    <appender-ref ref="console" />
	    <appender-ref ref="file" />
	    <appender-ref ref="AdoNetAppender" />
	  </root>
	  <appender name="console" type="log4net.Appender.ConsoleAppender">
	    <layout type="log4net.Layout.PatternLayout">
	      <!--pattern of logging to console-->
	      <conversionPattern value="%utcdate UTC %level %logger - %message%newline" />
	    </layout>
	  </appender>
	  <appender name="file" type="log4net.Appender.RollingFileAppender">
	    <file type="log4net.Util.PatternString" value="logs/log4netdblogger_%utcdate{yyyy-MM-dd}.log" />
	    <appendToFile value="true" />
	    <rollingStyle value="Size" />
	    <maxSizeRollBackups value="5" />
	    <maximumFileSize value="10MB" />
	    <staticLogFileName value="true" />
	    <layout type="log4net.Layout.PatternLayout">
	      <!--pattern of logging to file-->
	      <conversionPattern value="%utcdate UTC [Thread #%thread] %level %logger - %message%newline" />
	    </layout>
	  </appender>
	  <appender name="AdoNetAppender" type="log4net.Appender.AdoNetAppender">
	    <bufferSize value="1" />
	    <connectionType value="System.Data.SqlClient.SqlConnection, System.Data, Version=1.0.3300.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" />
	    <connectionStringName value="ConnectionString1" />
	    <commandText value="INSERT INTO dbo.Log4NetLog ([Date],[Thread],[Level],[Logger],[Message],[Exception]) VALUES (@log_date,@thread,@log_level,@logger,@message,@exception)" />
	    <parameter>
	      <parameterName value="@log_date" />
	      <dbType value="DateTime" />
	      <layout type="log4net.Layout.RawUtcTimeStampLayout" />
	    </parameter>
	    <parameter>
	      <parameterName value="@thread" />
	      <dbType value="String" />
	      <size value="255" />
	      <layout type="log4net.Layout.PatternLayout">
	        <conversionPattern value="%thread" />
	      </layout>
	    </parameter>
	    <parameter>
	      <parameterName value="@log_level" />
	      <dbType value="String" />
	      <size value="50" />
	      <layout type="log4net.Layout.PatternLayout">
	        <conversionPattern value="%level" />
	      </layout>
	    </parameter>
	    <parameter>
	      <parameterName value="@logger" />
	      <dbType value="String" />
	      <size value="255" />
	      <layout type="log4net.Layout.PatternLayout">
	        <conversionPattern value="%logger" />
	      </layout>
	    </parameter>
	    <parameter>
	      <parameterName value="@message" />
	      <dbType value="String" />
	      <size value="-1" />
	      <layout type="log4net.Layout.PatternLayout">
	        <conversionPattern value="%message" />
	      </layout>
	    </parameter>
	    <parameter>
	      <parameterName value="@exception" />
	      <dbType value="String" />
	      <size value="-1" />
	      <layout type="log4net.Layout.ExceptionLayout" />
	    </parameter>
	  </appender>
	</log4net>
- Open AssemblyInfo.cs, then insert this at the last line:
	[assembly: log4net.Config.XmlConfigurator(ConfigFile = "log4net.config")]
- In App.config, add this inside <configuration>:
	<connectionStrings>
		<add name="ConnectionString1" connectionString="Data Source=NINETAILS\SQLEXPRESS; Persist Security Info=True; Initial Catalog=log4netdblogger;Integrated Security=True" providerName="System.Data.SqlClient" />
	</connectionStrings>
	(*) Change Data Source to match the SQL Server connection on your machine.
	(*) This connection string uses Windows authentication to access SQL Server. If you want to use SQL Server authentication, replace "Integrated Security=True" with "user id=your_username;password=your_password"
- Create log4netdblogger database in SQL Server, then add this table:
	CREATE TABLE [dbo].[Log4NetLog](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[Date] [datetime] NOT NULL,
		[Thread] [nvarchar](255) NOT NULL,
		[Level] [nvarchar](50) NOT NULL,
		[Logger] [nvarchar](255) NOT NULL,
		[Message] [nvarchar](max) NOT NULL,
		[Exception] [nvarchar](max) NULL,
	 CONSTRAINT [PK_Log4NetLog] PRIMARY KEY CLUSTERED
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
	GO
- Program.cs:
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;
	using System.Threading.Tasks;

	namespace log4netdblogger
	{
	    class Program
	    {
	        private static readonly log4net.ILog log = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
	        static void Main(string[] args)
	        {
	            log.Info("1");
	            int divisor = 0, i = 1;
	            try
	            {
	                var result = i / divisor;
	            }
	            catch (Exception e)
	            {
	                log.Error("Divided by 0.", e);
	            }
	        }
	    }
	}