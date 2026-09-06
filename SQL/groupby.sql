use fitgym;

select
    count(level)
from
    members;

-- 第 1 关 条件+排序：查出所有 A、B 级会员，按入会日期倒序
select
    card_id,name
from members
where level != 'c'
order by join_date desc;

-- 第 2 关 分页：查出最新入会的 3 名会员（姓名+日期）
select
    name , join_date
from members
order by join_date desc
limit 3;

-- 第 3 关 分组统计：统计各等级会员人数，只显示人数 ≥ 2 的等级
select  level 等级,count(level) 数量
from members
group by level
having count(level) >= 2;

-- 第 4 关 两表 JOIN：查出会员"张三"的所有约课记录（课程名+约课时间）
select mb.name 姓名,cur.title 课程名, bk.booking_time 约课时间
from members mb,courses cur,bookings bk
where mb.card_id = bk.card_id and cur.id = bk.course_id and mb.name = '张三';

-- 第 5 关 三表 JOIN+分组：课程约课人次排行榜——每门课的约课人次，按人次倒序（课程名 + 人次）

select c.title 课程名, count(*) 预约人数
from bookings b
join courses c on b.course_id = c.id
group by c.title
order by count(*) desc

-- 第 6 关 LEFT JOIN：找出从未约过课的"沉睡会员"名单

select  m.name 姓名 ,count(*) 约课次数
from bookings b
join members m on b.card_id = m.card_id
group by m.name
having count(*) <1

