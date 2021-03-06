/*
13. Selecionar em ordem crescente de ano, o nome das equipes que conseguiram vencer um campeonato
	regional e um estadual no mesmo ano. O Resultado deve conter o ano, o nome da equipe e o estado da
	equipe.
*/
SELECT t.nom_time 'TIME', t.uf_time 'ESTADO', c.ano 'ANO'
	FROM campeonatos c, jogos j, times t
	WHERE t.nom_time IN (SELECT t1.nom_time
							FROM times t1, participacoes p, campeonatos c1
							WHERE c.ano = c1.ano 
							  AND t1.cod_time = t.cod_time 
							  AND p.cod_camp = c.cod_camp
							  AND c.cod_camp = j.cod_camp
							  AND j.cod_time1 = t.cod_time OR j.cod_time2 = t.cod_time)
	GROUP BY c.ano, t.nom_time, t.uf_time, c.tipo, j.resultado
	HAVING c.tipo = 'R' OR c.tipo = 'E'
	   AND j.resultado BETWEEN 1 AND 2
	ORDER BY c.ano
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

select t.nom_time as'Equipes',t.uf_time as 'UF',c.ano as 'Ano'
	from campeonatos c join jogos j on(j.cod_camp = c.cod_camp)
					   join participacoes p on (p.cod_camp = j.cod_camp)
					   join times t on (t.cod_time = p.cod_time)
	where t.cod_time in(select t1.cod_time
							from campeonatos c1 join jogos j1 on(j1.cod_camp = c1.cod_camp)
							    join participacoes p1 on (p1.cod_camp = j1.cod_camp)
							    join times t1 on (t1.cod_time = p1.cod_time)	
							where c1.ano = c.ano and
								  t1.cod_time = t.cod_time and
								  p1.cod_camp = p.cod_camp and 
								  j.cod_time1 = j1.cod_time2 or
								  j.cod_time2 = j1.cod_time1)
group by t.nom_time, t.uf_time, c.tipo, c.ano, j.resultado
having c.tipo = 'R' or c.tipo = 'E'
	  and j.resultado <> 0
order by c.ano


/*
14. Listar ordenadamente por estado, o nome de todas as equipes que nunca participaram de um campeonato
	Regional.
*/
SELECT nom_time, uf_time
	FROM times 
	WHERE nom_time NOT IN (SELECT nom_time
							  FROM times t JOIN participacoes p ON (t.cod_time = p.cod_time)  
										   JOIN campeonatos c ON (p.cod_camp = c.cod_camp)
							  WHERE c.tipo = 'R')
ORDER BY uf_time

/*
15. Selecionar para cada campeonato, a quantidade de equipes de cada estado. O resultado deve conter o
	nome do campeonato, o estado e o total de equipes, ordenados nome do campeonato e estado.
*/

SELECT c.dsc_camp, t.uf_time, COUNT(*) 'Qntd de equipes'
	FROM times t JOIN participacoes p ON (t.cod_time =  p.cod_time)  
				 JOIN  campeonatos c ON (p.cod_camp =  c.cod_camp)
GROUP BY t.uf_time, p.cod_camp, c.dsc_camp
ORDER BY c.dsc_camp, t.uf_time
--------------------------------------------------------------------------------------------------
SELECT c.dsc_camp, t.uf_time, count(*)
	FROM campeonatos c, participacoes p, times t
	WHERE	c.cod_camp = p.cod_camp and 
			p.cod_time = t.cod_time
	GROUP BY c.dsc_camp, t.uf_time
	ORDER BY c.dsc_camp, t.uf_time;


/*
16. Listar ordenadamente o nome dos jogadores e o sal�rio daqueles que melhor ganham.
*/

SELECT nom_jog Nome, Salario
	FROM jogadores j
	WHERE salario IN (SELECT MAX (salario)
						FROM jogadores)
ORDER BY nom_jog 
