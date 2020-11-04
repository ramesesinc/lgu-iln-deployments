use etracs255_ilocosnorte;

alter table af add ( 
  `baseunit` varchar(10) NULL,
  `defaultunit` varchar(10) NULL   
)
;

alter table af_control add ( 
  `dtfiled` date NULL,
  `state` varchar(50) NULL,
  `unit` varchar(25) NULL,
  `batchno` int NULL,
  `respcenter_objid` varchar(50) NULL,
  `respcenter_name` varchar(100) NULL,
  `cost` decimal(16,2) NULL,
  `currentindexno` int NULL,
  `currentdetailid` varchar(150) NULL,
  `batchref` varchar(50) NULL,
  `lockid` varchar(50) NULL,
  `allocid` varchar(50) NULL,
  `ukey` varchar(50) NOT NULL DEFAULT ''
)
;
create index ix_dtfiled on af_control (dtfiled) ; 
create index ix_state on af_control (state) ; 
create index ix_batchno on af_control (batchno) ; 
create index ix_respcenter_objid on af_control (respcenter_objid) ; 
create index ix_respcenter_name on af_control (respcenter_name) ; 
create index ix_currentdetailid on af_control (currentdetailid) ; 
create index ix_allocid on af_control (allocid) ; 
create index ix_ukey on af_control (ukey) ; 

alter table af_control modify afid varchar(50) not null ; 
alter table af_control modify startseries int not null ; 
alter table af_control modify currentseries int not null ; 
alter table af_control modify endseries int not null ; 

update af_control set ukey = md5( objid ); 
update af_control set prefix = '' where prefix is null; 
update af_control set suffix = '' where suffix is null; 

create unique index uix_af_control on af_control ( afid, startseries, prefix, suffix, ukey );  

alter table af_control modify prefix varchar(10) not null default ''; 
alter table af_control modify suffix varchar(10) not null default ''; 


update z20181120_af_inventory_detail set qtyreceived=0 where qtyreceived is null; 
update z20181120_af_inventory_detail set qtybegin=0 where qtybegin is null; 
update z20181120_af_inventory_detail set qtyissued=0 where qtyissued is null; 
update z20181120_af_inventory_detail set qtyending=0 where qtyending is null; 
update z20181120_af_inventory_detail set qtycancelled=0 where qtycancelled is null; 
update z20181120_af_inventory_detail set refno=refid where refdate is not null and refid is not null and refno is null 
;
insert into af_control_detail ( 
  objid, state, controlid, indexno, refid, refno, reftype, refdate, txndate, txntype, 
  receivedstartseries, receivedendseries, beginstartseries, beginendseries, 
  issuedstartseries, issuedendseries, endingstartseries, endingendseries, 
  qtyreceived, qtybegin, qtyissued, qtyending, qtycancelled, remarks, 
  issuedto_objid, issuedto_name
) 
select 
  d.objid, 1 as state, d.controlid, d.lineno, d.refid, d.refno, d.reftype, d.refdate, d.txndate, d.txntype, 
  d.receivedstartseries, d.receivedendseries, d.beginstartseries, d.beginendseries, 
  d.issuedstartseries, d.issuedendseries, d.endingstartseries, d.endingendseries, 
  d.qtyreceived, d.qtybegin, d.qtyissued, d.qtyending, d.qtycancelled, d.remarks, 
  a.owner_objid, a.owner_name 
from af_control a 
  inner join z20181120_af_inventory_detail d on d.controlid = a.objid 
where d.refdate is not null 
;
update af_control_detail set reftype='ISSUE', txntype='COLLECTION' where reftype='stockissue' and txntype in ('ISSUANCE-RECEIPT','ISSUE-RECEIPT') 
;
update af_control_detail set reftype='FORWARD', txntype='FORWARD' where reftype='SYSTEM' and txntype='ISSUANCE-RECEIPT'
; 
update af_control_detail set reftype='FORWARD', txntype='FORWARD' where reftype='SYSTEM' and txntype='COLLECTOR BEG.BAL.'
;
UPDATE af_control_detail set reftype=upper(reftype) where reftype = 'remittance' 
; 
update af_control_detail set reftype=upper(reftype), txntype='TRANSFER_COLLECTION' where reftype='TRANSFER'
; 


drop view if exists z20181120_vw_af_inventory_detail
;
create view z20181120_vw_af_inventory_detail as 
select 
  a.afid, a.respcenter_type, a.respcenter_objid, a.respcenter_name, 
  a.unit, a.startseries, a.endseries, a.cost as unitcost,  
  d.* 
from z20181120_af_inventory_detail d 
  inner join z20181120_af_inventory a on a.objid = d.controlid 
;
drop view if exists z20181120_vw_af_stockissuance
;
create view z20181120_vw_af_stockissuance as 
select 
  a.afid, a.respcenter_type, a.respcenter_objid, a.respcenter_name, 
  a.unit, a.startseries, a.endseries, a.cost as unitcost, 
  d.objid, d.lineno, d.controlid, d.refid, d.reftype, d.refno, d.refdate, 
  d.txntype, d.txndate, d.remarks, d.cost 
from z20181120_af_inventory_detail d 
  inner join z20181120_af_inventory a on a.objid = d.controlid 
where d.reftype = 'stockissue' 
  and d.txntype = 'ISSUANCE'
;
drop view if exists z20181120_vw_af_stockissuancereceipt
;
create view z20181120_vw_af_stockissuancereceipt as 
select 
  a.afid, a.respcenter_type, a.respcenter_objid, a.respcenter_name, 
  a.unit, a.startseries, a.endseries, a.cost as unitcost, 
  d.objid, d.lineno, d.controlid, d.refid, d.reftype, d.refno, d.refdate, 
  d.txntype, d.txndate, d.remarks, d.cost, 
  d.receivedstartseries, d.receivedendseries, d.qtyreceived 
