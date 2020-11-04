use etracs255_ilocosnorte;

create index `ix_assignee_objid` on af_control (`assignee_objid`); 
create index `ix_fund_objid` on af_control (`fund_objid`); 
create index `ix_owner_objid` on af_control (`owner_objid`); 
create index `ix_owner_name` on af_control (`owner_name`); 
create index `ix_afid` on af_control (`afid`); 

create index `ix_capturedby_objid` on batchcapture_collection (`capturedby_objid`); 
create index `ix_collectiontype_objid` on batchcapture_collection (`collectiontype_objid`); 
create index `ix_controlid` on batchcapture_collection (`controlid`); 
create index `ix_defaultreceiptdate` on batchcapture_collection (`defaultreceiptdate`); 
create index `ix_formno` on batchcapture_collection (`formno`); 
create index `ix_org_objid` on batchcapture_collection (`org_objid`); 
create index `ix_postedby_objid` on batchcapture_collection (`postedby_objid`); 
create index `ix_state` on batchcapture_collection (`state`); 

create index `ix_currentpermitid` on business (`currentpermitid`); 
create index `ix_owner_address_objid` on business (`owner_address_objid`); 
create index `ix_owner_name` on business (`owner_name`); 
create index `ix_owner_objid` on business (`owner_objid`); 
create index `ix_tradename` on business (`tradename`); 
create index `ix_yearstarted` on business (`yearstarted`); 

create index `ix_attribute_name` on business_active_info (`attribute_name`); 
create index `ix_attribute_objid` on business_active_info (`attribute_objid`); 
create index `ix_lob_name` on business_active_info (`lob_name`); 
create index `ix_lob_objid` on business_active_info (`lob_objid`); 


alter table business_active_info add CONSTRAINT `fk_business_active_info_lob_objid` 
  FOREIGN KEY (`lob_objid`) REFERENCES `lob` (`objid`)
; 

create index `ix_lobid` on business_active_lob (`lobid`); 
create index `ix_name` on business_active_lob (`name`); 

alter table business_active_lob add CONSTRAINT `fk_business_active_lob_lobid` 
  FOREIGN KEY (`lobid`) REFERENCES `lob` (`objid`)
; 

create index `ix_barangay_objid` on business_address (`barangay_objid`); 
create index `ix_businessid` on business_address (`businessid`); 
create index `ix_lessor_address_objid` on business_address (`lessor_address_objid`); 
create index `ix_lessor_objid` on business_address (`lessor_objid`); 

create index `ix_approver_objid` on business_application (`approver_objid`); 
create index `ix_appyear` on business_application (`appyear`); 
create index `ix_assessor_objid` on business_application (`assessor_objid`); 
create index `ix_businessaddress` on business_application (`businessaddress`); 
create index `ix_createdby_objid` on business_application (`createdby_objid`); 
create index `ix_dtfiled` on business_application (`dtfiled`); 
create index `ix_dtreleased` on business_application (`dtreleased`); 
create index `ix_nextbilldate` on business_application (`nextbilldate`); 
create index `ix_owneraddress` on business_application (`owneraddress`); 
create index `ix_ownername` on business_application (`ownername`); 
create index `ix_permit_objid` on business_application (`permit_objid`); 
create index `ix_state` on business_application (`state`); 
create index `ix_tradename` on business_application (`tradename`); 
create index `ix_txndate` on business_application (`txndate`); 

create index `ix_activeyear` on business_application_info (`activeyear`); 
create index `ix_attribute_objid` on business_application_info (`attribute_objid`); 
create index `ix_lob_objid` on business_application_info (`lob_objid`); 

alter table business_application_info add CONSTRAINT `fk_business_info_business_lob_objid` 
  FOREIGN KEY (`lob_objid`) REFERENCES `lob` (`objid`)
; 

create index `ix_activeyear` on business_application_lob (`activeyear`); 
create index `ix_name` on business_application_lob (`name`); 
alter table business_application_lob add CONSTRAINT `fk_business_application_lob_lobid` 
  FOREIGN KEY (`lobid`) REFERENCES `lob` (`objid`)
; 

create index `ix_actor_objid` on business_application_task (`actor_objid`); 
create index `ix_assignee_objid` on business_application_task (`assignee_objid`); 
create index `ix_enddate` on business_application_task (`enddate`); 
create index `ix_parentprocessid` on business_application_task (`parentprocessid`); 
create index `ix_startdate` on business_application_task (`startdate`); 

