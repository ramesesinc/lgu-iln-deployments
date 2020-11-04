use etracs255_ilocosnorte;


update depositvoucher set state='POSTED' where controldate <= '2020-10-31' and state = 'OPEN'; 

drop table if exists ztmp_fix_deposited_checks
;
create table ztmp_fix_deposited_checks 
select 
	cp.objid as checkpaymentid, 
	dv.objid as depositvoucherid, 
	dvf.fundid as fundid 
from depositvoucher dv 
	inner join depositvoucher_fund dvf on dvf.parentid = dv.objid 
	inner join depositslip ds on ds.depositvoucherfundid = dvf.objid 
	inner join checkpayment cp on cp.depositslipid = ds.objid 
where ds.deposittype = 'CHECK' 
	and cp.fundid is null 
; 
update 
	checkpayment aa, ztmp_fix_deposited_checks bb 
set 
	aa.depositvoucherid = bb.depositvoucherid, 
	aa.fundid = bb.fundid 
where 
	aa.objid = bb.checkpaymentid 
; 
drop table if exists ztmp_fix_deposited_checks
;


drop table if exists ztmp_fix_untrack_checks
;
create table ztmp_fix_untrack_checks
select cp.objid 
from checkpayment cp 
	left join depositslip ds on ds.objid = cp.depositslipid 
where cp.depositslipid is not null 
	and ds.objid is null 
;
update checkpayment aa, ztmp_fix_untrack_checks bb 
set aa.depositslipid = null 
where aa.objid = bb.objid 
; 
drop table if exists ztmp_fix_untrack_checks
;



drop table if exists ztmp_fix_cashreceipt_checks
;
create table ztmp_fix_cashreceipt_checks
select distinct nc.receiptid, nc.refid 
from depositvoucher dv 
	inner join collectionvoucher cv on cv.depositvoucherid = dv.objid 
	inner join remittance r on r.collectionvoucherid = cv.objid 
	inner join cashreceipt c on c.remittanceid = r.objid 
	inner join cashreceiptpayment_noncash nc on nc.receiptid = c.objid 
	inner join checkpayment cp on cp.objid = nc.refid 
	left join cashreceipt_void v on v.receiptid = c.objid 
where dv.controldate > '2020-10-31' 
	and v.objid is null 
;
create index ix_receiptid on ztmp_fix_cashreceipt_checks (receiptid)
;
create index ix_refid on ztmp_fix_cashreceipt_checks (refid)
;
delete from cashreceiptpayment_noncash where receiptid in (
	select receiptid from ztmp_fix_cashreceipt_checks 
	where receiptid = cashreceiptpayment_noncash.receiptid 
)
;
insert into cashreceiptpayment_noncash ( 
	objid, receiptid, refno, refdate, reftype, amount, 
	particulars, refid, checkid, fund_objid  
) 
select 
	concat('CRPN-',MD5(concat(t1.receiptid, t1.refid, t1.fundid))) as objid, 
	t1.receiptid, cp.refno, cp.refdate, 'CHECK' as reftype, t1.amount, 
	concat(cp.refno, ' (', b.code, ') dated ', convert(cp.refdate, char(10))) as particulars, 
	t1.refid, t1.refid as checkid, t1.fundid 
from ( 
	select z.receiptid, z.refid, ci.item_fund_objid as fundid, sum(ci.amount) as amount 
	from ztmp_fix_cashreceipt_checks z 
		inner join cashreceiptitem ci on ci.receiptid = z.receiptid 
	group by z.receiptid, z.refid, ci.item_fund_objid 
)t1 
	inner join checkpayment cp on cp.objid = t1.refid 
	inner join bank b on b.objid = cp.bankid 
; 
