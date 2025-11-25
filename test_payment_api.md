# Testing Payment System

## Issue: Payments not showing in admin panel

The backend has been updated to create payment records when purchases are made. Here's how to test:

## 1. Check if Backend is Running
Make sure your backend server is running with the latest code:
```bash
cd FYP_backend
git pull
npm start
```

## 2. Test Payment Creation Manually

### Option A: Test with Postman/Thunder Client

**Endpoint:** `POST https://2451dv8v-5000.asse.devtunnels.ms/api/marketplace/medicines/purchase`

**Headers:**
```
Content-Type: application/json
```

**Body:**
```json
{
  "medicineId": "YOUR_MEDICINE_ID",
  "userId": "YOUR_USER_ID",
  "quantity": 1,
  "address": "123 Test Street",
  "fullAddress": {
    "street": "123 Test Street",
    "city": "Test City",
    "state": "TS",
    "zipCode": "12345",
    "country": "USA"
  }
}
```

### Option B: Test Checkout Endpoint

**Endpoint:** `POST https://2451dv8v-5000.asse.devtunnels.ms/api/marketplace/checkout`

**Headers:**
```
Content-Type: application/json
Authorization: Bearer YOUR_USER_TOKEN
```

**Body:**
```json
{
  "address": "123 Test Street",
  "fullAddress": {
    "street": "123 Test Street",
    "city": "Test City",
    "state": "TS",
    "zipCode": "12345",
    "country": "USA"
  }
}
```

## 3. Verify Payment in Database

Connect to MongoDB and check:
```javascript
db.payments.find().sort({createdAt: -1}).limit(5)
```

## 4. Check Admin Panel

1. Open admin panel
2. Navigate to Payment Management
3. Click refresh button
4. Payments should appear

## 5. Debug Steps

### If payments still don't show:

1. **Check Backend Logs:**
   - Look for errors when purchase is made
   - Check if Payment model is being saved

2. **Check Network Tab in Browser:**
   - Open DevTools → Network
   - Navigate to Payment Management
   - Look for `/api/payments` request
   - Check response data

3. **Check API Response:**
   - The response should be an array of payment objects
   - Each payment should have: id, amount, currency, status, userEmail, userUsername

4. **Verify Backend URL:**
   - In `lib/Global_variables.dart`, check the URL is correct
   - Current: `https://2451dv8v-5000.asse.devtunnels.ms/api`

5. **Check CORS:**
   - Backend should allow requests from your admin panel domain
   - Check browser console for CORS errors

## 6. Common Issues

### Issue: "No payments found"
**Cause:** No payment records in database
**Solution:** Make a test purchase from user app

### Issue: Error loading payments
**Cause:** Backend not running or wrong URL
**Solution:** Check backend is running and URL is correct

### Issue: Payments show but no user info
**Cause:** userId not populated
**Solution:** Backend now returns userEmail and userUsername directly

### Issue: Old payments don't show user info
**Cause:** Old payments created before update
**Solution:** They won't have user info, only new payments will

## 7. User App Integration

Your user app needs to call one of these endpoints when user completes purchase:

### For Single Medicine Purchase:
```dart
final response = await dio.post(
  '/marketplace/medicines/purchase',
  data: {
    'medicineId': medicineId,
    'userId': userId,
    'quantity': quantity,
    'address': address,
    'fullAddress': fullAddress,
  },
);
```

### For Cart Checkout:
```dart
final response = await dio.post(
  '/marketplace/checkout',
  data: {
    'address': address,
    'fullAddress': fullAddress,
  },
  options: Options(
    headers: {'Authorization': 'Bearer $token'},
  ),
);
```

## 8. Restart Backend

After pulling the latest code, restart your backend:
```bash
# Stop current server (Ctrl+C)
# Then restart
npm start
```

The backend MUST be restarted for the new code to take effect!
