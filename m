Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62456 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753986AbcFHB0E (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Jun 2016 21:26:04 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id 4FC3F498F583
	for <linux-btrfs@vger.kernel.org>; Wed,  8 Jun 2016 09:25:58 +0800 (CST)
Subject: Re: [PATCH RFC] btrfs: Slightly speedup btrfs_read_block_groups
To: <linux-btrfs@vger.kernel.org>
References: <1462434673-8395-1-git-send-email-quwenruo@cn.fujitsu.com>
 <cf4f6373-cbe3-b535-4292-0bf848801b44@cn.fujitsu.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <d2184737-9a1b-8c77-130e-333348e6d69a@cn.fujitsu.com>
Date: Wed, 8 Jun 2016 09:25:57 +0800
MIME-Version: 1.0
In-Reply-To: <cf4f6373-cbe3-b535-4292-0bf848801b44@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ping?

Thanks,
Qu

At 05/23/2016 04:02 PM, Qu Wenruo wrote:
> Any comment on this patch?
>
> BTW, for anyone who is interested in the speedup, and the trace result,
> I've updated it to google driver:
>
> https://drive.google.com/open?id=0BxpkL3ehzX3pbFEybXd3X3MzRGM
> https://drive.google.com/open?id=0BxpkL3ehzX3pd1ByOFhhbml3Ujg
>
> Thanks,
> Qu
>
> Qu Wenruo wrote on 2016/05/05 15:51 +0800:
>> Btrfs_read_block_groups() function is the most time consuming function
>> if the whole fs is filled with small extents.
>>
>> For a btrfs filled with all 16K sized files, and when 2T space is used,
>> mount the fs needs 10 to 12 seconds.
>>
>> While ftrace shows that, btrfs_read_block_groups() takes about 9
>> seconds, while btrfs_read_chunk_tree() only takes 14ms.
>> In theory, btrfs_read_chunk_tree() and btrfs_read_block_groups() should
>> take the same time, as chunk and block groups are 1:1 mapped.
>>
>> However, considering block group items are spread across the large
>> extent tree, it takes a lot of time to search btree.
>>
>> And furthermore, find_first_block_group() function used by
>> btrfs_read_block_groups() is using a very bad method to locate block
>> group item, by searching and then checking slot by slot.
>>
>> In kernel space, checking slot by slot is a little time consuming, as
>> for next_leaf() case, kernel need to do extra locking.
>>
>> This patch will fix the slot by slot checking, as when we call
>> btrfs_read_block_groups(), we have already read out all chunks and save
>> them into map_tree.
>>
>> So we use map_tree to get exact block group start and length, then do
>> exact btrfs_search_slot(), without slot by slot check, to speedup the
>> mount.
>>
>> With this patch, time spent on btrfs_read_block_groups() is reduced to
>> 7.56s, compared to old 8.94s.
>>
>> Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>
>> ---
>> The further fix would change the mount process from reading out all
>> block groups to reading out block group on demand.
>>
>> But according to the btrfs_read_chunk_tree() calling time, the real
>> problem is the on-disk format and btree locking.
>>
>> If block group items are arranged like chunks, in a dedicated tree,
>> btrfs_read_block_groups() should take the same time as
>> btrfs_read_chunk_tree().
>>
>> And further more, if we can split current huge extent tree into
>> something like per-chunk extent tree, a lot of current code like
>> delayed_refs can be removed, as extent tree operation will be much
>> faster.
>> ---
>>  fs/btrfs/extent-tree.c | 61
>> ++++++++++++++++++++------------------------------
>>  fs/btrfs/extent_map.c  |  1 +
>>  fs/btrfs/extent_map.h  | 22 ++++++++++++++++++
>>  3 files changed, 47 insertions(+), 37 deletions(-)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 8507484..9fa7728 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -9520,39 +9520,20 @@ out:
>>      return ret;
>>  }
>>
>> -static int find_first_block_group(struct btrfs_root *root,
>> -        struct btrfs_path *path, struct btrfs_key *key)
>> +int find_block_group(struct btrfs_root *root,
>> +                   struct btrfs_path *path,
>> +                   struct extent_map *chunk_em)
>>  {
>>      int ret = 0;
>> -    struct btrfs_key found_key;
>> -    struct extent_buffer *leaf;
>> -    int slot;
>> -
>> -    ret = btrfs_search_slot(NULL, root, key, path, 0, 0);
>> -    if (ret < 0)
>> -        goto out;
>> +    struct btrfs_key key;
>>
>> -    while (1) {
>> -        slot = path->slots[0];
>> -        leaf = path->nodes[0];
>> -        if (slot >= btrfs_header_nritems(leaf)) {
>> -            ret = btrfs_next_leaf(root, path);
>> -            if (ret == 0)
>> -                continue;
>> -            if (ret < 0)
>> -                goto out;
>> -            break;
>> -        }
>> -        btrfs_item_key_to_cpu(leaf, &found_key, slot);
>> +    key.objectid = chunk_em->start;
>> +    key.offset = chunk_em->len;
>> +    key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
>>
>> -        if (found_key.objectid >= key->objectid &&
>> -            found_key.type == BTRFS_BLOCK_GROUP_ITEM_KEY) {
>> -            ret = 0;
>> -            goto out;
>> -        }
>> -        path->slots[0]++;
>> -    }
>> -out:
>> +    ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
>> +    if (ret > 0)
>> +        ret = -ENOENT;
>>      return ret;
>>  }
>>
>> @@ -9771,16 +9752,14 @@ int btrfs_read_block_groups(struct btrfs_root
>> *root)
>>      struct btrfs_block_group_cache *cache;
>>      struct btrfs_fs_info *info = root->fs_info;
>>      struct btrfs_space_info *space_info;
>> -    struct btrfs_key key;
>> +    struct btrfs_mapping_tree *map_tree = &root->fs_info->mapping_tree;
>> +    struct extent_map *chunk_em;
>>      struct btrfs_key found_key;
>>      struct extent_buffer *leaf;
>>      int need_clear = 0;
>>      u64 cache_gen;
>>
>>      root = info->extent_root;
>> -    key.objectid = 0;
>> -    key.offset = 0;
>> -    key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
>>      path = btrfs_alloc_path();
>>      if (!path)
>>          return -ENOMEM;
>> @@ -9793,10 +9772,16 @@ int btrfs_read_block_groups(struct btrfs_root
>> *root)
>>      if (btrfs_test_opt(root, CLEAR_CACHE))
>>          need_clear = 1;
>>
>> +    /* Here we don't lock the map tree, as we are the only reader */
>> +    chunk_em = first_extent_mapping(&map_tree->map_tree);
>> +    /* Not really possible */
>> +    if (!chunk_em) {
>> +        ret = -ENOENT;
>> +        goto error;
>> +    }
>> +
>>      while (1) {
>> -        ret = find_first_block_group(root, path, &key);
>> -        if (ret > 0)
>> -            break;
>> +        ret = find_block_group(root, path, chunk_em);
>>          if (ret != 0)
>>              goto error;
>>
>> @@ -9830,7 +9815,6 @@ int btrfs_read_block_groups(struct btrfs_root
>> *root)
>>                     sizeof(cache->item));
>>          cache->flags = btrfs_block_group_flags(&cache->item);
>>
>> -        key.objectid = found_key.objectid + found_key.offset;
>>          btrfs_release_path(path);
>>
>>          /*
>> @@ -9911,6 +9895,9 @@ int btrfs_read_block_groups(struct btrfs_root
>> *root)
>>              }
>>              spin_unlock(&info->unused_bgs_lock);
>>          }
>> +        chunk_em = next_extent_mapping(chunk_em);
>> +        if (!chunk_em)
>> +            break;
>>      }
>>
>>      list_for_each_entry_rcu(space_info, &root->fs_info->space_info,
>> list) {
>> diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
>> index 318b048..7e781e7 100644
>> --- a/fs/btrfs/extent_map.c
>> +++ b/fs/btrfs/extent_map.c
>> @@ -453,3 +453,4 @@ void replace_extent_mapping(struct extent_map_tree
>> *tree,
>>
>>      setup_extent_mapping(tree, new, modified);
>>  }
>> +
>> diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
>> index eb8b8fa..9358e3e 100644
>> --- a/fs/btrfs/extent_map.h
>> +++ b/fs/btrfs/extent_map.h
>> @@ -90,4 +90,26 @@ int unpin_extent_cache(struct extent_map_tree
>> *tree, u64 start, u64 len, u64 gen
>>  void clear_em_logging(struct extent_map_tree *tree, struct extent_map
>> *em);
>>  struct extent_map *search_extent_mapping(struct extent_map_tree *tree,
>>                       u64 start, u64 len);
>> +
>> +static inline struct extent_map *
>> +first_extent_mapping(struct extent_map_tree *tree)
>> +{
>> +    struct rb_node *node;
>> +
>> +    node = rb_first(&tree->map);
>> +    if (!node)
>> +        return NULL;
>> +    return rb_entry(node, struct extent_map, rb_node);
>> +}
>> +
>> +static inline struct extent_map *
>> +next_extent_mapping(struct extent_map *map)
>> +{
>> +    struct rb_node *node;
>> +
>> +    node = rb_next(&map->rb_node);
>> +    if (!node)
>> +        return NULL;
>> +    return rb_entry(node, struct extent_map, rb_node);
>> +}
>>  #endif
>>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


