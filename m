Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:26590 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752497AbcJMIOd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Oct 2016 04:14:33 -0400
Subject: Re: [PATCH v1] btrfs: Avoid reading out unnecessary extent tree
 blocks when mounting
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <20160707021159.10335-1-quwenruo@cn.fujitsu.com>
 <20161012145536.GR11398@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <95181915-73b4-8975-92d2-518352d85965@cn.fujitsu.com>
Date: Thu, 13 Oct 2016 16:13:22 +0800
MIME-Version: 1.0
In-Reply-To: <20161012145536.GR11398@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 10/12/2016 10:55 PM, David Sterba wrote:
> On Thu, Jul 07, 2016 at 10:11:59AM +0800, Qu Wenruo wrote:
>> Btrfs_read_block_groups() function is the most time consuming function
>> if the fs is large and filled with small extents.
>>
>> For a btrfs filled with 100,000,000 16K sized files, mount the fs takes
>> about 10 seconds.
>>
>> While ftrace shows that, btrfs_read_block_groups() takes about 9
>> seconds, taking up 90% of the mount time.
>> So it's worthy to speedup btrfs_read_block_groups(), to reduce the
>> overall mount time.
>>
>> Btrfs_read_block_groups() calls btrfs_search_slot() to find block group
>> items.
>> However the search key is (<block group start>, BLOCK_GROUP_KEY, 0).
>> This makes search_slot() always returns previous slot.
>>
>> Under most case, it's OK since the block group item and previous slot
>> are in the same leaf.
>> But for cases where block group item are the first item of a leaf, we
>> must read out next leaf to get block group item.
>> This needs extra IO and makes btrfs_read_block_groups() slower.
>>
>> In fact, before we call btrfs_read_block_groups(), we have already read
>> out all chunks, which are 1:1 mapped with block group items.
>> So we can get the exact block group length for btrfs_search_slot(), to
>> avoid any possible btrfs_next_leaf() to speedup
>> btrfs_read_block_groups().
>>
>> With this patch, time spent on btrfs_read_block_groups() is reduced to
>> 7.56s, compared to old 8.94s, about 15% improvement.
>
> It would be interesting to see if it helps to speed up the mount on a
> large filesystem where it takes long to mount. The difference is ~1
> second, this is too low to claim a 15% improvement.

Considering the original 8.94s, 1s is already near 15%.

But this doesn't really help much, as the 1s improvement seems to be the 
best result.

The extent tree has quite a lot of block group item in the first slot of 
the leaf, which this patch helps.

If not many block group items are in the first slot, then not much help.
So it seems I'm just lucky to create such a fs to test the fs.

Another tester reported this patch doesn't really reduce the mount time.

So please ignore this patch.
The root fix will be per-chunk extent tree, IIRC Josef is working on that.

Thanks,
Qu

