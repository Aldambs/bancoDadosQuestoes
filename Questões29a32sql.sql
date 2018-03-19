/*
29. Encontrar todos os times que participaram de um campeonato nacional no ano de 2002, ou que ganharam
de algum time que participou.
*/

SELECT t.nom_time FROM times t
	WHERE t.cod_time IN (SELECT p.cod_time 
							FROM participacoes p JOIN campeonatos c ON(p.cod_camp = c.cod_camp)
							WHERE c.ano = 2002 AND c.tipo = 'N')
							OR EXISTS (SELECT p1.cod_time FROM participacoes p1
															JOIN jogos j ON (p1.cod_camp = j.cod_camp)
															JOIN campeonatos c1 ON (p1.cod_camp = c1.cod_camp)
														  WHERE c1.ano = 2002 AND c1.tipo = 'N' AND
																(cod_time1 = p1.cod_time OR cod_time2 = p1.cod_time)
														  GROUP BY p1.cod_time, j.resultado
														  HAVING j.resultado BETWEEN 1 AND 2)


/*
30. Criar uma visão que listar o código do time, nome do time, o código do jogador, o nome do jogador e sua
posição.
*/

SELECT T.COD_TIME, T.NOM_TIME, J.COD_JOG, J.NOM_JOG, J.COD_POS
	FROM JOGADORES J JOIN TIMES T ON (J.COD_TIME = T.COD_TIME)

SELECT t.cod_time, t.nom_time, j.cod_jog, j.nom_jog, p.dsc_pos
	FROM posicoes p, times t 
		 JOIN jogadores j ON (t.cod_time = j.cod_time)
	WHERE EXISTS (SELECT p1.cod_pos
							FROM posicoes p1
							WHERE j.cod_pos = p.cod_pos) 
	GROUP BY t.cod_time, t.nom_time, j.cod_jog, j.nom_jog, p.dsc_pos
	ORDER BY 1

/*
31. Criar uma visão que a partir do histórico liste todas as transferências de clube realizadas pelo jogador.
Para isso, considere a data de transferência como a data de início do novo contrato do jogador. A visão
deve conter o código do jogador, o código e nome do time de origem, o código e o nome do time de
destino e a data da transferência. Os atributos da visão devem ser respectivamente: cod_jog,
cod_time_ant, nom_time_ant, cod_time_novo, nom_time_novo, dat_tansf. Por exemplo, se o jogador
começou no "Flamengo", foi para o "Santos" e está no "Guarani", a visão deve conter as seguintes linhas:
( 01, 04, 'Flamengo', 05, 'Santos', '05/02/2000' ) e ( 01, 05, 'Santos', 07, 'Guarani', '07/10/2001' ).
*/

SELECT H.COD_JOG, H.COD_TIME, T.NOM_TIME, DAT_INI
FROM HISTORICOS H JOIN TIMES T ON (H.COD_TIME = T.COD_TIME)
WHERE H.COD_JOG IN (SELECT H1.COD_JOG
						   FROM HISTORICOS H1
						   WHERE H1.DAT_INI <> H.DAT_INI AND H1.COD_TIME <> H.COD_TIME)


SELECT h1.cod_jog, t1.cod_time, t1.nom_time, t2.cod_time, t2.nom_time, h2.dat_ini
	FROM historicos h1, historicos h2, times t1, times t2
	WHERE(h1.cod_jog = h2.cod_jog) AND
		 (h1.dat_ini < h2.dat_ini) AND
		 (h2.dat_ini = (SELECT MIN(h3.dat_ini)
							FROM historicos h3
							WHERE h1.cod_jog = h3.cod_jog AND
								 h3.dat_ini > h1.dat_ini)) AND
								(h1.cod_time = t1.cod_time) AND 
								(h2.cod_time = t2.cod_time)

order by h1.cod_jog, h1.dat_ini

/*
32. Criar uma visão que liste para cada campeonato, a quantidade de vitórias, empates, derrotas e jogos não
realizados de cada time.
*/
SELECT c.dsc_camp,
      (SELECT COUNT(*) FROM jogos AS j
          WHERE (j.cod_camp = p.cod_camp) AND 
				(j.cod_time1 = p.cod_time) AND 
				(resultado = 1) OR (j.cod_camp = p.cod_camp) AND 
				(resultado = 2) AND (j.cod_time2 = p.cod_time)) AS qtd_vitoria,
                (SELECT COUNT(*) 
					FROM jogos j
                    WHERE (j.cod_camp = p.cod_camp) AND 
						  (p.cod_time IN (j.cod_time1, cod_time2)) AND 
						  (resultado = 0)) AS qtd_empates,
                          (SELECT  COUNT(*) 
                              FROM  jogos j
                              WHERE (j.cod_camp = p.cod_camp) AND 
									(j.cod_time1 = p.cod_time) AND
									(resultado = 2) OR (j.cod_camp = p.cod_camp) AND 
									(resultado = 1) AND (j.cod_time2 = p.cod_time)) AS qtd_derrotas,
                             (SELECT COUNT(*) 
                                FROM jogos j
                                WHERE (j.cod_camp = p.cod_camp) AND 
									  (p.cod_time IN (j.cod_time1, cod_time2)) AND 
									  (resultado IS NULL)) AS qtd_a_realizar
				FROM participacoes AS p  JOIN times t ON p.cod_time = t.cod_time 
										 JOIN campeonatos c ON p.cod_camp = c.cod_camp
