--9 SOLO DAM DAW
--  crea un trigger que cuando se inserte 1 intento en la tabla intentos, 
--  recoga la palabra intentada y calcule el resultado segun la palabra.
--  Después, deberá guardar en la tabla intentos ese resultado en otro campo

-- mejora el trigger anterior para que funcione con inserts de más de una linea.





create or alter procedure ProcedureIntentos @IDPARTIDA INT ,@IDINTENTO INT, @IDJUGADOR INT
AS
BEGIN
declare @palabraIntentada varchar(20)
	declare @i int
	declare @j int
	declare @palabraBuena varchar(20)
	declare @codif varchar(20)
	set @palabraBuena = (select PA.NOMBRE from intentos i
						 inner join partida p on 
						 p.id = i.IDPARTIDA
						 inner join palabras pa on
						 pa.id = p.IDPALABRA
						 where (select idpartida from INTENTOS WHERE @IDPARTIDA = IDPARTIDA AND @IDINTENTO = IDINTENTO AND @IDJUGADOR = IDJUGADOR) = p.ID)
	set @i = 0
	set @j = 0
	SET @palabraIntentada = (SELECT PALABRA_INTENTADA from intentos)
	--calcular el resultado 
	while(@i<len(@palabraIntentada))
	begin
	set @i =@i+1
		while(@j <= len(@palabraBuena) or SUBSTRING(@palabraIntentada,@i,1) = SUBSTRING(@palabraBuena,@j,1))
		begin
			set @j =@j+1
			if(SUBSTRING(@palabraIntentada,@i,1) = SUBSTRING(@palabraBuena,@j,1))
			begin
				if(@i=@j)
				begin
					set @codif=@codif+'2'
				end
				else
				begin
					set @codif=@codif+'1'
				end
			end
			else if(@j = len(@palabraBuena))
			begin
				set @codif=@codif+'0'		
			end
		end
		set @j = 0
	end

	UPDATE INTENTOS SET CODIF = @CODIF WHERE @IDPARTIDA = IDPARTIDA AND @IDINTENTO = IDINTENTO AND @IDJUGADOR = IDJUGADOR


END



GO
CREATE or alter TRIGGER TR_intentos
on intentos
for INSERT
AS
BEGIN
	
	declare cursorc cursor for (select IDPARTIDA,IDINTENTO,IDJUGADOR from inserted)
	DECLARE @IDPARTIDA INT
	DECLARE @IDINTENTO INT
	DECLARE @IDJUGADOR INT
	open cursorc
	fetch next from cursorc into  @IDPARTIDA,@IDINTENTO,@IDJUGADOR
	while(@@fetch_status=0)
	begin

		EXECUTE ProcedureIntentos @IDPARTIDA,@IDINTENTO,@IDJUGADOR
		fetch next from cursorc into  @IDPARTIDA,@IDINTENTO,@IDJUGADOR

	end
END
go