from z20181120_af_inventory_detail d 
  inner join z20181120_af_inventory a on a.objid = d.controlid 
where d.reftype = 'stockissue' 
  and d.txntype = 'ISSUANCE-RECEIPT'
;
drop view if exists z20181120_vw_af_stockreceipt 
;
create view z20181120_vw_af_stockreceipt as 
select 
  a.afid, a.respcenter_type, a.respcenter_objid, a.respcenter_name, 
  a.unit, a.startseries, a.endseries, a.cost as unitcost, 
  d.objid, d.lineno, d.controlid, d.refid, d.reftype, d.refno, d.refdate, 
  d.txntype, d.txndate, d.remarks, d.cost 
from z20181120_af_inventory_detail d 
  inner join z20181120_af_inventory a on a.objid = d.controlid 
where d.reftype = 'stockreceipt' 
  and d.txntype = 'RECEIPT'
;

insert ignore into af_control_detail ( 
  objid, state, controlid, indexno, refid, refno, reftype, refdate, txndate, txntype, 
  receivedstartseries, receivedendseries, beginstartseries, beginendseries, 
  issuedstartseries, issuedendseries, endingstartseries, endingendseries, 
  qtyreceived, qtybegin, qtyissued, qtyending, qtycancelled, 
  remarks, issuedto_objid, issuedto_name 
) 
select distinct 
  concat(ir.controlid,'-00') as objid, 1 as state, ir.controlid, 0 as indexno, 
  r.refid, r.refno, 'PURCHASE_RECEIPT' as reftype, r.refdate, r.txndate, 'PURCHASE' as txntype, 
  ir.receivedstartseries, ir.receivedendseries, 
  null as beginstartseries, null as beginendseries, 
  null as issuedstartseries, null as issuedendseries, 
  ir.receivedstartseries as endingstartseries, ir.receivedendseries as endingendseries, 
  ir.qtyreceived, 0 as qtybegin, 0 as qtyissued, ir.qtyreceived as qtyending, 0 as qtycancelled, 
  convert(r.remarks, char(255)) as remarks, null as issuedto_objid, null as issuedto_name 
from ( 
  select ir.objid as issuancereceiptid,  
    (select objid from z20181120_vw_af_stockissuance where refid=ir.refid and afid=ir.afid order by lineno desc limit 1) as issuanceid 
  from z20181120_vw_af_stockissuancereceipt ir 
)t1 
  inner join z20181120_vw_af_stockissuancereceipt ir on ir.objid = t1.issuancereceiptid 
  inner join af_control afc on afc.objid = ir.controlid 
  inner join z20181120_vw_af_stockissuance i on i.objid = t1.issuanceid 
  inner join z20181120_vw_af_stockreceipt r on r.controlid = i.controlid 
; 
update af_control_detail set 
  beginstartseries = issuedstartseries, 
  beginendseries = ifnull(endingendseries, issuedendseries) 
where reftype='REMITTANCE' and txntype='REMITTANCE' 
; 

update 
  af_control_detail aa, ( 
    select d.objid, d.refid, r.collector_objid, r.collector_name 
    from af_control_detail d 
      inner join remittance r on r.objid = d.refid 
    where d.reftype='REMITTANCE' 
      and d.txntype='REMITTANCE' 
  )bb 
set 
  aa.issuedto_objid = bb.collector_objid, 
  aa.issuedto_name = bb.collector_name 
where aa.objid = bb.objid 
;

update 
  af_control aa, ( 
    select controlid, min(refdate) as refdate 
    from af_control_detail 
    group by controlid 
  )bb 
set aa.dtfiled = bb.refdate 
where aa.objid = bb.controlid 
  and aa.dtfiled is null 
; 

update af_control set state = 'ISSUED' where state is null 
;

update af_control aaa, ( 
    select d.controlid, d.indexno, d.objid 
    from ( 
      select a.objid, 
        (
          select objid from af_control_detail 
          where controlid=a.objid 
          order by refdate desc, txndate desc, indexno desc 
          limit 1 
        ) as lastdetailid 
      from af_control a 
    )t1, af_control_detail d 
    where d.objid = t1.lastdetailid 
  )bbb 
set 
  aaa.currentindexno = bbb.indexno, 
  aaa.currentdetailid = bbb.objid 
where aaa.objid = bbb.controlid 
; 

update 
  af_control aa, ( 
    select t1.*, d.indexno as currentindexno  
    from ( 
      select a.objid, 
        (select objid from af_control_detail where controlid = a.objid order by refdate desc, txndate desc limit 1) as currentdetailid 
      from af_control a 
      where a.currentdetailid is null 
    )t1, af_control_detail d 
    where d.objid = t1.currentdetailid 
  )bb 
set 
  aa.currentdetailid = bb.currentdetailid, 
  aa.currentindexno = bb.currentindexno 
where aa.objid = bb.objid 
;

update 
  af_control aa, ( 
    select afc.objid, ai.unit  
    from af_control afc, z20181120_af_inventory ai  
    where afc.objid = ai.objid 
      and afc.unit is null 
  )bb 
set aa.unit = bb.unit 
where aa.objid = bb.objid 
;

update 
  af_control aa, ( 
    select d.controlid, d.refno 
    from ( 
      select a.objid, 
        (
          select objid from af_control_detail 
          where controlid = a.objid and reftype in ('BEGIN_BALANCE','FORWARD','PURCHASE_RECEIPT','TRANSFER') 
          order by refdate, txndate, indexno desc limit 1 
        ) as detailid 
      from af_control a 
      where a.batchref is null 
    )t1, af_control_detail d 
    where d.objid = t1.detailid 
  )bb 
