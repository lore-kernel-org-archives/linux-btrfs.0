Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-pro1.mana.pf ([202.3.225.198]:42048 "EHLO
	smtp-pro1.mana.pf" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407AbcC3Rzk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Mar 2016 13:55:40 -0400
Subject: Re: [PATCH] btrfs: fallback to vmalloc in btrfs_compare_tree
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <1459346743-17191-1-git-send-email-dsterba@suse.com>
From: Jean-Denis Girard <jd.girard@sysnux.pf>
Message-ID: <56FC1318.1010007@sysnux.pf>
Date: Wed, 30 Mar 2016 07:55:36 -1000
MIME-Version: 1.0
In-Reply-To: <1459346743-17191-1-git-send-email-dsterba@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

Le 30/03/2016 04:05, David Sterba a écrit :
> The allocation of node could fail if the memory is too fragmented for a
> given node size, practically observed with 64k.
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
> 

I adapted / applied the patch for kernel-4.4.6, rebooted and now the
backup completes without error, thanks a lot!

Tested by:  Jean-Denis Girard <jd.girard@sysnux.pf>


Thanks,
-- 
Jean-Denis Girard

SysNux                Systèmes   Linux   en   Polynésie   française
http://www.sysnux.pf/ Tél: +689 40.50.10.40 / GSM: +689 87.79.75.27
