use etracs255_ilocosnorte;

alter table af_control add constraint fk_af_control_afid 
  foreign key (afid) references af (objid) 
;

alter table collectiontype add constraint fk_collectiontype_fund_objid 
  foreign key (fund_objid) references fund (objid)
; 

alter table collectiontype_account 
	modify collectiontypeid varchar(50) character set utf8 not null 
;
alter table collectiontype_account add constraint fk_collectiontype_account_parentid 
  foreign key (collectiontypeid) references collectiontype (objid) 
; 

alter table collectiontype_account 
	modify account_objid varchar(50) character set utf8 not null 
;
alter table collectiontype_account add constraint fk_collectiontype_account_account_objid 
  foreign key (account_objid) references itemaccount (objid) 
; 

create index ix_parentid on entity_address (parentid)
;
create index ix_address_objid on entity (address_objid)
;
update entity e, entity_address a set a.parentid = e.objid where e.address_objid = a.objid 
;
delete from entity_address where parentid not in (select objid from entity where objid = entity_address.parentid) 
;
alter table entity_address modify parentid varchar(50) character set utf8 not null 
;
alter table entity_address add constraint fk_entity_address_parentid 
  foreign key (parentid) references entity (objid) 
; 

create index ix_entityid on entity_fingerprint (entityid)
;
alter table entity_fingerprint add constraint fk_entity_fingerprint_entityid 
  foreign key (entityid) references entity (objid) 
; 

create table z20181120_entityindividual_no_entity 
select e.* from entityindividual e 
where e.objid not in (select objid from entity where objid = e.objid) 
;
create index ix_objid on z20181120_entityindividual_no_entity (objid)
;
delete from entityindividual where objid in (select objid from z20181120_entityindividual_no_entity where objid = entityindividual.objid) 
; 
alter table entityindividual add constraint fk_entityindividual_objid 
  foreign key (objid) references entity (objid) 
; 

create table z20181120_entityjuridical_no_entity 
select e.* from entityjuridical e 
where e.objid not in (select objid from entity where objid = e.objid) 
;
create index ix_objid on z20181120_entityjuridical_no_entity (objid)
;
delete from entityjuridical where objid in (select objid from z20181120_entityjuridical_no_entity where objid = entityjuridical.objid) 
; 
alter table entityjuridical add constraint fk_entityjuridical_objid 
  foreign key (objid) references entity (objid) 
; 

alter table fund add constraint fk_fund_groupid 
  foreign key (groupid) references fundgroup (objid)
;


alter table sys_report add CONSTRAINT fk_sys_report_datasetid 
  FOREIGN KEY (datasetid) REFERENCES sys_dataset (objid)
; 
