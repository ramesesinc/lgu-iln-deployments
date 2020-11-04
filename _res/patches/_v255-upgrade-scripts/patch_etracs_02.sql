use etracs255_ilocosnorte;

rename table af_inventory_return to z20181120_af_inventory_return ; 
rename table af_inventory_detail_cancelseries to z20181120_af_inventory_detail_cancelseries ; 
rename table af_inventory_detail to z20181120_af_inventory_detail ; 
rename table af_inventory to z20181120_af_inventory ; 


rename table ap_detail to z20181120_ap_detail ; 
rename table ap to z20181120_ap ; 
rename table ar_detail to z20181120_ar_detail ; 
rename table ar to z20181120_ar ; 


rename table bankaccount_entry to z20181120_bankaccount_entry ; 
rename table bankaccount_account to z20181120_bankaccount_account ; 


rename table bankdeposit_liquidation to z20181120_bankdeposit_liquidation ; 
rename table bankdeposit_entry_check to z20181120_bankdeposit_entry_check ; 
rename table bankdeposit_entry to z20181120_bankdeposit_entry ; 
rename table bankdeposit to z20181120_bankdeposit ; 


rename table cashbook_entry to z20181120_cashbook_entry ; 
rename table cashbook to z20181120_cashbook ; 


rename table directcash_collection_item to z20181120_directcash_collection_item ; 
rename table directcash_collection to z20181120_directcash_collection ; 


rename table liquidation_remittance to z20181120_liquidation_remittance ; 
rename table liquidation_noncashpayment to z20181120_liquidation_noncashpayment ; 
rename table liquidation_creditmemopayment to z20181120_liquidation_creditmemopayment ; 
rename table liquidation_cashier_fund to z20181120_liquidation_cashier_fund ; 
rename table liquidation to z20181120_liquidation ; 


rename table ngas_revenue_deposit to z20181120_ngas_revenue_deposit ; 
rename table ngas_revenue_remittance to z20181120_ngas_revenue_remittance ; 
rename table ngas_revenueitem to z20181120_ngas_revenueitem ; 
rename table ngas_revenue to z20181120_ngas_revenue ; 


rename table remittance_noncashpayment to z20181120_remittance_noncashpayment ; 
rename table remittance_creditmemopayment to z20181120_remittance_creditmemopayment ; 
rename table remittance_cashreceipt to z20181120_remittance_cashreceipt ; 


rename table stockissueitem to z20181120_stockissueitem ; 
rename table stockissue to z20181120_stockissue ; 

rename table stockreceiptitem to z20181120_stockreceiptitem ; 
rename table stockreceipt to z20181120_stockreceipt ; 

rename table stocksaleitem to z20181120_stocksaleitem ; 
rename table stocksale to z20181120_stocksale ; 

rename table stockrequestitem to z20181120_stockrequestitem ; 
rename table stockrequest to z20181120_stockrequest ; 

rename table stockreturn to z20181120_stockreturn ; 

rename table stockitem_unit to z20181120_stockitem_unit ; 
rename table stockitem to z20181120_stockitem ; 

rename table eor_paymentorder to z20181120_eor_paymentorder;
rename table payment_partner to z20181120_payment_partner; 

drop table if exists draft_remittance_cashreceipt; 
drop table if exists draft_remittance; 

rename table cashreceiptpayment_eor to z20181120_cashreceiptpayment_eor;

rename table account to z20181120_account;
rename table account_incometarget to z20181120_account_incometarget;
