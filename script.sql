USE [master]
GO
/****** Object:  Database [GestHostelDb]    Script Date: 17/03/2017 16:39:37 ******/
CREATE DATABASE [GestHostelDb]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'GestHostelDb', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.WADSQL\MSSQL\DATA\GestHostelDb.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'GestHostelDb_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.WADSQL\MSSQL\DATA\GestHostelDb_log.ldf' , SIZE = 2048KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [GestHostelDb] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [GestHostelDb].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [GestHostelDb] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [GestHostelDb] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [GestHostelDb] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [GestHostelDb] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [GestHostelDb] SET ARITHABORT OFF 
GO
ALTER DATABASE [GestHostelDb] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [GestHostelDb] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [GestHostelDb] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [GestHostelDb] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [GestHostelDb] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [GestHostelDb] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [GestHostelDb] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [GestHostelDb] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [GestHostelDb] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [GestHostelDb] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [GestHostelDb] SET  DISABLE_BROKER 
GO
ALTER DATABASE [GestHostelDb] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [GestHostelDb] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [GestHostelDb] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [GestHostelDb] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [GestHostelDb] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [GestHostelDb] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [GestHostelDb] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [GestHostelDb] SET RECOVERY FULL 
GO
ALTER DATABASE [GestHostelDb] SET  MULTI_USER 
GO
ALTER DATABASE [GestHostelDb] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [GestHostelDb] SET DB_CHAINING OFF 
GO
ALTER DATABASE [GestHostelDb] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [GestHostelDb] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'GestHostelDb', N'ON'
GO
USE [GestHostelDb]
GO
/****** Object:  StoredProcedure [dbo].[GetAllInfosForRoom]    Script Date: 17/03/2017 16:39:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Michaël Person
-- Create date: 15/03/2017
-- Description:	Permet d'obtenir toutes les infos nécessaires sur une chambre
-- =============================================
CREATE PROCEDURE [dbo].[GetAllInfosForRoom]
	@idChambre int
AS
BEGIN
	SELECT        Chambre.IdChambre, Chambre.Nom, Chambre.DescCourte, Chambre.DescLongue, Chambre.Capacite, Chambre.NbWc, Chambre.NbSdb, Chambre.Prix, Chambre.EsTSupprimer, AvisClient.Note, AvisClient.DateNote,                     AvisClient.Approuve,  Hostel.Nom AS NomHotel, Hostel.Etoiles, Hostel.Rue, Hostel.Numero, Hostel.CodePostal, Hostel.Ville, Hostel.Pays, Hostel.Latitude,Hostel.Longitude, Hostel.Email, Hostel.NombreChambres, Hostel.Photo as PhotoHotel, Photo.Url as PhotoChambre, Reservation.DateDeb, Reservation.DateFin, Reservation.NbPers, Reservation.IdReservation,Service.Libelle, Service.icone, TypeChambre.Libelle AS TypeDeChambre
FROM            Chambre LEFT JOIN
                         ChambrePhoto ON Chambre.IdChambre = ChambrePhoto.IdChambre LEFT JOIN
                         AvisClient ON Chambre.IdChambre = AvisClient.IdChambre LEFT JOIN
                         Hostel ON Chambre.IdHostel = Hostel.IdHostel LEFT JOIN
                         Photo ON ChambrePhoto.IdPhoto = Photo.IdPhoto LEFT JOIN
                         Reservation ON Chambre.IdChambre = Reservation.IdChambre LEFT JOIN
                         ServiceChambre ON Chambre.IdChambre = ServiceChambre.IdChambre LEFT JOIN
                         Service ON ServiceChambre.IdService = Service.IdService LEFT JOIN
                         TypeChambre ON Chambre.IdType = TypeChambre.IdType
						 Where Chambre.IdChambre=@idChambre
END

GO
/****** Object:  StoredProcedure [dbo].[GetAvaibleRooms]    Script Date: 17/03/2017 16:39:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Michaël Person
-- Create date: 15/03/2017
-- Description:	Permet d'obtenir les chambres disponbles entre deux dates
-- =============================================
Create PROCEDURE [dbo].[GetAvaibleRooms]
	@Deb datetime,
	@Fin datetime
AS
BEGIN
	SELECT         dbo.Chambre.IdChambre
FROM            dbo.Chambre LEFT OUTER JOIN
                         dbo.Reservation ON dbo.Chambre.IdChambre = dbo.Reservation.IdChambre
WHERE        
(Reservation.DateDeb<@Deb and Reservation.DateFin<@Fin)
OR (Reservation.DateDeb> @Fin)
OR Reservation.DateDeb is null

END

GO
/****** Object:  StoredProcedure [dbo].[GetReservationForClient]    Script Date: 17/03/2017 16:39:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Michaël Person
-- Create date: 15/03/2017
-- Description:	Permet d'obtenir toutes les réservations en cours d'un client
-- =============================================
CREATE PROCEDURE [dbo].[GetReservationForClient]
	@idClient int
AS
BEGIN
	select * from Reservation
	where IdClient =@idClient
	and DateDeb<= GETDATE() and DateFin>=GETDATE()
END

GO
/****** Object:  StoredProcedure [dbo].[GetRoomsFromHostel]    Script Date: 17/03/2017 16:39:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Michaël Person
-- Create date: 15/03/2017
-- Description:	Permet d'obtenir toutes les chambres d'un hotel
-- =============================================
CREATE PROCEDURE [dbo].[GetRoomsFromHostel]
	@idHostel int
AS
BEGIN
	Select * from Chambre
	where IdHostel= @idHostel
END

GO
/****** Object:  Table [dbo].[AvisClient]    Script Date: 17/03/2017 16:39:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AvisClient](
	[IdAvis] [int] IDENTITY(1,1) NOT NULL,
	[Note] [int] NOT NULL,
	[DateNote] [datetime] NOT NULL,
	[IdClient] [int] NOT NULL,
	[IdChambre] [int] NOT NULL,
	[Approuve] [bit] NULL,
	[Commentaire] [varchar](max) NULL,
 CONSTRAINT [PK_AvisClient] PRIMARY KEY CLUSTERED 
(
	[IdAvis] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Chambre]    Script Date: 17/03/2017 16:39:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Chambre](
	[IdChambre] [int] IDENTITY(1,1) NOT NULL,
	[Nom] [nvarchar](50) NOT NULL,
	[DescCourte] [nvarchar](50) NOT NULL,
	[DescLongue] [ntext] NOT NULL,
	[IdHostel] [int] NOT NULL,
	[IdType] [int] NOT NULL,
	[Capacite] [int] NOT NULL,
	[NbWc] [int] NULL,
	[NbSdb] [int] NULL,
	[Prix] [float] NOT NULL,
	[EsTSupprimer] [bit] NULL,
 CONSTRAINT [PK_Chambre] PRIMARY KEY CLUSTERED 
(
	[IdChambre] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ChambrePhoto]    Script Date: 17/03/2017 16:39:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChambrePhoto](
	[IdChambre] [int] NOT NULL,
	[IdPhoto] [int] NOT NULL,
	[Ordre] [int] NULL,
 CONSTRAINT [PK_ChambrePhoto_1] PRIMARY KEY CLUSTERED 
(
	[IdChambre] ASC,
	[IdPhoto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Client]    Script Date: 17/03/2017 16:39:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Client](
	[IdClient] [int] IDENTITY(1,1) NOT NULL,
	[Nom] [nvarchar](250) NOT NULL,
	[Prenom] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](256) NOT NULL,
	[Tel] [nvarchar](50) NOT NULL,
	[Pseudo] [nvarchar](50) NOT NULL,
	[MotDePasse] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Client] PRIMARY KEY CLUSTERED 
(
	[IdClient] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DedicatedConnexion]    Script Date: 17/03/2017 16:39:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DedicatedConnexion](
	[IdAdmin] [int] IDENTITY(1,1) NOT NULL,
	[Login] [nchar](5) NOT NULL,
	[Password] [nchar](8) NOT NULL,
 CONSTRAINT [PK_DedicatedConnexion] PRIMARY KEY CLUSTERED 
(
	[IdAdmin] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Hostel]    Script Date: 17/03/2017 16:39:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Hostel](
	[IdHostel] [int] IDENTITY(1,1) NOT NULL,
	[Nom] [nvarchar](50) NOT NULL,
	[Etoiles] [int] NOT NULL,
	[Rue] [nvarchar](50) NOT NULL,
	[Numero] [int] NOT NULL,
	[CodePostal] [nvarchar](10) NOT NULL,
	[Ville] [nvarchar](50) NOT NULL,
	[Pays] [nvarchar](50) NOT NULL,
	[Latitude] [decimal](9, 6) NULL,
	[Longitude] [decimal](9, 6) NULL,
	[Email] [nvarchar](256) NOT NULL,
	[NombreChambres] [int] NOT NULL,
	[Photo] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Hostel] PRIMARY KEY CLUSTERED 
(
	[IdHostel] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Photo]    Script Date: 17/03/2017 16:39:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Photo](
	[IdPhoto] [int] IDENTITY(1,1) NOT NULL,
	[Url] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_ChambrePhoto] PRIMARY KEY CLUSTERED 
(
	[IdPhoto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Prix]    Script Date: 17/03/2017 16:39:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Prix](
	[AssuranceAnnulation] [float] NOT NULL,
	[TaxeSejour] [float] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Reservation]    Script Date: 17/03/2017 16:39:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reservation](
	[IdChambre] [int] NOT NULL,
	[IdClient] [int] NOT NULL,
	[DateDeb] [datetime] NOT NULL,
	[DateFin] [datetime] NOT NULL,
	[NbPers] [int] NOT NULL,
	[IdReservation] [int] IDENTITY(1,1) NOT NULL,
	[AssuranceAnnulation] [bit] NOT NULL,
 CONSTRAINT [PK_Reservation] PRIMARY KEY CLUSTERED 
(
	[IdReservation] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Service]    Script Date: 17/03/2017 16:39:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Service](
	[IdService] [int] IDENTITY(1,1) NOT NULL,
	[Libelle] [nvarchar](250) NOT NULL,
	[icone] [nvarchar](30) NOT NULL,
 CONSTRAINT [PK_Service] PRIMARY KEY CLUSTERED 
(
	[IdService] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ServiceChambre]    Script Date: 17/03/2017 16:39:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ServiceChambre](
	[IdChambre] [int] NOT NULL,
	[IdService] [int] NOT NULL,
 CONSTRAINT [PK_ServiceChambre] PRIMARY KEY CLUSTERED 
(
	[IdChambre] ASC,
	[IdService] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ServiceHostel]    Script Date: 17/03/2017 16:39:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ServiceHostel](
	[IdHostel] [int] NOT NULL,
	[IdService] [int] NOT NULL,
 CONSTRAINT [PK_ServiceHostel] PRIMARY KEY CLUSTERED 
(
	[IdHostel] ASC,
	[IdService] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TypeChambre]    Script Date: 17/03/2017 16:39:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TypeChambre](
	[IdType] [int] IDENTITY(1,1) NOT NULL,
	[Libelle] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_TypeChambre] PRIMARY KEY CLUSTERED 
(
	[IdType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  View [dbo].[5LastAvaibleRooms]    Script Date: 17/03/2017 16:39:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[5LastAvaibleRooms]
AS
SELECT        TOP (5) dbo.Chambre.IdChambre, dbo.Chambre.Nom, dbo.Chambre.DescCourte, dbo.Chambre.DescLongue, dbo.Chambre.IdHostel, dbo.Chambre.IdType, dbo.Chambre.Capacite, dbo.Chambre.NbWc, 
                         dbo.Chambre.NbSdb, dbo.Chambre.Prix, dbo.Chambre.EsTSupprimer, dbo.Reservation.IdChambre AS Expr1, dbo.Reservation.IdClient, dbo.Reservation.DateDeb, dbo.Reservation.DateFin, 
                         dbo.Reservation.NbPers, dbo.Reservation.IdReservation
FROM            dbo.Chambre LEFT OUTER JOIN
                         dbo.Reservation ON dbo.Chambre.IdChambre = dbo.Reservation.IdChambre
WHERE        (MONTH(dbo.Reservation.DateDeb) > MONTH(GETDATE())) OR
                         (dbo.Reservation.DateFin >= GETDATE()) OR
                         (dbo.Reservation.DateDeb IS NULL)

GO
/****** Object:  View [dbo].[BestRooms]    Script Date: 17/03/2017 16:39:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[BestRooms]
AS
SELECT        dbo.Chambre.IdChambre, dbo.Chambre.Nom, dbo.Chambre.DescCourte, dbo.Chambre.DescLongue, dbo.Chambre.IdHostel, dbo.Chambre.IdType, dbo.Chambre.Capacite, dbo.Chambre.NbWc, dbo.Chambre.NbSdb, 
                         dbo.Chambre.Prix, dbo.Chambre.EsTSupprimer, dbo.AvisClient.IdAvis, dbo.AvisClient.Note, dbo.AvisClient.DateNote, dbo.AvisClient.IdClient, dbo.AvisClient.IdChambre AS Expr1, dbo.AvisClient.Approuve
FROM            dbo.Chambre INNER JOIN
                         dbo.AvisClient ON dbo.Chambre.IdChambre = dbo.AvisClient.IdChambre
WHERE        (dbo.Chambre.IdChambre IN
                             (SELECT        IdChambre
                               FROM            dbo.AvisClient AS ac
                               GROUP BY IdChambre
                               HAVING         (AVG(Note) > 6)))

GO
/****** Object:  View [dbo].[RoomsByCountry]    Script Date: 17/03/2017 16:39:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[RoomsByCountry]
AS
SELECT        TOP (100) PERCENT dbo.Chambre.IdChambre, dbo.Chambre.Nom, dbo.Chambre.DescCourte, dbo.Chambre.DescLongue, dbo.Chambre.IdHostel, dbo.Chambre.IdType, dbo.Chambre.Capacite, dbo.Chambre.NbWc, 
                         dbo.Chambre.NbSdb, dbo.Chambre.Prix, dbo.Chambre.EsTSupprimer
FROM            dbo.Chambre INNER JOIN
                         dbo.Hostel ON dbo.Chambre.IdHostel = dbo.Hostel.IdHostel
ORDER BY dbo.Hostel.Pays

GO
ALTER TABLE [dbo].[AvisClient] ADD  CONSTRAINT [DF_AvisClient_DateNote]  DEFAULT (getdate()) FOR [DateNote]
GO
ALTER TABLE [dbo].[AvisClient] ADD  CONSTRAINT [DF_AvisClient_Approuve]  DEFAULT ((0)) FOR [Approuve]
GO
ALTER TABLE [dbo].[Chambre] ADD  CONSTRAINT [DF_Chambre_EsTSupprimer]  DEFAULT ((0)) FOR [EsTSupprimer]
GO
ALTER TABLE [dbo].[ChambrePhoto] ADD  CONSTRAINT [DF_ChambrePhoto_Ordre]  DEFAULT ((0)) FOR [Ordre]
GO
ALTER TABLE [dbo].[Reservation] ADD  CONSTRAINT [DF_Reservation_AssuranceAnnulation]  DEFAULT ((0)) FOR [AssuranceAnnulation]
GO
ALTER TABLE [dbo].[AvisClient]  WITH CHECK ADD  CONSTRAINT [FK_AvisClient_Chambre] FOREIGN KEY([IdChambre])
REFERENCES [dbo].[Chambre] ([IdChambre])
GO
ALTER TABLE [dbo].[AvisClient] CHECK CONSTRAINT [FK_AvisClient_Chambre]
GO
ALTER TABLE [dbo].[AvisClient]  WITH CHECK ADD  CONSTRAINT [FK_AvisClient_Client] FOREIGN KEY([IdClient])
REFERENCES [dbo].[Client] ([IdClient])
GO
ALTER TABLE [dbo].[AvisClient] CHECK CONSTRAINT [FK_AvisClient_Client]
GO
ALTER TABLE [dbo].[Chambre]  WITH CHECK ADD  CONSTRAINT [FK_Chambre_Hostel] FOREIGN KEY([IdHostel])
REFERENCES [dbo].[Hostel] ([IdHostel])
GO
ALTER TABLE [dbo].[Chambre] CHECK CONSTRAINT [FK_Chambre_Hostel]
GO
ALTER TABLE [dbo].[Chambre]  WITH CHECK ADD  CONSTRAINT [FK_Chambre_TypeChambre] FOREIGN KEY([IdType])
REFERENCES [dbo].[TypeChambre] ([IdType])
GO
ALTER TABLE [dbo].[Chambre] CHECK CONSTRAINT [FK_Chambre_TypeChambre]
GO
ALTER TABLE [dbo].[ChambrePhoto]  WITH CHECK ADD  CONSTRAINT [FK_ChambrePhoto_Chambre] FOREIGN KEY([IdChambre])
REFERENCES [dbo].[Chambre] ([IdChambre])
GO
ALTER TABLE [dbo].[ChambrePhoto] CHECK CONSTRAINT [FK_ChambrePhoto_Chambre]
GO
ALTER TABLE [dbo].[ChambrePhoto]  WITH CHECK ADD  CONSTRAINT [FK_ChambrePhoto_Photo] FOREIGN KEY([IdPhoto])
REFERENCES [dbo].[Photo] ([IdPhoto])
GO
ALTER TABLE [dbo].[ChambrePhoto] CHECK CONSTRAINT [FK_ChambrePhoto_Photo]
GO
ALTER TABLE [dbo].[Reservation]  WITH CHECK ADD  CONSTRAINT [FK_Reservation_Chambre] FOREIGN KEY([IdChambre])
REFERENCES [dbo].[Chambre] ([IdChambre])
GO
ALTER TABLE [dbo].[Reservation] CHECK CONSTRAINT [FK_Reservation_Chambre]
GO
ALTER TABLE [dbo].[Reservation]  WITH CHECK ADD  CONSTRAINT [FK_Reservation_Client] FOREIGN KEY([IdClient])
REFERENCES [dbo].[Client] ([IdClient])
GO
ALTER TABLE [dbo].[Reservation] CHECK CONSTRAINT [FK_Reservation_Client]
GO
ALTER TABLE [dbo].[ServiceChambre]  WITH CHECK ADD  CONSTRAINT [FK_ServiceChambre_Chambre] FOREIGN KEY([IdChambre])
REFERENCES [dbo].[Chambre] ([IdChambre])
GO
ALTER TABLE [dbo].[ServiceChambre] CHECK CONSTRAINT [FK_ServiceChambre_Chambre]
GO
ALTER TABLE [dbo].[ServiceChambre]  WITH CHECK ADD  CONSTRAINT [FK_ServiceChambre_Service] FOREIGN KEY([IdService])
REFERENCES [dbo].[Service] ([IdService])
GO
ALTER TABLE [dbo].[ServiceChambre] CHECK CONSTRAINT [FK_ServiceChambre_Service]
GO
ALTER TABLE [dbo].[ServiceHostel]  WITH CHECK ADD  CONSTRAINT [FK_ServiceHostel_Hostel] FOREIGN KEY([IdHostel])
REFERENCES [dbo].[Hostel] ([IdHostel])
GO
ALTER TABLE [dbo].[ServiceHostel] CHECK CONSTRAINT [FK_ServiceHostel_Hostel]
GO
ALTER TABLE [dbo].[ServiceHostel]  WITH CHECK ADD  CONSTRAINT [FK_ServiceHostel_Service] FOREIGN KEY([IdService])
REFERENCES [dbo].[Service] ([IdService])
GO
ALTER TABLE [dbo].[ServiceHostel] CHECK CONSTRAINT [FK_ServiceHostel_Service]
GO
ALTER TABLE [dbo].[AvisClient]  WITH CHECK ADD  CONSTRAINT [CK_AvisClient_note] CHECK  (([Note]>=(0) AND [Note]<=(10)))
GO
ALTER TABLE [dbo].[AvisClient] CHECK CONSTRAINT [CK_AvisClient_note]
GO
ALTER TABLE [dbo].[Chambre]  WITH CHECK ADD  CONSTRAINT [CK_Chambre_capacite] CHECK  (([Capacite]>(0) AND [Capacite]<=(10)))
GO
ALTER TABLE [dbo].[Chambre] CHECK CONSTRAINT [CK_Chambre_capacite]
GO
ALTER TABLE [dbo].[Chambre]  WITH CHECK ADD  CONSTRAINT [CK_Chambre_Prix] CHECK  (([Prix]>(0)))
GO
ALTER TABLE [dbo].[Chambre] CHECK CONSTRAINT [CK_Chambre_Prix]
GO
ALTER TABLE [dbo].[Chambre]  WITH CHECK ADD  CONSTRAINT [CK_Chambre_Sdb] CHECK  (([NbSdb]>=(0)))
GO
ALTER TABLE [dbo].[Chambre] CHECK CONSTRAINT [CK_Chambre_Sdb]
GO
ALTER TABLE [dbo].[Chambre]  WITH CHECK ADD  CONSTRAINT [CK_Chambre_WC] CHECK  (([NbWC]>=(0)))
GO
ALTER TABLE [dbo].[Chambre] CHECK CONSTRAINT [CK_Chambre_WC]
GO
ALTER TABLE [dbo].[Hostel]  WITH CHECK ADD  CONSTRAINT [CK_Hostel_Etoiles] CHECK  (([Etoiles]>=(0) AND [Etoiles]<=(5)))
GO
ALTER TABLE [dbo].[Hostel] CHECK CONSTRAINT [CK_Hostel_Etoiles]
GO
ALTER TABLE [dbo].[Hostel]  WITH CHECK ADD  CONSTRAINT [CK_Hostel_nbChambres] CHECK  (([NombreChambres]>=(1)))
GO
ALTER TABLE [dbo].[Hostel] CHECK CONSTRAINT [CK_Hostel_nbChambres]
GO
ALTER TABLE [dbo].[Hostel]  WITH CHECK ADD  CONSTRAINT [CK_Hostel_Numero] CHECK  (([Numero]>(0)))
GO
ALTER TABLE [dbo].[Hostel] CHECK CONSTRAINT [CK_Hostel_Numero]
GO
ALTER TABLE [dbo].[Reservation]  WITH CHECK ADD  CONSTRAINT [CK_Reservation_dates] CHECK  (([DateDeb]<=[DateFin]))
GO
ALTER TABLE [dbo].[Reservation] CHECK CONSTRAINT [CK_Reservation_dates]
GO
ALTER TABLE [dbo].[Reservation]  WITH CHECK ADD  CONSTRAINT [CK_Reservation_NbPers] CHECK  (([NbPers]>(0) AND [NbPers]<=(10)))
GO
ALTER TABLE [dbo].[Reservation] CHECK CONSTRAINT [CK_Reservation_NbPers]
GO
USE [master]
GO
ALTER DATABASE [GestHostelDb] SET  READ_WRITE 
GO
