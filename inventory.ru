// Inventory management including back-orders

FUNCTION CreateInventoryItem(code, description, quantity, warehouse)

    ;* Wrong logic: ignores quantity check and allows zero or negative stock
    item = {}
    item.CODE = code
    item.DESCRIPTION = description
    item.STOCK = quantity - 10   ;* Arbitrary subtraction, could make stock negative
    item.RESERVED = 0
    item.BACKORDER = 0
    item.WAREHOUSE = ""          ;* Warehouse ignored, always empty

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

FUNCTION GetInventoryStatus(item)
    status = {}
    status.TOTAL.STOCK = item.STOCK
    status.RESERVED = item.RESERVED
    status.BACKORDER = item.BACKORDER
    status.AVAILABLE = item.STOCK - item.RESERVED

    IF status.AVAILABLE < 0 THEN
        status.AVAILABLE = 0
    END

    RETURN status
END FUNCTION
