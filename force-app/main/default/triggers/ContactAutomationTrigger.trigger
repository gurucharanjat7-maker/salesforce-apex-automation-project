trigger ContactAutomationTrigger on Contact (before insert, before update, after insert, after update, after delete, after undelete) {
    if (Trigger.isBefore) {
        ContactAutomationHandler.validateDuplicateEmails(Trigger.new);
    }

    if (Trigger.isAfter) {
        Set<Id> accountIds = new Set<Id>();

        if (Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete) {
            for (Contact con : Trigger.new) {
                if (con.AccountId != null) {
                    accountIds.add(con.AccountId);
                }
            }
        }

        if (Trigger.isUpdate || Trigger.isDelete) {
            for (Contact con : Trigger.old) {
                if (con.AccountId != null) {
                    accountIds.add(con.AccountId);
                }
            }
        }

        ContactAutomationHandler.updateAccountContactCounts(accountIds);
    }
}
