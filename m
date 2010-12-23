From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH 4/6] btrfs: restructure find_free_dev_extent()
Date: Thu, 23 Dec 2010 10:14:07 +0800
Message-ID: <4D12B06F.30104@cn.fujitsu.com>
References: <4D11D742.9090504@cn.fujitsu.com> <4D11E9F6.1040207@gmx.net>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D11E9F6.1040207@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On wed, 22 Dec 2010 13:07:18 +0100, Arne Jansen wrote:
> this patch seems to have the same intention as the patch I sent to the
> list on Dec 11 "Fixing the chunk allocator to allow it to better
> utilize the devices". The result is quite similar, except that you
> left the line

Ahhh, partial code is similar indeed. But I think this patch is different with
yours. this function can return the offset of the max free space when it can not
find a suitable free space now, it is the main purpose of this patch.
I think this is also the biggest difference between this patch and yours.

The original function is what I need, so I retain it, and this is why the result
is similar.

> search_start = max(root->fs_info->alloc_start, search_start);
> 
> in place, which could lead to disregarding the configured alloc_start.

According to the original code, I think alloc_start just is a suggested
parameter, if there is no enough space on the device, we just ignore it.

Sometimes, we must retain the original semantic.

Thanks
Miao

> As both patches address the same problem, it might be good to compare
> them in more detail.
> 
> --
> Arne
> 
> On 22.12.2010 11:47, Miao Xie wrote:
>> - make it return the start position and length of the max free space when it can
>>     not find a suitable free space.
>> - make it more readability
>>
>> Signed-off-by: Miao Xie<miaox@cn.fujitsu.com>
>> ---
>>    fs/btrfs/extent-tree.c |    4 +-
>>    fs/btrfs/volumes.c     |  155 +++++++++++++++++++++++++++--------------------
>>    2 files changed, 91 insertions(+), 68 deletions(-)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 4bcd875..7c1a053 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -8098,7 +8098,7 @@ int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr)
>>    	mutex_lock(&root->fs_info->chunk_mutex);
>>    	list_for_each_entry(device,&fs_devices->alloc_list, dev_alloc_list) {
>>    		u64 min_free = btrfs_block_group_used(&block_group->item);
>> -		u64 dev_offset, max_avail;
>> +		u64 dev_offset;
>>
>>    		/*
>>    		 * check to make sure we can actually find a chunk with enough
>> @@ -8106,7 +8106,7 @@ int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr)
>>    		 */
>>    		if (device->total_bytes>   device->bytes_used + min_free) {
>>    			ret = find_free_dev_extent(NULL, device, min_free,
>> -						&dev_offset,&max_avail);
>> +						&dev_offset, NULL);
>>    			if (!ret)
>>    				break;
>>    			ret = -1;
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index e1028f4..15e8c3f 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -729,58 +729,82 @@ error:
>>    }
>>
>>    /*
>> + * find_free_dev_extent - find free space in the specified device
>> + * @trans:	transaction handler
>> + * @device:	the device which we search the free space in
>> + * @num_bytes:	the size of the free space that we need
>> + * @start:	store the start of the free space.
>> + * @len:	the size of the free space. that we find, or the size of the max
>> + * 		free space if we don't find suitable free space
>> + *
>>     * this uses a pretty simple search, the expectation is that it is
>>     * called very infrequently and that a given device has a small number
>>     * of extents
>> + *
>> + * @start is used to store the start of the free space if we find. But if we
>> + * don't find suitable free space, it will be used to store the start position
>> + * of the max free space.
>> + *
>> + * @len is used to store the size of the free space that we find.
>> + * But if we don't find suitable free space, it is used to store the size of
>> + * the max free space.
>>     */
>>    int find_free_dev_extent(struct btrfs_trans_handle *trans,
>>    			 struct btrfs_device *device, u64 num_bytes,
>> -			 u64 *start, u64 *max_avail)
>> +			 u64 *start, u64 *len)
>>    {
>>    	struct btrfs_key key;
>>    	struct btrfs_root *root = device->dev_root;
>> -	struct btrfs_dev_extent *dev_extent = NULL;
>> +	struct btrfs_dev_extent *dev_extent;
>>    	struct btrfs_path *path;
>> -	u64 hole_size = 0;
>> -	u64 last_byte = 0;
>> -	u64 search_start = 0;
>> +	u64 hole_size;
>> +	u64 max_hole_start;
>> +	u64 max_hole_size;
>> +	u64 extent_end;
>> +	u64 search_start;
>>    	u64 search_end = device->total_bytes;
>>    	int ret;
>> -	int slot = 0;
>> -	int start_found;
>> +	int slot;
>>    	struct extent_buffer *l;
>>
>> -	path = btrfs_alloc_path();
>> -	if (!path)
>> -		return -ENOMEM;
>> -	path->reada = 2;
>> -	start_found = 0;
>> -
>>    	/* FIXME use last free of some kind */
>>
>>    	/* we don't want to overwrite the superblock on the drive,
>>    	 * so we make sure to start at an offset of at least 1MB
>>    	 */
>> -	search_start = max((u64)1024 * 1024, search_start);
>> +	search_start = 1024 * 1024;
>>
>> -	if (root->fs_info->alloc_start + num_bytes<= device->total_bytes)
>> +	if (root->fs_info->alloc_start + num_bytes<= search_end)
>>    		search_start = max(root->fs_info->alloc_start, search_start);
>>
>> +	max_hole_start = search_start;
>> +	max_hole_size = 0;
>> +
>> +	if (search_start>= search_end) {
>> +		ret = -ENOSPC;
>> +		goto error;
>> +	}
>> +
>> +	path = btrfs_alloc_path();
>> +	if (!path) {
>> +		ret = -ENOMEM;
>> +		goto error;
>> +	}
>> +	path->reada = 2;
>> +
>>    	key.objectid = device->devid;
>>    	key.offset = search_start;
>>    	key.type = BTRFS_DEV_EXTENT_KEY;
>> +
>>    	ret = btrfs_search_slot(trans, root,&key, path, 0, 0);
>>    	if (ret<   0)
>> -		goto error;
>> +		goto out;
>>    	if (ret>   0) {
>>    		ret = btrfs_previous_item(root, path, key.objectid, key.type);
>>    		if (ret<   0)
>> -			goto error;
>> -		if (ret>   0)
>> -			start_found = 1;
>> +			goto out;
>>    	}
>> -	l = path->nodes[0];
>> -	btrfs_item_key_to_cpu(l,&key, path->slots[0]);
>> +
>>    	while (1) {
>>    		l = path->nodes[0];
>>    		slot = path->slots[0];
>> @@ -789,24 +813,9 @@ int find_free_dev_extent(struct btrfs_trans_handle *trans,
>>    			if (ret == 0)
>>    				continue;
>>    			if (ret<   0)
>> -				goto error;
>> -no_more_items:
>> -			if (!start_found) {
>> -				if (search_start>= search_end) {
>> -					ret = -ENOSPC;
>> -					goto error;
>> -				}
>> -				*start = search_start;
>> -				start_found = 1;
>> -				goto check_pending;
>> -			}
>> -			*start = last_byte>   search_start ?
>> -				last_byte : search_start;
>> -			if (search_end<= *start) {
>> -				ret = -ENOSPC;
>> -				goto error;
>> -			}
>> -			goto check_pending;
>> +				goto out;
>> +
>> +			break;
>>    		}
>>    		btrfs_item_key_to_cpu(l,&key, slot);
>>
>> @@ -814,48 +823,62 @@ no_more_items:
>>    			goto next;
>>
>>    		if (key.objectid>   device->devid)
>> -			goto no_more_items;
>> +			break;
>>
>> -		if (key.offset>= search_start&&   key.offset>   last_byte&&
>> -		    start_found) {
>> -			if (last_byte<   search_start)
>> -				last_byte = search_start;
>> -			hole_size = key.offset - last_byte;
>> +		if (btrfs_key_type(&key) != BTRFS_DEV_EXTENT_KEY)
>> +			goto next;
>>
>> -			if (hole_size>   *max_avail)
>> -				*max_avail = hole_size;
>> +		if (key.offset>   search_start) {
>> +			hole_size = key.offset - search_start;
>>
>> -			if (key.offset>   last_byte&&
>> -			    hole_size>= num_bytes) {
>> -				*start = last_byte;
>> -				goto check_pending;
>> +			if (hole_size>   max_hole_size) {
>> +				max_hole_start = search_start;
>> +				max_hole_size = hole_size;
>> +			}
>> +
>> +			/*
>> +			 * If this free space is greater than which we need,
>> +			 * it must be the max free space that we have found
>> +			 * until now, so max_hole_start must point to the start
>> +			 * of this free space and the length of this free space
>> +			 * is stored in max_hole_size. Thus, we return
>> +			 * max_hole_start and max_hole_size and go back to the
>> +			 * caller.
>> +			 */
>> +			if (hole_size>= num_bytes) {
>> +				ret = 0;
>> +				goto out;
>>    			}
>>    		}
>> -		if (btrfs_key_type(&key) != BTRFS_DEV_EXTENT_KEY)
>> -			goto next;
>>
>> -		start_found = 1;
>>    		dev_extent = btrfs_item_ptr(l, slot, struct btrfs_dev_extent);
>> -		last_byte = key.offset + btrfs_dev_extent_length(l, dev_extent);
>> +		extent_end = key.offset + btrfs_dev_extent_length(l,
>> +								  dev_extent);
>> +		if (extent_end>   search_start)
>> +			search_start = extent_end;
>>    next:
>>    		path->slots[0]++;
>>    		cond_resched();
>>    	}
>> -check_pending:
>> -	/* we have to make sure we didn't find an extent that has already
>> -	 * been allocated by the map tree or the original allocation
>> -	 */
>> -	BUG_ON(*start<   search_start);
>>
>> -	if (*start + num_bytes>   search_end) {
>> -		ret = -ENOSPC;
>> -		goto error;
>> +	hole_size = search_end- search_start;
>> +	if (hole_size>   max_hole_size) {
>> +		max_hole_start = search_start;
>> +		max_hole_size = hole_size;
>>    	}
>> -	/* check for pending inserts here */
>> -	ret = 0;
>>
>> -error:
>> +	/* See above. */
>> +	if (hole_size<   num_bytes)
>> +		ret = -ENOSPC;
>> +	else
>> +		ret = 0;
>> +
>> +out:
>>    	btrfs_free_path(path);
>> +error:
>> +	*start = max_hole_start;
>> +	if (len&&   max_hole_size>   *len)
>> +		*len = max_hole_size;
>>    	return ret;
>>    }
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