create index `ix_actor_objid` on business_application_workitem (`actor_objid`); 
create index `ix_assignee_objid` on business_application_workitem (`assignee_objid`); 
create index `ix_enddate` on business_application_workitem (`enddate`); 
create index `ix_refid` on business_application_workitem (`refid`); 
create index `ix_startdate` on business_application_workitem (`startdate`); 
create index `ix_workitemid` on business_application_workitem (`workitemid`); 

create index `ix_barangay_objid` on business_lessor (`barangay_objid`); 
create index `ix_bldgname` on business_lessor (`bldgname`); 
create index `ix_bldgno` on business_lessor (`bldgno`); 
create index `ix_lessor_address_objid` on business_lessor (`lessor_address_objid`); 
create index `ix_lessor_objid` on business_lessor (`lessor_objid`); 

create index `ix_appyear` on business_payment (`appyear`); 
create index `ix_refdate` on business_payment (`refdate`); 
create index `ix_refno` on business_payment (`refno`); 
alter table business_payment 
  modify applicationid varchar(50) character set utf8 not null
;
alter table business_payment 
  modify businessid varchar(50) character set utf8 not null
;

create table ztmp_duplicate_business_payment 
select p.objid from business_payment p 
  left join business_application a on a.objid = p.applicationid 
where a.objid is null 
; 
delete from business_payment_item where parentid in ( 
  select objid from ztmp_duplicate_business_payment
);
delete from business_payment where objid in ( 
  select objid from ztmp_duplicate_business_payment
);
drop table if exists ztmp_duplicate_business_payment
; 

alter table business_payment add CONSTRAINT `fk_business_payment_applicationid` 
  FOREIGN KEY (`applicationid`) REFERENCES `business_application` (`objid`) 
; 
alter table business_payment add CONSTRAINT `fk_business_payment_businessid` 
  FOREIGN KEY (`businessid`) REFERENCES `business` (`objid`) 
; 


create index `ix_account_objid` on business_payment_item (`account_objid`); 
create index `ix_lob_objid` on business_payment_item (`lob_objid`); 

create table ztmp_invalid_business_payment_item 
select b.objid 
from business_payment_item b 
  left join business_payment p on p.objid = b.parentid 
where p.objid is null 
;
delete from business_payment_item where objid in ( 
  select objid from ztmp_invalid_business_payment_item 
);
drop table if exists ztmp_invalid_business_payment_item
;

alter table business_payment_item add CONSTRAINT `fk_business_payment_item_parentid` 
  FOREIGN KEY (`parentid`) REFERENCES `business_payment` (`objid`)
;
alter table business_payment_item 
  change `PARTIAL` `partial` int null 
;

drop index uix_applicationid on business_permit ;
create index `ix_activeyear` on business_permit (`activeyear`); 
create index `ix_applicationid` on business_permit (`applicationid`); 
create index `ix_businessid` on business_permit (`businessid`); 
create index `ix_dtissued` on business_permit (`dtissued`); 
create index `ix_expirydate` on business_permit (`expirydate`); 
create index `ix_issuedby_objid` on business_permit (`issuedby_objid`); 
create index `ix_plateno` on business_permit (`plateno`); 

delete from business_permit where applicationid not in ( 
  select objid from business_application 
  where objid = business_permit.applicationid 
);

alter table business_permit add CONSTRAINT `fk_business_permit_applicationid` 
  FOREIGN KEY (`applicationid`) REFERENCES `business_application` (`objid`) 
; 
alter table business_permit add CONSTRAINT `fk_business_permit_businessid` 
  FOREIGN KEY (`businessid`) REFERENCES `business` (`objid`) 
; 


create index `ix_account_objid` on business_receivable (`account_objid`); 
alter table business_receivable modify applicationid varchar(50) character set utf8 not null 
; 
alter table business_receivable modify businessid varchar(50) character set utf8 not null 
; 

create table ztmp_invalid_business_receivable
select r.objid 
from business_receivable r 
  left join business_application a on a.objid = r.applicationid 
where a.objid is null 
;
delete from business_receivable where objid in ( 
  select objid from ztmp_invalid_business_receivable
);
drop table if exists ztmp_invalid_business_receivable
;

alter table business_receivable add CONSTRAINT `fk_business_receivable_applicationid` 
  FOREIGN KEY (`applicationid`) REFERENCES `business_application` (`objid`)
; 

alter table business_receivable add CONSTRAINT `fk_business_receivable_businessid` 
  FOREIGN KEY (`businessid`) REFERENCES `business` (`objid`)
; 

create index `ix_account_objid` on business_recurringfee (`account_objid`); 

alter table business_redflag 
  modify businessid varchar(50) character set utf8 not null
; 
alter table business_redflag add CONSTRAINT `fk_business_redflag_businessid` 
  FOREIGN KEY (`businessid`) REFERENCES `business` (`objid`)
