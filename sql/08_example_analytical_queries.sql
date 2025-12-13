-- This SQL script provides example analytical queries to demonstrate how to query the enriched data.

-- Example 1: Aggregate timestamps per gamer (login/logout) to show login/logout pairs.
SELECT GAMER_NAME,
       LISTAGG(GAME_EVENT_LTZ, ' / ') AS login_and_logout
FROM AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED 
GROUP BY GAMER_NAME;

-- Example 2: Calculate each game session's length by pairing each login with the next event (logout) for the same gamer.
SELECT GAMER_NAME,
       GAME_EVENT_LTZ AS login,
       LEAD(GAME_EVENT_LTZ) OVER (PARTITION BY GAMER_NAME ORDER BY GAME_EVENT_LTZ) AS logout,
       COALESCE(DATEDIFF('minute', login, logout), 0) AS game_session_length
FROM AGS_GAME_AUDIENCE.ENHANCED.LOGS_ENHANCED
ORDER BY game_session_length DESC;