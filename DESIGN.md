# Assumptions
- Rules are always promotions that should calculate a discount.
- The checkout & item currency is £.

---

# Design
Each class has a clear, single responsibility, keeping them small & easy to understand.

Classes have simple interfaces by which other classes can communicate with each other, without the need for understanding how things are done in child classes. This keeps classes loosely coupled and therefore more flexible & re-usable.

The same interface is used for all rule types meaning they can be handled in the same way by other classes.

It should be simple to add a new type of promotion by adding a new promo class, following the same interface, and extending the promo calculator's `discounts` method. No other class should need to be amended.

---

### Item
#### Responsibility:
- Keep track of it's price.

---

### Promotions
#### Responsibility:
- Calculating a discount based on a defined requirement.

#### Interface:
All promotions should follow the same interface in order for them to be treated the same by parent classes. They should have the following methods:  
`calculate_discount - returns the value to discount based on a total`  
`requirements_met? - returns a boolean for the condition of the promotion having been achieved or not`  
`type - returns the promo type`  

---

### PromoCalculator
#### Responsibility:
- Perform calculations relating to promos.

---

### Rules
#### Responsibility:
- Grouping promotions together.

---

### Checkout
#### Responsibility:
- Keeping track of scanned items and their total cost.

---
