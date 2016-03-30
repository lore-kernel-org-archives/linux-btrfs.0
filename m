Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19648 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139AbcC3RKu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Mar 2016 13:10:50 -0400
Date: Wed, 30 Mar 2016 10:10:45 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fallback to vmalloc in btrfs_compare_tree
Message-ID: <20160330171044.GB20816@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1459346743-17191-1-git-send-email-dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1459346743-17191-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 30, 2016 at 04:05:43PM +0200, David Sterba wrote:
> The allocation of node could fail if the memory is too fragmented for a
> given node size, practically observed with 64k.

It's not a critical path.  Why not use vmalloc directly?

Thanks,

-liubo

> 
> http://article.gmane.org/gmane.comp.file-systems.btrfs/54689
> 
> Reported-by: Jean-Denis Girard <jd.girard@sysnux.pf>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/ctree.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 77592931ab4f..ec7928a27aaa 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -19,6 +19,7 @@
>  #include <linux/sched.h>
>  #include <linux/slab.h>
>  #include <linux/rbtree.h>
> +#include <linux/vmalloc.h>
>  #include "ctree.h"
>  #include "disk-io.h"
>  #include "transaction.h"
> @@ -5361,10 +5362,13 @@ int btrfs_compare_trees(struct btrfs_root *left_root,
>  		goto out;
>  	}
>  
> -	tmp_buf = kmalloc(left_root->nodesize, GFP_KERNEL);
> +	tmp_buf = kmalloc(left_root->nodesize, GFP_KERNEL | __GFP_NOWARN);
>  	if (!tmp_buf) {
> -		ret = -ENOMEM;
> -		goto out;
> +		tmp_buf = vmalloc(left_root->nodesize);
> +		if (!tmp_buf) {
> +			ret = -ENOMEM;
> +			goto out;
> +		}
>  	}
>  
>  	left_path->search_commit_root = 1;
> @@ -5565,7 +5569,7 @@ int btrfs_compare_trees(struct btrfs_root *left_root,
>  out:
>  	btrfs_free_path(left_path);
>  	btrfs_free_path(right_path);
> -	kfree(tmp_buf);
> +	kvfree(tmp_buf);
>  	return ret;
>  }
>  
> -- 
> 2.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
