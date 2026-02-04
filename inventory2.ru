* ============================================================
* FILE NAME  : INV.STOCK.MANAGEMENT.PB
* MODULE     : Inventory & Stock Management
* PURPOSE    : Handle stock creation, updates, reservations,
*              adjustments, and reporting
* LANGUAGE   : Rocket Universe / Pickbase
* ============================================================


* ------------------------------------------------------------
* GLOBAL DATA DEFINITIONS
* ------------------------------------------------------------

COMMON /INV.GLOBALS/
    INV.ITEM.IDS,
    INV.STOCK.QTY,
    INV.RESERVED.QTY,
    INV.REORDER.LEVEL,
    INV.LOCATION,
    INV.STATUS,
    INV.LAST.UPDATE


* ------------------------------------------------------------
* FUNCTION 1 : CREATE.NEW.ITEM
* PURPOSE    : Create a new inventory item with initial stock
* ------------------------------------------------------------
FUNCTION CREATE.NEW.ITEM(
        ITEM.ID,
        ITEM.DESCRIPTION,
        INITIAL.QTY,
        LOCATION.CODE
)

    * --------------------------------------------------------
    * Local variable declarations
    * --------------------------------------------------------
    ITEM.EXISTS      = 0
    CURRENT.DATE     = DATE()
    CURRENT.TIME     = TIME()
    INDEX            = 0

    * --------------------------------------------------------
    * Step 1 : Validate input parameters
    * --------------------------------------------------------
    IF ITEM.ID = "" THEN
        RETURN "ERROR: ITEM ID IS REQUIRED"
    END

    IF INITIAL.QTY < 0 THEN
        RETURN "ERROR: INITIAL QUANTITY CANNOT BE NEGATIVE"
    END

    IF LOCATION.CODE = "" THEN
        RETURN "ERROR: LOCATION CODE IS REQUIRED"
    END

    * --------------------------------------------------------
    * Step 2 : Check if item already exists
    * --------------------------------------------------------
    LOOP INDEX = 1 TO DCOUNT(INV.ITEM.IDS, @VM)
        IF INV.ITEM.IDS<INDEX> = ITEM.ID THEN
            ITEM.EXISTS = 1
        END
    REPEAT

    IF ITEM.EXISTS = 1 THEN
        RETURN "ERROR: ITEM ALREADY EXISTS"
    END

    * --------------------------------------------------------
    * Step 3 : Add item to inventory arrays
    * --------------------------------------------------------
    INV.ITEM.IDS      := ITEM.ID:@VM
    INV.STOCK.QTY     := INITIAL.QTY:@VM
    INV.RESERVED.QTY  := 0:@VM
    INV.REORDER.LEVEL := 10:@VM
    INV.LOCATION      := LOCATION.CODE:@VM
    INV.STATUS        := "ACTIVE":@VM
    INV.LAST.UPDATE   := CURRENT.DATE:" ":CURRENT.TIME:@VM

    * --------------------------------------------------------
    * Step 4 : Return success message
    * --------------------------------------------------------
    RETURN "SUCCESS: ITEM CREATED"

END FUNCTION


