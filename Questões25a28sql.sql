/*
25. Encontrar os goleiros que atuaram por mais times diferentes.
*/

SELECT j.nom_jog NOME
	FROM jogadores j, historicos h, posicoes p
	WHERE h.cod_jog = j.cod_jog AND 
		  j.cod_pos = p.cod_pos AND 
		  p.dsc_pos = 'GOLEIRO' AND 
		  j.cod_jog IN (SELECT t.cod_time
						  FROM times t
						  WHERE t.cod_time <> h.COD_TIME)
GROUP BY j.nom_jog	

/*
26. Listar em cada time, o nome dos jogadores que atuaram por mais equipes diferentes. O resultado deve
conter o nome do jogador e o time que ele atua, ordenados por nome do time.
*/

SELECT t.nom_time TIMES, j.nom_jog JOGADORES ,COUNT(DISTINCT h.cod_time) "Total"
	FROM jogadores j, historicos h, times t 
	WHERE j.cod_jog = h.cod_jog AND
		  j.cod_time =  t.cod_time
	GROUP BY t.nom_time, j.nom_jog, j.cod_time
	HAVING COUNT (DISTINCT h.cod_time) = (SELECT TOP 1 COUNT(DISTINCT h1.cod_time)
											FROM jogadores j1, historicos h1
											WHERE j1.cod_jog = h1.cod_jog AND
												  j1.cod_time = j.cod_time
											GROUP BY j1.cod_jog
											ORDER  BY 1 DESC)
ORDER BY 1 

/*
27. Listar aos pares, os campeonatos que estavam em andamento simultaneamente. Cada par de campeonatos
deve ser listado apenas uma vez. Assim, se em março de 2000 estavam em andamento os campeonatos
"Camp1", "Camp2" e "Camp3", no resultado deve aparecer as linhas: ( "Camp1", "Camp2" ), ( "Camp1",
"Camp3" ) e ( "Camp2", "Camp3" ).
*/

SELECT  c1.dsc_camp, c2.dsc_camp
	FROM campeonatos c1, campeonatos c2
	WHERE(c1.cod_camp < c2.cod_camp) AND 
		--(MONTH(3) = 2000) AND
         (c1.dat_ini BETWEEN c2.dat_ini AND c2.dat_fim) OR
	     (c1.dat_fim BETWEEN c2.dat_ini AND c2.dat_fim) OR
		 (c2.dat_ini BETWEEN c1.dat_ini AND c1.dat_fim) OR
		 (c2.dat_fim BETWEEN c1.dat_ini AND c1.dat_fim)
ORDER BY 1


/*
28. Listar os jogos que fizeram uma equipe atuar com um intervalo menor que 3 dias entre os jogos.
*/

SELECT distinct j.cod_time1, j.cod_time2
	FROM jogos j JOIN participacoes p ON (p.cod_camp = j.cod_camp)
	WHERE DAY(data) < 3