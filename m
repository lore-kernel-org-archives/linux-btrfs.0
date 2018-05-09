Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:47813 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933715AbeEIIgb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 May 2018 04:36:31 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Wed, 09 May 2018 16:36:29 +0800
From: robbieko <robbieko@synology.com>
To: fdmanana@gmail.com
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-btrfs-owner@vger.kernel.org
Subject: Re: [PATCH] btrfs: incremental send, fix BUG when parent commit_root
 changed
In-Reply-To: <CAL3q7H7gnDdxPF8Grn0J8vXRGfpCDto_eNmaUQ6akonmEf_idg@mail.gmail.com>
References: <1525767358-3625-1-git-send-email-robbieko@synology.com>
 <CAL3q7H7kjKhdGBpntjJ4aHi4na6oFyH6mzhRHHw9d=Xzatremg@mail.gmail.com>
 <a4ded87a7636521c25e6453bc8d36f1e@synology.com>
 <CAL3q7H5eE7Dv2GCOQCZqG4kGZETiXTKOdnMBZXNittp1NcXmtg@mail.gmail.com>
 <bd8ca0719d5e9aa6dce8bea371533225@synology.com>
 <CAL3q7H7gnDdxPF8Grn0J8vXRGfpCDto_eNmaUQ6akonmEf_idg@mail.gmail.com>
Message-ID: <9431a6574bbf4df48728cb254ba602cf@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Filipe Manana,

Ok. I will add all this information, in detail, to the changelog,
and than send a patch V2 later.

Thanks.
Robbie Ko

