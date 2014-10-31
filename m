Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37907 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759544AbaJaOQG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Oct 2014 10:16:06 -0400
Date: Fri, 31 Oct 2014 22:15:57 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: move read only block groups onto their own list V2
Message-ID: <20141031141556.GB7522@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1414763374-1744-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1414763374-1744-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 31, 2014 at 09:49:34AM -0400, Josef Bacik wrote:
> Our gluster boxes were spending lots of time in statfs because our fs'es are
> huge.  The problem is statfs loops through all of the block groups looking for
> read only block groups, and when you have several terabytes worth of data that
> ends up being a lot of block groups.  Move the read only block groups onto a
> read only list and only proces that list in
> btrfs_account_ro_block_groups_free_space to reduce the amount of churn.  Thanks,

Looks good.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

-liubo
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
> V1->V2:
> -list_for_each_entry was using the wrong ->member name.
> 
>  fs/btrfs/ctree.h       |  4 ++++
>  fs/btrfs/extent-tree.c | 36 +++++++++++++-----------------------
>  2 files changed, 17 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index d557264e..438f087 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1170,6 +1170,7 @@ struct btrfs_space_info {
>  	struct percpu_counter total_bytes_pinned;
>  
>  	struct list_head list;
> +	struct list_head ro_bgs;
>  
>  	struct rw_semaphore groups_sem;
>  	/* for block groups in our same type */
> @@ -1305,6 +1306,9 @@ struct btrfs_block_group_cache {
>  
>  	/* For delayed block group creation or deletion of empty block groups */
>  	struct list_head bg_list;
> +
> +	/* For read-only block groups */
> +	struct list_head ro_list;
>  };
>  
>  /* delayed seq elem */
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 0d599ba..f51004f 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3518,6 +3518,7 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
>  	found->chunk_alloc = 0;
>  	found->flush = 0;
>  	init_waitqueue_head(&found->wait);
> +	INIT_LIST_HEAD(&found->ro_bgs);
>  
>  	ret = kobject_init_and_add(&found->kobj, &space_info_ktype,
>  				    info->space_info_kobj, "%s",
> @@ -8525,6 +8526,7 @@ static int set_block_group_ro(struct btrfs_block_group_cache *cache, int force)
>  	    min_allocable_bytes <= sinfo->total_bytes) {
>  		sinfo->bytes_readonly += num_bytes;
>  		cache->ro = 1;
> +		list_add_tail(&cache->ro_list, &sinfo->ro_bgs);
>  		ret = 0;
>  	}
>  out:
> @@ -8579,15 +8581,20 @@ int btrfs_force_chunk_alloc(struct btrfs_trans_handle *trans,
>  
>  /*
>   * helper to account the unused space of all the readonly block group in the
> - * list. takes mirrors into account.
> + * space_info. takes mirrors into account.
>   */
> -static u64 __btrfs_get_ro_block_group_free_space(struct list_head *groups_list)
> +u64 btrfs_account_ro_block_groups_free_space(struct btrfs_space_info *sinfo)
>  {
>  	struct btrfs_block_group_cache *block_group;
>  	u64 free_bytes = 0;
>  	int factor;
>  
> -	list_for_each_entry(block_group, groups_list, list) {
> +	/* It's df, we don't care if it's racey */
> +	if (list_empty(&sinfo->ro_bgs))
> +		return 0;
> +
> +	spin_lock(&sinfo->lock);
> +	list_for_each_entry(block_group, &sinfo->ro_bgs, ro_list) {
>  		spin_lock(&block_group->lock);
>  
>  		if (!block_group->ro) {
> @@ -8608,26 +8615,6 @@ static u64 __btrfs_get_ro_block_group_free_space(struct list_head *groups_list)
>  
>  		spin_unlock(&block_group->lock);
>  	}
> -
> -	return free_bytes;
> -}
> -
> -/*
> - * helper to account the unused space of all the readonly block group in the
> - * space_info. takes mirrors into account.
> - */
> -u64 btrfs_account_ro_block_groups_free_space(struct btrfs_space_info *sinfo)
> -{
> -	int i;
> -	u64 free_bytes = 0;
> -
> -	spin_lock(&sinfo->lock);
> -
> -	for (i = 0; i < BTRFS_NR_RAID_TYPES; i++)
> -		if (!list_empty(&sinfo->block_groups[i]))
> -			free_bytes += __btrfs_get_ro_block_group_free_space(
> -						&sinfo->block_groups[i]);
> -
>  	spin_unlock(&sinfo->lock);
>  
>  	return free_bytes;
> @@ -8647,6 +8634,7 @@ void btrfs_set_block_group_rw(struct btrfs_root *root,
>  		    cache->bytes_super - btrfs_block_group_used(&cache->item);
>  	sinfo->bytes_readonly -= num_bytes;
>  	cache->ro = 0;
> +	list_del_init(&cache->ro_list);
>  	spin_unlock(&cache->lock);
>  	spin_unlock(&sinfo->lock);
>  }
> @@ -9016,6 +9004,7 @@ btrfs_create_block_group_cache(struct btrfs_root *root, u64 start, u64 size)
>  	INIT_LIST_HEAD(&cache->list);
>  	INIT_LIST_HEAD(&cache->cluster_list);
>  	INIT_LIST_HEAD(&cache->bg_list);
> +	INIT_LIST_HEAD(&cache->ro_list);
>  	btrfs_init_free_space_ctl(cache);
>  
>  	return cache;
> @@ -9425,6 +9414,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
>  	 * are still on the list after taking the semaphore
>  	 */
>  	list_del_init(&block_group->list);
> +	list_del_init(&block_group->ro_list);
>  	if (list_empty(&block_group->space_info->block_groups[index])) {
>  		kobj = block_group->space_info->block_group_kobjs[index];
>  		block_group->space_info->block_group_kobjs[index] = NULL;
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
