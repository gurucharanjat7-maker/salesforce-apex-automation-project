public with sharing class OpportunityLineItemAutomationHandler {
    public static void updateAccountLineItemCounts(List<OpportunityLineItem> newRecords, List<OpportunityLineItem> oldRecords) {
        Set<Id> opportunityIds = new Set<Id>();

        if (newRecords != null) {
            for (OpportunityLineItem oli : newRecords) {
                if (oli.OpportunityId != null) {
                    opportunityIds.add(oli.OpportunityId);
                }
            }
        }
        if (oldRecords != null) {
            for (OpportunityLineItem oli : oldRecords) {
                if (oli.OpportunityId != null) {
                    opportunityIds.add(oli.OpportunityId);
                }
            }
        }

        if (opportunityIds.isEmpty()) {
            return;
        }

        Set<Id> accountIds = new Set<Id>();
        for (Opportunity opp : [SELECT Id, AccountId FROM Opportunity WHERE Id IN :opportunityIds]) {
            if (opp.AccountId != null) {
                accountIds.add(opp.AccountId);
            }
        }

        if (accountIds.isEmpty()) {
            return;
        }

        Map<Id, Integer> countsByAccount = new Map<Id, Integer>();
        for (AggregateResult ar : [
            SELECT Opportunity.AccountId accountId, COUNT(Id) lineCount
            FROM OpportunityLineItem
            WHERE Opportunity.AccountId IN :accountIds
            GROUP BY Opportunity.AccountId
        ]) {
            countsByAccount.put((Id) ar.get('accountId'), (Integer) ar.get('lineCount'));
        }

        List<Account> accountsToUpdate = new List<Account>();
        for (Id accountId : accountIds) {
            accountsToUpdate.add(new Account(
                Id = accountId,
                Total_Opportunity_Line_Items__c = countsByAccount.containsKey(accountId)
                    ? countsByAccount.get(accountId)
                    : 0
            ));
        }

        update accountsToUpdate;
    }
}
