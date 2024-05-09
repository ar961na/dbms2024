-- 0. Чистка данных
delete from LOG where user_id is null;
update LOG set user_id = substr(user_id, instr(user_id, 'user_'));
update LOG set user_id = replace(user_id , 'user', 'User');
delete from LOG where instr(user_id, 'User_') = 0;

delete from USERS where instr(user_id, 'User_') = 0;

-- 1.Сколько раз человеку надо прийти, чтобы сделать ставку?
select round(avg(visits), 3) as avg_visits
from (select LOG.user_id, count(*) as visits
      from LOG
               cross join (select user_id, min(time) as first_bet_time
                           from LOG
                           where bet != ''
                           group by user_id) as first_bet
      where LOG.time <= first_bet.first_bet_time
        and LOG.user_id = first_bet.user_id
      group by LOG.user_id);

-- 2. Каков средний выигрыш в процентах?
select round(avg(id_win_percent), 3) as win_percent
from (select (win - bet) / bet * 100 as id_win_percent
      from LOG
      where bet != '');

-- 3. Каков баланс по каждому пользователю?
select user_id, balance
from (select user_id, sum(win) - sum(bet) as balance
      from LOG
      group by user_id);

-- 4. Какие города самые выгодные?
select geo, round(avg(geo_win_percent), 3) as win_percent
from (select geo, (win - bet) / bet * 100 as geo_win_percent
      from USERS
               join LOG on USERS.user_id = LOG.user_id
      where bet != '')
where geo != ''
group by geo
order by win_percent desc;

-- 5. В каких городах самая высокая ставка?
select geo, round(avg(bet), 3) as average_bet
from USERS
         join LOG on USERS.user_id = LOG.user_id
where geo != ''
group by geo
order by -average_bet;

-- 6. Сколько в среднем времени проходит от первого посещения сайта до первой попытки?
select avg(
               julianday(strftime('%Y-%m-%d %H:%M:%S', substr(first_bet_time, 2)))
                   - julianday(strftime('%Y-%m-%d %H:%M:%S', substr(first_visit_time, 2)))) as days_difference
from (select user_id, min(time) as first_visit_time
      from LOG
      group by user_id) as first_visit
         cross join (select user_id, min(time) as first_bet_time
                     from LOG
                     where bet != ''
                     group by user_id) as first_bet
where first_visit_time <= first_bet_time
  and first_visit.user_id = first_bet.user_id;