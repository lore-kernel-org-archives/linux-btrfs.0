Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:45480 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751648AbdK1Igb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Nov 2017 03:36:31 -0500
Subject: Re: [PATCH 3/3] btrfs-progs: check: exclude extents of tree blocks
 and extent items
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, <linux-btrfs@vger.kernel.org>
References: <20171127031353.9338-1-suy.fnst@cn.fujitsu.com>
 <20171127031353.9338-4-suy.fnst@cn.fujitsu.com>
 <dffaee0f-6b98-b834-75b9-7d79a7ef3e08@gmx.com>
 <27271d15-991b-d964-17f4-128c9d63e6b7@cn.fujitsu.com>
 <3fc6c9b0-2c84-7bef-1775-bf3af708aa46@gmx.com>
 <d010dc5e-8770-c702-f13c-f61657f9c954@cn.fujitsu.com>
 <d7bf2d14-a2e1-9d27-ac09-80933717d57c@gmx.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <a23d78eb-6eff-f80c-38e0-c70e26b2f729@cn.fujitsu.com>
Date: Tue, 28 Nov 2017 16:40:13 +0800
MIME-Version: 1.0
In-Reply-To: <d7bf2d14-a2e1-9d27-ac09-80933717d57c@gmx.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11/28/2017 04:25 PM, Qu Wenruo wrote:
> 
> 
> On 2017年11月28日 15:47, Su Yue wrote:
>>
>>
>> On 11/28/2017 12:05 PM, Qu Wenruo wrote:
>>>
>>>
>>> On 2017年11月28日 10:38, Su Yue wrote:
>>>> Thanks for review.
>>>>
>>>> On 11/27/2017 06:37 PM, Qu Wenruo wrote:
>>>>>
>>>>>
>>>>> On 2017年11月27日 11:13, Su Yue wrote:
>>>>>> Commit d17d6663c99c ("btrfs-progs: lowmem check: Fix regression which
>>>>>> screws up extent allocator") removes pin_metadata_blocks() from
>>>>>> lowmem repair.
>>>>>> So we have to find another way to exclude extents which should be
>>>>>> occupied by tree blocks.
>>>>>
>>>>> First thing first, any tree block which is referred by will not be
>>>>> freed.
>>>>>
>>>>> Unless some special case, like extent tree initialization which clears
>>>>> the whole extent tree so we can't check if one tree block should be
>>>>> freed using extent tree, there is no need to explicitly pin existing
>>>>> tree blocks.
>>>>>
>>>>> Their creation/freeing is already handled well.
>>>>>
>>>> If I understand the logic of extents correctly:
>>>>
>>>> The extents in free space cache are handled in the way like
>>>> cache_block_group() in extent-tree.c.
>>>> It traverses all extents items then marks all holes free in free space
>>>> cache.
>>>>
>>>> Yes, in a normal situation, extents are already handled well.
>>>> But original and lowmem check try to repair corrupted extent tree.
>>>>
>>>> Suppose a situation:
>>>> 1) Let an extent item of one tree block is corrupted or missed.
>>>> 2) The correct extent in free space cache will be marked as free.
>>>> 3) Next CoW may allocate the "used" extents from free space
>>>>      and insert an extent item.
>>>> 4) Lowmem repair increases refs of the extent item and
>>>>      causes a wrong extent item.
>>>> OR
>>>> 3) Lowmem repair inserts the extent item firstly.
>>>> 4) CoW may allocate the "used" extents from free space.
>>>>      BUG_ON failure of inserting the extent item.
>>>
>>> OK, this explains things, but still not optimal.
>>>
>>> Such behavior should not happen if nothing is exposed.
>>> Pinning down all tree blocks is never a light operation and should be
>>> avoided if possible.
>>>
>>
>> Agreed.
>>
>>> It would be nice to do it when starting a new transaction to modify
>>> the fs.
>>>
>>
>> Now, there is only one transaction while checking chunks and extents
>> because of previous wrong call of pin_metadata_blocks().
>> It's meaningless to put it at start of new transaction now.
> 
> Because you start that transaction under all condition.
> 
> Normally, transaction should only be started if you're sure you will
> modify the filesystem.
> 
> Start them unconditionally is not a preferred behavior.
> 
>>
>> I will split the transaction into many minors. Then lowmem repair will
>> speed up if no error in chunks and extents. But it is just a little
>> optimization.
> 
> Compared to iterating all tree blocks, it's a big optimization.
> 
> Just think of filesystem with several TB metadata.
> 
>>
>>>>
>>>>> Please explain the reason why you need to pin extents first.
>>>>>
>>>> What I do in the patch is like origin mode's.
>>>> Pining extents first ensures every extents(corrupted and uncorrupted)
>>>> will not be rellocated.
>>>
>>> Only extent tree reinit will pin down all metadata block in original
>>> mode while normal repair won't.
>>>
>>> So you're still doing something which is not done in original mode,
>>> which either needs to be explained in detail or fix original mode first.
>>>
>>
>> You are right. I did miss details of how original mode frees extent
>> records.
>>
>> After come thinking, pining extents is still necessary in lowmem
>> repair.
>>
>> Original mode has extent cache to record all extents and free normal
>> extents while traversing tree blocks.
>> After traversal, only corrupted extent records exist in the cache.
>> At this moment, it pins them and start transactions to repair.
>>
>> Lowmem mode does not store anything like extent records. It begins
>> transactions(in further patch) in traversal. We can not guarantee
>> extents allocated from free space is occupied by one tree block which
>> has not been traversed.
>>
>> Although pining extents is heavy and painfully work, it seems
>> inevitable. Otherwise, I have no better idea than pining all
>> extents.
> 
> Firstly, only missing backref in extent tree will cause problem.
> 
> Even we have corrupted backref or extra backref which doesn't have any
> tree block/data referring it, it won't cause a big problem.
> 
> So for lowmem mode, we can do it in a different way, just like seed
> device, we allocate new meta chunks, and only use new meta chunks for
> our tree operations.
> 
> This will avoid any extra tree iteration, and easier to implement AFAIK.
> (Just mark all existing block groups full, to force chunk allocation)
> 