set aa.batchref = bb.refno, aa.batchno = 1  
where aa.objid = bb.controlid 
; 

update 
  af_control aa, ( 
    select afc.objid, 
      (select min(receiptdate) from cashreceipt where controlid = afc.objid) as receiptdate 
    from af_control afc 
    where afc.dtfiled is null
  )bb 
set aa.dtfiled = bb.receiptdate 
where aa.objid = bb.objid
; 

create table ztmp_afcontrol_no_dtfiled
select * from af_control where dtfiled is null 
; 
delete from af_control where objid in (
  select objid from ztmp_afcontrol_no_dtfiled 
  where objid = af_control.objid 
)
;

alter table af_control modify dtfiled date not null ; 
alter table af_control modify state varchar(50) not null ; 

update af_control_detail set 
  reftype='ISSUE', txntype='SALE' 
where reftype='stocksale' 
  and txntype='SALE-RECEIPT' 
;


INSERT INTO `afunit` (`objid`, `itemid`, `unit`, `qty`, `saleprice`, `interval`, `cashreceiptprintout`, `cashreceiptdetailprintout`) VALUES ('0016-STUB', '0016', 'STUB', '50', '0.00', '1', 'cashreceipt-form:0016', NULL);
INSERT INTO `afunit` (`objid`, `itemid`, `unit`, `qty`, `saleprice`, `interval`, `cashreceiptprintout`, `cashreceiptdetailprintout`) VALUES ('907-STUB', '907', 'STUB', '50', '0.00', '1', 'cashreceipt-form:907', NULL);
INSERT INTO `afunit` (`objid`, `itemid`, `unit`, `qty`, `saleprice`, `interval`, `cashreceiptprintout`, `cashreceiptdetailprintout`) VALUES ('51-STUB', '51', 'STUB', '50', '0.00', '1', 'cashreceipt:printout:51', 'cashreceiptdetail:printout:51');
INSERT INTO `afunit` (`objid`, `itemid`, `unit`, `qty`, `saleprice`, `interval`, `cashreceiptprintout`, `cashreceiptdetailprintout`) VALUES ('52-STUB', '52', 'STUB', '50', '0.00', '1', 'cashreceipt-form:52', NULL);
INSERT INTO `afunit` (`objid`, `itemid`, `unit`, `qty`, `saleprice`, `interval`, `cashreceiptprintout`, `cashreceiptdetailprintout`) VALUES ('53-STUB', '53', 'STUB', '50', '0.00', '1', 'cashreceipt-form:53', NULL);
INSERT INTO `afunit` (`objid`, `itemid`, `unit`, `qty`, `saleprice`, `interval`, `cashreceiptprintout`, `cashreceiptdetailprintout`) VALUES ('54-STUB', '54', 'STUB', '50', '0.00', '1', 'cashreceipt-form:54', NULL);
INSERT INTO `afunit` (`objid`, `itemid`, `unit`, `qty`, `saleprice`, `interval`, `cashreceiptprintout`, `cashreceiptdetailprintout`) VALUES ('56-STUB', '56', 'STUB', '50', '0.00', '1', 'cashreceipt-form:56', 'cashreceiptdetail:printout:56');
INSERT INTO `afunit` (`objid`, `itemid`, `unit`, `qty`, `saleprice`, `interval`, `cashreceiptprintout`, `cashreceiptdetailprintout`) VALUES ('57-STUB', '57', 'STUB', '50', '0.00', '1', 'cashreceipt-form:57', NULL);
INSERT INTO `afunit` (`objid`, `itemid`, `unit`, `qty`, `saleprice`, `interval`, `cashreceiptprintout`, `cashreceiptdetailprintout`) VALUES ('58-STUB', '58', 'STUB', '50', '0.00', '1', 'cashreceipt-form:58', NULL);
INSERT INTO `afunit` (`objid`, `itemid`, `unit`, `qty`, `saleprice`, `interval`, `cashreceiptprintout`, `cashreceiptdetailprintout`) VALUES ('CT1-PAD', 'CT1', 'PAD', '2000', '0.00', '1', NULL, NULL);
INSERT INTO `afunit` (`objid`, `itemid`, `unit`, `qty`, `saleprice`, `interval`, `cashreceiptprintout`, `cashreceiptdetailprintout`) VALUES ('CT10-PAD', 'CT10', 'PAD', '2000', '0.00', '1', NULL, NULL);
INSERT INTO `afunit` (`objid`, `itemid`, `unit`, `qty`, `saleprice`, `interval`, `cashreceiptprintout`, `cashreceiptdetailprintout`) VALUES ('CT2-PAD', 'CT2', 'PAD', '2000', '0.00', '1', NULL, NULL);
INSERT INTO `afunit` (`objid`, `itemid`, `unit`, `qty`, `saleprice`, `interval`, `cashreceiptprintout`, `cashreceiptdetailprintout`) VALUES ('CT5-PAD', 'CT5', 'PAD', '2000', '0.00', '1', NULL, NULL);

update 
  af_control aa, ( 
    select afc.objid, 
      (select unit from afunit where itemid=afc.afid limit 1) as unit 
    from af_control afc 
    where afc.unit is null
  )bb 
set aa.unit = bb.unit 
where aa.objid = bb.objid
; 

alter table af_control modify unit varchar(25) not null ; 

insert into afrequest ( 
  objid, reqno, state, dtfiled, reqtype, itemclass, 
  requester_objid, requester_name, requester_title, 
  org_objid, org_name, vendor 
) 
select distinct 
  sr.objid, sr.reqno, sr.state, sr.dtfiled, 'COLLECTION' as reqtype, sr.itemclass, 
  sr.requester_objid, sr.requester_name, sr.requester_title, 
  sr.org_objid, sr.org_name, sr.vendor 
