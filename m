From: Johann Lombardi <johann@whamcloud.com>
Subject: Re: [PATCH 2/2 v2] Btrfs: Per file/directory controls for COW and
 compression
Date: Mon, 21 Mar 2011 18:43:49 +0100
Message-ID: <20110321174348.GC8235@granier.hd.free.fr>
References: <4D8712E9.108@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D8712E9.108@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 21, 2011 at 04:57:13PM +0800, liubo wrote:
> @@ -4581,8 +4583,6 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
>  	location->offset = 0;
>  	btrfs_set_key_type(location, BTRFS_INODE_ITEM_KEY);
>  
> -	btrfs_inherit_iflags(inode, dir);
> -
>  	if ((mode & S_IFREG)) {
>  		if (btrfs_test_opt(root, NODATASUM))
>  			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATASUM;
> @@ -4590,6 +4590,8 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
>  			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATACOW;
>  	}
>  
> +	btrfs_inherit_iflags(inode, dir);

The problem is that btrfs_inherit_iflags() overwrites BTRFS_I(inode)->flags with the parent's flags, so you lose BTRFS_INODE_NODATA{SUM|COW}.

Johann
