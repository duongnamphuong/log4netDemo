/*script to add filegroup for log4netdblogger*/
/*
USE [master]
ALTER DATABASE log4netdblogger ADD FILEGROUP [log4netdblogger_mod] CONTAINS MEMORY_OPTIMIZED_DATA;
ALTER DATABASE log4netdblogger ADD FILE (name = [log4netdblogger_dir], filename='C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\log4netdblogger_dir') TO FILEGROUP log4netdblogger_mod;
GO
USE [log4netdblogger]
CREATE TABLE LogOltp
(
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
)
WITH ( MEMORY_OPTIMIZED = ON , DURABILITY = SCHEMA_AND_DATA )
GO
*/
USE [master]
GO
CREATE DATABASE [log4netdblogger]
 CONTAINMENT = NONE
 ON  PRIMARY
( NAME = N'log4netdblogger', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\log4netdblogger.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB ),
 FILEGROUP [log4netdblogger_mod] CONTAINS MEMORY_OPTIMIZED_DATA  DEFAULT
( NAME = N'log4netdblogger_dir', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\log4netdblogger_dir' , MAXSIZE = UNLIMITED)
 LOG ON
( NAME = N'log4netdblogger_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\log4netdblogger_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [log4netdblogger] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [log4netdblogger].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [log4netdblogger] SET ANSI_NULL_DEFAULT OFF
GO
ALTER DATABASE [log4netdblogger] SET ANSI_NULLS OFF
GO
ALTER DATABASE [log4netdblogger] SET ANSI_PADDING OFF
GO
ALTER DATABASE [log4netdblogger] SET ANSI_WARNINGS OFF
GO
ALTER DATABASE [log4netdblogger] SET ARITHABORT OFF
GO
ALTER DATABASE [log4netdblogger] SET AUTO_CLOSE OFF
GO
ALTER DATABASE [log4netdblogger] SET AUTO_SHRINK OFF
GO
ALTER DATABASE [log4netdblogger] SET AUTO_UPDATE_STATISTICS ON
GO
ALTER DATABASE [log4netdblogger] SET CURSOR_CLOSE_ON_COMMIT OFF
GO
ALTER DATABASE [log4netdblogger] SET CURSOR_DEFAULT  GLOBAL
GO
ALTER DATABASE [log4netdblogger] SET CONCAT_NULL_YIELDS_NULL OFF
GO
ALTER DATABASE [log4netdblogger] SET NUMERIC_ROUNDABORT OFF
GO
ALTER DATABASE [log4netdblogger] SET QUOTED_IDENTIFIER OFF
GO
ALTER DATABASE [log4netdblogger] SET RECURSIVE_TRIGGERS OFF
GO
ALTER DATABASE [log4netdblogger] SET  DISABLE_BROKER
GO
ALTER DATABASE [log4netdblogger] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO
ALTER DATABASE [log4netdblogger] SET DATE_CORRELATION_OPTIMIZATION OFF
GO
ALTER DATABASE [log4netdblogger] SET TRUSTWORTHY OFF
GO
ALTER DATABASE [log4netdblogger] SET ALLOW_SNAPSHOT_ISOLATION OFF
GO
ALTER DATABASE [log4netdblogger] SET PARAMETERIZATION SIMPLE
GO
ALTER DATABASE [log4netdblogger] SET READ_COMMITTED_SNAPSHOT OFF
GO
ALTER DATABASE [log4netdblogger] SET HONOR_BROKER_PRIORITY OFF
GO
ALTER DATABASE [log4netdblogger] SET RECOVERY SIMPLE
GO
ALTER DATABASE [log4netdblogger] SET  MULTI_USER
GO
ALTER DATABASE [log4netdblogger] SET PAGE_VERIFY CHECKSUM
GO
ALTER DATABASE [log4netdblogger] SET DB_CHAINING OFF
GO
ALTER DATABASE [log4netdblogger] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF )
GO
ALTER DATABASE [log4netdblogger] SET TARGET_RECOVERY_TIME = 60 SECONDS
GO
ALTER DATABASE [log4netdblogger] SET DELAYED_DURABILITY = DISABLED
GO
USE [log4netdblogger]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LogOltp]
(
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NOT NULL,
	[Host] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Thread] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Level] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Logger] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Message] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Exception] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Assembly] [nvarchar](255) NULL,
 PRIMARY KEY NONCLUSTERED
(
	[Id] ASC
)
)WITH ( MEMORY_OPTIMIZED = ON , DURABILITY = SCHEMA_AND_DATA )
GO
USE [master]
GO
ALTER DATABASE [log4netdblogger] SET  READ_WRITE
GO
