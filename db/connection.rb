require "pg"

$db = PG.connect({dbname: 'flame_forum'})