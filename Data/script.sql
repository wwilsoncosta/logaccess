USE [LocalDB]
GO
/****** Object:  Table [dbo].[LogAcesso]    Script Date: 05/11/2023 09:55:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LogAcesso](
	[LogAcessoId] [int] IDENTITY(1,1) NOT NULL,
	[UsuarioId] [int] NOT NULL,
	[DataHoraAcesso] [datetime] NOT NULL,
	[EnderecoIp] [varchar](50) NULL,
 CONSTRAINT [PK_LogAcesso1] PRIMARY KEY CLUSTERED 
(
	[LogAcessoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Usuarios]    Script Date: 05/11/2023 09:55:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Usuarios](
	[UsuarioId] [int] IDENTITY(1,1) NOT NULL,
	[Nome] [varchar](100) NULL,
	[Login] [varchar](50) NULL,
	[Senha] [varchar](50) NULL,
	[IsAdmin] [bit] NULL,
	[deleted] [int] NULL,
 CONSTRAINT [PK_Usuario] PRIMARY KEY CLUSTERED 
(
	[UsuarioId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Usuarios] ADD  DEFAULT ((0)) FOR [deleted]
GO
ALTER TABLE [dbo].[LogAcesso]  WITH CHECK ADD  CONSTRAINT [FK_UsuarioId] FOREIGN KEY([UsuarioId])
REFERENCES [dbo].[Usuarios] ([UsuarioId])
GO
ALTER TABLE [dbo].[LogAcesso] CHECK CONSTRAINT [FK_UsuarioId]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetLogAccess]    Script Date: 05/11/2023 09:55:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Wilson Chaveiro 
-- Create date: 02-11-2023
-- Description: Proc responsável por listar os acessos de um usuário caso seja informado
-- =============================================


CREATE PROCEDURE [dbo].[SP_GetLogAccess]
    @UsuarioId int = 0
AS   

    SET NOCOUNT ON;  

	if @UsuarioId = 0
	BEGIN

		SELECT  U.Nome, 
				L.EnderecoIp, 
				L.DataHoraAcesso,
				U.UsuarioId
		FROM [dbo].[LogAcesso] AS L
		INNER JOIN [dbo].[Usuarios] AS U ON L.UsuarioId = U.UsuarioId
		ORDER BY L.DataHoraAcesso
	END
	ELSE
		SELECT  U.Nome, 
				L.EnderecoIp, 
				L.DataHoraAcesso,
				U.UsuarioId
		FROM [dbo].[LogAcesso] AS L
		INNER JOIN [dbo].[Usuarios] AS U ON L.UsuarioId = U.UsuarioId
		WHERE L.UsuarioId = @UsuarioId
		ORDER BY L.DataHoraAcesso
GO
/****** Object:  StoredProcedure [dbo].[SP_LogAccess]    Script Date: 05/11/2023 09:55:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Wilson Chaveiro 
-- Create date: 02-11-2023
-- Description: Proc responsável por cadastrar os acessos do usuário
-- =============================================


CREATE PROCEDURE [dbo].[SP_LogAccess]
(
@UsuarioId int=null,
@EnderecoIp varchar(50)=null
)
AS
BEGIN 
 SET NOCOUNT ON  
		INSERT INTO [dbo].[LogAcesso] 
		([UsuarioId],[EnderecoIp],[DataHoraAcesso])
		VALUES(
			@UsuarioId ,
			@EnderecoIp,
			GETDATE()
		)
END
GO
