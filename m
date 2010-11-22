From: Ian Kent <raven@themaw.net>
Subject: Re: [PATCH] Btrfs: setup blank root and fs_info for mount time
Date: Mon, 22 Nov 2010 10:21:38 +0800
Message-ID: <1290392498.2602.21.camel@perseus.themaw.net>
References: <1290196755-19607-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1290196755-19607-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2010-11-19 at 14:59 -0500, Josef Bacik wrote:
> There is a problem with how we use sget, it searches through the list of supers
> attached to the fs_type looking for a super with the same fs_devices as what
> we're trying to mount.  This depends on sb->s_fs_info being filled, but we don't
> fill that in until we get to btrfs_fill_super, so we could hit supers on the
> fs_type super list that have a null s_fs_info.  In order to fix that we need to
> go ahead and setup a blank root with a blank fs_info to hold fs_devices, that
> way our test will work out right and then we can set s_fs_info in
> btrfs_set_super, and then open_ctree will simply use our pre-allocated root and
> fs_info when setting everything up.  Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
>  fs/btrfs/disk-io.c |    6 ++----
>  fs/btrfs/super.c   |   35 ++++++++++++++++++++++++++++++++---
>  2 files changed, 34 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index fb827d0..f0aa204 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1538,10 +1538,8 @@ struct btrfs_root *open_ctree(struct super_block *sb,
>  						 GFP_NOFS);
>  	struct btrfs_root *csum_root = kzalloc(sizeof(struct btrfs_root),
>  						 GFP_NOFS);
> -	struct btrfs_root *tree_root = kzalloc(sizeof(struct btrfs_root),
> -					       GFP_NOFS);
> -	struct btrfs_fs_info *fs_info = kzalloc(sizeof(*fs_info),
> -						GFP_NOFS);
> +	struct btrfs_root *tree_root = btrfs_sb(sb);
> +	struct btrfs_fs_info *fs_info = tree_root->fs_info;
>  	struct btrfs_root *chunk_root = kzalloc(sizeof(struct btrfs_root),
>  						GFP_NOFS);
>  	struct btrfs_root *dev_root = kzalloc(sizeof(struct btrfs_root),
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 8299a25..9145551 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -562,12 +562,20 @@ static int btrfs_show_options(struct seq_file *seq, struct vfsmount *vfs)
>  
>  static int btrfs_test_super(struct super_block *s, void *data)
>  {
> -	struct btrfs_fs_devices *test_fs_devices = data;
> +	struct btrfs_root *test_root = data;
>  	struct btrfs_root *root = btrfs_sb(s);
>  
> -	return root->fs_info->fs_devices == test_fs_devices;
> +	return root->fs_info->fs_devices == test_root->fs_info->fs_devices;
>  }
>  
> +static int btrfs_set_super(struct super_block *s, void *data)
> +{
> +	s->s_fs_info = data;
> +
> +	return set_anon_super(s, data);
> +}
> +
> +
>  /*
>   * Find a superblock for the given device / mount point.
>   *
> @@ -581,6 +589,8 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
>  	struct super_block *s;
>  	struct dentry *root;
>  	struct btrfs_fs_devices *fs_devices = NULL;
> +	struct btrfs_root *tree_root = NULL;
> +	struct btrfs_fs_info *fs_info = NULL;
>  	fmode_t mode = FMODE_READ;
>  	char *subvol_name = NULL;
>  	u64 subvol_objectid = 0;
> @@ -608,8 +618,25 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
>  		goto error_close_devices;
>  	}
>  
> +	/*
> +	 * Setup a dummy root and fs_info for test/set super.  This is because
> +	 * we don't actually fill this stuff out until open_ctree, but we need
> +	 * it for searching for existing supers, so this lets us do that and
> +	 * then open_ctree will properly initialize everything later.
> +	 */
> +	fs_info = kzalloc(sizeof(struct btrfs_fs_info), GFP_NOFS);
> +	tree_root = kzalloc(sizeof(struct btrfs_root), GFP_NOFS);
> +	if (!fs_info || !tree_root) {
> +		kfree(fs_info);
> +		kfree(tree_root);
> +		goto error_close_devices;
> +	}
> +	fs_info->tree_root = tree_root;
> +	fs_info->fs_devices = fs_devices;
> +	tree_root->fs_info = fs_info;
> +
>  	bdev = fs_devices->latest_bdev;
> -	s = sget(fs_type, btrfs_test_super, set_anon_super, fs_devices);
> +	s = sget(fs_type, btrfs_test_super, btrfs_set_super, tree_root);
>  	if (IS_ERR(s))
>  		goto error_s;

There's no context here to comment against but just below there's a
check on s->s_root which tells us that an existing super block was
found. If the flags test then fails these two allocations are freed in
the error exit otherwise the existing super is used and the new fs_info
and tree_root are leaked.

I thought you were going to merge my patch for that in to yours?

>  
> @@ -675,6 +702,8 @@ error_s:
>  	error = PTR_ERR(s);
>  error_close_devices:
>  	btrfs_close_devices(fs_devices);
> +	kfree(fs_info);
> +	kfree(tree_root);
>  error_free_subvol_name:
>  	kfree(subvol_name);
>  	return ERR_PTR(error);

This is a race against other processes that are mounting but there is
the very small race window for processes that are umounting as well. I
know you didn't think that was a problem but I think that was mostly
because of how I described it. I was hoping you would have another look
at that and include my patch in your series since it is related to this
problem.

Have a look in fs/super.c:generic_shutdown_super(), called by
fs/super.c:kill_anon_super(), where the super method ->put_super() is
called, setting the super s_fs_info to NULL, before taking the sb_lock
and removing it from the list of supers.

Here's my patch.

btrfs - fix race between btrfs_get_sb() and umount

From: Ian Kent <raven@themaw.net>

When mounting a btrfs file system btrfs_test_super() may attempt to
use sb->s_fs_info, the btrfs root, of a super block that is going away
and that has had the btrfs root set to NULL in its ->put_super(). But
if the super block is going away it cannot be an existing super block
so we can return false in this case.

Signed-off-by: Ian Kent <raven@themaw.net>
---

 fs/btrfs/super.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)


diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 6b57da3..960b320 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -565,6 +565,12 @@ static int btrfs_test_super(struct super_block *s, void *data)
 	struct btrfs_fs_devices *test_fs_devices = data->fs_info->fs_devices;
 	struct btrfs_root *root = btrfs_sb(s);
 
+	/*
+	 * If this super block is going away, return false as it
+	 * can't match as an existing super block.
+	 */
+	if (!atomic_read(&s->s_active))
+		return 0;
 	return root->fs_info->fs_devices == test_fs_devices;
 }
 


