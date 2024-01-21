  
ALTER PROCEDURE vbpInsertSevkEmriSatir   
  @sevkEmriNo nvarchar(15)              
  ,@siparisNo nvarchar(15)              
  ,@siparisSira tinyint              
  ,@teslimCari nvarchar(15)              
  ,@sira tinyint              
  ,@miktar int              
  ,@stokKodu nvarchar(35)              
  ,@userId nvarchar(3)    
  ,@sevkIrsaliyeNo nvarchar(15)  
  ,@urunHacim decimal(18,2)  
  ,@urunAgirlik decimal(18,2)  
AS  
begin  
SET NOCOUNT ON;              
              
SET XACT_ABORT ON              
begin try               
 BEGIN TRANSACTION       
        INSERT INTO  tblsevktra                          
   (               
     SUBE_KODU              
    ,TIP              
    ,BELGENO              
    ,SIPNO              
    ,SIPKONT              
    ,TESCARI               
    ,NAKLIYESEKLI              
    ,TESLIMATYERI              
    ,IRSFLAG              
    ,YUKMIK              
    ,SIRA              
    ,MIKTAR              
    ,MALFISK              
    ,MIKTAR2              
    ,STOKKODU              
    ,DEPO              
    ,KAYITYAPANKUL              
    ,KAYITTARIHI              
    ,I_YEDEK1              
    ,I_YEDEK2              
    ,F_YEDEK1              
    ,F_YEDEK2              
    ,F_YEDEK3              
   )                          
   VALUES                          
   (                 
   0   --SUBE KODU              
  ,1   --TIP               
  ,@sevkEmriNo   --BELGE_NO              
  ,@siparisNo     --SIPNO              
  ,@siparisSira   --sipkont              
  ,@teslimCari --TESCARI              
  ,0       --NAKLIYESEKLI                
  ,0       --TESLIMATYERI              
  ,0  --IRSFLAG              
  ,0  --YUKMIK              
  ,@sira      --SIRA              
  ,@miktar --MIKTAR              
  ,0   --MALFISK              
  ,0   --MIKTAR2              
  ,@stokKodu  --STOKKODU              
  ,90   --DEPO              
  ,@userId --KAYITYAPANKUL              
  ,FORMAT(GETDATE(), 'yyyy-MM-dd') --KAYITTARIHI              
  ,0              
  ,0              
  ,@urunHacim --F_YEDEK1              
  ,@urunAgirlik   --F_YEDEK2           
  ,0              
  )          
 commit              
end try      
BEGIN CATCH  
    ROLLBACK              
  declare @err as varchar(max)              
  set @err = ERROR_MESSAGE()              
  RAISERROR (@err, 16, 1)           
END CATCH;  
END;