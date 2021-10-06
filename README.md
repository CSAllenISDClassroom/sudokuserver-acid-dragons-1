Team Members: Tariq Mahamid, Sahil Sheth, Anish Saravanan, Grayson Smith, Amy Pham

Our API Uses a couple different requests: 
GET - Retrieve data
POST - Create Data
PUT - Update Data completely 
PATCH - Update Data partially
DELETE - Delete Data

When the user chooses to create a new game:

1)The game begins with multiple levels available. Once the user chooses the level of difficulty, the user will invoke the API with a GET Request (not available for the user to see on view) and a partially completed board by removing certain numbers from cells given the level of difficulty (Harder the difficulty, the more numbers will be removed) which is what the user will see through the view using a PATCH request. 

2) The viewer will then use a controller to manipulate the partially given model by inputting a number into a chosen cell which will in return create a PATCH method to enable the act. The changes can be viewed through the view of the MVC.

3) To compare the inputted number, a GET request will be sent out to retrieve the current state of the board. That board will then be compared to the complete board in the controller of the MVC. If the board is incorrect, the user will be notified with the conflicting numbers on the board that makes the move invalid.

4) If the number was invalid, the user can remove a cell’s value. A blank integer is implemented when you select the desired cell with the controller and implement a different key stroke. The different keystroke invokes a PUT request that will overwrite the cell’s value, returning it to nothing.
