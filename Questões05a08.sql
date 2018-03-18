/*
5. Listar o nome de todos os jogadores que tenham seus nomes 
   começados com ‘A’ ou terminados com ‘O’.
*/
Select nom_jog 'Nome' From jogadores
	Where nom_jog Like 'A%' or nom_jog Like '%O'

/*
6. Listar o nome de todos os patrocinadores que possuam a literal 
   “S/A” no nome. O resultado deve ser ordenado pelo próprio nome.
*/
Select nom_pat From patrocinadores
	Where 0 <> PATINDEX('%s/a%', nom_pat) 
	Order by nom_pat

/*
7. Listar o nome e o ano do campeonato, o nome do time e a classificação
   dos três primeiros colocados de campeonatos regionais já finalizados.
   Para isso, considere que os campeonatos estão finalizados quando a
   data de término é menor que a data atual e todos os jogos já possuemds
   resultados. O resultado deve ser ordenado por nome do campeonato 
   e classificação.
*/
Select c.dsc_camp, c.ano, t.nom_time,  p.classif
	FROM jogos j 
	   JOIN campeonatos c ON (c.cod_camp = j.cod_camp)
	   JOIN participacoes p ON (p.cod_camp = c.cod_camp)
	   JOIN times t ON (t.cod_time = p.cod_time)
	Where p.classif IN(1, 2, 3)				
	Group By t.nom_time, c.dsc_camp, c.ano, p.classif, c.tipo, c.dat_fim, j.resultado
	Having  c.tipo = 'R' And (c.dat_fim < GETDATE())
						 And (j.resultado Between 0 And 2)
	Order By c.dsc_camp, p.classif

/*
8. Recupere todos os campeonatos onde o "Flamengo" e o "Sport" se 
   enfrentaram. A resposta deve conter o campeonato, a data onde o 
   jogo ocorreu, o nome e a classificação da equipe vencedora.
*/

SELECT c.dsc_camp 'Campeonato', Jogo = CASE j.cod_time1
											 WHEN 1 THEN 'Flamengo X Sport'
											 WHEN 10 THEN 'Sport X Flamengo'
											 ELSE '-'
											 END, 
								 Vencedor = CASE j.resultado
												 WHEN 1 THEN 'Flamengo'
												 WHEN 2 THEN 'Sport'
												 ELSE 'Empate'
												 END, j.Data, p.classif 'Classificação'
FROM jogos j 
	 JOIN participacoes p ON (j.cod_camp = p.cod_camp)
	 JOIN campeonatos c ON (p.cod_camp = c.cod_camp)
WHERE (j.cod_time1 = 1 OR j.cod_time1 = 10) AND (j.cod_time2 = 1 OR j.cod_time2 = 10)
GROUP BY c.dsc_camp, j.cod_time1, j.resultado, j.data, p.classif