# LightningDemo
Working around UAC with PowerShell

The scenario:
You logon to your desktop without administrative rights.
UAC prompts for secondary Admin Credentials on the Secure Desktop.
Your security team has deployed a Privileged credential management tool so:
- You can no longer choose your own password for your admin accounts.
- The generated passwords are long and complex
- The password changes often

The problem:  
How do you enter your managed password when you are prompted on the Secure Desktop?
- The Secure Desktop blocks your view of the password in the Security tool.
- The Secure Desktop blocks your ability to copy, and paste the password from the Security tool into the UAC prompt.
