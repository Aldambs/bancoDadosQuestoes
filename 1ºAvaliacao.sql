/* 1º Selecionar os patrocinadores que investiram em uma mesma equipe em 
anos diferentes*/

SELECT DISTINCT p.nom_pat
	FROM patrocinadores p, patrocinios pc
	WHERE p.cod_pat = pc.cod_pat
	GROUP BY p.nom_pat, pc.cod_time
	HAVING COUNT(DISTINCT pc.ano ) > 1;

/* 2º Selecionar para cada campeonatos, a quantidade de equipes de cada estado.
O resultado deve conter o nome do campeonato, o estado e o total de equipe
ordenados por nome do campeonato e estado.*/

SELECT c.dsc_camp, t.uf_time, COUNT(*) 'Qntd de equipes'
	FROM times t JOIN participacoes p ON (t.cod_time =  p.cod_time)  
				 JOIN  campeonatos c ON (p.cod_camp =  c.cod_camp)
GROUP BY t.uf_time, p.cod_camp, c.dsc_camp
ORDER BY c.dsc_camp, t.uf_time

SELECT c.dsc_camp, t.uf_time, COUNT(*) 'Qntd de equipes'
	FROM campeonatos c, participacoes p, times t
	WHERE	c.cod_camp = p.cod_camp AND 
			p.cod_time = t.cod_time
	GROUP BY c.dsc_camp, t.uf_time
	ORDER BY c.dsc_camp, t.uf_time;

/* 3º Listar aos pares, os campeonatos que estavam em andamento simultaneamente. Cada par de campeonatos
deve ser listado apenas uma vez. Assim, se em março de 2000 estavam em andamento os campeonatos
"Camp1", "Camp2" e "Camp3", no resultado deve aparecer as linhas: ( "Camp1", "Camp2" ), ( "Camp1",
"Camp3" ) e ( "Camp2", "Camp3" ).*/

SELECT  c1.dsc_camp, c2.dsc_camp
	FROM campeonatos c1, campeonatos c2
	WHERE(c1.cod_camp < c2.cod_camp) AND 
		 --(MONTH(3) = 2000) AND
         (c1.dat_ini BETWEEN c2.dat_ini AND c2.dat_fim) OR
	     (c1.dat_fim BETWEEN c2.dat_ini AND c2.dat_fim) OR
		 (c2.dat_ini BETWEEN c1.dat_ini AND c1.dat_fim) OR
		 (c2.dat_fim BETWEEN c1.dat_ini AND c1.dat_fim)
ORDER BY 1