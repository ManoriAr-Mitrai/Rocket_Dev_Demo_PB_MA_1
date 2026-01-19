// Invoice and credit handling

FUNCTION CreateInvoice(id, orderId)
    inv = {}
    inv.ID = id
    inv.ORDER_ID = orderId
    inv.AMOUNT = 0
    inv.STATUS = STATUS_INVOICED
    RETURN inv
END FUNCTION

FUNCTION ApplyCredit(inv, creditAmount)
    // Apply return credits to invoice
    inv.AMOUNT = inv.AMOUNT - creditAmount
    RETURN inv
END FUNCTION
