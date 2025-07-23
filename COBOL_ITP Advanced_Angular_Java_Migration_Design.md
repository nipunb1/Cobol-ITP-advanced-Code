# COBOL to Angular + Java Migration - Technical Design Document

## Executive Summary

This document outlines the comprehensive technical design for migrating the existing COBOL mainframe financial services application to a modern Angular + Java web application stack. The migration will transform 36 COBOL programs across three business modules (VISA, Capital One, Vuflix) into a scalable, maintainable web-based system while preserving all existing functionality and addressing mainframe-level performance requirements.

**Migration Scope:**
- **Source System:** 36 COBOL programs (~8,000+ lines of code)
- **Target Architecture:** Angular 17+ frontend with Java Spring Boot backend
- **Business Modules:** VISA Payment Processing, Capital One Credit Services, Vuflix Streaming
- **Data Migration:** COBOL indexed files to PostgreSQL database
- **Performance Target:** Handle mainframe-scale data volumes with sub-second response times

---

## Current System Analysis

### Existing COBOL Architecture
```
Mainframe COBOL System
├── G3-MAIN.cbl (System Entry Point)
├── VISA Module (8 programs)
│   ├── G3-VISA-MAIN.cbl (Menu Dispatcher)
│   ├── G3-VISA-ISS-ADD.cbl (Issuer Management - 974 lines)
│   ├── G3-VISA-MER-*.cbl (Merchant Operations)
│   └── Build Programs
├── Capital One Module (8 programs)
│   ├── G3-CAP1-MAIN.cbl (Menu Dispatcher)
│   ├── G3-CAP1-U-*.cbl (User Management)
│   ├── G3-CAP1-TRANS.cbl (Transaction Processing)
│   ├── G3-CAP1-MONTH-END.cbl (Batch Processing)
│   └── Build Programs
├── Vuflix Module (7 programs)
│   ├── G3-VFX-MAIN.cbl (Menu Dispatcher)
│   ├── G3-VFX-*-*.cbl (Member & Movie Operations)
│   └── Build Programs
├── Integration Layer (2 programs)
│   ├── G3-LINK-CC-CHECK.cbl (Credit Validation)
│   └── G3-LINK-CC-TRANS.cbl (Transaction Linking)
└── Build Programs (7 programs)
    └── Data File Construction Utilities
```

### Current Data Architecture
- **File Types:** COBOL Indexed Sequential Access Method (ISAM)
- **Key Files:**
  - CH-FILE (Capital One Accounts)
  - CC-TRAN-FILE (Transaction History)
  - ISS-FILE (VISA Issuers)
  - MER-FILE (VISA Merchants)
  - VM-FILE (Vuflix Members)
  - VML-FILE (Movie Library)
  - ZIP-MST-OUT (ZIP Code Reference)

### Performance Characteristics
- **Batch Processing:** Month-end reconciliation of all accounts
- **Real-time Transactions:** Credit validation and purchase processing
- **Large Data Volumes:** Mainframe-scale transaction processing
- **Concurrent Access:** Multiple user sessions with file locking

---

## Target System Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Load Balancer (Nginx)                    │
└─────────────────────────────────────────────────────────────┘
                                │
┌─────────────────────────────────────────────────────────────┐
│                Angular 17+ Frontend (SPA)                   │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────────────────┐ │
│  │    VISA     │ │ Capital One │ │        Vuflix           │ │
│  │   Module    │ │   Module    │ │        Module           │ │
│  └─────────────┘ └─────────────┘ └─────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                                │
                          REST API (HTTPS)
                                │
┌─────────────────────────────────────────────────────────────┐
│              API Gateway (Spring Cloud Gateway)             │
└─────────────────────────────────────────────────────────────┘
                                │
┌─────────────────────────────────────────────────────────────┐
│                Java Spring Boot Microservices               │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────────────────┐ │
│  │    VISA     │ │ Capital One │ │        Vuflix           │ │
│  │   Service   │ │   Service   │ │        Service          │ │
│  └─────────────┘ └─────────────┘ └─────────────────────────┘ │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────────────────┐ │
│  │   Common    │ │   Batch     │ │      Notification       │ │
│  │  Services   │ │ Processing  │ │       Service           │ │
│  └─────────────┘ └─────────────┘ └─────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                                │
┌─────────────────────────────────────────────────────────────┐
│                    Data Layer                               │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────────────────┐ │
│  │ PostgreSQL  │ │    Redis    │ │      Elasticsearch      │ │
│  │  (Primary)  │ │   (Cache)   │ │    (Search/Analytics)   │ │
│  └─────────────┘ └─────────────┘ └─────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

### Technology Stack

#### Frontend Stack
- **Framework:** Angular 17+ with TypeScript
- **UI Library:** Angular Material + Custom Components
- **State Management:** NgRx for complex state management
- **HTTP Client:** Angular HttpClient with interceptors
- **Authentication:** JWT with Angular Guards
- **Build Tool:** Angular CLI with Webpack
- **Testing:** Jasmine + Karma for unit tests, Cypress for E2E

