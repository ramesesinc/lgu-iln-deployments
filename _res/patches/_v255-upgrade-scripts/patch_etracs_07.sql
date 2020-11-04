use etracs255_ilocosnorte;

insert into afunit ( 
	objid, itemid, unit, qty, saleprice, `interval` 
) 
select * from ( 
	select 
		concat(b.itemid,'-',b.unit) as objid, b.itemid, b.unit, b.qty, 0.0 as saleprice, 
		case when a.formtype = 'serial' then 1 else 0 end as `interval` 
	from af a, z20181120_stockitem_unit b 
	where a.objid = b.itemid 
)t1 
where t1.objid not in (select objid from afunit where objid = t1.objid)
;


INSERT IGNORE INTO aftxn_type (`txntype`, `formtype`, `poststate`, `sortorder`) VALUES ('BEGIN', 'BEGIN_BALANCE', 'OPEN', '1');
INSERT IGNORE INTO aftxn_type (`txntype`, `formtype`, `poststate`, `sortorder`) VALUES ('COLLECTION', 'ISSUE', 'ISSUED', '3');
INSERT IGNORE INTO aftxn_type (`txntype`, `formtype`, `poststate`, `sortorder`) VALUES ('FORWARD', 'FORWARD', 'ISSUED', '2');
INSERT IGNORE INTO aftxn_type (`txntype`, `formtype`, `poststate`, `sortorder`) VALUES ('RETURN_COLLECTION', 'RETURN', 'OPEN', '7');
INSERT IGNORE INTO aftxn_type (`txntype`, `formtype`, `poststate`, `sortorder`) VALUES ('RETURN_SALE', 'RETURN', 'OPEN', '8');
INSERT IGNORE INTO aftxn_type (`txntype`, `formtype`, `poststate`, `sortorder`) VALUES ('SALE', 'ISSUE', 'SOLD', '4');
INSERT IGNORE INTO aftxn_type (`txntype`, `formtype`, `poststate`, `sortorder`) VALUES ('TRANSFER_COLLECTION', 'TRANSFER', 'ISSUED', '5');
INSERT IGNORE INTO aftxn_type (`txntype`, `formtype`, `poststate`, `sortorder`) VALUES ('TRANSFER_SALE', 'TRANSFER', 'ISSUED', '6');


update afunit a, af set 
	a.cashreceiptprintout = concat('cashreceipt-form:', a.itemid) 
where af.objid = a.itemid 
	and af.formtype = 'serial' 
	and a.cashreceiptprintout is null 
;


update afunit set 
	cashreceiptprintout = 'cashreceipt:printout:51', 
	cashreceiptdetailprintout = 'cashreceiptdetail:printout:51' 
where itemid = '51' and unit = 'STUB' 
; 


update afunit set 
	cashreceiptprintout = 'cashreceipt-form:56', 
	cashreceiptdetailprintout = 'cashreceiptdetail:printout:56' 
where itemid = '56' and unit = 'STUB' 
; 


update itemaccount set state = 'ACTIVE' where state = 'APPROVED' ;
update itemaccount set state = 'DRAFT' where state <> 'ACTIVE' ;


INSERT INTO itemaccount (`objid`, `state`, `code`, `title`, `type`, `generic`, `sortorder`) 
VALUES ('CASH_IN_TREASURY', 'ACTIVE', '-', 'CASH IN TREASURY', 'CASH_IN_TREASURY', 0, 0)
;


insert into itemaccount ( 
	objid, state, type, code, title,  fund_objid, fund_code, 
	fund_title, defaultvalue, valuetype, generic, sortorder 
) 
select * from ( 
	select 
		concat('CIB-', objid) as objid, 'ACTIVE' as state, 'CASH_IN_BANK' as type, '-' as code, 
		concat('CASH IN BANK - ', title) as title, objid as fund_objid, code as fund_code, 
		title as fund_title, 0.0 as defaultvalue, 'ANY' as valuetype, 0 as generic, 0 as sortorder 
	from fund 
	where state = 'ACTIVE' 
)t1 
where t1.objid not in (select objid from itemaccount where objid = t1.objid)
; 


update bankaccount ba, itemaccount ia 
set ba.acctid = ia.objid  
where ia.objid = concat('CIB-', ba.fund_objid) and ba.acctid is null 
; 


insert ignore into business_application_task_lock ( 
	refid, state 
) 
select bat.refid, bat.state  
from ( 
	select t1.*, 
		(
			select objid from business_application_task 
			where refid = t1.objid  
			order by startdate desc, enddate desc 
			limit 1 
		) as currenttaskid 
	from ( select objid from business_application where state <> 'COMPLETED' )t1 
)t2, business_application_task bat 
where bat.objid = t2.currenttaskid 
; 


