Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:29884 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751486AbcF3Dc0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jun 2016 23:32:26 -0400
Subject: Re: [PATCH 1/2] btrfs: fix fsfreeze hang caused by delayed iputs deal
To: <fdmanana@gmail.com>
References: <20160629051510.17222-1-wangxg.fnst@cn.fujitsu.com>
 <CAL3q7H52eBXgm7rb=SQ9WovqhUcHVDSGZt39oMgvywBdB7PEdw@mail.gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Message-ID: <5774925E.6060106@cn.fujitsu.com>
Date: Thu, 30 Jun 2016 11:30:38 +0800
MIME-Version: 1.0
In-Reply-To: <CAL3q7H52eBXgm7rb=SQ9WovqhUcHVDSGZt39oMgvywBdB7PEdw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hello,

On 06/29/2016 07:16 PM, Filipe Manana wrote:
> On Wed, Jun 29, 2016 at 6:15 AM, Wang Xiaoguang
> <wangxg.fnst@cn.fujitsu.com> wrote:
>> When running fstests generic/068, sometimes we got below WARNING:
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
>>  From this warning, freeze_super() already holds SB_FREEZE_FS, but
>> btrfs_freeze() will call btrfs_commit_transaction() again, if
>> btrfs_commit_transaction() finds that it has delayed iputs to handle,
>> it'll start_transaction(), which will try to get SB_FREEZE_FS lock
>> again, then deadlock occurs.
>>
>> The root cause is that in btrfs, sync_filesystem(sb) does not make
>> sure all metadata is updated. See below race window in freeze_super():
>>          sync_filesystem(sb);
>>                  |
>>                  | race window
>>                  | In this period, cleaner_kthread() may be scheduled to
>>                  | run, and it call btrfs_delete_unused_bgs() which will
>>                  | add some delayed iputs.
>>                  |
>>          sb->s_writers.frozen = SB_FREEZE_FS;
>>          sb_wait_write(sb, SB_FREEZE_FS);
>>          if (sb->s_op->freeze_fs) {
>>                  /* freeze_fs will call btrfs_commit_transaction() */
>>                  ret = sb->s_op->freeze_fs(sb);
>>
> This pseudo diagram also doesn't well the problem.
> You should add two timelines for 2 different CPUs/tasks where we see
> one locking SB_FREEZE_FS and calling btrfs_freeze()
> while the task in the other CPU calls btrfs_commit_transaction(), runs
> delayed iputs and then starts/joins a transaction in the
> eviction handler.
OK, got it.

>
>
>
>> So if btrfs is doing freeze job, we should block
>> btrfs_delete_unused_bgs(), to avoid add delayed iputs.
> Nop, this isn't a real solution.
>
> You can have many other parts adding inodes to the delayed iputs list,
> not just btrfs_delete_unused_bgs() (doing it indirectly for the free
> space cache inodes).
> For example, when an ordered extent completes we add its inode to the
> delayed iputs list at btrfs_put_ordered_extent(), called through
> btrfs_finish_ordered_io().
Yes, I know. Before sending this patch, I had searched related codes which
call btrfs_add_delayed_iput(). I had thought sync_filesystem() in 
freeze_super()
would ensure that all other btrfs_add_delayed_iput()s are called before 
transaction
starts except the one in cleaner_kthread().

I also have one question, for compressed buffered write, even 
sync_filesystem()
returns, we can not ensure the data is written to disk, right? It seems that
btrfs_writepages() can return directly for compressed data, but with 
page still locked
and no WRITEBACK flag set, so later  filemap_fdatawait() won't work.
btrfs_fdatawrite_range() is used to resolve this issue, but it seems that
sync_filesystem() won't make btrfs_fdatawrite_range() called.

Also would you be OK with this solution:
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 948aa18..89a996c6 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2278,7 +2278,8 @@ int btrfs_commit_transaction(struct 
btrfs_trans_handle *trans,
         kmem_cache_free(btrfs_trans_handle_cachep, trans);

         if (current != root->fs_info->transaction_kthread &&
-           current != root->fs_info->cleaner_kthread)
+           current != root->fs_info->cleaner_kthread &&
+           root->fs_info->sb->s_writers.frozen != SB_FREEZE_FS)
                 btrfs_run_delayed_iputs(root);

         return ret;

Regards,
Xiaoguang Wang
>
> thanks
>
>
>
>> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
>> ---
>>   fs/btrfs/disk-io.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 863bf7a..fdbe0df 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -1846,8 +1846,11 @@ static int cleaner_kthread(void *arg)
>>                   * after acquiring fs_info->delete_unused_bgs_mutex. So we
>>                   * can't hold, nor need to, fs_info->cleaner_mutex when deleting
>>                   * unused block groups.
>> +                *
> Unneeded and unrelated change, please remove it.
>
>>                   */
>> +               __sb_start_write(root->fs_info->sb, SB_FREEZE_WRITE, true);
>>                  btrfs_delete_unused_bgs(root->fs_info);
>> +               __sb_end_write(root->fs_info->sb, SB_FREEZE_WRITE);
> A comment explaining why we do this would be valuable, since we never
> do these calls except when starting/committing transactions.
>
>>   sleep:
>>                  if (!again) {
>>                          set_current_state(TASK_INTERRUPTIBLE);
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



