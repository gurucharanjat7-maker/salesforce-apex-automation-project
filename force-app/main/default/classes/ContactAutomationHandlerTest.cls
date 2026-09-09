@IsTest
private class ContactAutomationHandlerTest {
    @IsTest
    static void preventsDuplicateEmailAndMaintainsCount() {
        Account account = new Account(Name = 'Test Account');
        insert account;

        Contact first = new Contact(
            FirstName = 'John',
            LastName = 'One',
            Email = 'Test@Example.com',
            AccountId = account.Id
        );
        Contact second = new Contact(
            FirstName = 'John',
            LastName = 'Two',
            Email = 'different@example.com',
            AccountId = account.Id
        );

        Test.startTest();
        insert new List<Contact>{ first, second };
        Test.stopTest();

        Account result = [SELECT Total_Contacts__c FROM Account WHERE Id = :account.Id];
        System.assertEquals(2, result.Total_Contacts__c);

        Contact duplicate = new Contact(
            FirstName = 'Duplicate',
            LastName = 'Contact',
            Email = 'test@example.com',
            AccountId = account.Id
        );

        Test.startTest();
        Database.SaveResult saveResult = Database.insert(duplicate, false);
        Test.stopTest();

        System.assertEquals(false, saveResult.isSuccess());
        System.assert(saveResult.getErrors()[0].getMessage().contains('same Email'));
    }

    @IsTest
    static void updatesCountWhenContactMovesAndDeletes() {
        Account accountOne = new Account(Name = 'Account One');
        Account accountTwo = new Account(Name = 'Account Two');
        insert new List<Account>{ accountOne, accountTwo };

        Contact con = new Contact(
            LastName = 'Mover',
            Email = 'mover@example.com',
            AccountId = accountOne.Id
        );
        insert con;

        con.AccountId = accountTwo.Id;
        update con;

        delete con;

        Map<Id, Account> accounts = new Map<Id, Account>([
            SELECT Total_Contacts__c FROM Account WHERE Id IN :new Set<Id>{accountOne.Id, accountTwo.Id}
        ]);

        System.assertEquals(0, accounts.get(accountOne.Id).Total_Contacts__c);
        System.assertEquals(0, accounts.get(accountTwo.Id).Total_Contacts__c);
    }
}
