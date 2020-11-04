
insert into sys_usergroup (
	objid, title, domain, role, userclass
) values (
	'TREASURY.LIQ_OFFICER_ADMIN', 'TREASURY LIQ. OFFICER ADMIN', 
	'TREASURY', 'LIQ_OFFICER_ADMIN', 'usergroup' 
); 

insert into sys_usergroup_permission (
	objid, usergroup_objid, object, permission, title 
) values ( 
	'UGP-d2bb69a6769517e0c8e672fec41f5fd7', 'TREASURY.LIQ_OFFICER_ADMIN', 
	'collectionvoucher', 'changeLiqOfficer', 'Change Liquidating Officer'
); 

insert into sys_usergroup_permission (
	objid, usergroup_objid, object, permission, title 
) values ( 
	'UGP-3219ec222220f68d1f69d4d1d76021e0', 'TREASURY.LIQ_OFFICER_ADMIN', 
	'collectionvoucher', 'modifyCashBreakdown', 'Modify Cash Breakdown'
); 

insert into sys_usergroup_permission (
	objid, usergroup_objid, object, permission, title 
) values ( 
	'UGP-4e508bdd04888894926f677bbc0be374', 'TREASURY.LIQ_OFFICER_ADMIN', 
	'collectionvoucher', 'rebuildFund', 'Rebuild Fund Summary'
); 

insert into sys_usergroup_permission (
	objid, usergroup_objid, object, permission, title 
) values ( 
	'UGP-cf543fabc2aca483c6e5d3d48c39c4cc', 'TREASURY.LIQ_OFFICER_ADMIN', 
	'incomesummary', 'rebuild', 'Rebuild Income Summary'
); 


INSERT INTO `sys_usergroup` (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) 
VALUES ('RULEMGMT.DEV', 'RULEMGMT DEV', 'RULEMGMT', NULL, NULL, 'DEV');

INSERT INTO `sys_usergroup` (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) 
VALUES ('WORKFLOW.DEV', 'WORKFLOW DEV', 'WORKFLOW', NULL, NULL, 'DEV');

update sys_usergroup_member set usergroup_objid='RULEMGMT.DEV' where usergroup_objid = 'RULEMGMT.MASTER'; 
update sys_usergroup_member set usergroup_objid='WORKFLOW.DEV' where usergroup_objid = 'WORKFLOW.MASTER'; 


insert into sys_usergroup_member (
	objid, usergroup_objid, user_objid, user_username, user_firstname, user_lastname, jobtitle 
) 
select 
	concat('UGM-',MD5(CONCAT(u.objid, ug.objid))) as objid, ug.objid as usergroup_objid, 
	u.objid as user_objid, u.username as user_username, u.firstname as user_firstname, 
	u.lastname as user_lastname, u.jobtitle 
from sys_user u, sys_usergroup ug  
where u.username='admin'
	and ug.domain = 'TREASURY' 
	and ug.role in ('AFO_ADMIN','COLLECTOR_ADMIN','LIQ_OFFICER_ADMIN') 
;
