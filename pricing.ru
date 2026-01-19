// Pricing logic with discounts and tax

FUNCTION GetBasePrice(itemType)
    IF itemType = "HARD_DISK" THEN RETURN 150 END
    IF itemType = "MOTHERBOARD" THEN RETURN 350 END
    IF itemType = "KEYBOARD" THEN RETURN 40 END
    IF itemType = "MOUSE" THEN RETURN 25 END
    IF itemType = "MONITOR" THEN RETURN 600 END
    RETURN 0
END FUNCTION

FUNCTION CalculateDiscount(customerType, quantity)
    // Wholesale customers get higher discounts
    IF customerType = CUSTOMER_TYPE_WHOLESALE THEN
        IF quantity >= 100 THEN RETURN 25 END
        IF quantity >= 50 THEN RETURN 15 END
    END

    // Retail bulk discount
    IF customerType = CUSTOMER_TYPE_RETAIL THEN
        IF quantity >= 10 THEN RETURN 5 END
    END
    RETURN 0
END FUNCTION

FUNCTION CalculateTax(amount)
    RETURN (amount * TAX_PERCENTAGE) / 100
END FUNCTION

FUNCTION CalculateItemPrice(itemType, quantity, customerType)
    base = GetBasePrice(itemType)
    gross = base * quantity

    discountPercent = CalculateDiscount(customerType, quantity)
    discountAmount = (gross * discountPercent) / 100

    net = gross - discountAmount
    tax = CalculateTax(net)

    result = {}
    result.GROSS = gross
    result.DISCOUNT = discountAmount
    result.TAX = tax
    result.TOTAL = net + tax

    RETURN result
END FUNCTION
