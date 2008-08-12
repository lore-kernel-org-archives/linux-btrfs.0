From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] Introduce btrfs_iget helper
Date: Tue, 12 Aug 2008 14:46:54 -0400
Message-ID: <20080812184654.GA29426@infradead.org>
References: <200806290505.31641.balajirrao@gmail.com> <1218548800.2977.178.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Balaji Rao <balajirrao@gmail.com>, linux-btrfs@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1218548800.2977.178.camel@pmac.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

> +struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
> +			 struct btrfs_root *root, int *is_new)
> +{
> +	struct inode *inode;
> +
> +	inode = btrfs_iget_locked(s, location->objectid, root);
> +	if (!inode)
> +		return ERR_PTR(-EACCES);
> +
> +	if (inode->i_state & I_NEW) {
> +		BTRFS_I(inode)->root = root;
> +		memcpy(&BTRFS_I(inode)->location, location, sizeof(*location));
> +		btrfs_read_locked_inode(inode);
> +		unlock_new_inode(inode);
> +		if (is_new)
> +			*is_new = 1;
> +	} else {
> +		if (is_new)
> +			*is_new = 0;
> +	}
> +
> +	return inode;

Please leave the unlock_new_inode to the caller and kill the is_new
parameter. Gives much nicer to read code, and generally making sure the
inode is 100% ready and correct before unlocking it is a good idea, too
so that e.g. no one can actually access an inode marked bad due to a
generation number mismatch before it's marked bad.

> +}
> +
>  static struct dentry *btrfs_lookup(struct inode *dir, struct dentry *dentry,
>  				   struct nameidata *nd)
>  {
> @@ -1889,7 +1916,7 @@ static struct dentry *btrfs_lookup(struct inode *dir, struct dentry *dentry,
>  	struct btrfs_root *root = bi->root;
>  	struct btrfs_root *sub_root = root;
>  	struct btrfs_key location;
> -	int ret, do_orphan = 0;
> +	int ret, new, do_orphan = 0;
>  
>  	if (dentry->d_name.len > BTRFS_NAME_LEN)
>  		return ERR_PTR(-ENAMETOOLONG);
> @@ -1907,23 +1934,15 @@ static struct dentry *btrfs_lookup(struct inode *dir, struct dentry *dentry,
>  			return ERR_PTR(ret);
>  		if (ret > 0)
>  			return ERR_PTR(-ENOENT);
> -
> -		inode = btrfs_iget_locked(dir->i_sb, location.objectid,
> -					  sub_root);
> -		if (!inode)
> -			return ERR_PTR(-EACCES);
> -		if (inode->i_state & I_NEW) {
> -			/* the inode and parent dir are two different roots */
> -			if (sub_root != root) {
> -				igrab(inode);
> -				sub_root->inode = inode;
> -				do_orphan = 1;
> -			}
> -			BTRFS_I(inode)->root = sub_root;
> -			memcpy(&BTRFS_I(inode)->location, &location,
> -			       sizeof(location));
> -			btrfs_read_locked_inode(inode);
> -			unlock_new_inode(inode);
> +		inode = btrfs_iget(dir->i_sb, &location, sub_root, &new);
> +		if (IS_ERR(inode))
> +			return ERR_CAST(inode);
> +
> +		/* the inode and parent dir are two different roots */
> +		if (new && root != sub_root) {
> +			igrab(inode);
> +			sub_root->inode = inode;
> +			do_orphan = 1;
>  		}
>  	}
>  
> -- 
> 1.5.5.1
> 
> 
> -- 
> David Woodhouse                            Open Source Technology Centre
> David.Woodhouse@intel.com                              Intel Corporation
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
