Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:51795 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207Ab2FFTbw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jun 2012 15:31:52 -0400
Date: Wed, 6 Jun 2012 20:31:47 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Jim Meyering <jim@meyering.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCHv2 3/4] avoid several strncpy-induced buffer overruns
Message-ID: <20120606193147.GS15986@carfax.org.uk>
References: <1334950046-24147-1-git-send-email-jim@meyering.net>
 <1334950046-24147-4-git-send-email-jim@meyering.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2/Dpz40iF3jpiHxF"
In-Reply-To: <1334950046-24147-4-git-send-email-jim@meyering.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--2/Dpz40iF3jpiHxF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   Hi, Jim, 

   I picked this up to go in integration-*, and Alex Block spotted a
problem, so I did a bit of a more in-depth review. Comments below.

On Fri, Apr 20, 2012 at 09:27:25PM +0200, Jim Meyering wrote:
> From: Jim Meyering <meyering@redhat.com>
> 
> * restore.c (main): Ensure strncpy-copied dir_name is NUL-terminated.
> * btrfsctl.c (main): Likewise, for a command-line argument.
> * utils.c (multiple functions): Likewise.
> * btrfs-list.c (add_root): Likewise.
> * btrfslabel.c (change_label_unmounted): Likewise.
> * cmds-device.c (cmd_add_dev, cmd_rm_dev, cmd_scan_dev): Likewise.
> * cmds-filesystem.c (cmd_resize): Likewise.
> * cmds-subvolume.c (cmd_subvol_create, cmd_subvol_delete, cmd_snapshot):
> Likewise.
> 
> Reviewed-by: Josef Bacik <josef@redhat.com>
> ---
>  btrfs-list.c      |    2 ++
>  btrfsctl.c        |    5 +++--
>  btrfslabel.c      |    1 +
>  cmds-device.c     |    3 +++
>  cmds-filesystem.c |    1 +
>  cmds-subvolume.c  |    3 +++
>  restore.c         |    3 ++-
>  utils.c           |   13 ++++++++++---
>  8 files changed, 25 insertions(+), 6 deletions(-)
> 
> diff --git a/btrfs-list.c b/btrfs-list.c
> index 5f4a9be..35e6139 100644
> --- a/btrfs-list.c
> +++ b/btrfs-list.c
> @@ -183,6 +183,8 @@ static int add_root(struct root_lookup *root_lookup,
>  	ri->root_id = root_id;
>  	ri->ref_tree = ref_tree;
>  	strncpy(ri->name, name, name_len);
> +	if (name_len > 0)
> +		ri->name[name_len-1] = 0;

   Alex Block pointed out on IRC that this breaks "btrfs sub list", by
chopping off the last character of the subvol name. This should
probably be:

- 	strncpy(ri->name, name, name_len);
+ 	strncpy(ri->name, name, name_len+1);
+	if (name_len > 0)
+		ri->name[name_len] = 0;

>  	ret = tree_insert(&root_lookup->root, root_id, ref_tree, &ri->rb_node);
>  	if (ret) {
> diff --git a/btrfsctl.c b/btrfsctl.c
> index d45e2a7..518684c 100644
> --- a/btrfsctl.c
> +++ b/btrfsctl.c
> @@ -241,9 +241,10 @@ int main(int ac, char **av)
>  		fd = open_file_or_dir(fname);
>  	 }
> 
> -	if (name)
> +	if (name) {
>                  strncpy(args.name, name, BTRFS_PATH_NAME_MAX + 1);
> -	else
> +                args.name[BTRFS_PATH_NAME_MAX] = 0;
> +	} else
>  		args.name[0] = '\0';
> 
>  	if (command == BTRFS_IOC_SNAP_CREATE) {
> diff --git a/btrfslabel.c b/btrfslabel.c
> index c9f4684..da694e1 100644
> --- a/btrfslabel.c
> +++ b/btrfslabel.c
> @@ -58,6 +58,7 @@ static void change_label_unmounted(char *dev, char *nLabel)
> 
>         trans = btrfs_start_transaction(root, 1);
>         strncpy(root->fs_info->super_copy.label, nLabel, BTRFS_LABEL_SIZE);
> +       root->fs_info->super_copy.label[BTRFS_LABEL_SIZE-1] = 0;
>         btrfs_commit_transaction(trans, root);
> 
>         /* Now we close it since we are done. */
> diff --git a/cmds-device.c b/cmds-device.c
> index db625a6..771856b 100644
> --- a/cmds-device.c
> +++ b/cmds-device.c
> @@ -117,6 +117,7 @@ static int cmd_add_dev(int argc, char **argv)
>  		close(devfd);
> 
>  		strncpy(ioctl_args.name, argv[i], BTRFS_PATH_NAME_MAX);

   Actually, this could go up to BTRFS_PATH_NAME_MAX+1,

> +		ioctl_args.name[BTRFS_PATH_NAME_MAX-1] = 0;

and this to BTRFS_PATH_NAME_MAX, since struct btrfs_ioctl_vol_args'
name member is BTRFS_PATH_NAME_MAX+1 in size...

>  		res = ioctl(fdmnt, BTRFS_IOC_ADD_DEV, &ioctl_args);
>  		e = errno;
>  		if(res<0){
> @@ -161,6 +162,7 @@ static int cmd_rm_dev(int argc, char **argv)
>  		int	res;
> 
>  		strncpy(arg.name, argv[i], BTRFS_PATH_NAME_MAX);
> +		arg.name[BTRFS_PATH_NAME_MAX-1] = 0;

... and here...

>  		res = ioctl(fdmnt, BTRFS_IOC_RM_DEV, &arg);
>  		e = errno;
>  		if(res<0){
> @@ -226,6 +228,7 @@ static int cmd_scan_dev(int argc, char **argv)
>  		printf("Scanning for Btrfs filesystems in '%s'\n", argv[i]);
> 
>  		strncpy(args.name, argv[i], BTRFS_PATH_NAME_MAX);
> +		args.name[BTRFS_PATH_NAME_MAX-1] = 0;

... and here, and the next 3 hunks as well.

>  		/*
>  		 * FIXME: which are the error code returned by this ioctl ?
>  		 * it seems that is impossible to understand if there no is
> diff --git a/cmds-filesystem.c b/cmds-filesystem.c
> index 1f53d1c..ea9e788 100644
> --- a/cmds-filesystem.c
> +++ b/cmds-filesystem.c
> @@ -489,6 +489,7 @@ static int cmd_resize(int argc, char **argv)
> 
>  	printf("Resize '%s' of '%s'\n", path, amount);
>  	strncpy(args.name, amount, BTRFS_PATH_NAME_MAX);
> +	args.name[BTRFS_PATH_NAME_MAX-1] = 0;
>  	res = ioctl(fd, BTRFS_IOC_RESIZE, &args);
>  	e = errno;
>  	close(fd);
> diff --git a/cmds-subvolume.c b/cmds-subvolume.c
> index 950fa8f..fc749f1 100644
> --- a/cmds-subvolume.c
> +++ b/cmds-subvolume.c
> @@ -111,6 +111,7 @@ static int cmd_subvol_create(int argc, char **argv)
> 
>  	printf("Create subvolume '%s/%s'\n", dstdir, newname);
>  	strncpy(args.name, newname, BTRFS_PATH_NAME_MAX);
> +	args.name[BTRFS_PATH_NAME_MAX-1] = 0;
>  	res = ioctl(fddst, BTRFS_IOC_SUBVOL_CREATE, &args);
>  	e = errno;
> 
> @@ -202,6 +203,7 @@ static int cmd_subvol_delete(int argc, char **argv)
> 
>  	printf("Delete subvolume '%s/%s'\n", dname, vname);
>  	strncpy(args.name, vname, BTRFS_PATH_NAME_MAX);
> +	args.name[BTRFS_PATH_NAME_MAX-1] = 0;
>  	res = ioctl(fd, BTRFS_IOC_SNAP_DESTROY, &args);
>  	e = errno;
> 
> @@ -378,6 +380,7 @@ static int cmd_snapshot(int argc, char **argv)
> 
>  	args.fd = fd;
>  	strncpy(args.name, newname, BTRFS_SUBVOL_NAME_MAX);
> +	args.name[BTRFS_PATH_NAME_MAX-1] = 0;

   This, however, is wrong. args here is a struct
btrfs_ioctl_vol_args_v2, and the name field is BTRFS_SUBVOL_NAME_MAX+1
long, so it should be:

-  	strncpy(args.name, newname, BTRFS_SUBVOL_NAME_MAX);
+  	strncpy(args.name, newname, BTRFS_SUBVOL_NAME_MAX+1);
+	args.name[BTRFS_SUBVOL_NAME_MAX] = 0;

>  	res = ioctl(fddst, BTRFS_IOC_SNAP_CREATE_V2, &args);
>  	e = errno;
> 
> diff --git a/restore.c b/restore.c
> index 2674832..d1ac542 100644
> --- a/restore.c
> +++ b/restore.c
> @@ -846,7 +846,8 @@ int main(int argc, char **argv)
> 
>  	memset(path_name, 0, 4096);
> 
> -	strncpy(dir_name, argv[optind + 1], 128);
> +	strncpy(dir_name, argv[optind + 1], sizeof dir_name);
> +	dir_name[sizeof dir_name - 1] = 0;
> 
>  	/* Strip the trailing / on the dir name */
>  	len = strlen(dir_name);
> diff --git a/utils.c b/utils.c
> index ee7fa1b..5240c2c 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -657,9 +657,11 @@ int resolve_loop_device(const char* loop_dev, char* loop_file, int max_len)
>  	ret_ioctl = ioctl(loop_fd, LOOP_GET_STATUS, &loopinfo);
>  	close(loop_fd);
> 
> -	if (ret_ioctl == 0)
> +	if (ret_ioctl == 0) {
>  		strncpy(loop_file, loopinfo.lo_name, max_len);
> -	else
> +		if (max_len > 0)
> +			loop_file[max_len-1] = 0;
> +	} else
>  		return -errno;
> 
>  	return 0;
> @@ -860,8 +862,10 @@ int check_mounted_where(int fd, const char *file, char *where, int size,
>  	}
> 
>  	/* Did we find an entry in mnt table? */
> -	if (mnt && size && where)
> +	if (mnt && size && where) {
>  		strncpy(where, mnt->mnt_dir, size);
> +		where[size-1] = 0;
> +	}
>  	if (fs_dev_ret)
>  		*fs_dev_ret = fs_devices_mnt;
> 
> @@ -893,6 +897,8 @@ int get_mountpt(char *dev, char *mntpt, size_t size)
>                 if (strcmp(dev, mnt->mnt_fsname) == 0)
>                 {
>                         strncpy(mntpt, mnt->mnt_dir, size);
> +                       if (size)
> +                                mntpt[size-1] = 0;
>                         break;
>                 }
>         }
> @@ -925,6 +931,7 @@ void btrfs_register_one_device(char *fname)
>  		return;
>  	}
>  	strncpy(args.name, fname, BTRFS_PATH_NAME_MAX);
> +	args.name[BTRFS_PATH_NAME_MAX-1] = 0;

   Same comment about the length of the name field in struct
btrfs_ioctl_vol_args as the 6 or 7 places above.

>  	ret = ioctl(fd, BTRFS_IOC_SCAN_DEV, &args);
>  	e = errno;
>  	if(ret<0){

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- Your problem is that you've got too much taste to be ---       
                            a web developer.                             

--2/Dpz40iF3jpiHxF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFPz7AjIKyzvlFcI40RAuVQAJ4l0uvEbNy9Cb4icJZJw/cm3VzaggCg0Ml8
85qK5sYYynEYXi5SAU3cbHU=
=fVAX
-----END PGP SIGNATURE-----

--2/Dpz40iF3jpiHxF--
