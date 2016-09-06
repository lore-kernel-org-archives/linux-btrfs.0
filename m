Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51512 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750940AbcIFQvx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Sep 2016 12:51:53 -0400
Date: Tue, 6 Sep 2016 18:50:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 7/7] Btrfs: fix memory leak due to invalid btree height
Message-ID: <20160906165019.GE16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1463184422-13584-1-git-send-email-bo.li.liu@oracle.com>
 <1463184422-13584-7-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1463184422-13584-7-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 13, 2016 at 05:07:02PM -0700, Liu Bo wrote:
> Thanks to fuzz testing, we can have invalid btree root node height.

Shouldn't we do this kind of sanity checks earlier? Not at the search
slot time but when it's read from disk. The check that you're adding can
stay, but without the early check we could hit it very often thus making
it very noisy.

> Btrfs limits btree height to 7 and if the given height is 9, then btrfs
> will have problems in both releasing root node's lock and freeing the node.


> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/ctree.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index ec7928a..3fccbcc 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -2756,6 +2756,13 @@ again:
>  			}
>  		}
>  	}
> +	if (level > BTRFS_MAX_LEVEL - 1 || level < 0) {
> +		WARN_ONCE(1, KERN_WARNING "Invalid btree height %d\n", level);
> +		if (!p->skip_locking)
> +			btrfs_tree_unlock_rw(b, root_lock);
> +		free_extent_buffer(b);
> +		return -EINVAL;
> +	}
>  	p->nodes[level] = b;
>  	if (!p->skip_locking)
>  		p->locks[level] = root_lock;
> -- 
> 2.5.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