#### Backend Stack
- **Framework:** Spring Boot 3.2+ with Java 21
- **Architecture:** Microservices with Spring Cloud
- **API Gateway:** Spring Cloud Gateway
- **Security:** Spring Security with JWT
- **Data Access:** Spring Data JPA + Hibernate
- **Caching:** Redis with Spring Cache
- **Message Queue:** Apache Kafka for async processing
- **Batch Processing:** Spring Batch for month-end operations
- **Monitoring:** Micrometer + Prometheus + Grafana
- **Documentation:** OpenAPI 3.0 (Swagger)

#### Database & Infrastructure
- **Primary Database:** PostgreSQL 15+ with partitioning
- **Cache:** Redis 7+ for session and data caching
- **Search Engine:** Elasticsearch for complex queries
- **Message Broker:** Apache Kafka for event streaming
- **Container Platform:** Docker + Kubernetes
- **Load Balancer:** Nginx or AWS ALB
- **Monitoring:** ELK Stack (Elasticsearch, Logstash, Kibana)

---

## Detailed Migration Strategy

### Phase 1: Foundation & Infrastructure (Weeks 1-4)

#### 1.1 Environment Setup
- Set up development, staging, and production environments
- Configure CI/CD pipelines with Jenkins/GitLab CI
- Establish monitoring and logging infrastructure
- Set up database clusters with replication

#### 1.2 Data Migration Planning
- Analyze COBOL file structures and data relationships
- Design PostgreSQL schema with proper indexing
- Create data migration scripts for COBOL to PostgreSQL
- Implement data validation and integrity checks

#### 1.3 Security Framework
- Implement JWT-based authentication system
- Set up role-based access control (RBAC)
- Configure API security with Spring Security
- Establish audit logging for compliance

### Phase 2: Core Services Development (Weeks 5-12)

#### 2.1 Common Services
```java
// Example service structure
@Service
public class CreditValidationService {
    // Migrated from G3-LINK-CC-CHECK.cbl
    public ValidationResult validateCreditCard(String cardId, BigDecimal amount);
    public BigDecimal calculateAvailableCredit(String accountId);
    public boolean checkCreditLimit(String accountId, BigDecimal transactionAmount);
}
```

#### 2.2 Capital One Service Migration
- **Account Management Service** (from G3-CAP1-U-*.cbl)
- **Transaction Processing Service** (from G3-CAP1-TRANS.cbl)
- **Batch Processing Service** (from G3-CAP1-MONTH-END.cbl)
- **Payment Service** (from G3-CAP1-PAY.cbl)

#### 2.3 VISA Service Migration
- **Issuer Management Service** (from G3-VISA-ISS-ADD.cbl)
- **Merchant Management Service** (from G3-VISA-MER-*.cbl)
- **Payment Processing Service**

#### 2.4 Vuflix Service Migration
- **Member Management Service** (from G3-VFX-1-ADD.cbl, G3-VFX-2-EDIT.cbl)
- **Movie Catalog Service** (from G3-VFX-3-PUR.cbl)
- **Purchase Processing Service**
- **Wishlist Management Service** (from G3-VFX-5-MOV-WISH.cbl)

### Phase 3: Frontend Development (Weeks 8-16)

#### 3.1 Angular Application Structure
```typescript
src/
├── app/
│   ├── core/                 // Singleton services, guards
│   ├── shared/               // Shared components, pipes, directives
│   ├── features/
│   │   ├── visa/            // VISA module components
│   │   ├── capital-one/     // Capital One module components
│   │   └── vuflix/          // Vuflix module components
│   ├── layout/              // Application shell
│   └── auth/                // Authentication components
```

#### 3.2 Component Migration Strategy
- **Main Menu** → Angular Router with lazy-loaded modules
- **COBOL Screens** → Angular Reactive Forms
- **Menu Navigation** → Angular Material Navigation
- **Data Display** → Angular Material Tables with pagination

#### 3.3 State Management
```typescript
// Example NgRx state structure
interface AppState {
  visa: VisaState;
  capitalOne: CapitalOneState;
  vuflix: VuflixState;
  auth: AuthState;
  ui: UIState;
}
```

### Phase 4: Integration & Testing (Weeks 13-20)

#### 4.1 API Integration
- Implement REST API clients with proper error handling
- Add request/response interceptors for logging and auth
- Implement retry logic and circuit breakers
- Add API response caching strategies

#### 4.2 Performance Optimization
- Implement lazy loading for Angular modules
- Add database query optimization and indexing
- Configure Redis caching for frequently accessed data
- Implement connection pooling and database partitioning

#### 4.3 Testing Strategy
- Unit tests for all services and components (80%+ coverage)
- Integration tests for API endpoints
- End-to-end tests for critical user journeys
- Performance testing with mainframe-scale data volumes

---

## Data Migration Strategy

### Database Schema Design

