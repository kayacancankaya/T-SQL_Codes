
create PROCEDURE [dbo].[vbpInsertIsemri]   
  @siparisNo nvarchar(15)  
 ,@siparisSira  smallint  
 ,@siparisMiktar  int  
 ,@aciklama nvarchar(800)  
 ,@user nvarchar(12)  
 ,@urunKodu nvarchar(35)  
 ,@count int  
 ,@teslimTarihi datetime  
AS      
begin      
SET NOCOUNT ON;      
      
SET XACT_ABORT ON      
begin try       
BEGIN TRANSACTION      
  
  
declare @tarih datetime  
declare @isemrino nvarchar(15)  
DECLARE @ResultTable TABLE (isemrino nvarchar(15));  
declare @refisemrino nvarchar(15)  
declare @tepemam nvarchar(35)  
declare @serino nvarchar(50)  
declare @ustIsemri nvarchar(15)  
declare @ieMiktar int  
declare @mamulKodu nvarchar(35)  
declare @hamKodu nvarchar(35)  
declare @previousIsemrino nvarchar(15)  
declare @mamulIsemrino nvarchar(15)  
  
INSERT INTO @ResultTable (isemrino)  
EXEC vbpGetFisno 'IE', 'TBLISEMRI', 'ISEMRINO';  
  
SELECT @refisemrino = isemrino FROM @ResultTable;  
if (@refisemrino is null)  
begin  
set @refisemrino='IE0000000000001'  
end;  
  
IF OBJECT_ID('dbo.vbtTopluIsemriAcTemp', 'U') IS NOT NULL DROP TABLE dbo.vbtTopluIsemriAcTemp;   
  
WITH urunAgaciCTE AS (  
    SELECT  
        MAMUL_KODU,  
        @siparisMiktar AS miktar,  
        sabitMamul.DEPO_KODU AS girisDepoKodu,  
        sabitHam.DEPO_KODU AS cikisDepoKodu,  
        HAM_KODU,  
        MAMUL_KODU  as ustMamul,  
        1 AS Seviye  
    FROM  
        TBLSTOKURM urm  
        INNER JOIN TBLSTSABIT sabitMamul ON urm.mamul_kodu = sabitMamul.STOK_KODU  
        INNER JOIN TBLSTSABIT sabitHam ON urm.mamul_kodu = sabitHam.STOK_KODU  
    WHERE  
        MAMUL_KODU = @urunKodu  
  
    UNION ALL  
  
    SELECT  
        ua.HAM_KODU,  
        CAST(ISNULL(ua.MIKTAR, 0) AS INT) * @siparisMiktar AS miktar,  
        sabitMamul.DEPO_KODU AS girisDepoKodu,  
        sabitHam.DEPO_KODU AS cikisDepoKodu,  
        urm.HAM_KODU,  
        ua.MAMUL_KODU  as ustMamul,  
        ua.Seviye + 1  
      
    FROM  
        TBLSTOKURM urm  
        INNER JOIN urunAgaciCTE ua ON ua.HAM_KODU = urm.MAMUL_KODU    
        INNER JOIN TBLSTSABIT sabitMamul ON urm.mamul_kodu = sabitMamul.STOK_KODU  
        INNER JOIN TBLSTSABIT sabitHam ON urm.mamul_kodu = sabitHam.STOK_KODU  
     
)  
  
SELECT DISTINCT  
 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS ID,  
  Cast('' as nvarchar(15)) as ISEMRINO  
 ,format(GETDATE(),'yyyy-MM-dd') as tarih  
    ,MAMUL_KODU AS STOK_KODU  
    ,miktar AS MIKTAR  
 ,@aciklama as ACIKLAMA  
 ,@teslimTarihi AS TESLIM_TARIHI  
 ,@siparisNo as SIPARIS_NO  
 ,'H' as KAPALI  
 ,cast(Seviye as nvarchar(80)) AS YEDEK1  
 ,ustMamul as YEDEK2  
 ,'' as YEDEK3 --ustmamul isemrino  
 ,@refisemrino AS REFISEMRINO  
 ,@user AS KAYITYAPANKUL  
 ,GETDATE() AS KAYITTARIHI  
 ,@siparisSira AS SIPKONT  
 ,@urunKodu AS TEPEMAM  
 ,@siparisNo as TEPESIPNO  
 ,@siparisSira AS TEPESIPKONT  
    ,girisDepoKodu AS DEPO_KODU  
    ,'' AS SERINO  
 ,cikisDepoKodu AS CIKIS_DEPO_KODU  
    ,'Y' AS USK_STATUS  
    ,'Y' AS REZERVASYON_STATUS  