from ( 
  select refid, reftype, refno 
  from z20181120_vw_af_stockissuance
  group by refid, reftype, refno 
)t1
  inner join z20181120_stockissue si on si.objid = t1.refid 
  inner join z20181120_stockrequest sr on sr.objid = si.request_objid 
;

insert into afrequestitem ( 
  objid, parentid, item_objid, item_code, item_title, unit, qty, qtyreceived 
) 
select 
  sri.objid, sri.parentid, sri.item_objid, sri.item_code, sri.item_title, 
  sri.unit, sri.qty, sri.qtyreceived 
from afrequest req 
  inner join z20181120_stockrequestitem sri on sri.parentid = req.objid 
; 


insert into aftxn ( 
  objid, state, request_objid, request_reqno, controlno, dtfiled, 
  user_objid, user_name, issueto_objid, issueto_name, issueto_title, 
  org_objid, org_name, txndate, txntype, cost 
) 
select 
  si.objid, 'POSTED' as state, si.request_objid, si.request_reqno, si.issueno, si.dtfiled, 
  si.user_objid, si.user_name, si.issueto_objid, si.issueto_name, si.issueto_title, 
  si.org_objid, si.org_name, si.dtfiled, 'ISSUE' as txntype, null as cost 
from ( 
  select refid, reftype, refno 
  from z20181120_vw_af_stockissuance
  group by refid, reftype, refno 
)t1
  inner join z20181120_stockissue si on si.objid = t1.refid 
;

insert into aftxnitem ( 
  objid, parentid, item_objid, item_code, item_title, unit, 
  qty, qtyserved, remarks, txntype, cost 
) 
select 
  si.objid, si.parentid, si.item_objid, si.item_code, si.item_title, si.unit, 
  si.qtyrequested, si.qtyissued, si.remarks, 'COLLECTION' as txntype, 0 as cost 
from aftxn a 
  inner join z20181120_stockissueitem si on si.parentid = a.objid 
;



alter table bank add ( 
  `depositsliphandler` varchar(50) NULL, 
  `cashreport` varchar(255) NULL, 
  `checkreport` varchar(255) NULL 
)
;
alter table bank add _ukey varchar(50) not null default ''
;
update bank set _ukey=objid where _ukey=''
;
create UNIQUE index `ux_bank_code_branch` on bank (`code`,`branchname`,`_ukey`) ; 

create UNIQUE index `ux_bank_name_branch` on bank (`name`,`branchname`,`_ukey`) ; 
create index ix_name on bank (name);
create index ix_state on bank (state);
create index ix_code on bank (code);


alter table bankaccount modify fund_objid varchar(100) null not null ;  
alter table bankaccount add acctid varchar(50) null ; 
create index ix_acctid on bankaccount (acctid) ;
alter table bankaccount 
  add constraint fk_bankaccount_acctid 
  foreign key (acctid) references itemaccount (objid) ; 


alter table batchcapture_collection_entry_item modify `item_title` varchar(255) NULL ;
alter table batchcapture_collection_entry_item modify `fund_objid` varchar(100) NULL ;


delete from business_recurringfee where objid='RECFEE687ce4b1:1689d2dfeea:-4cb7'
;
create UNIQUE index `uix_businessid_acctid` on business_recurringfee (`businessid`,`account_objid`) 
;

alter table cashreceipt modify payer_name varchar(800) null ;
alter table cashreceipt modify paidby varchar(800) not null ;
alter table cashreceipt add ( 
  remittanceid varchar(50) null, 
  subcollector_remittanceid varchar(50) null 
)
;
create index ix_remittanceid on cashreceipt (remittanceid); 
create index ix_subcollector_remittanceid on cashreceipt (subcollector_remittanceid); 

create index ix_paidby on cashreceipt (paidby) ; 
create index ix_payer_name on cashreceipt (payer_name) ; 
create index ix_formtype on cashreceipt (formtype) ; 

delete from cashreceiptitem where receiptid is null ;
alter table cashreceiptitem modify receiptid varchar(50) not null ;

create table ztmp_cashreceiptitem_no_item_objid 
select * from cashreceiptitem where item_objid is null
;
delete from cashreceiptitem where objid in (
  select objid from ztmp_cashreceiptitem_no_item_objid 
  where objid = cashreceiptitem.objid 
)
;

alter table cashreceiptitem modify item_objid varchar(50) not null ;
alter table cashreceiptitem modify item_code varchar(100) not null ;
alter table cashreceiptitem modify item_title varchar(255) not null ;
alter table cashreceiptitem modify amount decimal(16,4) not null ;
create index `ix_item_code` on cashreceiptitem (`item_code`) ; 
create index `ix_item_title` on cashreceiptitem (`item_title`) ; 

alter table cashreceiptitem add sortorder int default '0';

alter table cashreceiptitem add item_fund_objid varchar(100) null ;
create index ix_item_fund_objid on cashreceiptitem (item_fund_objid) ;

update cashreceiptitem ci, itemaccount ia set 
  ci.item_fund_objid = ia.fund_objid 
where ci.item_objid = ia.objid 
;
update cashreceiptitem set item_fund_objid = 'GENERAL' where item_fund_objid is null 
; 
alter table cashreceiptitem modify item_fund_objid varchar(100) not null ;
alter table cashreceiptitem 
  add constraint fk_cashreceiptitem_item_fund_objid 
  foreign key (item_fund_objid) REFERENCES fund (objid) 
; 