>
>>
>> Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>> v2:
>>   Update commit message
>> ---
>>  fs/btrfs/extent-tree.c | 61 ++++++++++++++++++++------------------------------
>>  fs/btrfs/extent_map.h  | 22 ++++++++++++++++++
>>  2 files changed, 46 insertions(+), 37 deletions(-)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 82b912a..874f5b3 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -9648,39 +9648,20 @@ out:
>>  	return ret;
>>  }
>>
>> -static int find_first_block_group(struct btrfs_root *root,
>> -		struct btrfs_path *path, struct btrfs_key *key)
>> +int find_block_group(struct btrfs_root *root,
>> +				   struct btrfs_path *path,
>> +				   struct extent_map *chunk_em)
>>  {
>>  	int ret = 0;
>> -	struct btrfs_key found_key;
>> -	struct extent_buffer *leaf;
>> -	int slot;
>> -
>> -	ret = btrfs_search_slot(NULL, root, key, path, 0, 0);
>> -	if (ret < 0)
>> -		goto out;
>> +	struct btrfs_key key;
>>
>> -	while (1) {
>> -		slot = path->slots[0];
>> -		leaf = path->nodes[0];
>> -		if (slot >= btrfs_header_nritems(leaf)) {
>> -			ret = btrfs_next_leaf(root, path);
>> -			if (ret == 0)
>> -				continue;
>> -			if (ret < 0)
>> -				goto out;
>> -			break;
>> -		}
>> -		btrfs_item_key_to_cpu(leaf, &found_key, slot);
>> +	key.objectid = chunk_em->start;
>> +	key.offset = chunk_em->len;
>> +	key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
>>
>> -		if (found_key.objectid >= key->objectid &&
>> -		    found_key.type == BTRFS_BLOCK_GROUP_ITEM_KEY) {
>> -			ret = 0;
>> -			goto out;
>> -		}
>> -		path->slots[0]++;
>> -	}
>> -out:
>> +	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
>> +	if (ret > 0)
>> +		ret = -ENOENT;
>>  	return ret;
>>  }
>>
>> @@ -9899,16 +9880,14 @@ int btrfs_read_block_groups(struct btrfs_root *root)
>>  	struct btrfs_block_group_cache *cache;
>>  	struct btrfs_fs_info *info = root->fs_info;
>>  	struct btrfs_space_info *space_info;
>> -	struct btrfs_key key;
>> +	struct btrfs_mapping_tree *map_tree = &root->fs_info->mapping_tree;
>> +	struct extent_map *chunk_em;
>>  	struct btrfs_key found_key;
>>  	struct extent_buffer *leaf;
>>  	int need_clear = 0;
>>  	u64 cache_gen;
>>
>>  	root = info->extent_root;
>> -	key.objectid = 0;
>> -	key.offset = 0;
>> -	key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
>>  	path = btrfs_alloc_path();
>>  	if (!path)
>>  		return -ENOMEM;
>> @@ -9921,10 +9900,16 @@ int btrfs_read_block_groups(struct btrfs_root *root)
>>  	if (btrfs_test_opt(root, CLEAR_CACHE))
>>  		need_clear = 1;
>>
>> +	/* Here we don't lock the map tree, as we are the only reader */
>> +	chunk_em = first_extent_mapping(&map_tree->map_tree);
>> +	/* Not really possible */
>> +	if (!chunk_em) {
>> +		ret = -ENOENT;
>> +		goto error;
>> +	}
>> +
>>  	while (1) {
>> -		ret = find_first_block_group(root, path, &key);
>> -		if (ret > 0)
>> -			break;
>> +		ret = find_block_group(root, path, chunk_em);
>>  		if (ret != 0)
>>  			goto error;
>>
>> @@ -9958,7 +9943,6 @@ int btrfs_read_block_groups(struct btrfs_root *root)
>>  				   sizeof(cache->item));
>>  		cache->flags = btrfs_block_group_flags(&cache->item);
>>
>> -		key.objectid = found_key.objectid + found_key.offset;
>>  		btrfs_release_path(path);
>>
>>  		/*
>> @@ -10039,6 +10023,9 @@ int btrfs_read_block_groups(struct btrfs_root *root)
>>  			}
>>  			spin_unlock(&info->unused_bgs_lock);
>>  		}
>> +		chunk_em = next_extent_mapping(chunk_em);
>> +		if (!chunk_em)
>> +			break;
>>  	}
>>
>>  	list_for_each_entry_rcu(space_info, &root->fs_info->space_info, list) {
>> diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
>> index eb8b8fa..9358e3e 100644
>> --- a/fs/btrfs/extent_map.h
>> +++ b/fs/btrfs/extent_map.h
>> @@ -90,4 +90,26 @@ int unpin_extent_cache(struct extent_map_tree *tree, u64 start, u64 len, u64 gen
>>  void clear_em_logging(struct extent_map_tree *tree, struct extent_map *em);
>>  struct extent_map *search_extent_mapping(struct extent_map_tree *tree,
>>  					 u64 start, u64 len);
>> +
>> +static inline struct extent_map *
>> +first_extent_mapping(struct extent_map_tree *tree)
>> +{
>> +	struct rb_node *node;
>> +
>> +	node = rb_first(&tree->map);
>> +	if (!node)
>> +		return NULL;
>> +	return rb_entry(node, struct extent_map, rb_node);
>> +}
>> +
>> +static inline struct extent_map *
>> +next_extent_mapping(struct extent_map *map)
>> +{
>> +	struct rb_node *node;
>> +
>> +	node = rb_next(&map->rb_node);
>> +	if (!node)
>> +		return NULL;
>> +	return rb_entry(node, struct extent_map, rb_node);
>> +}
>>  #endif
>> --
>> 2.9.0
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


