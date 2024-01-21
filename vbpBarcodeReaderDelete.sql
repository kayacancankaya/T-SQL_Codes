USE [VITA2023]
GO

/****** Object:  StoredProcedure [dbo].[vbpElTerminaliSevkKayitlariGeriAlSatir]    Script Date: 6.11.2023 15:53:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



     
ALTER procedure [dbo].[vbpElTerminaliSevkKayitlariGeriAlSatir]               
@belgeNo nvarchar(15),              
@fisno nvarchar(15),              
@stra_sipkont int,    
@urunKodu nvarchar(35),    
@okutulanMiktar int
as                             
begin                              
SET NOCOUNT ON;                              
                              
SET XACT_ABORT ON                              
begin try                               
BEGIN TRANSACTION                               
              
declare @count int              
              
select @count = COUNT(*) from TBLSEVKTRA where TIP=3 and SIPNO=@belgeNo and stokkodu=@urunKodu              
if @count > 0              
begin              
delete from TBLSEVKTRA where TIP=3 and SIPNO=@belgeNo and STOKKODU=@urunKodu             
end              
       
    
declare @isemrino nvarchar(15)              
select @count = COUNT(*) from TBLISEMRI where ISEMRINO like 'yuk%' and ACIKLAMA=@belgeNo AND SIPARIS_NO=@fisno AND SIPKONT=@stra_sipkont              
              
if @count > 0              
begin              
 select @isemrino = ISEMRINO from TBLISEMRI where ISEMRINO like 'yuk%' and ACIKLAMA=@belgeNo AND SIPARIS_NO=@fisno AND SIPKONT=@stra_sipkont              
 DELETE FROM TBLISEMRI WHERE ISEMRINO LIKE 'YUK%' AND ACIKLAMA=@belgeNo AND SIPARIS_NO=@fisno AND SIPKONT=@stra_sipkont              
              
 select @count = COUNT(*) FROM sbptUretimSonu where isEmriNo = @isemrino              
              
  if @count > 0              
  begin              
   DELETE FROM sbptUretimSonu where isEmriNo = @isemrino               
  end              
              
 select @count = COUNT(*) from TBLSTOKURS where URETSON_SIPNO = @isemrino              
              
 if @count > 0              
 begin              
  delete from TBLSTOKURS where URETSON_SIPNO = @isemrino              
 end              
              
 select @count = COUNT(*) from TBLSTHAR where STHAR_SIPNUM=@isemrino               
 if @count > 0              
 begin              
  delete from TBLSTHAR where STHAR_SIPNUM=@isemrino              
 end              
end              
              
              
              
select @count = COUNT(*) from TBLSTHAR where fisno like 'SI0%' and STHAR_SIPNUM=@fisno and STRA_SIPKONT=@stra_sipkont and STOK_KODU=@urunKodu               
if @count > 0              
begin             
	delete from TBLSTHAR where fisno like 'SI0%' and STHAR_SIPNUM=@fisno and STRA_SIPKONT=@stra_sipkont and STOK_KODU=@urunKodu       
	
	declare @inckey int
	select top 1 @inckey = inckeyno from TBLSTHAR where fisno like 'SI0%' and STHAR_SIPNUM=@fisno and STRA_SIPKONT=@stra_sipkont and STOK_KODU=@urunKodu      
	delete from TBLKALEMDETAY where REFINCKEYNO=@inckey
end              

DECLARE @yukMikGuncel int
DECLARE @cikisSiparisGuncel int

select @yukMikGuncel = YUKMIK FROM TBLSEVKTRA WHERE TIP=1 and BELGENO=@belgeNo and SIPNO=@fisno and sipkont=@stra_sipkont  
UPDATE TBLSEVKTRA SET YUKMIK= @yukMikGuncel-@okutulanMiktar from tblsevktra where tip=1 and BELGENO=@belgeNo and SIPNO=@fisno and sipkont=@stra_sipkont     

select @cikisSiparisGuncel = FIRMA_DOVTUT FROM TBLSIPATRA WHERE FISNO=@fisno and STRA_SIPKONT=@stra_sipkont AND STHAR_FTIRSIP=6
if @cikisSiparisGuncel>0
begin
	UPDATE TBLSIPATRA SET FIRMA_DOVTUT= @cikisSiparisGuncel-@okutulanMiktar FROM TBLSIPATRA WHERE FISNO=@fisno and STRA_SIPKONT=@stra_sipkont AND STHAR_FTIRSIP=6 
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
GO