;


create index `ix_completedby_objid` on business_requirement (`completedby_objid`); 
create index `ix_dtcompleted` on business_requirement (`dtcompleted`); 
create index `ix_dtissued` on business_requirement (`dtissued`); 
create index `ix_refid` on business_requirement (`refid`); 
create index `ix_refno` on business_requirement (`refno`); 

create table ztmp_invalid_business_requirement
select r.objid 
from business_requirement r 
  left join business_application a on a.objid = r.applicationid 
where a.objid is null 
;
delete from business_requirement where objid in ( 
  select objid from ztmp_invalid_business_requirement
);
drop table if exists ztmp_invalid_business_requirement
;

alter table business_requirement add CONSTRAINT `fk_business_requirement_applicationid` 
  FOREIGN KEY (`applicationid`) REFERENCES `business_application` (`objid`)
;

create UNIQUE index `uix_code` on businessrequirementtype (`code`) ;

-- create UNIQUE index `uix_title` on businessrequirementtype (`title`) ;

create UNIQUE index `uix_name` on businessvariable (`name`); 

alter table cashreceipt add ukey varchar(50) not null default '';
create index ix_ukey on cashreceipt (ukey); 
update cashreceipt set ukey=MD5(objid);
create UNIQUE index `uix_receiptno` on cashreceipt (`receiptno`,`ukey`); 

create index `ix_formno` on cashreceipt (`formno`); 
create index `ix_org_objid` on cashreceipt (`org_objid`); 
create index `ix_payer_objid` on cashreceipt (`payer_objid`); 
create index `ix_receiptdate` on cashreceipt (`receiptdate`); 
create index `ix_user_objid` on cashreceipt (`user_objid`); 

alter table cashreceipt add CONSTRAINT `fk_cashreceipt_collector_objid` 
  FOREIGN KEY (`collector_objid`) REFERENCES `sys_user` (`objid`)
; 
alter table cashreceipt 
  modify controlid varchar(50) character set utf8 not null 
; 

set foreign_key_checks=0;
alter table cashreceipt add CONSTRAINT `fk_cashreceipt_controlid` 
  FOREIGN KEY (`controlid`) REFERENCES `af_control` (`objid`)
; 
set foreign_key_checks=1;

create index `ix_controlid` on cashreceipt_cancelseries (`controlid`); 
create index `ix_postedby_objid` on cashreceipt_cancelseries (`postedby_objid`); 
create index `ix_txndate` on cashreceipt_cancelseries (`txndate`); 


alter table cashreceipt_rpt drop foreign key cashreceipt_rpt_ibfk_1; 

create index `ix_acctid` on cashreceipt_slaughter (`acctid`); 
create index `ix_acctno` on cashreceipt_slaughter (`acctno`); 

create index `ix_postedby_objid` on cashreceipt_void (`postedby_objid`); 
create index `ix_txndate` on cashreceipt_void (`txndate`); 

create index `ix_account_fund_objid` on cashreceiptpayment_noncash (`account_fund_objid`); 
create index `ix_account_objid` on cashreceiptpayment_noncash (`account_objid`); 
create index `ix_refdate` on cashreceiptpayment_noncash (`refdate`); 
create index `ix_refno` on cashreceiptpayment_noncash (`refno`); 

create index `ix_formno` on collectiontype (`formno`); 
create index `ix_handler` on collectiontype (`handler`); 

alter table collectiontype_account drop foreign key fk_collectiontype_account_revitem; 
alter table collectiontype_account drop foreign key fk_collectiontype_account_parentid; 

alter table creditmemo add ( 
  `payer_name` varchar(255) NULL,
  `payer_address_objid` varchar(50) NULL,
  `payer_address_text` varchar(50) NULL
); 
create index `ix_bankaccount_objid` on creditmemo (`bankaccount_objid`); 
create index `ix_controlno` on creditmemo (`controlno`); 
create index `ix_dtissued` on creditmemo (`dtissued`); 
create index `ix_issuedby_objid` on creditmemo (`issuedby_objid`); 
create index `ix_payer_objid` on creditmemo (`payer_objid`); 
create index `ix_receiptid` on creditmemo (`receiptid`); 
create index `ix_receiptno` on creditmemo (`receiptno`); 
create index `ix_refdate` on creditmemo (`refdate`); 
create index `ix_refno` on creditmemo (`refno`); 
create index `ix_state` on creditmemo (`state`); 
create index `ix_type_objid` on creditmemo (`type_objid`); 

