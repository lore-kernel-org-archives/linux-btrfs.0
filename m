Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48337 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753321AbeFTFem (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 01:34:42 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8DDE3ABC7
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jun 2018 05:34:41 +0000 (UTC)
Subject: Re: [PATCH v3] btrfs: Don't remove block group still has pinned down
 bytes
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20180615013523.2807-1-wqu@suse.com>
 <2ec3bf9b-cc0f-a027-b17c-04b3b237be88@suse.com>
From: Qu Wenruo <wqu@suse.de>
Message-ID: <9d6d1fc0-84d6-170c-8789-7fe7b5168483@suse.de>
Date: Wed, 20 Jun 2018 13:34:38 +0800
MIME-Version: 1.0
In-Reply-To: <2ec3bf9b-cc0f-a027-b17c-04b3b237be88@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年06月20日 13:25, Nikolay Borisov wrote:
> 
> 
> On 15.06.2018 04:35, Qu Wenruo wrote:
>> [BUG]
>> Under certain KVM load and LTP tests, we are possible to hit the
>> following calltrace if quota is enabled:
>> ------
>> BTRFS critical (device vda2): unable to find logical 8820195328 length 4096
>> BTRFS critical (device vda2): unable to find logical 8820195328 length 4096
>> ------------[ cut here ]------------
>> WARNING: CPU: 0 PID: 49 at ../block/blk-core.c:172 blk_status_to_errno+0x1a/0x30
>> CPU: 0 PID: 49 Comm: kworker/u2:1 Not tainted 4.12.14-15-default #1 SLE15 (unreleased)
>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
>> Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
>> task: ffff9f827b340bc0 task.stack: ffffb4f8c0304000
>> RIP: 0010:blk_status_to_errno+0x1a/0x30
>> Call Trace:
>>  submit_extent_page+0x191/0x270 [btrfs]
>>  ? btrfs_create_repair_bio+0x130/0x130 [btrfs]
>>  __do_readpage+0x2d2/0x810 [btrfs]
>>  ? btrfs_create_repair_bio+0x130/0x130 [btrfs]
>>  ? run_one_async_done+0xc0/0xc0 [btrfs]
>>  __extent_read_full_page+0xe7/0x100 [btrfs]
>>  ? run_one_async_done+0xc0/0xc0 [btrfs]
>>  read_extent_buffer_pages+0x1ab/0x2d0 [btrfs]
>>  ? run_one_async_done+0xc0/0xc0 [btrfs]
>>  btree_read_extent_buffer_pages+0x94/0xf0 [btrfs]
>>  read_tree_block+0x31/0x60 [btrfs]
>>  read_block_for_search.isra.35+0xf0/0x2e0 [btrfs]
>>  btrfs_search_slot+0x46b/0xa00 [btrfs]
>>  ? kmem_cache_alloc+0x1a8/0x510
>>  ? btrfs_get_token_32+0x5b/0x120 [btrfs]
>>  find_parent_nodes+0x11d/0xeb0 [btrfs]
>>  ? leaf_space_used+0xb8/0xd0 [btrfs]
>>  ? btrfs_leaf_free_space+0x49/0x90 [btrfs]
>>  ? btrfs_find_all_roots_safe+0x93/0x100 [btrfs]
>>  btrfs_find_all_roots_safe+0x93/0x100 [btrfs]
>>  btrfs_find_all_roots+0x45/0x60 [btrfs]
>>  btrfs_qgroup_trace_extent_post+0x20/0x40 [btrfs]
>>  btrfs_add_delayed_data_ref+0x1a3/0x1d0 [btrfs]
>>  btrfs_alloc_reserved_file_extent+0x38/0x40 [btrfs]
>>  insert_reserved_file_extent.constprop.71+0x289/0x2e0 [btrfs]
>>  btrfs_finish_ordered_io+0x2f4/0x7f0 [btrfs]
>>  ? pick_next_task_fair+0x2cd/0x530
>>  ? __switch_to+0x92/0x4b0
>>  btrfs_worker_helper+0x81/0x300 [btrfs]
>>  process_one_work+0x1da/0x3f0
>>  worker_thread+0x2b/0x3f0
>>  ? process_one_work+0x3f0/0x3f0
>>  kthread+0x11a/0x130
>>  ? kthread_create_on_node+0x40/0x40
>>  ret_from_fork+0x35/0x40
>> Code: 00 00 5b c3 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 40 80 ff 0c 40 0f b6 c7 77 0b 48 c1 e0 04 8b 80 00 bf c8 bd c3 <0f> 0b b8 fb ff ff ff c3 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00
>> ---[ end trace f079fb809e7a862b ]---
>> BTRFS critical (device vda2): unable to find logical 8820195328 length 16384
>> BTRFS: error (device vda2) in btrfs_finish_ordered_io:3023: errno=-5 IO failure
>> BTRFS info (device vda2): forced readonly
>> BTRFS error (device vda2): pending csums is 2887680
>> ------
>>
>> [CAUSE]
>> It's caused by race with block group auto removal like the following
>> case:
>> - There is a meta block group X, which has only one tree block
>>   The tree block belongs to fs tree 257.
>> - In current transaction, some operation modified fs tree 257
>>   The tree block get CoWed, so the block group X is empty, and marked as
>>   unused, queued to be deleted.
>> - Some workload (like fsync) wakes up cleaner_kthread()
>>   Which will call btrfs_deleted_unused_bgs() to remove unused block
>>   groups.
>>   So block group X along its chunk map get removed.
>> - Some delalloc work finished for fs tree 257
>>   Quota needs to get the original reference of the extent, which will
>>   reads tree blocks of commit root of 257.
>>   Then since the chunk map get removed, above warning get triggered.
>>
>> [FIX]
>> Just teach btrfs_delete_unused_bgs() to skip block group who still has
>> pinned bytes.
>>
>> However there is a minor side effect, since currently we only queue
>> empty blocks at update_block_group(), and such empty block group with
>> pinned bytes won't go through update_block_group() again, such block
>> group won't be removed, until it get new extent allocated and removed.
>>
>> But please note that, there are more problems related to extent
>> allocator with block group auto removal.
>>
>> Even a block group is marked unused, extent allocator can still allocate
>> new extents from unused block group.
>> Thus delaying block group to next transaction won't work.
>> (Extents get allocated in current transaction, and removed again in next
>> transaction).
> 
> Isn't this easily solvable by making the allocator check whether the
> block group it has chosen is part of the unused_bgs_list ?

That's also my initial idea, however bg_cache->bg_list can also be used
in trans->new_bgs.

Another factor is, even we check the block group of an extent in
find_free_extent() and skip the allocation, we can lead to more frequent
false ENOSPC.

The correct way to do it is to allow find_free_extent() to skip block
group which is in unused_bgs_list (maybe needs extra bit to indicate
this), if we have other block group to use.
Or we still need to use that unused block group, and remove it from
unused_bgs_list to avoid ENOSPC and unneeded new block group creation.

(BTW, there is a bug that find_free_extent() checked block_group->list
wrongly)

That's the main reason sending out such small fix, as the perfect fix
may be much complex than my expectation.

Thanks,
Qu

> 
>>
>> So the root fix need to co-operate with extent allocator.
>> But current fix should be enough for this particular bug.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
> 
> LGTM,
> 
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> 
>> ---
>> changelog:
>> v2:
>>   Commit message update, to better indicate how pinned byte is used in
>>   btrfs and why it's related to quota.
>> v3:
>>   Commit message update, further explaining the bug with an example.
>>   And added the side effect of the fix, and possible further fix.
>> ---
>>  fs/btrfs/extent-tree.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index f190023386a9..7d14c4ca8232 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -10675,7 +10675,7 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
>>  		/* Don't want to race with allocators so take the groups_sem */
>>  		down_write(&space_info->groups_sem);
>>  		spin_lock(&block_group->lock);
>> -		if (block_group->reserved ||
>> +		if (block_group->reserved || block_group->pinned ||
>>  		    btrfs_block_group_used(&block_group->item) ||
>>  		    block_group->ro ||
>>  		    list_is_singular(&block_group->list)) {
>>