#### Core Tables Structure
```sql
-- Capital One Account Management
CREATE TABLE cap_one_accounts (
    account_id BIGSERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(15),
    address TEXT,
    zip_code VARCHAR(10),
    email VARCHAR(100),
    credit_limit DECIMAL(12,2),
    current_balance DECIMAL(12,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Transaction History with Partitioning
CREATE TABLE cc_transactions (
    transaction_id BIGSERIAL,
    account_id BIGINT REFERENCES cap_one_accounts(account_id),
    transaction_type CHAR(1) CHECK (transaction_type IN ('W', 'D')),
    amount DECIMAL(12,2),
    transaction_date TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (transaction_id, transaction_date)
) PARTITION BY RANGE (transaction_date);

-- VISA Issuers
CREATE TABLE visa_issuers (
    issuer_id BIGSERIAL PRIMARY KEY,
    issuer_name VARCHAR(100) NOT NULL,
    state VARCHAR(2),
    email VARCHAR(100),
    phone VARCHAR(15),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- VISA Merchants
CREATE TABLE visa_merchants (
    merchant_id BIGSERIAL PRIMARY KEY,
    merchant_name VARCHAR(100) NOT NULL,
    address TEXT,
    zip_code VARCHAR(10),
    phone VARCHAR(15),
    email VARCHAR(100),
    account_number VARCHAR(20),
    routing_number VARCHAR(15),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Vuflix Members
CREATE TABLE vuflix_members (
    member_id BIGSERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    address TEXT,
    zip_code VARCHAR(10),
    phone VARCHAR(15),
    email VARCHAR(100),
    credit_card_id BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Movie Library
CREATE TABLE movies (
    movie_id BIGSERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    genre VARCHAR(50),
    price DECIMAL(8,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ZIP Code Reference
CREATE TABLE zip_codes (
    zip_code VARCHAR(10) PRIMARY KEY,
    city VARCHAR(100),
    state VARCHAR(2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### Indexing Strategy
```sql
-- Performance indexes for large data volumes
CREATE INDEX idx_cc_transactions_account_date ON cc_transactions(account_id, transaction_date);
CREATE INDEX idx_cc_transactions_date ON cc_transactions(transaction_date);
CREATE INDEX idx_cap_one_accounts_email ON cap_one_accounts(email);
CREATE INDEX idx_visa_merchants_name ON visa_merchants(merchant_name);
CREATE INDEX idx_vuflix_members_email ON vuflix_members(email);
CREATE INDEX idx_movies_genre ON movies(genre);
CREATE INDEX idx_movies_title ON movies USING gin(to_tsvector('english', title));
```

### Data Migration Process

#### 1. COBOL File Analysis
```bash
# Extract COBOL file structures
cobol-file-analyzer --input CHOLD.DAT --output chold-schema.json
cobol-file-analyzer --input CC-TRAN.DAT --output cctran-schema.json
```

#### 2. Migration Scripts
```java
@Component
public class CobolDataMigrator {
    
    @Autowired
    private JdbcTemplate jdbcTemplate;
    
    public void migrateCapitalOneAccounts() {
        // Read COBOL CHOLD.DAT file
        // Parse fixed-width records
        // Insert into PostgreSQL with batch processing
        String sql = "INSERT INTO cap_one_accounts (account_id, first_name, last_name, ...) VALUES (?, ?, ?, ...)";
        jdbcTemplate.batchUpdate(sql, batchArgs);
    }
    
    public void migrateTransactionHistory() {
        // Migrate CC-TRAN.DAT with date partitioning
        // Handle large volumes with streaming processing
    }
}
```

#### 3. Data Validation
- Compare record counts between COBOL files and PostgreSQL tables
- Validate data integrity and referential constraints
- Perform checksum validation for critical financial data
- Test query performance with production-scale data

---

## Performance Optimization Strategy

### Database Performance

#### 1. Partitioning Strategy
```sql
-- Monthly partitions for transaction data
CREATE TABLE cc_transactions_y2024m01 PARTITION OF cc_transactions
    FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');
    
CREATE TABLE cc_transactions_y2024m02 PARTITION OF cc_transactions
    FOR VALUES FROM ('2024-02-01') TO ('2024-03-01');
```

#### 2. Connection Pooling
```yaml
# application.yml
spring:
  datasource:
    hikari:
      maximum-pool-size: 50
      minimum-idle: 10
      connection-timeout: 30000
      idle-timeout: 600000
      max-lifetime: 1800000
```

#### 3. Query Optimization
```java
@Repository
public class TransactionRepository {
    
    @Query(value = "SELECT * FROM cc_transactions WHERE account_id = ?1 AND transaction_date >= ?2 ORDER BY transaction_date DESC LIMIT ?3", nativeQuery = true)
    List<Transaction> findRecentTransactions(Long accountId, LocalDateTime fromDate, int limit);
    
