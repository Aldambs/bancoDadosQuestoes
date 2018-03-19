/*
29. Encontrar todos os times que participaram de um campeonato nacional no ano de 2002, ou que ganharam
de algum time que participou.
*/


/*
30. Criar uma vis�o que listar o c�digo do time, nome do time, o c�digo do jogador, o nome do jogador e sua
posi��o.
*/

SELECT t.cod_time, t.nom_time, j.cod_jog, j.nom_jog, p.dsc_pos
	FROM posicoes p, times t 
		 JOIN jogadores j ON (t.cod_time = j.cod_time)
	WHERE EXISTS (SELECT p1.cod_pos
							FROM posicoes p1
							WHERE j.cod_pos = p.cod_pos) 
	GROUP BY t.cod_time, t.nom_time, j.cod_jog, j.nom_jog, p.dsc_pos
	ORDER BY 4

/*
31. Criar uma vis�o que a partir do hist�rico liste todas as transfer�ncias de clube realizadas pelo jogador.
Para isso, considere a data de transfer�ncia como a data de in�cio do novo contrato do jogador. A vis�o
deve conter o c�digo do jogador, o c�digo e nome do time de origem, o c�digo e o nome do time de
destino e a data da transfer�ncia. Os atributos da vis�o devem ser respectivamente: cod_jog,
cod_time_ant, nom_time_ant, cod_time_novo, nom_time_novo, dat_tansf. Por exemplo, se o jogador
come�ou no "Flamengo", foi para o "Santos" e est� no "Guarani", a vis�o deve conter as seguintes linhas:
( 01, 04, 'Flamengo', 05, 'Santos', '05/02/2000' ) e ( 01, 05, 'Santos', 07, 'Guarani', '07/10/2001' ).
*/

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
32. Criar uma vis�o que liste para cada campeonato, a quantidade de vit�rias, empates, derrotas e jogos n�o
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
