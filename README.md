# Salesforce Apex Automation Project

A recruiter-friendly Salesforce Developer project demonstrating **Apex Triggers, Trigger Handler Pattern, SOQL, Maps/Sets, Bulkification, duplicate prevention, rollup-style automation, and Test Classes**.

## Project Objective

This project contains realistic Salesforce automation requirements commonly discussed in Salesforce Developer interviews.

### Automation 1 — Prevent Duplicate Contacts

Do not allow two Contacts under the **same Account** to have the same Email address.

- Works for insert and update.
- Bulk-safe.
- Checks existing Salesforce records and duplicate records in the same transaction.

### Automation 2 — Maintain Contact Count on Account

Maintain `Account.Total_Contacts__c` with the number of Contacts related to each Account.

- Handles insert, update, and delete.
- Uses aggregate SOQL.
- Bulk-safe.

### Automation 3 — Update Account Opportunity Status

Maintain `Account.Opportunity_Status__c` using related Opportunities:

- `Closed Won` when the Account has Opportunities and **all** of them are Closed Won.
- `Open` when at least one related Opportunity is not Closed Won.
- Accounts without Opportunities remain `Open`.

## Salesforce Components

```text
force-app/main/default/
├── classes/
│   ├── AccountAutomationHandler.cls
│   ├── AccountAutomationHandler.cls-meta.xml
│   ├── ContactAutomationHandler.cls
│   ├── ContactAutomationHandler.cls-meta.xml
│   ├── ContactAutomationTriggerTest.cls
│   ├── ContactAutomationTriggerTest.cls-meta.xml
│   ├── OpportunityAutomationTriggerTest.cls
│   └── OpportunityAutomationTriggerTest.cls-meta.xml
├── triggers/
│   ├── ContactAutomationTrigger.trigger
│   ├── ContactAutomationTrigger.trigger-meta.xml
│   ├── OpportunityAutomationTrigger.trigger
│   └── OpportunityAutomationTrigger.trigger-meta.xml
└── README.md
```

## Concepts Demonstrated

- Apex Trigger
- Trigger Handler Pattern
- Trigger Context Variables
- SOQL and Aggregate SOQL
- `Map`, `Set`, and `List`
- Bulkification
- `addError()` validation
- Insert, Update and Delete handling
- Relationship queries
- Test classes
- `Test.startTest()` / `Test.stopTest()`
- Assertions

## Required Custom Fields

Create these fields in Salesforce before deploying/running the complete project:

| Object | Field API Name | Type |
|---|---|---|
| Account | `Total_Contacts__c` | Number(18,0) |
| Account | `Opportunity_Status__c` | Text(50) or Picklist with values `Open`, `Closed Won` |

> If your org uses different API names, update the Apex code accordingly.

## Deployment

This project is structured as a Salesforce DX source directory. It can be deployed using Salesforce CLI / VS Code Salesforce Extension Pack.

```bash
sf project deploy start --source-dir force-app/main/default
```

## Interview Talking Points

**Why use a handler class?**

I keep the trigger thin and move business logic into handler classes. This improves readability, maintainability and testability.

**How is the solution bulk-safe?**

I collect IDs and email keys in Sets, perform SOQL outside loops, and use Maps to process records in memory. The design works for single records and bulk transactions.

**Why use aggregate SOQL for the Contact count?**

Aggregate SOQL lets Salesforce calculate the count at the database level, so Apex does not need to query every Contact just to count them.

## Note

This is a personal learning/project portfolio repository. It demonstrates Salesforce development skills and should not be presented as production experience with a real client.
