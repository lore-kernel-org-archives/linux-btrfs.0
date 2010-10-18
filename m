From: Ian Kent <raven@themaw.net>
Subject: Re: [PATCH V3] Removing a subvolume with a simple "rm -rf"
Date: Mon, 18 Oct 2010 14:30:16 +0800
Message-ID: <1287383416.3114.41.camel@localhost>
References: <201010171809.58152.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: kreijack@libero.it
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201010171809.58152.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 2010-10-17 at 18:09 +0200, Goffredo Baroncelli wrote:
> Hi all,
> 
> enclosed you can find a new version of the patch which permits to remove a 
> volume via the rmdir(2) syscall by a non-root user. The goal of this patch 
> is to permits to remove a subvolume with a simple "rm -rf" command.
> 
> The rules for a subvolume removal are the same ones of a directory:
> - the user must have the write permission on the parent directory
> - the subvolume must be empty
> 
> The mains differences between calling rmdir(2) on a subvolume and calling the 
> BTRFS_IOC_SNAP_DESTROY ioctl are:
> 
> - rmdir(2) requires the subvolume to be empty (the user has to empty the 
> subvolume before removing it, like the rm -rf command does)
> - rmdir(2) is a synchronous operation (instead BTRFS_IOC_SNAP_DESTROY works 
> in background)
> 
> The previous statements have the following (nice) consequences:
> 
> - the CAP_ADMIN capability is not mandatory anymore to remove a subvolume. 
> BTRFS_IOC_SNAP_DESTROY requires CAP_ADMIN because the subvolume removal is
> performed in background so it would not be possible to return an error if 
> the user has not the privilege of removing a file. This explain why this ioctl
> may be executed only by root.
> 
> - When the rmdir(2) syscall returns, the space is really freed.
> 
> The only advantage of the BTRFS_IOC_SNAP_DESTROY ioctl is its greater speed
> in removing a not empty subvolume.
> 
> I simplify the code respect my previous post, removing a un-needed call to the
> function may_destroy_subvol(). Moreover I added a call to the d_invalidate()
>  function, which was missed in my previous version.
> 
> You can pull the code from the branch named "rmdir-subvolume" of the following
> repository:
> 
> 	http://cassiopea.homelinux.net/git/btrfs-unstable.git  
> 
> As usual, comments are welcome
> 
> Regards
> G.Baroncelli
> 
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index f08427c..f732ddf 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -2944,6 +2944,88 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
>  	return 0;
>  }
>  
> +static noinline int btrfs_snap_destroy(struct inode *dir,
> +				       struct dentry *dentry)
> +{
> +
> +	struct inode *inode;
> +	struct btrfs_root *root = BTRFS_I(dir)->root;
> +	struct btrfs_root *dest = NULL;
> +	struct btrfs_trans_handle *trans;
> +	int ret;
> +	int err = 0;
> +
> +	if (IS_ERR(dentry)) {
> +		err = PTR_ERR(dentry);
> +		goto out;
> +	}
> +
> +	if (!dentry->d_inode) {
> +		err = -ENOENT;
> +		goto out;
> +	}
> +
> +	inode = dentry->d_inode;
> +	if (inode->i_ino != BTRFS_FIRST_FREE_OBJECTID) {
> +		err = -EINVAL;
> +		goto out;
> +	}
> +
> +	dest = BTRFS_I(inode)->root;
> +	
> +	err = d_invalidate(dentry);
> +	if (err)
> +		goto out;
> +
> +	down_write(&root->fs_info->subvol_sem);
> +
> +	/* remove this check because the directory is empty.
> +	 * err = may_destroy_subvol(dest);
> +	 * if (err)
> +	 *	goto out_up_write;
> +	 */
> +
> +	trans = btrfs_start_transaction(root, 0);
> +	if (IS_ERR(trans)) {
> +		err = PTR_ERR(trans);
> +		goto out_up_write;
> +	}

Mmm ... sorry to be picky but can this really fail?

Won't you be left with a dentry invisible to the VFS but with an
existing subvol?

> +	trans->block_rsv = &root->fs_info->global_block_rsv;
> +
> +	ret = btrfs_unlink_subvol(trans, root, dir,
> +				dest->root_key.objectid,
> +				dentry->d_name.name,
> +				dentry->d_name.len);
> +	BUG_ON(ret);

What happens if this fails?

Will the file system look corrupt after the reboot, or will the
transaction simply not have been flushed to the disk (ie. not committed
I guess), leaving it looking OK?

> +
> +	btrfs_record_root_in_trans(trans, dest);
> +
> +	memset(&dest->root_item.drop_progress, 0,
> +		sizeof(dest->root_item.drop_progress));
> +	dest->root_item.drop_level = 0;
> +	btrfs_set_root_refs(&dest->root_item, 0);
> +
> +	if (!xchg(&dest->orphan_item_inserted, 1)) {
> +		ret = btrfs_insert_orphan_item(trans,
> +					root->fs_info->tree_root,
> +					dest->root_key.objectid);
> +		BUG_ON(ret);

Same Q?

> +	}
> +
> +	ret = btrfs_commit_transaction(trans, root);
> +	BUG_ON(ret);

And again?

> +	inode->i_flags |= S_DEAD;
> +out_up_write:
> +	up_write(&root->fs_info->subvol_sem);
> +	if (!err) {
> +		shrink_dcache_sb(root->fs_info->sb);
> +		btrfs_invalidate_inodes(dest);
> +		/*d_delete(dentry);*/
> +	}
> +out:
> +	return err;
> +}
> +
>  static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
>  {
>  	struct inode *inode = dentry->d_inode;
> @@ -2952,10 +3034,12 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
>  	struct btrfs_trans_handle *trans;
>  	unsigned long nr = 0;
>  
> -	if (inode->i_size > BTRFS_EMPTY_DIR_SIZE ||
> -	    inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)
> +	if (inode->i_size > BTRFS_EMPTY_DIR_SIZE)
>  		return -ENOTEMPTY;
>  
> +	if (inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)
> +		return btrfs_snap_destroy(dir, dentry);
> +
>  	trans = __unlink_start_trans(dir, dentry);
>  	if (IS_ERR(trans))
>  		return PTR_ERR(trans);
> 
> 


