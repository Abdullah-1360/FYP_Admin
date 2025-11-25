# Payment System Fix

## Issues Fixed:

### 1. **Payments Not Creating from User App** ✅
**Problem:** When users made purchases, payment records weren't being created in the database

**Solution:** Updated marketplace controller to create Payment records on purchase

#### Backend Changes:

**File: `FYP_backend/controllers/marketplaceController.js`**

1. **Updated `purchaseMedicine` function:**
   - Now creates Payment record when medicine is purchased
   - Updates medicine stock after purchase
   - Validates stock availability
   - Generates payment intent ID if not provided

2. **Added `checkout` function:**
   - Processes entire cart purchase
   - Creates single payment record for all cart items
   - Validates stock for all items before processing
   - Updates stock for all purchased items
   - Clears cart after successful checkout

**File: `FYP_backend/routes/marketplaceRoutes.js`**
- Added new route: `POST /api/marketplace/checkout`
- Requires authentication

### 2. **Payment Management Screen Not Showing Data** ✅
**Problem:** Payment model wasn't parsing the backend response correctly

**Solution:** Updated Payment model to handle both response formats

#### Frontend Changes:

**File: `lib/models/payment_model.dart`**
- Updated `fromJson` to handle direct fields (`userEmail`, `userUsername`)
- Added fallback for nested `userId` object
- Fixed `fullAddress` parsing

**File: `lib/screens/payment_management.dart`**
- Added refresh button in AppBar
- Added auto-refresh when returning to screen
- Improved lifecycle management

## New API Endpoints:

### 1. POST /api/marketplace/checkout
**Description:** Process cart purchase and create payment record

**Request Body:**
```json
{
  "paymentIntentId": "pi_xxx", // Optional, auto-generated if not provided
  "address": "123 Main St",
  "fullAddress": {
    "street": "123 Main St",
    "city": "New York",
    "state": "NY",
    "zipCode": "10001",
    "country": "USA"
  }
}
```

**Response:**
```json
{
  "message": "Checkout successful",
  "payment": {
    "_id": "...",
    "userId": "...",
    "amount": 150.00,
    "currency": "usd",
    "status": "succeeded",
    "items": [...],
    "createdAt": "..."
  }
}
```

### 2. POST /api/marketplace/medicines/purchase (Updated)
**Description:** Purchase a single medicine and create payment record

**Request Body:**
```json
{
  "medicineId": "...",
  "userId": "...",
  "quantity": 2,
  "paymentIntentId": "pi_xxx", // Optional
  "address": "123 Main St",
  "fullAddress": {...}
}
```

**Response:**
```json
{
  "message": "Medicine purchased successfully",
  "payment": {...},
  "remainingStock": 48
}
```

## How It Works Now:

### User Purchase Flow:
1. User adds items to cart
2. User proceeds to checkout
3. Frontend calls `POST /api/marketplace/checkout`
4. Backend:
   - Validates all items have sufficient stock
   - Creates Payment record with status "succeeded"
   - Updates medicine stock for all items
   - Clears user's cart
5. Payment appears in admin panel immediately

### Admin Panel:
1. Navigate to Payment Management
2. See all payments with:
   - User information (username/email)
   - Amount and currency
   - Payment status
   - Payment intent ID
   - Delivery address
   - Creation date
3. Can search by user or payment intent ID
4. Can delete payments
5. Can refresh to see latest data

## Testing:

### Test User Purchase:
1. In user app, add items to cart
2. Proceed to checkout
3. Complete purchase
4. Check admin panel Payment Management
5. Verify payment appears with correct details

### Test Admin Panel:
1. Open admin panel
2. Navigate to Payment Management
3. Click refresh button
4. Verify payments display
5. Test search functionality
6. Test delete functionality

## Database Schema:

### Payment Model:
```javascript
{
  userId: ObjectId (ref: User),
  amount: Number,
  currency: String (default: 'usd'),
  status: String (enum: ['pending', 'succeeded', 'failed', 'cancelled']),
  paymentIntentId: String,
  items: [{
    medicineId: ObjectId (ref: Medicine),
    quantity: Number,
    price: Number
  }],
  address: String,
  fullAddress: {
    street: String,
    city: String,
    state: String,
    zipCode: String,
    country: String
  },
  createdAt: Date
}
```

## Notes:

- All payments are created with status "succeeded" by default
- Payment intent IDs are auto-generated if not provided: `pi_[timestamp]_[random]`
- Stock is validated before purchase to prevent overselling
- Cart is automatically cleared after successful checkout
- Admin panel auto-refreshes when navigating back to payment screen
- Search works on username, email, and payment intent ID

## Future Enhancements:

1. Integrate real payment gateway (Stripe, PayPal)
2. Add payment status transitions (pending → succeeded/failed)
3. Add refund functionality
4. Add payment analytics (revenue by period, top customers)
5. Add export functionality (CSV, PDF)
6. Add email notifications for successful payments
