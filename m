Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43743 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777Ab3BVBod (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Feb 2013 20:44:33 -0500
Date: Fri, 22 Feb 2013 09:43:13 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: make sure NODATACOW also gets NODATASUM set
Message-ID: <20130222014312.GA11000@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <1361478855-5059-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1361478855-5059-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 21, 2013 at 03:34:15PM -0500, Josef Bacik wrote:
> A user reported hitting the BUG_ON() in btrfs_finished_ordered_io() where we had
> csums on a NOCOW extent.  This can happen if we have NODATACOW set but not
> NODATASUM set, which can happen in two cases, either we mount with -o nodatacow
> and then write into preallocated space, or chattr +C a directory and move a file
> into that directory.  This patch fixes up those two cases and now we should
> uniformly have NODATACOW and NODATASUM set always.  Thanks,

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  fs/btrfs/inode.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 40d49da..5d7ceb5 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -5574,7 +5574,8 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
>  		if (btrfs_test_opt(root, NODATASUM))
>  			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATASUM;
>  		if (btrfs_test_opt(root, NODATACOW))
> -			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATACOW;
> +			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATACOW |
> +				BTRFS_INODE_NODATASUM;
>  	}
>  
>  	insert_inode_hash(inode);
> @@ -8069,7 +8070,8 @@ static void fixup_inode_flags(struct inode *dir, struct inode *inode)
>  	struct btrfs_inode *b_inode = BTRFS_I(inode);
>  
>  	if (b_dir->flags & BTRFS_INODE_NODATACOW)
> -		b_inode->flags |= BTRFS_INODE_NODATACOW;
> +		b_inode->flags |= BTRFS_INODE_NODATACOW |
> +			BTRFS_INODE_NODATASUM;
>  	else
>  		b_inode->flags &= ~BTRFS_INODE_NODATACOW;
>  
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
