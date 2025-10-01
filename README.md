# Amazon Clone - Cross-Platform E-Commerce Mobile App

An extensive, full-stack e-commerce application built to replicate the core features and functionality of Amazon, providing a seamless shopping experience across mobile platforms.

This project was developed using **Flutter** for the cross-platform frontend and **Node.js/Express** for a robust, scalable backend, with **MongoDB** as the primary database.

## 🚀 Key Features

### User-Facing Features
* **Secure Authentication:** User sign-up, sign-in, and session management[cite: 14].
* **Product Catalog:** Comprehensive product search, categorization, and browsing[cite: 13].
* **Deal of the Day:** Dedicated section for daily featured discounts[cite: 13].
* **Shopping Cart:** Add, update, and remove items with persistent storage[cite: 13].
* **Ratings & Reviews:** Functionality for users to rate and review products[cite: 13].
* **Order Tracking:** Real-time status updates for placed orders[cite: 14].
* **Integrated Checkout:** Seamless checkout experience with **GPay integration** for secure payments[cite: 15].

### Admin Panel Features
* **Order Management:** Full access to view, process, and update the status of all customer orders[cite: 14].
* **Sales Dashboard:** Visual representation of business metrics, including:
    * Total Sales over time[cite: 16].
    * Category-wise Sales Graphs for product performance analysis[cite: 16].
* **Product CRUD:** Tools for creating, viewing, updating, and deleting products.

## 💻 Tech Stack

| Component | Technologies Used |
| :--- | :--- |
| **Frontend (Client)** | **Flutter**, **Dart**, **Provider** (State Management) |
| **Backend (Server)** | **Node.js**, **Express.js** |
| **Database** | **MongoDB**, **Mongoose** (ODM) |
| **Payments** | **Google Pay (GPay)** API Integration [cite: 15] |
| **Authentication** | JWT (JSON Web Tokens) for secure Auth [cite: 14] |

## ⚙️ Project Structure

This project is split into two separate repositories:

| Repository | Description | Link |
| :--- | :--- | :--- |
| **Frontend** | The cross-platform mobile application built with Flutter. | `https://github.com/karanshrma/amazon_flutter_clone` |
| **Backend** | The API server built with Node.js, Express.js, and MongoDB. | `https://github.com/karanshrma/server` |

## 🛠️ Setup and Installation

### 1. Backend Setup

1.  **Clone the backend repository:**
    ```bash
    git clone [https://github.com/karanshrma/server.git](https://github.com/karanshrma/server.git)
    cd server
    ```
2.  **Install dependencies:**
    ```bash
    npm install
    ```
3.  **Configure environment variables:**
    Create a `.env` file in the root directory and add your MongoDB connection string and other necessary keys (e.g., JWT secret, port).
4.  **Run the server:**
    ```bash
    npm start
    ```
    The server will typically start on port `3000`.

### 2. Frontend Setup

1.  **Clone the frontend repository:**
    ```bash
    git clone [https://github.com/karanshrma/amazon_flutter_clone.git](https://github.com/karanshrma/amazon_flutter_clone.git)
    cd amazon_flutter_clone
    ```
2.  **Install Flutter dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Update the API URL:**
    Locate the configuration file (e.g., `constants.dart` or similar) in the project and update the base URL to match your running backend server (e.g., `http://<your-ip-address>:3000`).
4.  **Run the app:**
    Connect a device or start an emulator/simulator and run the application.
    ```bash
    flutter run
    ```
