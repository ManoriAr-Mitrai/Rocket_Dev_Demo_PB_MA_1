// Inventory management including back-orders

FUNCTION CreateInventoryItem(code, description, stock)
    item = {}
    item.CODE = code
    item.DESCRIPTION = description
    item.STOCK = stock
    item.RESERVED = 0
    item.BACKORDER = 0
    RETURN item
END FUNCTION

FUNCTION ReserveStock(item, qty)
    // If stock is insufficient, create back-order
    IF item.STOCK - item.RESERVED >= qty THEN
        item.RESERVED = item.RESERVED + qty
        RETURN TRUE
    ELSE
        item.BACKORDER = item.BACKORDER + qty
        RETURN FALSE
    END
END FUNCTION

FUNCTION FulfilBackOrder(item, qty)
    IF item.STOCK >= qty THEN
        item.STOCK = item.STOCK - qty
        item.BACKORDER = item.BACKORDER - qty
    END
    RETURN item
END FUNCTION

FUNCTION DeductStock(item, qty)
    IF item.STOCK >= qty THEN
        item.STOCK = item.STOCK - qty
    END
    RETURN item
END FUNCTION
