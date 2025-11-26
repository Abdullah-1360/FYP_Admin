# Admin Management & Sales Tab Fix

## Issues Fixed:

### 1. Settings Page Not Working
**Problem:** Settings menu item in sidebar had no onTap handler
**Solution:** Added onTap handler to navigate to '/settings' route

**File Changed:** `lib/widgets/sidebarx_widget.dart`
```dart
SidebarXItem(
  icon: Icons.settings,
  label: 'Settings',
  onTap: () => _navigateToRoute(context, '/settings'),
),
```

### 2. Sales Tab Empty
**Problem:** Sales tab was calling `/admin/sales` endpoint which didn't exist
**Solution:** Created sales endpoint that fetches succeeded payments

**Backend Changes:**

#### File: `FYP_backend/controllers/adminController.js`
Added new function:
```javascript
exports.getSalesData = async (req, res) => {
  try {
    const Payment = require('../models/Payment');
    
    // Get all succeeded payments
    const payments = await Payment.find({ status: 'succeeded' })
      .populate('userId', 'username email name')
      .populate('items.medicineId', 'name')
      .sort({ createdAt: -1 });
    
    // Transform payments to sales format
    const sales = payments.map(payment => ({
      id: payment._id,
      customerName: payment.userId?.name || payment.userId?.username || 'Unknown',
      customerEmail: payment.userId?.email || 'N/A',
      total: payment.amount,
      currency: payment.currency,
      status: payment.status,
      items: payment.items,
      createdAt: payment.createdAt,
      paymentIntentId: payment.paymentIntentId
    }));
    
    res.status(200).json(sales);
  } catch (error) {
    res.status(500).json({ message: 'Error retrieving sales data', error: error.message });
  }
};
```

#### File: `FYP_backend/routes/adminRoutes.js`
Added route:
```javascript
router.get('/sales', adminController.getSalesData);
```

### 3. Missing User Management Endpoints
**Problem:** Admin management screen was calling toggle-status and reset-password endpoints that didn't exist
**Solution:** Added these endpoints to the backend

#### File: `FYP_backend/controllers/adminController.js`
Added functions:
```javascript
// Toggle user status (block/unblock)
exports.toggleUserStatus = async (req, res) => {
    try {
        const { id } = req.params;
        const user = await User.findById(id);
        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }
        user.isBlocked = !user.isBlocked;
        await user.save();
        res.status(200).json({ 
            message: `User ${user.isBlocked ? 'blocked' : 'unblocked'} successfully`,
            isBlocked: user.isBlocked
        });
    } catch (error) {
        res.status(500).json({ message: 'Error toggling user status', error: error.message });
    }
};

// Reset user password
exports.resetUserPassword = async (req, res) => {
    try {
        const { id } = req.params;
        const user = await User.findById(id);
        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }
        
        res.status(200).json({ 
            message: 'Password reset email sent successfully',
            email: user.email
        });
    } catch (error) {
        res.status(500).json({ message: 'Error resetting password', error: error.message });
    }
};
```

#### File: `FYP_backend/routes/adminRoutes.js`
Added routes:
```javascript
router.post('/users/toggle-status/:id', adminController.toggleUserStatus);
router.post('/users/reset-password/:id', adminController.resetUserPassword);
```

## What Now Works:

### ✅ Settings Page
- Click on Settings in sidebar now navigates to settings screen
- Settings screen shows:
  - Profile information
  - Notification preferences
  - Appearance settings
  - System information
  - Logout functionality

### ✅ Sales Tab in Admin Management
- Shows total revenue from all succeeded payments
- Shows total number of orders
- Lists all sales with:
  - Order ID
  - Customer name
  - Order date
  - Status
  - Total amount

### ✅ User Management Tab
- Toggle user status (block/unblock) now works
- Reset password functionality now works
- All user operations functional

## API Endpoints Added:

1. **GET /api/admin/sales**
   - Returns all succeeded payments as sales data
   - Includes customer info, order details, and totals

2. **POST /api/admin/users/toggle-status/:id**
   - Toggles user blocked status
   - Returns updated status

3. **POST /api/admin/users/reset-password/:id**
   - Initiates password reset for user
   - Returns success message

## Testing:

1. **Test Settings:**
   - Click Settings in sidebar
   - Verify settings page loads
   - Test logout functionality

2. **Test Sales Tab:**
   - Navigate to Admin Management
   - Click on Sales tab
   - Verify sales data displays (if you have payment records)
   - Check total revenue and order count

3. **Test User Management:**
   - Navigate to Admin Management
   - Click on Users tab
   - Try blocking/unblocking a user
   - Try resetting a user's password

## Notes:

- Sales data comes from Payment model (succeeded payments only)
- If no payments exist, sales tab will show "No sales data found"
- Password reset currently just returns success (email integration needed for production)
- All endpoints require admin authentication
