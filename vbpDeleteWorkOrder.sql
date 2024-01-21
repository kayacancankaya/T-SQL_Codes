create procedure vbpDeleteIsemri
 @siparisNo nvarchar(15)  
 ,@siparisSira  smallint  
 ,@urunKodu nvarchar(35)  
AS      
begin      
SET NOCOUNT ON;      
      
SET XACT_ABORT ON      
begin try       
BEGIN TRANSACTION      

 declare @count int;
 DECLARE @STOK_KODU NVARCHAR(35);
 DECLARE @ISEMRINO NVARCHAR(15);
 declare @URETIM_FISI NVARCHAR(15);

 select @count = count(*) from TBLISEMRI where TEPESIPNO=@siparisNo and TEPESIPKONT=@siparisSira and TEPEMAM=@urunKodu
 if @count > 0
 begin
	DECLARE sql_cursor CURSOR FOR select stok_kodu,isemrino FROM TBLISEMRI WHERE TEPESIPNO=@siparisNo and TEPESIPKONT=@siparisSira and TEPEMAM=@urunKodu;
	OPEN sql_cursor;
	FETCH NEXT FROM sql_cursor INTO @STOK_KODU,@ISEMRINO
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		FETCH NEXT FROM sql_cursor INTO @STOK_KODU,@ISEMRINO	

		select @count = count(*) from tblstokurs where uretson_mamuL=@STOK_KODU and uretson_sipno=@ISEMRINO
		 if @count > 0
		 begin
			SELECT @URETIM_FISI = URETSON_FISNO FROM TBLSTOKURS WHERE URETSON_MAMUL=@STOK_KODU and uretson_sipno=@ISEMRINO
			delete from tblsthar where fisno=@URETIM_FISI
			delete from tblstokurs where URETSON_MAMUL=@STOK_KODU and uretson_sipno=@ISEMRINO
		 end
		 
		DELETE FROM TBLISEMRIEK WHERE isemri=@ISEMRINO
		delete from tblisemrirec where isemrino = @isemrino
		delete from tblisemri where isemrino=@isemrino
	END;
	CLOSE sql_cursor
	deallocate sql_cursor
 end

commit      
end try      
begin catch      
 ROLLBACK      
 declare @err as varchar(max)      
 set @err = ERROR_MESSAGE()      
 RAISERROR (@err, 16, 1)      
end catch      
end 