Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slow1-d.mail.gandi.net ([217.70.178.86]:34302 "EHLO
	slow1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab3KBQ76 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Nov 2013 12:59:58 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
	by slow1-d.mail.gandi.net (Postfix) with ESMTP id E1D2B47A262
	for <linux-btrfs@vger.kernel.org>; Sat,  2 Nov 2013 17:59:57 +0100 (CET)
Date: Sat, 2 Nov 2013 09:59:32 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: opw-kernel@googlegroups.com, linux-btrfs@vger.kernel.org
Subject: Re: [OPW kernel] [PATCH v2] btrfs: Replace multiple atomic_inc()
 with atomic_add()
Message-ID: <20131102165932.GI15704@leaf>
References: <20131030212314.GA25069@gmail.com>
 <1383169362-25993-1-git-send-email-rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1383169362-25993-1-git-send-email-rashika.kheria@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 31, 2013 at 03:12:42AM +0530, Rashika Kheria wrote:
> This patch replaces multiple atomic_inc() with atomic_add() in
> delayed-inode.c to reduce source code and have few instructions
> for compilation.
> 
> Reviewed-by: Zach Brown <zab@redhat.com>
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

> 
> This revision fixes the following issues of the previous revision-
> Space in comment
> 
>  fs/btrfs/delayed-inode.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> index cbd9523..504a9b5 100644
> --- a/fs/btrfs/delayed-inode.c
> +++ b/fs/btrfs/delayed-inode.c
> @@ -108,8 +108,8 @@ static struct btrfs_delayed_node *btrfs_get_delayed_node(struct inode *inode)
>  			return node;
>  		}
>  		btrfs_inode->delayed_node = node;
> -		atomic_inc(&node->refs);	/* can be accessed */
> -		atomic_inc(&node->refs);	/* cached in the inode */
> +		/* can be accessed and cached in the inode */
> +		atomic_add(2, &node->refs);
>  		spin_unlock(&root->inode_lock);
>  		return node;
>  	}
> @@ -138,8 +138,8 @@ again:
>  		return ERR_PTR(-ENOMEM);
>  	btrfs_init_delayed_node(node, root, ino);
>  
> -	atomic_inc(&node->refs);	/* cached in the btrfs inode */
> -	atomic_inc(&node->refs);	/* can be accessed */
> +	/* cached in the btrfs inode and can be accessed */
> +	atomic_add(2, &node->refs);
>  
>  	ret = radix_tree_preload(GFP_NOFS & ~__GFP_HIGHMEM);
>  	if (ret) {
> -- 
> 1.7.9.5
> 
> -- 
> You received this message because you are subscribed to the Google Groups "opw-kernel" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to opw-kernel+unsubscribe@googlegroups.com.
> For more options, visit https://groups.google.com/groups/opt_out.
