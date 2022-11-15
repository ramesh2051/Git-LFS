# Managing Large Files Storage with Git LFS:

Git was originally designed for small file storage. However, in some scenarios, uploading some large files is inevitable. Git Large File Storage (Git-LFS) was invented to make large file storage on Git fast and reliable. Git LFS can be used when you want to version large files, usually, valuable output data, which is larger than GitHub limit (100Mb). These files can be plain text or binaries. 

In this Blog you will see the Configuration of Git-LFS and how Git LFS fits into your current workflow, whether you use 
1.	GitHub’s web interface
2.	Command line
3.	GitHub Desktop application
## Configuring Git Large File Storage:
**Step-1:** Open Git Bash Download the Git LFS, before that first you need to install Git and then install the Git-LFS.
   
   ![image](https://user-images.githubusercontent.com/95218310/201887121-43ed2c41-6759-4b96-acb6-207f2f647e30.png)

**Step-2:** After you download and install Git LFS, you can start managing large files in a Git repository by running `git lfs track <your-file>`, where <your-file> is a command-line glob specifying a particular file, extension, directory, or any combination. Git LFS writes these globs to a `.gitattributes` file in your repository that Git uses to pre-process files as they move back and forth from your working directory to your index and commit history.
   
   ![image](https://user-images.githubusercontent.com/95218310/201887255-2c3446ee-9943-48f2-bdf8-2ab86a1c8800.png)

**Step-3:** Once you tell Git LFS which files and paths to manage, you can `stage`, `commit`, and `push` just like you normally would; Git LFS handles all the details for you. When you run git push, you’ll notice a progress indicator showing the transfer status of each file as Git LFS uploads it to the LFS server.
   
   ![image](https://user-images.githubusercontent.com/95218310/201887341-d83f0a3f-b6cc-4218-b64a-d0509dc2492b.png)

**Step-4:** If you ever need to find out which paths Git LFS is managing, you can run `git lfs track` with no arguments. You’ll get an output of all the tracking rules from the globs listed in the `.gitattributes` file. For a deeper view of which specific files these globs are catching, you can run `git lfs ls-files` to see a listing of all the files in your project that Git LFS is managing.
  
   ![image](https://user-images.githubusercontent.com/95218310/201887393-f8850ded-4537-4d6e-95cc-861b65ca20af.png)
   

## How to Clone the Repo contains large file storage: 
-	To download the Git repository containing large files, please make sure that Git-LFS was installed beforehand. 
-	Otherwise, the repository you cloned will only contain the shortcuts of the large files. Installing of Git-LFS after the repository was cloned will not help. `git      pull` and `git fetch` will not automatically replace the shortcuts to large files for you. 
-	If you have already cloned the repository, just delete the repository, make sure Git-LFS is correctly installed, and clone again. 
-	In this way, the large files will be cloned correctly.

## Benefits of using Git-LFS:
-	Git LFS is a Git extension that allows users to save space by storing binary files in a different location.
-	Every GitHub account using Git Large File Storage receives 1 GB of free storage and 1 GB a month of free bandwidth.

## Reference Links:
-	[Git-LFS Public repo](https://github.com/git-lfs/git-lfs/wiki/Tutorial#create-a-new-repo)
-	[Managing billing for Git Large File Storage in GitHub](https://docs.github.com/en/billing/managing-billing-for-git-large-file-storage)
