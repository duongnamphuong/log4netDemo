# Introduction

This is a demo of log4net, which writes logs to console, file and database.

I use UTC timezone for the timing of the logs and target database is an SQL Server.

# References:

* [https://www.c-sharpcorner.com/article/configure-log4net-with-database-tutorial-for-beginners/](https://www.c-sharpcorner.com/article/configure-log4net-with-database-tutorial-for-beginners/)
* [https://stackify.com/log4net-guide-dotnet-logging/](https://stackify.com/log4net-guide-dotnet-logging/)

# Steps

* Create a solution with a library project **LogUtil**, using .NET Framework 4.5.2
* Using Package Manager Console, run: `install-package log4net -version 2.0.12`
* Add a new config file: **log4net.config**. Open its properties and set "Copy to Output Directory" to "Copy always". Paste this content into the file (overwrite all previous content):
```xml
<log4net>
  <root>
    <level value="ALL" />
    <appender-ref ref="console" />
    <appender-ref ref="file" />
    <appender-ref ref="AdoNetAppender" />
  </root>
  <appender name="console" type="log4net.Appender.ColoredConsoleAppender">
    <!--Possible colors: Blue, Green, Red, White, Yellow, Purple, Cyan, HighIntensity: https://logging.apache.org/log4net/release/sdk/html/T_log4net_Appender_ColoredConsoleAppender_Colors.htm-->
    <mapping>
      <level value="INFO" />
      <forecolor value="Green" />
    </mapping>
    <mapping>
      <level value="ERROR" />
      <forecolor value="Red" />
    </mapping>
    <mapping>
      <level value="DEBUG" />
      <forecolor value="White" />
    </mapping>
    <mapping>
      <level value="WARN" />
      <forecolor value="Yellow" />
    </mapping>
    <mapping>
      <level value="FATAL" />
      <forecolor value="Cyan" />
    </mapping>
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
    <connectionStringName value="Log4NetConnectionString" />
    <commandText value="INSERT INTO dbo.LogOltp ([Date],[Host],[Thread],[Level],[Logger],[Message],[Exception],[Assembly]) VALUES (@log_date,@log_host,@thread,@log_level,@logger,@message,@exception,NULL)" />
    <parameter>
      <parameterName value="@log_date" />
      <dbType value="DateTime" />
      <layout type="log4net.Layout.RawUtcTimeStampLayout" />
    </parameter>
    <parameter>
      <parameterName value="@log_host" />
      <dbType value="String" />
      <size value="255" />
      <layout type="log4net.Layout.PatternLayout">
        <conversionPattern value="%property{log4net:HostName}" />
      </layout>
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
```
* Open AssemblyInfo.cs, then insert this at the last line:
```csharp
[assembly: log4net.Config.XmlConfigurator(ConfigFile = "log4net.config")]
```
* Add file Log4netLogger.cs:
```csharp
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LogUtil
{
    public static class Log4netLogger
    {
        public static void Info(Type caller, object message)
        {
            var log = log4net.LogManager.GetLogger(caller);
            log.Info(message);
        }
        public static void Info(Type caller, object message, Exception exception)
        {
            var log = log4net.LogManager.GetLogger(caller);
            log.Info(message, exception);
        }
        public static void Warn(Type caller, object message)
        {
            var log = log4net.LogManager.GetLogger(caller);
            log.Warn(message);
        }
        public static void Warn(Type caller, object message, Exception exception)
        {
            var log = log4net.LogManager.GetLogger(caller);
            log.Warn(message, exception);
        }
        public static void Error(Type caller, object message)
        {
            var log = log4net.LogManager.GetLogger(caller);
            log.Error(message);
        }
        public static void Error(Type caller, object message, Exception exception)
        {
            var log = log4net.LogManager.GetLogger(caller);
            log.Error(message, exception);
        }
        public static void Debug(Type caller, object message)
        {
            var log = log4net.LogManager.GetLogger(caller);
            log.Debug(message);
        }
        public static void Debug(Type caller, object message, Exception exception)
        {
            var log = log4net.LogManager.GetLogger(caller);
            log.Debug(message, exception);
        }
        public static void Fatal(Type caller, object message)
        {
            var log = log4net.LogManager.GetLogger(caller);
            log.Fatal(message);
        }
        public static void Fatal(Type caller, object message, Exception exception)
        {
            var log = log4net.LogManager.GetLogger(caller);
            log.Fatal(message, exception);
        }
    }
}
```
* Add a console project **log4netdblogger**, and add "LogUtil" into its references list.
* In *App.config*, add this inside &lt;configuration&gt;:
  * Change Data Source to match the SQL Server connection on your machine.
  * This connection string uses Windows authentication to access SQL Server. If you want to use SQL Server authentication, replace **Integrated Security=True** with **user id=your_username;password=your_password**
```xml
<connectionStrings>
	<add name="Log4NetConnectionString" connectionString="Data Source=.; Persist Security Info=True; Initial Catalog=log4netdblogger;Integrated Security=True" providerName="System.Data.SqlClient" />
</connectionStrings>
```
* Create log4netdblogger database in SQL Server, then add these tables:
  * Note: **LogOltp** is a In-memory table and is only supported in SQL Server 2017 or later. It uses new technology to speed up data insertion.
```sql
CREATE TABLE [dbo].[Log4NetLog](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NOT NULL,
	[Host] [nvarchar](255) NOT NULL,
	[Thread] [nvarchar](255) NOT NULL,
	[Level] [nvarchar](50) NOT NULL,
	[Logger] [nvarchar](255) NOT NULL,
	[Message] [nvarchar](max) NOT NULL,
	[Exception] [nvarchar](max) NULL,
	[Assembly] [nvarchar](255) NULL,
 CONSTRAINT [PK_Log4NetLog] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE TABLE [dbo].[LogOltp] (
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NOT NULL,
	[Host] [nvarchar](255) NOT NULL,
	[Thread] [nvarchar](255) NOT NULL,
	[Level] [nvarchar](50) NOT NULL,
	[Logger] [nvarchar](255) NOT NULL,
	[Message] [nvarchar](max) NOT NULL,
	[Exception] [nvarchar](max) NULL,
	[Assembly] [nvarchar](255) NULL,
 PRIMARY KEY NONCLUSTERED
(
	[Id] ASC
)
)WITH ( MEMORY_OPTIMIZED = ON , DURABILITY = SCHEMA_AND_DATA )
GO
```
* Before creating an In-memory table in database, the database must have a filegroup. Use these scripts to add one:
```sql
USE [master]
ALTER DATABASE log4netdblogger ADD FILEGROUP [log4netdblogger_mod] CONTAINS MEMORY_OPTIMIZED_DATA;
ALTER DATABASE log4netdblogger ADD FILE (name = [log4netdblogger_dir], filename='C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\log4netdblogger_dir') TO FILEGROUP log4netdblogger_mod;
GO
```
(Of course, filegroup is supported since SQL Server 2017)
* When writing logs, you will use one of those two tables. Use [Log4NetLog] if your SQL Server is not 2017 or later version. Use **LogOltp** if you have SQL Server 2017 and want a better capability for high speed of log insertion. The name of the used table is written in log4net.config. You can find it and change as you like.
* Demo logging in *Program.cs*:
```csharp
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace log4netdblogger
{
    class Program
    {
        static void Main(string[] args)
        {
            LogUtil.Log4netLogger.Info(MethodBase.GetCurrentMethod().DeclaringType, "1");
            LogUtil.Log4netLogger.Debug(MethodBase.GetCurrentMethod().DeclaringType, "1");
            LogUtil.Log4netLogger.Warn(MethodBase.GetCurrentMethod().DeclaringType, "1");
            LogUtil.Log4netLogger.Fatal(MethodBase.GetCurrentMethod().DeclaringType, "1");
            int divisor = 0, i = 1;
            try
            {
                var result = i / divisor;
            }
            catch (Exception e)
            {
                LogUtil.Log4netLogger.Error(MethodBase.GetCurrentMethod().DeclaringType, "Divided by 0.", e);
            }
            Console.ReadLine();
        }
    }
}
```
* Run **log4netdblogger.exe**, then check for logs in console, file and in the table in database.
