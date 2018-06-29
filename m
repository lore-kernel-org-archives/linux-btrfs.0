Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:49263 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751750AbeF2KFM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 06:05:12 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Fri, 29 Jun 2018 18:05:10 +0800
From: ethanlien <ethanlien@synology.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-btrfs-owner@vger.kernel.org
Subject: Re: [PATCH] btrfs: use customized batch size for total_bytes_pinned
In-Reply-To: <82b1e745-864a-1d0a-aa3a-bfae7308495f@suse.com>
References: <20180629082725.12934-1-ethanlien@synology.com>
 <82b1e745-864a-1d0a-aa3a-bfae7308495f@suse.com>
Message-ID: <04ac53bd7d274e17104d3058343d8f81@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Nikolay Borisov 於 2018-06-29 16:43 寫到:
> On 29.06.2018 11:27, Ethan Lien wrote:
>> We use percpu_counter to reduce lock contention of frequently updated
>> counter. But the default 32 batch size is suitable only for inc/dec
>> update, not for sector size update. The end result is we still acquire
>> spin lock for every percpu_counter_add(). So use customized batch size
>> for total_bytes_pinned as we already done for dirty_metadata_bytes
>> and delalloc_bytes. Also we fix dirty_metadata_bytes to use
>> __percpu_counter_compare of customized batch so we get precise value 
>> of
>> dirty_metadata_bytes.
> 
> Do you have any numbers to prove this is problematic? Perhaps a fio
> workload + lockdep contention numbers before/after the patch ?
> 

I think a contented path may come from heavily cow metadata and short 
data
extents, where we call add_pinned_bytes() frequently in releasing old 
blocks.
I'll try if I can find out a test to show the difference.

