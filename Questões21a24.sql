/*
21. Selecionar o nome dos patrocinadores e o total do patrocínio no ano 2001, 
daqueles que investiram em algum time do Rio de Janeiro neste ano.
*/

SELECT p.nom_pat, t.uf_time, SUM (pc.valor) valor
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

SELECT pt.nom_pat NOME, SUM(pn.valor) [TOTAL PATROCÍNIO]
	FROM patrocinadores pt JOIN  patrocinios pn ON( pt.cod_pat = pn.cod_pat)
						   JOIN  times t ON(t.cod_time = pn.cod_time)
	WHERE pt.cod_pat = pn.cod_pat AND 
		  pn.cod_time = t.cod_time AND 
		  pn.ano = 2000
	GROUP BY pt.nom_pat, t.uf_time, pn.valor, pn.ano
	HAVING SUM (pn.valor) IN (SELECT SUM(pn1.valor)
								 FROM patrocinios pn1, times t1
								 WHERE pn1.cod_time = t1.cod_time AND 
									   pn.valor > pn1.valor
								 GROUP BY pn1.cod_pat, t1.uf_time)
ORDER BY pt.nom_pat

/*
23. Selecionar o nome e a quantidade de jogos dos campeonatos com maior número de jogos.
*/

SELECT TOP 2 c.dsc_camp DESCRIÇÃO, COUNT(*) [Nº DE JOGOS], MAX(j.cod_camp)
	FROM jogos j, campeonatos c
	WHERE j.cod_camp = c.cod_camp 
	GROUP BY c.dsc_camp, c.ano
	ORDER BY 2 DESC

/*
24. Selecionar o nome e a quantidade de jogos dos campeonatos com maior número de jogos em cada ano.
*/

SELECT TOP 2 c.dsc_camp DESCRIÇÃO, COUNT(*) [Nº DE JOGOS], MAX(j.cod_camp)
	FROM jogos j, campeonatos c
	WHERE j.cod_camp = c.cod_camp 
	GROUP BY c.dsc_camp, c.ano
	HAVING MAX(c.cod_camp) = c.ano
	ORDER BY 2 DESC