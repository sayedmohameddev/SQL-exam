
Use Library


--1. Write a query that displays Full name of an employee who has more than 3 letters in his/her First Name
Select CONCAT_WS
(' ',Fname,Lname) 'FullName'

From Employee
Where LEN(Fname) > 3 and Fname is not NULL and Lname is not NULL

--2. Write a query to display the total number of Programming books available in the library with alias name ‘NO OF PROGRAMMING BOOKS


Select COUNT(Id) 'NO OF PROGRAMMING BOOKS'
From Book
Where Cat_id = 1

--OR

Select COUNT(BO.Id) 
'NO OF PROGRAMMING BOOKS'
From Book BO, Category Cat
Where BO.Cat_id = Cat.Id and Cat.Cat_name = 'Programming'

--3. Write a query to display the number of books published by (HarperCollins) with the alias name 'NO_OF_BOOKS'
Select COUNT(Bo.Id)
'NO_OF_BOOKS'

From Book Bo,Publisher Pub
Where Pub.Id = Bo.Publisher_id and Pub.Name = 'HarperCollins'


--4. Write a query to display the User SSN and name, date of borrowing and due date  of the User whose due date is before July 2022
Select Us.SSN, Us.User_Name,
Bor.Borrow_date, Bor.Due_date

From Users Us, Borrowing Bor
Where Us.SSN = Bor.User_ssn and Bor.Due_date < '2022-07-01'



--5. Write a query to display book title, author name and display in the following format, [Book Title] is written by [Author Name]
Select CONCAT_WS(' ',Bo.Title,'is written by',Auth.Name)
'Written by'

From Book Bo,Author Auth,Book_Author BoAuth
Where Auth.Id = BoAuth.Author_id and Bo.Id = BoAuth.Book_id


--6. Write a query to display the name of users who have letter 'A' in their names
Select User_Name

From Users
Where User_Name like '%A%'



--7. Write a query that display user SSN who makes the most borrowing
Select Top(1) Us.SSN, COUNT(Bor.User_ssn) as 
'CountOfBorrow'

From  Users Us,Borrowing Bor
Where Us.SSN = Bor.User_ssn
Group by Us.SSN
Order By CountOfBorrow Desc


--8. Write a query that displays the total amount of money that each user paid for borrowing books

Select Distinct Us.SSN, Us.User_Name ,SUM(Bor.Amount) Over
(Partition By Us.SSN) 
'TotalMoneyForBorrowing'

From Users Us, Borrowing Bor
Where Us.SSN = Bor.User_ssn

--OR

Select Us.SSN, Us.User_Name ,

SUM(Bor.Amount) 'TotalMoneyForBorrowing'

From Users Us, Borrowing Bor
Where Us.SSN = Bor.User_ssn
Group By Us.SSN, Us.User_Name


--9. write a query that displays the category which has the book that has the minimum amount of money for borrowing
Select Top(1)Cat.Id,Cat.Cat_name,
MIN(Bor.Amount) 'MinBookMoney'

From Book B,Category Cat, Borrowing Bor

Where B.Cat_id = Cat.Id and B.Id = Bor.Book_id
Group By Cat.Id,Cat.Cat_name
Order By MinBookMoney

--OR

Select Top(1)Cat.Id,Cat.Cat_name, Bor.Amount

From Book B,Category Cat, Borrowing Bor
Where B.Cat_id = Cat.Id and B.Id = Bor.Book_id
Order By Bor.Amount



--10.write a query that displays the email of an employee if it's not found,display address if it's not found, display date of birthday

Select ISNULL(Email,ISNULL(Address,DOB)) 'EmailOrAddressOrDOB'
From Employee

--11. Write a query to list the category and number of books in each category with the alias name 'Count Of Books'

Select Cat.Cat_name,COUNT(B.Id) 'Count Of Books'

From Category Cat,Book B
Where B.Cat_id = Cat.Id
Group By Cat_name


--12. Write a query that display books id which is not found in floor num = 1 and shelf-code = A1

Select B.Id
From Book B, Floor F, Shelf S
Where B.Shelf_code = S.Code and F.Number = S.Floor_num and B.Shelf_code != 'A1' and F.Number != 1  --XXXXXXXX


--13.Write a query that displays the floor number , Number of Blocks and number of employees working on that floor
Select F.Number,F.Num_blocks, 
COUNT(E.Id) 'EmpsWorkOnTheFloor'