>> 
>> Signed-off-by: Ethan Lien <ethanlien@synology.com>
>> ---
>>  fs/btrfs/ctree.h       |  1 +
>>  fs/btrfs/disk-io.c     | 10 ++++++----
>>  fs/btrfs/extent-tree.c | 43 
>> +++++++++++++++++++++++++++---------------
>>  3 files changed, 35 insertions(+), 19 deletions(-)
>> 
>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>> index 118346aceea9..df682a521635 100644
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -422,6 +422,7 @@ struct btrfs_space_info {
>>  	 * time the transaction commits.
>>  	 */
>>  	struct percpu_counter total_bytes_pinned;
>> +	s32 total_bytes_pinned_batch;
>> 
>>  	struct list_head list;
>>  	/* Protected by the spinlock 'lock'. */
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 205092dc9390..dfed08e70ec1 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -961,8 +961,9 @@ static int btree_writepages(struct address_space 
>> *mapping,
>> 
>>  		fs_info = BTRFS_I(mapping->host)->root->fs_info;
>>  		/* this is a bit racy, but that's ok */
>> -		ret = percpu_counter_compare(&fs_info->dirty_metadata_bytes,
>> -					     BTRFS_DIRTY_METADATA_THRESH);
>> +		ret = __percpu_counter_compare(&fs_info->dirty_metadata_bytes,
>> +					     BTRFS_DIRTY_METADATA_THRESH,
>> +					     fs_info->dirty_metadata_batch);
>>  		if (ret < 0)
>>  			return 0;
>>  	}
>> @@ -4150,8 +4151,9 @@ static void __btrfs_btree_balance_dirty(struct 
>> btrfs_fs_info *fs_info,
>>  	if (flush_delayed)
>>  		btrfs_balance_delayed_items(fs_info);
>> 
>> -	ret = percpu_counter_compare(&fs_info->dirty_metadata_bytes,
>> -				     BTRFS_DIRTY_METADATA_THRESH);
>> +	ret = __percpu_counter_compare(&fs_info->dirty_metadata_bytes,
>> +				     BTRFS_DIRTY_METADATA_THRESH,
>> +				     fs_info->dirty_metadata_batch);
>>  	if (ret > 0) {
>>  		balance_dirty_pages_ratelimited(fs_info->btree_inode->i_mapping);
>>  	}
> 
> This hunk needs to be in a separate patch. And the last sentence which
> relates to it needs to be expanded further to explain the problem.
> 

OK I'll prepare a separate patch.

>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 3d9fe58c0080..a067c047904c 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -758,7 +758,8 @@ static void add_pinned_bytes(struct btrfs_fs_info 
>> *fs_info, s64 num_bytes,
>> 
>>  	space_info = __find_space_info(fs_info, flags);
>>  	ASSERT(space_info);
>> -	percpu_counter_add(&space_info->total_bytes_pinned, num_bytes);
>> +	percpu_counter_add_batch(&space_info->total_bytes_pinned, num_bytes,
>> +		    space_info->total_bytes_pinned_batch);
>>  }
>> 
>>  /*
>> @@ -2598,8 +2599,9 @@ static int cleanup_ref_head(struct 
>> btrfs_trans_handle *trans,
>>  			flags = BTRFS_BLOCK_GROUP_METADATA;
>>  		space_info = __find_space_info(fs_info, flags);
>>  		ASSERT(space_info);
>> -		percpu_counter_add(&space_info->total_bytes_pinned,
>> -				   -head->num_bytes);
>> +		percpu_counter_add_batch(&space_info->total_bytes_pinned,
>> +				   -head->num_bytes,
>> +				   space_info->total_bytes_pinned_batch);
>> 
>>  		if (head->is_data) {
>>  			spin_lock(&delayed_refs->lock);
>> @@ -4035,6 +4037,10 @@ static int create_space_info(struct 
>> btrfs_fs_info *info, u64 flags)
>>  	INIT_LIST_HEAD(&space_info->ro_bgs);
>>  	INIT_LIST_HEAD(&space_info->tickets);
>>  	INIT_LIST_HEAD(&space_info->priority_tickets);
>> +	if (flags & BTRFS_BLOCK_GROUP_DATA)
>> +		space_info->total_bytes_pinned_batch = info->delalloc_batch;
>> +	else
>> +		space_info->total_bytes_pinned_batch = info->dirty_metadata_batch;
>> 
>>  	ret = kobject_init_and_add(&space_info->kobj, &space_info_ktype,
>>  				    info->space_info_kobj, "%s",
>> @@ -4309,9 +4315,10 @@ int btrfs_alloc_data_chunk_ondemand(struct 
>> btrfs_inode *inode, u64 bytes)
>>  		 * allocation, and no removed chunk in current transaction,
>>  		 * don't bother committing the transaction.
>>  		 */
>> -		have_pinned_space = percpu_counter_compare(
>> +		have_pinned_space = __percpu_counter_compare(
>>  			&data_sinfo->total_bytes_pinned,
>> -			used + bytes - data_sinfo->total_bytes);
>> +			used + bytes - data_sinfo->total_bytes,
>> +			data_sinfo->total_bytes_pinned_batch);
>>  		spin_unlock(&data_sinfo->lock);
>> 
>>  		/* commit the current transaction and try again */
>> @@ -4912,8 +4919,9 @@ static int may_commit_transaction(struct 
>> btrfs_fs_info *fs_info,
>>  		return 0;
>> 
>>  	/* See if there is enough pinned space to make this reservation */
>> -	if (percpu_counter_compare(&space_info->total_bytes_pinned,
>> -				   bytes) >= 0)
>> +	if (__percpu_counter_compare(&space_info->total_bytes_pinned,
>> +				   bytes,
>> +				   space_info->total_bytes_pinned_batch) >= 0)
>>  		goto commit;
>> 
>>  	/*
>> @@ -4930,8 +4938,9 @@ static int may_commit_transaction(struct 
>> btrfs_fs_info *fs_info,
>>  		bytes -= delayed_rsv->size;
>>  	spin_unlock(&delayed_rsv->lock);
>> 
>> -	if (percpu_counter_compare(&space_info->total_bytes_pinned,
>> -				   bytes) < 0) {
>> +	if (__percpu_counter_compare(&space_info->total_bytes_pinned,
>> +				   bytes,
>> +				   space_info->total_bytes_pinned_batch) < 0) {
>>  		return -ENOSPC;
>>  	}
>> 
>> @@ -6268,8 +6277,9 @@ static int update_block_group(struct 
>> btrfs_trans_handle *trans,
>>  			trace_btrfs_space_reservation(info, "pinned",
>>  						      cache->space_info->flags,
>>  						      num_bytes, 1);
>> -			percpu_counter_add(&cache->space_info->total_bytes_pinned,
>> -					   num_bytes);
>> +			percpu_counter_add_batch(&cache->space_info->total_bytes_pinned,
>> +					   num_bytes,
>> +					   cache->space_info->total_bytes_pinned_batch);
>>  			set_extent_dirty(info->pinned_extents,
>>  					 bytenr, bytenr + num_bytes - 1,
>>  					 GFP_NOFS | __GFP_NOFAIL);
>> @@ -6347,7 +6357,8 @@ static int pin_down_extent(struct btrfs_fs_info 
>> *fs_info,
>> 
>>  	trace_btrfs_space_reservation(fs_info, "pinned",
>>  				      cache->space_info->flags, num_bytes, 1);
>> -	percpu_counter_add(&cache->space_info->total_bytes_pinned, 
>> num_bytes);
>> +	percpu_counter_add_batch(&cache->space_info->total_bytes_pinned,
>> +		    num_bytes, cache->space_info->total_bytes_pinned_batch);
>>  	set_extent_dirty(fs_info->pinned_extents, bytenr,
>>  			 bytenr + num_bytes - 1, GFP_NOFS | __GFP_NOFAIL);
>>  	return 0;
>> @@ -6711,7 +6722,8 @@ static int unpin_extent_range(struct 
>> btrfs_fs_info *fs_info,
>>  		trace_btrfs_space_reservation(fs_info, "pinned",
>>  					      space_info->flags, len, 0);
>>  		space_info->max_extent_size = 0;
>> -		percpu_counter_add(&space_info->total_bytes_pinned, -len);
>> +		percpu_counter_add_batch(&space_info->total_bytes_pinned,
>> +			    -len, space_info->total_bytes_pinned_batch);
>>  		if (cache->ro) {
>>  			space_info->bytes_readonly += len;
>>  			readonly = true;
>> @@ -10764,8 +10776,9 @@ void btrfs_delete_unused_bgs(struct 
>> btrfs_fs_info *fs_info)
>> 
>>  		space_info->bytes_pinned -= block_group->pinned;
>>  		space_info->bytes_readonly += block_group->pinned;
>> -		percpu_counter_add(&space_info->total_bytes_pinned,
>> -				   -block_group->pinned);
>> +		percpu_counter_add_batch(&space_info->total_bytes_pinned,
>> +				   -block_group->pinned,
>> +				   space_info->total_bytes_pinned_batch);
>>  		block_group->pinned = 0;
>> 
>>  		spin_unlock(&block_group->lock);
>> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" 
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

