public with sharing class ContactAutomationHandler {
    public static void validateDuplicateEmails(List<Contact> newContacts) {
        Set<Id> accountIds = new Set<Id>();
        Set<String> emailKeys = new Set<String>();

        for (Contact con : newContacts) {
            if (con.AccountId != null && String.isNotBlank(con.Email)) {
                accountIds.add(con.AccountId);
                emailKeys.add(buildKey(con.AccountId, con.Email));
            }
        }

        if (accountIds.isEmpty() || emailKeys.isEmpty()) {
            return;
        }

        Map<String, Id> existingKeys = new Map<String, Id>();
        for (Contact con : [
            SELECT Id, AccountId, Email
            FROM Contact
            WHERE AccountId IN :accountIds
            AND Email != null
        ]) {
            existingKeys.put(buildKey(con.AccountId, con.Email), con.Id);
        }

        Set<String> transactionKeys = new Set<String>();
        for (Contact con : newContacts) {
            if (con.AccountId == null || String.isBlank(con.Email)) {
                continue;
            }

            String key = buildKey(con.AccountId, con.Email);
            Boolean duplicateInDatabase = existingKeys.containsKey(key)
                && existingKeys.get(key) != con.Id;
            Boolean duplicateInTransaction = !transactionKeys.add(key);

            if (duplicateInDatabase || duplicateInTransaction) {
                con.Email.addError('A Contact with the same Email already exists under this Account.');
            }
        }
    }

    public static void updateAccountContactCounts(Set<Id> accountIds) {
        if (accountIds.isEmpty()) {
            return;
        }

        Map<Id, Integer> countsByAccount = new Map<Id, Integer>();
        for (AggregateResult ar : [
            SELECT AccountId accountId, COUNT(Id) contactCount
            FROM Contact
            WHERE AccountId IN :accountIds
            GROUP BY AccountId
        ]) {
            countsByAccount.put((Id) ar.get('accountId'), (Integer) ar.get('contactCount'));
        }

        List<Account> accountsToUpdate = new List<Account>();
        for (Id accountId : accountIds) {
            accountsToUpdate.add(new Account(
                Id = accountId,
                Total_Contacts__c = countsByAccount.containsKey(accountId)
                    ? countsByAccount.get(accountId)
                    : 0
            ));
        }

        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }

    private static String buildKey(Id accountId, String email) {
        return String.valueOf(accountId) + '|' + email.trim().toLowerCase();
    }
}