alter table cashreceiptpayment_creditmemo modify account_fund_objid varchar(100) null ;


alter table cashreceiptpayment_noncash change bank _bank varchar(50) null ; 
alter table cashreceiptpayment_noncash drop foreign key cashreceiptpayment_noncash_ibfk_2; 
alter table cashreceiptpayment_noncash change bankid _bankid varchar(50) null ; 
alter table cashreceiptpayment_noncash change deposittype _deposittype varchar(50) null ; 
alter table cashreceiptpayment_noncash modify account_fund_objid varchar(100) null ; 

alter table cashreceiptpayment_noncash add ( 
  fund_objid varchar(100) null, 
  refid varchar(50) null, 
  checkid varchar(50) null, 
  voidamount decimal(16,4) null 
)
;
create index ix_fund_objid on cashreceiptpayment_noncash (fund_objid) ;
create index ix_refid on cashreceiptpayment_noncash (refid) ;
create index ix_checkid on cashreceiptpayment_noncash (checkid) ;

alter table cashreceiptpayment_noncash 
  modify fund_objid varchar(100) character set utf8 null 
; 
alter table cashreceiptpayment_noncash 
  add constraint fk_cashreceiptpayment_noncash_fund_objid 
  foreign key (fund_objid) references fund (objid) 
; 


create unique index uix_receiptid on cashreceipt_cancelseries (receiptid)
;

update cashreceipt set paidby = substring(paidby, 1, 800) ; 
update cashreceipt set payer_name = substring(payer_name, 1, 800) ; 

alter table cashreceipt modify paidby varchar(800) not null ; 
alter table cashreceipt modify payer_name varchar(800) null ; 

create table ztmp_duplicate_cashreceipt_void 
select t1.receiptid, (
    select objid from cashreceipt_void 
    where receiptid = t1.receiptid 
    order by txndate limit 1 
  )as validreceiptid 
from (
  select receiptid, count(*) as icount 
  from cashreceipt_void  
  group by receiptid
  having count(*) > 1 
)t1 
;
create index ix_receiptid on ztmp_duplicate_cashreceipt_void (receiptid);
create index ix_validreceiptid on ztmp_duplicate_cashreceipt_void (validreceiptid);

create table ztmp_duplicate_cashreceipt_void_for_deletion 
select v.objid  
from cashreceipt_void v 
  inner join ztmp_duplicate_cashreceipt_void z on (z.receiptid = v.receiptid and z.validreceiptid <> v.objid) 
;
delete from cashreceipt_void where objid in (select objid from ztmp_duplicate_cashreceipt_void_for_deletion) 
; 
drop table ztmp_duplicate_cashreceipt_void_for_deletion; 
drop table ztmp_duplicate_cashreceipt_void;

create unique index uix_receiptid on cashreceipt_void (receiptid) ;


create table z20181120_collectiongroup 
select * from collectiongroup 
; 

alter table collectiongroup drop column afno ; 
alter table collectiongroup drop column org_objid ; 
alter table collectiongroup drop column org_name ;


alter table collectiongroup_revenueitem drop foreign key collectiongroup_revenueitem_ibfk_1 ; 
alter table collectiongroup_revenueitem drop foreign key collectiongroup_revenueitem_ibfk_2 ; 

create index ix_collectiongroupid on collectiongroup_revenueitem (collectiongroupid) ; 
alter table collectiongroup_revenueitem change revenueitemid account_objid varchar(50) not null ; 
alter table collectiongroup_revenueitem change orderno sortorder int not null ; 

alter table collectiongroup_revenueitem add (
  `objid` varchar(100) NULL,
  `account_title` varchar(255) NULL,
  `tag` varchar(255) NULL 
)
;

update collectiongroup_revenueitem set objid = concat('CGA-', md5(concat(collectiongroupid,'|',account_objid))) ; 
update collectiongroup_revenueitem aa, itemaccount bb set aa.account_title = bb.title where aa.account_objid = bb.objid ; 

alter table collectiongroup_revenueitem drop primary key ; 
rename table collectiongroup_revenueitem to collectiongroup_account ; 

alter table collectiongroup_account modify objid varchar(50) not null ; 
alter table collectiongroup_account modify account_title varchar(255) not null ; 

alter table collectiongroup_account add constraint pk_collectiongroup_account primary key (objid) ; 
create unique index uix_collectiongroup_account on collectiongroup_account (collectiongroupid, account_objid) ; 

create table ztmp_collectiongroup_account_no_parent_reference
select * from collectiongroup_account where collectiongroupid not in (
  select objid from collectiongroup 
  where objid = collectiongroup_account.collectiongroupid 
) 
;
delete from collectiongroup_account where objid in (
  select objid from ztmp_collectiongroup_account_no_parent_reference 
  where objid = collectiongroup_account.objid 
)
;
alter table collectiongroup_account add constraint fk_collectiongroup_account_collectiongroupid 
  foreign key (collectiongroupid) references collectiongroup (objid) 
;
alter table collectiongroup_account add constraint fk_collectiongroup_account_account_objid 
  foreign key (account_objid) references itemaccount (objid) 
;


insert into collectiongroup_org ( 
  objid, collectiongroupid, org_objid, org_name, org_type 
) 
select * from ( 
  select 
    concat('CGO-',MD5(concat(g.objid,'|',g.org_objid))) as objid, g.objid as collectiongroupid, 
    o.objid as org_objid, o.name as org_name, o.orgclass as org_type 
  from z20181120_collectiongroup g, sys_org o 
  where g.org_objid = o.objid 
)t1 
; 


create index ix_state on collectiongroup (state) ;
update collectiongroup set state = 'ACTIVE' ; 


