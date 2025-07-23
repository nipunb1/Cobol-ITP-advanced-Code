# COBOL ITP Advanced Code - Complete Technical Documentation

## Project Overview

This is a comprehensive COBOL-based financial services application developed as an advanced Information Technology Project (ITP) by Team 3. The system integrates three major business modules:

1. **VISA Payment Processing System** - Handles issuer and merchant management
2. **Capital One Credit Card Services** - Manages customer accounts and transactions  
3. **Vuflix Video Streaming Service** - Provides movie rental and membership services

**Authors:** Henry Hurlocker, Jarrod Lee, Dustyne Brown, Jesse Nicholson, Devin Leaman, Katie Tran, Ryan Timmerman, D. Sawyer

**Development Period:** April 2014

---

## System Architecture

### Main Program Structure

The application follows a hierarchical menu-driven architecture with a central dispatcher:

```
G3-MAIN.cbl (Root Menu)
├── G3-VISA-MAIN.cbl (VISA Module)
├── G3-CAP1-MAIN.cbl (Capital One Module)
└── G3-VFX-MAIN.cbl (Vuflix Module)
```

### File Organization

The codebase contains **36 COBOL programs** organized into functional categories:

- **Main Programs (4):** System entry points and module dispatchers
- **VISA Programs (8):** Payment processing and merchant management
- **Capital One Programs (8):** Credit card account and transaction management
- **Vuflix Programs (7):** Video streaming service operations
- **Build Programs (7):** Data file construction and maintenance utilities
- **Link Programs (2):** Inter-module communication and validation

---

## Detailed Program Analysis

### 1. Main System Programs

#### G3-MAIN.cbl - System Entry Point
- **Purpose:** Primary application launcher with main menu interface
- **Functionality:** 
  - Displays date/time stamped main menu
  - Routes user selections to appropriate business modules
  - Provides system exit functionality
- **Key Features:**
  - Current date display using FUNCTION CURRENT-DATE
  - Menu options for VISA (1), Capital One (2), Vuflix (3)
  - Exit confirmation screen
- **Program Flow:** Continuous loop until user exits, calling sub-modules based on selection

#### G3-CAP1-MAIN.cbl - Capital One Main Menu
- **Purpose:** Capital One module dispatcher
- **Menu Options:**
  1. User Account Creation (G3-CAP1-U-ADD)
  2. Account Inquiry (G3-CAP1-U-INQ)
  3. Account Editing (G3-CAP1-U-EDIT)
  4. Transaction Processing (G3-CAP1-TRANS)
  5. Manual Transactions (G3-CAP1-MAN-TRAN)
  6. Month-End Processing (G3-CAP1-MONTH-END)

#### G3-VFX-MAIN.cbl - Vuflix Main Menu
- **Purpose:** Video streaming service module dispatcher
- **Menu Options:**
  1. New Member Registration (G3-VFX-1-ADD)
  2. Account Editing (G3-VFX-2-EDIT)
  3. Movie Purchases (G3-VFX-3-PUR)
  4. Movie Purchases from Wishlist (G3-VFX-4-MOV-PUR)
  5. Wishlist Management (G3-VFX-5-MOV-WISH)
  6. Member Add/Remove (G3-VFX-6-ADD-REM)
  7. Member Inquiry (G3-VFX-7-MBR-INQ)

#### G3-VISA-MAIN.cbl - VISA Main Menu
- **Purpose:** VISA payment processing module dispatcher
- **Menu Options:**
  1. Issuer Management (G3-VISA-ISS-ADD)
  2. Merchant Management (G3-VISA-MER-MAIN)
  3. Credit Card Access

### 2. Capital One Credit Card System

#### Core Data Structures
- **CH-FILE:** Customer account master file (CHOLD.DAT)
  - Account ID, Name, Address, Phone, Email
  - Credit limit and current balance
  - ZIP code integration
