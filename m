Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53957 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071Ab2HAMCe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Aug 2012 08:02:34 -0400
Received: by yenl2 with SMTP id l2so7174704yen.19
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Aug 2012 05:02:33 -0700 (PDT)
Message-ID: <50191AD3.9080401@gmail.com>
Date: Wed, 01 Aug 2012 20:02:27 +0800
From: Liu Bo <liub.liubo@gmail.com>
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: remove superblock writing after fatal error
References: <1343821552-28726-1-git-send-email-sbehrens@giantdisaster.de>
In-Reply-To: <1343821552-28726-1-git-send-email-sbehrens@giantdisaster.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/01/2012 07:45 PM, Stefan Behrens wrote:
> With commit acce952b0, btrfs was changed to flag the filesystem with
> BTRFS_SUPER_FLAG_ERROR and switch to read-only mode after a fatal
> error happened like a write I/O errors of all mirrors.
> In such situations, on unmount, the superblock is written in
> btrfs_error_commit_super(). This is done with the intention to be able
> to evaluate the error flag on the next mount. A warning is printed
> in this case during the next mount and the log tree is ignored.
> 
> The issue is that it is possible that the superblock points to a root
> that was not written (due to write I/O errors).
> The result is that the filesystem cannot be mounted. btrfsck also does
> not start and all the other btrfs-progs tools fail to start as well.
> However, mount -o recovery is working well and does the right things
> to recover the filesystem (i.e., don't use the log root, clear the
> free space cache and use the next mountable root that is stored in the
> root backup array).
> 
> This patch removes the writing of the superblock when
> BTRFS_SUPER_FLAG_ERROR is set, and removes the handling of the error
> flag in the mount function.
> 

Yes, I have to admit that this can be a serious problem.

But we'll need to send the error flag stored in the super block into
disk in the future so that the next mount can find it unstable and do
fsck by itself maybe.

If we do not write the super any more, it cannot find the flag.

So can we find a way to make both things happy?

thanks,
liubo

> These lines can be used to reproduce the issue (using /dev/sdm):
> SCRATCH_DEV=/dev/sdm
> SCRATCH_MNT=/mnt
> echo 0 25165824 linear $SCRATCH_DEV 0 | dmsetup create foo
> ls -alLF /dev/mapper/foo
> mkfs.btrfs /dev/mapper/foo
> mount /dev/mapper/foo $SCRATCH_MNT
> echo bar > $SCRATCH_MNT/foo
> sync
> echo 0 25165824 error | dmsetup reload foo
> dmsetup resume foo
> ls -alF $SCRATCH_MNT
> touch $SCRATCH_MNT/1
> ls -alF $SCRATCH_MNT
> sleep 35
> echo 0 25165824 linear $SCRATCH_DEV 0 | dmsetup reload foo
> dmsetup resume foo
> sleep 1
> umount $SCRATCH_MNT
> btrfsck /dev/mapper/foo
> dmsetup remove foo
> 
> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
> Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
> ---
> Changes v1 -> v2:
> - Removed one large comment entirely which was not needed anymore
>   after the code changes.
> - Removed a warning message which was dead code since the super block
>   is not written anymore when the flag BTRFS_SUPER_FLAG_ERROR is set.
> - Removed the return code of btrfs_error_commit_super() since it now
>   does not return any errors anymore.
> 
>  fs/btrfs/disk-io.c | 36 ++++--------------------------------
>  fs/btrfs/disk-io.h |  2 +-
>  2 files changed, 5 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 502b20c..f6a1d0f 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2531,8 +2531,7 @@ retry_root_backup:
>  		goto fail_trans_kthread;
>  
>  	/* do not make disk changes in broken FS */
> -	if (btrfs_super_log_root(disk_super) != 0 &&
> -	    !(fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR)) {
> +	if (btrfs_super_log_root(disk_super) != 0) {
>  		u64 bytenr = btrfs_super_log_root(disk_super);
>  
>  		if (fs_devices->rw_devices == 0) {
> @@ -3192,30 +3191,14 @@ int close_ctree(struct btrfs_root *root)
>  	/* clear out the rbtree of defraggable inodes */
>  	btrfs_run_defrag_inodes(fs_info);
>  
> -	/*
> -	 * Here come 2 situations when btrfs is broken to flip readonly:
> -	 *
> -	 * 1. when btrfs flips readonly somewhere else before
> -	 * btrfs_commit_super, sb->s_flags has MS_RDONLY flag,
> -	 * and btrfs will skip to write sb directly to keep
> -	 * ERROR state on disk.
> -	 *
> -	 * 2. when btrfs flips readonly just in btrfs_commit_super,
> -	 * and in such case, btrfs cannot write sb via btrfs_commit_super,
> -	 * and since fs_state has been set BTRFS_SUPER_FLAG_ERROR flag,
> -	 * btrfs will cleanup all FS resources first and write sb then.
> -	 */
>  	if (!(fs_info->sb->s_flags & MS_RDONLY)) {
>  		ret = btrfs_commit_super(root);
>  		if (ret)
>  			printk(KERN_ERR "btrfs: commit super ret %d\n", ret);
>  	}
>  
> -	if (fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR) {
> -		ret = btrfs_error_commit_super(root);
> -		if (ret)
> -			printk(KERN_ERR "btrfs: commit super ret %d\n", ret);
> -	}
> +	if (fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR)
> +		btrfs_error_commit_super(root);
>  
>  	btrfs_put_block_group_cache(fs_info);
>  
> @@ -3437,18 +3420,11 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
>  	if (read_only)
>  		return 0;
>  
> -	if (fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR) {
> -		printk(KERN_WARNING "warning: mount fs with errors, "
> -		       "running btrfsck is recommended\n");
> -	}
> -
>  	return 0;
>  }
>  
> -int btrfs_error_commit_super(struct btrfs_root *root)
> +void btrfs_error_commit_super(struct btrfs_root *root)
>  {
> -	int ret;
> -
>  	mutex_lock(&root->fs_info->cleaner_mutex);
>  	btrfs_run_delayed_iputs(root);
>  	mutex_unlock(&root->fs_info->cleaner_mutex);
> @@ -3458,10 +3434,6 @@ int btrfs_error_commit_super(struct btrfs_root *root)
>  
>  	/* cleanup FS via transaction */
>  	btrfs_cleanup_transaction(root);
> -
> -	ret = write_ctree_super(NULL, root, 0);
> -
> -	return ret;
>  }
>  
>  static void btrfs_destroy_ordered_operations(struct btrfs_root *root)
> diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
> index 95e147e..c5b00a7 100644
> --- a/fs/btrfs/disk-io.h
> +++ b/fs/btrfs/disk-io.h
> @@ -54,7 +54,7 @@ int write_ctree_super(struct btrfs_trans_handle *trans,
>  		      struct btrfs_root *root, int max_mirrors);
>  struct buffer_head *btrfs_read_dev_super(struct block_device *bdev);
>  int btrfs_commit_super(struct btrfs_root *root);
> -int btrfs_error_commit_super(struct btrfs_root *root);
> +void btrfs_error_commit_super(struct btrfs_root *root);
>  struct extent_buffer *btrfs_find_tree_block(struct btrfs_root *root,
>  					    u64 bytenr, u32 blocksize);
>  struct btrfs_root *btrfs_read_fs_root_no_radix(struct btrfs_root *tree_root,
> 