alter table collectiontype modify allowbatch int default '0' ; 
alter table collectiontype modify allowonline int default '0' ; 
alter table collectiontype modify allowoffline int default '0' ; 

alter table collectiontype add ( 
  `allowpaymentorder` int default '0',
  `allowkiosk` int default '0',
  `allowcreditmemo` int default '0', 
  `system` int default '0'  
)
; 

create table z20181120_collectiontype 
select * from collectiontype 
; 

create index ix_state on collectiontype (state) ; 
update collectiontype set state = 'ACTIVE' ; 

create index ix_collectiontypeid on collectiontype_account (collectiontypeid) ; 
alter table collectiontype_account add objid varchar(50) null ; 

update collectiontype_account set objid = concat('CTA-',MD5(concat(collectiontypeid,'|',account_objid))); 
alter table collectiontype_account modify objid varchar(50) not null ; 
alter table collectiontype_account drop primary key ; 
alter table collectiontype_account add constraint pk_collectiontype_account primary key (objid) ;
create unique index uix_collectiontype_account on collectiontype_account (collectiontypeid, account_objid) ;


insert into collectiontype_org ( 
  objid, collectiontypeid, org_objid, org_name, org_type 
) 
select * from ( 
  select 
    concat('CTO-',MD5(concat(a.objid,'|',o.objid))) as objid, a.objid as collectiontypeid, 
    o.objid as org_objid, o.name as org_name, o.orgclass as org_type 
  from z20181120_collectiontype a, sys_org o 
  where a.org_objid = o.objid 
)t1 
;  


alter table creditmemo add ( 
  `receiptdate` date NULL,
  `issuereceipt` int NULL,
  `type` varchar(25) NULL
)
; 
create index ix_receiptdate on creditmemo (receiptdate) ; 


alter table creditmemotype modify fund_objid varchar(100) null ; 
alter table creditmemotype 
  modify fund_objid varchar(100) character set utf8 null 
; 
alter table creditmemotype add constraint fk_creditmemotype_fund_objid 
  foreign key (fund_objid) references fund (objid) 
; 
alter table creditmemotype 
  change `HANDLER` `handler` varchar(50) null 
;



alter table entity modify entityname varchar(800) not null ; 
alter table entity modify email varchar(50) null ; 
alter table entity add state varchar(25) null ; 
create index ix_state on entity (state);
update entity set state = 'ACTIVE' where state is null; 


create unique index uix_idtype_idno on entityid (entityid, idtype, idno);
 
create table ztmp_invalid_entityid 
select id.objid 
from entityid id 
  left join entity e on e.objid = id.entityid 
where id.entityid is not null 
  and e.objid is null 
;
delete from entityid where objid in ( 
  select objid from  ztmp_invalid_entityid
)
;
drop table ztmp_invalid_entityid 
;

alter table entityid add constraint fk_entityid_entityid 
  foreign key (entityid) references entity (objid) 
;


alter table entityindividual modify lastname varchar(100) not null ; 
alter table entityindividual modify firstname varchar(100) not null ; 
alter table entityindividual modify tin varchar(50) null ; 
alter table entityindividual add profileid varchar(50) null; 
create index ix_profileid on entityindividual (profileid);


alter table entityjuridical modify tin varchar(50) null ;
alter table entityjuridical modify administrator_address varchar(255) null ;
alter table entityjuridical add ( 
  administrator_objid varchar(50) null, 
  administrator_address_objid varchar(50) null, 
  administrator_address_text varchar(255) null 
);
create index ix_dtregistered on entityjuridical (dtregistered);
create index ix_administrator_objid on entityjuridical (administrator_objid);
create index ix_administrator_name on entityjuridical (administrator_name);
create index ix_administrator_address_objid on entityjuridical (administrator_address_objid);

update entityjuridical set 
  administrator_address_text = administrator_address
where administrator_address_text is null 
;


alter table entitymember add member_address varchar(255) null ;
alter table entitymember modify member_name varchar(800) not null ;


alter table entity_address modify street varchar(255) null ;


alter table fund modify objid varchar(100) not null ; 

alter table fund add ( 
  `groupid` varchar(50) NULL,
  `depositoryfundid` varchar(100) NULL 
)
;
create index ix_groupid on fund (groupid) ; 
create index ix_depositoryfundid on fund (depositoryfundid) ; 

update fund set state = 'ACTIVE' 
; 
update fund set 
  groupid = objid, depositoryfundid = objid, system = 1, parentid = null  
where objid in ('GENERAL', 'SEF', 'TRUST') 
; 
update fund set depositoryfundid = objid where depositoryfundid is null 
;
update fund a, fund b set 
  a.groupid = b.objid 
where a.parentid = b.objid 
  and b.objid in ('GENERAL','SEF','TRUST') 
  and a.groupid is null 
;
update fund set system=0 where system is null 
;
update fund set groupid = 'GENERAL' where groupid is null 
;  


update fund set title='GENERAL PROPER' where objid='GENERAL';
update fund set title='SEF PROPER' where objid='SEF';
update fund set title='TRUST PROPER' where objid='TRUST';

update fund aa, ( select distinct fund_objid from bankaccount ) bb 
set aa.depositoryfundid = aa.objid 
where aa.objid = bb.fund_objid 
;


alter table itemaccount modify fund_objid varchar(100) null; 
alter table itemaccount add constraint fk_itemaccount_fund_objid 
  foreign key (fund_objid) references fund (objid)
;

alter table itemaccount add (
  `generic` int(11) DEFAULT '0',
  `sortorder` int(11) DEFAULT '0',
  `hidefromlookup` int(11) NOT NULL DEFAULT '0' 
)
;
create index `ix_state` on itemaccount (`state`) ; 
create index `ix_generic` on itemaccount (`generic`) ; 
create index `ix_type` on itemaccount (`type`) ; 