insert into collectionvoucher (
	objid, state, controlno, controldate, amount, totalcash, totalcheck, totalcr, cashbreakdown, 
	liquidatingofficer_objid, liquidatingofficer_name, liquidatingofficer_title, dtposted 
) 
select 
	objid, state, txnno as controlno, dtposted as controldate, 
	amount, totalcash, totalnoncash as totalcheck, 0.0 as totalcr, cashbreakdown, 
	liquidatingofficer_objid, liquidatingofficer_name, liquidatingofficer_title, 
	dtposted 
from z20181120_liquidation 
;


drop table if exists ztmp_collectionvoucher_fund
;
create table ztmp_collectionvoucher_fund 
select 
	lcf.objid, cv.objid as parentid, concat(cv.controlno,'-',fund.code) as controlno, 
	lcf.fund_objid, lcf.fund_title, lcf.amount, 
	case when lcf.totalcash is null then lcf.amount else lcf.totalcash end as totalcash, 
	case when lcf.totalnoncash is null then 0.0 else lcf.totalnoncash end as totalcheck, 
	0.0 as totalcr, 
	case when lcf.cashbreakdown is null then '[]' else lcf.cashbreakdown end as cashbreakdown 
from z20181120_liquidation_cashier_fund lcf 
	inner join collectionvoucher cv on cv.objid = lcf.liquidationid 
	inner join fund on fund.objid = lcf.fund_objid 
;
drop table if exists ztmp_collectionvoucher_fund_phase1
;
create table ztmp_collectionvoucher_fund_phase1 
select parentid, fund_objid, sum(amount) as amount, count(*) as icount  
from ztmp_collectionvoucher_fund 
group by parentid, fund_objid 
having count(*) > 1 
;
drop table if exists ztmp_collectionvoucher_fund_phase2
;
create table ztmp_collectionvoucher_fund_phase2 
select a.parentid, a.fund_objid, a.amount, min(b.objid) as objid 
from ztmp_collectionvoucher_fund_phase1 a, ztmp_collectionvoucher_fund b 
where a.parentid = b.parentid and a.fund_objid = b.fund_objid 
group by a.parentid, a.fund_objid, a.amount  
;
update ztmp_collectionvoucher_fund aa, ztmp_collectionvoucher_fund_phase2 bb 
set aa.amount = bb.amount  
where aa.objid = bb.objid
;
drop table if exists ztmp_collectionvoucher_fund_phase3
;
create table ztmp_collectionvoucher_fund_phase3 
select a.objid  
from ztmp_collectionvoucher_fund a, ztmp_collectionvoucher_fund_phase2 b 
where a.parentid = b.parentid 
	and a.fund_objid = b.fund_objid 
	and a.objid <> b.objid 
;
delete from ztmp_collectionvoucher_fund where objid in (
	select objid from ztmp_collectionvoucher_fund_phase3 
)
;
drop table if exists ztmp_collectionvoucher_fund_phase3 ; 
drop table if exists ztmp_collectionvoucher_fund_phase2 ; 
drop table if exists ztmp_collectionvoucher_fund_phase1 ; 

insert into collectionvoucher_fund (
	objid, parentid, controlno, fund_objid, fund_title, 
	amount, totalcash, totalcheck, totalcr, cashbreakdown 
) 
select 
	objid, parentid, controlno, fund_objid, fund_title, 
	amount, totalcash, totalcheck, totalcr, cashbreakdown 
from ztmp_collectionvoucher_fund 
;

drop table if exists ztmp_collectionvoucher_fund
;


drop table if exists ztmp_collectionvoucherdeposit
;
create table ztmp_collectionvoucherdeposit 
select distinct 
	cvf.parentid as collectionvoucherid, bdl.bankdepositid as depositvoucherid  
from z20181120_bankdeposit_liquidation bdl 
	inner join collectionvoucher_fund cvf on cvf.objid = bdl.objid 
;

insert into depositvoucher (
	objid, state, controlno, controldate, 
	dtcreated, createdby_objid, createdby_name, 
	amount, dtposted, postedby_objid, postedby_name 
) 
select 
	bd.objid, bd.state, bd.txnno as controlno, bd.dtposted as controldate, 
	bd.dtposted as dtcreated, cashier_objid as createdby_objid, cashier_name as createdby_name, 
	bd.amount, bd.dtposted, cashier_objid as postedby_objid, cashier_name as postedby_name  
