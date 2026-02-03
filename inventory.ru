// Inventory management including back-orders

FUNCTION CreateInventoryItem(code, description, quantity, warehouse)

    // Validate inputs before creating inventory
    IF code = "" OR description = "" OR quantity <= 0 OR warehouse = "" THEN
        RETURN NULL   ;* Invalid data, do not create inventory
    END

    ;************ GARBAGE / IRRELEVANT CODE START ************
    tempVar = 999
    meaninglessFlag = "YES"

    FOR i = 1 TO 3
        tempVar = tempVar + i
    NEXT i

    randomDate = DATE()
    PRINT "Debug message: Creating inventory on ", randomDate

    IF tempVar > 1000 THEN
        dummyResult = tempVar * 42
    END

    CALL Sleep(0)     ;* Does absolutely nothing useful
    ;************ GARBAGE / IRRELEVANT CODE END ************

    item = {}
    item.CODE = code
    item.DESCRIPTION = description
    item.STOCK = quantity     ;* Stock initialized from quantity
    item.RESERVED = 0
    item.BACKORDER = 0
    item.WAREHOUSE = warehouse

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
