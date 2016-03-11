Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36793 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932544AbcCKPoT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Mar 2016 10:44:19 -0500
Date: Fri, 11 Mar 2016 16:43:55 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Output more info for enospc_debug mount option
Message-ID: <20160311154355.GR18908@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1456819701-21067-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1456819701-21067-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 01, 2016 at 04:08:21PM +0800, Qu Wenruo wrote:
> As one user in mail list report reproducible balance ENOSPC error, it's
> better to add more debug info for enospc_debug mount option.
> 
> Reported-by: Marc Haber <mh+linux-btrfs@zugschlus.de>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  fs/btrfs/extent-tree.c | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 083783b..a95d247 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -9386,15 +9386,23 @@ int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr)
>  	u64 dev_min = 1;
>  	u64 dev_nr = 0;
>  	u64 target;
> +	int debug;
>  	int index;
>  	int full = 0;
>  	int ret = 0;
>  
> +	debug = btrfs_test_opt(root, ENOSPC_DEBUG);
> +
>  	block_group = btrfs_lookup_block_group(root->fs_info, bytenr);
>  
>  	/* odd, couldn't find the block group, leave it alone */
> -	if (!block_group)
> +	if (!block_group) {
> +		if (debug)
> +			btrfs_warn(root->fs_info,
> +				   "Can't find block group %llu\n",

no newline, no capital 'C'

> +				   bytenr);
>  		return -1;
> +	}
>  
>  	min_free = btrfs_block_group_used(&block_group->item);
>  
> @@ -9448,8 +9456,11 @@ int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr)
>  		 * this is just a balance, so if we were marked as full
>  		 * we know there is no space for a new chunk
>  		 */
> -		if (full)
> +		if (full) {
> +			if (debug)
> +				btrfs_warn(root->fs_info, "space info full");

the block group bytenr should be printed as well

>  			goto out;
> +		}
>  
>  		index = get_block_group_index(block_group);
>  	}
> @@ -9496,6 +9507,8 @@ int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr)
>  			ret = -1;
>  		}
>  	}
> +	if (debug && ret == -1)
> +		btrfs_warn(root->fs_info, "no space to allocate a new chunk");

same here, add bytenr

>  	mutex_unlock(&root->fs_info->chunk_mutex);
>  	btrfs_end_transaction(trans, root);
>  out:
> -- 
> 2.7.2
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