Filipe Manana 於 2018-05-09 16:29 寫到:
> On Wed, May 9, 2018 at 2:10 AM, robbieko <robbieko@synology.com> wrote:
>> Filipe Manana 於 2018-05-08 19:12 寫到:
>>> 
>>> On Tue, May 8, 2018 at 11:30 AM, robbieko <robbieko@synology.com> 
>>> wrote:
>>>> 
>>>> Hi Filipe Manana,
>>>> 
>>>> Although the snapshot is readonly, when the snapshot is created,
>>>> in order to modify the last_snapshot, it will cause generation 
>>>> changes,
>>>> and it will affect the commit_root modification.
>>> 
>>> 
>>> So what you to say is that the problem happens when creating a
>>> snapshot of snapshot that is being used by send.
>>> You don't mention that anywhere, except in the example below.
>>> 
>>> Just say that in the changelog, that the problem can happen if while
>>> we are doing a send one of the snapshots used (parent or send) is
>>> snapshotted, because snapshoting implies COWing the root of the 
>>> source
>>> subvolume/snaphot.
>>> That is not mentioned anywhere in the changelog.
>> 
>> 
>> OK, I will add this information to changelog.
>> 
>> 
>>> 
>>> Now, why does this happen without your patch?
>>> Before we use the commit roots, we call extent_buffer_get() on them 
>>> to
>>> make sure they are not released and we do that while holding the
>>> semaphore commit_root_sem. Why isn't this enough to prevent
>>> use-after-free problems?
>>> 
>> 
>> Although we use extent_buffer_get to prevent the extent_buffer
>> from being released, because of the snapshoting implies COWing
>> the root, the commit_root original space (A) is released.
>> Therefore, when other process need alloc the new tree block,
>> it may use the space of A.
>> However, alloc_extent_buffer is created by the bytenr.
>> It will first find out if there is an existing extent_buffer through
>> find_extent_buffer and cause the original extent_buffer to be 
>> modified.
>> Eventually causing send process to access illegal memory.
>> Thus extent_buffer_get can only prevent extent_buffer from being 
>> released,
>> but it cannot prevent extent_buffer from being used by others.
>> 
>> btrfs_alloc_tree_block
>> --btrfs_reserve_extent (get A bytenr)
>> --btrfs_init_new_buffer (use A bytenr)
>> ----btrfs_find_create_tree_block
>> ------alloc_extent_buffer
>> --------find_extent_buffer (get A)
>> 
>> So we fixed the problem by copy commit_root to avoid accessing illegal
>> memory
> 
> Here it should be mentioned as well how the space gets released
> despite the fact that the extent buffer has references.
> I.e. that __btrfs_cow_block() calls btrfs_free_tree_block().
> 
> Please add all this information, in detail, to the changelog.
> The changelog you provided had no useful information at all - didn't
> mention how the problem can happen nor why.
> 
> thanks
> 
>> 
>> 
>> 
>>> That should be explained as well in the changelog.
>>> 
>>> Those are the 2 pieces of information you need to put in the 
>>> changelog.
>>> 
>>>> 
>>>> Example:
>>>> #btrfs sub show snap1
>>>>         Name:                   snap1
>>>>         UUID:                   17ba3140-b79d-1649-a2e1-b238c3253a40
>>>>         Parent UUID:    6fe90a14-02f3-1b40-bdfc-be435060d023
>>>>         Received UUID:  17ba3140-b79d-1649-a2e1-b238c3253a40
>>>>         Creation time:  2018-04-27 18:04:11 +0800
>>>>         Subvolume ID:   514
>>>>         Generation:             4854
>>>>         Gen at creation:        506
>>>>         Parent ID:              511
>>>>         Top level ID:   511
>>>>         Flags:                  readonly
>>>>         Snapshot(s):
>>>> 
>>>> #btrfs-debug-tree -t 514 /dev/md2 | more
>>>> btrfs-progs v4.0
>>>> file tree key (514 ROOT_ITEM 506)
>>>> node 259127066624 level 2 items 192 free 301 generation 4854 owner 
>>>> 514
>>>> fs uuid 081b4c28-007c-430b-be7f-ead57aa71548
>>>> chunk uuid a48e7346-bd15-4eac-8957-b11a2bf9bbe2
>>>>         key (256 INODE_ITEM 0) block 258707652608 (15790262) gen 505
>>>> 
>>>> #btrfs sub snap send_snap1 test_subvol
>>>> #btrfs-debug-tree -t 514 /dev/md2 | more
>>>> btrfs-progs v4.0
>>>> file tree key (514 ROOT_ITEM 506)
>>>> node 258444509184 level 2 items 192 free 301 generation 4881 owner 
>>>> 514
>>>> fs uuid 081b4c28-007c-430b-be7f-ead57aa71548
>>>> chunk uuid a48e7346-bd15-4eac-8957-b11a2bf9bbe2
>>>>         key (256 INODE_ITEM 0) block 258707652608 (15790262) gen 505
>>>> 
>>>> According to the above example node and generation will be updated.
>>>> 
>>>> This means that as long as the send or parent snapshot is taken 
>>>> during
>>>> the btrfs send, commit_root will change, and send process may access
>>>> invalid memory.
>>>> 
>>>> Thanks.
>>>> Robbie Ko
>>>> 
>>>> 
>>>> Filipe Manana 於 2018-05-08 17:15 寫到:
>>>>> 
>>>>> 
>>>>> On Tue, May 8, 2018 at 9:15 AM, robbieko <robbieko@synology.com> 
>>>>> wrote:
>>>>> 
>>>>>> From: Robbie Ko <robbieko@synology.com>
>>>>>> 
>>>>>> [BUG]
>>>>>> btrfs send BUG on parent commit_root node receive destination
>>>>>> is at the same volume.
>>>>> 
>>>>> 
>>>>> 
>>>>> I can't make sense of that sentence.
>>>>> 
>>>>>> 
>>>>>> [Example]
>>>>>> btrfs send -e -p /mnt/snap1/ /mnt/snap2/ | btrfs receive -e 
>>>>>> /mnt/temp
>>>>> 
>>>>> 
>>>>> 
>>>>> So, is -e necessary?
>>>>> So doing that, for any parent and send snapshots, triggers the bug?
>>>>> (and regardless of -e)
>>>>> If that was enough I'm pretty sure almost everyone would be 
>>>>> reporting
>>>>> send/receive as unusable.
>>>>> Please clarify.
>>>>> 
>>>>>> 
>>>>>> [REASON]
>>>>>> 1. When send with the parent, the send process will get the parent
>>>>>>    commit_root(A), then send commit_root(B) and then compare the
>>>>>>    tree between A and B.
>>>>>> 2. The receive process will take snapshot from parent, then the 
>>>>>> parent
>>>>>>    commit_root changes from A to C, so A will be released.
>>>>> 
>>>>> 
>>>>> 
>>>>> I don't understand this. How can the commit_root change?
>>>>> The snapshot is readonly, it's can't be modified after it's 
>>>>> created.
>>>>> 
>>>>>> 3. Then A will be assigned to other leaf nodes.
>>>>>> 4. Therefore, the send process will use invalid A, resulting in
>>>>>>    invalid memory access.
>>>>>> 
>>>>>> [FIX]
>>>>>> We create new root and copy from parent/send commit_root to
>>>>>> avoid invalid memory access.
>>>>>> 
>>>>>> CallTrace looks like this:
>>>>>>  ------------[ cut here ]------------
>>>>>>  kernel BUG at fs/btrfs/ctree.c:1861!
>>>>>>  invalid opcode: 0000 [#1] SMP
>>>>>>  CPU: 6 PID: 24235 Comm: btrfs Tainted: P           O 3.10.105 
>>>>>> #23721
>>>>> 
>>>>> 
>>>>> 
>>>>> 3.10 kernel....
>>>>> You should reproduce any bugs you find on more recent kernels...
>>>>> 
>>>>>>  ffff88046652d680 ti: ffff88041b720000 task.ti: ffff88041b720000
>>>>>>  RIP: 0010:[<ffffffffa08dd0e8>] read_node_slot+0x108/0x110 [btrfs]
>>>>>>  RSP: 0018:ffff88041b723b68  EFLAGS: 00010246
>>>>>>  RAX: ffff88043ca6b000 RBX: ffff88041b723c50 RCX: ffff880000000000
>>>>>>  RDX: 000000000000004c RSI: ffff880314b133f8 RDI: ffff880458b24000
>>>>>>  RBP: 0000000000000000 R08: 0000000000000001 R09: ffff88041b723c66
>>>>>>  R10: 0000000000000001 R11: 0000000000001000 R12: ffff8803f3e48890
>>>>>>  R13: ffff8803f3e48880 R14: ffff880466351800 R15: 0000000000000001
>>>>>>  FS:  00007f8c321dc8c0(0000) GS:ffff88047fcc0000(0000)
>>>>>>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>>>>  R2: 00007efd1006d000 CR3: 0000000213a24000 CR4: 00000000003407e0
>>>>>>  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>>>>>  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>>>>>  Stack:
>>>>>>  ffff88041b723c50 ffff8803f3e48880 ffff8803f3e48890 
>>>>>> ffff8803f3e48880
>>>>>>  ffff880466351800 0000000000000001 ffffffffa08dd9d7 
>>>>>> ffff88041b723c50
>>>>>>  ffff8803f3e48880 ffff88041b723c66 ffffffffa08dde85 
>>>>>> a9ff88042d2c4400
>>>>>>  Call Trace:
>>>>>>  [<ffffffffa08dd9d7>] ? tree_move_down.isra.33+0x27/0x50 [btrfs]
>>>>>>  [<ffffffffa08dde85>] ? tree_advance+0xb5/0xc0 [btrfs]
>>>>>>  [<ffffffffa08e83d4>] ? btrfs_compare_trees+0x2d4/0x760 [btrfs]
>>>>>>  [<ffffffffa0982050>] ? finish_inode_if_needed+0x870/0x870 [btrfs]
>>>>>>  [<ffffffffa09841ea>] ? btrfs_ioctl_send+0xeda/0x1050 [btrfs]
>>>>>>  [<ffffffffa094bd3d>] ? btrfs_ioctl+0x1e3d/0x33f0 [btrfs]
>>>>>>  [<ffffffff81111133>] ? handle_pte_fault+0x373/0x990
>>>>>>  [<ffffffff8153a096>] ? atomic_notifier_call_chain+0x16/0x20
>>>>>>  [<ffffffff81063256>] ? set_task_cpu+0xb6/0x1d0
>>>>>>  [<ffffffff811122c3>] ? handle_mm_fault+0x143/0x2a0
>>>>>>  [<ffffffff81539cc0>] ? __do_page_fault+0x1d0/0x500
>>>>>>  [<ffffffff81062f07>] ? check_preempt_curr+0x57/0x90
>>>>>>  [<ffffffff8115075a>] ? do_vfs_ioctl+0x4aa/0x990
>>>>>>  [<ffffffff81034f83>] ? do_fork+0x113/0x3b0
>>>>>>  [<ffffffff812dd7d7>] ? trace_hardirqs_off_thunk+0x3a/0x6c
>>>>>>  [<ffffffff81150cc8>] ? SyS_ioctl+0x88/0xa0
>>>>>>  [<ffffffff8153e422>] ? system_call_fastpath+0x16/0x1b
>>>>>>  ---[ end trace 29576629ee80b2e1 ]---
>>>>>> 
>>>>>> Signed-off-by: Robbie Ko <robbieko@synology.com>
>>>>>> ---
>>>>>>  fs/btrfs/ctree.c | 26 ++++++++++++++++++++++++--
>>>>>>  1 file changed, 24 insertions(+), 2 deletions(-)
>>>>>> 
>>>>>> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
>>>>>> index b88a79e..c9ce52f 100644
>>>>>> --- a/fs/btrfs/ctree.c
>>>>>> +++ b/fs/btrfs/ctree.c
>>>>>> @@ -5398,6 +5398,8 @@ int btrfs_compare_trees(struct btrfs_root
>>>>>> *left_root,
>>>>>>         u64 right_blockptr;
>>>>>>         u64 left_gen;
>>>>>>         u64 right_gen;
>>>>>> +       struct extent_buffer *left_root_node = NULL;
>>>>>> +       struct extent_buffer *right_root_node = NULL;
>>>>>> 
>>>>>>         left_path = btrfs_alloc_path();
>>>>>>         if (!left_path) {
>>>>>> @@ -5416,6 +5418,20 @@ int btrfs_compare_trees(struct btrfs_root
>>>>>> *left_root,
>>>>>>                 goto out;
>>>>>>         }
>>>>>> 
>>>>>> +       left_root_node = 
>>>>>> alloc_dummy_extent_buffer(left_root->fs_info,
>>>>>> 0);
>>>>>> +       if (!left_root_node) {
>>>>>> +               ret = -ENOMEM;
>>>>>> +               goto out;
>>>>>> +       }
>>>>>> +       extent_buffer_get(left_root_node);
>>>>>> +
>>>>>> +       right_root_node = 
>>>>>> alloc_dummy_extent_buffer(left_root->fs_info,
>>>>>> 0);
>>>>>> +       if (!right_root_node) {
>>>>>> +               ret = -ENOMEM;
>>>>>> +               goto out;
>>>>>> +       }
>>>>>> +       extent_buffer_get(right_root_node);
>>>>>> +
>>>>>>         left_path->search_commit_root = 1;
>>>>>>         left_path->skip_locking = 1;
>>>>>>         right_path->search_commit_root = 1;
>>>>>> @@ -5460,12 +5476,16 @@ int btrfs_compare_trees(struct btrfs_root
>>>>>> *left_root,
>>>>>>         down_read(&fs_info->commit_root_sem);
>>>>>>         left_level = btrfs_header_level(left_root->commit_root);
>>>>>>         left_root_level = left_level;
>>>>>> -       left_path->nodes[left_level] = left_root->commit_root;
>>>>>> +       copy_extent_buffer_full(left_root_node,
>>>>>> left_root->commit_root);
>>>>>> +       set_bit(EXTENT_BUFFER_UPTODATE, &left_root_node->bflags);
>>>>>> +       left_path->nodes[left_level] = left_root_node;
>>>>>>         extent_buffer_get(left_path->nodes[left_level]);
>>>>>> 
>>>>>>         right_level = btrfs_header_level(right_root->commit_root);
>>>>>>         right_root_level = right_level;
>>>>>> -       right_path->nodes[right_level] = right_root->commit_root;
>>>>>> +       copy_extent_buffer_full(right_root_node,
>>>>>> right_root->commit_root);
>>>>>> +       set_bit(EXTENT_BUFFER_UPTODATE, &right_root_node->bflags);
>>>>>> +       right_path->nodes[right_level] = right_root_node;
>>>>>>         extent_buffer_get(right_path->nodes[right_level]);
>>>>>>         up_read(&fs_info->commit_root_sem);
>>>>>> 
>>>>>> @@ -5613,6 +5633,8 @@ int btrfs_compare_trees(struct btrfs_root
>>>>>> *left_root,
>>>>>>  out:
>>>>>>         btrfs_free_path(left_path);
>>>>>>         btrfs_free_path(right_path);
>>>>>> +       free_extent_buffer(left_root_node);
>>>>>> +       free_extent_buffer(right_root_node);
>>>>>>         kvfree(tmp_buf);
>>>>>>         return ret;
>>>>>>  }
>>>>>> --
>>>>>> 1.9.1
>>>>>> 
>>>>>> --
>>>>>> To unsubscribe from this list: send the line "unsubscribe 
>>>>>> linux-btrfs"
>>>>>> in
>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>> 
>>>> 
>>>> 
>> 