    // Use database-specific optimizations
    @Query(value = "SELECT account_id, SUM(CASE WHEN transaction_type = 'W' THEN amount ELSE -amount END) as balance FROM cc_transactions WHERE account_id = ?1 GROUP BY account_id", nativeQuery = true)
    BigDecimal calculateAccountBalance(Long accountId);
}
```

### Application Performance

#### 1. Caching Strategy
```java
@Service
@CacheConfig(cacheNames = "creditValidation")
public class CreditValidationService {
    
    @Cacheable(key = "#accountId")
    public BigDecimal getAvailableCredit(Long accountId) {
        // Expensive calculation cached for 5 minutes
    }
    
    @CacheEvict(key = "#accountId")
    public void updateAccountBalance(Long accountId, BigDecimal newBalance) {
        // Invalidate cache when balance changes
    }
}
```

#### 2. Async Processing
```java
@Service
public class BatchProcessingService {
    
    @Async("batchExecutor")
    public CompletableFuture<Void> processMonthEndReconciliation() {
        // Equivalent to G3-CAP1-MONTH-END.cbl
        // Process large volumes asynchronously
        return CompletableFuture.completedFuture(null);
    }
}
```

#### 3. Database Read Replicas
```yaml
spring:
  datasource:
    primary:
      url: jdbc:postgresql://primary-db:5432/financial_services
    readonly:
      url: jdbc:postgresql://readonly-db:5432/financial_services
```

### Frontend Performance

#### 1. Lazy Loading
```typescript
const routes: Routes = [
  {
    path: 'visa',
    loadChildren: () => import('./features/visa/visa.module').then(m => m.VisaModule)
  },
  {
    path: 'capital-one',
    loadChildren: () => import('./features/capital-one/capital-one.module').then(m => m.CapitalOneModule)
  }
];
```

#### 2. Virtual Scrolling for Large Data Sets
```typescript
@Component({
  template: `
    <cdk-virtual-scroll-viewport itemSize="50" class="transaction-viewport">
      <div *cdkVirtualFor="let transaction of transactions">
        {{transaction.date}} - {{transaction.amount}}
      </div>
    </cdk-virtual-scroll-viewport>
  `
})
export class TransactionListComponent {
  transactions: Transaction[] = []; // Large dataset
}
```

#### 3. OnPush Change Detection
```typescript
@Component({
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `...`
})
export class HighPerformanceComponent {
  // Optimized for large data rendering
}
```

---

## API Design

### RESTful API Structure

#### Capital One APIs
```yaml
# Capital One Account Management
GET    /api/v1/capital-one/accounts                    # List accounts
POST   /api/v1/capital-one/accounts                    # Create account
GET    /api/v1/capital-one/accounts/{id}               # Get account details
PUT    /api/v1/capital-one/accounts/{id}               # Update account
DELETE /api/v1/capital-one/accounts/{id}               # Delete account

# Transaction Management
GET    /api/v1/capital-one/accounts/{id}/transactions  # Get transactions
POST   /api/v1/capital-one/accounts/{id}/transactions  # Create transaction
GET    /api/v1/capital-one/transactions/{id}           # Get transaction details

# Batch Processing
POST   /api/v1/capital-one/batch/month-end             # Trigger month-end processing
GET    /api/v1/capital-one/batch/month-end/status      # Check processing status
```

#### VISA APIs
```yaml
# Issuer Management
GET    /api/v1/visa/issuers                           # List issuers
POST   /api/v1/visa/issuers                           # Create issuer
GET    /api/v1/visa/issuers/{id}                      # Get issuer details
PUT    /api/v1/visa/issuers/{id}                      # Update issuer
DELETE /api/v1/visa/issuers/{id}                      # Delete issuer
GET    /api/v1/visa/issuers/search                    # Search issuers

# Merchant Management
GET    /api/v1/visa/merchants                         # List merchants
POST   /api/v1/visa/merchants                         # Create merchant
GET    /api/v1/visa/merchants/{id}                    # Get merchant details
PUT    /api/v1/visa/merchants/{id}                    # Update merchant
DELETE /api/v1/visa/merchants/{id}                    # Delete merchant
```

#### Vuflix APIs
```yaml
# Member Management
GET    /api/v1/vuflix/members                         # List members
POST   /api/v1/vuflix/members                         # Create member
GET    /api/v1/vuflix/members/{id}                    # Get member details
PUT    /api/v1/vuflix/members/{id}                    # Update member
DELETE /api/v1/vuflix/members/{id}                    # Delete member

# Movie Management
GET    /api/v1/vuflix/movies                          # List movies
GET    /api/v1/vuflix/movies/search                   # Search movies
GET    /api/v1/vuflix/movies/{id}                     # Get movie details

# Purchase Management
POST   /api/v1/vuflix/purchases                       # Purchase movie
GET    /api/v1/vuflix/members/{id}/purchases          # Get member purchases
GET    /api/v1/vuflix/members/{id}/wishlist           # Get member wishlist
POST   /api/v1/vuflix/members/{id}/wishlist           # Add to wishlist
DELETE /api/v1/vuflix/members/{id}/wishlist/{movieId} # Remove from wishlist
```

#### Common APIs
```yaml
# Credit Validation (migrated from G3-LINK-CC-CHECK.cbl)
POST   /api/v1/common/credit/validate                 # Validate credit card
GET    /api/v1/common/credit/{cardId}/available       # Get available credit

