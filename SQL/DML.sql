use fitgym;

-- 插入数据
insert into members (card_id, name, phone, level, join_date)values
    (1,'卢德志',13472625217,'A',now()),
    (2,'张三',13472625218,'B',now()),
    (3,'李四',13472625219,'A',now()),
    (4,'王五',13472625210,'A',now()),
    (5,'郭继凡',13472625211,'A',now());

-- 修改数据
update members set level = 'A' where card_id = 2;

-- 删除数据
delete
from members
where card_id = 4;

-- 跟练