Seems feasible! I will try to implement it.

Thanks,
Su

> Thanks,
> Qu
> 
>>
>> Thanks,
>> Su
>>
>>>>
>>>> Thanks,
>>>> Su
>>>>
>>>>> Thanks,
>>>>> Qu
>>>>>
>>>>>>
>>>>>> Modify pin_down_tree_blocks() only for code reuse.
>>>>>> So behavior of pin_metadata_blocks() which works with option
>>>>>> 'init-extent-tree' is not influenced.
>>>>>>
>>>>>> Introduce exclude_blocks_and_extent_items() to mark extents of all
>>>>>> tree
>>>>>> blocks dirty in fs_info->excluded_extents. It also calls
>>>>>> exclude_extent_items() to exclude extent_items in extent tree.
>>>>>>
>>>>>> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
>>>>>> ---
>>>>>>     cmds-check.c | 122
>>>>>> ++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
>>>>>>     1 file changed, 112 insertions(+), 10 deletions(-)
>>>>>>
>>>>>> diff --git a/cmds-check.c b/cmds-check.c
>>>>>> index c7b570bef9c3..f39285c5a3c2 100644
>>>>>> --- a/cmds-check.c
>>>>>> +++ b/cmds-check.c
>>>>>> @@ -13351,6 +13351,7 @@ out:
>>>>>>         return err;
>>>>>>     }
>>>>>>     +static int exclude_blocks_and_extent_items(struct btrfs_fs_info
>>>>>> *fs_info);
>>>>>>     /*
>>>>>>      * Low memory usage version check_chunks_and_extents.
>>>>>>      */
>>>>>> @@ -13363,12 +13364,22 @@ static int
>>>>>> check_chunks_and_extents_v2(struct btrfs_fs_info *fs_info)
>>>>>>         struct btrfs_root *root1;
>>>>>>         struct btrfs_root *root;
>>>>>>         struct btrfs_root *cur_root;
>>>>>> +    struct extent_io_tree excluded_extents;
>>>>>>         int err =;
>>>>>>         int ret;
>>>>>>           root =s_info->fs_root;
>>>>>>           if (repair) {
>>>>>> +        extent_io_tree_init(&excluded_extents);
>>>>>> +        fs_info->excluded_extents =excluded_extents;
>>>>>> +        ret =xclude_blocks_and_extent_items(fs_info);
>>>>>> +        if (ret) {
>>>>>> +            error("failed to exclude tree blocks and extent items");
>>>>>> +            return ret;
>>>>>> +        }
>>>>>> +        reset_cached_block_groups(fs_info);
>>>>>> +
>>>>>>             trans =trfs_start_transaction(fs_info->extent_root, 1);
>>>>>>             if (IS_ERR(trans)) {
>>>>>>                 error("failed to start transaction before check");
>>>>>> @@ -13437,6 +13448,8 @@ out:
>>>>>>                 err |=et;
>>>>>>             else
>>>>>>                 err &=BG_ACCOUNTING_ERROR;
>>>>>> +        extent_io_tree_cleanup(&excluded_extents);
>>>>>> +        fs_info->excluded_extents =ULL;
>>>>>>         }
>>>>>>           if (trans)
>>>>>> @@ -13534,40 +13547,106 @@ init:
>>>>>>         return 0;
>>>>>>     }
>>>>>>     -static int pin_down_tree_blocks(struct btrfs_fs_info *fs_info,
>>>>>> -                struct extent_buffer *eb, int tree_root)
>>>>>> +static int exclude_extent_items(struct btrfs_fs_info *fs_info,
>>>>>> +                struct extent_io_tree *tree)
>>>>>> +{
>>>>>> +    struct btrfs_root *root =s_info->extent_root;
>>>>>> +    struct btrfs_key key;
>>>>>> +    struct btrfs_path path;
>>>>>> +    struct extent_buffer *eb;
>>>>>> +    int slot;
>>>>>> +    int ret;
>>>>>> +    u64 start;
>>>>>> +    u64 end;
>>>>>> +
>>>>>> +    ASSERT(tree);
>>>>>> +    btrfs_init_path(&path);
>>>>>> +    key.objectid =;
>>>>>> +    key.type =;
>>>>>> +    key.offset =;
>>>>>> +
>>>>>> +    ret =trfs_search_slot(NULL, root, &key, &path, 0, 0);
>>>>>> +    if (ret < 0)
>>>>>> +        goto out;
>>>>>> +
>>>>>> +    while (1) {
>>>>>> +        eb =ath.nodes[0];
>>>>>> +        slot =ath.slots[0];
>>>>>> +        btrfs_item_key_to_cpu(eb, &key, slot);
>>>>>> +        if (key.type !=TRFS_EXTENT_ITEM_KEY &&
>>>>>> +            key.type !=TRFS_METADATA_ITEM_KEY)
>>>>>> +            goto next;
>>>>>> +        start =ey.objectid;
>>>>>> +        if (key.type =BTRFS_EXTENT_ITEM_KEY)
>>>>>> +            end =tart + key.offset;
>>>>>> +        else
>>>>>> +            end =tart + fs_info->nodesize;
>>>>>> +
>>>>>> +        set_extent_dirty(tree, start, end - 1);
>>>>>> +next:
>>>>>> +        ret =trfs_next_item(root, &path);
>>>>>> +        if (ret > 0) {
>>>>>> +            ret =;
>>>>>> +            goto out;
>>>>>> +        }
>>>>>> +        if (ret < 0)
>>>>>> +            goto out;
>>>>>> +    }
>>>>>> +out:
>>>>>> +    if (ret)
>>>>>> +        error("failed to exclude extent items");
>>>>>> +    btrfs_release_path(&path);
>>>>>> +    return ret;
>>>>>> +}
>>>>>> +
>>>>>> +static int traverse_tree_blocks(struct btrfs_fs_info *fs_info,
>>>>>> +                struct extent_buffer *eb, int tree_root,
>>>>>> +                int pin)
>>>>>>     {
>>>>>>         struct extent_buffer *tmp;
>>>>>>         struct btrfs_root_item *ri;
>>>>>>         struct btrfs_key key;
>>>>>> +    struct extent_io_tree *tree;
>>>>>>         u64 bytenr;
>>>>>>         int level =trfs_header_level(eb);
>>>>>>         int nritems;
>>>>>>         int ret;
>>>>>>         int i;
>>>>>> +    u64 end =b->start + eb->len;
>>>>>>     +    if (pin)
>>>>>> +        tree =fs_info->pinned_extents;
>>>>>> +    else
>>>>>> +        tree =s_info->excluded_extents;
>>>>>>         /*
>>>>>> -     * If we have pinned this block before, don't pin it again.
>>>>>> +     * If we have pinned/excluded this block before, don't do it
>>>>>> again.
>>>>>>          * This can not only avoid forever loop with broken filesystem
>>>>>>          * but also give us some speedups.
>>>>>>          */
>>>>>> -    if (test_range_bit(&fs_info->pinned_extents, eb->start,
>>>>>> -               eb->start + eb->len - 1, EXTENT_DIRTY, 0))
>>>>>> +    if (test_range_bit(tree, eb->start, end - 1, EXTENT_DIRTY, 0))
>>>>>>             return 0;
>>>>>>     -    btrfs_pin_extent(fs_info, eb->start, eb->len);
>>>>>> +    if (pin)
>>>>>> +        btrfs_pin_extent(fs_info, eb->start, eb->len);
>>>>>> +    else
>>>>>> +        set_extent_dirty(tree, eb->start, end - 1);
>>>>>>           nritems =trfs_header_nritems(eb);
>>>>>>         for (i =; i < nritems; i++) {
>>>>>>             if (level =0) {
>>>>>> +            bool is_extent_root;
>>>>>>                 btrfs_item_key_to_cpu(eb, &key, i);
>>>>>>                 if (key.type !=TRFS_ROOT_ITEM_KEY)
>>>>>>                     continue;
>>>>>>                 /* Skip the extent root and reloc roots */
>>>>>> -            if (key.objectid =BTRFS_EXTENT_TREE_OBJECTID ||
>>>>>> -                key.objectid =BTRFS_TREE_RELOC_OBJECTID ||
>>>>>> +            if (key.objectid =BTRFS_TREE_RELOC_OBJECTID ||
>>>>>>                     key.objectid =BTRFS_DATA_RELOC_TREE_OBJECTID)
>>>>>>                     continue;
>>>>>> +            is_extent_root >> +                key.objectid ==
>>>>>> BTRFS_EXTENT_TREE_OBJECTID;
>>>>>> +            /* If pin, skip the extent root */
>>>>>> +            if (pin && is_extent_root)
>>>>>> +                continue;
>>>>>>                 ri =trfs_item_ptr(eb, i, struct btrfs_root_item);
>>>>>>                 bytenr =trfs_disk_root_bytenr(eb, ri);
>>>>>>     @@ -13582,7 +13661,7 @@ static int pin_down_tree_blocks(struct
>>>>>> btrfs_fs_info *fs_info,
>>>>>>                     fprintf(stderr, "Error reading root block\n");
>>>>>>                     return -EIO;
>>>>>>                 }
>>>>>> -            ret =in_down_tree_blocks(fs_info, tmp, 0);
>>>>>> +            ret =raverse_tree_blocks(fs_info, tmp, 0, pin);
>>>>>>                 free_extent_buffer(tmp);
>>>>>>                 if (ret)
>>>>>>                     return ret;
>>>>>> @@ -13601,7 +13680,8 @@ static int pin_down_tree_blocks(struct
>>>>>> btrfs_fs_info *fs_info,
>>>>>>                     fprintf(stderr, "Error reading tree block\n");
>>>>>>                     return -EIO;
>>>>>>                 }
>>>>>> -            ret =in_down_tree_blocks(fs_info, tmp, tree_root);
>>>>>> +            ret =raverse_tree_blocks(fs_info, tmp, tree_root,
>>>>>> +                           pin);
>>>>>>                 free_extent_buffer(tmp);
>>>>>>                 if (ret)
>>>>>>                     return ret;
>>>>>> @@ -13611,6 +13691,12 @@ static int pin_down_tree_blocks(struct
>>>>>> btrfs_fs_info *fs_info,
>>>>>>         return 0;
>>>>>>     }
>>>>>>     +static int pin_down_tree_blocks(struct btrfs_fs_info *fs_info,
>>>>>> +                struct extent_buffer *eb, int tree_root)
>>>>>> +{
>>>>>> +    return traverse_tree_blocks(fs_info, eb, tree_root, 1);
>>>>>> +}
>>>>>> +
>>>>>>     static int pin_metadata_blocks(struct btrfs_fs_info *fs_info)
>>>>>>     {
>>>>>>         int ret;
>>>>>> @@ -13622,6 +13708,22 @@ static int pin_metadata_blocks(struct
>>>>>> btrfs_fs_info *fs_info)
>>>>>>         return pin_down_tree_blocks(fs_info,
>>>>>> fs_info->tree_root->node, 1);
>>>>>>     }
>>>>>>     +static int exclude_tree_blocks(struct btrfs_fs_info *fs_info,
>>>>>> +                struct extent_buffer *eb, int tree_root)
>>>>>> +{
>>>>>> +    return traverse_tree_blocks(fs_info, fs_info->tree_root->node,
>>>>>> 1, 0);
>>>>>> +}
>>>>>> +
>>>>>> +static int exclude_blocks_and_extent_items(struct btrfs_fs_info
>>>>>> *fs_info)
>>>>>> +{
>>>>>> +    int ret;
>>>>>> +
>>>>>> +    ret =xclude_extent_items(fs_info, fs_info->excluded_extents);
>>>>>> +    if (ret)
>>>>>> +        return ret;
>>>>>> +    return exclude_tree_blocks(fs_info, fs_info->tree_root->node, 1);
>>>>>> +}
>>>>>> +
>>>>>>     static int reset_block_groups(struct btrfs_fs_info *fs_info)
>>>>>>     {
>>>>>>         struct btrfs_block_group_cache *cache;
>>>>>>
>>>>>
>>>>
>>>>
>>>> -- 
>>>> To unsubscribe from this list: send the line "unsubscribe
>>>> linux-btrfs" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


