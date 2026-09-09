# Salesforce Apex Automation Project

A recruiter-friendly Salesforce Developer portfolio project demonstrating **Apex Triggers, Trigger Handler Pattern, SOQL, Maps/Sets, Bulkification, duplicate prevention, rollup-style automation, and Test Classes**.

## Business Requirements

### 1. Prevent duplicate Contacts
Two Contacts under the same Account cannot have the same Email address. The validation works for insert and update and also catches duplicates created in the same transaction.

### 2. Maintain Contact count
Maintain `Account.Total_Contacts__c` with the number of Contacts related to the Account. Insert, update, delete, and undelete are handled.

### 3. Maintain Opportunity status
Maintain `Account.Opportunity_Status__c`:
- `Closed Won` when the Account has Opportunities and all are Closed Won.
- `Open` when at least one related Opportunity is not Closed Won.
- `Open` when the Account has no Opportunities.

### 4. Maintain Opportunity Line Item count
Maintain `Account.Total_Opportunity_Line_Items__c` with the number of Opportunity Line Items across all Opportunities belonging to the Account.

## Project Structure

```text
force-app/main/default/
├── classes/
│   ├── AccountAutomationHandler.cls
│   ├── AccountAutomationHandler.cls-meta.xml
│   ├── ContactAutomationHandler.cls
│   ├── ContactAutomationHandler.cls-meta.xml
│   ├── ContactAutomationHandlerTest.cls
│   ├── ContactAutomationHandlerTest.cls-meta.xml
│   ├── OpportunityAutomationHandlerTest.cls
│   ├── OpportunityAutomationHandlerTest.cls-meta.xml
│   ├── OpportunityLineItemAutomationHandler.cls
│   └── OpportunityLineItemAutomationHandler.cls-meta.xml
├── objects/Account/fields/
│   ├── Total_Contacts__c.field-meta.xml
│   ├── Opportunity_Status__c.field-meta.xml
│   └── Total_Opportunity_Line_Items__c.field-meta.xml
└── triggers/
    ├── ContactAutomationTrigger.trigger
    ├── ContactAutomationTrigger.trigger-meta.xml
    ├── OpportunityAutomationTrigger.trigger
    ├── OpportunityAutomationTrigger.trigger-meta.xml
    ├── OpportunityLineItemAutomationTrigger.trigger
    └── OpportunityLineItemAutomationTrigger.trigger-meta.xml
```

## Salesforce Concepts Demonstrated

- Apex Trigger and Trigger Context Variables
- Trigger Handler Pattern
- `Map`, `Set`, and `List`
- SOQL and Aggregate SOQL
- Relationship queries
- Bulkification and governor-limit awareness
- `addError()` validation
- Insert, update, delete, and undelete handling
- Test classes and assertions
- `Test.startTest()` / `Test.stopTest()`

## Custom Account Fields

| Field API Name | Type | Purpose |
|---|---|---|
| `Total_Contacts__c` | Number | Contact count |
| `Opportunity_Status__c` | Picklist | Open / Closed Won |
| `Total_Opportunity_Line_Items__c` | Number | Opportunity Line Item count |

The field metadata is included in this repository, so the project can be deployed as Salesforce DX source instead of manually creating these fields.

## Deployment

Authenticate to your Salesforce Developer Edition, sandbox, or other authorized org and deploy the source:

```bash
sf project deploy start --source-dir force-app/main/default
```

Run Apex tests from Salesforce Setup, VS Code, or Salesforce CLI after deployment.

## Interview Explanation

> "I created a Salesforce Apex automation project using a trigger-handler architecture. I kept the triggers thin and moved business logic into handler classes. The project prevents duplicate Contacts based on Account and Email, maintains Contact and Opportunity Line Item counts on Account, and automatically changes Account Opportunity Status depending on whether all related Opportunities are Closed Won. I used Sets and Maps to collect IDs and Aggregate SOQL to avoid queries inside loops, making the solution bulk-safe and governor-limit friendly."

## What Problem Did I Solve?

A common problem with beginner Apex code is putting SOQL or DML inside loops. That approach can fail when Salesforce processes many records in one transaction. In this project, IDs are collected first, data is queried in bulk, and records are updated using Lists. This makes the automation suitable for bulk operations such as data loads.

## Portfolio Note

This is a personal learning/portfolio project. It demonstrates Salesforce development skills and should not be presented as production experience with a real client.