# ZIP Code Service
GET    /api/v1/common/zip-codes/{zipCode}             # Get ZIP code details
GET    /api/v1/common/zip-codes/search                # Search ZIP codes
```

### API Response Format
```json
{
  "success": true,
  "data": {
    "accountId": 12345,
    "firstName": "John",
    "lastName": "Doe",
    "email": "john.doe@example.com",
    "creditLimit": 5000.00,
    "currentBalance": 1250.75
  },
  "metadata": {
    "timestamp": "2024-07-23T12:31:34Z",
    "version": "v1",
    "requestId": "req-123456"
  },
  "pagination": {
    "page": 1,
    "size": 20,
    "totalElements": 150,
    "totalPages": 8
  }
}
```

---

## Security Implementation

### Authentication & Authorization

#### JWT Token Structure
```json
{
  "sub": "user123",
  "name": "John Doe",
  "roles": ["CAPITAL_ONE_USER", "VISA_ADMIN", "VUFLIX_MEMBER"],
  "modules": ["capital-one", "visa", "vuflix"],
  "exp": 1627123456,
  "iat": 1627037056
}
```

#### Role-Based Access Control
```java
@PreAuthorize("hasRole('CAPITAL_ONE_ADMIN')")
@PostMapping("/api/v1/capital-one/accounts/{id}/credit-limit")
public ResponseEntity<Void> updateCreditLimit(@PathVariable Long id, @RequestBody CreditLimitRequest request) {
    // Only Capital One admins can update credit limits
}

@PreAuthorize("hasRole('VISA_MERCHANT_MANAGER')")
@PostMapping("/api/v1/visa/merchants")
public ResponseEntity<MerchantResponse> createMerchant(@RequestBody MerchantRequest request) {
    // Only VISA merchant managers can create merchants
}
```

### Data Protection

#### Encryption at Rest
```yaml
spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/financial_services?ssl=true&sslmode=require
  jpa:
    properties:
      hibernate:
        dialect: org.hibernate.dialect.PostgreSQLDialect
        jdbc:
          lob:
            non_contextual_creation: true
```

#### Sensitive Data Handling
```java
@Entity
public class CapitalOneAccount {
    @Id
    private Long accountId;
    
    @Column(name = "first_name")
    private String firstName;
    
    @Column(name = "last_name")
    private String lastName;
    
    @Encrypted  // Custom annotation for field-level encryption
    @Column(name = "ssn")
    private String socialSecurityNumber;
    
    @Encrypted
    @Column(name = "credit_card_number")
    private String creditCardNumber;
}
```

### Audit Logging
```java
@Component
public class AuditLogger {
    
    @EventListener
    public void handleAccountCreation(AccountCreatedEvent event) {
        auditLog.info("Account created: accountId={}, userId={}, timestamp={}", 
                     event.getAccountId(), event.getUserId(), event.getTimestamp());
    }
    
    @EventListener
    public void handleTransactionProcessed(TransactionProcessedEvent event) {
        auditLog.info("Transaction processed: transactionId={}, accountId={}, amount={}", 
                     event.getTransactionId(), event.getAccountId(), event.getAmount());
    }
}
```

---

## Batch Processing Migration

### Month-End Processing (G3-CAP1-MONTH-END.cbl → Spring Batch)

#### Job Configuration
```java
@Configuration
@EnableBatchProcessing
public class MonthEndBatchConfig {
    
    @Bean
    public Job monthEndReconciliationJob() {
        return jobBuilderFactory.get("monthEndReconciliation")
                .incrementer(new RunIdIncrementer())
                .start(calculateBalancesStep())
                .next(updateAccountsStep())
                .next(archiveTransactionsStep())
                .build();
    }
    
    @Bean
    public Step calculateBalancesStep() {
        return stepBuilderFactory.get("calculateBalances")
                .<Account, AccountBalance>chunk(1000)
                .reader(accountReader())
                .processor(balanceCalculationProcessor())
                .writer(balanceWriter())
                .build();
    }
}
```

#### Balance Calculation Processor
```java
@Component
public class BalanceCalculationProcessor implements ItemProcessor<Account, AccountBalance> {
    
    @Override
    public AccountBalance process(Account account) throws Exception {
        // Equivalent logic from G3-CAP1-MONTH-END.cbl lines 57-76
        BigDecimal totalBalance = account.getCurrentBalance();
        
        List<Transaction> transactions = transactionRepository
                .findByAccountIdAndProcessedFalse(account.getAccountId());
        
        for (Transaction transaction : transactions) {
            if ("W".equals(transaction.getTransactionType())) {
                totalBalance = totalBalance.add(transaction.getAmount());
            } else if ("D".equals(transaction.getTransactionType())) {
                totalBalance = totalBalance.subtract(transaction.getAmount());
            }
        }
        
        return new AccountBalance(account.getAccountId(), totalBalance);
    }
}
```

### Build Program Migration

#### Data Import Jobs
```java
@Component
public class DataImportService {
    
