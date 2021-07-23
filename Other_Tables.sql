/* Imported in authors, award recipients, and volunteers successfully. Had to expand several columns to more than 50 characters. On the volunteers table interestingly there were
dates that just didn't make sense i.e. people started in 1900 to volunteer which is definitely not a thing. Went back in and created a filter to eliminate the issue.

Purpose of this SQL code is to add in Member ID columns to each new table (ie authors, award recipient and volunteers) then import in the Member ID from the member identification
table that was made based off the professional members sheet
*/

/*
First thing to do is to add Member ID to each of the new tables: cleaned_authors, cleaned_award_recipients, and cleaned_volunteers
*/

Alter Table cleaned_authors
Add [Member ID] int;

Alter Table cleaned_award_recipients
Add [Member ID] int;

Alter Table cleaned_volunteers
Add [Member ID] int;

/*
Verify this was done for each table.
*/

Select *
from cleaned_authors;

Select *
from cleaned_award_recipients;

Select *
from cleaned_volunteers;

/*
New column Member ID added to all three tables: cleaned_authors, cleaned_award_recipients, and cleaned_volunteers.
Now we need to update each of these tables with the relevant information from the Member_Identification_Table.
*/

/*
Step 1: Adding in Member ID into the cleaned_authors table.

Keep in mind that the cleaned_authors table has a column labeled as "Member" NOT "Name".
The member_identification table has a column labeled as "Name". Important to keep this in mind because each table denotes this
differently.
*/

Update cleaned_authors
set [Member ID] = Member_Identification_Table.[Member ID]
from cleaned_authors inner join Member_Identification_Table
on cleaned_authors.[Member] = Member_Identification_Table.[Name]

Select *
from cleaned_authors;

/*
Verified that authors table is populated with the Member ID. Time to do the cleaned_award_recipients. 

STEP 2: After selecting the TOP 1000 rows in this table, clear that column denoting member names is labeled as "Member" NOT "Name". Will be 
re-using the above SQL statement to populate the correct member ID with the corresponding member. 
*/

Update cleaned_award_recipients
set [Member ID] = Member_Identification_Table.[Member ID]
from cleaned_award_recipients inner join Member_Identification_Table
on cleaned_award_recipients.[Member] = Member_Identification_Table.[Name]

Select *
from cleaned_award_recipients

/*
All rows were populated except Rashidat Balogun. Will investigate further in the cleaned_professional_members table.
*/

Select Name
from cleaned_professional_members
Where Name = 'Rashidat Balogun'

/* After looking up this person, he was not in the professional members table so him not having a Member ID is valid, brings
into question how many members are listed for Permian, but aren't actual members. Is this an error in the system?
*/

/*
Step 3: Time to do the volunteers table! Important to keep in mind the member names are denoted in a column labeled as 
"Name" NOT "Member". Will be using the same update statement, however will need to change the column to "Name".
*/

Update cleaned_volunteers
set [Member ID] = Member_Identification_Table.[Member ID]
from cleaned_volunteers inner join Member_Identification_Table
on cleaned_volunteers.[Name] = Member_Identification_Table.[Name]

Select *
from cleaned_volunteers;

/* Looks good, but going to see if anyone has NULL for Member ID in this table or any of the other tables too */

Select [Member ID]
from cleaned_authors
Where [Member ID] IS NULL

/* This table is ok, no null values */

Select [Member ID]
from cleaned_member_education
Where [Member ID] IS NULL

/* Member Education has a NULL Member ID, will need to investigate*/

Select [Member ID]
from cleaned_award_recipients
Where [Member ID] IS NULL

/*Award Recipients also has a NULL Member ID, may be the same as earlier, but will need to investiage*/

Select [Member ID]
from cleaned_volunteers
Where [Member ID] IS NULL

/* Volunteers table is good, now time to look into Member Education and Award Recipients. */

SELECT [Member]
      ,[Degree]
      ,[Field of Study]
      ,[University]
      ,[Graduation Date]
      ,[Member ID]
from cleaned_member_education
Where [Member ID] IS NULL

/* Looks like it's Kimberly Burgess who had a typo, so will have to fix this... First will check she's in the Member ID Table */

Select Name, [Member ID]
from Member_Identification_Table
Where Name = 'Kimberly Burgess'

/* She has a member ID of 1485, so will need to insert this into the cleaned_member_education table.. TBD*/

/* 
Decided to investigate the award recipients table first before updating the member education table with Kimberley's info.

Trying to target people without member ids. 
*/

Select[Member]
      ,[Year]
      ,[Award]
      ,[Member ID]
from cleaned_award_recipients
Where [Member ID] IS NULL

Select Name, [Member ID]
from Member_Identification_Table
Where Name = 'Rashidat Balogun'

/* Rashidat Balogun does not seem to exist in any of the tables, not sure how he ended up in the award recipients table. May
need to be thrown out. 

Irregardless, first need to update the member education table first */

/*Let's go ahead and hardcode in Kimberly's Member ID since we know it*/

Update cleaned_member_education
set [Member ID] = 1485
Where Member = 's Kimberly Burgess'

/*Verify this worked....*/

SELECT [Member]
      ,[Degree]
      ,[Field of Study]
      ,[University]
      ,[Graduation Date]
      ,[Member ID]
from cleaned_member_education
Where Member = 's Kimberly Burgess'

/*Success! We can try and mess around to see if Kimberly's s could feasibly be removed, but may be more trouble than it's worth...*/

Update cleaned_member_education
set Member = Replace(Member, 's', ' ')
Where [Member ID] = 1485

SELECT [Member]
      ,[Degree]
      ,[Field of Study]
      ,[University]
      ,[Graduation Date]
      ,[Member ID]
from cleaned_member_education
Where [Member ID] = 1485

/* Well that removed the s's in there.... Time to add in the necessary ones back..... Whoops?*/

Update cleaned_member_education
Set Member = 'Kimberly Burgess'
Where [Member ID] = 1485

SELECT [Member]
      ,[Degree]
      ,[Field of Study]
      ,[University]
      ,[Graduation Date]
      ,[Member ID]
from cleaned_member_education
Where [Member ID] = 1485

/*Well that worked. The replace function was totally unnecessary. Would've been faster to just input the member ID the do the update and set statement done above. Oh well 
that's how you learn folks.*/
