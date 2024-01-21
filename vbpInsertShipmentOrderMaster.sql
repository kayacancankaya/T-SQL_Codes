
alter PROCEDURE vbpInsertSevkEmriGenel 
	@sevkEmriNo nvarchar(15),
    @sevkEmriTarihi DateTime,
    @userID nvarchar(3),
    @sevkAciklama NVARCHAR(500),
    @soforIsim NVARCHAR(500),
    @plakaNo NVARCHAR(500),
	@sevkHacim DECIMAL(18,2),
	@sevkAgirlik DECIMAL(18,2)
AS
begin
SET NOCOUNT ON;            
            
SET XACT_ABORT ON            
begin try             
	BEGIN TRANSACTION     
        INSERT INTO  TBLSEVKMAS                        
		 (             
		   SUBE_KODU            
		  ,TIP            
		  ,BELGENO            
		  ,TARIH 
		  ,ACIK1
		  ,KAMYONNO
		  ,UPDATEKODU            
		  ,KAYITYAPANKUL            
		  ,KAYITTARIHI      
		  ,SOFORISIM   
		  ,F_YEDEK1
		  ,F_YEDEK2
		 )    
   
		 VALUES                        
		 (               
		 0   --SUBE KODU            
		,1   --TIP             
		,@sevkEmriNo   --BELGE_NO            
		,@sevkEmriTarihi --TARIH   
		,@sevkAciklama --ACIK1
		,@plakaNo		--KAMYONNO
		,'E'			--UPDATEKODU            
		,@userID		--KAYITYAPANKUL          
		,GETDATE() --KAYITTARIHI            
		,@soforIsim --SOFORISIM      
		,@sevkHacim --F_YEDEK1
		,@sevkAgirlik --F_YEDEK2
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
