/*
1. Obter o nome dos times do estado do Rio de Janeiro ordenados por nome do time.
*/
SELECT nom_time 'NOME', uf_time 'ESTADO'
	FROM times
	WHERE uf_time = 'RJ'
	ORDER BY nom_time
/*
2. Encontrar todos os jogadores com menos de 36 anos. O resultado deve conter o nome do jogador e a data
   de nascimento, ordenados decrescentemente por data de nascimento. Para jogadores nascidos na mesma
   data, deve ser seguida a ordem alfabética de nomes.
*/
SELECT nom_jog 'NOME', dat_nasc 'DATA DE NASCIMENTO'
	FROM jogadores
	WHERE dat_nasc < 36
	ORDER BY nom_jog
/*
3. Selecionar todos os campeonatos que estavam em andamento em fevereiro de 2002. O resultado deve
conter a descrição do campeonato e a descrição do seu tipo, ou seja, as palavras: Estadual, Regional ou
Nacional. Os nomes das colunas devem ser: "Campeonato" e "Tipo". O resultado deve estar em ordem
crescente de campeonatos.
*/

/*--------------------------------------- Com uso de UNION --------------------------------------*/
/*-----------------------------------------------------------------------------------------------*/
SELECT c.cod_camp 'CÓDIGO', c.dsc_camp 'DESCRIÇÃO', 'Estadual' TIPO, c.ANO
	FROM campeonatos c JOIN jogos j ON(J.cod_camp = c.cod_camp)
	WHERE MONTH(j.data) = 2 AND c.ano = 2002 AND c.tipo = 'E'
	
UNION
	SELECT c.cod_camp 'CÓDIGO', c.dsc_camp 'DESCRIÇÃO', 'Regional' TIPO, c.ANO
		FROM campeonatos c JOIN jogos j ON(J.cod_camp = c.cod_camp)
		WHERE MONTH(j.data) = 2 AND c.ano = 2002 AND c.tipo = 'R'
		
UNION
	SELECT c.cod_camp 'CÓDIGO', c.dsc_camp 'DESCRIÇÃO', 'Nacional' TIPO, c.ANO
		FROM campeonatos c JOIN jogos j ON(J.cod_camp = c.cod_camp)
		WHERE MONTH(j.data) = 2 AND c.ano = 2002 AND c.tipo = 'N'
		ORDER BY c.dsc_camp 
/*--------------------------------------- Com uso de CASE ---------------------------------------*/
/*-----------------------------------------------------------------------------------------------*/
SELECT c.dsc_camp 'Campeonatos', 
	   Tipo = CASE c.tipo WHEN 'E' THEN 'Estadual' 
						  WHEN 'R' THEN 'Regional'
						  WHEN 'N' THEN 'Nacional'
						  ELSE '-' 
						  END, c.Ano
	FROM jogos j, campeonatos c
	WHERE j.cod_camp = c.cod_camp AND MONTH(j.data) = 2 
								  AND c.ano = 2002	
	GROUP BY c.dsc_camp, c.tipo, c.ano
	ORDER BY c.dsc_camp 
 
/*==============================================================================*/
SELECT c.dsc_camp 'CAMPEONATO', 'ESTADUAL' TIPO, c.ANO
	 FROM campeonatos c JOIN jogos j ON(J.cod_camp = c.cod_camp)
	 WHERE j.cod_camp = c.cod_camp AND MONTH(j.data) = 2 
								   AND c.ano = 2002	
	 GROUP BY c.dsc_camp, TIPO, c.ano
	 HAVING c.tipo = 'E' 

UNION 

SELECT c.dsc_camp 'CAMPEONATO', 'REGIONAL' TIPO, c.ANO
	 FROM campeonatos c JOIN jogos j ON(j.cod_camp = c.cod_camp)
	 WHERE j.cod_camp = c.cod_camp AND MONTH(j.data) = 2 
								   AND c.ano = 2002	
	 GROUP BY c.dsc_camp, TIPO, c.ano
	 HAVING c.tipo = 'R'

UNION

SELECT c.dsc_camp 'CAMPEONATO', 'NACIONAL' TIPO, c.ANO
	 FROM campeonatos c JOIN jogos j ON(J.cod_camp = c.cod_camp)
	 WHERE j.cod_camp = c.cod_camp AND MONTH(j.data) = 2 
								   AND c.ano = 2002	
	 GROUP BY c.dsc_camp, TIPO, c.ano
	 HAVING c.tipo = 'N'
	 ORDER BY c.dsc_camp
/*
4. Listar todos os patrocinadores do Flamengo do Rio de Janeiro no ano de 2002. No resultado deve estar
presente o nome do patrocinador, seu país de origem, o valor do patrocínio no ano e uma projeção do
valor do patrocínio acrescido de 20%. Esta última coluna deve ser chamada de "Projeção Futura".
*/

SELECT p.nom_pat 'PATROCINADOR', pa.VALOR, pa.valor + (pa.valor*0.2) 'PROJEÇÃO FUTURA'
	FROM patrocinios pa JOIN patrocinadores p ON (pa.cod_pat = p.cod_pat)
	GROUP BY p.nom_pat, p.pais, pa.valor, pa.ano, pa.cod_time
	HAVING pa.ano = 2002 AND pa.cod_time = 1