into vbtTopluIsemriAcTemp  
FROM  
  urunAgaciCTE  
   
GROUP BY  
    MAMUL_KODU, girisDepoKodu, cikisDepoKodu, miktar,Seviye,ustMamul  
   
 update vbtTopluIsemriAcTemp set ISEMRINO=@refisemrino WHERE cast(YEDEK1 as int)=1  
   
  
declare @seviye int ;  
declare @nextSeviye int;  
declare @maxSeviye int = 0;  
select @maxSeviye = max(cast(YEDEK1 as int)) from vbtTopluIsemriAcTemp  
  
  
declare @seviyeSira int = 1  
declare @seviyeAdet int  
declare @rowNumber int  
select @seviyeAdet = count(cast(yedek1 as int)) from vbtTopluIsemriAcTemp where cast(YEDEK1 as int) = 2  
  
 WHILE @seviyeSira<=@seviyeAdet   
 begin  
 set @seviye=2  
  declare @id int;  
  
  with cte as (select ROW_NUMBER() over(order by stok_kodu) as sira ,id,STOK_KODU from vbtTopluIsemriAcTemp where cast(YEDEK1 as int) =@seviye )  
  select @id = id from cte where sira=@seviyeSira;  
    
  INSERT INTO @ResultTable (isemrino)  
  EXEC vbpGetFisno 'IE', 'vbtTopluIsemriAcTemp', 'ISEMRINO';  
    
  SELECT @isemrino = isemrino FROM @ResultTable;  
  select top 1 @previousIsemrino = ISEMRINO from vbtTopluIsemriAcTemp order by isemrino desc  
  
  update vbtTopluIsemriAcTemp set ISEMRINO=@isemrino, yedek3=@refisemrino,SERINO=@previousIsemrino where id=@id   
  
  declare @seviyeSiraSub int  
  declare @seviyeAdetSub int;  
     
   while @seviye < @maxSeviye  
   begin  
      
    if (@seviye=2)   
    begin  
     with cte as (select ROW_NUMBER() over(order by stok_kodu) as sira ,id,STOK_KODU from vbtTopluIsemriAcTemp where cast(YEDEK1 as int) =@seviye )  
     select @mamulKodu = stok_kodu from cte where sira=@seviyeSira   
    end  
    set @seviye = @seviye + 1  
      
    set @seviyeSiraSub = 1  
    select @seviyeAdetSub = count(cast(yedek1 as int)) from vbtTopluIsemriAcTemp where cast(YEDEK1 as int) = @seviye and yedek2=@mamulKodu  
      
    WHILE @seviyeSiraSub<=@seviyeAdetSub   
    begin  
       
     with cte as (select ROW_NUMBER() over(order by stok_kodu) as sira ,id,STOK_KODU from vbtTopluIsemriAcTemp where cast(YEDEK1 as int) =@seviye and yedek2=@mamulKodu)  
     select @id = id from cte where sira=@seviyeSiraSub  
       
     INSERT INTO @ResultTable (isemrino)  
     EXEC vbpGetFisno 'IE', 'vbtTopluIsemriAcTemp', 'ISEMRINO';  
  
     SELECT @isemrino = isemrino FROM @ResultTable;  
     SELECT top 1 @previousIsemrino = ISEMRINO from vbtTopluIsemriAcTemp order by isemrino desc  
     SELECT @mamulIsemrino = isemrino from vbtTopluIsemriAcTemp where cast(YEDEK1 as int) =@seviye - 1 and STOK_KODU=@mamulKodu  
  
     update vbtTopluIsemriAcTemp set ISEMRINO=@isemrino, yedek3=@mamulIsemrino,SERINO=@previousIsemrino where id=@id   
       
     declare @stokKodu nvarchar(15);  
     with cte as (select ROW_NUMBER() over(order by stok_kodu) as sira ,id,STOK_KODU from vbtTopluIsemriAcTemp where cast(YEDEK1 as int) =@seviye and yedek2=@mamulKodu)  
     select @stokKodu = STOK_KODU from cte where sira=@seviyeSiraSub  
     set @nextSeviye = @seviye + 1  
     IF EXISTS (SELECT 1 FROM vbtTopluIsemriAcTemp WHERE CAST(YEDEK1 AS INT) = @nextSeviye AND YEDEK2 = @stokKodu )  
      BEGIN  
       EXEC vbpIsemriAcRecursiveCheckandUpdate @nextSeviye, @stokKodu;  
      END  
  
     SET @seviyeSiraSub = @seviyeSiraSub + 1;  
    end  
      
   end  
  
  set @seviyeSira=@seviyeSira + 1  
 end  
  
 INSERT INTO tblisemri (  
    ISEMRINO,  
    TARIH,  
    STOK_KODU,  
    MIKTAR,  
    ACIKLAMA,  
    TESLIM_TARIHI,  
    SIPARIS_NO,  
    KAPALI,  
    YEDEK1,--SEVIYE  
    YEDEK2,--USTMAMUL  
    YEDEK3,--USTMAMULISEMRINO  
    REFISEMRINO,  
    KAYITYAPANKUL,  
    KAYITTARIHI,  
    SIPKONT,  
    TEPEMAM,  
    TEPESIPNO,  
    TEPESIPKONT,  
    DEPO_KODU,  
    SERINO,--ONCEKI ISEMRINO  
    CIKIS_DEPO_KODU,  
    USK_STATUS,  
    REZERVASYON_STATUS  
)  
SELECT  
    ISEMRINO,  
    TARIH,  
    STOK_KODU,  
    MIKTAR,  
    ACIKLAMA,  
    TESLIM_TARIHI,  
    SIPARIS_NO,  
    KAPALI,  
    YEDEK1,  
    YEDEK2,  
    YEDEK3,  
    REFISEMRINO,  
    KAYITYAPANKUL,  
    KAYITTARIHI,  
    SIPKONT,  
    TEPEMAM,  
    TEPESIPNO,  
    TEPESIPKONT,  
    DEPO_KODU,  
    SERINO,  
    CIKIS_DEPO_KODU,  
    USK_STATUS,  
    REZERVASYON_STATUS  
