##Transfomation performed to convert raw test data and train data into one tiny dataset

Step 1: Read the activity_labels.txt file in a dataframe. Name the 2 columns as activity_id and activity.

Step 2: Read the feature.txt file in a dataframe, make a list of column names for the measure dataset using the 
        2nd column of featureTable.
        
Step 3: Read data, activity and subject for test dataset.

Step 4: Read data, activity and subject for training dataset.

Step 5: Make a list of the cloumns names with mean() and std()

Step 6: Take subset of only the cloumns intersted, from both test & train dataset.

Step 7: Add column, subject and activity to the subset of measure data and bind the two datasets together, now we have
        one combined raw dataset.
        
Step 8: Replace the activity id by activity description in the combined raw dataset.

Step 9. Use the melt function to define all the colums as measure column except Subject id and activity.

Step 10. use dcast function from reshape2 package to take mean of all the measures by subject id and activity.

Step 11. Write the data into a tidy data set.
