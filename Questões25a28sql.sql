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

SELECT t.nom_time TIMES, j.nom_jog JOGADORES 
	FROM jogadores j, historicos h, times t 
	WHERE j.cod_jog = h.cod_jog AND
		  j.cod_time =  t.cod_time
	GROUP BY t.nom_time, j.nom_jog, j.cod_time
	HAVING COUNT (DISTINCT h.cod_time) in (SELECT TOP 1 COUNT(DISTINCT h1.cod_time)
											FROM jogadores j1, historicos h1
											WHERE j1.cod_jog = h1.cod_jog AND
												  j1.cod_time = j.cod_time
											GROUP BY j1.cod_jog
											ORDER  BY 1 DESC)
ORDER BY 1 

----------------------------------------------------------------------------------------------------------

select t.nom_time Times, j.nom_jog Jogadores, count (distinct h.cod_time) "Total"
from jogadores j join historicos h on (j.cod_jog =  h.cod_jog)
                 join times t on (j.cod_time =  t.cod_time)
group by t.nom_time, j.nom_jog, j.cod_time
having count (distinct h.cod_time) = (select top 1 count (distinct h1.cod_time)
                                         from jogadores j1, historicos h1
										 where j1.cod_jog =  h1.cod_jog  and
										       j1.cod_time =  j.cod_time
										 group by j1.cod_jog
										 order by 1 desc)
order by 1

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
-- do camp 1 e camp 2
*/

SELECT j1.cod_camp, j1.cod_time1, j1.cod_time2, j1.data,
	   j2.cod_camp, j2.cod_time1, j2.cod_time2, j2.data 
	FROM jogos j1, jogos j2 
	WHERE(J1.data < j2.data) AND
		 (j2.data - j1.data < 3) AND 
		 (j1.cod_time1 = j2.cod_time1 OR
		  j1.cod_time1 = j2.cod_time2 OR
		  j1.cod_time2 = j2.cod_time1 OR
		  j1.cod_time2 = j2.cod_time2) AND 
		  j1.cod_camp IN (1,2) AND j2.cod_camp IN (1,2)
		  
		  
	