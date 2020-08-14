This app is created to help students to reflect on their grasp of lecture content as well as to reflect on their notetaking skills. Students,individuals or in groups, are able to paste their lecture notes into a Google Sheet prepared by the teacher. These notes are then compared to another Google Sheet containing keyword of a certain lecture. The output in the app interface includes the keywords each student or group hits and misses. Students can use it to revisit the course content and make sure they fully grasp the key points in a lecture. The results, unless the teacher resets the Google Sheet in the app, are also saved into the Google Sheet by the side of each note so students can make future references to it. The app also provides the overall hit rate for each keyword so the teacher can adjust their lecture to emphasize on frequently-missed content.

Please follow the instructions closely as I do not intend to write more code for various user interaction senarios.
*************
BEFORE THE CLASS
1. Create a Google Sheet for students' notes. Rename the worksheet according to your course content such as "Ch1," "Ch2" or "Introduction," "Fundamental Concepts," etc. In each worksheet, input students' or groups' names in the "names" column. The corresponding cell in the "Note" column is for them to paste their notes. (you can make a copy of the notes template: https://docs.google.com/spreadsheets/d/1WzEXtEhCJjOvreoizkuv6z-Gi3HJRy801IBpE4_kHlo/edit?usp=sharing). Share the Google Sheet with the choice of "Anyone on the internet with this link can edit." This link will be your notes sheet link.

2. Create another Google Sheet for the keywords. Rename the worksheet according to your course content such as "Ch1," "Ch2" or "Introduction," "Fundamental Concepts," etc. !!!IMPORTANT!!! These worksheet names must be exactly the same as those in the Google Sheet of notes, so the program can match them. In each worksheet, type one keyword of that lecture/section of your course in the first row of each column. Below each keyword, you can type in as many variations of the keyword you want, each in a cell in the same row. There is no limit on the number of keywords or their variations in each worksheet. (Please see the template at https://docs.google.com/spreadsheets/d/17ZGVVGbd8BJAFbjh79oKVAP3UIGcWit83g9G7n3q7Yw/edit?usp=sharing). Share your Keyword sheet as "Anyone on the internet with this link can view." 

3. You should have R Studio or other R console. If you haven't, use Install.packages("Shiny") and Intall.packages("Googlesheet4) to install the packages needed for this app.

***************
IN CLASS
1. Share the Google Sheet link to the notes with your students and ask them to paste/type their notes or keywords into the cell in the "notes" column corresponding to their names.

2. Once the students are finished, load the app in R Studio either by opening the app.R script file in the environment or double click it in your operating system.

2. Click "Run App" in the script window.

3. Paste the link to the Google sheet links of the notes and the keywords into corresponding textboxes in the app interface.


4. Click "Read Data." You may be prompted to login with your Google account in R studio (not in the app interface).

5. The list of worksheets will be listed in the dropdown menu. Choose the one course content you are working on.

6. Click "Run" and the result of students' hits and misses will show up in the "Notes Stats" tab and the hit rates of keywords will show up in the "Keywords Stats" tab. The Google Sheet of notes will also be populated with the results corresponding to each student/group. 

7. You can click "Reset" to clear the inputs and results (both in the app interface and the Google Sheet of notes) for the next use.
************************
Thank you very much for your interest and I hope this helps your students learn better. 
For any question, please contact me at cuix"AT"cofc"DOT"edu.