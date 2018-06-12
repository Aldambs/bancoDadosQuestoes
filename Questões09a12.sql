/*
9. Listar o nome do jogador e a descrição da posição de todos os jogadores do "Flamengo".
*/

SELECT  j.nom_jog, p.dsc_pos
FROM jogadores j JOIN times t ON (j.cod_time = t.cod_time)
				 JOIN posicoes p ON (j.cod_pos =  p.cod_pos)
	   WHERE j.cod_time = 1

/*
10. Listar o nome do time e o total de jogadores de cada equipe. 
(Fazer a mesma questão de quatro maneiras diferentes!).
*/

SELECT t.nom_time NOME, COUNT (j.cod_jog) 'TOTAL DE JOGADORES'
	FROM times t JOIN jogadores j ON (j.cod_time =  t.cod_time)
	GROUP BY nom_time

SELECT t.nom_time NOME, COUNT (j.cod_jog) 'TOTAL DE JOGADORES'
	FROM times t LEFT JOIN jogadores j ON (j.cod_time =  t.cod_time)
	GROUP BY nom_time

SELECT t.nom_time NOME, COUNT (j.cod_jog) 'TOTAL DE JOGADORES'
	FROM times t RIGHT JOIN jogadores j ON (j.cod_time =  t.cod_time)
	GROUP BY nom_time

SELECT t.nom_time NOME, COUNT (j.cod_jog) 'TOTAL DE JOGADORES'
	FROM times t FULL JOIN jogadores j ON (j.cod_time =  t.cod_time)
	GROUP BY nom_time


/*
11. Encontrar o nome dos jogadores que já tenham passado por mais de uma equipe diferente no estado do
	Rio de Janeiro.
*/
	
SELECT DISTINCT j.nom_jog, t.nom_time
	FROM jogadores j JOIN historicos h ON (j.cod_jog = h.cod_jog) 
					 JOIN times t ON (t.cod_time = h.cod_time)
	WHERE t.uf_time =  'RJ' AND j.cod_jog IN (SELECT h1.cod_jog
												FROM  historicos h1
												WHERE h1.cod_time <> h.cod_time)


/*
12. Listar em ordem alfabética o nome de todos os jogadores que já jogaram pelo "Flamengo".
*/

SELECT nom_jog
	FROM jogadores
	WHERE cod_time  =  1
	ORDER BY nom_jog
