  
CREATE PROCEDURE [dbo].[vbpVaryantStokKartiAc]    
       @sablonKod nvarchar(11)    
       ,@varyantKod nvarchar(35)    
       ,@varyantIsim nvarchar(max)    
    ,@identifier nvarchar(max)    
    ,@varyantIngIsim nvarchar(max)    
    ,@kayitYapanKul nvarchar(216)    
AS    
begin    
SET NOCOUNT ON;    
    
SET XACT_ABORT ON    
begin try     
BEGIN TRANSACTION     
--sabit    
 declare @kod_1 as nvarchar(135)    
 declare @kod_2 as nvarchar(135)    
 declare @kod_3 as nvarchar(135)    
 declare @kod_4 as nvarchar(135)    
 declare @kod_5 as nvarchar(135)    
 declare @satici_kodu as nvarchar(235)    
 declare @pay_1 as nvarchar(35)    
 declare @payda_1 as nvarchar(35)    
 declare @pay2 as nvarchar(35)    
 declare @payda2 as nvarchar(35)    
 declare @sat_dov_tip as int    
 declare @muh_detaykodu as int    
 declare @birim_agirlik as float    
 declare @kdv_orani as float    
 declare @alis_dov_tip as int    
 declare @dovtur as int    
 declare @alis_kdv_kodu as float    
 declare @alis_fiat1 as float    
 declare @gumruktarifekodu as nvarchar(max)    
 declare @en float    
 declare @boy float    
 declare @genislik float    
--sabitek    
 declare @kayitTarihi date    
 declare @tur nvarchar(15)    
 declare @kull1n nvarchar(max)    
 declare @kull8n nvarchar(max)    
 declare @kull2s nvarchar(max)    
 declare @kull5s nvarchar(max)    
 declare @kull6s nvarchar(max)    
 declare @kull7s nvarchar(max)    
    
 select @kod_1 = kod_1 from tblstsabit where STOK_KODU=@sablonKod    
 select @kod_2 = kod_2 from tblstsabit where STOK_KODU=@sablonKod    
 select @kod_3 = kod_3 from tblstsabit where STOK_KODU=@sablonKod    
 select @kod_4 = KOD_4 from tblstsabit where STOK_KODU=@sablonKod    
 select @kod_5 = KOD_5 from tblstsabit where STOK_KODU=@sablonKod    
 select @satici_kodu = SATICI_KODU from tblstsabit where STOK_KODU=@sablonKod    
 select @pay_1 = PAY_1 from tblstsabit where STOK_KODU=@sablonKod    
 select @payda_1 = PAYDA_1 from tblstsabit where STOK_KODU=@sablonKod    
 select @pay2 = PAY2 from tblstsabit where STOK_KODU=@sablonKod    
 select @payda2 = PAYDA2 from tblstsabit where STOK_KODU=@sablonKod    
 select @sat_dov_tip = SAT_DOV_TIP from tblstsabit where STOK_KODU=@sablonKod    
 select @birim_agirlik = BIRIM_AGIRLIK from TBLSTSABIT where STOK_KODU=@sablonKod    
 select @kdv_orani = KDV_ORANI from TBLSTSABIT where STOK_KODU=@sablonKod    
 select @dovtur = DOV_TUR from TBLSTSABIT where STOK_KODU=@sablonKod    
 select @alis_kdv_kodu = ALIS_KDV_KODU from TBLSTSABIT where STOK_KODU=@sablonKod    
 select @alis_fiat1 = ALIS_FIAT1 from TBLSTSABIT where STOK_KODU=@sablonKod    
 select @gumruktarifekodu = GUMRUKTARIFEKODU from TBLSTSABIT where STOK_KODU=@sablonKod    
 select @en = EN from TBLSTSABIT where STOK_KODU=@sablonKod    
 select @boy = BOY from TBLSTSABIT where STOK_KODU=@sablonKod    
 select @genislik = GENISLIK from TBLSTSABIT where STOK_KODU=@sablonKod    
