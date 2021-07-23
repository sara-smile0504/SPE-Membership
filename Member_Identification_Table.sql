/****** Script for SelectTopNRows command from SSMS  ******/

/*Code was originally fairl dirty and had prefixes in front of names such as Mr. Mrs. Mr Mrs Dr. etc. This made it hard to tie people across the tables. First thing to be done
was determine each distinc member then create a unique member id in a separate table and apply that same member id to all other relevant tables
*/

 /*Basic query revealed that the primary key is going to have to be created based off the professional member table */
  Select DISTINCT(Name)
  from cleaned_professional_members

/*Re-create the member identification table by first selecting the distinct names then making a new table with them*/
Select Distinct(Name)
INTO Member_Identification_Table
from cleaned_professional_members

/*Add in a new column to the new identification table to create a primary key*/
Alter Table Member_Identification_Table
Add [Member ID] int IDENTITY (1,1) NOT NULL;

Select *
from Member_Identification_Table

/*Verified that this works just fine and all members now have an ID*/
/*Time to create a Member ID column in the cleaned member education and the cleaned professional members table*/

Alter Table cleaned_professional_members
Add [Member ID] int;

Alter Table cleaned_member_education
Add [Member ID] int;

/*Verify this worked for both*/

Select * 
from cleaned_member_education;

Select *
from cleaned_professional_members;

/*It did work, now we need to update the new columns with the appropriate member id. Let's start with cleaned_member_education */

Update cleaned_member_education
set [Member ID] = Member_Identification_Table.[Member ID]
from cleaned_member_education inner join Member_Identification_Table
on cleaned_member_education.[Member] = Member_Identification_Table.[Name]

/*Verify this worked*/
Select *
from cleaned_member_education

/*Time to do the same thing in the cleaned_professional members table as well since the member id is blank still*/
Update cleaned_professional_members
set [Member ID] = Member_Identification_Table.[Member ID]
from cleaned_professional_members inner join Member_Identification_Table
on cleaned_professional_members.[Name] = Member_Identification_Table.[Name]

Select *
from cleaned_professional_members

/*Verified all the names now have a unique identifier so we can now start sifting through this data. May decided to pull in the other data later, however that could change depending
on analysis*/