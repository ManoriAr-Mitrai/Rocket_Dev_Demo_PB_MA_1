// Returns and credit note logic

FUNCTION CreateReturnNote(returnId, orderId)
    ret = {}
    ret.ID = returnId
    ret.ORDER_ID = orderId
    ret.ITEMS = {}
    ret.STATUS = STATUS_RETURNED
    RETURN ret
END FUNCTION

FUNCTION AddReturnItem(ret, itemType, qty, reason)
    item = {}
    item.TYPE = itemType
    item.QTY = qty
    item.REASON = reason
    APPEND ret.ITEMS, item
    RETURN ret
END FUNCTION

FUNCTION CalculateCreditAmount(ret)
    totalCredit = 0
    FOR EACH item IN ret.ITEMS
        // Flat credit logic for sample purposes
        totalCredit = totalCredit + (GetBasePrice(item.TYPE) * item.QTY)
    END
    RETURN totalCredit
END FUNCTION
