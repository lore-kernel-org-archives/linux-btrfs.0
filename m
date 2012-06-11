Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:42772 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753468Ab2FKMGA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jun 2012 08:06:00 -0400
Received: from mx.meyering.net (unknown [88.168.87.75])
	by smtp5-g21.free.fr (Postfix) with ESMTP id C5985D4802A
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Jun 2012 14:05:53 +0200 (CEST)
From: Jim Meyering <jim@meyering.net>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCHv4 3/4] avoid several strncpy-induced buffer overruns
In-Reply-To: <20120606193147.GS15986@carfax.org.uk> (Hugo Mills's message of
	"Wed, 6 Jun 2012 20:31:47 +0100")
References: <1334950046-24147-1-git-send-email-jim@meyering.net>
	<1334950046-24147-4-git-send-email-jim@meyering.net>
	<20120606193147.GS15986@carfax.org.uk>
Date: Mon, 11 Jun 2012 14:05:52 +0200
Message-ID: <87aa0a834v.fsf_-_@rho.meyering.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills wrote:
>    Hi, Jim,
>
>    I picked this up to go in integration-*, and Alex Block spotted a
> problem, so I did a bit of a more in-depth review. Comments below.

Hi Hugo,

Thanks again for the review feedback.
...
TL;DR: the length of btrfs_ioctl_vol_args.name depends on #ifdef __CHECKER__
Patch at the end.
-----------------------------------------------------------------

