-- Transfer Pet and Thrall ownership ID's to our custom tables before we remove old event logs
create table if not exists z_pet_ownership(pet_id bigint null, player_owner_id bigint null, clan_owner_id bigint null);
create table if not exists z_thrall_ownership(thrall_id bigint null, player_owner_id bigint null, clan_owner_id bigint null);
insert into z_pet_ownership (pet_id, player_owner_id, clan_owner_id) select distinct objectid, ownerid, ownerguildid from game_events where not exists ( select pet_id from z_pet_ownership where z_pet_ownership.pet_id = game_events.objectid ) and eventtype = 89 and objectname like '%pet_%';
insert into z_thrall_ownership (thrall_id, player_owner_id, clan_owner_id) select distinct objectid, ownerid, ownerguildid from game_events where not exists ( select thrall_id from z_thrall_ownership where z_thrall_ownership.thrall_id = game_events.objectid ) and eventtype = 89 and objectname like '%Aquilonian%' or objectname like '%Cimmerian%' or objectname like '%Darfari%' or objectname like '%Hyborian%' or objectname like '%Hyrkanian%' or objectname like '%Kambujan%' or objectname like '%Khitan%' or objectname like '%Kushite%' or objectname like '%Lemurian%' or objectname like '%Nordheimer%' or objectname like '%Shemite%' or objectname like '%Stygian%' or objectname like '%Zamorian%' or objectname like '%Zingarian%' or objectname like '%Black_Hand%' or objectname like '%Darfari%' or objectname like '%Dogs%' or objectname like '%Exile%' or objectname like '%Forgotten%' or objectname like '%Heir%' or objectname like '%Lemurian%' or objectname like '%Relic_%' or objectname like '%Votaries%' or objectname like '%Alchemist%' or objectname like '%Archer%' or objectname like '%Armorer%' or objectname like '%Bearer%' or objectname like '%Blacksmith%' or objectname like '%Carpenter%' or objectname like '%Cook%' or objectname like '%Entertainer%' or objectname like '%Fighter%' or objectname like '%Priest%' or objectname like '%Smelter%' or objectname like '%Tanner%' or objectname like '%Taskmaster%' or objectname like '%Witch_Queen%' or objectname like '%broodwarden%';

-- Remove duplicate owned npc id rows from our custom tables above
delete from z_thrall_ownership where rowid not in ( select min(rowid) from z_thrall_ownership group by thrall_id ) ; 
delete from z_pet_ownership where rowid not in ( select min(rowid) from z_pet_ownership group by pet_id ) ;

-- Replace 0 values with Null value
update `z_pet_ownership` set `player_owner_id` = null where player_owner_id = 0;
update `z_pet_ownership` set `clan_owner_id` = null where clan_owner_id = 0;
update `z_thrall_ownership` set `player_owner_id` = null where player_owner_id = 0;
update `z_thrall_ownership` set `clan_owner_id` = null where clan_owner_id = 0;

-- remove inactive player/clan pets
delete from properties where object_id in (select distinct pet_id from z_pet_ownership where player_owner_id in (select id from characters where lastTimeOnline < strftime('%s', 'now', '-6 days')) and player_owner_id not in (select id from characters where guild in (select distinct guild from characters where lastTimeOnline > strftime('%s', 'now', '-6 days') and guild is not null)));
delete from properties where object_id in (select distinct pet_id from z_pet_ownership where clan_owner_id in (select guildid from guilds where guildid not in (select distinct guild from characters where lastTimeOnline > strftime('%s', 'now', '-6 days') and guild is not null)));
delete from actor_position where id in (select distinct pet_id from z_pet_ownership where player_owner_id in (select id from characters where lastTimeOnline < strftime('%s', 'now', '-6 days')) and player_owner_id not in (select id from characters where guild in (select distinct guild from characters where lastTimeOnline > strftime('%s', 'now', '-6 days') and guild is not null)));
delete from actor_position where id in (select distinct pet_id from z_pet_ownership where clan_owner_id in (select guildid from guilds where guildid not in (select distinct guild from characters where lastTimeOnline > strftime('%s', 'now', '-6 days') and guild is not null)));
delete from item_inventory where owner_id in (select distinct pet_id from z_pet_ownership where player_owner_id in (select id from characters where lastTimeOnline < strftime('%s', 'now', '-6 days')) and player_owner_id not in (select id from characters where guild in (select distinct guild from characters where lastTimeOnline > strftime('%s', 'now', '-6 days') and guild is not null)));
delete from item_inventory where owner_id in (select distinct pet_id from z_pet_ownership where clan_owner_id in (select guildid from guilds where guildid not in (select distinct guild from characters where lastTimeOnline > strftime('%s', 'now', '-6 days') and guild is not null)));
delete from character_stats where char_id in (select distinct pet_id from z_pet_ownership where player_owner_id in (select id from characters where lastTimeOnline < strftime('%s', 'now', '-6 days')) and player_owner_id not in (select id from characters where guild in (select distinct guild from characters where lastTimeOnline > strftime('%s', 'now', '-6 days') and guild is not null)));
delete from character_stats where char_id in (select distinct pet_id from z_pet_ownership where clan_owner_id in (select guildid from guilds where guildid not in (select distinct guild from characters where lastTimeOnline > strftime('%s', 'now', '-6 days') and guild is not null)));

