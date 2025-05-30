# User management using Linux command, how to use this script

# Comprehensive shell script for user management in Ubuntu. It allows you to create, delete, list, and manage users with proper checks. 

# The script ensures:
-	Users cannot create duplicate accounts.
-	Deleting users confirms the action.
-	Passwords are set securely.
-	Users can be added to specific groups.
-	It includes a help menu.


# Features:

-	Create users with a home directory and password.
-	Delete users after confirmation.
-	List all users.
-	Lock/unlock users.
-	Add users to groups.


# How to use the script:

1.	Make the script executable:
chmod +x user_management.sh
2.	Run the script as root:
sudo ./user_management.sh
3.	Follow the on-screen prompts to create, delete, list, lock, or unlock users.

# Security & Best Practices
-	The script ensures only root users can manage accounts.
-	Passwords are set securely.
-	Users are prompted before deletion to avoid accidental removals.
-	Users can be added to groups during creation.

# Real-World Scenario: User Management in an Organization Using This Scrip:

In an organization, managing users efficiently is crucial for security, compliance, and operational continuity. This script can be used by system administrators and DevOps engineers to create, delete, manage, and control access to user accounts in a structured and secure manner.

# Scenario: User Lifecycle Management in a Company

# 1️. New Employee Joins the Company
Example: A new DevOps Engineer named David Mark joins the company, and HR informs IT that he needs access.
- IT Admin uses the script to create a user:
sudo ./user_management.sh
-	Selects option 1 (Create a new user).
-	Enters the username: davidmark            # depending on company naming convention
-	Sets a password.
-	Adds David to the devops group.
# Outcome:
-	David now has a home directory /home/davidmark.
-	He's added to the devops group, so he has appropriate permissions.
-	He can now log in and start working.

# 2️. Temporary User Access for Contractors
Example: A contractor (Boeing) joins the team for 2 months to work on a security audit.
- IT Admin creates a temporary user:
-	Runs the script and creates boeing_temp.
-	Adds Boeing to the security group.
-	Uses chage to set an expiration date for the user: 

sudo chage -E 2024-07-10 boeing_temp
-	This ensures his access is automatically revoked after 2 months.
# Outcome:
-	Boeing can work without the risk of forgetting to remove his account later.
-	IT can audit and control temporary access effectively.

# 3️. Employee Leaves the Company (User Deletion)
Example: Alex Müller resigns from the company.
- IT Admin uses the script to delete Alex's account:
sudo ./user_management.sh
-	Selects option 2 (Delete a user).
-	Confirms deletion.
# Outcome:
-	Alex’s user account is completely removed, along with his home directory.
-	Prevents ex-employees from accessing company resources



# 4️. Security Measures: Locking and Unlocking Accounts
Example 1: John from Finance is on a 2-month leave.
-	Instead of deleting his account, IT locks it: 

sudo ./user_management.sh
-	Selects option 4 (Lock a user).
-	Enters john.
# Outcome: John's account is locked until he returns.
Example 2: When John returns, IT unlocks his account:
sudo ./user_management.sh
-	Selects option 5 (Unlock a user).
# Outcome: John can log in again without recreating his account.

# 5️. Security & Compliance: Listing Users
To audit user accounts and find unauthorized users:
sudo ./user_management.sh
-	Selects option 3 (List all users).
-	Admin can check for orphaned accounts (users who no longer work in the company).
# Outcome: Ensures only valid employees have access to the system.