>>  	strncpy(ri->name, name, name_len);
>> +	if (name_len > 0)
>> +		ri->name[name_len-1] = 0;
>
>    Alex Block pointed out on IRC that this breaks "btrfs sub list", by
> chopping off the last character of the subvol name. This should
> probably be:
>
> - 	strncpy(ri->name, name, name_len);
> + 	strncpy(ri->name, name, name_len+1);
> +	if (name_len > 0)
> +		ri->name[name_len] = 0;
>
>>  	ret = tree_insert(&root_lookup->root, root_id, ref_tree, &ri->rb_node);
>>  	if (ret) {
>> diff --git a/btrfsctl.c b/btrfsctl.c
>> index d45e2a7..518684c 100644
>> --- a/btrfsctl.c
>> +++ b/btrfsctl.c
>> @@ -241,9 +241,10 @@ int main(int ac, char **av)
>>  		fd = open_file_or_dir(fname);
>>  	 }
>>
>> -	if (name)
>> +	if (name) {
>>                  strncpy(args.name, name, BTRFS_PATH_NAME_MAX + 1);
>> -	else
>> +                args.name[BTRFS_PATH_NAME_MAX] = 0;
>> +	} else
>>  		args.name[0] = '\0';
>>
>>  	if (command == BTRFS_IOC_SNAP_CREATE) {
>> diff --git a/btrfslabel.c b/btrfslabel.c
>> index c9f4684..da694e1 100644
>> --- a/btrfslabel.c
>> +++ b/btrfslabel.c
>> @@ -58,6 +58,7 @@ static void change_label_unmounted(char *dev, char *nLabel)
>>
>>         trans = btrfs_start_transaction(root, 1);
>>         strncpy(root->fs_info->super_copy.label, nLabel, BTRFS_LABEL_SIZE);
>> +       root->fs_info->super_copy.label[BTRFS_LABEL_SIZE-1] = 0;
>>         btrfs_commit_transaction(trans, root);
>>
>>         /* Now we close it since we are done. */
>> diff --git a/cmds-device.c b/cmds-device.c
>> index db625a6..771856b 100644
>> --- a/cmds-device.c
>> +++ b/cmds-device.c
>> @@ -117,6 +117,7 @@ static int cmd_add_dev(int argc, char **argv)
>>  		close(devfd);
>>
>>  		strncpy(ioctl_args.name, argv[i], BTRFS_PATH_NAME_MAX);
>
>    Actually, this could go up to BTRFS_PATH_NAME_MAX+1,

There's no point in copying or clearing the last byte
when the next statement will clear it, so I've left the above as-is.

>> +		ioctl_args.name[BTRFS_PATH_NAME_MAX-1] = 0;

In the patch below I've adjusted it to clear the byte at the end of the
struct defined in ioctl.h, assuming that the 1-byte-shorter
__CHECKER__-defined struct declarations (see below) are erroneous.

As I write, I realize that I would prefer this instead:

		ioctl_args.name[sizeof(ioctl_args.name)-1] = 0;

since this code is independent of whether __CHECKER__ is defined.
Say the word and I'll be happy to provide a v5.

> and this to BTRFS_PATH_NAME_MAX, since struct btrfs_ioctl_vol_args'
> name member is BTRFS_PATH_NAME_MAX+1 in size...

However, using an index of BTRFS_PATH_NAME_MAX with
struct btrfs_ioctl_vol_args would cause its own overrun whenever
__CHECKER__ is defined, due to these:

    $ git grep 'btrfs_ioctl_vol_args.*MAX'
    btrfs-vol.c:struct btrfs_ioctl_vol_args { char name[BTRFS_VOL_NAME_MAX]; };
    btrfsctl.c:struct btrfs_ioctl_vol_args { char name[BTRFS_VOL_NAME_MAX]; };
    cmds-device.c:struct btrfs_ioctl_vol_args { char name[BTRFS_VOL_NAME_MAX]; };

E.g.,

  #ifdef __CHECKER__
  #define BLKGETSIZE64 0
  #define BTRFS_IOC_SNAP_CREATE 0
  #define BTRFS_IOC_ADD_DEV 0
  #define BTRFS_IOC_RM_DEV 0
  #define BTRFS_VOL_NAME_MAX 255
  struct btrfs_ioctl_vol_args { char name[BTRFS_VOL_NAME_MAX]; };
  static inline int ioctl(int fd, int define, void *arg) { return 0; }
  #endif

If those "name" buffers are not deliberately one byte shorter
than the real ones in ioctl.h, let me know and I'll adjust them
in a precursor patch.

>>  		res = ioctl(fdmnt, BTRFS_IOC_ADD_DEV, &ioctl_args);
>>  		e = errno;
>>  		if(res<0){
>> @@ -161,6 +162,7 @@ static int cmd_rm_dev(int argc, char **argv)
>>  		int	res;
>>
>>  		strncpy(arg.name, argv[i], BTRFS_PATH_NAME_MAX);
>> +		arg.name[BTRFS_PATH_NAME_MAX-1] = 0;
>
> ... and here...
>
>>  		res = ioctl(fdmnt, BTRFS_IOC_RM_DEV, &arg);
>>  		e = errno;
>>  		if(res<0){
>> @@ -226,6 +228,7 @@ static int cmd_scan_dev(int argc, char **argv)
>>  		printf("Scanning for Btrfs filesystems in '%s'\n", argv[i]);
>>
>>  		strncpy(args.name, argv[i], BTRFS_PATH_NAME_MAX);
>> +		args.name[BTRFS_PATH_NAME_MAX-1] = 0;
>
> ... and here, and the next 3 hunks as well.
...
>> +	args.name[BTRFS_PATH_NAME_MAX-1] = 0;
>
>    This, however, is wrong. args here is a struct
> btrfs_ioctl_vol_args_v2, and the name field is BTRFS_SUBVOL_NAME_MAX+1
> long, so it should be:
>
> -  	strncpy(args.name, newname, BTRFS_SUBVOL_NAME_MAX);
> +  	strncpy(args.name, newname, BTRFS_SUBVOL_NAME_MAX+1);
> +	args.name[BTRFS_SUBVOL_NAME_MAX] = 0;

As you noted, later, that was fixed in a subsequent round.

Here's a complete version of that adjusted patch:

>From c2026ca5fe3ffe90f2ddc0f4f6332922c4f33cb0 Mon Sep 17 00:00:00 2001
From: Jim Meyering <meyering@redhat.com>
Date: Mon, 16 Apr 2012 22:03:38 +0200
Subject: [PATCHv4 3/4] avoid several strncpy-induced buffer overruns

* btrfs-list.c (add_root): Use calloc in place of malloc+memset-0
* restore.c (main): Ensure strncpy-copied dir_name is NUL-terminated.
* btrfsctl.c (main): Likewise, for a command-line argument.
* utils.c (multiple functions): Likewise.
* btrfslabel.c (change_label_unmounted): Likewise.
* cmds-device.c (cmd_add_dev, cmd_rm_dev, cmd_scan_dev): Likewise.
* cmds-filesystem.c (cmd_resize): Likewise.
* cmds-subvolume.c (cmd_subvol_create, cmd_subvol_delete, cmd_snapshot):
Likewise.

Reviewed-by: Josef Bacik <josef@redhat.com>

.
---
 btrfs-list.c      |  3 +--
 btrfsctl.c        |  5 +++--
 btrfslabel.c      |  1 +
 cmds-device.c     |  3 +++
 cmds-filesystem.c |  1 +
 cmds-subvolume.c  |  3 +++
 restore.c         |  3 ++-
 utils.c           | 13 ++++++++++---
 8 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 5f4a9be..da43eff 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -172,12 +172,11 @@ static int add_root(struct root_lookup *root_lookup,
 {
 	struct root_info *ri;
 	struct rb_node *ret;
-	ri = malloc(sizeof(*ri) + name_len + 1);
+	ri = calloc(sizeof(*ri) + name_len + 1);
 	if (!ri) {
 		printf("memory allocation failed\n");
 		exit(1);
 	}
-	memset(ri, 0, sizeof(*ri) + name_len + 1);
 	ri->path = NULL;
 	ri->dir_id = dir_id;
 	ri->root_id = root_id;
diff --git a/btrfsctl.c b/btrfsctl.c
index d45e2a7..518684c 100644
--- a/btrfsctl.c
+++ b/btrfsctl.c
@@ -241,9 +241,10 @@ int main(int ac, char **av)
 		fd = open_file_or_dir(fname);
 	 }

-	if (name)
+	if (name) {
                 strncpy(args.name, name, BTRFS_PATH_NAME_MAX + 1);
-	else
+                args.name[BTRFS_PATH_NAME_MAX] = 0;
+	} else
 		args.name[0] = '\0';

 	if (command == BTRFS_IOC_SNAP_CREATE) {
diff --git a/btrfslabel.c b/btrfslabel.c
index c9f4684..da694e1 100644
--- a/btrfslabel.c
+++ b/btrfslabel.c
@@ -58,6 +58,7 @@ static void change_label_unmounted(char *dev, char *nLabel)

        trans = btrfs_start_transaction(root, 1);
        strncpy(root->fs_info->super_copy.label, nLabel, BTRFS_LABEL_SIZE);
+       root->fs_info->super_copy.label[BTRFS_LABEL_SIZE-1] = 0;
        btrfs_commit_transaction(trans, root);

        /* Now we close it since we are done. */
diff --git a/cmds-device.c b/cmds-device.c
index db625a6..0e3e38c 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -117,6 +117,7 @@ static int cmd_add_dev(int argc, char **argv)
 		close(devfd);

 		strncpy(ioctl_args.name, argv[i], BTRFS_PATH_NAME_MAX);
+		ioctl_args.name[BTRFS_PATH_NAME_MAX] = 0;
 		res = ioctl(fdmnt, BTRFS_IOC_ADD_DEV, &ioctl_args);
 		e = errno;
 		if(res<0){
@@ -161,6 +162,7 @@ static int cmd_rm_dev(int argc, char **argv)
 		int	res;

 		strncpy(arg.name, argv[i], BTRFS_PATH_NAME_MAX);
+		arg.name[BTRFS_PATH_NAME_MAX] = 0;
 		res = ioctl(fdmnt, BTRFS_IOC_RM_DEV, &arg);
 		e = errno;
 		if(res<0){
@@ -226,6 +228,7 @@ static int cmd_scan_dev(int argc, char **argv)
 		printf("Scanning for Btrfs filesystems in '%s'\n", argv[i]);

 		strncpy(args.name, argv[i], BTRFS_PATH_NAME_MAX);
+		args.name[BTRFS_PATH_NAME_MAX] = 0;
 		/*
 		 * FIXME: which are the error code returned by this ioctl ?
 		 * it seems that is impossible to understand if there no is
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 1f53d1c..b6ab2b3 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -489,6 +489,7 @@ static int cmd_resize(int argc, char **argv)

 	printf("Resize '%s' of '%s'\n", path, amount);
 	strncpy(args.name, amount, BTRFS_PATH_NAME_MAX);
+	args.name[BTRFS_PATH_NAME_MAX] = 0;
 	res = ioctl(fd, BTRFS_IOC_RESIZE, &args);
 	e = errno;
 	close(fd);
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 950fa8f..47a69c3 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -111,6 +111,7 @@ static int cmd_subvol_create(int argc, char **argv)

 	printf("Create subvolume '%s/%s'\n", dstdir, newname);
 	strncpy(args.name, newname, BTRFS_PATH_NAME_MAX);
+	args.name[BTRFS_PATH_NAME_MAX] = 0;
 	res = ioctl(fddst, BTRFS_IOC_SUBVOL_CREATE, &args);
 	e = errno;

@@ -202,6 +203,7 @@ static int cmd_subvol_delete(int argc, char **argv)

 	printf("Delete subvolume '%s/%s'\n", dname, vname);
 	strncpy(args.name, vname, BTRFS_PATH_NAME_MAX);
+	args.name[BTRFS_PATH_NAME_MAX] = 0;
 	res = ioctl(fd, BTRFS_IOC_SNAP_DESTROY, &args);
 	e = errno;

@@ -378,6 +380,7 @@ static int cmd_snapshot(int argc, char **argv)

 	args.fd = fd;
 	strncpy(args.name, newname, BTRFS_SUBVOL_NAME_MAX);
+	args.name[BTRFS_SUBVOL_NAME_MAX] = 0;
 	res = ioctl(fddst, BTRFS_IOC_SNAP_CREATE_V2, &args);
 	e = errno;

diff --git a/restore.c b/restore.c
index 2674832..d1ac542 100644
--- a/restore.c
+++ b/restore.c
@@ -846,7 +846,8 @@ int main(int argc, char **argv)

 	memset(path_name, 0, 4096);

-	strncpy(dir_name, argv[optind + 1], 128);
+	strncpy(dir_name, argv[optind + 1], sizeof dir_name);
+	dir_name[sizeof dir_name - 1] = 0;

 	/* Strip the trailing / on the dir name */
 	len = strlen(dir_name);
diff --git a/utils.c b/utils.c
index ee7fa1b..5908715 100644
--- a/utils.c
+++ b/utils.c
@@ -657,9 +657,11 @@ int resolve_loop_device(const char* loop_dev, char* loop_file, int max_len)
 	ret_ioctl = ioctl(loop_fd, LOOP_GET_STATUS, &loopinfo);
 	close(loop_fd);

-	if (ret_ioctl == 0)
+	if (ret_ioctl == 0) {
 		strncpy(loop_file, loopinfo.lo_name, max_len);
-	else
+		if (max_len > 0)
+			loop_file[max_len-1] = 0;
+	} else
 		return -errno;

 	return 0;
@@ -860,8 +862,10 @@ int check_mounted_where(int fd, const char *file, char *where, int size,
 	}

 	/* Did we find an entry in mnt table? */
-	if (mnt && size && where)
+	if (mnt && size && where) {
 		strncpy(where, mnt->mnt_dir, size);
+		where[size-1] = 0;
+	}
 	if (fs_dev_ret)
 		*fs_dev_ret = fs_devices_mnt;

@@ -893,6 +897,8 @@ int get_mountpt(char *dev, char *mntpt, size_t size)
                if (strcmp(dev, mnt->mnt_fsname) == 0)
                {
                        strncpy(mntpt, mnt->mnt_dir, size);
+                       if (size)
+                                mntpt[size-1] = 0;
                        break;
                }
        }
@@ -925,6 +931,7 @@ void btrfs_register_one_device(char *fname)
 		return;
 	}
 	strncpy(args.name, fname, BTRFS_PATH_NAME_MAX);
+	args.name[BTRFS_PATH_NAME_MAX] = 0;
 	ret = ioctl(fd, BTRFS_IOC_SCAN_DEV, &args);
 	e = errno;
 	if(ret<0){
--
1.7.11.rc2
