Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33965 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751370AbeA2Nou (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Jan 2018 08:44:50 -0500
Subject: Re: [PATCH v2] btrfs: Gracefully handle errors in
 btrfs_qgroup_trace_extent_post
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <1517211848-13324-1-git-send-email-nborisov@suse.com>
 <67d1afde-c6f7-ea41-d9d4-35c5d0a1c136@gmx.com>
 <0aace605-1267-2b4d-d15a-167f4e7946f2@suse.com>
 <4031fa1b-4839-d496-b015-0cd75a04084b@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <2ac60946-3fc7-21e9-ef9b-c70d6fb89cfa@suse.com>
Date: Mon, 29 Jan 2018 15:44:47 +0200
MIME-Version: 1.0
In-Reply-To: <4031fa1b-4839-d496-b015-0cd75a04084b@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 29.01.2018 13:57, Qu Wenruo wrote:
> 
> 
> On 2018年01月29日 19:21, Nikolay Borisov wrote:
>>
>>
>> On 29.01.2018 13:09, Qu Wenruo wrote:
>>>
>>>
>>> On 2018年01月29日 15:44, Nikolay Borisov wrote:
>>>> Running generic/019 with qgroups on the scratch device enabled is
>>>> almost guaranteed to trigger the BUG_ON in btrfs_free_tree_block. It's
>>>> supposed to trigger only on -ENOMEM, in reality, however, it's possible
>>>> to get -EIO from btrfs_qgroup_trace_extent_post. This function just
>>>> finds the roots of the extent being tracked and sets the qrecord->old_roots
>>>> list. If this operation fails nothing critical happens except the
>>>> quota accounting can be considered wrong. In such case just set the
>>>> INCONSISTENT flag for the quota and print a warning.
>>>>
>>>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>>>> ---
>>>>
>>>> V2: 
>>>>  * Always print a warning if btrfs_qgroup_trace_extent_post fails 
>>>>  * Set quota inconsistent flag if btrfs_qgroup_trace_extent_post fails
>>>>
>>>>  fs/btrfs/delayed-ref.c | 7 +++++--
>>>>  fs/btrfs/qgroup.c      | 6 ++++--
>>>>  2 files changed, 9 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
>>>> index a1a40cf382e3..5b2789a28a13 100644
>>>> --- a/fs/btrfs/delayed-ref.c
>>>> +++ b/fs/btrfs/delayed-ref.c
>>>> @@ -820,8 +820,11 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
>>>>  			     num_bytes, parent, ref_root, level, action);
>>>>  	spin_unlock(&delayed_refs->lock);
>>>>  
>>>> -	if (qrecord_inserted)
>>>> -		return btrfs_qgroup_trace_extent_post(fs_info, record);
>>>> +	if (qrecord_inserted) {
>>>> +		int ret = btrfs_qgroup_trace_extent_post(fs_info, record);
>>>> +		if (ret < 0)
>>>> +			btrfs_warn(fs_info, "Error accounting new delayed refs extent (err code: %d). Quota inconsistent", ret);
>>>
>>> Sorry that I didn't point it out in previous review, there are 2 callers
>>> in delayed-ref.c using btrfs_qgroup_trace_extent_post().
>>>
>>> One is the one you're fixing, and the other one is
>>> btrfs_add_delayed_data_ref().
>>
>> Yes, but the callers of btrfs_add_delayed_data_ref seem to be expecting
>> error values and actually handling them.
> 
> Not exactly.
> 
> A quick search leads to extra unhandled btrfs_add_delayed_data_ref().
> 
> walk_down_proc()
> |- btrfs_dec_ref()
>    |- __btrfs_mod_ref()
>       |- btrfs_free_extent()
>          |- btrfs_add_delayed_data_ref()
>             |- btrfs_qgroup_trace_extent_post()
> 
> And this leads to another BUG_ON().
> 


And I just hit : 

[ 4289.716628] ------------[ cut here ]------------
[ 4289.716631] kernel BUG at fs/btrfs/inode.c:4661!
[ 4289.716872] invalid opcode: 0000 [#1] SMP KASAN PTI
[ 4289.717029] Modules linked in:
[ 4289.717158] CPU: 5 PID: 2815 Comm: btrfs-cleaner Tainted: G    B   W        4.15.0-rc9-nbor #421
[ 4289.717408] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
[ 4289.717680] RIP: 0010:btrfs_truncate_inode_items+0x1016/0x1e00
[ 4289.717850] RSP: 0018:ffff8801047d7ae0 EFLAGS: 00010282
[ 4289.718009] RAX: 00000000fffffffb RBX: 000000000000006c RCX: ffff8800ad0faf00
[ 4289.718197] RDX: ffffed00208faf3f RSI: 0000000000000001 RDI: 0000000000000246
[ 4289.718381] RBP: ffff88002fcd7840 R08: 0000000000000406 R09: 00000000001c3000
[ 4289.718565] R10: ffff8801047d7410 R11: 1ffff100208fae58 R12: dffffc0000000000
[ 4289.718748] R13: ffff8800adb42000 R14: 00000000001c3000 R15: ffff8800b7eaa700
[ 4289.718932] FS:  0000000000000000(0000) GS:ffff88010ef40000(0000) knlGS:0000000000000000
[ 4289.719161] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4289.719364] CR2: 00007f5b2bb86008 CR3: 000000006ea40000 CR4: 00000000000006a0
[ 4289.719574] Call Trace:
[ 4289.719700]  ? btrfs_rmdir+0x610/0x610
[ 4289.719839]  ? _raw_spin_unlock+0x24/0x30
[ 4289.719983]  ? join_transaction+0x268/0xce0
[ 4289.720139]  ? start_transaction+0x193/0xf00
[ 4289.720378]  ? btrfs_block_rsv_refill+0x9e/0xb0
[ 4289.720628]  btrfs_evict_inode+0xb89/0x1070
[ 4289.720808]  ? btrfs_setattr+0x750/0x750
[ 4289.720949]  evict+0x20f/0x570
[ 4289.721075]  btrfs_run_delayed_iputs+0x122/0x220
[ 4289.721248]  ? mutex_trylock+0x152/0x1b0
[ 4289.721387]  cleaner_kthread+0x2e5/0x400
[ 4289.721527]  ? btrfs_destroy_pinned_extent+0x140/0x140
[ 4289.721680]  ? btrfs_destroy_pinned_extent+0x140/0x140
[ 4289.721835]  ? btrfs_destroy_pinned_extent+0x140/0x140
[ 4289.721989]  kthread+0x2d4/0x3d0
[ 4289.722115]  ? kthread_create_on_node+0xb0/0xb0
[ 4289.722258]  ret_from_fork+0x3a/0x50
[ 4289.722390] Code: eb 8b 9c 24 e0 00 00 00 48 8b ac 24 d8 00 00 00 65 ff 0d 3e 63 4e 7e e9 9d fc ff ff 48 8b 7c 24 40 e8 df c5 0e 00 e9 bc f2 ff ff <0f> 0b 48 8b 7c 24 78 e8 1e b6 96 ff e9 7d f3 ff ff e8 14 b6 96 
[ 4289.722850] RIP: btrfs_truncate_inode_items+0x1016/0x1e00 RSP: ffff8801047d7ae0
[ 4289.723101] ---[ end trace bb97e3f06308a096 ]---

Which is: 

 ret = btrfs_free_extent(trans, root, extent_start,      
                                                extent_num_bytes, 0,            
                                                btrfs_header_owner(leaf),       
                                                ino, extent_offset);            
                        BUG_ON(ret);               


so I guess you are right :) V3 pending ... 

