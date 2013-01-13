Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46957 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab3AMMeg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Jan 2013 07:34:36 -0500
Date: Sun, 13 Jan 2013 20:32:10 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: update timestamps on truncate()
Message-ID: <20130113123208.GB2784@liubo>
Reply-To: bo.li.liu@oracle.com
References: <50F0D112.3020407@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50F0D112.3020407@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 11, 2013 at 08:57:22PM -0600, Eric Sandeen wrote:
> truncate() vs. ftruncate() differ in the VFS; truncate()
> doesn't set (ATTR_CTIME | ATTR_MTIME), and it's up to the
> fs to do the timestamp updates if the size changes.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> Hm, am I breaking the rules by updating the vfs inode fields
> before the transaction starts?

IMO it is ok since we'll modify these info in btree during a
transaction.

thanks,
liubo

> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 16d9e8e..af1ab2d 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -88,7 +88,7 @@ static unsigned char btrfs_type_by_mode[S_IFMT >> S_SHIFT] = {
>  	[S_IFLNK >> S_SHIFT]	= BTRFS_FT_SYMLINK,
>  };
>  
> -static int btrfs_setsize(struct inode *inode, loff_t newsize);
> +static int btrfs_setsize(struct inode *inode, struct iattr *attr);
>  static int btrfs_truncate(struct inode *inode);
>  static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent);
>  static noinline int cow_file_range(struct inode *inode,
> @@ -3748,16 +3748,27 @@ next:
>  	return err;
>  }
>  
> -static int btrfs_setsize(struct inode *inode, loff_t newsize)
> +static int btrfs_setsize(struct inode *inode, struct iattr *attr)
>  {
>  	struct btrfs_root *root = BTRFS_I(inode)->root;
>  	struct btrfs_trans_handle *trans;
>  	loff_t oldsize = i_size_read(inode);
> +	loff_t newsize = attr->ia_size;
> +	int mask = attr->ia_valid;
>  	int ret;
>  
>  	if (newsize == oldsize)
>  		return 0;
>  
> +	/*
> +	 * The regular truncate() case without ATTR_CTIME and ATTR_MTIME is a
> +	 * special case where we need to update the times despite not having
> +	 * these flags set.  For all other operations the VFS set these flags
> +	 * explicitly if it wants a timestamp update.
> +	 */
> +	if (newsize != oldsize && (!(mask & (ATTR_CTIME | ATTR_MTIME))))
> +		inode->i_ctime = inode->i_mtime = current_fs_time(inode->i_sb);
> +
>  	if (newsize > oldsize) {
>  		truncate_pagecache(inode, oldsize, newsize);
>  		ret = btrfs_cont_expand(inode, oldsize, newsize);
> @@ -3805,7 +3816,7 @@ static int btrfs_setattr(struct dentry *dentry, struct iattr *attr)
>  		return err;
>  
>  	if (S_ISREG(inode->i_mode) && (attr->ia_valid & ATTR_SIZE)) {
> -		err = btrfs_setsize(inode, attr->ia_size);
> +		err = btrfs_setsize(inode, attr);
>  		if (err)
>  			return err;
>  	}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
