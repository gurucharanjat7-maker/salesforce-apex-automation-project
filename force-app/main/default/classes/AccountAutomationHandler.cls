public with sharing class AccountAutomationHandler {
    public static void updateOpportunityStatus(Set<Id> accountIds) {
        if (accountIds.isEmpty()) {
            return;
        }

        Map<Id, Integer> totalByAccount = new Map<Id, Integer>();
        Map<Id, Integer> closedWonByAccount = new Map<Id, Integer>();

        for (AggregateResult ar : [
            SELECT AccountId accountId, COUNT(Id) totalCount
            FROM Opportunity
            WHERE AccountId IN :accountIds
            GROUP BY AccountId
        ]) {
            totalByAccount.put((Id) ar.get('accountId'), (Integer) ar.get('totalCount'));
        }

        for (AggregateResult ar : [
            SELECT AccountId accountId, COUNT(Id) wonCount
            FROM Opportunity
            WHERE AccountId IN :accountIds
            AND IsWon = true
            GROUP BY AccountId
        ]) {
            closedWonByAccount.put((Id) ar.get('accountId'), (Integer) ar.get('wonCount'));
        }

        List<Account> accountsToUpdate = new List<Account>();
        for (Id accountId : accountIds) {
            Integer total = totalByAccount.containsKey(accountId) ? totalByAccount.get(accountId) : 0;
            Integer won = closedWonByAccount.containsKey(accountId) ? closedWonByAccount.get(accountId) : 0;

            accountsToUpdate.add(new Account(
                Id = accountId,
                Opportunity_Status__c = (total > 0 && total == won) ? 'Closed Won' : 'Open'
            ));
        }

        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}
