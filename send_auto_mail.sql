    
    
alter PROCEDURE [dbo].[vbp_aktarilamayanreceteler]    
AS    
 DECLARE @Style NVARCHAR(MAX)= '';    
 DECLARE @tableHTML NVARCHAR(MAX)= '';    
 DECLARE @COUNT INT;    
     
  SELECT @count=count(*)   from sbpvReceteTuretmeRaporu with(nolock)                    
    where durumDetay='Hatali'  
    
 IF @COUNT > 0    
    
    
BEGIN    
 SET NOCOUNT ON;    
    
    SET @Style += +N'<style type="text/css">' + N'.tg  {border-collapse:collapse;border-spacing:0;border-color:#aaa;}'    
    + N'.tg td{font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;border-color:#aaa;color:#333;background-color:#fff;}'    
    + N'.tg th{font-family:Arial, sans-serif;font-size:14px;font-weight:normal;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;border-color:#aaa;color:#fff;background-color:#f38630;}'    
    + N'.tg .tg-9ajh{font-weight:bold;background-color:#68cbd0}' + N'.tg .tg-hgcj{font-weight:bold;text-align:center}'    
    + N'</style>';    
     
SET @tableHTML += @Style + @tableHTML + N'' + '</H2>'     
 + N'<table class="tg">' --DEFINE TABLE    
    
 + N'<tr>'    
    + N'<td class="tg-9ajh">Stok Kodu</td>'     
    + N'<td class="tg-9ajh">Açıklama</td>'     
     
    
 + CAST((    
    
     SELECT distinct    
  td= SUBSTRING(stokKodu,1,11),    
   '',    

  td= substring(aciklama,1,100),    
   ''

 from sbpvReceteTuretmeRaporu with(nolock)                    
   where durumDetay='Hatali'
    
           FOR    
             XML PATH('tr') ,    
                 TYPE    
           ) AS NVARCHAR(MAX)) + N'</table>';            
     
     
EXECUTE [msdb].[dbo].[sp_send_dbmail]      
 @profile_name = 'backup@vitabianca.com.tr'      
 ,@recipients  = 'irem.aydin@vitabianca.com.tr;erdem.kantekin@vitabianca.com.tr;velittin.gorgulu@vitabianca.com.tr;gokmen.bal@vitabianca.com.tr;birol.sahin@vitabianca.com.tr;burcin.toksabay@vitabianca.com.tr;halil.paso@vitabianca.com.tr;anil.inal@vitabianca.com.tr;cemal.yanik@vitabianca.com.tr;meryem.sarikaya@vitabianca.com.tr;mesut.bayezit@vitabianca.com.tr'            
  ,@subject = 'Aktarılamayan Reçete Kayıtları'    
, @body = @tableHTML    
    , @body_format = 'HTML'    
    
END      

--exec vbp_aktarilamayanreceteler
    