From Floor F, Employee E
Where E.Floor_no = F.Number
Group By F.Number,F.Num_blocks



--14.Display Book Title and User Name to designate Borrowing that occurred within the period ‘3/1/2022’ and ‘10/1/2022’

Select B.Title, U.User_Name

From Book B, Users U, Borrowing Bor
Where U.SSN = Bor.User_ssn and B.Id = Bor.Book_id and Bor.Borrow_date between '3/1/2022' and '10/1/2022'



--15.Display Employee Full Name and Name Of his/her Supervisor as Supervisor Name

Select CONCAT_WS(' ',Emp.Fname,Emp.Lname)'EmpFullName',
CONCAT_WS(' ',Sup.Fname,Sup.Lname)'SupFullName'

From Employee Emp, Employee Sup
Where Emp.Super_id = Sup.Id


--16.Select Employee name and his/her salary but if there is no salary display Employee bonus

Select CONCAT_WS(' ',Fname,Lname)'FullName',ISNULL(Salary,Bouns)'SalaryOrBouns'
From Employee


--17.Display max and min salary for Employees

Select MAX(Salary) 'MaxSalary',

MIN(Salary)'MinSalary'
From Employee
GO



--18.Write a function that take Number and display if it is even or odd 

Create Or Alter Function IsEvenOrOdd (@Number int)
Returns varchar(max)
With Encryption
As
Begin
	Declare @Result varchar(max)
	If @Number % 2 = 0
		Begin
			Set @Result = 'Even'
		End
	Else
		Begin
			Set @Result = 'Odd'
		End
	Return @Result
End
GO
Select dbo.IsEvenOrOdd(6)'IsEvenOrOdd'
Go


--19.write a function that take category name and display Title of books in that category

Create Or Alter Function GetBooksByCatName (@CatName varchar(max))

Returns @TableResult Table(BookName varchar(max))
With Encryption
As
Begin
	Insert Into @TableResult
	Select BookName = B.Title
	From Book B, Category C
	Where C.Id = B.Cat_id and C.Cat_name = @CatName
	Return
End
Go


Select * from  dbo.GetBooksByCatName('Mathematics')
GO




--20. write a function that takes the phone of the user and displays Book Title , user-name,amount of money and due-date    

Create Or Alter Function GetBookByUserPhone (@PhoneNum varchar(max))

Returns Table 
With Encryption
Return (
Select B.Title,U.User_Name,Bor.Amount,Bor.Due_date
From Book B ,User_phones UP,Users U,Borrowing Bor
Where U.SSN = UP.User_ssn and U.SSN = Bor.User_ssn and B.Id = Bor.Book_id and UP.Phone_num = @PhoneNum )
Go



Select * From dbo.GetBookByUserPhone('0120321455')
GO





--21.Write a function that take user name and check if it's duplicated return Message in the following format ([User Name] is Repeated [Count] times)

Create Or Alter Function UserNameDuplicatedCheck (@UserName varchar(max))

Returns varchar(max)
With Encryption
As
Begin
	Declare @CheckMSG varchar(max)
	Declare @RepetedCount int

	Select @RepetedCount = COUNT(User_Name)
	From Users
	Where User_Name = @UserName
	If @RepetedCount =  1
		Set @CheckMSG = CONCAT_WS(' ',@UserName,'is not duplicated')
	Else If @RepetedCount > 1
		Set @CheckMSG = CONCAT_WS(' ',@UserName,'is Repeated', @RepetedCount,'Times')
	Else 
		Set @CheckMSG = CONCAT_WS(' ',@UserName,'is Not Found')
	Return @CheckMSG
End
GO
Select dbo.UserNameDuplicatedCheck('Amr Ahmed')
GO





--22.Create a scalar function that takes date and Format to return Date With That Format

Create Or Alter Function FormatedDate(@Date date,@Format varchar(max))

Returns varchar(max)
With Encryption
As
Begin
	Declare @Result varchar(max)
	Set @Result = FORMAT(@Date,@Format)
	Return @Result
End
GO
Select dbo.FormatedDate(GETDATE(),'MMMM') 
Go




--23.Create a stored procedure to show the number of books per Category

Create Or Alter Procedure Sp_BookNumByCat
With Encryption
As
	Select Cat_id,COUNT(Id)'BookCount'
	From Book
	Group By Cat_id