update itemaccount set state = 'ACTIVE' where state = 'APPROVED' ; 


alter table lob modify name varchar(255) not null ;
alter table lob add psic_objid varchar(50) null ; 
create index ix_psic_objid on lob (psic_objid) ;
  

alter table remittance_fund modify fund_objid varchar(100) not null; 

update remittance_fund set fund_objid='FUND6f3c344a:15ec5d50d11:-7bb7' where fund_objid='TRUST FUND - DOLE'
;
update remittance_fund set fund_objid='GENERAL' where fund_objid='GENERAL FUND'
;
alter table remittance_fund add constraint fk_remittance_fund_fund_objid 
  foreign key (fund_objid) references fund (objid)
;

alter table remittance change txnno controlno varchar(100) not null ; 
alter table remittance change totalnoncash totalcheck decimal(16,2) not null ; 
alter table remittance modify `liquidatingofficer_objid` varchar(50) NULL ; 
alter table remittance modify `liquidatingofficer_name` varchar(100) NULL ; 
alter table remittance modify `liquidatingofficer_title` varchar(50) NULL ; 

update remittance set remittancedate = dtposted where remittancedate is null ;
alter table remittance change remittancedate controldate datetime not null ; 

alter table remittance add ( 
  `totalcr` decimal(16,2) NULL,
  `collector_signature` longtext NULL,
  `liquidatingofficer_signature` longtext NULL,
  `collectionvoucherid` varchar(50) NULL 
)
;

alter table remittance add _ukey varchar(50) not null default '';
update remittance set _ukey = objid; 

create unique index uix_controlno on remittance (controlno,_ukey) ; 
create index ix_controldate on remittance (controldate) ; 
create index ix_collectionvoucherid on remittance (collectionvoucherid) ; 

update remittance set totalcr = 0.0 where totalcr is null ; 
alter table remittance modify totalcr decimal(16,2) not null ; 

alter table remittance 
  add constraint fk_remittance_collectionvoucherid 
  foreign key (collectionvoucherid) references collectionvoucher (objid) ;


alter table remittance_af add ( 
  `controlid` varchar(50) NULL,
  `receivedstartseries` int NULL,
  `receivedendseries` int NULL,
  `beginstartseries` int NULL,
  `beginendseries` int NULL,
  `issuedstartseries` int NULL,
  `issuedendseries` int NULL,
  `endingstartseries` int NULL,
  `endingendseries` int NULL,
  `qtyreceived` int NULL,
  `qtybegin` int NULL,
  `qtyissued` int NULL,
  `qtyending` int NULL,
  `qtycancelled` int NULL,
  `remarks` varchar(255) NULL 
)
;
create index ix_controlid on remittance_af (controlid) 
; 


alter table remittance_fund modify fund_objid varchar(100) not null ; 
alter table remittance_fund modify fund_title varchar(255) not null ; 
alter table remittance_fund add ( 
  `totalcash` decimal(16,4) NULL,
  `totalcheck` decimal(16,4) NULL,
  `totalcr` decimal(16,4) NULL,
  `cashbreakdown` longtext NULL,
  `controlno` varchar(100) NULL 
)
;

update remittance_fund set totalcash = amount where totalcash is null ; 
update remittance_fund set totalcheck = 0.0 where totalcheck is null ; 
update remittance_fund set totalcr = 0.0 where totalcr is null ; 

alter table remittance_fund modify amount decimal(16,4) not null ; 
alter table remittance_fund modify totalcash decimal(16,4) not null ; 
alter table remittance_fund modify totalcheck decimal(16,4) not null ; 
alter table remittance_fund modify totalcr decimal(16,4) not null ; 
alter table remittance_fund modify remittanceid varchar(50) not null ; 

create table ztmp_remittance_fund_duplicates
select rf.* 
from ( 
  select rf.remittanceid, rf.fund_objid, count(*) as icount 
  from remittance_fund rf 
  group by rf.remittanceid, rf.fund_objid 
  having count(*) > 1 
)t1, remittance_fund rf 
where rf.remittanceid = t1.remittanceid   
  and rf.fund_objid = t1.fund_objid 
;
delete from remittance_fund where objid in (
  select objid from ztmp_remittance_fund_duplicates 
  where objid = remittance_fund.objid 
)
;

create unique index uix_remittance_fund on remittance_fund (remittanceid, fund_objid) 
; 

insert into remittance_fund (
  objid, remittanceid, fund_objid, fund_title, 
  amount, totalcash, totalcheck, totalcr
)
select 
  concat('REMFUND-', MD5(concat(remittanceid, fund_objid))) as objid, remittanceid, fund_objid, 
  (select fund_title from ztmp_remittance_fund_duplicates where remittanceid = t1.remittanceid and fund_objid = t1.fund_objid limit 1) as fund_title, 
  amount, totalcash, totalcheck, totalcr 
from ( 
  select 
    rf.remittanceid, rf.fund_objid, 
    sum(rf.amount) as amount, sum(rf.totalcash) as totalcash, 
    sum(rf.totalcheck) as totalcheck, sum(rf.totalcr) as totalcr
  from ztmp_remittance_fund_duplicates rf 
  group by rf.remittanceid, rf.fund_objid 
)t1
;


alter table sys_org modify root int not null default '0' ; 