from ( 
	select distinct depositvoucherid 
	from ztmp_collectionvoucherdeposit 
)t1, z20181120_bankdeposit bd 
where bd.objid = t1.depositvoucherid 
;

update 	
	collectionvoucher aa, ( 
		select z.* 
		from depositvoucher dv, ztmp_collectionvoucherdeposit z 
		where dv.objid = z.depositvoucherid 
	)bb 
set aa.depositvoucherid = bb.depositvoucherid 
where aa.objid = bb.collectionvoucherid 
; 

update collectionvoucher set state='POSTED' where state='OPEN';  

update 
	remittance aa, ( 
		select z.* 
		from z20181120_liquidation_remittance z, collectionvoucher cv  
		where cv.objid = z.liquidationid 
	)bb 
set aa.collectionvoucherid = bb.liquidationid  
where aa.objid = bb.objid
;

update remittance set state = 'POSTED' where state in ('OPEN','APPROVED'); 

create table ztmp_depositvoucher_fund
select 
	concat(dv.objid,'|',ba.fund_objid) as objid, 'POSTED' as state, 
	dv.objid as parentid, ba.fund_objid as fundid, ze.amount, 
	ze.amount as amountdeposited, 0.0 as totaldr, 0.0 as totalcr 
from ( 
	select distinct depositvoucherid 
	from ztmp_collectionvoucherdeposit
)t1, depositvoucher dv, z20181120_bankdeposit_entry ze, bankaccount ba 
where dv.objid = t1.depositvoucherid 
	and ze.parentid = dv.objid 
	and ba.objid = ze.bankaccount_objid 
;

create table ztmp_depositvoucher_fund_fixed_duplicate
select 
	vf.parentid, vf.fundid, sum(vf.amount) as amount, 
	sum(vf.amountdeposited) as amountdeposited, 
	sum(vf.totaldr) as totaldr, sum(vf.totalcr) as totalcr 
from ( 
	select parentid, fundid, count(*) as icount 
	from ztmp_depositvoucher_fund 
	group by parentid, fundid 
	having count(*) > 1 
)t1, ztmp_depositvoucher_fund vf 
where vf.parentid = t1.parentid 
	and vf.fundid = t1.fundid 
group by vf.parentid, vf.fundid 
; 

delete from ztmp_depositvoucher_fund where (
	select count(*) from ztmp_depositvoucher_fund_fixed_duplicate 
	where parentid = ztmp_depositvoucher_fund.parentid 
		and fundid = ztmp_depositvoucher_fund.fundid 
) > 0 
;

insert into depositvoucher_fund ( 
	objid, state, parentid, fundid, amount, amountdeposited, totaldr, totalcr 
) 
select 
	concat(parentid,'|',fundid) as objid, 'POSTED' as state, 
	parentid, fundid, amount, amountdeposited, totaldr, totalcr 
from ztmp_depositvoucher_fund 
;

insert into depositvoucher_fund ( 
	objid, state, parentid, fundid, amount, amountdeposited, totaldr, totalcr 
) 
select 
	concat(parentid,'|',fundid) as objid, 'POSTED' as state, 
	parentid, fundid, amount, amountdeposited, totaldr, totalcr 
from ztmp_depositvoucher_fund_fixed_duplicate 
;

drop table ztmp_depositvoucher_fund_fixed_duplicate;
drop table ztmp_depositvoucher_fund;


alter table remittance_fund modify objid varchar(150) not null ;

alter table remittance_af modify objid varchar(150) not null ;


insert into checkpayment (
	objid, bankid, bank_name, refno, refdate, amount, amtused, receivedfrom, 
	collector_objid, collector_name, state, split, external 
) 
select 
	nc.objid, bank.objid as bankid, bank.name as bank_name, nc.refno, nc.refdate, 
	nc.amount, nc.amount as amtused, c.paidby as receivedfrom, 
	c.collector_objid, c.collector_name, 'PENDING' as state, 0 as split, 0 as `external` 
from cashreceiptpayment_noncash nc, cashreceipt c, bank 
where nc.receiptid = c.objid 
	and nc._bankid = bank.objid 
	and nc.reftype = 'CHECK' 
; 

update cashreceiptpayment_noncash nc, checkpayment p 
set nc.refid = p.objid, nc.checkid = p.objid 
where nc.objid = p.objid and nc.refid is null 
; 


