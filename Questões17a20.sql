/*
17. Listar ordenadamente os jogadores e o salário daqueles mais bem pagos no Rio de Janeiro.
*/

SELECT nom_jog, salario
	FROM jogadores 
	WHERE salario IN (SELECT MAX (salario) 
						FROM jogadores j JOIN times t ON (t.cod_time = j.cod_time)
						WHERE uf_time = 'RJ'
						GROUP BY j.cod_time)
	ORDER BY nom_jog



/*
18. Selecionar o nome dos jogadores mais bem pagos em cada estado. O resultado deve ser ordenado por
	estado e salário.
*/

SELECT j.nom_jog NOME, t.uf_time ESTADO, j.salario SALÁRIO
	FROM jogadores j JOIN times t ON (j.cod_time = t.cod_time)
	WHERE j.salario IN (SELECT MAX(j1.salario)
						  FROM jogadores j1 JOIN times t1 ON (j1.cod_time = t1.cod_time)
						  WHERE t1.uf_time = t.uf_time)
	GROUP BY j.nom_jog, j.cod_jog, t.uf_time, j.salario
	ORDER BY t.uf_time, j.salario

------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

select t.uf_time Estado, j.salario Salário, j.nom_jog Jogadores
    from jogadores J, times t
	where j.cod_time = t.cod_time
	group by T.UF_TIME, J.SALARIO, J.nom_jog
    having J.salario in (select max(js.salario)
		                    from jogadores js join times ts on (JS.cod_time = TS.cod_time)
						    where ts.uf_time = t.uf_time)
	  order by t.uf_time, j.salario

/*
19. Selecionar os campeonatos sem times inscritos, ou seja, sem participantes.
*/

SELECT  dsc_camp
	FROM campeonatos c JOIN participacoes p ON (c.cod_camp = p.cod_camp) 
	WHERE p.cod_time NOT IN (SELECT DISTINCT cod_time
                                FROM participacoes p1
							    WHERE p1.cod_camp = p.cod_camp)


/*
20. Selecionar os patrocinadores que investiram em uma mesma equipe em anos diferentes.
*/

SELECT DISTINCT p.nom_pat
	FROM patrocinadores p 
	WHERE p.cod_pat IN (SELECT pc.cod_pat
						   FROM patrocinios pc
					       WHERE p.cod_pat = pc.cod_pat 
						   AND pc.ano > 1)								 
GROUP BY p.nom_pat

SELECT DISTINCT p.nom_pat
	FROM patrocinadores p, patrocinios pc
	WHERE p.cod_pat = pc.cod_pat
	GROUP BY p.nom_pat, pc.cod_time
	HAVING COUNT(DISTINCT ano ) > 1