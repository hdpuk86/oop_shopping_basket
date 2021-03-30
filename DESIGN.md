# Design
Each class has a clear, single responsibility, keeping them small & easy to understand.

Classes have simple interfaces by which other classes can communicate with each other, without the need for understanding in depth how things are done inside. This keeps classes loosely coupled and are therefore more flexible.

The same interface is used for all promotions meaning they can be handled in the same way by other classes without the need for checking the type of promotion being handled.

It should be simple to add a new type of promotion by adding a new class, following the same promo interface. No other class should need to be amended for the Checkout to handle a new promo if it follows the same patterns.

---

### Item
#### Responsibility:
- Keep track of it's price.

---

### Checkout
#### Responsibility:
- Keeping track of scanned items and their total cost, applying discounts if conditions are met.

---

### Promotion Classes
#### Responsibility:
- Calculating a discount based on a defined requirement.

#### Interface:
All promotions should follow the same interface in order for them to be treated the same by parent classes. They should have the following methods:  
`calculate_discount - returns the amount to be discounted based on a given total`  
`requirements_met? - returns a boolean to indicate whether conditions have been met to activate the promotion`  