    @Scheduled(cron = "0 0 2 * * ?") // Daily at 2 AM
    public void importZipCodeData() {
        // Equivalent to G3-BLD-ZIP.cbl
        Job job = jobBuilderFactory.get("zipCodeImport")
                .start(zipCodeImportStep())
                .build();
        
        jobLauncher.run(job, new JobParameters());
    }
    
    public void importCobolDataFiles() {
        // Migration utility for one-time COBOL file import
        // Equivalent to all G3-BLD-*.cbl programs
    }
}
```

---

## Monitoring & Observability

### Application Monitoring

#### Metrics Collection
```java
@RestController
@Timed(name = "api.requests", description = "API request duration")
public class CapitalOneController {
    
    @Counter(name = "accounts.created", description = "Number of accounts created")
    private Counter accountCreationCounter;
    
    @PostMapping("/accounts")
    public ResponseEntity<AccountResponse> createAccount(@RequestBody AccountRequest request) {
        accountCreationCounter.increment();
        // Account creation logic
    }
}
```

#### Health Checks
```java
@Component
public class DatabaseHealthIndicator implements HealthIndicator {
    
    @Override
    public Health health() {
        try {
            jdbcTemplate.queryForObject("SELECT 1", Integer.class);
            return Health.up()
                    .withDetail("database", "PostgreSQL")
                    .withDetail("status", "Connected")
                    .build();
        } catch (Exception e) {
            return Health.down()
                    .withDetail("database", "PostgreSQL")
                    .withDetail("error", e.getMessage())
                    .build();
        }
    }
}
```

### Performance Monitoring

#### Database Query Monitoring
```yaml
# application.yml
spring:
  jpa:
    show-sql: false
    properties:
      hibernate:
        generate_statistics: true
        session:
          events:
            log:
              LOG_QUERIES_SLOWER_THAN_MS: 1000
```

#### Custom Metrics
```java
@Component
public class BusinessMetrics {
    
    @EventListener
    public void recordTransactionProcessed(TransactionProcessedEvent event) {
        Metrics.counter("transactions.processed", 
                       "type", event.getTransactionType(),
                       "module", event.getModule())
               .increment();
        
        Metrics.timer("transaction.processing.time")
               .record(event.getProcessingDuration(), TimeUnit.MILLISECONDS);
    }
}
```

---

## Deployment Strategy

### Containerization

#### Dockerfile for Spring Boot Services
```dockerfile
FROM openjdk:21-jre-slim

WORKDIR /app

COPY target/financial-services-*.jar app.jar

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/actuator/health || exit 1

ENTRYPOINT ["java", "-jar", "app.jar"]
```

#### Docker Compose for Development
```yaml
version: '3.8'
services:
  postgres:
    image: postgres:15
    environment:
      POSTGRES_DB: financial_services
      POSTGRES_USER: app_user
      POSTGRES_PASSWORD: app_password
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

  capital-one-service:
    build: ./capital-one-service
    ports:
      - "8081:8080"
    depends_on:
      - postgres
      - redis
    environment:
      SPRING_DATASOURCE_URL: jdbc:postgresql://postgres:5432/financial_services
      SPRING_REDIS_HOST: redis

  visa-service:
    build: ./visa-service
    ports:
      - "8082:8080"
    depends_on:
      - postgres
      - redis

  vuflix-service:
    build: ./vuflix-service
    ports:
      - "8083:8080"
    depends_on:
      - postgres
      - redis

  angular-frontend:
    build: ./frontend
    ports:
      - "4200:80"
    depends_on:
      - capital-one-service
      - visa-service
      - vuflix-service
```

### Kubernetes Deployment

#### Service Deployment
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: capital-one-service
spec:
  replicas: 3
  selector:
    matchLabels:
      app: capital-one-service
  template:
    metadata:
      labels:
        app: capital-one-service
    spec:
      containers:
      - name: capital-one-service
        image: financial-services/capital-one-service:latest
        ports:
        - containerPort: 8080
        env:
        - name: SPRING_DATASOURCE_URL
          valueFrom:
            secretKeyRef:
              name: database-secret
              key: url
        resources:
          requests:
            memory: "512Mi"
            cpu: "250m"
          limits:
            memory: "1Gi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /actuator/health
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /actuator/health/readiness
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 5
```

---

## Testing Strategy

### Unit Testing