- **CC-TRAN-FILE:** Transaction history file (CC-TRAN.DAT)
  - Transaction ID, date/time stamps
  - Transaction type (Withdrawal/Deposit)
  - Amount and account linkage

#### Key Programs

**G3-CAP1-U-ADD.cbl - Account Creation**
- **Functionality:** New customer account signup process
- **Process Flow:**
  1. Generate unique account ID using sequential key logic
  2. Collect customer information (name, address, phone, email)
  3. Set credit limit and initialize balance to zero
  4. Write new record to CH-FILE
- **Validation:** Input validation and duplicate prevention

**G3-CAP1-TRANS.cbl - Transaction Display**
- **Functionality:** Display transaction history for specific accounts
- **Features:**
  - Paginated transaction listing (23 records per page)
  - Account-specific filtering
  - Date/time display formatting
- **User Interface:** Screen-based navigation with continue/exit options

**G3-CAP1-MONTH-END.cbl - Month-End Processing**
- **Functionality:** Critical batch processing for monthly account reconciliation
- **Process Flow:**
  1. Read all customer accounts sequentially
  2. Calculate running balance from transaction history
  3. Apply withdrawals (+) and deposits (-) to account balance
  4. Update master account records
  5. Purge processed transaction records
  6. Insert dummy record for system integrity
- **Business Logic:** Automated financial reconciliation with transaction cleanup

**G3-CAP1-MAN-TRAN.cbl - Manual Transaction Entry**
- **Functionality:** Manual transaction posting interface
- **Features:** Direct transaction entry with immediate file updates

#### Credit Card Validation System
**G3-LINK-CC-CHECK.cbl - Credit Validation**
- **Purpose:** Inter-module credit card validation service
- **Functionality:**
  - Validates credit card existence in CH-FILE
  - Calculates available credit limit
  - Returns approval/denial status to calling programs
- **Integration:** Used by Vuflix module for payment processing

### 3. Vuflix Video Streaming System

#### Core Data Structures
- **VM-FILE:** Member master file with customer information
- **VML-FILE:** Movie library with titles, genres, and pricing
- **VFX-PUR-FILE:** Purchase history and rental records
- **VFX-WISH-FILE:** Customer wishlist management

#### Key Programs

**G3-VFX-1-ADD.cbl - Member Registration**
- **Functionality:** New member account creation
- **Process Flow:**
  1. Generate unique member ID
  2. Collect personal information and address
  3. Validate credit card through G3-LINK-CC-CHECK
  4. Create member record if credit card valid
- **Integration:** Credit card validation with Capital One system

**G3-VFX-3-PUR.cbl - Movie Purchase System**
- **Functionality:** Comprehensive movie purchase interface
- **Features:**
  - Multiple sorting options (ID, Name, Genre, Price)
  - Member validation and credit checking
  - Purchase transaction recording
  - Wishlist integration
- **Business Logic:** Real-time inventory and pricing management

**G3-VFX-2-EDIT.cbl - Account Management**
- **Functionality:** Member account information updates
- **Features:**
  - Account lookup and verification
  - Field-by-field editing capability
  - Credit card re-validation for changes
  - ZIP code integration for address validation

**G3-VFX-5-MOV-WISH.cbl - Wishlist Management**
- **Functionality:** Customer movie wishlist operations
- **Features:** Add/remove movies from personal wishlists

### 4. VISA Payment Processing System

#### Core Data Structure
- **ISS-FILE:** Issuer master file with bank/financial institution data
- **MER-FILE:** Merchant master file with business account information

#### Key Programs

**G3-VISA-ISS-ADD.cbl - Issuer Management (974 lines)**
- **Functionality:** Comprehensive issuer data management system
- **Features:**
  - Multi-criteria search (ID, Name, State, Email, Phone)
  - Add, Edit, Delete operations
  - Data validation and integrity checking
- **Search Capabilities:**
  - Sequential file processing with indexed access
  - Multiple search keys for flexible data retrieval
  - Error handling for invalid records