insert into checkpayment_deadchecks (
	objid, refno, refdate, amount, amtused, 
	collector_objid, collectorid, bankid, bank_name, 
	receivedfrom, state, split, `external`   
) 
select 
	p.objid, p.refno, p.refdate, p.amount, p.amtused, 
	p.collector_objid, p.collector_objid, p.bankid, p.bank_name, 
	p.receivedfrom, p.state, p.split, p.`external` 
from cashreceipt_void v 
	inner join cashreceipt c on c.objid = v.receiptid 
	inner join cashreceiptpayment_noncash nc on nc.receiptid = c.objid 
	inner join checkpayment p on p.objid = nc.objid 
where nc.reftype = 'CHECK'
;


delete from checkpayment where objid in ( 
	select objid from checkpayment_deadchecks 
);


drop table if exists ztmp_depositedchecks
;
create table ztmp_depositedchecks  
select 
	nc.receiptid, nc.refid as checkid, c.remittanceid, r.collectionvoucherid, cv.depositvoucherid 
from cashreceipt c 
	inner join cashreceiptpayment_noncash nc on (nc.receiptid = c.objid and nc.reftype='CHECK')
	inner join remittance r on r.objid = c.remittanceid 
	inner join collectionvoucher cv on cv.objid = r.collectionvoucherid 
	inner join depositvoucher dv on dv.objid = cv.depositvoucherid 
	left join cashreceipt_void v on v.receiptid = c.objid 
where v.objid is null 
;

update checkpayment cp, ztmp_depositedchecks z 
set cp.depositvoucherid = z.depositvoucherid 
where cp.objid = z.checkid  
;


insert into depositslip (
	objid, state, depositvoucherfundid, depositdate, deposittype, checktype, 
	dtcreated, createdby_objid, createdby_name, 
	bankacctid, amount, totalcash, totalcheck, cashbreakdown, 
	validation_refno, validation_refdate 
) 
select 
	concat(ze.objid,'|CASH') as objid, ze.state, concat(dv.objid,'|',ba.fund_objid) as depositvoucherfundid, 
	dv.controldate as depositdate, 'CASH' as deposittype, null as checktype, 
	dv.dtcreated, dv.createdby_objid, dv.createdby_name, 
	ze.bankaccount_objid as bankacctid, ze.totalcash as amount, ze.totalcash, 0.0 as totalcheck, ze.cashbreakdown, 
	ze.validationno as validation_refno, ze.validationdate as validation_refdate 
from depositvoucher dv 
	inner join z20181120_bankdeposit_entry ze on ze.parentid = dv.objid 
	inner join bankaccount ba on ba.objid = ze.bankaccount_objid 
where ze.amount > 0 
	and ze.totalcash > 0 
;


insert into depositslip (
	objid, state, depositvoucherfundid, depositdate, deposittype, checktype, 
	dtcreated, createdby_objid, createdby_name, 
	bankacctid, amount, totalcash, totalcheck, cashbreakdown, 
	validation_refno, validation_refdate 
) 
select 
	concat(ze.objid,'|CHECK') as objid, ze.state, 
	concat(dv.objid,'|',ba.fund_objid) as depositvoucherfundid, 
	dv.controldate as depositdate, 'CHECK' as deposittype, bank.deposittype as checktype, 
	dv.dtcreated, dv.createdby_objid, dv.createdby_name, 
	ze.bankaccount_objid as bankacctid, ze.totalnoncash as amount, 0.0 as totalcash, 
	ze.totalnoncash as totalcheck, '[]' as cashbreakdown, 
	ze.validationno as validation_refno, ze.validationdate as validation_refdate 
from depositvoucher dv 
	inner join z20181120_bankdeposit_entry ze on ze.parentid = dv.objid 
	inner join bankaccount ba on ba.objid = ze.bankaccount_objid 
	inner join bank on bank.objid = ba.bank_objid 
where ze.amount > 0 
	and ze.totalnoncash > 0 
;

update 
	checkpayment aa, ( 
		select 
			zec.objid as checkpaymentid, 
			concat(ze.objid,'|CHECK') as depositslipid 
		from z20181120_bankdeposit_entry_check zec, z20181120_bankdeposit_entry ze 
		where ze.objid = zec.parentid
	)bb 
set aa.depositslipid = bb.depositslipid  
where aa.objid = bb.checkpaymentid
;

update depositslip set state='APPROVED' where validation_refno is null 
;
update depositslip set state='VALIDATED' where validation_refno is not null 
;

alter table collectiontype add queuesection varchar(50) NULL
;

-- alter table remittance 
--     modify txnmode varchar(50) null
-- ;

alter table eftpayment 
	modify fundid varchar(100)
; 