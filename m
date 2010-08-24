From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 6/6] btrfs: check mergeable free space when removing a
 cluster
Date: Tue, 24 Aug 2010 09:04:13 +0800
Message-ID: <4C731A8D.2010402@cn.fujitsu.com>
References: <4C71CD4B.10606@cn.fujitsu.com> <4C71CDB7.6000602@cn.fujitsu.com> <20100823131504.GE2404@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100823131504.GE2404@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik wrote:
> On Mon, Aug 23, 2010 at 09:24:07AM +0800, Li Zefan wrote:
>> After returing extents from a cluster to the block group, some
>> extents in the block group may be mergeable.
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>> ---
>>  fs/btrfs/free-space-cache.c |   26 ++++++++++++++++++++------
>>  1 files changed, 20 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
>> index faeec8f..c11f4f7 100644
>> --- a/fs/btrfs/free-space-cache.c
>> +++ b/fs/btrfs/free-space-cache.c
>> @@ -234,11 +234,18 @@ tree_search_offset(struct btrfs_block_group_cache *block_group,
>>  	return entry;
>>  }
>>  
>> -static void unlink_free_space(struct btrfs_block_group_cache *block_group,
>> -			      struct btrfs_free_space *info)
>> +static inline void
>> +__unlink_free_space(struct btrfs_block_group_cache *block_group,
>> +		    struct btrfs_free_space *info)
>>  {
>>  	rb_erase(&info->offset_index, &block_group->free_space_offset);
>>  	block_group->free_extents--;
>> +}
>> +
>> +static void unlink_free_space(struct btrfs_block_group_cache *block_group,
>> +			      struct btrfs_free_space *info)
>> +{
>> +	__unlink_free_space(block_group, info);
>>  	block_group->free_space -= info->bytes;
>>  }
>>  
>> @@ -611,7 +618,7 @@ out:
>>  }
>>  
>>  bool try_merge_free_space(struct btrfs_block_group_cache *block_group,
>> -			  struct btrfs_free_space *info)
>> +			  struct btrfs_free_space *info, bool update_stat)
>>  {
>>  	struct btrfs_free_space *left_info;
>>  	struct btrfs_free_space *right_info;
>> @@ -632,7 +639,10 @@ bool try_merge_free_space(struct btrfs_block_group_cache *block_group,
>>  		left_info = tree_search_offset(block_group, offset - 1, 0, 0);
>>  
>>  	if (right_info && !right_info->bitmap) {
>> -		unlink_free_space(block_group, right_info);
>> +		if (update_stat)
>> +			unlink_free_space(block_group, right_info);
>> +		else
>> +			__unlink_free_space(block_group, right_info);
>>  		info->bytes += right_info->bytes;
>>  		kfree(right_info);
>>  		merged = true;
>> @@ -640,7 +650,10 @@ bool try_merge_free_space(struct btrfs_block_group_cache *block_group,
>>  
>>  	if (left_info && !left_info->bitmap &&
>>  	    left_info->offset + left_info->bytes == offset) {
>> -		unlink_free_space(block_group, left_info);
>> +		if (update_stat)
>> +			unlink_free_space(block_group, left_info);
>> +		else
>> +			__unlink_free_space(block_group, left_info);
>>  		info->offset = left_info->offset;
>>  		info->bytes += left_info->bytes;
>>  		kfree(left_info);
>> @@ -665,7 +678,7 @@ int btrfs_add_free_space(struct btrfs_block_group_cache *block_group,
>>  
>>  	spin_lock(&block_group->tree_lock);
>>  
>> -	if (try_merge_free_space(block_group, info))
>> +	if (try_merge_free_space(block_group, info, true))
>>  		goto link;
>>  
>>  	/*
>> @@ -883,6 +896,7 @@ __btrfs_return_cluster_to_free_space(
>>  		node = rb_next(&entry->offset_index);
>>  		rb_erase(&entry->offset_index, &cluster->root);
>>  		BUG_ON(entry->bitmap);
>> +		try_merge_free_space(block_group, entry, false);
>>  		tree_insert_offset(&block_group->free_space_offset,
>>  				   entry->offset, &entry->offset_index, 0);
> 
> It's early in the morning here, so forgive me if I'm missing something obvious,
> but if try_merge_free_space() succeeds here, then won't tree_insert_offset()
> then add an entry that overlaps the same spot?  Should we do something like
> 
> merged = try_merge_free_space();
> if (!merged)
> 	tree_insert_offset();
> 
> ?  Thanks,
> 

In try_merge_free_space() we try to merge the left and right entry into
@entry, and then the caller has to insert the @entry into the tree by
itself.

Similarly, In btrfs_add_free_space() we call link_free_space() no matter
try_merge_free_space() returns success or not.
