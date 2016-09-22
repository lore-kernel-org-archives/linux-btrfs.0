Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30707 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935429AbcIVSD4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Sep 2016 14:03:56 -0400
Date: Thu, 22 Sep 2016 11:03:45 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH] Btrfs: don't BUG() during drop snapshot
Message-ID: <20160922180345.GB12906@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1474556904-22495-1-git-send-email-dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1474556904-22495-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 22, 2016 at 05:08:24PM +0200, David Sterba wrote:
> From: Josef Bacik <jbacik@fb.com>
> 
> Really there's lots of things that can go wrong here, kill all the
> BUG_ON()'s and replace the logic ones with ASSERT()'s and return EIO
> instead.
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/extent-tree.c | 27 +++++++++++++++++++++++----
>  1 file changed, 23 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index c95f85c292a4..37aba7d00c8f 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -8884,12 +8884,15 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
>  				       &wc->flags[level - 1]);
>  	if (ret < 0) {
>  		btrfs_tree_unlock(next);
> +		free_extent_buffer(next);
>  		return ret;
>  	}
>  
>  	if (unlikely(wc->refs[level - 1] == 0)) {
>  		btrfs_err(root->fs_info, "Missing references.");
> -		BUG();
> +		btrfs_tree_unlock(next);
> +		free_extent_buffer(next);
> +		return -EIO;
>  	}
>  	*lookup_info = 0;
>  
> @@ -8941,7 +8944,13 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
>  	}
>  
>  	level--;
> -	BUG_ON(level != btrfs_header_level(next));
> +	ASSERT(level == btrfs_header_level(next));
> +	if (level != btrfs_header_level(next)) {
> +		btrfs_err("mismatched level");
> +		btrfs_tree_unlock(next);
> +		free_extent_buffer(next);
> +		return -EIO;
> +	}
>  	path->nodes[level] = next;
>  	path->slots[level] = 0;
>  	path->locks[level] = BTRFS_WRITE_LOCK_BLOCKING;
> @@ -8956,8 +8965,14 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
>  		if (wc->flags[level] & BTRFS_BLOCK_FLAG_FULL_BACKREF) {
>  			parent = path->nodes[level]->start;
>  		} else {
> -			BUG_ON(root->root_key.objectid !=
> +			ASSERT(root->root_key.objectid ==
>  			       btrfs_header_owner(path->nodes[level]));
> +			if (root->root_key.objectid !=
> +			    btrfs_header_owner(path->nodes[level])) {
> +				btrfs_err("mismatched block owner");
> +				btrfs_tree_unlock(next);
> +				free_extent_buffer(next);

We need a 'return' here, otherwise the next 'if (need_account)' may use
@next after free.

> +			}
>  			parent = 0;
>  		}
>  
> @@ -8972,7 +8987,11 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
>  		}
>  		ret = btrfs_free_extent(trans, root, bytenr, blocksize, parent,
>  				root->root_key.objectid, level - 1, 0);
> -		BUG_ON(ret); /* -ENOMEM */
> +		if (ret) {
> +			btrfs_tree_unlock(next);
> +			free_extent_buffer(next);
> +			return ret;
> +		}
>  	}

Can we put a label of "out" here since most of the above cleanups use
the same way to bail out?

Thanks,

-liubo
>  	btrfs_tree_unlock(next);
>  	free_extent_buffer(next);
> -- 
> 2.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
