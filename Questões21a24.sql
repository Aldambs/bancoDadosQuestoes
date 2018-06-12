/*
21. Selecionar o nome dos patrocinadores e o total do patrocínio no ano 2001, 
daqueles que investiram em algum time do Rio de Janeiro neste ano.
*/

SELECT p.nom_pat Nome, t.uf_time Estado, SUM (pc.valor) Valor
	FROM patrocinadores p, patrocinios pc, times t
	WHERE p.cod_pat = pc.cod_pat AND
		  pc.cod_time = t.cod_time AND
		  t.uf_time = 'RJ' AND
		  pc.ano = 2001
	GROUP BY t.uf_time, p.nom_pat
	HAVING SUM(pc.valor) = (SELECT TOP 1 sum (pc1.valor)
	                            FROM patrocinios pc1, times t1
								WHERE pc1.cod_time = t1.cod_time AND
								      pc1.ano = 2001 AND
									  t1.uf_time = 'RJ'
							     GROUP BY pc1.cod_pat
								 ORDER BY 1 DESC)
ORDER BY t.uf_time, p.nom_pat

/*
22.	Selecionar o nome dos patrocinadores e o total do patrocínio, daqueles que mais investiram no ano de
	2000 em cada estado. A divisão por estado deve ser feita analisando o estado do time onde ocorre o
	investimento.
*/

select pa.nom_pat PATROCINADORES, t.uf_time ESTADOS, sum(pt.valor) VALOR
	from patrocinadores pa join patrocinios pt on(pt.cod_pat = pa.cod_pat)
						   join times t on(t.cod_time = pt.cod_time)
	where pt.ano = 2000
	group by t.uf_time, pa.nom_pat, pt.valor, pt.ano
	having sum(pt.valor) = (select top 1 sum(pt1.valor) 
								from patrocinios pt1 join times t1 on(pt1.cod_time = t1.cod_time)
								where pt1.ano = 2000 and
									  t1.uf_time = t.uf_time								  
									  group by pt1.valor
									  order by 1 desc)
order  by 1

-----------------------------------------------------------------------------------------------------------------
select pa.nom_pat PATROCINADORES, t.uf_time ESTADOS, sum(pt.valor) VALOR
	from patrocinadores pa, patrocinios pt, times t
	where pa.cod_pat = pt.cod_pat and
		  pt.cod_time = t.cod_time and
		  pt.ano = 2000
	group by pa.nom_pat, t.uf_time, pt.valor, pt.ano
	having sum(pt.valor) = (select top 1 sum(pt1.valor)
								from patrocinios pt1, times t1
								where pt1.cod_time = t1.cod_time and
									  pt1.ano = 2000 and
									  t1.uf_time = t.uf_time
								group by pt1.valor
								order by 1 desc)				
order  by 1
/*
23. Selecionar o nome e a quantidade de jogos dos campeonatos com maior número de jogos.
*/

SELECT top 2 c.dsc_camp DESCRIÇÃO, COUNT(*) [Nº DE JOGOS]
	FROM jogos j JOIN campeonatos c ON (j.cod_camp = c.cod_camp)
	GROUP BY c.dsc_camp, c.ano
	ORDER BY 2 DESC

/*==========================================================================*/

SELECT  c.dsc_camp DESCRIÇÃO, COUNT(j.cod_camp) [Nº DE JOGOS]
	FROM jogos j, campeonatos c
	WHERE j.cod_camp = c.cod_camp 
	GROUP BY c.dsc_camp
	HAVING COUNT(*) = (SELECT top 1 COUNT(*)
						 FROM jogos
						 GROUP BY cod_camp
						 ORDER BY 1 desc)

/*
24. Selecionar o nome e a quantidade de jogos dos campeonatos com maior número de jogos em cada ano.
*/

SELECT c.dsc_camp DESCRIÇÃO, COUNT(*) [Nº DE JOGOS]
	FROM jogos j, campeonatos c
	WHERE j.cod_camp = c.cod_camp 
	GROUP BY c.dsc_camp, c.ano
	HAVING MAX(c.cod_camp) = c.ano
	ORDER BY 2 DESC
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
SELECT  c.dsc_camp DESCRIÇÃO, COUNT(j.cod_camp) [Nº DE JOGOS], c.ANO
	FROM jogos j JOIN campeonatos c ON (j.cod_camp = c.cod_camp)
	GROUP BY c.dsc_camp, c.ano
	HAVING COUNT(*) = (SELECT top 1 COUNT(*)
						 FROM jogos j1 JOIN campeonatos c1 ON (c1.ano = c.ano)
						 GROUP BY c1.cod_camp
						 ORDER BY 1 desc)