FROM  
    vbtTopluIsemriAcTemp;  
  

   
 INSERT INTO TBLISEMRIREC (
 ISEMRINO
,MAMUL_KODU
,HAM_KODU
,MIKTAR
,KAYIT_TARIHI
,GEC_FLAG
,BASLANGIC_TARIHI
,OPNO
,DEPO_KODU
,BILESEN_ALTERNATIF_KODU
,MALIYET_YUZDESI
) 
  select 
  ieTemp.ISEMRINO
  ,ieTemp.stok_kodu as MAMUL_KODU
  ,urm.HAM_KODU
  ,urm.MIKTAR
  ,getdate() as KAYIT_TARIHI
  ,'0'
  ,GETDATE() as BASLANGIC_TARIHI
  ,urm.OPNO
  ,ieTemp.CIKIS_DEPO_KODU
  ,'0'
  ,'0'
  from vbtTopluIsemriAcTemp ieTemp (nolock)
  left join tblstokurm (nolock) urm on ieTemp.STOK_KODU = urm.MAMUL_KODU
  
IF OBJECT_ID('dbo.vbtTopluIsemriAcTemp', 'U') IS NOT NULL DROP TABLE dbo.vbtTopluIsemriAcTemp;   
 
commit      
end try      
begin catch      
 ROLLBACK      
 declare @err as varchar(max)      
 set @err = ERROR_MESSAGE()      
 RAISERROR (@err, 16, 1)      
end catch      
end 