/*Check if database 'telemetry' exist, create new database 'telemetry' and switch to 'telemetry'*/
if exists(select * from sys.databases where name='telemetry')
    raiserror('Database "telemetry" already exists', 20, -1) with log  --terminate batch
GO
create database telemetry  COLLATE SQL_Latin1_General_CP1_CI_AS
GO

if not exists(select * from sys.databases where name='telemetry')
    raiserror('Database "telemetry" could not be created', 20, -1) with log --terminate batch

use telemetry
GO

/*Create table with following schema*/
CREATE TABLE [dbo].[DeviceData](
	[NodeID] [nvarchar](255) NULL,
	[RunningStatus] [nvarchar](255) NULL,
	[CountGood] [int] NULL,
	[CountBad] [int] NULL,
	[Frequency] [int] NULL,
	[SourceTimestamp] [datetime2](7) NULL
GO

/*Check Data Retention Policy from database wide*/
SELECT is_data_retention_enabled, name
FROM sys.databases;
GO

/*Set Data Retention Policy to 90 days*/
Alter Table dbo.DeviceData
SET (DATA_DELETION = On (FILTER_COLUMN = [SourceTimestamp], RETENTION_PERIOD = 90 day))
GO

USE telemetry
GO

/*Confirm Data Retention Policy is set*/
select name, data_retention_period, data_retention_period_unit from sys.tables
GO