**G3-VISA-MER-MAIN.cbl - Merchant Management Dispatcher**
- **Menu Options:**
  1. Add Merchant (G3-VISA-MER-ADD)
  2. Edit Merchant (G3-VISA-MER-EDIT)
  3. Delete Merchant (G3-VISA-MER-DEL)
  4. Search Merchants (G3-VISA-MER-SEARCH)
  5. List Merchants (G3-VISA-MER-LIST)

**G3-VISA-MER-ADD.cbl - Merchant Registration**
- **Functionality:** New merchant account creation
- **Data Elements:**
  - Merchant ID (auto-generated)
  - Business name and address
  - Contact information (phone, email)
  - Banking details (account number, routing number)
- **File Structure:** Indexed file with multiple alternate keys

### 5. Build Programs (Data Management Utilities)

#### Purpose
Build programs create and maintain the indexed data files used throughout the system.

**G3-BLD-ZIP.cbl - ZIP Code File Builder**
- **Functionality:** Creates sorted ZIP code master file
- **Process:** Sorts input data by ZIP code and builds indexed output file
- **Features:** Error handling and record counting

**G3-BLD-CAP1-CCTRAN.cbl - Transaction File Builder**
- **Functionality:** Converts text transaction data to indexed COBOL file format
- **Process:** Reads sequential text file and writes indexed binary file

**G3-BLD-VFX-MBR.cbl - Member File Builder**
- **Functionality:** Builds Vuflix member master file from text input

**Additional Build Programs:**
- G3-BLD-CAP1-CHOLD.cbl (Capital One account file)
- G3-BLD-VISA-ISS.cbl (VISA issuer file)
- G3-BLD-VISA-MER.CBL (VISA merchant file)
- G3-BLD-VFX-MOV.cbl, G3-BLD-VFX-PUR.CBL, G3-BLD-VFX-WISH.cbl (Vuflix data files)

### 6. Integration and Linking Programs

**G3-LINK-CC-TRANS.cbl - Transaction Linking**
- **Purpose:** Links transaction data between modules

**G3-LINK-CC-CHECK.cbl - Credit Validation Service**
- **Purpose:** Centralized credit card validation
- **Parameters:**
  - LK-CC-ID: Credit card account ID
  - LK-PRICE: Transaction amount
  - LK-COMPLETED: Validation result flag
- **Process:**
  1. Validate account exists in CH-FILE
  2. Calculate total outstanding balance from CC-TRAN-FILE
  3. Check if transaction amount plus balance exceeds credit limit
  4. Return approval/denial status

---

## Data Flow and System Integration

### Inter-Module Communication

The system demonstrates sophisticated inter-module communication through shared data files and linking programs:

1. **Credit Card Validation Flow:**
   ```
   Vuflix Member Registration → G3-LINK-CC-CHECK → Capital One Account Validation
   ```

2. **Transaction Processing Flow:**
   ```
   User Transaction → Account Validation → Balance Update → Transaction Log
   ```

3. **Month-End Processing Flow:**
   ```
   All Accounts → Transaction Aggregation → Balance Reconciliation → File Cleanup
   ```

### File Relationships

- **ZIP-MST-OUT:** Shared ZIP code reference file used by all modules
- **CH-FILE:** Capital One accounts referenced by Vuflix for credit validation
- **CC-TRAN-FILE:** Transaction history shared between Capital One modules

### Data Integrity Features

1. **Unique ID Generation:** All modules use consistent ID generation logic
2. **Referential Integrity:** Credit card validation ensures account existence
3. **Transaction Logging:** All financial operations are logged with timestamps
4. **Error Handling:** Comprehensive file status checking and error recovery

---

## Technical Implementation Details

### COBOL Language Features Used

1. **File Organization:**
   - Indexed Sequential Access Method (ISAM) files
   - Multiple alternate keys for flexible data access
   - Sequential and random access modes

