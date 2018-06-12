/*
Recupere todos os campeonatos onde o flamengo e o fluminese não se enfrentam.
*/
SELECT c.dsc_camp 'CAMPEONATO', t.nom_time 'TIMES'
	FROM campeonatos c 
				 JOIN jogos j ON(j.cod_camp = c.cod_camp)
				 JOIN participacoes p ON(p.cod_camp = j.cod_camp)
				 JOIN times t ON(t.cod_time = p.cod_time)
	WHERE p.cod_time = t.cod_time 
			OR NOT EXISTS (SELECT j1.cod_camp
							 FROM  campeonatos c1 
										JOIN jogos j1 ON(j1.cod_camp = c1.cod_camp)
										JOIN participacoes p1 ON(p1.cod_camp = j1.cod_camp)
										JOIN times t1 ON(t1.cod_time = p1.cod_time)
							WHERE p1.cod_time = t1.cod_time 
								AND p1.cod_camp = j1.cod_camp
								AND (j1.cod_time1 = 1 
							    AND j1.cod_time2 = 3) 
								OR (j1.cod_time1 = 3 
							    AND j1.cod_time2 = 1)
								AND resultado BETWEEN 0 AND 1)
GROUP BY c.cod_camp, t.nom_time, c.dsc_camp
HAVING t.nom_time = 'Flamengo' OR t.nom_time = 'Fluminese'

select distinct c.dsc_camp 'Campeonatos'
	from campeonatos c join participacoes p on(p.cod_camp = c.cod_camp)
	where c.cod_camp not in (select p1.cod_camp
								from participacoes p1 join times t on (t.cod_time = p1.cod_time)
													  join historicos h on (t.cod_time = h.cod_time)
								where t.cod_time in (1,3))

/*2.Encontrar o nome dos jogadores que já tenham passado por mais de uma equipe diferente no estado
 do Rio de Janeiro e são paulo.*/

SELECT DISTINCT j.nom_jog 'NOME DO JOGAGOR', t.nom_time 'NOME DO TIME'
	FROM jogadores j JOIN historicos h ON (j.cod_jog = h.cod_jog)
					 JOIN times t ON (h.cod_time = t.cod_time)
	WHERE t.uf_time = 'RJ' OR  t.uf_time = 'SP'
						   AND  j.cod_jog IN (SELECT h1.cod_jog
												FROM  historicos h1
												WHERE h1.cod_time <> h.cod_time)

/*3.Selecionar para cada campeonato, a quantidade de equipes de cada estado.
 O resultado deve conter o nome do campeonato, o estado e o total de equipes, 
 ordenados nome do campeonato e estado.
*/

SELECT c.dsc_camp 'CAMPEONATO', t.uf_time 'ESTADO', COUNT(*) 'QTD. EQUIPE'
	FROM campeonatos c, participacoes p, times t
	WHERE c.cod_camp = p.cod_camp
	  AND p.cod_time = t.cod_time
	GROUP BY c.dsc_camp, t.uf_time, p.cod_camp
	ORDER BY c.dsc_camp, t.uf_time
