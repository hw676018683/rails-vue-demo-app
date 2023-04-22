create table schedules(
    `id` INTEGER PRIMARY KEY   AUTOINCREMENT,
    `partner_id` INTEGER NOT NULL,
    `date` date(6) not NULL,
    `times` TEXT
);

create table meetings(
    `id` INTEGER PRIMARY KEY   AUTOINCREMENT,
    `partner_id` INTEGER NOT NULL,
    `candidate_id` INTEGER NOT NULL,
    `status` INTEGER NOT NULL,
    `start_at` datetime(6) not NULL
);

create table partners(
    `id` INTEGER PRIMARY KEY   AUTOINCREMENT,
    `name` varchar(100) NOT NULL
);

create table candidates(
    `id` INTEGER PRIMARY KEY   AUTOINCREMENT,
    `name` varchar(100) NOT NULL
);

insert into meetings (partner_id, candidate_id, status, start_at) values(1,1,0,'2023-04-22 09:15:00');
insert into meetings (partner_id, candidate_id, status, start_at) values(2,2,0,'2023-04-22 09:15:00');
insert into meetings (partner_id, candidate_id, status, start_at) values(3,3,0,'2023-04-22 15:15:00');
insert into meetings (partner_id, candidate_id, status, start_at) values(3,4,0,'2023-04-22 16:15:00');
insert into meetings (partner_id, candidate_id, status, start_at) values(1,4,0,'2023-04-22 16:30:00');

insert into partners (name) values('合伙人1');
insert into partners (name) values('合伙人2');
insert into partners (name) values('合伙人3');
insert into partners (name) values('合伙人4');


insert into schedules (partner_id,`date`,times) values(1,'2023-04-22', '["09:15", "09:30", "09:45"]');
insert into schedules (partner_id,`date`,times) values(2,'2023-04-22', '["09:15", "09:30", "09:45"]');


insert into candidates (name) values('创业者1');
insert into candidates (name) values('创业者2');
insert into candidates (name) values('创业者3');
insert into candidates (name) values('创业者4');

curl -XPOST --data '{"partner_id":1,"candidate_id":1, "start_at": "2023-04-22 9:15"}' --header 'Content-Type: application/json' http://localhost:5100/api/calendars
# 每个⼩时⾥有 00,15,30,45 这4个固定的开始时间
curl -XPOST --data '{"partner_id":1,"candidate_id":3, "start_at": "2023-04-22 10:15"}' --header 'Content-Type: application/json' http://localhost:5100/api/calendars
# 同⼀个时间段，⼀个合伙⼈只能⻅⼀个创业者。
curl -XPOST --data '{"partner_id":1,"candidate_id":2, "start_at": "2023-04-22 9:15"}' --header 'Content-Type: application/json' http://localhost:5100/api/calendars

# 取消后，不可被其他⼈预约
curl -XPOST --data '{"partner_id":1,"candidate_id":4, "start_at": "2023-04-22 9:15"}' --header 'Content-Type: application/json' http://localhost:5100/api/calendars

# 合伙人取消
curl -XPUT --header 'Content-Type: application/json' http://localhost:5100/api/calendars/2/cancel

# 创业者1取消
curl -XDELETE --header 'Content-Type: application/json' http://localhost:5100/api/calendars/1

# 同⼀个创业者在同⼀个时间段只能和最多⼀位合伙⼈会⾯。
curl -XPOST --data '{"partner_id":2,"candidate_id":1, "start_at": "2023-04-22 9:15"}' --header 'Content-Type: application/json' http://localhost:5100/api/calendars

# 同⼀个创业者和同⼀个合伙⼈⼀天内只能最多⼀次会⾯。
curl -XPOST --data '{"partner_id":1,"candidate_id":1, "start_at": "2023-04-22 9:30"}' --header 'Content-Type: application/json' http://localhost:5100/api/calendars
