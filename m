Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:10464 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750871AbdLUHCK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Dec 2017 02:02:10 -0500
Subject: Re: [PATCH v2 06/17] btrfs-progs: lowmem check: introduce
 force_cow_in_new_chunk()
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, <linux-btrfs@vger.kernel.org>
References: <20171220045731.19343-1-suy.fnst@cn.fujitsu.com>
 <20171220045731.19343-7-suy.fnst@cn.fujitsu.com>
 <37268331-348d-fe29-db97-e289bb2dea1c@gmx.com>
 <3d829151-9b9a-9eae-e76d-b5bcd6e8c5fd@cn.fujitsu.com>
 <399b00c9-3ab5-e777-a69d-4cbaf3641ddb@gmx.com>
 <c70b76c8-61c8-999a-158f-667fa9c86b5f@gmx.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <b34701d4-89bd-ee24-4224-bbd84d0ba390@cn.fujitsu.com>
Date: Thu, 21 Dec 2017 15:06:16 +0800
MIME-Version: 1.0
In-Reply-To: <c70b76c8-61c8-999a-158f-667fa9c86b5f@gmx.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12/21/2017 02:51 PM, Qu Wenruo wrote:
> 
> 
> On 2017年12月20日 16:37, Qu Wenruo wrote:
>>
>>
>> On 2017年12月20日 16:21, Su Yue wrote:
>>>
>>>
>>> On 12/20/2017 01:41 PM, Qu Wenruo wrote:
>>>>
>>>>
>>>> On 2017年12月20日 12:57, Su Yue wrote:
>>>>> Introduce create_chunk_and_block_block_group() to allocate new chunk
>>>>> and corresponding block group.
>>>>>
>>>>> The new function force_cow_in_new_chunk() first allocates new chunk
>>>>> and records its start.
>>>>> Then it modifies all metadata block groups cached and full.
>>>>> Finally it marks the new block group uncached and unfree.
>>>>> In the next CoW, extents states will be updated automatically by
>>>>> cache_block_group().
>>>>>
>>>>> Suggested-by: Qu Wenruo <wqu@suse.com>
>>>>> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
>>>>> ---
>>>>>    cmds-check.c | 80
>>>>> ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>>>    1 file changed, 80 insertions(+)
>>>>>
>>>>> diff --git a/cmds-check.c b/cmds-check.c
>>>>> index d98d4bda7357..311c8a9f45e8 100644
>>>>> --- a/cmds-check.c
>>>>> +++ b/cmds-check.c
>>>>> @@ -10911,6 +10911,86 @@ out:
>>>>>        return ret;
>>>>>    }
>>>>>    +static int create_chunk_and_block_group(struct btrfs_fs_info
>>>>> *fs_info,
>>>>> +                    u64 flags, u64 *start, u64 *nbytes)
>>>>> +{
>>>>> +    struct btrfs_trans_handle *trans;
>>>>> +    struct btrfs_root *root = fs_info->extent_root;
>>>>> +    int ret;
>>>>> +
>>>>> +    if ((flags & BTRFS_BLOCK_GROUP_TYPE_MASK) == 0)
>>>>> +        return -EINVAL;
>>>>> +
>>>>> +    trans = btrfs_start_transaction(root, 1);
>>>>> +    if (IS_ERR(trans)) {
>>>>> +        ret = PTR_ERR(trans);
>>>>> +        error("error starting transaction %s", strerror(-ret));
>>>>> +        return ret;
>>>>> +    }
>>>>> +    ret = btrfs_alloc_chunk(trans, fs_info, start, nbytes, flags);
>>>>> +    if (ret) {
>>>>> +        error("fail to allocate new chunk %s", strerror(-ret));
>>>>> +        goto out;
>>>>> +    }
>>>>> +    ret = btrfs_make_block_group(trans, fs_info, 0, flags,
>>>>> +                 BTRFS_FIRST_CHUNK_TREE_OBJECTID, *start, *nbytes);
>>>>> +    if (ret) {
>>>>> +        error("fail to make block group for chunk %llu %llu %s",
>>>>> +              *start, *nbytes, strerror(-ret));
>>>>> +        goto out;
>>>>> +    }
>>>>> +out:
>>>>> +    btrfs_commit_transaction(trans, root);
>>>>> +    return ret;
>>>>> +}
>>>>> +
>>>>> +static int force_cow_in_new_chunk(struct btrfs_fs_info *fs_info)
>>>>> +{
>>>>> +    struct btrfs_block_group_cache *bg;
>>>>> +    u64 start;
>>>>> +    u64 nbytes;
>>>>> +    u64 alloc_profile;
>>>>> +    u64 flags;
>>>>> +    int ret;
>>>>> +
>>>>> +    alloc_profile = (fs_info->avail_metadata_alloc_bits &
>>>>> +             fs_info->metadata_alloc_profile);
>>>>> +    flags = BTRFS_BLOCK_GROUP_METADATA | alloc_profile;
>>>>> +    if (btrfs_fs_incompat(fs_info, MIXED_GROUPS))
>>>>> +        flags |= BTRFS_BLOCK_GROUP_DATA;
>>>>> +
>>>>> +    ret = create_chunk_and_block_group(fs_info, flags, &start,
>>>>> &nbytes);
>>>>
>>>> Why bother allocating a new chunk by yourself?
>>>>
>>>> Just mark all block groups full and that's all.
>>>>
>>>> Any later tree block allocation like btrfs_search_slot() with @cow = 1
>>>> will trigger chunk allocation automatically.
>>>>
>>>
>>> Tried to let it happen but BUG_ON with -ENOSPC.
>>
>> Then fix it.
>>
>> It's not a normal behavior in this case.
>>
>> Thanks,
>> Qu
> 
> And I think the fix to allow btrfs_reserve_extent() to allocate new
> chunk will solve a lot of strange BUG_ON().
> 
> it just occurred to me that, a lot of use cases relies on the assumption
> that btrfs_reserve_extent() will try to allocate new chunks.
> Yes, it has many dependency so I considered to do chunk allocation
manually in the patchset. If fix is not good enough, many funtions
of btrfs-progs will behave abnormal.
Since you ask it, I will go to fix it.

Thanks,
Su
> Especially for case like convert, certain btrfs check --repair, some
> rescue tools.
> 
> So this would be a quite nice start point for such fix.
> 
> Thanks,
> Qu
> 
>>
>>> Do you mean do_chunk_alloc() in btrfs_reserve_extent() which is called
>>> while doing CoW?> In progs, allocation of new chunk during CoW depends @root->ref_cows.
>>> However, @root->ref_cows should be set only if @root is root of a fs
>>> trees.
>>>
>>> Thanks,
>>> Su
>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>> +    if (!ret)
>>>>> +        printf("Create new chunk %llu %llu\n", start, nbytes);
>>>>> +    else
>>>>> +        goto err;
>>>>> +
>>>>> +    flags = BTRFS_BLOCK_GROUP_METADATA;
>>>>> +    /* Mark all metadata block groups cached and full in free space*/
>>>>> +    ret = modify_block_groups_cache(fs_info, flags, 1);
>>>>> +    if (ret)
>>>>> +        goto clear_bg_cache;
>>>>> +
>>>>> +    bg = btrfs_lookup_block_group(fs_info, start);
>>>>> +    if (!bg) {
>>>>> +        ret = -ENOENT;
>>>>> +        error("fail to look up block group %llu %llu", start, nbytes);
>>>>> +        goto clear_bg_cache;
>>>>> +    }
>>>>> +
>>>>> +    /* Clear block group cache just allocated */
>>>>> +    ret = modify_block_group_cache(fs_info, bg, 0);
>>>>> +    if (ret)
>>>>> +        goto clear_bg_cache;
>>>>> +
>>>>> +    return 0;
>>>>> +
>>>>> +clear_bg_cache:
>>>>> +    modify_block_groups_cache(fs_info, flags, 0);
>>>>> +err:
>>>>> +    return ret;
>>>>> +}
>>>>> +
>>>>>    static int check_extent_refs(struct btrfs_root *root,
>>>>>                     struct cache_tree *extent_cache)
>>>>>    {
>>>>>
>>>>
>>>
>>>
>>> -- 
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 


