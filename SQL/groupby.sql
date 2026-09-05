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