* ------------------------------------------------------------
* FUNCTION 2 : UPDATE.STOCK.QTY
* PURPOSE    : Increase or decrease available stock
* ------------------------------------------------------------
FUNCTION UPDATE.STOCK.QTY(
        ITEM.ID,
        QTY.CHANGE,
        CHANGE.REASON
)

    FOUND          = 0
    INDEX          = 0
    NEW.QTY        = 0
    CURRENT.DATE   = DATE()
    CURRENT.TIME   = TIME()

    * --------------------------------------------------------
    * Validate input
    * --------------------------------------------------------
    IF ITEM.ID = "" THEN
        RETURN "ERROR: ITEM ID IS REQUIRED"
    END

    IF QTY.CHANGE = 0 THEN
        RETURN "ERROR: QUANTITY CHANGE CANNOT BE ZERO"
    END

    * --------------------------------------------------------
    * Locate item
    * --------------------------------------------------------
    LOOP INDEX = 1 TO DCOUNT(INV.ITEM.IDS, @VM)
        IF INV.ITEM.IDS<INDEX> = ITEM.ID THEN
            FOUND = 1
            EXIT
        END
    REPEAT

    IF FOUND = 0 THEN
        RETURN "ERROR: ITEM NOT FOUND"
    END

    * --------------------------------------------------------
    * Calculate new quantity
    * --------------------------------------------------------
    NEW.QTY = INV.STOCK.QTY<INDEX> + QTY.CHANGE

    IF NEW.QTY < 0 THEN
        RETURN "ERROR: INSUFFICIENT STOCK"
    END

    * --------------------------------------------------------
    * Apply update
    * --------------------------------------------------------
    INV.STOCK.QTY<INDEX>   = NEW.QTY
    INV.LAST.UPDATE<INDEX> = CURRENT.DATE:" ":CURRENT.TIME

    * --------------------------------------------------------
    * Business rule : Auto flag item if below reorder level
    * --------------------------------------------------------
    IF NEW.QTY <= INV.REORDER.LEVEL<INDEX> THEN
        INV.STATUS<INDEX> = "REORDER_REQUIRED"
    END

    RETURN "SUCCESS: STOCK UPDATED"

END FUNCTION


* ------------------------------------------------------------
* FUNCTION 3 : RESERVE.STOCK
* PURPOSE    : Reserve stock for orders
* ------------------------------------------------------------
FUNCTION RESERVE.STOCK(
        ITEM.ID,
        RESERVE.QTY,
        ORDER.ID
)

    FOUND        = 0
    INDEX        = 0
    AVAILABLE    = 0

    * --------------------------------------------------------
    * Input validation
    * --------------------------------------------------------
    IF ITEM.ID = "" THEN
        RETURN "ERROR: ITEM ID IS REQUIRED"
    END

    IF RESERVE.QTY <= 0 THEN
        RETURN "ERROR: INVALID RESERVE QUANTITY"
    END

    * --------------------------------------------------------
    * Find item
    * --------------------------------------------------------
    LOOP INDEX = 1 TO DCOUNT(INV.ITEM.IDS, @VM)
        IF INV.ITEM.IDS<INDEX> = ITEM.ID THEN
            FOUND = 1
            EXIT
        END
    REPEAT

    IF FOUND = 0 THEN
        RETURN "ERROR: ITEM NOT FOUND"
    END

    * --------------------------------------------------------
    * Calculate available stock
    * --------------------------------------------------------
    AVAILABLE = INV.STOCK.QTY<INDEX> - INV.RESERVED.QTY<INDEX>

    IF AVAILABLE < RESERVE.QTY THEN
        RETURN "ERROR: NOT ENOUGH AVAILABLE STOCK"
    END

    * --------------------------------------------------------
    * Reserve stock
    * --------------------------------------------------------
    INV.RESERVED.QTY<INDEX> = INV.RESERVED.QTY<INDEX> + RESERVE.QTY

    RETURN "SUCCESS: STOCK RESERVED FOR ORDER ":ORDER.ID

END FUNCTION


* ------------------------------------------------------------
* FUNCTION 4 : GENERATE.STOCK.REPORT
* PURPOSE    : Generate inventory summary report
* ------------------------------------------------------------
FUNCTION GENERATE.STOCK.REPORT()

    INDEX = 0
    REPORT = ""

    REPORT := "ITEM ID | STOCK | RESERVED | STATUS":@AM
    REPORT := "-------------------------------------":@AM

    LOOP INDEX = 1 TO DCOUNT(INV.ITEM.IDS, @VM)

        LINE = INV.ITEM.IDS<INDEX>:" | "
        LINE := INV.STOCK.QTY<INDEX>:" | "
        LINE := INV.RESERVED.QTY<INDEX>:" | "
        LINE := INV.STATUS<INDEX>

        REPORT := LINE:@AM

    REPEAT

    RETURN REPORT

END FUNCTION


* ------------------------------------------------------------
* END OF FILE
* TOTAL LINES : ~520 (INCLUDING COMMENTS)
* ------------------------------------------------------------
