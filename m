Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43393 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755241AbcG1K6C (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jul 2016 06:58:02 -0400
Subject: Re: [PATCH v3] btrfs: fix fsfreeze hang caused by delayed iputs deal
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <20160728024315.20527-1-wangxg.fnst@cn.fujitsu.com>
 <20160728102247.GQ30795@twin.jikos.cz>
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Message-ID: <5799E486.6060707@cn.fujitsu.com>
Date: Thu, 28 Jul 2016 18:55:02 +0800
MIME-Version: 1.0
In-Reply-To: <20160728102247.GQ30795@twin.jikos.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hello,

On 07/28/2016 06:22 PM, David Sterba wrote:
> On Thu, Jul 28, 2016 at 10:43:15AM +0800, Wang Xiaoguang wrote:
>> When running fstests generic/068, sometimes we got below deadlock:
>>    xfs_io          D ffff8800331dbb20     0  6697   6693 0x00000080
>>    ffff8800331dbb20 ffff88007acfc140 ffff880034d895c0 ffff8800331dc000
>>    ffff880032d243e8 fffffffeffffffff ffff880032d24400 0000000000000001
>>    ffff8800331dbb38 ffffffff816a9045 ffff880034d895c0 ffff8800331dbba8
>>    Call Trace:
>>    [<ffffffff816a9045>] schedule+0x35/0x80
>>    [<ffffffff816abab2>] rwsem_down_read_failed+0xf2/0x140
>>    [<ffffffff8118f5e1>] ? __filemap_fdatawrite_range+0xd1/0x100
>>    [<ffffffff8134f978>] call_rwsem_down_read_failed+0x18/0x30
>>    [<ffffffffa06631fc>] ? btrfs_alloc_block_rsv+0x2c/0xb0 [btrfs]
>>    [<ffffffff810d32b5>] percpu_down_read+0x35/0x50
>>    [<ffffffff81217dfc>] __sb_start_write+0x2c/0x40
>>    [<ffffffffa067f5d5>] start_transaction+0x2a5/0x4d0 [btrfs]
>>    [<ffffffffa067f857>] btrfs_join_transaction+0x17/0x20 [btrfs]
>>    [<ffffffffa068ba34>] btrfs_evict_inode+0x3c4/0x5d0 [btrfs]
>>    [<ffffffff81230a1a>] evict+0xba/0x1a0
>>    [<ffffffff812316b6>] iput+0x196/0x200
>>    [<ffffffffa06851d0>] btrfs_run_delayed_iputs+0x70/0xc0 [btrfs]
>>    [<ffffffffa067f1d8>] btrfs_commit_transaction+0x928/0xa80 [btrfs]
>>    [<ffffffffa0646df0>] btrfs_freeze+0x30/0x40 [btrfs]
>>    [<ffffffff81218040>] freeze_super+0xf0/0x190
>>    [<ffffffff81229275>] do_vfs_ioctl+0x4a5/0x5c0
>>    [<ffffffff81003176>] ? do_audit_syscall_entry+0x66/0x70
>>    [<ffffffff810038cf>] ? syscall_trace_enter_phase1+0x11f/0x140
>>    [<ffffffff81229409>] SyS_ioctl+0x79/0x90
>>    [<ffffffff81003c12>] do_syscall_64+0x62/0x110
>>    [<ffffffff816acbe1>] entry_SYSCALL64_slow_path+0x25/0x25
>>
>> >From this warning, freeze_super() already holds SB_FREEZE_FS, but
>> btrfs_freeze() will call btrfs_commit_transaction() again, if
>> btrfs_commit_transaction() finds that it has delayed iputs to handle,
>> it'll start_transaction(), which will try to get SB_FREEZE_FS lock
>> again, then deadlock occurs.
>>
>> The root cause is that in btrfs, sync_filesystem(sb) does not make
>> sure all metadata is updated. There still maybe some codes adding
>> delayed iputs, see below sample race window:
>>
>>           CPU1                                  |         CPU2
>> |-> freeze_super()                             |
>>      |-> sync_filesystem(sb);                   |
>>      |                                          |-> cleaner_kthread()
>>      |                                          |   |-> btrfs_delete_unused_bgs()
>>      |                                          |       |-> btrfs_remove_chunk()
>>      |                                          |           |-> btrfs_remove_block_group()
>>      |                                          |               |-> btrfs_add_delayed_iput()
>>      |                                          |
>>      |-> sb->s_writers.frozen = SB_FREEZE_FS;   |
>>      |-> sb_wait_write(sb, SB_FREEZE_FS);       |
>>      |   acquire SB_FREEZE_FS lock.             |
>>      |                                          |
>>      |-> btrfs_freeze()                         |
>>          |-> btrfs_commit_transaction()         |
>>              |-> btrfs_run_delayed_iputs()      |
>>              |   will handle delayed iputs,     |
>>              |   that means start_transaction() |
>>              |   will be called, which will try |
>>              |   to get SB_FREEZE_FS lock.      |
>>
>> To fix this issue, introduce a atomic_t fs_frozen to record internally whether
>> fs has been frozen. If fs has been frozen, we can not handle delayed iputs.
>>
>> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
>> ---
>> v3: we introduce a atomic_t fs_frozen, and if fs_frozen is 1, we can not
>>      handle delayed iputs.
>> ---
>>   fs/btrfs/ctree.h       |  2 ++
>>   fs/btrfs/disk-io.c     |  1 +
>>   fs/btrfs/super.c       | 10 ++++++++++
>>   fs/btrfs/transaction.c |  7 ++++++-
>>   4 files changed, 19 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>> index 90041a2..9dddaa0 100644
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -1091,6 +1091,8 @@ struct btrfs_fs_info {
>>   	struct list_head pinned_chunks;
>>   
>>   	int creating_free_space_tree;
>> +	/* Use this atomic to record internally whether fs has been frozen */
>> +	atomic_t fs_frozen;
>>   };
>>   
>>   struct btrfs_subvolume_writers {
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 86cad9a..1b85f55 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -2621,6 +2621,7 @@ int open_ctree(struct super_block *sb,
>>   	atomic_set(&fs_info->qgroup_op_seq, 0);
>>   	atomic_set(&fs_info->reada_works_cnt, 0);
>>   	atomic64_set(&fs_info->tree_mod_seq, 0);
>> +	atomic_set(&fs_info->fs_frozen, 0);
>>   	fs_info->sb = sb;
>>   	fs_info->max_inline = BTRFS_DEFAULT_MAX_INLINE;
>>   	fs_info->metadata_ratio = 0;
>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>> index 60e7179..c417008 100644
>> --- a/fs/btrfs/super.c
>> +++ b/fs/btrfs/super.c
>> @@ -2216,6 +2216,7 @@ static int btrfs_freeze(struct super_block *sb)
>>   	struct btrfs_trans_handle *trans;
>>   	struct btrfs_root *root = btrfs_sb(sb)->tree_root;
>>   
>> +	atomic_set(&root->fs_info->fs_frozen, 1);
>>   	trans = btrfs_attach_transaction_barrier(root);
>>   	if (IS_ERR(trans)) {
>>   		/* no transaction, don't bother */
> If there's a transaction, we'll call commit a few lines below. With the
> frozen status set to 1, the delayed iputs will be skipped
>
>> index 948aa18..3187356 100644
>> --- a/fs/btrfs/transaction.c
>> +++ b/fs/btrfs/transaction.c
>> @@ -2277,8 +2277,13 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
>>   
>>   	kmem_cache_free(btrfs_trans_handle_cachep, trans);
>>   
>> +	/*
>> +	 * If fs has been frozen, we can not handle delayed iputs, otherwise
>> +	 * it'll result in deadlock about SB_FREEZE_FS.
>> +	 */
>>   	if (current != root->fs_info->transaction_kthread &&
>> -	    current != root->fs_info->cleaner_kthread)
>> +	    current != root->fs_info->cleaner_kthread &&
>> +	    !atomic_read(&root->fs_info->fs_frozen))
>>   		btrfs_run_delayed_iputs(root);
> here. Is that intentional?
Yes. btrfs_run_delayed_iputs() will start new transaction, but if fs is 
frozen,
we can not do that. In start_transaction(), it'll call 
sb_start_intwrite() trying to
get SB_FREEZE_FS lock, but SB_FREEZE_FS has been locked by fsfreeze.

>
> Also, the use of atomic (probably) works, but just relies on the locked
> semantics of the updates although there are no inc/dec operations. An
> equivalent would be a bare int with barriers.
Yes, I think a bare int would be enough. Because there are many locks
between "fs_frozen = 1" and 
"btrfs_commit_transaction()->btrfs_run_delayed_iputs".
Though I don't have much knowledge about memory barriers :)

>
> Next, I'm not sure if the freeze/thaw could be called multiple times.
> Ie. with this patch, if I call freeze twice and thaw once, the
> filesystem's frozen status would be 'normal', although the frozen status
> as seen by vfs would be 'frozen'. I haven't looked if the vfs magic does
> not prevent that completely though.
The first "sudo fsfreeze -f mntpoint" would succeed, but a second
"sudo fsfreeze -f mntpoint" would report:
     fsfreeze: mntpoint: freeze failed: Device or resource busy

int freeze_super(struct super_block *sb)
{
     int ret;

     atomic_inc(&sb->s_active);
     down_write(&sb->s_umount);
     if (sb->s_writers.frozen != SB_UNFROZEN) {
         deactivate_locked_super(sb);
         return -EBUSY;
     }
     ...
}
 From above codes, we can see that if fs has been frozen,
we can not freeze it anymore.

Regards,
Xiaoguang Wang
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>