Go
Exec Sp_BookNumByCat
Go

--24.Create a stored procedure that will be used in case there is an old manager 

Create Or Alter Procedure Sp_NewEmpComeAndOldLeave @OldEmpId int,@NewEmpId int, @FloorNum int
With Encryption
As
	Update Floor
		Set MG_ID = @NewEmpId
		Where MG_ID = @OldEmpId and Number = @FloorNum
GO
Exec Sp_NewEmpComeAndOldLeave 4,1,3
GO


--25.Create a view AlexAndCairoEmp that displays Employee data for users who live in Alex or Cairo
Create Or Alter View EmpsLiveInAlexCairo
With Encryption
As
	Select *
	From Employee
	Where Address in ('Alex','Cairo')
GO
Select * From EmpsLiveInAlexCairo
GO

--26.create a view "V2" That displays number of books per shelf 


Create Or Alter View V2
With Encryption
As
	Select Shelf_code, 
	COUNT(Id) 'CountOfBooks'
	From Book
	Group By Shelf_code
Go

Select * From V2 Order By CountOfBooks Desc
Go

--27.create a view "V3" That display  the shelf code that have maximum number of  books using the previous view "V2"


Create Or Alter View V3
With Encryption 
As
	
	Select * From
	(Select *, DENSE_RANK() Over (Order By CountOfBooks Desc)'RN'
	From V2) As RankedTable
	Where RN = 1

GO

Select * From V3
GO

--28.Create a table named ‘ReturnedBooks’ With the Following Structure :then create A trigger that instead of inserting the data of returned book 


Create Table ReturnedBooks (
UserSSN int,
BookID int,
DueDate Date,
ReturnDate Date,
Fees int
)
GO
--B. Create Trigger
Create Or Alter Trigger AddingFeesOrNot
On ReturnedBooks
Instead of Insert
As
Begin
    Declare @DueDate Date
    Declare @ReturnDate Date
    Declare @Amount Money
    Declare @UserSSN int
    Declare @BookID int

    Select 
        @DueDate = DueDate, 
        @ReturnDate = ReturnDate,
        @UserSSN = UserSSN,
        @BookID = BookID
    From inserted

    If @ReturnDate <= @DueDate
    Begin
        Insert Into ReturnedBooks(UserSSN, BookID, DueDate, ReturnDate, Fees)
        Values (@UserSSN, @BookID, @DueDate, @ReturnDate, 0)
    End
    Else
    Begin
        Select @Amount = Amount
        From Borrowing
        Where User_ssn = @UserSSN 
          And Book_id = @BookID

        Insert Into ReturnedBooks(UserSSN, BookID, DueDate, ReturnDate, Fees)
        Values (@UserSSN, @BookID, @DueDate, @ReturnDate, @Amount * 0.2)
    End
End
GO
Disable Trigger PreventDMLinEmp On Employee
Enable Trigger PreventDMLinEmp On Employee

Insert Into Floor(Number, Num_blocks, MG_ID, Hiring_Date)
Values (9, 2, 17, CAST(GETDATE() AS DATE))

Go
Insert Into ReturnedBooks(UserSSN,BookID,DueDate,ReturnDate)
Values(17,6,'11/25/2024','12/12/2024')
GO

Insert Into ReturnedBooks(UserSSN,BookID,DueDate,ReturnDate)
Values(1,3,'9/27/2024',GETDATE())
GO



--29.In the Floor table insert new Floor With Number of blocks 2 , employee with SSN = 20 as a manager for this Floor,The start date for this manager is Now. Do what is required if you know that : Mr.Omar Amr(SSN=5) 

Insert Into Floor(Number,Num_blocks,MG_ID,Hiring_Date)
Values(20,2,19,Convert(varchar(max),FORMAT(GETDATE(),'yyyy-MM-dd')))

--Make ali mohamed ssn 12 manager for floor
Update F
	Set MG_ID = 12
	From Floor F
	Where MG_ID = 5

-- Move Omar Amr To Be manager for floor 6
Update Floor
	Set MG_ID = 5
	Where Number = 6
GO



---30.Create view name (v_2006_check)  that will display Manager id, Floor Number where he/she works , Number of Blocks and the Hiring Date 

