USE [VITA2023]
GO
/****** Object:  StoredProcedure [dbo].[vbpYuklemeKayitSatir]    Script Date: 6.11.2023 13:00:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
          
      
ALTER procedure [dbo].[vbpYuklemeKayitSatir]            
  @sevkEmriNo nvarchar(15)            
 ,@sipNo nvarchar(15)            
 ,@sipKont tinyint            
 ,@teslimCari nvarchar(15)            
 ,@sira tinyint            
 ,@miktar int            
 ,@stokKodu nvarchar(35)            
 ,@userId smallint  
 ,@sevkIrsaliyeNo nvarchar(15)  
AS                        
begin                        
SET NOCOUNT ON;                        
                        
SET XACT_ABORT ON                        
begin try                         
BEGIN TRANSACTION                         
            
--sevktra                        
 DECLARE @yuklemeEmriNo nvarchar(15)      
 select @yuklemeEmriNo = belgeno from TBLSEVKMAS where ACIK10=@sevkEmriNo       
        
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
,3   --TIP             
,@yuklemeEmriNo   --BELGE_NO            
,@sevkEmriNo     --SIPNO            
,@sira   --sipkont            
,@teslimCari --TESCARI            
,0       --NAKLIYESEKLI              
,0       --TESLIMATYERI            
,0    --IRSFLAG            
,0   --YUKMIK            
,@sira      --SIRA            
,@miktar --MIKTAR            
,0   --MALFISK            
,0   --MIKTAR2            
,@stokKodu  --STOKKODU            
,90   --DEPO            
,@userId   --KAYITYAPANKUL            
,FORMAT(GETDATE(), 'yyyy-MM-dd') --KAYITTARIHI            
,0            
,0            
,0            
,0            
,0            
)                    
        
     
-------------------------------------sthar-------------------------------            
declare @sthar_NF decimal(28,10)            
declare @dovTip tinyint            
declare @dovFiyat decimal(28,10)            
declare @odeGun smallint            
declare @sthar_kod1 char            
declare @plasiyerKodu nvarchar(8)            
declare @sevkInckey int            
declare @teslimTarih datetime            
declare @vadeTarihi datetime            
declare @fiyatTarihi datetime            
               
SELECT @sthar_NF = isnull(sthar_nf,0) from TBLSIPATRA where FISNO=@sipNo and STRA_SIPKONT=@sipKont and STOK_KODU=@stokKodu            
select @dovTip = isnull(STHAR_DOVTIP,0) from TBLSIPATRA where FISNO=@sipNo and STRA_SIPKONT=@sipKont and STOK_KODU=@stokKodu            
select @dovFiyat = isnull(STHAR_DOVFIAT,0) from TBLSIPATRA where FISNO=@sipNo and STRA_SIPKONT=@sipKont and STOK_KODU=@stokKodu            
select @odeGun = isnull(STHAR_ODEGUN,0) from TBLSIPATRA where FISNO=@sipNo and STRA_SIPKONT=@sipKont and STOK_KODU=@stokKodu            
select @sthar_kod1 = isnull(STHAR_KOD1,'') from TBLSIPATRA where FISNO=@sipNo and STRA_SIPKONT=@sipKont and STOK_KODU=@stokKodu            
select @plasiyerKodu = isnull(STHAR_KOD1,'') from TBLSIPATRA where FISNO=@sipNo and STRA_SIPKONT=@sipKont and STOK_KODU=@stokKodu            
select @sevkInckey = isnull(inckeyno,0) from tblsevktra where SIPNO=@sipNo and SIPKONT=@sipKont and STOKKODU=@stokKodu AND BELGENO = @sevkEmriNo            
select @teslimTarih = isnull(STHAR_TESTAR,'') from TBLSIPATRA where FISNO=@sipNo and STRA_SIPKONT=@sipKont and STOK_KODU=@stokKodu            
SELECT  @vadeTarihi = FORMAT(DATEADD(DAY,@odeGun,GETDATE()), 'yyyy-MM-dd')            
select @fiyatTarihi =  isnull(FIYATTARIHI,'') from TBLSIPATRA where FISNO=@sipNo and STRA_SIPKONT=@sipKont and STOK_KODU=@stokKodu            
            
 INSERT INTO  TBLSTHAR   
 (             
   STOK_KODU    
  ,FISNO     
  ,STHAR_GCMIK            
  ,STHAR_GCMIK2            
  ,CEVRIM            
  ,STHAR_GCKOD            
  ,STHAR_TARIH            
  ,STHAR_NF            
  ,STHAR_BF            
  ,STHAR_KDV            
  ,DEPO_KODU            
  ,STHAR_ACIKLAMA            
  ,STHAR_FTIRSIP            
  ,STHAR_HTUR            
  ,STHAR_DOVTIP            
  ,STHAR_DOVFIAT            
  ,STHAR_ODEGUN            
  ,STHAR_BGTIP            
  ,STHAR_KOD1            
  ,STHAR_SIPNUM            
  ,STHAR_CARIKOD            
  ,SIRA            
  ,STRA_SIPKONT            
  ,AMBAR_KABULNO            
  ,IRSALIYE_NO            
  ,IRSALIYE_TARIH            
  ,STHAR_TESTAR            
  ,OLCUBR            
  ,VADE_TARIHI            
  ,SUBE_KODU            
  ,D_YEDEK10            
  ,FIYATTARIHI            
  ,DUZELTMETARIHI            
  ,ONAYTIPI
  ,EKALAN
 )                       
 VALUES                        
 (               
   @stokKodu  --STOK_KODU    
  ,@sevkIrsaliyeNo     --FISNO     
  ,@miktar   --STHAR_GCMIK            
  ,0    --STHAR_GCMIK2            
  ,0    --CEVRIM            
  ,'C'    --STHAR_GCKOD            
  ,FORMAT(GETDATE(), 'yyyy-MM-dd') --STHAR_tarih               
  ,@sthar_NF  --sthar_nf            
  ,@sthar_NF  --sthar_bf            
  ,10    --STHAR_KDV            
  ,40    --DEPO_KODU            
  ,'120A100104'  --STHAR_ACIKLAMA            
  ,3    --STHAR_FTIRSIP            
  ,'H'    --STHAR_HTUR            
  ,@dovTip   --sthar_dovtip            
  ,@dovFiyat        --sthar_dovfiat            
  ,@odeGun          --sthar_odegun            
  ,'I'    --sthar_bgtip            
  ,@sthar_kod1  --sthar_kod1            
  ,@sipNo   --sthar_sipnum            
  ,@teslimCari  --sthar_carikod            
  ,@sira   --sira            
  ,@sipKont   --stra_sipkont            
  ,@sevkInckey  --ambar_kabulno            
  ,@sevkIrsaliyeNo   --irsaliye_no            
  ,FORMAT(GETDATE(), 'yyyy-MM-dd') --irsaliye_tarih               
  ,@teslimTarih  --sthar_testar            
  ,1    --olcu_br            
  ,@vadeTarihi  --vade_tarihi            
  ,0            
  ,FORMAT(GETDATE(), 'yyyy-MM-dd') --D_YEDEK10              
  ,@fiyatTarihi  --FIYATTARIHI            
  ,GETDATE()  --DUZELTMETARIHI            
  ,'A'    --ONAYTIPI         
  ,@sevkEmriNo --EKALAN
 )          
 
 -----------------------------------kalemDetay----------------------------

 declare @inckey int
 select top 1 @inckey = inckeyno from TBLSTHAR where stok_kodu=@stokKodu and FISNO=@sevkIrsaliyeNo and sthar_sipnum=@sipNo and STRA_SIPKONT=@sipKont 
 if (@inckey is not null)
 begin
	INSERT INTO TBLKALEMDETAY 
	(
		 SUBE_KODU
		,TABLOTIPI
		,REFINCKEYNO
		,STHAR_DOVNF
		,KAYITYAPANKUL
		,KAYITTARIHI
	)
	VALUES
	(
		 0	--SUBE_KODU
		,1	--TABLOTIPI
		,@inckey	--REFINCKEYNO
		,@dovFiyat		--STHAR_DOVNF
		,@userId		--KAYITYAPANKUL
		,GETDATE() --KAYITTARIHI
	)
end
        
-------------------------------------işemri-------------------------------            
            
declare @lastIsemrino nvarchar(15)            
declare @isemrino NVARCHAR(15)            
            
select top 1 @lastIsemriNo = ISEMRINO from TBLISEMRI WHERE ISEMRINO LIKE 'YUK%' order by ISEMRINO desc            
 IF @lastIsemriNo IS NULL            
 BEGIN            
  SET @lastIsemriNo = 'YUK000000000001'             
 END            
 ELSE        
 BEGIN        
 SET @isemrino = dbo.vbfGetNextRefNo(@lastIsemriNo, 'YUK')            
 END        
            
INSERT INTO  TBLISEMRI                        
 (             
   ISEMRINO            
  ,TARIH            
  ,STOK_KODU            
  ,MIKTAR            
  ,ACIKLAMA            
  ,TESLIM_TARIHI            
  ,SIPARIS_NO            
  ,KAPALI            
  ,KAYITYAPANKUL            
  ,KAYITTARIHI            
  ,SIPKONT            
  ,DEPO_KODU            
  ,CIKIS_DEPO_KODU            
  ,USK_STATUS            
  ,REZERVASYON_STATUS            
 )                        
 VALUES                        
 (               
   @isemrino   --ISEMRINO            
  ,FORMAT(GETDATE(), 'yyyy-MM-dd') --TARIH            
  ,@stokKodu   --stok_kodu            
  ,@miktar    --miktar            
  ,@sevkEmriNo   --aciklama            
  ,FORMAT(GETDATE(), 'yyyy-MM-dd') --TESLIM_TARIHI            
  ,@sipNo    --siparis_no            
  ,'H'     --kapali            
  ,@userId     --kayityapankul            
  ,GETDATE()   --kayittarihi            
  ,@sipKont    --sipkont            
  ,40     --depo_kodu            
  ,40     --cikis_depo_kodu            
  ,'Y'     --USK_STATUS            
  ,'Y'     --REZERVASYON_STATUS            
 )                
            
 -------------------------------------ÜRETİM KAYDI-------------------------------            
             
 declare @lastUretimSonuFisno nvarchar(15)            
 declare @uretimSonuFisno nvarchar(15)            
            
             
select top 1 @lastUretimSonuFisno = uretimSonuFisNo from sbptUretimSonu WHERE uretimSonuFisNo LIKE 'usp%' order by uretimSonuFisNo desc            
 IF @lastUretimSonuFisno IS NULL            
 BEGIN            
  SET @lastUretimSonuFisno = 'USP000000000001'             
 END            
 ELSE        
 BEGIN        
 SET @uretimSonuFisno = dbo.vbfGetNextRefNo(@lastUretimSonuFisno, 'USP')            
 END        
        
 INSERT INTO  sbptUretimSonu                        
 (             
   isEmriNo            
  ,stokKodu            
  ,tarih            
  ,girisDepo            
  ,cikisDepo            
  ,uretimMiktari            
  ,seriNo            
  ,uretimSonuFisNo            
  ,kayitTarihi            
  ,aktarildiMi            
  ,hataliMi            
  ,subeKodu            
  ,userID            
 )                        
 VALUES                        
 (               
   @isemrino  --isemrino            
  ,@stokKodu  --stokKodu            
  ,FORMAT(GETDATE(), 'yyyy-MM-dd') --tarih            
  ,40    --girisDepo            
  ,40    --cikisDepo            
  ,@miktar   --uretimMiktari            
  ,'USP'   --seriNo            
  ,@uretimSonuFisno            
  ,GETDATE()  --kayittarihi            
  ,0    --aktarildiMi            
  ,0    --hataliMi            
  ,0    --subeKodu            
  ,@userId    --userID            
 )                
    
 declare @eskiYuklemeMiktari int     
 declare @yukmik int    
 declare @eskiSiparisTeslimMiktar int     
 declare @siparisTeslimMiktar int    
    
 select @eskiYuklemeMiktari = YUKMIK FROM TBLSEVKTRA WHERE BELGENO=@sevkEmriNo AND SIPNO=@sipNo AND SIPKONT=@sipKont and TIP=1    
 set @yukmik = @eskiYuklemeMiktari + @miktar
 select @eskiSiparisTeslimMiktar = FIRMA_DOVTUT FROM TBLSIPATRA WHERE FISNO=@sipNo AND STRA_SIPKONT=@sipKont AND STOK_KODU=@stokKodu    
 set @siparisTeslimMiktar = @eskiSiparisTeslimMiktar + @miktar       
    
 update TBLSEVKTRA set YUKMIK=@yukmik where BELGENO=@sevkEmriNo AND SIPNO=@sipNo AND SIPKONT=@sipKont and TIP=1    
 update TBLISEMRI set USK_STATUS='T' where ISEMRINO=@isemrino    
 UPDATE TBLSIPATRA SET FIRMA_DOVTUT=@siparisTeslimMiktar WHERE FISNO=@sipNo AND STRA_SIPKONT=@sipKont AND STOK_KODU=@stokKodu
    
commit                        
end try                        
begin catch                        
 ROLLBACK                        
 declare @err as varchar(max)                        
 set @err = ERROR_MESSAGE()                        
 RAISERROR (@err, 16, 1)                        
end catch                        
end 