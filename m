Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40588 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752259AbcIWSCJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Sep 2016 14:02:09 -0400
Date: Fri, 23 Sep 2016 11:01:59 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, jbacik@fb.com
Subject: Re: [PATCH v2] Btrfs: don't BUG() during drop snapshot
Message-ID: <20160923180158.GA27026@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1474556904-22495-1-git-send-email-dsterba@suse.com>
 <1474629808-30823-1-git-send-email-dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1474629808-30823-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 23, 2016 at 01:23:28PM +0200, David Sterba wrote:
> From: Josef Bacik <jbacik@fb.com>
> 
> Really there's lots of things that can go wrong here, kill all the
> BUG_ON()'s and replace the logic ones with ASSERT()'s and return EIO
> instead.
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> [ switched to btrfs_err, errors go to common label ]
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
> 
> - added missing return to one branch
> - merge common exit code to a label, minor reordering
> 
>  fs/btrfs/extent-tree.c | 38 +++++++++++++++++++++++++++-----------
>  1 file changed, 27 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index b6e8b58f05e4..7a0b09fb18e2 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -8922,15 +8922,13 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
>  	ret = btrfs_lookup_extent_info(trans, root, bytenr, level - 1, 1,
>  				       &wc->refs[level - 1],
>  				       &wc->flags[level - 1]);
> -	if (ret < 0) {
> -		btrfs_tree_unlock(next);
> -		free_extent_buffer(next);
> -		return ret;
> -	}
> +	if (ret < 0)
> +		goto out_unlock;
>  
>  	if (unlikely(wc->refs[level - 1] == 0)) {
>  		btrfs_err(root->fs_info, "Missing references.");
> -		BUG();
> +		ret = -EIO;
> +		goto out_unlock;
>  	}
>  	*lookup_info = 0;
>  
> @@ -8982,7 +8980,12 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
>  	}
>  
>  	level--;
> -	BUG_ON(level != btrfs_header_level(next));
> +	ASSERT(level == btrfs_header_level(next));
> +	if (level != btrfs_header_level(next)) {
> +		btrfs_err(root->fs_info, "mismatched level");
> +		ret = -EIO;
> +		goto out_unlock;
> +	}
>  	path->nodes[level] = next;
>  	path->slots[level] = 0;
>  	path->locks[level] = BTRFS_WRITE_LOCK_BLOCKING;
> @@ -8997,8 +9000,15 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
>  		if (wc->flags[level] & BTRFS_BLOCK_FLAG_FULL_BACKREF) {
>  			parent = path->nodes[level]->start;
>  		} else {
> -			BUG_ON(root->root_key.objectid !=
> +			ASSERT(root->root_key.objectid ==
>  			       btrfs_header_owner(path->nodes[level]));
> +			if (root->root_key.objectid !=
> +			    btrfs_header_owner(path->nodes[level])) {
> +				btrfs_err(root->fs_info,
> +						"mismatched block owner");
> +				ret = -EIO;
> +				goto out_unlock;
> +			}
>  			parent = 0;
>  		}
>  
> @@ -9013,12 +9023,18 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
>  		}
>  		ret = btrfs_free_extent(trans, root, bytenr, blocksize, parent,
>  				root->root_key.objectid, level - 1, 0);
> -		BUG_ON(ret); /* -ENOMEM */
> +		if (ret)
> +			goto out_unlock;
>  	}
> +
> +	*lookup_info = 1;
> +	ret = 1;
> +
> +out_unlock:
>  	btrfs_tree_unlock(next);
>  	free_extent_buffer(next);
> -	*lookup_info = 1;
> -	return 1;
> +
> +	return ret;
>  }
>  
>  /*

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
