
/*1ºCriar uma visão que a partir do histórico liste todas as transferências de clube realizadas pelo jogador. Para
isso, considere a data de transferência como a data de início do novo contrato do jogador. A visão deve
conter o código do jogador, o código e nome do time de origem, o código e o nome do time de destino e a
data da transferência. Os atributos da visão devem ser respectivamente: cod_jog, cod_time_ant,
nom_time_ant, cod_time_novo, nom_time_novo, dat_tansf. Por exemplo, se o jogador começou no
"Flamengo", foi para o "Santos" e está no "Guarani", a visão deve conter as seguintes linhas: ( 01, 04,
'Flamengo', 05, 'Santos', '05/02/2000' ) e ( 01, 05, 'Santos', 07, 'Guarani', '07/10/2001' )..*/

SELECT  h.cod_jog, t.cod_time, t.nom_time
		,t1.cod_time, t1.nom_time, h1.dat_ini
	FROM historicos h, historicos h1, times t, times t1
		WHERE (h.cod_jog = h1.cod_jog) AND
			  (h.dat_ini < h1.dat_ini) AND
			   h1.dat_ini = (SELECT MIN(h2.dat_ini)
								FROM historicos h2							
									WHERE h.cod_jog = h2.cod_jog AND
										  h2.dat_ini > h.dat_ini AND 
										  h.cod_time = t.cod_time AND
										  h1.cod_time = t1.cod_time)


/*2ºCriar uma visão que liste para cada campeonato, a quantidade de vitórias, empates, derrotas e jogos não
realizados de cada time.*/

SELECT DISTINCT c.dsc_camp DESCRIÇÃO,
      (SELECT COUNT(*) 
		  FROM jogos j
          WHERE (j.cod_camp = p.cod_camp) AND 
				(j.cod_time1 = p.cod_time) AND 
				(j.resultado = 1) OR (j.cod_camp = p.cod_camp) AND 
				(j.resultado = 2) AND (j.cod_time2 = p.cod_time)) AS 'QTD VITÓRIA',
		 
                (SELECT COUNT(*) 
					FROM jogos j
                    WHERE (j.cod_camp = p.cod_camp) AND 
						  (p.cod_time IN (j.cod_time1, cod_time2)) AND 
						  (j.resultado = 0)) AS 'QTD EMPATE',

                          (SELECT  COUNT(*) 
                              FROM  jogos j
                              WHERE (j.cod_camp = p.cod_camp) AND 
									(j.cod_time1 = p.cod_time) AND
									(j.resultado = 2) OR (j.cod_camp = p.cod_camp) AND 
									(j.resultado = 1) AND (j.cod_time2 = p.cod_time)) AS 'QTD DERROTA',

                             (SELECT COUNT(*) 
                                FROM jogos j
                                WHERE (j.cod_camp = p.cod_camp) AND 
									  (p.cod_time IN (j.cod_time1, cod_time2)) AND 
									  (j.resultado IS NULL)) AS 'QTD A REALIZAR'

	FROM participacoes p  JOIN times t ON t.cod_time = p.cod_time 
						  JOIN campeonatos c ON c.cod_camp = p.cod_camp


/*3º
Listar aos pares, os campeonatos que estavam em andamento simultaneamente. Cada par de campeonatos
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

/*4.Listar em cada time, o nome dos jogadores que atuaram por mais equipes diferentes. O resultado deve
conter o nome do jogador e o time que ele atua, ordenados por nome do time.*/

SELECT  t.nom_time, j.cod_jog, j.nom_jog
		,COUNT(DISTINCT h.cod_time) 'Total de times'
		FROM jogadores j, historicos h, times t
		WHERE j.cod_jog = h.cod_jog and j.cod_time = t.cod_time
		GROUP BY t.nom_time, j.nom_jog, j.cod_time,j.cod_jog
		HAVING COUNT(DISTINCT h.cod_time) = (SELECT TOP 1 COUNT( h1.cod_time)
												FROM jogadores j1, historicos h1
												WHERE j1.cod_jog = h1.cod_jog 
												GROUP BY j1.cod_jog, h1.cod_time)

		ORDER BY  t.nom_time


/*5.Selecionar o nome dos patrocinadores e o total do patrocínio, daqueles que mais investiram no ano de 2000
em cada estado. A divisão por estado deve ser feita analisando o estado do time onde ocorre o investimento..*/

SELECT t.uf_time, p.nom_pat ,SUM(pat.valor) 'Total do patrocionio'
	FROM patrocinadores p, patrocinios pat, times t
	WHERE p.cod_pat = pat.cod_pat and 
		  pat.cod_time = t.cod_time and 
		  pat.ano = 2000
	GROUP BY t.uf_time, p.nom_pat
	HAVING SUM(pat.valor) = (SELECT TOP 1 SUM (pat1.valor)
								FROM patrocinios pat1, times t1
								WHERE pat1.cod_time = t1.cod_time and 
									  pat1.ano = 2000 and
									  t1.uf_time = t.uf_time
								GROUP BY pat1.cod_pat
								ORDER BY 1 DESC)

	ORDER BY t.uf_time, p.nom_pat