alter table creditmemoitem drop foreign key creditmemoitem_ibfk_1;
alter table creditmemoitem drop foreign key FK_creditmemoitem_revenueitem;
alter table creditmemoitem drop foreign key FK_creditmemo_item;
alter table creditmemoitem add constraint `fk_creditmemoitem_parentid` 
  FOREIGN KEY (`parentid`) REFERENCES `creditmemo` (`objid`)
; 
alter table creditmemoitem add constraint `fk_creditmemoitem_item_objid` 
  FOREIGN KEY (`item_objid`) REFERENCES `itemaccount` (`objid`)
; 


create index ix_account_objid on creditmemotype_account (account_objid); 

create index ix_barangay_objid on entity_address (barangay_objid);
alter table entity_address drop foreign key entity_address_ibfk_1;
alter table entity_address drop foreign key fk_entity_address_parentid;

create index `ix_entityid` on entityid (`entityid`); 
create index `ix_idno` on entityid (`idno`); 


alter table entityindividual modify lastname varchar(50) not null; 
alter table entityindividual modify firstname varchar(50) not null; 
alter table entityindividual modify middlename varchar(50) null; 
alter table entityindividual modify birthdate date null; 
create index ix_lastname on entityindividual (lastname); 

alter table entityjuridical drop foreign key entityjuridical_ibfk_1;

create index ix_member_name on entitymember (member_name);

create index `ix_code` on fund (`code`); 
create index `ix_title` on fund (`title`); 
create index `ix_parentid` on fund (`parentid`); 
alter table fund add constraint fk_fund_depositoryfundid 
  foreign key (depositoryfundid) references fund (objid) 
; 


create index `ix_code` on itemaccount (`code`); 
create index `ix_title` on itemaccount (`title`); 
create index `ix_parentid` on itemaccount (`parentid`); 
alter table itemaccount drop foreign key itemaccount_ibfk_1;


alter table lob add ukey varchar(50) not null default ''; 
create index ix_ukey on lob (ukey); 
update lob set ukey=MD5(UUID()); 
create UNIQUE index `uix_name` on lob (`name`, `ukey`); 
create index `ix_name` on lob (`name`); 
create index `ix_psic` on lob (`psic`); 



create unique index `uix_name` on lobclassification (`name`); 

create unique index `uix_name` on lobattribute (`name`);


drop table if exists paymentorder; 

CREATE TABLE `paymentorder` (
  `txnid` varchar(50) NOT NULL,
  `txndate` datetime NULL,
  `payer_objid` varchar(50) NULL,
  `payer_name` longtext,
  `paidby` longtext,
  `paidbyaddress` varchar(150) NULL,
  `particulars` longtext,
  `amount` decimal(16,2) NULL,
  `txntypeid` varchar(50) NULL,
  `expirydate` date NULL,
  `refid` varchar(50) NULL,
  `refno` varchar(50) NULL,
  `info` longtext,
  PRIMARY KEY (`txnid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


alter table remittance modify controldate date not null ;


create index `ix_dtposted` on remittance (`dtposted`); 

alter table report_bpdelinquency modify totalcount int null; 
alter table report_bpdelinquency modify processedcount int null; 

drop table if exists sms_inbox; 
drop table if exists sms_inbox_pending; 
drop table if exists sms_outbox; 
drop table if exists sms_outbox_pending; 


create index `ix_txnno` on subcollector_remittance (`txnno`); 
create index `ix_state` on subcollector_remittance (`state`); 
create index `ix_dtposted` on subcollector_remittance (`dtposted`); 
create index `ix_collector_objid` on subcollector_remittance (`collector_objid`); 
create index `ix_subcollector_objid` on subcollector_remittance (`subcollector_objid`); 


drop table if exists sys_notification; 
drop table if exists sys_notification_group; 
drop table if exists sys_notification_user; 


alter table sys_report drop foreign key sys_report_ibfk_1;

alter table sys_rule add _ukey varchar(50) not null default ''; 
update sys_rule set _ukey = objid where _ukey = '';
create UNIQUE index `uix_ruleset_name` on sys_rule (`ruleset`,`name`,`_ukey`); 

create index `ix_actiondef_objid` on sys_rule_action (`actiondef_objid`); 


alter table remittance modify controldate date not null ;

update remittance_fund set cashbreakdown='[]' where cashbreakdown is null; 


update 
  remittance_fund aa, ( 
    select rf.objid, concat(r.controlno,'-',fund.code) as controlno 
    from remittance_fund rf, remittance r, fund 
    where rf.remittanceid = r.objid 
      and rf.fund_objid = fund.objid 
  )bb 
set aa.controlno = bb.controlno  
where aa.objid = bb.objid
;


