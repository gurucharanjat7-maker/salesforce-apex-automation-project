@IsTest
private class OpportunityAutomationHandlerTest {
    @IsTest
    static void accountIsOpenUntilAllOpportunitiesAreWon() {
        Account account = new Account(Name = 'Opportunity Test Account');
        insert account;

        Opportunity oppOne = new Opportunity(
            Name = 'Opportunity One',
            AccountId = account.Id,
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30)
        );
        Opportunity oppTwo = new Opportunity(
            Name = 'Opportunity Two',
            AccountId = account.Id,
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30)
        );

        insert new List<Opportunity>{ oppOne, oppTwo };

        Account openAccount = [SELECT Opportunity_Status__c FROM Account WHERE Id = :account.Id];
        System.assertEquals('Open', openAccount.Opportunity_Status__c);

        Test.startTest();
        oppOne.StageName = 'Closed Won';
        update oppOne;
        Test.stopTest();

        Account stillOpen = [SELECT Opportunity_Status__c FROM Account WHERE Id = :account.Id];
        System.assertEquals('Open', stillOpen.Opportunity_Status__c);

        Test.startTest();
        oppTwo.StageName = 'Closed Won';
        update oppTwo;
        Test.stopTest();

        Account closedAccount = [SELECT Opportunity_Status__c FROM Account WHERE Id = :account.Id];
        System.assertEquals('Closed Won', closedAccount.Opportunity_Status__c);
    }
}
