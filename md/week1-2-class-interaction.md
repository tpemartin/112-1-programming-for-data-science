# 2 Class interaction

In each class we will visit an online material like this one. There are contexts and codes in the material. To learn and interact properly, you need to follow the instructions below.

  * Setup practice folder. 
  * Create R script file in the practice folder for each class.  
  * Backup your practice folder to GitHub after each class.  

## 2.1 Setup practice folder  

A practice folder is a folder that you will use to store your practice files and 

  * is under version control, and
  * is an R project.

### a. Create a folder

Create a folder, say named `r-4-data-science` in your computer. This folder will be used to store your practice files. You can create the folder anywhere you want. Just remember:  
  
  * Avoid a directory that contains spaces or special characters. （不要有中文，空白，或特殊符號(`- _`除外的符號）在儲存資料匣的路徑)  
  * Avoid a network or shared drive. (不要存在One Drive, Google Drive, Dropbox, 等等)  
  * Avoid a directory that requires elevated privileges. (不要存在需要管理員權限的資料匣)  

### b. Setup version control

Use Github Desktop to setup version control for the folder. The folder chosen will be called a **repository**.  

  1. Launch Github Desktop.  
  2. Click "File" in the menu bar.  
  3. Click "Add Local Repository".  
  4. Select the folder you created in step a.  
  5. Click "Create Repository".
   ![](../img/Create%20repository.png)
  6. Click "Publish Repository".  
   ![](../img/publish%20repo.png)
   Make sure **keep this code private** is NOT checked.
   ![](../img/publish%20repo2.png)
    7. Click "Publish Repository" again.
    8. You're done!

You can click **View on Github** to see your repository on Github.com.
![](../img/view%20on%20gh.png)

### c. Setup R project  

 1. Launch RStudio.  
 2. Click "File" in the menu bar.  
 3. Click "New Project".  
 4. Click "Existing Directory".  
 5. Click "Browse".  
 6. Select the folder you created in step a.  
 7. Click "Create Project".  
 8. You're done!

> Don't worry that your RStudio look different from mine. We will fine tune it later.

## 2.2 Create R script file in the practice folder for each class

In each class, you will 

  1. Launch RStudio.   
  2. Click "File" in the menu bar.
  3. Click "New File".  
  4. Click "R Script".  
  5. Click ![](../img/Save.png) to save file.  


During the class, you will type codes in the R script file. You can save the file at any time. You can also run the codes in the file at any time. We will learn how to run codes in the next class.

For example:  

```r
install.packages("tidyverse")
```

## 2.3 Backup your practice folder to GitHub after each class   

At the end of each class, you will backup your practice folder to GitHub.  

  1. Launch Github Desktop.  
  2. Click "Changes" in the menu bar.  
  3. Type a summary in the "Summary" field.  
  4. Click "Commit to main".  
  5. Click "Push origin".  
  6. You're done!


## Not my computer

Suppose you are using school computer or other people's computer but later you want to use your own computer. 

As long as each time you have backed up to Github, you can download your repository from Github.com to any computer

 1. Launch Github Desktop.  
 2. Click "File" in the menu bar.  
 3. Click "Clone Repository".  
 4. Click "URL".  
 5. Copy the URL of [your repository from Github.com](https://github.com/tpemartin/112-1-r-4-data-science).  
   ![](../img/clone%20repo.png)
 6. Paste the URL in the "URL" field.  
 7. Click "Choose..." to select a folder to store your repository.  
 8. Click "Clone".  
 9.  You're done!

Then launch RStudio and open the R project in the folder you selected in step 7. You can continue your work.