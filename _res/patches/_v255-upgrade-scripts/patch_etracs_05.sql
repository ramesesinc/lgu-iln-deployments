use etracs255_ilocosnorte;

CREATE TABLE `afrequest` (
  `objid` varchar(50) NOT NULL,
  `reqno` varchar(20) NULL,
  `state` varchar(25) NOT NULL,
  `dtfiled` datetime NULL,
  `reqtype` varchar(10) NULL,
  `itemclass` varchar(50) NULL,
  `requester_objid` varchar(50) NULL,
  `requester_name` varchar(50) NULL,
  `requester_title` varchar(50) NULL,
  `org_objid` varchar(50) NULL,
  `org_name` varchar(50) NULL,
  `vendor` varchar(100) NULL,
  `respcenter_objid` varchar(50) NULL,
  `respcenter_name` varchar(100) NULL,
  `dtapproved` datetime NULL,
  `approvedby_objid` varchar(50) NULL,
  `approvedby_name` varchar(160) NULL,
  constraint pk_afrequest PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8 
;
create UNIQUE index `uix_reqno` on afrequest (`reqno`) ; 
create index `ix_dtfiled` on afrequest (`dtfiled`) ; 
create index `ix_org_objid` on afrequest (`org_objid`) ; 
create index `ix_requester_name` on afrequest (`requester_name`) ; 
create index `ix_requester_objid` on afrequest (`requester_objid`) ; 
create index `ix_state` on afrequest (`state`) ; 
create index `ix_dtapproved` on afrequest (`dtapproved`) ; 
create index `ix_approvedby_objid` on afrequest (`approvedby_objid`) ; 
create index `ix_approvedby_name` on afrequest (`approvedby_name`) ; 


CREATE TABLE `afrequestitem` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NULL,
  `item_objid` varchar(50) NULL,
  `item_code` varchar(50) NULL,
  `item_title` varchar(255) NULL,
  `unit` varchar(10) NULL,
  `qty` int(11) NULL,
  `qtyreceived` int(11) NULL,
  constraint pk_afrequestitem PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_parentid` on afrequestitem (`parentid`) ; 
create index `ix_item_objid` on afrequestitem (`item_objid`) ; 
alter table afrequestitem add CONSTRAINT `fk_afrequestitem_parentid` 
  FOREIGN KEY (`parentid`) REFERENCES `afrequest` (`objid`) ;


CREATE TABLE `aftxn_type` (
  `txntype` varchar(50) NOT NULL,
  `formtype` varchar(50) NULL,
  `poststate` varchar(50) NULL,
  `sortorder` int(11) NULL,
  constraint pk_aftxn_type PRIMARY KEY (`txntype`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

INSERT INTO `aftxn_type` (`txntype`, `formtype`, `poststate`, `sortorder`) VALUES ('PURCHASE', 'PURCHASE_RECEIPT', 'OPEN', '0');
INSERT INTO `aftxn_type` (`txntype`, `formtype`, `poststate`, `sortorder`) VALUES ('BEGIN', 'BEGIN_BALANCE', 'OPEN', '1');
INSERT INTO `aftxn_type` (`txntype`, `formtype`, `poststate`, `sortorder`) VALUES ('FORWARD', 'FORWARD', 'ISSUED', '2');
INSERT INTO `aftxn_type` (`txntype`, `formtype`, `poststate`, `sortorder`) VALUES ('COLLECTION', 'ISSUE', 'ISSUED', '3');
INSERT INTO `aftxn_type` (`txntype`, `formtype`, `poststate`, `sortorder`) VALUES ('SALE', 'ISSUE', 'SOLD', '4');
INSERT INTO `aftxn_type` (`txntype`, `formtype`, `poststate`, `sortorder`) VALUES ('TRANSFER_COLLECTION', 'TRANSFER', 'ISSUED', '5');
INSERT INTO `aftxn_type` (`txntype`, `formtype`, `poststate`, `sortorder`) VALUES ('TRANSFER_SALE', 'TRANSFER', 'ISSUED', '6');
INSERT INTO `aftxn_type` (`txntype`, `formtype`, `poststate`, `sortorder`) VALUES ('RETURN_COLLECTION', 'RETURN', 'OPEN', '7');
INSERT INTO `aftxn_type` (`txntype`, `formtype`, `poststate`, `sortorder`) VALUES ('RETURN_SALE', 'RETURN', 'OPEN', '8');


CREATE TABLE `aftxn` (
  `objid` varchar(100) NOT NULL,
  `state` varchar(50) NULL,
  `request_objid` varchar(50) NULL,
  `request_reqno` varchar(50) NULL,
  `controlno` varchar(50) NULL,
  `dtfiled` datetime NULL,
  `user_objid` varchar(50) NULL,
  `user_name` varchar(100) NULL,
  `issueto_objid` varchar(50) NULL,
  `issueto_name` varchar(100) NULL,
  `issueto_title` varchar(50) NULL,
  `org_objid` varchar(50) NULL,
  `org_name` varchar(50) NULL,
  `respcenter_objid` varchar(50) NULL,
  `respcenter_name` varchar(100) NULL,
  `txndate` datetime NOT NULL,
  `cost` decimal(16,2) NULL,
  `txntype` varchar(50) NULL,
  `particulars` varchar(255) NULL,
  `issuefrom_objid` varchar(50) NULL,
  `issuefrom_name` varchar(150) NULL,
  `issuefrom_title` varchar(150) NULL,
  constraint pk_aftxn PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create UNIQUE index `uix_issueno` on aftxn (`controlno`) ; 
create index `ix_dtfiled` on aftxn (`dtfiled`) ; 
create index `ix_issuefrom_name` on aftxn (`issuefrom_name`) ; 
create index `ix_issuefrom_objid` on aftxn (`issuefrom_objid`) ; 
create index `ix_issueto_objid` on aftxn (`issueto_objid`) ; 
create index `ix_org_objid` on aftxn (`org_objid`) ; 
create index `ix_request_objid` on aftxn (`request_objid`) ; 
create index `ix_request_reqno` on aftxn (`request_reqno`) ; 
create index `ix_user_objid` on aftxn (`user_objid`) ; 


CREATE TABLE `aftxnitem` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(100) NOT NULL,
  `item_objid` varchar(50) NULL,
  `item_code` varchar(50) NULL,
  `item_title` varchar(255) NULL,
  `unit` varchar(20) NULL,
  `qty` int(11) NULL,
  `qtyserved` int(11) NULL,
  `remarks` varchar(255) NULL,
  `txntype` varchar(50) NULL,
  `cost` decimal(16,2) NULL,
  constraint pk_aftxnitem PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_parentid` on aftxnitem (`parentid`) ; 
create index `ix_item_objid` on aftxnitem (`item_objid`) ; 
alter table aftxnitem add CONSTRAINT `fk_aftxnitem_parentid` 
  FOREIGN KEY (`parentid`) REFERENCES `aftxn` (`objid`) ; 


CREATE TABLE `afunit` (
  `objid` varchar(50) NOT NULL,
  `itemid` varchar(50) NOT NULL,
  `unit` varchar(10) NOT NULL,
  `qty` int(11) NULL,
  `saleprice` decimal(16,2) NOT NULL,
  `interval` int(11) DEFAULT '1',
  `cashreceiptprintout` varchar(255) NULL,
  `cashreceiptdetailprintout` varchar(255) NULL,
  constraint pk_afunit PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create UNIQUE index `uix_itemid_unit` on afunit (`itemid`,`unit`) ; 
create index `ix_itemid` on afunit (`itemid`) ; 

alter table afunit modify itemid varchar(50) character set utf8 not null 
;
alter table afunit add CONSTRAINT `fk_afunit_itemid` 
  FOREIGN KEY (`itemid`) REFERENCES `af` (`objid`) ; 



CREATE TABLE `jev` (
  `objid` varchar(150) NOT NULL,
  `jevno` varchar(50) NULL,
  `jevdate` date NULL,
  `fundid` varchar(50) NULL,
  `dtposted` datetime NULL,
  `txntype` varchar(50) NULL,
  `refid` varchar(50) NULL,
  `refno` varchar(50) NULL,
  `reftype` varchar(50) NULL,
  `amount` decimal(16,4) NULL,
  `state` varchar(32) NULL,
  `postedby_objid` varchar(50) NULL,
  `postedby_name` varchar(255) NULL,
  `verifiedby_objid` varchar(50) NULL,
  `verifiedby_name` varchar(255) NULL,
  `dtverified` datetime NULL,
  `batchid` varchar(50) NULL,
  `refdate` date NULL,
  constraint pk_jev PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_batchid` on jev (`batchid`) ; 
create index `ix_dtposted` on jev (`dtposted`) ; 
create index `ix_dtverified` on jev (`dtverified`) ; 
create index `ix_fundid` on jev (`fundid`) ; 
create index `ix_jevdate` on jev (`jevdate`) ; 
create index `ix_jevno` on jev (`jevno`) ; 
create index `ix_postedby_objid` on jev (`postedby_objid`) ; 
create index `ix_refdate` on jev (`refdate`) ; 
create index `ix_refid` on jev (`refid`) ; 
create index `ix_refno` on jev (`refno`) ; 
create index `ix_reftype` on jev (`reftype`) ; 
create index `ix_verifiedby_objid` on jev (`verifiedby_objid`) ; 


CREATE TABLE `jevitem` (
  `objid` varchar(150) NOT NULL,
  `jevid` varchar(150) NULL,
  `accttype` varchar(50) NULL,
  `acctid` varchar(50) NULL,
  `acctcode` varchar(32) NULL,
  `acctname` varchar(255) NULL,
  `dr` decimal(16,4) NULL,
  `cr` decimal(16,4) NULL,
  `particulars` varchar(255) NULL,
  `itemrefid` varchar(255) NULL,
  constraint pk_jevitem PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_jevid` on jevitem (`jevid`) ; 
create index `ix_ledgertype` on jevitem (`accttype`) ; 
create index `ix_acctid` on jevitem (`acctid`) ; 
create index `ix_acctcode` on jevitem (`acctcode`) ; 
create index `ix_acctname` on jevitem (`acctname`) ; 
create index `ix_itemrefid` on jevitem (`itemrefid`) ; 
alter table jevitem add CONSTRAINT `fk_jevitem_jevid` 
  FOREIGN KEY (`jevid`) REFERENCES `jev` (`objid`) ; 


CREATE TABLE `bankaccount_ledger` (
  `objid` varchar(150) NOT NULL,
  `jevid` varchar(150) NOT NULL,
  `bankacctid` varchar(50) NOT NULL,
  `itemacctid` varchar(50) NOT NULL,
  `dr` decimal(16,4) NOT NULL,
  `cr` decimal(16,4) NOT NULL,
  constraint pk_bankaccount_ledger PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_jevid` on bankaccount_ledger (`jevid`) ; 
create index `ix_bankacctid` on bankaccount_ledger (`bankacctid`) ; 
create index `ix_itemacctid` on bankaccount_ledger (`itemacctid`) ; 
alter table bankaccount_ledger add CONSTRAINT `fk_bankaccount_ledger_jevid` 
  FOREIGN KEY (`jevid`) REFERENCES `jev` (`objid`) ; 


CREATE TABLE `business_application_task_lock` (
  `refid` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  constraint pk_business_application_task_lock PRIMARY KEY (`refid`,`state`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_refid` on business_application_task_lock (`refid`) ; 
alter table business_application_task_lock 
  add CONSTRAINT `fk_business_application_task_lock_refid` 
  FOREIGN KEY (`refid`) REFERENCES `business_application` (`objid`)
;


CREATE TABLE `business_billitem_txntype` (
  `objid` varchar(50) NOT NULL,
  `title` varchar(255) NULL,
  `category` varchar(50) NULL,
  `acctid` varchar(50) NULL,
  `feetype` varchar(50) NULL,
  `domain` varchar(100) NULL,
  `role` varchar(100) NULL,
  constraint pk_business_billitem_txntype PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_acctid` on business_billitem_txntype (`acctid`) ; 


CREATE TABLE `cashreceipt_reprint_log` (
  `objid` varchar(50) NOT NULL,
  `receiptid` varchar(50) NOT NULL,
  `approvedby_objid` varchar(50) NOT NULL,
  `approvedby_name` varchar(150) NOT NULL,
  `dtapproved` datetime NOT NULL,
  `reason` varchar(255) NOT NULL,
  constraint pk_cashreceipt_reprint_log PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_approvedby_name` on cashreceipt_reprint_log (`approvedby_name`) ; 
create index `ix_approvedby_objid` on cashreceipt_reprint_log (`approvedby_objid`) ; 
create index `ix_dtapproved` on cashreceipt_reprint_log (`dtapproved`) ; 
create index `ix_receiptid` on cashreceipt_reprint_log (`receiptid`) ; 
alter table cashreceipt_reprint_log 
  add CONSTRAINT `fk_cashreceipt_reprint_log_receiptid` 
  FOREIGN KEY (`receiptid`) REFERENCES `cashreceipt` (`objid`) 
;


CREATE TABLE `cashreceipt_share` (
  `objid` varchar(50) NOT NULL,
  `receiptid` varchar(50) NOT NULL,
  `refitem_objid` varchar(50) NOT NULL,
  `payableitem_objid` varchar(50) NOT NULL,
  `amount` decimal(16,4) NOT NULL,
  `share` decimal(16,2) NULL,
  constraint pk_cashreceipt_share PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_receiptid` on cashreceipt_share (`receiptid`) ; 
create index `ix_refitem_objid` on cashreceipt_share (`refitem_objid`) ; 
create index `ix_payableitem_objid` on cashreceipt_share (`payableitem_objid`) ; 
alter table cashreceipt_share 
  add CONSTRAINT `fk_cashreceipt_share_receiptid` 
  FOREIGN KEY (`receiptid`) REFERENCES `cashreceipt` (`objid`) 
;


CREATE TABLE `cash_treasury_ledger` (
  `objid` varchar(150) NOT NULL,
  `jevid` varchar(150) NULL,
  `itemacctid` varchar(50) NULL,
  `dr` decimal(16,4) NULL,
  `cr` decimal(16,4) NULL,
  constraint pk_cash_treasury_ledger PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_jevid` on cash_treasury_ledger (`jevid`) ; 
create index `ix_itemacctid` on cash_treasury_ledger (`itemacctid`) ; 
alter table cash_treasury_ledger 
  add CONSTRAINT `cash_treasury_ledger_jevid` 
  FOREIGN KEY (`jevid`) REFERENCES `jev` (`objid`) ; 


CREATE TABLE `depositvoucher` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `controlno` varchar(100) NOT NULL,
  `controldate` date NOT NULL,
  `dtcreated` datetime NOT NULL,
  `createdby_objid` varchar(50) NOT NULL,
  `createdby_name` varchar(255) NOT NULL,
  `amount` decimal(16,4) NOT NULL,
  `dtposted` datetime NULL,
  `postedby_objid` varchar(50) NULL,
  `postedby_name` varchar(255) NULL,
  constraint pk_depositvoucher PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create UNIQUE index `uix_controlno` on depositvoucher (`controlno`) ; 
create index `ix_state` on depositvoucher (`state`) ; 
create index `ix_controldate` on depositvoucher (`controldate`) ; 
create index `ix_createdby_objid` on depositvoucher (`createdby_objid`) ; 
create index `ix_createdby_name` on depositvoucher (`createdby_name`) ; 
create index `ix_dtcreated` on depositvoucher (`dtcreated`) ; 
create index `ix_postedby_objid` on depositvoucher (`postedby_objid`) ; 
create index `ix_postedby_name` on depositvoucher (`postedby_name`) ; 
create index `ix_dtposted` on depositvoucher (`dtposted`) ; 

CREATE TABLE `depositvoucher_fund` (
  `objid` varchar(150) NOT NULL,
  `state` varchar(20) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `fundid` varchar(100) NOT NULL,
  `amount` decimal(16,4) NOT NULL,
  `amountdeposited` decimal(16,4) NOT NULL,
  `totaldr` decimal(16,4) NOT NULL,
  `totalcr` decimal(16,4) NOT NULL,
  `dtposted` datetime NULL,
  `postedby_objid` varchar(50) NULL,
  `postedby_name` varchar(255) NULL,
  `postedby_title` varchar(100) NULL,
  constraint pk_depositvoucher_fund PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create UNIQUE index `uix_parentid_fundid` on depositvoucher_fund (`parentid`,`fundid`) ; 
create index `ix_state` on depositvoucher_fund (`state`) ; 
create index `ix_parentid` on depositvoucher_fund (`parentid`) ; 
create index `ix_fundid` on depositvoucher_fund (`fundid`) ; 
create index `ix_dtposted` on depositvoucher_fund (`dtposted`) ; 
create index `ix_postedby_objid` on depositvoucher_fund (`postedby_objid`) ; 
create index `ix_postedby_name` on depositvoucher_fund (`postedby_name`) ; 
alter table depositvoucher_fund 
  add CONSTRAINT `fk_depositvoucher_fund_fundid` 
  FOREIGN KEY (`fundid`) REFERENCES `fund` (`objid`) ; 
alter table depositvoucher_fund 
  add CONSTRAINT `fk_depositvoucher_fund_parentid` 
  FOREIGN KEY (`parentid`) REFERENCES `depositvoucher` (`objid`) ; 


CREATE TABLE `depositslip` (
  `objid` varchar(100) NOT NULL,
  `depositvoucherfundid` varchar(150) NULL,
  `createdby_objid` varchar(50) NULL,
  `createdby_name` varchar(255) NULL,
  `depositdate` date NULL,
  `dtcreated` datetime NULL,
  `bankacctid` varchar(50) NULL,
  `totalcash` decimal(16,4) NULL,
  `totalcheck` decimal(16,4) NULL,
  `amount` decimal(16,4) NULL,
  `validation_refno` varchar(50) NULL,
  `validation_refdate` date NULL,
  `cashbreakdown` longtext,
  `state` varchar(10) NULL,
  `deposittype` varchar(50) NULL,
  `checktype` varchar(50) NULL,
  constraint pk_depositslip PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_depositvoucherid` on depositslip (`depositvoucherfundid`) ; 
create index `ix_createdby_objid` on depositslip (`createdby_objid`) ; 
create index `ix_createdby_name` on depositslip (`createdby_name`) ; 
create index `ix_depositdate` on depositslip (`depositdate`) ; 
create index `ix_dtcreated` on depositslip (`dtcreated`) ; 
create index `ix_bankacctid` on depositslip (`bankacctid`) ; 
create index `ix_validation_refno` on depositslip (`validation_refno`) ; 
create index `ix_validation_refdate` on depositslip (`validation_refdate`) ; 
alter table depositslip 
  add CONSTRAINT `fk_depositslip_depositvoucherfundid` 
  FOREIGN KEY (`depositvoucherfundid`) REFERENCES `depositvoucher_fund` (`objid`) ;


CREATE TABLE `checkpayment` (
  `objid` varchar(50) NOT NULL,
  `bankid` varchar(50) NULL,
  `refno` varchar(50) NULL,
  `refdate` date NULL,
  `amount` decimal(16,4) NULL,
  `receiptid` varchar(50) NULL,
  `bank_name` varchar(255) NULL,
  `amtused` decimal(16,4) NULL,
  `receivedfrom` longtext,
  `state` varchar(50) NULL,
  `depositvoucherid` varchar(50) NULL,
  `fundid` varchar(100) NULL,
  `depositslipid` varchar(100) NULL,
  `split` int(11) NOT NULL,
  `external` int(11) NOT NULL DEFAULT '0',
  `collector_objid` varchar(50) NULL,
  `collector_name` varchar(255) NULL,
  `subcollector_objid` varchar(50) NULL,
  `subcollector_name` varchar(255) NULL,
  constraint pk_checkpayment PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_bankid` on checkpayment (`bankid`) ; 
create index `ix_collector_name` on checkpayment (`collector_name`) ; 
create index `ix_collectorid` on checkpayment (`collector_objid`) ; 
create index `ix_depositslipid` on checkpayment (`depositslipid`) ; 
create index `ix_depositvoucherid` on checkpayment (`depositvoucherid`) ; 
create index `ix_fundid` on checkpayment (`fundid`) ; 
create index `ix_receiptid` on checkpayment (`receiptid`) ; 
create index `ix_refdate` on checkpayment (`refdate`) ; 
create index `ix_refno` on checkpayment (`refno`) ; 
create index `ix_state` on checkpayment (`state`) ; 
create index `ix_subcollector_objid` on checkpayment (`subcollector_objid`) ; 
alter table checkpayment 
  add CONSTRAINT `fk_checkpayment_depositslipid` 
  FOREIGN KEY (`depositslipid`) REFERENCES `depositslip` (`objid`) ; 
alter table checkpayment 
  add CONSTRAINT `fk_paymentcheck_depositvoucher` 
  FOREIGN KEY (`depositvoucherid`) REFERENCES `depositvoucher` (`objid`) ; 
alter table checkpayment 
  add CONSTRAINT `fk_paymentcheck_fund` 
  FOREIGN KEY (`fundid`) REFERENCES `fund` (`objid`) ; 


CREATE TABLE `checkpayment_deadchecks` (
  `objid` varchar(50) NOT NULL,
  `bankid` varchar(50) NULL,
  `refno` varchar(50) NULL,
  `refdate` date NULL,
  `amount` decimal(16,4) NULL,
  `collector_objid` varchar(50) NULL,
  `bank_name` varchar(255) NULL,
  `amtused` decimal(16,4) NULL,
  `receivedfrom` varchar(255) NULL,
  `state` varchar(50) NULL,
  `depositvoucherid` varchar(50) NULL,
  `fundid` varchar(100) NULL,
  `depositslipid` varchar(100) NULL,
  `split` int(11) NOT NULL,
  `amtdeposited` decimal(16,4) NULL,
  `external` int(11) NULL,
  `collector_name` varchar(255) NULL,
  `subcollector_objid` varchar(50) NULL,
  `subcollector_name` varchar(255) NULL,
  `collectorid` varchar(50) NULL,
  constraint pk_checkpayment_deadchecks PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_bankid` on checkpayment_deadchecks (`bankid`) ; 
create index `ix_collector_name` on checkpayment_deadchecks (`collector_name`) ; 
create index `ix_collectorid` on checkpayment_deadchecks (`collector_objid`) ; 
create index `ix_collectorid_` on checkpayment_deadchecks (`collectorid`) ; 
create index `ix_depositslipid` on checkpayment_deadchecks (`depositslipid`) ; 
create index `ix_depositvoucherid` on checkpayment_deadchecks (`depositvoucherid`) ; 
create index `ix_fundid` on checkpayment_deadchecks (`fundid`) ; 
create index `ix_refdate` on checkpayment_deadchecks (`refdate`) ; 
create index `ix_refno` on checkpayment_deadchecks (`refno`) ; 
create index `ix_subcollector_objid` on checkpayment_deadchecks (`subcollector_objid`) ; 


CREATE TABLE `checkpayment_dishonored` (
  `objid` varchar(50) NOT NULL,
  `checkpaymentid` varchar(50) NOT NULL,
  `dtfiled` datetime NOT NULL,
  `filedby_objid` varchar(50) NOT NULL,
  `filedby_name` varchar(150) NOT NULL,
  `remarks` varchar(255) NOT NULL,
  constraint pk_checkpayment_dishonored PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_checkpaymentid` on checkpayment_dishonored (`checkpaymentid`) ; 
create index `ix_dtfiled` on checkpayment_dishonored (`dtfiled`) ; 
create index `ix_filedby_objid` on checkpayment_dishonored (`filedby_objid`) ; 
create index `ix_filedby_name` on checkpayment_dishonored (`filedby_name`) ; 
alter table checkpayment_dishonored 
  add CONSTRAINT `fk_checkpayment_dishonored_checkpaymentid` 
  FOREIGN KEY (`checkpaymentid`) REFERENCES `checkpayment` (`objid`) ; 


CREATE TABLE `collectiongroup_org` (
  `objid` varchar(100) NOT NULL,
  `collectiongroupid` varchar(50) NOT NULL,
  `org_objid` varchar(50) NOT NULL,
  `org_name` varchar(255) NOT NULL,
  `org_type` varchar(50) NOT NULL,
  constraint pk_collectiongroup_org PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create UNIQUE index `uix_collectiongroup_org` on collectiongroup_org (`collectiongroupid`,`org_objid`) ; 
create index `ix_collectiongroupid` on collectiongroup_org (`collectiongroupid`) ; 
create index `ix_org_objid` on collectiongroup_org (`org_objid`) ; 
alter table collectiongroup_org 
  add CONSTRAINT `fk_collectiongroup_org_parent` 
  FOREIGN KEY (`collectiongroupid`) REFERENCES `collectiongroup` (`objid`) ; 


CREATE TABLE `collectiontype_org` (
  `objid` varchar(100) NOT NULL,
  `collectiontypeid` varchar(50) NULL,
  `org_objid` varchar(50) NULL,
  `org_name` varchar(150) NULL,
  `org_type` varchar(50) NULL,
  constraint pk_collectiontype_org PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create UNIQUE index `uix_collectiontype_org` on collectiontype_org (`collectiontypeid`,`org_objid`) ; 
create index `ix_collectiontypeid` on collectiontype_org (`collectiontypeid`) ; 
create index `ix_org_objid` on collectiontype_org (`org_objid`) ; 
create index `ix_org_name` on collectiontype_org (`org_name`) ; 
alter table collectiontype_org 
  add CONSTRAINT `fk_collectiontype_org_parent` 
  FOREIGN KEY (`collectiontypeid`) REFERENCES `collectiontype` (`objid`) ; 


CREATE TABLE `collectionvoucher` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `controlno` varchar(100) NOT NULL,
  `controldate` date NOT NULL,
  `dtposted` datetime NOT NULL,
  `liquidatingofficer_objid` varchar(50) NULL,
  `liquidatingofficer_name` varchar(100) NULL,
  `liquidatingofficer_title` varchar(50) NULL,
  `liquidatingofficer_signature` longtext,
  `amount` decimal(18,2) NULL,
  `totalcash` decimal(18,2) NULL,
  `totalcheck` decimal(16,4) NULL,
  `cashbreakdown` longtext,
  `totalcr` decimal(16,4) NULL,
  `depositvoucherid` varchar(50) NULL,
  constraint pk_collectionvoucher PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create UNIQUE index `uix_controlno` on collectionvoucher (`controlno`) ; 
create index `ix_state` on collectionvoucher (`state`) ; 
create index `ix_controldate` on collectionvoucher (`controldate`) ; 
create index `ix_dtposted` on collectionvoucher (`dtposted`) ; 
create index `ix_liquidatingofficer_objid` on collectionvoucher (`liquidatingofficer_objid`) ; 
create index `ix_liquidatingofficer_name` on collectionvoucher (`liquidatingofficer_name`) ; 
create index `ix_depositvoucherid` on collectionvoucher (`depositvoucherid`) ; 
alter table collectionvoucher 
  add CONSTRAINT `fk_collectionvoucher_depositvoucherid` 
  FOREIGN KEY (`depositvoucherid`) REFERENCES `depositvoucher` (`objid`) ; 
alter table collectionvoucher 
  add CONSTRAINT `fk_collectionvoucher_liquidatingofficer` 
  FOREIGN KEY (`liquidatingofficer_objid`) REFERENCES `sys_user` (`objid`) ; 


CREATE TABLE `collectionvoucher_fund` (
  `objid` varchar(255) NOT NULL,
  `controlno` varchar(100) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `fund_objid` varchar(100) NOT NULL,
  `fund_title` varchar(100) NOT NULL,
  `amount` decimal(16,4) NOT NULL,
  `totalcash` decimal(16,4) NOT NULL,
  `totalcheck` decimal(16,4) NOT NULL,
  `totalcr` decimal(16,4) NOT NULL,
  `cashbreakdown` longtext,
  `depositvoucherid` varchar(50) NULL,
  constraint pk_collectionvoucher_fund PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create UNIQUE index `uix_parentid_fund_objid` on collectionvoucher_fund (`parentid`,`fund_objid`) ; 
create index `ix_controlno` on collectionvoucher_fund (`controlno`) ; 
create index `ix_parentid` on collectionvoucher_fund (`parentid`) ; 
create index `ix_fund_objid` on collectionvoucher_fund (`fund_objid`) ; 
create index `ix_depositvoucherid` on collectionvoucher_fund (`depositvoucherid`) ; 
alter table collectionvoucher_fund 
  add CONSTRAINT `fk_collectionvoucher_fund_fund_objid` 
  FOREIGN KEY (`fund_objid`) REFERENCES `fund` (`objid`) ; 
alter table collectionvoucher_fund 
  add CONSTRAINT `fk_collectionvoucher_fund_parentid` 
  FOREIGN KEY (`parentid`) REFERENCES `collectionvoucher` (`objid`) ; 


CREATE TABLE `deposit_fund_transfer` (
  `objid` varchar(150) NOT NULL,
  `fromdepositvoucherfundid` varchar(150) NOT NULL,
  `todepositvoucherfundid` varchar(150) NOT NULL,
  `amount` decimal(16,4) NOT NULL,
  constraint pk_deposit_fund_transfer PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_fromfundid` on deposit_fund_transfer (`fromdepositvoucherfundid`) ; 
create index `ix_tofundid` on deposit_fund_transfer (`todepositvoucherfundid`) ; 
alter table deposit_fund_transfer 
  add CONSTRAINT `fk_deposit_fund_transfer_fromdepositvoucherfundid` 
  FOREIGN KEY (`fromdepositvoucherfundid`) REFERENCES `fund` (`objid`) ;
alter table deposit_fund_transfer 
  add CONSTRAINT `fk_deposit_fund_transfer_todepositvoucherfundid` 
  FOREIGN KEY (`todepositvoucherfundid`) REFERENCES `fund` (`objid`) ;


drop table if exists draftremittanceitem;
drop table if exists draftremittance; 

CREATE TABLE `draftremittance` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(20) NOT NULL,
  `dtfiled` datetime NOT NULL,
  `remittancedate` datetime NOT NULL,
  `collector_objid` varchar(50) NOT NULL,
  `collector_name` varchar(255) NOT NULL,
  `collector_title` varchar(255) NOT NULL,
  `amount` decimal(18,2) NOT NULL,
  `totalcash` decimal(18,2) NOT NULL,
  `totalnoncash` decimal(18,2) NOT NULL,
  `txnmode` varchar(32) NOT NULL,
  `lockid` varchar(50) NULL,
  constraint pk_draftremittance PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_dtfiled` on draftremittance (`dtfiled`) ;
create index `ix_remittancedate` on draftremittance (`remittancedate`) ;
create index `ix_collector_objid` on draftremittance (`collector_objid`) ;


CREATE TABLE `draftremittanceitem` (
  `objid` varchar(50) NOT NULL,
  `remittanceid` varchar(50) NOT NULL,
  `controlid` varchar(50) NOT NULL,
  `batchid` varchar(50) NULL,
  `amount` decimal(18,2) NOT NULL,
  `totalcash` decimal(18,2) NOT NULL,
  `totalnoncash` decimal(18,2) NOT NULL,
  `voided` int(11) NOT NULL,
  `cancelled` int(11) NOT NULL,
  `lockid` varchar(50) NULL,
  constraint pk_draftremittanceitem PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_remittanceid` on draftremittanceitem (`remittanceid`) ; 
create index `ix_controlid` on draftremittanceitem (`controlid`) ; 
create index `ix_batchid` on draftremittanceitem (`batchid`) ; 


CREATE TABLE `eftpayment` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `refno` varchar(50) NOT NULL,
  `refdate` date NOT NULL,
  `amount` decimal(16,4) NOT NULL,
  `receivedfrom` varchar(255) NULL,
  `particulars` varchar(255) NULL,
  `bankacctid` varchar(50) NOT NULL,
  `fundid` varchar(100) NULL,
  `createdby_objid` varchar(50) NOT NULL,
  `createdby_name` varchar(255) NOT NULL,
  `receiptid` varchar(50) NULL,
  `receiptno` varchar(50) NULL,
  `payer_objid` varchar(50) NULL,
  `payer_name` varchar(255) NULL,
  `payer_address_objid` varchar(50) NULL,
  `payer_address_text` varchar(255) NULL,
  constraint pk_eftpayment PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_state` on eftpayment (`state`) ; 
create index `ix_refno` on eftpayment (`refno`) ; 
create index `ix_refdate` on eftpayment (`refdate`) ; 
create index `ix_bankacctid` on eftpayment (`bankacctid`) ; 
create index `ix_fundid` on eftpayment (`fundid`) ; 
create index `ix_createdby_objid` on eftpayment (`createdby_objid`) ; 
create index `ix_receiptid` on eftpayment (`receiptid`) ; 
create index `ix_payer_objid` on eftpayment (`payer_objid`) ; 
create index `ix_payer_address_objid` on eftpayment (`payer_address_objid`) ; 
alter table eftpayment 
  add CONSTRAINT `fk_eftpayment_bankacct` 
  FOREIGN KEY (`bankacctid`) REFERENCES `bankaccount` (`objid`) ; 
alter table eftpayment 
  add CONSTRAINT `fk_eftpayment_fund` 
  FOREIGN KEY (`fundid`) REFERENCES `fund` (`objid`) ; 


CREATE TABLE `entityprofile` (
  `objid` varchar(50) NOT NULL,
  `idno` varchar(50) NOT NULL,
  `lastname` varchar(60) NOT NULL,
  `firstname` varchar(60) NOT NULL,
  `middlename` varchar(60) NULL,
  `birthdate` date NULL,
  `gender` varchar(10) NULL,
  `address` longtext,
  `defaultentityid` varchar(50) NULL,
  constraint pk_entityprofile PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_defaultentityid` on entityprofile (`defaultentityid`) ; 
create index `ix_firstname` on entityprofile (`firstname`) ; 
create index `ix_idno` on entityprofile (`idno`) ; 
create index `ix_lastname` on entityprofile (`lastname`) ; 
create index `ix_lfname` on entityprofile (`lastname`,`firstname`) ; 


CREATE TABLE `entity_ctc` (
  `objid` varchar(50) NOT NULL,
  `entityid` varchar(50) NOT NULL,
  `nonresident` int(11) NOT NULL,
  `ctcno` varchar(50) NOT NULL,
  `dtissued` date NOT NULL,
  `placeissued` varchar(255) NOT NULL,
  `lgu_objid` varchar(50) NULL,
  `lgu_name` varchar(255) NULL,
  `barangay_objid` varchar(50) NULL,
  `barangay_name` varchar(255) NOT NULL,
  `createdby_objid` varchar(50) NOT NULL,
  `createdby_name` varchar(160) NOT NULL,
  `system` int(11) NOT NULL DEFAULT '0',
  constraint pk_entity_ctc PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_barangay_name` on entity_ctc (`barangay_name`) ; 
create index `ix_barangay_objid` on entity_ctc (`barangay_objid`) ; 
create index `ix_createdby_name` on entity_ctc (`createdby_name`) ; 
create index `ix_createdby_objid` on entity_ctc (`createdby_objid`) ; 
create index `ix_ctcno` on entity_ctc (`ctcno`) ; 
create index `ix_dtissued` on entity_ctc (`dtissued`) ; 
create index `ix_entityid` on entity_ctc (`entityid`) ; 
create index `ix_lgu_name` on entity_ctc (`lgu_name`) ; 
create index `ix_lgu_objid` on entity_ctc (`lgu_objid`) ; 
alter table entity_ctc 
  add CONSTRAINT `fk_entity_ctc_entityid` 
  FOREIGN KEY (`entityid`) REFERENCES `entity` (`objid`) ; 


CREATE TABLE `entity_fingerprint` (
  `objid` varchar(50) NOT NULL,
  `entityid` varchar(50) NULL,
  `dtfiled` datetime NULL,
  `fingertype` varchar(20) NULL,
  `data` longtext,
  `image` longtext,
  constraint pk_entity_fingerprint PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create UNIQUE index `uix_entityid_fingertype` on entity_fingerprint (`entityid`,`fingertype`) ; 
create index `ix_dtfiled` on entity_fingerprint (`dtfiled`) ; 


CREATE TABLE `entity_reconciled` (
  `objid` varchar(50) NOT NULL,
  `info` longtext,
  `masterid` varchar(50) NULL,
  constraint pk_entity_reconciled PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `FK_entity_reconciled_entity` on entity_reconciled (`masterid`) ; 
alter table entity_reconciled 
  add CONSTRAINT `FK_entity_reconciled_entity` 
  FOREIGN KEY (`masterid`) REFERENCES `entity` (`objid`) ; 


CREATE TABLE `entity_reconciled_txn` (
  `objid` varchar(50) NOT NULL,
  `reftype` varchar(50) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `tag` char(1) NULL,
  constraint pk_entity_reconciled_txn PRIMARY KEY (`objid`,`reftype`,`refid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


CREATE TABLE `entity_relation_type` (
  `objid` varchar(50) NOT NULL DEFAULT '',
  `gender` varchar(1) NULL,
  `inverse_any` varchar(50) NULL,
  `inverse_male` varchar(50) NULL,
  `inverse_female` varchar(50) NULL,
  constraint pk_entity_relation_type PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `entity_relation_type` (`objid`, `gender`, `inverse_any`, `inverse_male`, `inverse_female`) VALUES ('AUNT', 'F', 'NEPHEW/NIECE', 'NEPHEW', 'NIECE');
INSERT INTO `entity_relation_type` (`objid`, `gender`, `inverse_any`, `inverse_male`, `inverse_female`) VALUES ('BROTHER', 'M', 'SIBLING', 'BROTHER', 'SISTER');
INSERT INTO `entity_relation_type` (`objid`, `gender`, `inverse_any`, `inverse_male`, `inverse_female`) VALUES ('COUSIN', NULL, 'COUSIN', 'COUSIN', 'COUSIN');
INSERT INTO `entity_relation_type` (`objid`, `gender`, `inverse_any`, `inverse_male`, `inverse_female`) VALUES ('DAUGHTER', 'F', 'PARENT', 'FATHER', 'MOTHER');
INSERT INTO `entity_relation_type` (`objid`, `gender`, `inverse_any`, `inverse_male`, `inverse_female`) VALUES ('FATHER', 'M', 'CHILD', 'SON', 'DAUGHTER');
INSERT INTO `entity_relation_type` (`objid`, `gender`, `inverse_any`, `inverse_male`, `inverse_female`) VALUES ('GRANDDAUGHTER', 'F', 'GRANDPARENT', 'GRANDFATHER', 'GRANDMOTHER');
INSERT INTO `entity_relation_type` (`objid`, `gender`, `inverse_any`, `inverse_male`, `inverse_female`) VALUES ('GRANDSON', 'M', 'GRANDPARENT', 'GRANDFATHER', 'GRANDMOTHER');
INSERT INTO `entity_relation_type` (`objid`, `gender`, `inverse_any`, `inverse_male`, `inverse_female`) VALUES ('HUSBAND', 'M', 'SPOUSE', 'SPOUSE', 'WIFE');
INSERT INTO `entity_relation_type` (`objid`, `gender`, `inverse_any`, `inverse_male`, `inverse_female`) VALUES ('MOTHER', 'F', 'CHILD', 'SON', 'DAUGHTER');
INSERT INTO `entity_relation_type` (`objid`, `gender`, `inverse_any`, `inverse_male`, `inverse_female`) VALUES ('NEPHEW', 'M', 'UNCLE/AUNT', 'UNCLE', 'AUNT');
INSERT INTO `entity_relation_type` (`objid`, `gender`, `inverse_any`, `inverse_male`, `inverse_female`) VALUES ('NIECE', 'F', 'UNCLE/AUNT', 'UNCLE', 'AUNT');
INSERT INTO `entity_relation_type` (`objid`, `gender`, `inverse_any`, `inverse_male`, `inverse_female`) VALUES ('SISTER', 'F', 'SIBLING', 'BROTHER', 'SISTER');
INSERT INTO `entity_relation_type` (`objid`, `gender`, `inverse_any`, `inverse_male`, `inverse_female`) VALUES ('SON', 'M', 'PARENT', 'FATHER', 'MOTHER');
INSERT INTO `entity_relation_type` (`objid`, `gender`, `inverse_any`, `inverse_male`, `inverse_female`) VALUES ('SPOUSE', NULL, 'SPOUSE', 'HUSBAND', 'WIFE');
INSERT INTO `entity_relation_type` (`objid`, `gender`, `inverse_any`, `inverse_male`, `inverse_female`) VALUES ('UNCLE', 'M', 'NEPHEW/NIECE', 'NEPHEW', 'NIECE');
INSERT INTO `entity_relation_type` (`objid`, `gender`, `inverse_any`, `inverse_male`, `inverse_female`) VALUES ('WIFE', 'F', 'SPOUSE', 'HUSBAND', 'SPOUSE');


drop table if exists entity_relation
;

CREATE TABLE `entity_relation` (
  `objid` varchar(50) NOT NULL,
  `entity_objid` varchar(50) NULL,
  `relateto_objid` varchar(50) NULL,
  `relation_objid` varchar(50) NULL,
  constraint pk_entity_relation PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create UNIQUE index `uix_sender_receiver` on entity_relation (`entity_objid`,`relateto_objid`) ; 
create index `ix_entity_objid` on entity_relation (`entity_objid`) ; 
create index `ix_relateto_objid` on entity_relation (`relateto_objid`) ; 
create index `ix_relation_objid` on entity_relation (`relation_objid`) ; 
alter table entity_relation 
  add CONSTRAINT `fk_entity_relation_entity_objid` 
  FOREIGN KEY (`entity_objid`) REFERENCES `entity` (`objid`) ; 
alter table entity_relation 
  add CONSTRAINT `fk_entity_relation_relation_objid` 
  FOREIGN KEY (`relateto_objid`) REFERENCES `entity` (`objid`) ; 
alter table entity_relation 
  add CONSTRAINT `fk_entity_relation_relation` 
  FOREIGN KEY (`relation_objid`) REFERENCES `entity_relation_type` (`objid`) ; 


CREATE TABLE `fundgroup` (
  `objid` varchar(50) NOT NULL,
  `title` varchar(100) NOT NULL,
  `indexno` int(11) NOT NULL,
  constraint pk_fundgroup PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create UNIQUE index `uix_title` on fundgroup (`title`) ; 


INSERT INTO `fundgroup` (`objid`, `title`, `indexno`) VALUES ('GENERAL', 'GENERAL', '0');
INSERT INTO `fundgroup` (`objid`, `title`, `indexno`) VALUES ('SEF', 'SEF', '1');
INSERT INTO `fundgroup` (`objid`, `title`, `indexno`) VALUES ('TRUST', 'TRUST', '2');


CREATE TABLE `income_ledger` (
  `objid` varchar(150) NOT NULL,
  `jevid` varchar(150) NULL,
  `itemacctid` varchar(50) NOT NULL,
  `dr` decimal(16,4) NOT NULL,
  `cr` decimal(16,4) NOT NULL,
  constraint pk_income_ledger PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_jevid` on income_ledger (`jevid`) ;
create index `ix_itemacctid` on income_ledger (`itemacctid`) ;
alter table income_ledger 
  add CONSTRAINT `fk_income_ledger_jevid` 
  FOREIGN KEY (`jevid`) REFERENCES `jev` (`objid`) ; 
alter table income_ledger 
  add CONSTRAINT `fk_income_ledger_itemacctid` 
  FOREIGN KEY (`itemacctid`) REFERENCES `itemaccount` (`objid`) ; 


CREATE TABLE `interfund_transfer_ledger` (
  `objid` varchar(150) NOT NULL,
  `jevid` varchar(150) NULL,
  `itemacctid` varchar(50) NULL,
  `dr` decimal(16,4) NULL,
  `cr` decimal(16,4) NULL,
  constraint pk_interfund_transfer_ledger PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_jevid` on interfund_transfer_ledger (`jevid`) ; 
create index `ix_itemacctid` on interfund_transfer_ledger (`itemacctid`) ; 
alter table interfund_transfer_ledger 
  add CONSTRAINT `fk_interfund_transfer_ledger_jevid` 
  FOREIGN KEY (`jevid`) REFERENCES `jev` (`objid`) ; 


drop table if exists paymentorder_type 
;

CREATE TABLE `paymentorder_type` (
  `objid` varchar(50) NOT NULL,
  `title` varchar(150) NULL,
  `collectiontype_objid` varchar(50) NULL,
  `queuesection` varchar(50) NULL,
  constraint pk_paymentorder_type PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `fk_paymentorder_type_collectiontype` on paymentorder_type (`collectiontype_objid`) ; 
alter table paymentorder_type 
  add CONSTRAINT `paymentorder_type_ibfk_1` 
  FOREIGN KEY (`collectiontype_objid`) REFERENCES `collectiontype` (`objid`) ; 


CREATE TABLE `payable_ledger` (
  `objid` varchar(50) NOT NULL,
  `jevid` varchar(150) NULL,
  `refitemacctid` varchar(50) NULL,
  `itemacctid` varchar(50) NOT NULL,
  `dr` decimal(16,4) NULL,
  `cr` decimal(16,4) NULL,
  constraint pk_payable_ledger PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_jevid` on payable_ledger (`jevid`) ; 
create index `ix_itemacctid` on payable_ledger (`itemacctid`) ; 
create index `ix_refitemacctid` on payable_ledger (`refitemacctid`) ; 
alter table payable_ledger 
  add CONSTRAINT `fk_payable_ledger_jevid` 
  FOREIGN KEY (`jevid`) REFERENCES `jev` (`objid`) ; 


drop table if exists sys_report 
;

CREATE TABLE `sys_report` (
  `objid` varchar(50) NOT NULL,
  `folderid` varchar(50) NULL,
  `title` varchar(255) NULL,
  `filetype` varchar(25) NULL,
  `dtcreated` datetime NULL,
  `createdby_objid` varchar(50) NULL,
  `createdby_name` varchar(255) NULL,
  `datasetid` varchar(50) NULL,
  `template` mediumtext,
  `outputtype` varchar(50) NULL,
  `system` int(11) NULL,
  constraint pk_sys_report PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `FK_sys_report_dataset` on sys_report (`datasetid`) ; 
create index `FK_sys_report_entry_folder` on sys_report (`folderid`) ; 
alter table sys_report 
  add CONSTRAINT `sys_report_ibfk_1` 
  FOREIGN KEY (`datasetid`) REFERENCES `sys_dataset` (`objid`) ; 


CREATE TABLE `treasury_variableinfo` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(10) NOT NULL,
  `name` varchar(50) NOT NULL,
  `datatype` varchar(20) NOT NULL,
  `caption` varchar(50) NOT NULL,
  `description` varchar(100) NULL,
  `arrayvalues` longtext,
  `system` int(11) NULL,
  `sortorder` int(11) NULL,
  `category` varchar(100) NULL,
  `handler` varchar(50) NULL,
  constraint pk_treasury_variableinfo PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_name` on treasury_variableinfo (`name`) ; 


CREATE TABLE `cashbook_revolving_fund` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `dtfiled` datetime NOT NULL,
  `filedby_objid` varchar(50) NOT NULL,
  `filedby_name` varchar(150) NOT NULL,
  `issueto_objid` varchar(50) NOT NULL,
  `issueto_name` varchar(150) NOT NULL,
  `controldate` date NOT NULL,
  `amount` decimal(16,2) NOT NULL,
  `remarks` varchar(255) NOT NULL,
  `fund_objid` varchar(100) NOT NULL,
  `fund_title` varchar(255) NOT NULL,
  constraint pk_cashbook_revolving_fund PRIMARY KEY (objid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_state` on cashbook_revolving_fund (`state`) ; 
create index `ix_dtfiled` on cashbook_revolving_fund (`dtfiled`) ; 
create index `ix_filedby_objid` on cashbook_revolving_fund (`filedby_objid`) ; 
create index `ix_filedby_name` on cashbook_revolving_fund (`filedby_name`) ; 
create index `ix_issueto_objid` on cashbook_revolving_fund (`issueto_objid`) ; 
create index `ix_issueto_name` on cashbook_revolving_fund (`issueto_name`) ; 
create index `ix_controldate` on cashbook_revolving_fund (`controldate`) ; 
create index `ix_fund_objid` on cashbook_revolving_fund (`fund_objid`) ; 
create index `ix_fund_title` on cashbook_revolving_fund (`fund_title`) ; 


CREATE TABLE `cashreceipt_changelog` (
  `objid` varchar(50) NOT NULL,
  `receiptid` varchar(50) NOT NULL,
  `dtfiled` datetime NOT NULL,
  `filedby_objid` varchar(50) NOT NULL,
  `filedby_name` varchar(150) NOT NULL,
  `action` varchar(255) NOT NULL,
  `remarks` varchar(255) NOT NULL,
  `oldvalue` text NOT NULL,
  `newvalue` text NOT NULL,
  constraint pk_cashreceipt_changelog PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_receiptid` on cashreceipt_changelog (`receiptid`) ; 
create index `ix_dtfiled` on cashreceipt_changelog (`dtfiled`) ; 
create index `ix_filedby_objid` on cashreceipt_changelog (`filedby_objid`) ; 
create index `ix_filedby_name` on cashreceipt_changelog (`filedby_name`) ; 
create index `ix_action` on cashreceipt_changelog (`action`) ; 
alter table cashreceipt_changelog 
  add CONSTRAINT `fk_cashreceipt_changelog_receiptid` 
  FOREIGN KEY (`receiptid`) REFERENCES `cashreceipt` (`objid`) ;


CREATE TABLE `psic` (
  `objid` varchar(50) NOT NULL,
  `title` varchar(255) NOT NULL,
  `parentid` varchar(50) NULL,
  constraint pk_psic PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_title` on psic (`title`) ; 
create index `ix_parentid` on psic (`parentid`) ; 
alter table psic 
  add CONSTRAINT `fk_psic_parentid` 
  FOREIGN KEY (`parentid`) REFERENCES `psic` (`objid`) ;


CREATE TABLE `af_control_detail` (
  `objid` varchar(150) NOT NULL,
  `state` int(11) NULL,
  `controlid` varchar(50) NOT NULL,
  `indexno` int(11) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `aftxnitemid` varchar(50) NULL,
  `refno` varchar(50) NOT NULL,
  `reftype` varchar(32) NOT NULL,
  `refdate` datetime NOT NULL,
  `txndate` datetime NOT NULL,
  `txntype` varchar(32) NOT NULL,
  `receivedstartseries` int(11) NULL,
  `receivedendseries` int(11) NULL,
  `beginstartseries` int(11) NULL,
  `beginendseries` int(11) NULL,
  `issuedstartseries` int(11) NULL,
  `issuedendseries` int(11) NULL,
  `endingstartseries` int(11) NULL,
  `endingendseries` int(11) NULL,
  `qtyreceived` int(11) NOT NULL,
  `qtybegin` int(11) NOT NULL,
  `qtyissued` int(11) NOT NULL,
  `qtyending` int(11) NOT NULL,
  `qtycancelled` int(11) NOT NULL,
  `remarks` varchar(255) NULL,
  `issuedto_objid` varchar(50) NULL,
  `issuedto_name` varchar(255) NULL,
  `respcenter_objid` varchar(50) NULL,
  `respcenter_name` varchar(255) NULL,
  `prevdetailid` varchar(150) NULL,
  `aftxnid` varchar(100) NULL,
  constraint pk_af_control_detail PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_aftxnid` on af_control_detail (`aftxnid`) ; 
create index `ix_aftxnitemid` on af_control_detail (`aftxnitemid`) ; 
create index `ix_controlid` on af_control_detail (`controlid`) ; 
create index `ix_issuedto_name` on af_control_detail (`issuedto_name`) ; 
create index `ix_issuedto_objid` on af_control_detail (`issuedto_objid`) ; 
create index `ix_prevdetailid` on af_control_detail (`prevdetailid`) ; 
create index `ix_refdate` on af_control_detail (`refdate`) ; 
create index `ix_refid` on af_control_detail (`refid`) ; 
create index `ix_refitemid` on af_control_detail (`aftxnitemid`) ; 
create index `ix_refno` on af_control_detail (`refno`) ; 
create index `ix_reftype` on af_control_detail (`reftype`) ; 
create index `ix_respcenter_name` on af_control_detail (`respcenter_name`) ; 
create index `ix_respcenter_objid` on af_control_detail (`respcenter_objid`) ; 
create index `ix_txndate` on af_control_detail (`txndate`) ; 
create index `ix_txntype` on af_control_detail (`txntype`) ; 
alter table af_control_detail 
  add CONSTRAINT `fk_af_control_detail_aftxnid` 
  FOREIGN KEY (`aftxnid`) REFERENCES `aftxn` (`objid`) ; 

alter table af_control_detail modify controlid varchar(50) character set utf8 not null 
; 
alter table af_control_detail 
  add CONSTRAINT `fk_af_control_detail_controlid` 
  FOREIGN KEY (`controlid`) REFERENCES `af_control` (`objid`) ; 


CREATE TABLE `holiday` (
  `objid` varchar(50) NOT NULL,
  `year` int(11) NULL,
  `month` int(11) NULL,
  `day` int(11) NULL,
  `week` int(11) NULL,
  `dow` int(11) NULL,
  `name` varchar(255) NULL,
  constraint pk_holiday PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


CREATE TABLE `af_allocation` (
  `objid` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `respcenter_objid` varchar(50) NULL,
  `respcenter_name` varchar(100) NULL,
  constraint pk_af_allocation PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_name` on af_allocation (`name`) ;
create index `ix_respcenter_objid` on af_allocation (`respcenter_objid`) ;
create index `ix_respcenter_name` on af_allocation (`respcenter_name`) ;


drop table if exists income_summary
;
CREATE TABLE `income_summary` (
  `refid` varchar(50) NOT NULL,
  `refdate` date NOT NULL,
  `refno` varchar(50) NULL,
  `reftype` varchar(50) NULL,
  `acctid` varchar(50) NOT NULL,
  `fundid` varchar(50) NOT NULL,
  `amount` decimal(16,4) NULL,
  `orgid` varchar(50) NOT NULL,
  `collectorid` varchar(50) NULL,
  `refyear` int(11) NULL,
  `refmonth` int(11) NULL,
  `refqtr` int(11) NULL,
  `remittanceid` varchar(50) NOT NULL DEFAULT '',
  `remittancedate` date NULL,
  `remittanceyear` int(11) NULL,
  `remittancemonth` int(11) NULL,
  `remittanceqtr` int(11) NULL,
  `liquidationid` varchar(50) NOT NULL DEFAULT '',
  `liquidationdate` date NULL,
  `liquidationyear` int(11) NULL,
  `liquidationmonth` int(11) NULL,
  `liquidationqtr` int(11) NULL,
  PRIMARY KEY (`refid`,`refdate`,`fundid`,`acctid`,`orgid`,`remittanceid`,`liquidationid`),
  KEY `ix_refdate` (`refdate`),
  KEY `ix_refno` (`refno`),
  KEY `ix_acctid` (`acctid`),
  KEY `ix_fundid` (`fundid`),
  KEY `ix_orgid` (`orgid`),
  KEY `ix_collectorid` (`collectorid`),
  KEY `ix_refyear` (`refyear`),
  KEY `ix_refmonth` (`refmonth`),
  KEY `ix_refqtr` (`refqtr`),
  KEY `ix_remittanceid` (`remittanceid`),
  KEY `ix_remittancedate` (`remittancedate`),
  KEY `ix_remittanceyear` (`remittanceyear`),
  KEY `ix_remittancemonth` (`remittancemonth`),
  KEY `ix_remittanceqtr` (`remittanceqtr`),
  KEY `ix_liquidationid` (`liquidationid`),
  KEY `ix_liquidationdate` (`liquidationdate`),
  KEY `ix_liquidationyear` (`liquidationyear`),
  KEY `ix_liquidationmonth` (`liquidationmonth`),
  KEY `ix_liquidationqtr` (`liquidationqtr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;