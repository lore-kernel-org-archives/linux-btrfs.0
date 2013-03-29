Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26228 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092Ab3C2CMj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Mar 2013 22:12:39 -0400
Date: Fri, 29 Mar 2013 10:10:24 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: find free ino outside of the transaction and
 cleanup properly
Message-ID: <20130329021021.GA7551@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <1364495166-19396-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1364495166-19396-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 28, 2013 at 02:26:06PM -0400, Josef Bacik wrote:
> A user reported a hang on mount and it looks like we are waiting for the inode
> cache to fill up.  The caching thread will stop if it sees that we are
> committing a transaction every time it has to move leaves and then it will
> re-search.  But we call btrfs_find_free_ino() inside of a transaction so if the
> transaction goes to commit it will be held open while we wait for an inode to
> show up.  This will make the caching thread take for freaking ever and appear to
> lock up the box.  The other thing this patch fixes is that if we have an error
> creating the inode we won't properly free up the inode number we just took, so
> we could leak inode numbers if we have inode caching on in this case.  Thanks,

Looks good to me.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  fs/btrfs/inode.c |   52 ++++++++++++++++++++++++++++++++--------------------
>  1 files changed, 32 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index b883815..725e268 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -5713,23 +5713,26 @@ static int btrfs_mknod(struct inode *dir, struct dentry *dentry,
>  	if (!new_valid_dev(rdev))
>  		return -EINVAL;
>  
> +	err = btrfs_find_free_ino(root, &objectid);
> +	if (err)
> +		return err;
> +
>  	/*
>  	 * 2 for inode item and ref
>  	 * 2 for dir items
>  	 * 1 for xattr if selinux is on
>  	 */
>  	trans = btrfs_start_transaction(root, 5);
> -	if (IS_ERR(trans))
> +	if (IS_ERR(trans)) {
> +		btrfs_return_ino(root, objectid);
>  		return PTR_ERR(trans);
> -
> -	err = btrfs_find_free_ino(root, &objectid);
> -	if (err)
> -		goto out_unlock;
> +	}
>  
>  	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
>  				dentry->d_name.len, btrfs_ino(dir), objectid,
>  				mode, &index);
>  	if (IS_ERR(inode)) {
> +		btrfs_return_ino(root, objectid);
>  		err = PTR_ERR(inode);
>  		goto out_unlock;
>  	}
> @@ -5777,23 +5780,26 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
>  	u64 objectid;
>  	u64 index = 0;
>  
> +	err = btrfs_find_free_ino(root, &objectid);
> +	if (err)
> +		return err;
> +
>  	/*
>  	 * 2 for inode item and ref
>  	 * 2 for dir items
>  	 * 1 for xattr if selinux is on
>  	 */
>  	trans = btrfs_start_transaction(root, 5);
> -	if (IS_ERR(trans))
> +	if (IS_ERR(trans)) {
> +		btrfs_return_ino(root, objectid);
>  		return PTR_ERR(trans);
> -
> -	err = btrfs_find_free_ino(root, &objectid);
> -	if (err)
> -		goto out_unlock;
> +	}
>  
>  	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
>  				dentry->d_name.len, btrfs_ino(dir), objectid,
>  				mode, &index);
>  	if (IS_ERR(inode)) {
> +		btrfs_return_ino(root, objectid);
>  		err = PTR_ERR(inode);
>  		goto out_unlock;
>  	}
> @@ -5906,24 +5912,27 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
>  	u64 objectid = 0;
>  	u64 index = 0;
>  
> +	err = btrfs_find_free_ino(root, &objectid);
> +	if (err)
> +		return err;
> +
>  	/*
>  	 * 2 items for inode and ref
>  	 * 2 items for dir items
>  	 * 1 for xattr if selinux is on
>  	 */
>  	trans = btrfs_start_transaction(root, 5);
> -	if (IS_ERR(trans))
> +	if (IS_ERR(trans)) {
> +		btrfs_return_ino(root, objectid);
>  		return PTR_ERR(trans);
> -
> -	err = btrfs_find_free_ino(root, &objectid);
> -	if (err)
> -		goto out_fail;
> +	}
>  
>  	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
>  				dentry->d_name.len, btrfs_ino(dir), objectid,
>  				S_IFDIR | mode, &index);
>  	if (IS_ERR(inode)) {
>  		err = PTR_ERR(inode);
> +		btrfs_return_ino(root, objectid);
>  		goto out_fail;
>  	}
>  
> @@ -8407,23 +8416,26 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
>  	if (name_len > BTRFS_MAX_INLINE_DATA_SIZE(root))
>  		return -ENAMETOOLONG;
>  
> +	err = btrfs_find_free_ino(root, &objectid);
> +	if (err)
> +		return err;
> +
>  	/*
>  	 * 2 items for inode item and ref
>  	 * 2 items for dir items
>  	 * 1 item for xattr if selinux is on
>  	 */
>  	trans = btrfs_start_transaction(root, 5);
> -	if (IS_ERR(trans))
> +	if (IS_ERR(trans)) {
> +		btrfs_return_ino(root, objectid);
>  		return PTR_ERR(trans);
> -
> -	err = btrfs_find_free_ino(root, &objectid);
> -	if (err)
> -		goto out_unlock;
> +	}
>  
>  	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
>  				dentry->d_name.len, btrfs_ino(dir), objectid,
>  				S_IFLNK|S_IRWXUGO, &index);
>  	if (IS_ERR(inode)) {
> +		btrfs_return_ino(root, objectid);
>  		err = PTR_ERR(inode);
>  		goto out_unlock;
>  	}
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
