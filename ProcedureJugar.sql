
create or alter procedure Tr_Jugar @nombreJugador varchar(50), @palabraIntentada varchar(5)
as
begin 
	declare @idJugador int
	if(select COUNT(NICK) from jugadores where NICK = @nombreJugador)<1
		begin
			insert into jugadores (nick) values (@nombreJugador)

			
			
			set @idJugador=(select id from jugadores j where NICK = @nombreJugador) 

				
		end 
	else
		begin
				set @idJugador=(select id from jugadores j where NICK = @nombreJugador)
	
		end
		declare @idPalabra int
		if(select COUNT(*) from partida where IDJUGADOR = @idJugador and FECHA=Convert(date, getdate()))<1
				begin
					set @idpalabra =(select top 1 id  from palabras p
					left join AparicionesJug a  on a.IDPALABRA=p.ID
					where IDJUGADOR is null or IDJUGADOR = @idJugador
					order by NUMAPARICIONES asc)

					
					if (select COUNT(*) from AparicionesJug where IDPALABRA = @idPalabra and IDJUGADOR = @idJugador)<1
						begin
							insert into AparicionesJug (IDPALABRA,IDJUGADOR,NUMAPARICIONES) values (@idPalabra , @idJugador,1)
						end
					else
						begin
							update AparicionesJug set NUMAPARICIONES += 1 where IDPALABRA = @idPalabra and IDJUGADOR = @idJugador
						end

					insert into partida (IDJUGADOR,IDPALABRA,FECHA) VALUES (@idJugador, @idPalabra, GETDATE())				
				end

			
		declare @idPartida int
		declare @PalabraBuena varchar (5)
		DECLARE @INTENTOS INT
		
		set @idPartida= (select TOP 1 ID from partida where IDJUGADOR = @idJugador and FECHA=Convert(date, getdate()))
		SET @INTENTOS = (select COUNT(*) from intentos where IDPARTIDA = @idPartida)
		set @PalabraBuena = (select NOMBRE from palabras where ID = (select IDPALABRA from partida where ID=@idPartida))

		DECLARE @A VARCHAR(20)
		SET @A = (select TOP 1 PALABRA_INTENTADA from intentos where IDPARTIDA = @idPartida ORDER BY IDINTENTO desc)

		if @INTENTOS<5 and (select TOP 1 PALABRA_INTENTADA from intentos where IDPARTIDA = @idPartida ORDER BY IDINTENTO desc) <> @PalabraBuena OR @INTENTOS =0
			begin
				--//
				declare @i int
				declare @j int
				declare @codif varchar(20)
				SET @codif=''
				set @i = 0
				set @j = 0
				--calcular el resultado 
				while(@i<len(@palabraIntentada))
				begin
				set @i =@i+1
					while(@j <= len(@palabraBuena) AND LEN(@codif)<@i)
					begin
						set @j =@j+1



						if(SUBSTRING(@palabraIntentada,@i,1) = SUBSTRING(@palabraBuena,@j,1))
						begin
							if(SUBSTRING(@palabraIntentada,@i,1) = SUBSTRING(@palabraBuena,@i,1))
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

				--//

				PRINT(@palabraBuena)
				insert into intentos (IDPARTIDA, IDINTENTO, CODIF, PALABRA_INTENTADA) VALUES(@idPartida, @INTENTOS + 1, @codif, @palabraIntentada )
				PRINT(CONCAT('INTENTO Nº: ',(@INTENTOS + 1)))
				PRINT(@palabraIntentada)
				PRINT(@CODIF)
				IF(@INTENTOS+1=5 AND  @palabraIntentada <> @PalabraBuena)
					BEGIN
						print('Numero maximo de intentos alcanzados la palabra era ' + @PalabraBuena)
					END
			end
			ELSE
				BEGIN
					if @INTENTOS =5
						begin
							print('Numero maximo de intentos alcanzados la palabra era ' + @PalabraBuena)
						end
					else
						begin 
							print('La palabra ya ha sido acertada')
						end
				END
 

end

select * from AparicionesJug
SELECT * FROM jugadores
SELECT * FROM partida
select * from intentos

insert into AparicionesJug values(2,4,1)


exec Tr_Jugar 'ANSEEPE','POLLA'