>> So a failure doesn't
>> necessarily mean the fs is in inconsistent state.
> 
> But at the cost of aborting current transaction.
> 
>>
>>>
>>> So it would be even better if the warning message can be integrated into
>>> btrfs_qgroup_trace_extent_post().
>>
>> See below why I don't think integrating the warning is a good idea. In
>> the case being modified in this patch we will continue operating
>> normally, hence the warning and INCONSISTENT flag make sense.
>>
>>>
>>> Also btrfs_qgroup_trace_extent_post() also needs to ignore the return
>>> value from btrfs_qgroup_trace_extent_post().
>>
>> I don't think so, if we are able to handle failures as is the case in
>> the delayed_data_ref case then we might abort the current transaction
>> and this should leave the fs in a consistent state.
> 
> Here comes the trade-off.
> 
> Keep the on-disk data consistent while abort current transaction and
> make fs read-only.
> 
> VS
> 
> Make the fs continue running while just discard the qgroup data.
> 
> 
> Although the truth is, either way we may eventually goes
> abort_transaction() since we failed to read some tree blocks.
> 
> But since there are still some BUG_ON() wondering around the wild, the
> latter one seems a little better.
> 
>> In that case even
>> the "STATUS_FLAG_INCONSISTENT" being set in qgroup_trace_extent_post
>> might be "wrong" in the sense that a failure from this function doesn't
>> necessarily make the quota inconsistent if upper layers can handle the
>> failures and revert their work.
> 
> Well, most of them just abort the transaction and leads to above trade-off.
> 
> Unfortunately, there is not much thing we can do in error handler. :(
> 
> Thanks,
> Qu
> 
>> So I'm now starting to think that the
>> inconsistent flag should be set in add_delayed_tree_ref, but this sort
>> of leaks the qgroup implementation detail into the delayed tree ref
>> function...
>>>
>>> Thanks,
>>> Qu
>>>
>>>> +	}
>>>>  	return 0;
>>>>  
>>>>  free_head_ref:
>>>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>>>> index b2ab5f795816..33f9dba44e92 100644
>>>> --- a/fs/btrfs/qgroup.c
>>>> +++ b/fs/btrfs/qgroup.c
>>>> @@ -1440,8 +1440,10 @@ int btrfs_qgroup_trace_extent_post(struct btrfs_fs_info *fs_info,
>>>>  	int ret;
>>>>  
>>>>  	ret = btrfs_find_all_roots(NULL, fs_info, bytenr, 0, &old_root, false);
>>>> -	if (ret < 0)
>>>> +	if (ret < 0) {
>>>> +		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
>>>>  		return ret;
>>>> +	}
>>>>  
>>>>  	/*
>>>>  	 * Here we don't need to get the lock of
>>>> @@ -2933,7 +2935,7 @@ static int __btrfs_qgroup_release_data(struct inode *inode,
>>>>  	if (free && reserved)
>>>>  		return qgroup_free_reserved_data(inode, reserved, start, len);
>>>>  	extent_changeset_init(&changeset);
>>>> -	ret = clear_record_extent_bits(&BTRFS_I(inode)->io_tree, start, 
>>>> +	ret = clear_record_extent_bits(&BTRFS_I(inode)->io_tree, start,
>>>>  			start + len -1, EXTENT_QGROUP_RESERVED, &changeset);
>>>>  	if (ret < 0)
>>>>  		goto out;
>>>>
>>>
> 
