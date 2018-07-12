Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:46123 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727136AbeGLRYI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jul 2018 13:24:08 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Fri, 13 Jul 2018 01:13:39 +0800
From: ethanlien <ethanlien@synology.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-btrfs-owner@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: use customized batch size for
 total_bytes_pinned
In-Reply-To: <96feeac4-78ca-a76b-19cd-be9a4a309da8@suse.com>
References: <20180711155936.11511-1-ethanlien@synology.com>
 <96feeac4-78ca-a76b-19cd-be9a4a309da8@suse.com>
Message-ID: <ebd3a334cb2f809c2e59ca4815416025@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Nikolay Borisov 於 2018-07-12 15:07 寫到:
> On 11.07.2018 18:59, Ethan Lien wrote:
>> In commit b150a4f10d878 ("Btrfs: use a percpu to keep track of 
>> possibly
>> pinned bytes") we use total_bytes_pinned to track how many bytes we 
>> are
>> going to free in this transaction. When we are close to ENOSPC, we 
>> check it
>> and know if we can make the allocation by commit the current 
>> transaction.
>> For every data/metadata extent we are going to free, we add
>> total_bytes_pinned in btrfs_free_extent() and btrfs_free_tree_block(), 
>> and
>> release it in unpin_extent_range() when we finish the transaction. So 
>> this
>> is a variable we frequently update but rarely read - just the suitable
>> use of percpu_counter. But in previous commit we update 
>> total_bytes_pinned
>> by default 32 batch size, making every update essentially a spin lock
>> protected update. Since every spin lock/unlock operation involves 
>> syncing
>> a globally used variable and some kind of barrier in a SMP system, 
>> this is
>> more expensive than using total_bytes_pinned as a simple atomic64_t. 
>> So
>> fix this by using a customized batch size. Since we only read
>> total_bytes_pinned when we are close to ENOSPC and fail to alloc new 
>> chunk,
>> we can use a really large batch size and have nearly no penalty in 
>> most
>> cases.
>> 
>> 
>> [Test]
>> We test the patch on a 4-cores x86 machine:
>> 1. falloate a 16GiB size test file.
>> 2. take snapshot (so all following writes will be cow write).
>> 3. run a 180 sec, 4 jobs, 4K random write fio on test file.
>> 
>> We also add a temporary lockdep class on percpu_counter's spin lock 
>> used
>> by total_bytes_pinned to track lock_stat.
>> 
>> 
>> [Results]
>> unpatched:
>> lock_stat version 0.4
>> -----------------------------------------------------------------------
>>                               class name    con-bounces    contentions
>> waittime-min   waittime-max waittime-total   waittime-avg    
>> acq-bounces
>> acquisitions   holdtime-min   holdtime-max holdtime-total   
>> holdtime-avg
>> 
>>                total_bytes_pinned_percpu:            82             82
>>         0.21           0.61          29.46           0.36         
>> 298340
>>       635973           0.09          11.01      173476.25           
>> 0.27
>> 
>> 
>> patched:
>> lock_stat version 0.4
>> -----------------------------------------------------------------------
>>                               class name    con-bounces    contentions
>> waittime-min   waittime-max waittime-total   waittime-avg    
>> acq-bounces
>> acquisitions   holdtime-min   holdtime-max holdtime-total   
>> holdtime-avg
>> 
>>                total_bytes_pinned_percpu:             1              1
>>         0.62           0.62           0.62           0.62          
>> 13601
>>        31542           0.14           9.61       11016.90           
>> 0.35
>> 
> 
> According to these numbers though, the best-case (waittime-min and the
> average waittime-avg) have actually regressed. So what really saves you

In patched version we only got one contentions count so the min/max/avg
waittime all come from that count. I think the min/max/avg waittime here
are inconclusive since we have only one sample count so it could be 
biased.


> is the fact that the number of time we had to go to the best/average
> case is reduced, due to the larger batch. I guess in that regard you 
> are
> in the clear. Another pertinent question is did you observe any
> significant impact on run times of actual workloads or, say, 
> transaction
> commit times or anything like that? I think this case will only be hit
> when the filesystem is struggling to satisfy a metadata allocation  has
> to cycle through all stages .

The frequently update of total_bytes_pinned can happen in normal cow 
write path.
In our test, any re-write to a existing 4K data block will trigger cow 
and we release
old data block by btrfs_free_extent() and in that time we add 
total_bytes_pinned.
As the test file is written out, eventually almost every 4K write will 
trigger a +4K and a
-4K update to total_bytes_pinned. But so far we haven't seen significant 
performance
improvement from the test.

> 
>> 
>> [Analysis]
>> Since the spin lock only protect a single in-memory variable, the
>> contentions (number of lock acquisitions that had to wait) in both
>> unpatched and patched version are low. But when we see acquisitions 
>> and
>> acq-bounces, we get much lower counts in patched version. Here the 
>> most
>> important metric is acq-bounces. It means how many times the lock get
>> transferred between different cpus, so the patch can really recude
> 
> nit: s/recude/reduce - no need to resend i guess david will fix it on
> the way into the tree
> 
>> cacheline bouncing of spin lock (also the global counter of 
>> percpu_counter)
>> in a SMP system.
>> 
>> Fixes: b150a4f10d878 ("Btrfs: use a percpu to keep track of possibly
>> pinned bytes")
>> 
>> Signed-off-by: Ethan Lien <ethanlien@synology.com>
> 
>  Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> 
>> ---
>> 
>> V2:
>> 	Rewrite commit comments.
>> 	Add lock_stat test.
>> 	Pull dirty_metadata_bytes out to a separate patch.
>> 
>>  fs/btrfs/ctree.h       |  1 +
>>  fs/btrfs/extent-tree.c | 46 
>> ++++++++++++++++++++++++++++--------------
>>  2 files changed, 32 insertions(+), 15 deletions(-)
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
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 3d9fe58c0080..937113534ef4 100644
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
>> @@ -4024,6 +4026,13 @@ static int create_space_info(struct 
>> btrfs_fs_info *info, u64 flags)
>>  		kfree(space_info);
>>  		return ret;
>>  	}
>> +	/*
>> +	 * Use large batch size to reduce update overhead.
>> +	 * For reader side, we only read it when we are close to ENOSPC and
>> +	 * the read overhead is mostly related to # of cpus, so it is OK to
>> +	 * use arbitrary large value here.
>> +	 */
>> +	space_info->total_bytes_pinned_batch = SZ_128M;
>> 
>>  	for (i = 0; i < BTRFS_NR_RAID_TYPES; i++)
>>  		INIT_LIST_HEAD(&space_info->block_groups[i]);
>> @@ -4309,9 +4318,10 @@ int btrfs_alloc_data_chunk_ondemand(struct 
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
>> @@ -4912,8 +4922,9 @@ static int may_commit_transaction(struct 
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
>> @@ -4930,8 +4941,9 @@ static int may_commit_transaction(struct 
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
>> @@ -6268,8 +6280,9 @@ static int update_block_group(struct 
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
>> @@ -6347,7 +6360,8 @@ static int pin_down_extent(struct btrfs_fs_info 
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
>> @@ -6711,7 +6725,8 @@ static int unpin_extent_range(struct 
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
>> @@ -10764,8 +10779,9 @@ void btrfs_delete_unused_bgs(struct 
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

