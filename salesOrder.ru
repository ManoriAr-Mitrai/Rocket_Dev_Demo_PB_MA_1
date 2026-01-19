// Sales order lifecycle with partial delivery

FUNCTION CreateSalesOrder(id, customer, customerType)
    order = {}
    order.ID = id
    order.CUSTOMER = customer
    order.TYPE = customerType
    order.ITEMS = {}
    order.TOTAL = 0
    order.STATUS = STATUS_ORDER_ENTERED
    RETURN order
END FUNCTION

FUNCTION AddOrderItem(order, itemType, qty)
    price = CalculateItemPrice(itemType, qty, order.TYPE)

    item = {}
    item.TYPE = itemType
    item.QTY = qty
    item.DELIVERED = 0   // Used for partial delivery
    item.TOTAL = price.TOTAL

    APPEND order.ITEMS, item
    order.TOTAL = order.TOTAL + price.TOTAL
    RETURN order
END FUNCTION

FUNCTION DeliverPartial(order, itemIndex, deliveredQty)
    // Supports partial delivery scenarios
    order.ITEMS[itemIndex].DELIVERED =
        order.ITEMS[itemIndex].DELIVERED + deliveredQty
    RETURN order
END FUNCTION