Create Or Alter View V_2006_Check
With Encryption
As
	Select MG_ID,Number,Num_blocks,Hiring_Date
	From Floor
	Where Hiring_Date between '12/12/2024' and '12/12/2024' With Check Option
GO

Select * From V_2006_Check
GO

Insert Into V_2006_Check
Values
(2,8,2,'08/08/2024')
GO

--31.Create a trigger to prevent anyone from Modifying or Delete or Insert in the Employee table ( Display a message for user to tell him that he can’t 


Create Or Alter Trigger PreventDMLinEmp
On Employee
With Encryption
Instead of Update,Delete,Insert
As
	Select 'You can’t take any action with this Table ->'
GO
Insert Into Employee(Fname,Lname,Floor_no,Address,Bouns,DOB,Email,phone,Salary,Super_id)
Values('sayed','mohamed',7,'Cairo',300,'14/08/2005',Null,01150778216,2000,1)

Update Employee
	Set Super_id = 1
	Where Id = 12

Delete From Employee
	Where Id = 12

--32.Testing Referential Integrity , Mention What Will Happen When: 
--A. Add a new User Phone Number with User_SSN = 50 in User_Phones Table


Insert Into Users(SSN,User_Name,User_Email,Emp_id)
Values(50,'sayed mohamed','sayedmohameddev@gmail.com',12)

--Then insert phone in user_phone table
Insert Into User_phones(User_ssn,Phone_num)
Values(50,01150778216)
GO

--Disabling trigger PreventDMLinEmp
Disable Trigger PreventDMLinEmp On Employee	


--Start Update

--1. made the Identity column isertion acceptable
Set Identity_Insert Employee On

--2. insert the same date of emp 20 but with id 21
Insert Into Employee(Id,Fname,Lname,Email,phone,Salary,Address,Bouns,DOB,Floor_no,Super_id)

Select 21,Fname,Lname,Email,phone,Salary,Address,Bouns,DOB,Floor_no,Super_id

From Employee
Where Id = 20

--3. Update the floor & Users & Borrowing that have empId as a Foriegn Key & Emp.Super That have the Emp Id
Update Floor
	Set MG_ID = 21
	Where MG_ID = 20


Update Users
	Set Emp_id = 21
	Where Emp_id = 20


Update Borrowing
	Set Emp_id = 21
	Where Emp_id = 20


Update Employee
	Set Super_id = Null
	Where Super_id = 20


--4. Delete Emp 20
Delete From Employee
Where Id = 20


--C. Delete the employee with id 1

--1. Update the floor that have empId as a Foriegn Key
Update Floor
	Set MG_ID = Null
	Where MG_ID = 1

Update Borrowing
	Set Emp_id = Null
	Where Emp_id = 1


UPDATE Employee
SET Super_id = 20
WHERE Super_id = 1

ALTER TABLE Employee
ALTER COLUMN Super_id INT NULL

DELETE FROM Users
WHERE Emp_id = 1;


ALTER TABLE Floor
DROP CONSTRAINT FK_Floor_Employee; 

ALTER TABLE Floor
ADD CONSTRAINT FK_Floor_Employee
FOREIGN KEY (MG_ID)
REFERENCES Employee(Id)
ON DELETE SET NULL;



Update Floor
	Set MG_ID = 2
	Where MG_ID = Null

Update Borrowing
	Set Emp_id = 2
	Where Emp_id = Null


UPDATE Employee
SET Super_id = 2
WHERE Super_id = Null

UPDATE Users
SET Emp_id = 2
WHERE Emp_id = 1

DELETE FROM Employee
WHERE Id = 1;


--D. Delete the employee with id 12 
Update Floor
	Set MG_ID = 2
	Where MG_ID = 12

Update Borrowing
	Set Emp_id = 2
	Where Emp_id = 12


UPDATE Employee
SET Super_id = 2
WHERE Super_id = 12

UPDATE Users
SET Emp_id = 2
WHERE Emp_id = 12


Delete From Employee
Where Id = 12          
GO



--E. Create an index on column (Salary) that allows you to cluster the data in table Employee
Go
Create NonClustered Index IX_Salary
On Employee(Salary)

Select *
From Employee
Where Salary = 6000





--33.Try to Create Login With Your Name And give yourself access Only to 
--Employee and Floor tables then allow this login to select and insert data 
--into tables and deny Delete and update (Don't Forget To take screenshot

