From: Felix Blanke <felixblanke@gmail.com>
Subject: Re: [PATCH] Add the "btrfs filesystem label" command
Date: Wed, 15 Sep 2010 15:18:21 +0200
Message-ID: <4C90C79D.5030909@gmail.com>
References: <201009132124.14402.kreijack@inwind.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201009132124.14402.kreijack@inwind.it>
List-ID: <linux-btrfs.vger.kernel.org>

Worked like it should for me :)


Thanks a lot for your work.
I hope this patch will be merged soon.

Like G.Baroncelli says: It's such an essential feature.

Regards,
Felix


Goffredo Baroncelli schrieb:
> Hi all,
> 
> this patch adds the command "btrfs filesystem label" to change (or show) the 
> label of a filesystem.
> This patch is a subset of the one written previously by Morey Roof. I 
> included the user space part only. So it is possible only to change/show a 
> label of a *single device* and *unounted* filesystem.
> 
> The reason of excluding the kernel space part, is to simplify the patch in 
> order to speed the check and then the merging of the patch itself. In fact I 
> have to point out that in the past there was almost three attempts to propose 
> this patch, without success neither complaints.
> 
> Chris, let me know how you want to proceed. I know that you are very busy, 
> and you prefer to work to stabilize btrfs instead adding new feature. But I 
> think that changing a label is a *essential* feature for a filesystem 
> managing tool. Think about a mount by LABEL.
> 
> 
> To show a label
> 
> $ btrfs filesystem label <device>
> 
> To set a label
> 
> $ btrfs filesystem label <device> <newlabel>
> 
> Please guys, give a look to the source. 
> Comments are welcome.
> 
> You can pull the source from the branch "label" of the repository 
> http://cassiopea.homelinux.net/git/btrfs-progs-unstable-all.git
> 
> Regards
> G.Baroncelli
> 
> diff --git a/Makefile b/Makefile
> index 525676e..c06e512 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -4,7 +4,7 @@ CFLAGS = -g -Werror -Os
>  objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
>  	  root-tree.o dir-item.o file-item.o inode-item.o \
>  	  inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o \
> -	  volumes.o utils.o btrfs-list.o
> +	  volumes.o utils.o btrfs-list.o btrfslabel.o
>  
>  #
>  CHECKFLAGS=-D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ -Wbitwise \
> diff --git a/btrfs.c b/btrfs.c
> index ab5e57f..ab0a9da 100644
> --- a/btrfs.c
> +++ b/btrfs.c
> @@ -95,6 +95,10 @@ static struct Command commands[] = {
>  	  "filesystem balance", "<path>\n"
>  		"Balance the chunks across the device."
>  	},
> +	{ do_change_label, -1,
> +	  "filesystem label", "<device> [<label>]\n"
> +		"Get or set a label of a filesystem."
> +	},
>  	{ do_scan,
>  	  999, "device scan", "[<device> [<device>..]\n"
>  		"Scan all device for or the passed device for a btrfs\n"
> @@ -108,11 +112,6 @@ static struct Command commands[] = {
>  	  "device delete", "<dev> [<dev>..] <path>\n"
>  		"Remove a device from a filesystem."
>  	},
> -	/* coming soon
> -	{ 2, "filesystem label", "<label> <path>\n"
> -		"Set the label of a filesystem"
> -	}
> -	*/
>  	{ 0, 0 , 0 }
>  };
>  
> diff --git a/btrfs_cmds.c b/btrfs_cmds.c
> index 8031c58..3f632c8 100644
> --- a/btrfs_cmds.c
> +++ b/btrfs_cmds.c
> @@ -40,6 +40,7 @@
>  #include "volumes.h"
>  
>  #include "btrfs_cmds.h"
> +#include "btrfslabel.h"
>  
>  #ifdef __CHECKER__
>  #define BLKGETSIZE64 0
> @@ -834,6 +835,21 @@ int do_set_default_subvol(int nargs, char **argv)
>  	return 0;
>  }
>  
> +int do_change_label(int nargs, char **argv)
> +{
> +	/* check the number of argument */
> +	if ( nargs > 3 ){
> +		fprintf(stderr, "ERROR: '%s' requires maximum 2 args\n",
> +			argv[0]);
> +		return -2;
> +	}else if (nargs == 2){
> +		return get_label(argv[1]);
> +	} else {	/* nargs == 0 */
> +		return set_label(argv[1], argv[2]);
> +	}
> +}
> +
> +
>  int do_df_filesystem(int nargs, char **argv)
>  {
>  	struct btrfs_ioctl_space_args *sargs;
> diff --git a/btrfs_cmds.h b/btrfs_cmds.h
> index 7bde191..ab722d4 100644
> --- a/btrfs_cmds.h
> +++ b/btrfs_cmds.h
> @@ -32,3 +32,4 @@ int list_subvols(int fd);
>  int do_df_filesystem(int nargs, char **argv);
>  int find_updated_files(int fd, u64 root_id, u64 oldest_gen);
>  int do_find_newer(int argc, char **argv);
> +int do_change_label(int argc, char **argv);
> diff --git a/btrfslabel.c b/btrfslabel.c
> new file mode 100644
> index 0000000..c9f4684
> --- /dev/null
> +++ b/btrfslabel.c
> @@ -0,0 +1,121 @@
> +/*
> + * Copyright (C) 2008 Morey Roof.   All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public
> + * License v2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public
> + * License along with this program; if not, write to the
> + * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
> + * Boston, MA 021110-1307, USA.
> + */
> +
> +#define _GNU_SOURCE
> +
> +#ifndef __CHECKER__
> +#include <sys/ioctl.h>
> +#include <sys/mount.h>
> +#include "ioctl.h"
> +#endif /* __CHECKER__ */
> +
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <dirent.h>
> +#include <fcntl.h>
> +#include <unistd.h>
> +#include <linux/fs.h>
> +#include <linux/limits.h>
> +#include <ctype.h>
> +#include "kerncompat.h"
> +#include "ctree.h"
> +#include "utils.h"
> +#include "version.h"
> +#include "disk-io.h"
> +#include "transaction.h"
> +
> +#define MOUNTED                        1
> +#define UNMOUNTED                      2
> +#define GET_LABEL                      3
> +#define SET_LABEL                      4
> +
> +static void change_label_unmounted(char *dev, char *nLabel)
> +{
> +       struct btrfs_root *root;
> +       struct btrfs_trans_handle *trans;
> +
> +       /* Open the super_block at the default location
> +        * and as read-write.
> +        */
> +       root = open_ctree(dev, 0, 1);
> +
> +       trans = btrfs_start_transaction(root, 1);
> +       strncpy(root->fs_info->super_copy.label, nLabel, BTRFS_LABEL_SIZE);
> +       btrfs_commit_transaction(trans, root);
> +
> +       /* Now we close it since we are done. */
> +       close_ctree(root);
> +}
> +
> +static void get_label_unmounted(char *dev)
> +{
> +       struct btrfs_root *root;
> +
> +       /* Open the super_block at the default location
> +        * and as read-only.
> +        */
> +       root = open_ctree(dev, 0, 0);
> +
> +       fprintf(stdout, "%s\n", root->fs_info->super_copy.label);
> +
> +       /* Now we close it since we are done. */
> +       close_ctree(root);
> +}
> +
> +int get_label(char *btrfs_dev)
> +{
> +
> +	int ret;
> +	ret = check_mounted(btrfs_dev);
> +	if (ret < 0)
> +	{
> +	       fprintf(stderr, "FATAL: error checking %s mount status\n", 
> btrfs_dev);
> +	       return -1;
> +	}
> +
> +	if(ret != 0)
> +	{
> +	       fprintf(stderr, "FATAL: the filesystem has to be 
> unmounted\n");
> +	       return -2;
> +	}
> +	get_label_unmounted(btrfs_dev);
> +	return 0;
> +}
> +
> +
> +int set_label(char *btrfs_dev, char *nLabel)
> +{
> +
> +	int ret;
> +	ret = check_mounted(btrfs_dev);
> +	if (ret < 0)
> +	{
> +	       fprintf(stderr, "FATAL: error checking %s mount status\n", 
> btrfs_dev);
> +	       return -1;
> +	}
> +
> +	if(ret != 0)
> +	{
> +	       fprintf(stderr, "FATAL: the filesystem has to be 
> unmounted\n");
> +	       return -2;
> +	}
> +	change_label_unmounted(btrfs_dev, nLabel);
> +	return 0;
> +}
> diff --git a/btrfslabel.h b/btrfslabel.h
> new file mode 100644
> index 0000000..abf43ad
> --- /dev/null
> +++ b/btrfslabel.h
> @@ -0,0 +1,5 @@
> +/* btrflabel.h */
> +
> +
> +int get_label(char *btrfs_dev);
> +int set_label(char *btrfs_dev, char *nLabel);
> \ No newline at end of file
> diff --git a/man/btrfs.8.in b/man/btrfs.8.in
> index 26ef982..c1a8a42 100644
> --- a/man/btrfs.8.in
> +++ b/man/btrfs.8.in
> @@ -21,6 +21,8 @@ btrfs \- control a btrfs filesystem
>  .PP
>  \fBbtrfs\fP \fBfilesystem resize\fP\fI [+/\-]<size>[gkm]|max <filesystem>\fP
>  .PP
> +\fBbtrfs\fP \fBfilesystem label\fP\fI <dev> [newlabel]\fP
> +.PP
>  \fBbtrfs\fP \fBdevice scan\fP\fI [<device> [<device>..]]\fP
>  .PP
>  \fBbtrfs\fP \fBdevice show\fP\fI <dev>|<label> [<dev>|<label>...]\fP
> @@ -138,6 +140,23 @@ can expand the partition before enlarging the filesystem 
> and shrink the
>  partition after reducing the size of the filesystem.
>  .TP
>  
> +\fBbtrfs\fP \fBfilesystem label\fP\fI <dev> [newlabel]\fP
> +Show or update the label of a filesystem. \fI<dev>\fR is used to identify 
> the
> +filesystem. 
> +If a \fInewlabel\fR optional argument is passed, the label is changed. The
> +following costraints exist for a label:
> +.IP
> +- the maximum allowable lenght shall be less or equal than 256 chars
> +.IP
> +- the label shall not  contain the '/' or '\\' characters.
> +
> +NOTE: Currently there are the following limitations:
> +.IP
> +- the filesystem has to be unmounted
> +.IP
> +- the filesystem should not have more than one device.
> +.TP
> +
>  \fBfilesystem show\fR [<uuid>|<label>]\fR
>  Show the btrfs filesystem with some additional info. If no UUID or label is
>  passed, \fBbtrfs\fR show info of all the btrfs filesystem.
> diff --git a/utils.c b/utils.c
> index 2f4c6e1..ea8e5b7 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -587,7 +587,7 @@ error:
>  }
>  
>  /*
> - * returns 1 if the device was mounted, < 0 on error or 0 if everything
> + * returns 1 if the device is mounted, < 0 on error or 0 if everything
>   * is safe to continue.  TODO, this should also scan multi-device 
> filesystems
>   */
>  int check_mounted(char *file)
> @@ -638,6 +638,39 @@ int check_mounted(char *file)
>  	return ret;
>  }
>  
> +/* Gets the mount point of btrfs filesystem that is using the specified 
> device.
> + * Returns 0 is everything is good, <0 if we have an error.
> + * TODO: Fix this fucntion and check_mounted to work with multiple drive 
> BTRFS
> + * setups.
> + */
> +int get_mountpt(char *dev, char *mntpt, size_t size)
> +{
> +       struct mntent *mnt;
> +       FILE *f;
> +       int ret = 0;
> +
> +       f = setmntent("/proc/mounts", "r");
> +       if (f == NULL)
> +               return -errno;
> +
> +       while ((mnt = getmntent(f)) != NULL )
> +       {
> +               if (strcmp(dev, mnt->mnt_fsname) == 0)
> +               {
> +                       strncpy(mntpt, mnt->mnt_dir, size);
> +                       break;
> +               }
> +       }
> +
> +       if (mnt == NULL)
> +       {
> +               /* We didn't find an entry so lets report an error */
> +               ret = -1;
> +       }
> +
> +       return ret;
> +}
> +
>  struct pending_dir {
>  	struct list_head list;
>  	char name[256];
> @@ -820,3 +853,27 @@ char *pretty_sizes(u64 size)
>  	return pretty;
>  }
>  
> +/*
> + * Checks to make sure that the label matches our requirements.
> + * Returns:
> +       0    if everything is safe and usable
> +      -1    if the label is too long
> +      -2    if the label contains an invalid character
> + */
> +int check_label(char *input)
> +{
> +       int i;
> +       int len = strlen(input);
> +
> +       if (len > BTRFS_LABEL_SIZE) {
> +               return -1;
> +       }
> +
> +       for (i = 0; i < len; i++) {
> +               if (input[i] == '/' || input[i] == '\\') {
> +                       return -2;
> +               }
> +       }
> +
> +       return 0;
> +}
> diff --git a/utils.h b/utils.h
> index 7ff542b..838b65e 100644
> --- a/utils.h
> +++ b/utils.h
> @@ -40,4 +40,6 @@ int check_mounted(char *devicename);
>  int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
>  				 int super_offset);
>  char *pretty_sizes(u64 size);
> +int check_label(char *input);
> +int get_mountpt(char *dev, char *mntpt, size_t size);
>  #endif
> 
> 

