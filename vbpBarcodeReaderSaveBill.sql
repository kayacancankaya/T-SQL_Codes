USE [VITA2023]
GO

/****** Object:  StoredProcedure [dbo].[vbpElTerminaliIrsaliyeKaydet]    Script Date: 6.11.2023 15:52:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


  
  ALTER PROCEDURE [dbo].[vbpElTerminaliIrsaliyeKaydet]  
(  
    @cariKodu nvarchar(35),  
 @kullaniciKodu smallint,  
 @sevkIrsaliyesiNo nvarchar(15)  
  
)  
AS  
BEGIN  

SET NOCOUNT ON;                          
                          
SET XACT_ABORT ON                          
begin try                           
BEGIN TRANSACTION                           
  
  
    INSERT INTO TBLFATUIRS  
    (  
        SUBE_KODU,  
        FTIRSIP,  
        FATIRS_NO,  
        CARI_KODU,  
        TARIH,  
        TIPI,  
  KAYITYAPANKUL,  
  KAYITTARIHI,  
  CARI_KOD2,  
  ISLETME_KODU   
    )   
    VALUES  
    (  
  0   --SUBE_KODU  
 ,3   --FTIRSIP  
 ,@sevkIrsaliyesiNo  --FATIRSNO  
 ,@cariKodu  --CARI_KODU  
   ,FORMAT(GETDATE(), 'yyyy-MM-dd') --TARIH  
   ,2   --tipi  
   ,@kullaniciKodu --kayityapankul  
   ,GETDATE() --kayit_tarihi  
   ,@cariKodu  --cari_kod2  
   ,1   --isleme_kodu  
    );  

INSERT INTO TBLFATUEK    
    (    
        SUBE_KODU,    
        FKOD,    
        FATIRSNO,    
        CKOD    
    )     
    VALUES    
    (    
  0   --SUBE_KODU    
 ,3   --FKOD    
 ,@sevkIrsaliyesiNo  --FATIRSNO    
 ,@cariKodu  --CKOD     
    );    

commit                          
end try                          
begin catch                          
 ROLLBACK                          
 declare @err as varchar(max)                          
 set @err = ERROR_MESSAGE()                          
 RAISERROR (@err, 16, 1)                          
end catch                         
  
END
GO