-- remove inactive player/clan thralls
delete from properties where object_id in (select distinct thrall_id from z_thrall_ownership where player_owner_id in (select id from characters where lastTimeOnline < strftime('%s', 'now', '-6 days')) and player_owner_id not in (select id from characters where guild in (select distinct guild from characters where lastTimeOnline > strftime('%s', 'now', '-6 days') and guild is not null)));
delete from properties where object_id in (select distinct thrall_id from z_thrall_ownership where clan_owner_id in (select guildid from guilds where guildid not in (select distinct guild from characters where lastTimeOnline > strftime('%s', 'now', '-6 days') and guild is not null)));
delete from actor_position where id in (select distinct thrall_id from z_thrall_ownership where player_owner_id in (select id from characters where lastTimeOnline < strftime('%s', 'now', '-6 days')) and player_owner_id not in (select id from characters where guild in (select distinct guild from characters where lastTimeOnline > strftime('%s', 'now', '-6 days') and guild is not null)));
delete from actor_position where id in (select distinct thrall_id from z_thrall_ownership where clan_owner_id in (select guildid from guilds where guildid not in (select distinct guild from characters where lastTimeOnline > strftime('%s', 'now', '-6 days') and guild is not null)));
delete from item_inventory where owner_id in (select distinct thrall_id from z_thrall_ownership where player_owner_id in (select id from characters where lastTimeOnline < strftime('%s', 'now', '-6 days')) and player_owner_id not in (select id from characters where guild in (select distinct guild from characters where lastTimeOnline > strftime('%s', 'now', '-6 days') and guild is not null)));
delete from item_inventory where owner_id in (select distinct thrall_id from z_thrall_ownership where clan_owner_id in (select guildid from guilds where guildid not in (select distinct guild from characters where lastTimeOnline > strftime('%s', 'now', '-6 days') and guild is not null)));
delete from character_stats where char_id in (select distinct thrall_id from z_thrall_ownership where player_owner_id in (select id from characters where lastTimeOnline < strftime('%s', 'now', '-6 days')) and player_owner_id not in (select id from characters where guild in (select distinct guild from characters where lastTimeOnline > strftime('%s', 'now', '-6 days') and guild is not null)));
delete from character_stats where char_id in (select distinct thrall_id from z_thrall_ownership where clan_owner_id in (select guildid from guilds where guildid not in (select distinct guild from characters where lastTimeOnline > strftime('%s', 'now', '-6 days') and guild is not null)));

-- Deleting character records based on inactivity (10 days)
DELETE FROM characters
WHERE id IN (
    SELECT id
    FROM characters
    WHERE lastTimeOnline < strftime('%s', 'now', '-10 days')
    AND guild IS NULL);

DELETE FROM characters
WHERE id IN (
    SELECT id
    FROM characters
    WHERE lastTimeOnline < strftime('%s', 'now', '-10 days')
    AND guild NOT IN (
        SELECT DISTINCT guild
        FROM characters
        WHERE lastTimeOnline > strftime('%s', 'now', '-10 days')
        AND guild IS NOT NULL));

-- Remove old event logs
delete from game_events where worldTime < strftime('%s', 'now', '-5 days');

-- Remove All Corpse's
delete from item_inventory where owner_id in (select distinct id from actor_position where class like '%corpse%');
delete from actor_position where class like '%Corpse%';
delete from properties where name like '%Corpse%';

--Remove's OP bows from DMT that were spwaning in chests for a while remoce the double dashes below if you wish to use
--delete from item_inventory where template_id in ('2710295','2709883','2709998');

-- This will compress our database, reindex for faster querying, Analyze and then an integrety check and close the database after our transactions above have finished 
VACUUM;
REINDEX;
ANALYZE;
PRAGMA integrity_check;
PRAGMA optimize;