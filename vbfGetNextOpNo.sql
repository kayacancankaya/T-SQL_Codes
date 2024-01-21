
create FUNCTION dbo.GetNextOpNo(@mamulKodu nvarchar(15))
RETURNS nvarchar(4)
AS
BEGIN
    declare @maxOpNo nvarchar(4)
	declare @nextOpNoNumber nvarchar(4)

    SELECT top 1 @maxOpNo = isnull(opno,'0000')
    FROM TBLSTOKURM
    WHERE MAMUL_KODU = @mamulKodu
	order by opno desc;

	if @maxOpNo = '0000' or @maxOpNo is null
	begin
		set @nextOpNoNumber = '0001'
		return @nextOpNoNumber
	end

	DECLARE @currentChar NVARCHAR(1) 
	declare @i int = 1
	declare @opNoNumber int
	declare @zeroCount int = 0

	while @i <= len(@maxOpNo) 
	begin
		SET @currentChar = SUBSTRING(@maxOpNo,@i,1)  

		if @currentChar <> '0'
		begin
			set @opNoNumber = cast(substring(@maxOpno,len(substring(@maxOpNo,1,@i)),len(@maxOpNo)) as int) 
			break
		end
       SET @zeroCount = @zeroCount + 1;
	  
		set @i = @i + 1
	end

		if right(cast(@opNoNumber as nvarchar(4)),1) = '9'  
		begin
			SET @zeroCount = @zeroCount - 1;
		end

	set @opNoNumber = @opNoNumber + 1

	 declare @zerosAsString nvarchar(4) = REPLICATE('0', @zeroCount);
	 
	 set @nextOpNoNumber = @zerosAsString + cast(@opNoNumber as nvarchar(4))
	 return @nextOpNoNumber
END;