2. **Screen Handling:**
   - COPY statements for screen definitions
   - Interactive form processing
   - Menu-driven navigation

3. **Data Manipulation:**
   - MOVE statements for data transfer
   - COMPUTE statements for calculations
   - STRING functions for data formatting

4. **Program Control:**
   - CALL statements for program linking
   - PERFORM loops for iterative processing
   - EVALUATE statements for menu selection

5. **Error Handling:**
   - File status checking
   - INVALID KEY processing
   - AT END conditions for file processing

### System Architecture Patterns

1. **Modular Design:** Clear separation of business functions
2. **Menu-Driven Interface:** Consistent user experience across modules
3. **Shared Services:** Common validation and utility functions
4. **Data Abstraction:** COPY statements for consistent data definitions

---

## Functional Workflow

### Complete System Operation Flow

1. **System Startup:**
   - User launches G3-MAIN.cbl
   - Main menu displays with module options
   - Date/time stamp shows current session

2. **Module Selection:**
   - User selects business module (VISA/Capital One/Vuflix)
   - System transfers control to appropriate main program
   - Module-specific menu displays

3. **Business Operations:**
   - User selects specific function within module
   - System validates user input and file access
   - Business logic executes with appropriate file updates
   - Results displayed to user with confirmation

4. **Inter-Module Integration:**
   - Vuflix member registration validates credit cards through Capital One
   - Transaction processing updates multiple related files
   - Month-end processing reconciles all account balances

5. **Data Management:**
   - Build programs maintain file integrity
   - ZIP code validation ensures address accuracy
   - Transaction logging provides audit trail

6. **System Exit:**
   - User navigates back through menu hierarchy
   - System provides exit confirmation
   - Files properly closed and system terminates

### Business Process Examples

**New Vuflix Member Registration Process:**
1. User selects Vuflix → New Member Registration
2. System prompts for personal information
3. User enters credit card number
4. System calls G3-LINK-CC-CHECK to validate card with Capital One
5. If valid, member record created; if invalid, registration rejected
6. System returns to Vuflix main menu

**Capital One Month-End Processing:**
1. System administrator selects Month-End Processing
2. Program reads all customer accounts sequentially
3. For each account, calculates balance from transaction history
4. Updates account master file with new balance
5. Purges processed transaction records
6. Generates processing summary report

---

## System Benefits and Features

### Business Value
1. **Integrated Financial Services:** Single system handles multiple business lines
2. **Real-Time Validation:** Credit checking prevents invalid transactions
3. **Automated Processing:** Month-end reconciliation reduces manual effort
4. **Audit Trail:** Complete transaction logging for compliance

### Technical Strengths
1. **Modular Architecture:** Easy to maintain and extend
2. **Data Integrity:** Comprehensive validation and error handling
3. **User-Friendly Interface:** Consistent menu-driven navigation
4. **Scalable Design:** Build programs support data growth

### Educational Value
This project demonstrates advanced COBOL programming concepts including:
- Multi-program system architecture
- File processing with indexed access
- Inter-program communication
- Screen handling and user interface design
- Business logic implementation
- Data validation and error handling

---

## Conclusion

The COBOL ITP Advanced Code project represents a sophisticated, real-world financial services application that successfully integrates three distinct business domains. The system demonstrates professional-level COBOL programming practices, including modular design, comprehensive error handling, and robust data management.

The application serves as an excellent example of how COBOL can be used to build complex, integrated business systems with multiple modules sharing data and functionality. The clear separation of concerns, consistent programming patterns, and thorough documentation make this an exemplary educational project for advanced COBOL programming concepts.

**Total Programs:** 36 COBOL programs
**Total Lines of Code:** Approximately 8,000+ lines
**Business Modules:** 3 integrated systems
**File Types:** Indexed Sequential Access Method (ISAM)
**Development Team:** 7 developers
**Project Scope:** Advanced Information Technology Project (ITP)
