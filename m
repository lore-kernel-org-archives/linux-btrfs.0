Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:64879 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752749Ab2IMC5O (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Sep 2012 22:57:14 -0400
Message-ID: <50514B7E.6030503@cn.fujitsu.com>
Date: Thu, 13 Sep 2012 10:57:02 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: delay block group item insertion
References: <1347473053-3158-1-git-send-email-jbacik@fusionio.com> <20120913013205.GA12929@liubo>
In-Reply-To: <20120913013205.GA12929@liubo>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On thu, 13 Sep 2012 09:32:05 +0800, Liu Bo wrote:
> On Wed, Sep 12, 2012 at 02:04:13PM -0400, Josef Bacik wrote:
>> So we have lots of places where we try to preallocate chunks in order to
>> make sure we have enough space as we make our allocations.  This has
>> historically meant that we're constantly tweaking when we should allocate a
>> new chunk, and historically we have gotten this horribly wrong so we way
>> over allocate either metadata or data.  To try and keep this from happening
>> we are going to make it so that the block group item insertion is done out
>> of band at the end of a transaction.  This will allow us to create chunks
>> even if we are trying to make an allocation for the extent tree.  With this
>> patch my enospc tests run faster (didn't expect this) and more efficiently
>> use the disk space (this is what I wanted).  Thanks,
>>
> 
> I'm afraid this does not perform good enough in normal case, here is the
> compilebench test:
> 
> # cat btrfs-makej/result-4k 
> intial create total runs 30 avg 51.99 MB/s (user 0.50s sys 0.85s)
> compile total runs 30 avg 98.45 MB/s (user 0.12s sys 0.38s)
> read compiled tree total runs 3 avg 19.89 MB/s (user 1.55s sys 3.07s)
> delete compiled tree total runs 30 avg 12.15 seconds (user 0.66s sys 2.15s)
> 
> # cat btrfs-josef-makej/result 
> intial create total runs 30 avg 49.79 MB/s (user 0.52s sys 0.87s)
> compile total runs 30 avg 70.01 MB/s (user 0.14s sys 0.44s)
> read compiled tree total runs 3 avg 18.46 MB/s (user 1.57s sys 3.16s)
> delete compiled tree total runs 30 avg 13.88 seconds (user 0.67s sys 2.18s)
> 
> And the blktrace shows that it makes us do more seeks in create and
> compile section.

I think it is because the metadata free space become smaller. Without this patch,
we may allocate metadata chunks as many as possible until the size of the metadata
chunks touches the threshold of the chunk allocation. And then we can allocate
the free space linearly, so the seeks are less than the result after we apply
this patch.

>> @@ -5962,20 +5950,6 @@ int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
>>  
>>  	data = btrfs_get_alloc_profile(root, data);
>>  again:
>> -	/*
>> -	 * the only place that sets empty_size is btrfs_realloc_node, which
>> -	 * is not called recursively on allocations
>> -	 */
>> -	if (empty_size || root->ref_cows) {
>> -		ret = do_chunk_alloc(trans, root->fs_info->extent_root,
>> -				     num_bytes + 2 * 1024 * 1024, data,
>> -				     CHUNK_ALLOC_NO_FORCE);
>> -		if (ret < 0 && ret != -ENOSPC) {
>> -			btrfs_abort_transaction(trans, root, ret);
>> -			return ret;
>> -		}
>> -	}
>> -
>>  	WARN_ON(num_bytes < root->sectorsize);
>>  	ret = find_free_extent(trans, root, num_bytes, empty_size,
>>  			       hint_byte, ins, data);

I think retaining this chunk allocation may help you.

Thanks
Miao

>> @@ -7828,6 +7796,31 @@ error:
>>  	return ret;
>>  }
>>  
>> +void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans,
>> +				       struct btrfs_root *root)
>> +{
>> +	struct btrfs_block_group_cache *block_group, *tmp;
>> +	struct btrfs_root *extent_root = root->fs_info->extent_root;
>> +	struct btrfs_block_group_item item;
>> +	struct btrfs_key key;
>> +	int ret;
>> +
>> +	list_for_each_entry_safe(block_group, tmp, &trans->new_bgs,
>> +				 new_bg_list) {
>> +		list_del_init(&block_group->new_bg_list);
>> +
>> +		spin_lock(&block_group->lock);
>> +		memcpy(&item, &block_group->item, sizeof(item));
>> +		memcpy(&key, &block_group->key, sizeof(key));
>> +		spin_unlock(&block_group->lock);
>> +
>> +		ret = btrfs_insert_item(trans, extent_root, &key, &item,
>> +					sizeof(item));
>> +		if (ret)
>> +			btrfs_abort_transaction(trans, extent_root, ret);
>> +	}
>> +}
>> +
>>  int btrfs_make_block_group(struct btrfs_trans_handle *trans,
>>  			   struct btrfs_root *root, u64 bytes_used,
>>  			   u64 type, u64 chunk_objectid, u64 chunk_offset,
>> @@ -7861,6 +7854,7 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
>>  	spin_lock_init(&cache->lock);
>>  	INIT_LIST_HEAD(&cache->list);
>>  	INIT_LIST_HEAD(&cache->cluster_list);
>> +	INIT_LIST_HEAD(&cache->new_bg_list);
>>  
>>  	btrfs_init_free_space_ctl(cache);
>>  
>> @@ -7892,12 +7886,7 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
>>  	ret = btrfs_add_block_group_cache(root->fs_info, cache);
>>  	BUG_ON(ret); /* Logic error */
>>  
>> -	ret = btrfs_insert_item(trans, extent_root, &cache->key, &cache->item,
>> -				sizeof(cache->item));
>> -	if (ret) {
>> -		btrfs_abort_transaction(trans, extent_root, ret);
>> -		return ret;
>> -	}
>> +	list_add_tail(&cache->new_bg_list, &trans->new_bgs);
>>  
>>  	set_avail_alloc_bits(extent_root->fs_info, type);
>>  
>> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
>> index 0629edf..c01dec7 100644
>> --- a/fs/btrfs/transaction.c
>> +++ b/fs/btrfs/transaction.c
>> @@ -374,6 +374,7 @@ again:
>>  	h->qgroup_reserved = qgroup_reserved;
>>  	h->delayed_ref_elem.seq = 0;
>>  	INIT_LIST_HEAD(&h->qgroup_ref_list);
>> +	INIT_LIST_HEAD(&h->new_bgs);
>>  
>>  	smp_mb();
>>  	if (cur_trans->blocked && may_wait_transaction(root, type)) {
>> @@ -549,6 +550,9 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
>>  		trans->qgroup_reserved = 0;
>>  	}
>>  
>> +	if (!list_empty(&trans->new_bgs))
>> +		btrfs_create_pending_block_groups(trans, root);
>> +
>>  	while (count < 2) {
>>  		unsigned long cur = trans->delayed_ref_updates;
>>  		trans->delayed_ref_updates = 0;
>> @@ -564,6 +568,9 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
>>  	btrfs_trans_release_metadata(trans, root);
>>  	trans->block_rsv = NULL;
>>  
>> +	if (!list_empty(&trans->new_bgs))
>> +		btrfs_create_pending_block_groups(trans, root);
>> +
>>  	if (lock && !atomic_read(&root->fs_info->open_ioctl_trans) &&
>>  	    should_end_transaction(trans, root)) {
>>  		trans->transaction->blocked = 1;
>> @@ -1400,6 +1407,9 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
>>  	 */
>>  	cur_trans->delayed_refs.flushing = 1;
>>  
>> +	if (!list_empty(&trans->new_bgs))
>> +		btrfs_create_pending_block_groups(trans, root);
>> +
>>  	ret = btrfs_run_delayed_refs(trans, root, 0);
>>  	if (ret)
>>  		goto cleanup_transaction;
>> diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
>> index 1b05480..b6463e1 100644
>> --- a/fs/btrfs/transaction.h
>> +++ b/fs/btrfs/transaction.h
>> @@ -68,6 +68,7 @@ struct btrfs_trans_handle {
>>  	struct btrfs_root *root;
>>  	struct seq_list delayed_ref_elem;
>>  	struct list_head qgroup_ref_list;
>> +	struct list_head new_bgs;
>>  };
>>  
>>  struct btrfs_pending_snapshot {
>> -- 
>> 1.7.7.6
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


