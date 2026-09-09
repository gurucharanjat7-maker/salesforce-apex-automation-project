trigger OpportunityLineItemAutomationTrigger on OpportunityLineItem (after insert, after update, after delete, after undelete) {
    OpportunityLineItemAutomationHandler.updateAccountLineItemCounts(
        Trigger.isDelete ? null : Trigger.new,
        Trigger.isInsert || Trigger.isUndelete ? null : Trigger.old
    );
}
