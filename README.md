# Zumba Class Management System

A web application for managing Zumba class participants and batch assignments built with Jakarta EE.

## Overview

This system allows class owners to manage participants and assign them to morning or evening batches. Participants can view their assignments and see their classmates.

## Features

### Owner Features
- View all participants
- Assign participants to morning/evening batches
- Real-time batch updates

### Participant Features
- View current batch assignment
- See other batch members
- Clear assignment status

## Technology Stack

- **Backend**: Java 21, Jakarta EE, MySQL
- **Frontend**: HTML5, CSS3, JavaScript
- **Build**: Maven
- **Security**: BCrypt password hashing

## Quick Start

1. **Prerequisites**: Java 21+, Maven 3.9+, MySQL 8.0+

2. **Setup Database**:
   ```sql
   CREATE DATABASE zumba_management;
   ```

3. **Configure Environment** (create `.env` file):
   ```env
   DB_URL=jdbc:mysql://localhost:3306/zumba_management
   DB_USERNAME=your_username
   DB_PASSWORD=your_password
   ```

4. **Run Application**:
   ```bash
   mvn clean compile
   mvn jetty:run
   ```

5. **Access**: Open `http://localhost:8080`

## Database Schema

- **users**: Participants (id, name, email, password, user_type)
- **owners**: Class owners (id, name, email, password, access_level) 
- **batch_assignments**: Batch assignments (participant_id, participant_name, batch_type)

## Key Features

- **Secure Authentication**: BCrypt hashing, session management
- **Clean Architecture**: MVC pattern, JSTL templates
- **Responsive Design**: Mobile-friendly interface
- **Performance Optimized**: Connection pooling, efficient queries
