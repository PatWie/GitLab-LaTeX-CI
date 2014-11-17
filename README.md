GitLab - LaTeX CI builder
=========================

Just a small project to automatically build latex projects using GitLab webhooks. 

![example overview](https://raw.githubusercontent.com/PatWie/GitLab-LaTeX-CI/master/demo.jpg "screenshot")



installation
---------------
- copy all files to `/var/www/latex-builder/`.
- make `hook.sh, build.sh` executable
- install php
- change settings in `api.php` (change your secretkey!)

Use `nano /etc/crontab` to add the following line to your crontab:

	*/5 *   * * *   root    cd /var/www/latex-builder/hook/ && /bin/bash ./hook.sh

To insert a job in the processing queue add a webhook in Gitlab

	http://path-to.latex-builder.com/hook/api.php?k=secretkey

You can now wait and see your builds under:

	http://path-to.latex-builder.com/

Therefore, you just need to enter the groupname and projectname. If the GitLab url is
	
	https://gitlab.example.com/admin/example

you need to enter `admin` as groupname and `example` as projectname.