DROP TABLE IF EXISTS sys_requirement_type
;
CREATE TABLE `sys_requirement_type` (
  `code` varchar(50) NOT NULL,
  `title` varchar(255) NOT NULL,
  `handler` varchar(50) DEFAULT NULL,
  `objid` varchar(50) NOT NULL,
  `type` varchar(50) DEFAULT NULL,
  `system` int(11) DEFAULT NULL,
  `agency` varchar(50) DEFAULT NULL,
  `sortindex` int(11) NOT NULL,
  `verifier` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `uix_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

alter table sys_rule add noloop int not NULL default '1' ; 
alter table sys_rule modify name varchar(255) not null ;

alter table sys_rule_actiondef_param modify objid varchar(255) not null; 

alter table sys_rule_action_param modify actiondefparam_objid varchar(255) NOT NULL; 

alter table sys_rule_condition add notexist int NOT NULL default '0';
update sys_rule_condition set notexist=0 where notexist is null; 

alter table sys_rule_condition_constraint modify field_objid varchar(255) null; 

alter table sys_rule_fact_field modify objid varchar(255) not null ;

alter table sys_securitygroup modify objid varchar(100) not null; 

alter table sys_session add terminalid varchar(50) null; 
alter table sys_session_log add terminalid varchar(50) null; 

alter table sys_wf_node modify idx int not null; 
alter table sys_wf_node add ( 
  properties text NULL,
  ui text NULL,
  tracktime int null 
); 

alter table sys_wf_transition add ui text null ; 


alter table af_control modify fund_objid varchar(100) null ; 

CREATE TABLE `business_permit_lob` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) DEFAULT NULL,
  `lobid` varchar(50) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `txndate` datetime DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_lobid` (`lobid`),
  KEY `ix_name` (`name`),
  CONSTRAINT `fk_business_permit_lob_lobid` FOREIGN KEY (`lobid`) REFERENCES `lob` (`objid`),
  CONSTRAINT `fk_business_permit_lob_parentid` FOREIGN KEY (`parentid`) REFERENCES `business_permit` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


insert ignore into business_permit_lob ( 
  objid, parentid, lobid, name, txndate 
) 
select 
  concat('PLOB-',MD5(concat(tmp2.parentid,'-',tmp2.lobid))) as objid, 
  tmp2.parentid, tmp2.lobid, lob.name, tmp2.txndate 
from ( 
  select 
    parentid, lobid, min(txndate) as txndate, sum(iflag) as iflag 
  from ( 
    select 
      p.objid as parentid, alob.lobid, a.txndate, 
      (case when alob.assessmenttype in ('NEW','RENEW') then 1 else -1 end) as iflag 
    from business_permit p 
      inner join business_application pa on p.applicationid=pa.objid 
      inner join business_application a on (a.business_objid=p.businessid and a.appyear=pa.appyear)
      inner join business_application_lob alob on alob.applicationid=a.objid 
    where p.state = 'ACTIVE' 
      and a.state = 'COMPLETED' 
      and a.txndate <= pa.txndate 
  )tmp1 
  group by parentid, lobid 
  having sum(iflag) > 0 
)tmp2 
  left join lob on lob.objid=tmp2.lobid 
order by tmp2.txndate 
;


drop table if exists ztmp_business_recurringfee_duplicates
;
create table ztmp_business_recurringfee_duplicates 
select rf.* 
from ( 
  select t1.*, 
    (
      select objid from business_recurringfee 
      where businessid=t1.businessid and account_objid=t1.account_objid 
      order by amount desc limit 1 
    ) as recfeeid 
  from ( 
    select businessid, account_objid, count(*) as icount 
    from business_recurringfee 
    group by businessid, account_objid 
    having count(*) > 1 
  )t1 
)t2, business_recurringfee rf 
where rf.businessid = t2.businessid 
  and rf.account_objid = t2.account_objid 
  and rf.objid <> t2.recfeeid 
;
delete from business_recurringfee where objid in ( 
  select objid from ztmp_business_recurringfee_duplicates 
)
;

update business_permit p, business_application a set 
  a.permit_objid = p.objid 
where p.applicationid = a.objid 
  and a.permit_objid is null 
;


alter table cashreceipt modify `paidbyaddress` varchar(800) NOT NULL ;

alter table cashreceipt 
  add constraint fk_cashreceipt_remittanceid 
  foreign key (remittanceid) references remittance (objid) ;

alter table cashreceipt 
  add constraint fk_cashreceipt_subcollector_remittanceid 
  foreign key (subcollector_remittanceid) references subcollector_remittance (objid) ;

update cashreceipt aa, z20181120_remittance_cashreceipt bb 
set aa.remittanceid = bb.remittanceid  
where aa.objid = bb.objid
;

update cashreceipt aa, subcollector_remittance_cashreceipt bb 
set aa.subcollector_remittanceid = bb.remittanceid  
where aa.objid = bb.objid 
;

alter table cashreceipt_share 
  add constraint fk_cashreceipt_share_refitem_objid 
  foreign key (refitem_objid) references itemaccount (objid) ; 

alter table cashreceipt_share 
  add constraint fk_cashreceipt_share_payableitem_objid 
  foreign key (payableitem_objid) references itemaccount (objid) ; 


create index ix_txnno on certification (txnno) ; 
create index ix_txndate on certification (txndate) ; 
create index ix_type on certification (type) ; 
create index ix_name on certification (name) ; 
create index ix_orno on certification (orno) ; 
create index ix_ordate on certification (ordate) ; 
create index ix_createdbyid on certification (createdbyid) ; 
create index ix_createdby on certification (createdby) ; 

alter table collectiontype modify fund_objid varchar(100) null ;
alter table collectiontype modify fund_title varchar(255) null ;

create index ix_account_title on collectiontype_account (account_title) ;

drop table if exists draftremittance_cashreceipt ;

create index `ix_entityname_state` on entity (`state`,`entityname`); 

alter table txnlog modify refid varchar(255) not null ; 
create index ix_refid on txnlog (refid); 
