Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43293 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755588AbdESRpZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 May 2017 13:45:25 -0400
Date: Fri, 19 May 2017 19:44:26 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org, bo.li.liu@oracle.com, jeffm@suse.com
Subject: Re: [PATCH v3 1/2] btrfs: Separate space_info create/update
Message-ID: <20170519174426.GX4065@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1495178467-26746-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1495178467-26746-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Only minor nits

On Fri, May 19, 2017 at 10:21:06AM +0300, Nikolay Borisov wrote:
> Currently the struct space_info creation code is intermixed in the
> udpate_space_info function. There are well-defined points at which the we
  ^^^^^^^^^^^^^^^^^

> actually want to create brand-new space_info structs (e.g. during mount of
> the filesystem as well as sometimes when adding/initialising new chunks). In
> such cases udpate_space_info is called with 0 as the bytes parameter. All of
             ^^^^^^^^^^^^^^^^^

> this makes for spaghetti code.
> 
> Fix it by factoring out the creation code in a separate create_space_info
> structure. This also allows to simplify the internals. Also remove BUG_ON from
> do_alloc_chunk since the callers handle errors. Furthermore it will
> make the update_space_info function not fail, allowing us to remove error
> handling in callers. This will come in a follow up patch.
> 
> Reviewed-by: Jeff Mahoney <jeffm@suse.com>
> Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Missing signed-off-by

> ---
>  fs/btrfs/extent-tree.c | 129 ++++++++++++++++++++++++-------------------------
>  1 file changed, 64 insertions(+), 65 deletions(-)
> 
> 
>  Worked on feedback from Liu Bo and discovered I didn't have vim's linuxtsy 
>  plugin installed, hence the b0rked formatting in some of my patches. 
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index be5477676cc8..55b6836f5a20 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3914,15 +3914,58 @@ static const char *alloc_name(u64 flags)
>  	};
>  }
>  
> +static int create_space_info(struct btrfs_fs_info *info, u64 flags,
> +			     struct btrfs_space_info **new) {

function openning { on a new line

> +
> +	struct btrfs_space_info *space_info;
> +	int i;
> +	int ret;
> +
> +	space_info = kzalloc(sizeof(*space_info), GFP_NOFS);
> +	if (!space_info)
> +		return -ENOMEM;
> +
> +	ret = percpu_counter_init(&space_info->total_bytes_pinned, 0,
> +				 GFP_KERNEL);
> +	if (ret) {
> +		kfree(space_info);
> +		return ret;
> +	}
> +
> +	for (i = 0; i < BTRFS_NR_RAID_TYPES; i++)
> +		INIT_LIST_HEAD(&space_info->block_groups[i]);
> +	init_rwsem(&space_info->groups_sem);
> +	spin_lock_init(&space_info->lock);
> +	space_info->flags = flags & BTRFS_BLOCK_GROUP_TYPE_MASK;
> +	space_info->force_alloc = CHUNK_ALLOC_NO_FORCE;
> +	init_waitqueue_head(&space_info->wait);
> +	INIT_LIST_HEAD(&space_info->ro_bgs);
> +	INIT_LIST_HEAD(&space_info->tickets);
> +	INIT_LIST_HEAD(&space_info->priority_tickets);
> +
> +	ret = kobject_init_and_add(&space_info->kobj, &space_info_ktype,
> +				    info->space_info_kobj, "%s",
> +				    alloc_name(space_info->flags));
> +	if (ret) {
> +		kfree(space_info);
> +		return ret;
> +	}
> +
> +	*new = space_info;
> +	list_add_rcu(&space_info->list, &info->space_info);
> +	if (flags & BTRFS_BLOCK_GROUP_DATA)
> +		info->data_sinfo = space_info;
> +
> +	return ret;
> +}
> +
>  static int update_space_info(struct btrfs_fs_info *info, u64 flags,
>  			     u64 total_bytes, u64 bytes_used,
>  			     u64 bytes_readonly,
>  			     struct btrfs_space_info **space_info)
>  {
>  	struct btrfs_space_info *found;
> -	int i;
>  	int factor;
> -	int ret;
>  
>  	if (flags & (BTRFS_BLOCK_GROUP_DUP | BTRFS_BLOCK_GROUP_RAID1 |
>  		     BTRFS_BLOCK_GROUP_RAID10))
> @@ -3946,53 +3989,6 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
>  		*space_info = found;
>  		return 0;
>  	}
> -	found = kzalloc(sizeof(*found), GFP_NOFS);
> -	if (!found)
> -		return -ENOMEM;
> -
> -	ret = percpu_counter_init(&found->total_bytes_pinned, 0, GFP_KERNEL);
> -	if (ret) {
> -		kfree(found);
> -		return ret;
> -	}
> -
> -	for (i = 0; i < BTRFS_NR_RAID_TYPES; i++)
> -		INIT_LIST_HEAD(&found->block_groups[i]);
> -	init_rwsem(&found->groups_sem);
> -	spin_lock_init(&found->lock);
> -	found->flags = flags & BTRFS_BLOCK_GROUP_TYPE_MASK;
> -	found->total_bytes = total_bytes;
> -	found->disk_total = total_bytes * factor;
> -	found->bytes_used = bytes_used;
> -	found->disk_used = bytes_used * factor;
> -	found->bytes_pinned = 0;
> -	found->bytes_reserved = 0;
> -	found->bytes_readonly = bytes_readonly;
> -	found->bytes_may_use = 0;
> -	found->full = 0;
> -	found->max_extent_size = 0;
> -	found->force_alloc = CHUNK_ALLOC_NO_FORCE;
> -	found->chunk_alloc = 0;
> -	found->flush = 0;
> -	init_waitqueue_head(&found->wait);
> -	INIT_LIST_HEAD(&found->ro_bgs);
> -	INIT_LIST_HEAD(&found->tickets);
> -	INIT_LIST_HEAD(&found->priority_tickets);
> -
> -	ret = kobject_init_and_add(&found->kobj, &space_info_ktype,
> -				    info->space_info_kobj, "%s",
> -				    alloc_name(found->flags));
> -	if (ret) {
> -		kfree(found);
> -		return ret;
> -	}
> -
> -	*space_info = found;
> -	list_add_rcu(&found->list, &info->space_info);
> -	if (flags & BTRFS_BLOCK_GROUP_DATA)
> -		info->data_sinfo = found;
> -
> -	return ret;
>  }
>  
>  static void set_avail_alloc_bits(struct btrfs_fs_info *fs_info, u64 flags)
> @@ -4495,10 +4491,10 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
>  
>  	space_info = __find_space_info(fs_info, flags);
>  	if (!space_info) {
> -		ret = update_space_info(fs_info, flags, 0, 0, 0, &space_info);
> -		BUG_ON(ret); /* -ENOMEM */
> +		ret = create_space_info(fs_info, flags, &space_info);
> +		if (ret)
> +			return -ENOMEM;

create_space_info can possibly return other codes than just ENOMEM,
'return ret' is fine here.

Otherwise looks good.