--sabitek    
 set @kayitTarihi = GETDATE()    
 select @tur = TUR from TBLSTSABITEK where STOK_KODU=@sablonKod      
 select @kull1n = KULL1N from TBLSTSABITEK where STOK_KODU=@sablonKod      
 select @kull8n = KULL8N from TBLSTSABITEK where STOK_KODU=@sablonKod      
 select @kull2s = KULL2S from TBLSTSABITEK where STOK_KODU=@sablonKod      
 select @kull5s = KULL5S from TBLSTSABITEK where STOK_KODU=@sablonKod      
 select @kull6s = KULL6S from TBLSTSABITEK where STOK_KODU=@sablonKod      
 select @kull7s = KULL7S from TBLSTSABITEK where STOK_KODU=@sablonKod      
    
    
 INSERT INTO  [TBLSTSABIT]    
 (    
   [SUBE_KODU]    
   ,[ISLETME_KODU]    
   ,[STOK_KODU]    
   ,URETICI_KODU    
   ,STOK_ADI    
   ,GRUP_KODU    
   ,KOD_1    
   ,KOD_2    
   ,KOD_3    
   ,KOD_4    
   ,KOD_5    
   ,SATICI_KODU    
   ,OLCU_BR1    
   ,PAY_1    
   ,PAYDA_1    
   ,PAY2    
   ,PAYDA2    
   ,FIAT_BIRIMI    
   ,SAT_DOV_TIP    
   ,MUH_DETAYKODU    
   ,BIRIM_AGIRLIK    
   ,KDV_ORANI    
   ,DEPO_KODU    
   ,DOV_TUR    
   ,ALIS_DOV_TIP    
   ,BILESENMI    
   ,MAMULMU    
   ,FORMUL_TOPLAMI    
   ,UPDATE_KODU    
   ,ALIS_KDV_KODU    
   ,ALIS_FIAT1    
   ,SIP_POLITIKASI    
   ,PLANLANACAK    
   ,GUMRUKTARIFEKODU    
   ,EN    
   ,BOY    
   ,GENISLIK    
   ,S_YEDEK3    
   ,SERIBARKOD    
   ,ATIK_URUN    
 )    
 VALUES    
 (    
        '-1' --SUBE_KODU    
     ,'1' --ISLETME_KODU    
     ,@varyantKod -- STOK_KODU    
     ,@sablonKod -- URETICI_KODU    
     ,@varyantIsim -- STOK_ADI    
     ,'MAMUL' --GRUP_KODU    
     ,@kod_1 --KOD_1    
     ,@kod_2 --KOD_2    
     ,@kod_3 -- KOD_3    
     ,@kod_4 -- KOD_4    
     ,@kod_5 -- KOD_5    
     ,@satici_kodu -- SATICI_KODU    
     ,'AD' -- OLCU_BR1    
     ,@pay_1 -- PAY_1    
     ,@payda_1 -- PAYDA_1    
     ,@pay2 -- PAY2    
     ,@payda2 --PAYDA2    
     ,'1' --FIAT_BIRIMI    
     ,@sat_dov_tip --SAT_DOV_TIP    
     ,@muh_detaykodu --MUH_DETAY_KODU    
     ,@birim_agirlik --BIRIM_AGIRLIK    
     ,@kdv_orani --KDV_ORANI    
     ,'40' --DEPO_KODU    
     ,@dovtur --DOV_TUR    
     ,@alis_dov_tip --ALIS_DOV_TIP    
     ,'H' --BILESENMI    
     ,'E' --MAMULMU    
     ,1  --FORMULTOPLAMI    
     ,'X' --UPDATE_KODU    
     ,@alis_kdv_kodu --alis_kdv_kodu    
     ,@alis_fiat1 --alis_fiat1    
     ,'S' --sip politikasý    
     ,'E' --planlanacak    
     ,@gumruktarifekodu --gumruk_tarife_kodu    
     ,@en --EN    
     ,@boy --BOY    
     ,@genislik --GENÝSLIK    
     ,@identifier --s_yedek3    
     ,'H' --SERIBARKOD    
     ,'H' --ATIK_URUN    
 )    
    
 INSERT INTO  [TBLSTSABITEK]    
 (    
   STOK_KODU    
   ,TUR    
   ,MGRUP    
   ,KAYITTARIHI    
   ,KAYITYAPANKUL    
   ,INGISIM    
   ,KULL1N    
   ,KULL8N    
   ,KULL2S    
   ,KULL5S    
   ,KULL6S    
   ,KULL7S    
    
 )    
 Values    
 (    
   @varyantKod --STOK_KODU    
   ,@tur -- tur    
   ,@varyantKod --mgrup    
   ,@kayitTarihi --kayittarihi    
   ,@kayitYapanKul --kayityapankul    
   ,@varyantIngIsim --ingisim    
   ,@kull1n --kull1n    
   ,@kull8n --kull8n    
   ,@kull2s --kull2s    
   ,@kull5s --kull5s    
   ,@kull6s --kull6s    
   ,@kull7s --kull7s    
       
 )    
    
    commit    
end try    
begin catch    
 ROLLBACK    
 declare @err as varchar(max)    
 set @err = ERROR_MESSAGE()    
 RAISERROR (@err, 16, 1)    
end catch    
end    
    
    
    