#### Service Layer Testing
```java
@ExtendWith(MockitoExtension.class)
class CreditValidationServiceTest {
    
    @Mock
    private AccountRepository accountRepository;
    
    @Mock
    private TransactionRepository transactionRepository;
    
    @InjectMocks
    private CreditValidationService creditValidationService;
    
    @Test
    void shouldValidateCreditCardSuccessfully() {
        // Given
        Account account = new Account();
        account.setAccountId(12345L);
        account.setCreditLimit(new BigDecimal("5000.00"));
        account.setCurrentBalance(new BigDecimal("1000.00"));
        
        when(accountRepository.findByAccountId(12345L)).thenReturn(Optional.of(account));
        when(transactionRepository.calculatePendingBalance(12345L)).thenReturn(new BigDecimal("500.00"));
        
        // When
        ValidationResult result = creditValidationService.validateCreditCard("12345", new BigDecimal("1000.00"));
        
        // Then
        assertTrue(result.isValid());
        assertEquals(new BigDecimal("3500.00"), result.getAvailableCredit());
    }
}
```

#### Repository Testing
```java
@DataJpaTest
class AccountRepositoryTest {
    
    @Autowired
    private TestEntityManager entityManager;
    
    @Autowired
    private AccountRepository accountRepository;
    
    @Test
    void shouldFindAccountByEmail() {
        // Given
        Account account = new Account();
        account.setEmail("test@example.com");
        account.setFirstName("John");
        account.setLastName("Doe");
        entityManager.persistAndFlush(account);
        
        // When
        Optional<Account> found = accountRepository.findByEmail("test@example.com");
        
        // Then
        assertTrue(found.isPresent());
        assertEquals("John", found.get().getFirstName());
    }
}
```

### Integration Testing

#### API Integration Tests
```java
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@TestPropertySource(locations = "classpath:application-test.properties")
class CapitalOneControllerIntegrationTest {
    
    @Autowired
    private TestRestTemplate restTemplate;
    
    @Autowired
    private AccountRepository accountRepository;
    
    @Test
    void shouldCreateAccountSuccessfully() {
        // Given
        AccountRequest request = new AccountRequest();
        request.setFirstName("John");
        request.setLastName("Doe");
        request.setEmail("john.doe@example.com");
        request.setCreditLimit(new BigDecimal("5000.00"));
        
        // When
        ResponseEntity<AccountResponse> response = restTemplate.postForEntity(
                "/api/v1/capital-one/accounts", request, AccountResponse.class);
        
        // Then
        assertEquals(HttpStatus.CREATED, response.getStatusCode());
        assertNotNull(response.getBody().getAccountId());
        
        // Verify in database
        Optional<Account> savedAccount = accountRepository.findById(response.getBody().getAccountId());
        assertTrue(savedAccount.isPresent());
        assertEquals("John", savedAccount.get().getFirstName());
    }
}
```

### Performance Testing

#### Load Testing with JMeter
```xml
<?xml version="1.0" encoding="UTF-8"?>
<jmeterTestPlan version="1.2">
  <hashTree>
    <TestPlan testname="Financial Services Load Test">
      <elementProp name="TestPlan.arguments" elementType="Arguments" guiclass="ArgumentsPanel">
        <collectionProp name="Arguments.arguments"/>
      </elementProp>
      <stringProp name="TestPlan.user_define_classpath"></stringProp>
      <boolProp name="TestPlan.serialize_threadgroups">false</boolProp>
      <boolProp name="TestPlan.functional_mode">false</boolProp>
    </TestPlan>
    <hashTree>
      <ThreadGroup testname="Account Creation Load Test">
        <stringProp name="ThreadGroup.num_threads">100</stringProp>
        <stringProp name="ThreadGroup.ramp_time">60</stringProp>
        <stringProp name="ThreadGroup.duration">300</stringProp>
        <boolProp name="ThreadGroup.scheduler">true</boolProp>
      </ThreadGroup>
    </hashTree>
  </hashTree>
</jmeterTestPlan>
```

### End-to-End Testing

#### Cypress E2E Tests
```typescript
describe('Capital One Account Management', () => {
  beforeEach(() => {
    cy.login('admin@example.com', 'password');
    cy.visit('/capital-one');
  });

  it('should create new account successfully', () => {
    cy.get('[data-cy=create-account-btn]').click();
    
    cy.get('[data-cy=first-name-input]').type('John');
    cy.get('[data-cy=last-name-input]').type('Doe');
    cy.get('[data-cy=email-input]').type('john.doe@example.com');
    cy.get('[data-cy=credit-limit-input]').type('5000');
    
    cy.get('[data-cy=submit-btn]').click();
    
    cy.get('[data-cy=success-message]').should('contain', 'Account created successfully');
    cy.url().should('include', '/capital-one/accounts/');
  });

  it('should display transaction history', () => {
    cy.get('[data-cy=account-12345]').click();
    cy.get('[data-cy=transactions-tab]').click();
    
    cy.get('[data-cy=transaction-list]').should('be.visible');
    cy.get('[data-cy=transaction-item]').should('have.length.greaterThan', 0);
  });
});
```

---

## Risk Mitigation & Rollback Strategy

### Migration Risks

#### 1. Data Loss Prevention
- **Parallel Run Strategy:** Run both COBOL and new system simultaneously for 30 days
- **Data Synchronization:** Real-time sync between COBOL files and PostgreSQL
- **Backup Strategy:** Full COBOL file backups before each migration step
- **Rollback Plan:** Automated rollback to COBOL system within 4 hours

