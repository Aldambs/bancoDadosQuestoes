/*
29. Encontrar todos os times que participaram de um campeonato nacional no ano de 2002, ou que ganharam
de algum time que participou.
*/

SELECT t.nom_time
	FROM times t
	WHERE t.cod_time IN (SELECT p.cod_time 
							FROM participacoes p 
							JOIN campeonatos c ON(p.cod_camp = c.cod_camp)
							WHERE c.ano = 2002 AND c.tipo = 'N')
							OR EXISTS (SELECT p1.cod_time 
										  FROM participacoes p1
											   JOIN jogos j ON (p1.cod_camp = j.cod_camp)
											   JOIN campeonatos c1 ON (p1.cod_camp = c1.cod_camp)
										  WHERE c1.ano = 2002 AND c1.tipo = 'N' AND
			    								(cod_time1 = p1.cod_time OR cod_time2 = p1.cod_time)
										  GROUP BY p1.cod_time, j.resultado
										  HAVING j.resultado BETWEEN 1 AND 2)

/*================================================================================================================*/

select distinct t.nom_time, c.tipo 
	from times t join participacoes p on (p.cod_time = t.cod_time)
				 join campeonatos c on (c.cod_camp = p.cod_camp)
	where c.tipo = 'n' and c.ano = 2002 
					   and t.cod_time in (select p1.cod_time 
											from participacoes p1 
												join jogos j on (p1.cod_camp = j.cod_camp)
												join campeonatos c1 on (p1.cod_camp = c1.cod_camp)
											where c1.ano = 2002 and c1.tipo = 'n'
												  or j.cod_time1 = p1.cod_time
												  or j.cod_time2 = p1.cod_time
											group by p1.cod_time, j.resultado
											having j.resultado <> 1)
												  
/*
30. Criar uma visão que listar o código do time, nome do time, o código do jogador, o nome do jogador e sua
posição.
*/

--CREATE VIEW v_jogadores

--AS

SELECT t.cod_time, t.nom_time, j.cod_jog, j.nom_jog, p.dsc_pos
	FROM posicoes p, times t 
		 JOIN jogadores j ON (t.cod_time = j.cod_time)
	WHERE EXISTS (SELECT p1.cod_pos
							FROM posicoes p1
							WHERE j.cod_pos = p.cod_pos) 
	GROUP BY t.cod_time, t.nom_time, j.cod_jog, j.nom_jog, p.dsc_pos


/*
31. Criar uma visão que a partir do histórico liste todas as transferências de clube realizadas pelo jogador.
Para isso, considere a data de transferência como a data de início do novo contrato do jogador.
A visão deve conter o código do jogador, o código e nome do time de origem, o código e o nome do time de
destino e a data da transferência.
Os atributos da visão devem ser respectivamente: cod_jog, cod_time_ant, nom_time_ant, cod_time_novo, nom_time_novo, 
dat_tansf. 
Por exemplo, se o jogador
começou no "Flamengo", foi para o "Santos" e está no "Guarani", a visão deve conter as seguintes linhas:
( 01, 04, 'Flamengo', 05, 'Santos', '05/02/2000' ) e ( 01, 05, 'Santos', 07, 'Guarani', '07/10/2001' ).
*/

CREATE VIEW CLUBES
AS
SELECT  h.cod_jog, t.cod_time, t.nom_time
		,t1.cod_time, t1.nom_time, h1.dat_ini
	FROM historicos h, historicos h1, times t, times t1
		WHERE (h.cod_jog = h1.cod_jog) AND
			  (h.dat_ini < h1.dat_ini) AND
			   h1.dat_ini = (SELECT MIN(h2.dat_ini)
								FROM historicos h2							
									WHERE h.cod_jog = h2.cod_jog AND
										  h2.dat_ini > h.dat_ini AND 
										  h.cod_time = t.cod_time AND
										  h1.cod_time = t1.cod_time)

	
/*
32. Criar uma visão que liste para cada campeonato, a quantidade de vitórias, empates, derrotas e jogos não
realizados de cada time.
*/

CREATE VIEW RESULTADOS
AS
SELECT DISTINCT c.dsc_camp DESCRIÇÃO,
      (SELECT COUNT(*) 
		  FROM jogos j
          WHERE (j.cod_camp = p.cod_camp) AND 
				(j.cod_time1 = p.cod_time) AND 
				(j.resultado = 1) OR (j.cod_camp = p.cod_camp) AND 
				(j.resultado = 2) AND (j.cod_time2 = p.cod_time)) AS 'QTD VITÓRIA',
		 
                (SELECT COUNT(*) 
					FROM jogos j
                    WHERE (j.cod_camp = p.cod_camp) AND 
						  (p.cod_time IN (j.cod_time1, cod_time2)) AND 
						  (j.resultado = 0)) AS 'QTD EMPATE',

                          (SELECT  COUNT(*) 
                              FROM  jogos j
                              WHERE (j.cod_camp = p.cod_camp) AND 
									(j.cod_time1 = p.cod_time) AND
									(j.resultado = 2) OR (j.cod_camp = p.cod_camp) AND 
									(j.resultado = 1) AND (j.cod_time2 = p.cod_time)) AS 'QTD DERROTA',

                             (SELECT COUNT(*) 
                                FROM jogos j
                                WHERE (j.cod_camp = p.cod_camp) AND 
									  (p.cod_time IN (j.cod_time1, cod_time2)) AND 
									  (j.resultado IS NULL)) AS 'QTD A REALIZAR'

	FROM participacoes p  JOIN times t ON t.cod_time = p.cod_time 
						  JOIN campeonatos c ON c.cod_camp = p.cod_camp