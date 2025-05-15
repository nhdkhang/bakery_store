Installation Guide
1. Install Python (if it is not installed)
•	Download the latest version of Python from the official website.
•	Run the installer and ensure you check the option to "Add Python to PATH" during installation.
2. Download the Project
•	Download the project’s source code
•	Run the installer and follow the default installation steps
3. Navigate to the Project Directory
•	Open the Command Prompt and change to the project directory (depends on where the project was installed):
cd project
4. Set Up Virtual Environment
•	Create a virtual environment by running:
python -m venv env
•	Activate the virtual environment by using this command line:
env\Scripts\activate
5. Install Project Dependencies
•	Install the required packages using requirements.txt:
pip install -r requirements.txt
6. Set Up the Database
•	The database can be set up by utilising the bakery-database.sql file using MySQL Workbench, 
then either use XAMPP or MySQL Server (both needs to be installed) to access
•	Start the server to make the database working
•	Use the insert-data.sql to add some pre-made data into the webpage
7. Run the Application
•	Start the Flask application by executing:
python app.py
8. Access the Application
•	Open a web browser and go to http://127.0.0.1:5000 to access the application.

Notes:
1 - In the database script, the coordinated data is also provided. Please run your database first before diving into the website.
2 - Due to last-minute modifications, some very small tweaks were left in Vietnamese not English. However, it is assured that these mishaps did not affect the whole system.