#### 2. Performance Degradation
- **Load Testing:** Test with 150% of current mainframe transaction volume
- **Performance Monitoring:** Real-time alerts for response times > 2 seconds
- **Auto-scaling:** Kubernetes horizontal pod autoscaling based on CPU/memory
- **Circuit Breakers:** Automatic fallback to cached data during high load

#### 3. Business Continuity
- **Blue-Green Deployment:** Zero-downtime deployment strategy
- **Feature Flags:** Gradual rollout of new features with instant rollback
- **24/7 Monitoring:** Dedicated support team during migration period
- **Disaster Recovery:** Multi-region deployment with automatic failover

### Rollback Procedures

#### Emergency Rollback (< 1 hour)
```bash
# Immediate rollback to previous version
kubectl rollout undo deployment/capital-one-service
kubectl rollout undo deployment/visa-service
kubectl rollout undo deployment/vuflix-service

# Redirect traffic back to COBOL system
kubectl patch service api-gateway -p '{"spec":{"selector":{"app":"cobol-gateway"}}}'
```

#### Data Rollback (< 4 hours)
```sql
-- Restore from backup
pg_restore --clean --if-exists -d financial_services backup_20240723.dump

-- Verify data integrity
SELECT COUNT(*) FROM cap_one_accounts;
SELECT COUNT(*) FROM cc_transactions;
```

---

## Implementation Timeline

### Phase 1: Foundation (Weeks 1-4)
- **Week 1:** Environment setup, CI/CD pipeline, database design
- **Week 2:** Data migration scripts, COBOL file analysis
- **Week 3:** Security framework, authentication system
- **Week 4:** Common services, credit validation API

### Phase 2: Backend Services (Weeks 5-12)
- **Weeks 5-6:** Capital One service development
- **Weeks 7-8:** VISA service development
- **Weeks 9-10:** Vuflix service development
- **Weeks 11-12:** Integration testing, performance optimization

### Phase 3: Frontend Development (Weeks 8-16)
- **Weeks 8-10:** Angular application setup, routing, authentication
- **Weeks 11-13:** Capital One module development
- **Weeks 14-15:** VISA and Vuflix modules development
- **Week 16:** UI/UX refinement, responsive design

### Phase 4: Integration & Testing (Weeks 13-20)
- **Weeks 13-15:** API integration, end-to-end testing
- **Weeks 16-17:** Performance testing, load testing
- **Weeks 18-19:** Security testing, penetration testing
- **Week 20:** User acceptance testing, documentation

### Phase 5: Deployment & Migration (Weeks 21-24)
- **Week 21:** Production environment setup
- **Week 22:** Data migration, parallel run setup
- **Week 23:** Go-live, monitoring, support
- **Week 24:** Post-migration optimization, COBOL system decommission

---

## Success Metrics

### Performance Metrics
- **Response Time:** < 2 seconds for 95% of API requests
- **Throughput:** Handle 10,000+ concurrent users
- **Availability:** 99.9% uptime (< 8.76 hours downtime/year)
- **Data Processing:** Process 1M+ transactions per day

### Business Metrics
- **User Adoption:** 100% migration from COBOL system within 30 days
- **Feature Parity:** 100% of COBOL functionality available in new system
- **Data Accuracy:** 99.99% data integrity during migration
- **Cost Reduction:** 40% reduction in operational costs within 6 months

### Technical Metrics
- **Code Coverage:** > 80% unit test coverage
- **Security:** Zero critical security vulnerabilities
- **Scalability:** Auto-scale from 3 to 50 instances based on load
- **Monitoring:** 100% of critical business processes monitored

---

## Conclusion

This comprehensive migration strategy transforms the legacy COBOL mainframe system into a modern, scalable Angular + Java web application while maintaining all existing functionality and addressing mainframe-level performance requirements. The phased approach ensures minimal business disruption while providing a clear path to modernization.

**Key Benefits:**
- **Modernization:** Move from mainframe to cloud-native architecture
- **Scalability:** Handle growing transaction volumes with auto-scaling
- **Maintainability:** Modern codebase with comprehensive testing
- **User Experience:** Intuitive web interface replacing terminal-based screens
- **Cost Efficiency:** Reduced operational costs and improved developer productivity
- **Security:** Enhanced security with modern authentication and encryption
- **Performance:** Optimized for large-scale data processing with caching and partitioning

The migration preserves the robust business logic of the original COBOL system while leveraging modern technologies to provide better performance, scalability, and user experience. The comprehensive testing strategy and rollback procedures ensure a safe migration with minimal risk to business operations.

**Total Estimated Timeline:** 24 weeks (6 months)
**Estimated Team Size:** 8-10 developers (2 frontend, 4 backend, 2 DevOps, 1 DBA, 1 QA)
**Technology Stack:** Angular 17+, Java 21, Spring Boot 3.2+, PostgreSQL 15+, Redis 7+, Kubernetes
