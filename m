Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:4718 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751029AbaJHCNx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Oct 2014 22:13:53 -0400
Message-ID: <54349E0F.80906@cn.fujitsu.com>
Date: Wed, 8 Oct 2014 10:14:39 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <linux-btrfs@vger.kernel.org>
CC: Chris Mason <clm@fb.com>
Subject: Re: [PATCH v2] btrfs: Make btrfs handle security mount options internally
 to avoid losing security label.
References: <1412734360-16237-1-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1412734360-16237-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Cc Chris:

The delta of the v2 patch is only the following lines:

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 1eb7858..6f64411 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1248,6 +1248,7 @@ static int setup_security_options(struct 
btrfs_fs_info *fs_info,
      if (ret)
          return ret;

+#ifdef CONFIG_SECURITY
      if (!fs_info->security_opts.num_mnt_opts) {
          /* first time security setup, copy sec_opts to fs_info */
          memcpy(&fs_info->security_opts, sec_opts, sizeof(*sec_opts));
@@ -1260,6 +1261,7 @@ static int setup_security_options(struct 
btrfs_fs_info *fs_info,
           */
          security_free_mnt_opts(sec_opts);
      }
+#endif
      return ret;
  }

There should not be much pain to replace the original patch.

Thanks,
Qu


-------- Original Message --------
Subject: [PATCH v2] btrfs: Make btrfs handle security mount options 
internally to avoid losing security label.
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Date: 2014年10月08日 10:12
> [BUG]
> Originally when mount btrfs with "-o subvol=" mount option, btrfs will
> lose all security lable.
> And if the btrfs fs is mounted somewhere else, due to the lost of
> security lable, SELinux will refuse to mount since the same super block
> is being mounted using different security lable.
>
> [REPRODUCER]
> With SELinux enabled:
>   #mkfs -t btrfs /dev/sda5
>   #mount -o context=system_u:object_r:nfs_t:s0 /dev/sda5 /mnt/btrfs
>   #btrfs subvolume create /mnt/btrfs/subvol
>   #mount -o subvol=subvol,context=system_u:object_r:nfs_t:s0 /dev/sda5
>    /mnt/test
>
> kernel message:
> SELinux: mount invalid.  Same superblock, different security settings
> for (dev sda5, type btrfs)
>
> [REASON]
> This happens because btrfs will call vfs_kern_mount() and then
> mount_subtree() to handle subvolume name lookup.
> First mount will cut off all the security lables and when it comes to
> the second vfs_kern_mount(), it has no security label now.
>
> [FIX]
> This patch will makes btrfs behavior much more like nfs,
> which has the type flag FS_BINARY_MOUNTDATA,
> making btrfs handles the security label internally.
> So security label will be set in the real mount time and won't lose
> label when use with "subvol=" mount option.
>
> Reported-by: Eryu Guan <guaneryu@gmail.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
> changelog:
> v2: Fix a compile error when CONFIG_SECURITY is not set.
> ---
>   fs/btrfs/ctree.h |  5 +++
>   fs/btrfs/super.c | 99 +++++++++++++++++++++++++++++++++++++++++++++++++++++---
>   2 files changed, 99 insertions(+), 5 deletions(-)
>
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 8e29b61..c82dd6d 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -34,6 +34,7 @@
>   #include <linux/pagemap.h>
>   #include <linux/btrfs.h>
>   #include <linux/workqueue.h>
> +#include <linux/security.h>
>   #include "extent_io.h"
>   #include "extent_map.h"
>   #include "async-thread.h"
> @@ -1723,6 +1724,9 @@ struct btrfs_fs_info {
>   
>   	/* Used to reclaim the metadata space in the background. */
>   	struct work_struct async_reclaim_work;
> +
> +	/* For btrfs to record security options */
> +	struct security_mnt_opts security_opts;
>   };
>   
>   struct btrfs_subvolume_writers {
> @@ -3604,6 +3608,7 @@ static inline void free_fs_info(struct btrfs_fs_info *fs_info)
>   	kfree(fs_info->uuid_root);
>   	kfree(fs_info->super_copy);
>   	kfree(fs_info->super_for_commit);
> +	security_free_mnt_opts(&fs_info->security_opts);
>   	kfree(fs_info);
>   }
>   
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index c4124de..6f64411 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1215,6 +1215,56 @@ static struct dentry *mount_subvol(const char *subvol_name, int flags,
>   	return root;
>   }
>   
> +static int parse_security_options(char *orig_opts,
> +				  struct security_mnt_opts *sec_opts)
> +{
> +	char *secdata = NULL;
> +	int ret = 0;
> +
> +	secdata = alloc_secdata();
> +	if (!secdata)
> +		return -ENOMEM;
> +	ret = security_sb_copy_data(orig_opts, secdata);
> +	if (ret) {
> +		free_secdata(secdata);
> +		return ret;
> +	}
> +	ret = security_sb_parse_opts_str(secdata, sec_opts);
> +	free_secdata(secdata);
> +	return ret;
> +}
> +
> +static int setup_security_options(struct btrfs_fs_info *fs_info,
> +				  struct super_block *sb,
> +				  struct security_mnt_opts *sec_opts)
> +{
> +	int ret = 0;
> +
> +	/*
> +	 * Call security_sb_set_mnt_opts() to check whether new sec_opts
> +	 * is valid.
> +	 */
> +	ret = security_sb_set_mnt_opts(sb, sec_opts, 0, NULL);
> +	if (ret)
> +		return ret;
> +
> +#ifdef CONFIG_SECURITY
> +	if (!fs_info->security_opts.num_mnt_opts) {
> +		/* first time security setup, copy sec_opts to fs_info */
> +		memcpy(&fs_info->security_opts, sec_opts, sizeof(*sec_opts));
> +	} else {
> +		/*
> +		 * Since SELinux(the only one supports security_mnt_opts) does
> +		 * NOT support changing context during remount/mount same sb,
> +		 * This must be the same or part of the same security options,
> +		 * just free it.
> +		 */
> +		security_free_mnt_opts(sec_opts);
> +	}
> +#endif
> +	return ret;
> +}
> +
>   /*
>    * Find a superblock for the given device / mount point.
>    *
> @@ -1229,6 +1279,7 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
>   	struct dentry *root;
>   	struct btrfs_fs_devices *fs_devices = NULL;
>   	struct btrfs_fs_info *fs_info = NULL;
> +	struct security_mnt_opts new_sec_opts;
>   	fmode_t mode = FMODE_READ;
>   	char *subvol_name = NULL;
>   	u64 subvol_objectid = 0;
> @@ -1251,9 +1302,16 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
>   		return root;
>   	}
>   
> +	security_init_mnt_opts(&new_sec_opts);
> +	if (data) {
> +		error = parse_security_options(data, &new_sec_opts);
> +		if (error)
> +			return ERR_PTR(error);
> +	}
> +
>   	error = btrfs_scan_one_device(device_name, mode, fs_type, &fs_devices);
>   	if (error)
> -		return ERR_PTR(error);
> +		goto error_sec_opts;
>   
>   	/*
>   	 * Setup a dummy root and fs_info for test/set super.  This is because
> @@ -1262,13 +1320,16 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
>   	 * then open_ctree will properly initialize everything later.
>   	 */
>   	fs_info = kzalloc(sizeof(struct btrfs_fs_info), GFP_NOFS);
> -	if (!fs_info)
> -		return ERR_PTR(-ENOMEM);
> +	if (!fs_info) {
> +		error = -ENOMEM;
> +		goto error_sec_opts;
> +	}
>   
>   	fs_info->fs_devices = fs_devices;
>   
>   	fs_info->super_copy = kzalloc(BTRFS_SUPER_INFO_SIZE, GFP_NOFS);
>   	fs_info->super_for_commit = kzalloc(BTRFS_SUPER_INFO_SIZE, GFP_NOFS);
> +	security_init_mnt_opts(&fs_info->security_opts);
>   	if (!fs_info->super_copy || !fs_info->super_for_commit) {
>   		error = -ENOMEM;
>   		goto error_fs_info;
> @@ -1306,8 +1367,19 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
>   	}
>   
>   	root = !error ? get_default_root(s, subvol_objectid) : ERR_PTR(error);
> -	if (IS_ERR(root))
> +	if (IS_ERR(root)) {
>   		deactivate_locked_super(s);
> +		error = PTR_ERR(root);
> +		goto error_sec_opts;
> +	}
> +
> +	fs_info = btrfs_sb(s);
> +	error = setup_security_options(fs_info, s, &new_sec_opts);
> +	if (error) {
> +		dput(root);
> +		deactivate_locked_super(s);
> +		goto error_sec_opts;
> +	}
>   
>   	return root;
>   
> @@ -1315,6 +1387,8 @@ error_close_devices:
>   	btrfs_close_devices(fs_devices);
>   error_fs_info:
>   	free_fs_info(fs_info);
> +error_sec_opts:
> +	security_free_mnt_opts(&new_sec_opts);
>   	return ERR_PTR(error);
>   }
>   
> @@ -1396,6 +1470,21 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
>   	sync_filesystem(sb);
>   	btrfs_remount_prepare(fs_info);
>   
> +	if (data) {
> +		struct security_mnt_opts new_sec_opts;
> +
> +		security_init_mnt_opts(&new_sec_opts);
> +		ret = parse_security_options(data, &new_sec_opts);
> +		if (ret)
> +			goto restore;
> +		ret = setup_security_options(fs_info, sb,
> +					     &new_sec_opts);
> +		if (ret) {
> +			security_free_mnt_opts(&new_sec_opts);
> +			goto restore;
> +		}
> +	}
> +
>   	ret = btrfs_parse_options(root, data);
>   	if (ret) {
>   		ret = -EINVAL;
> @@ -1769,7 +1858,7 @@ static struct file_system_type btrfs_fs_type = {
>   	.name		= "btrfs",
>   	.mount		= btrfs_mount,
>   	.kill_sb	= btrfs_kill_super,
> -	.fs_flags	= FS_REQUIRES_DEV,
> +	.fs_flags	= FS_REQUIRES_DEV | FS_BINARY_MOUNTDATA,
>   };
>   MODULE_ALIAS_FS("btrfs");
>   

