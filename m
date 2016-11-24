Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:33013 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937225AbcKXLNj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Nov 2016 06:13:39 -0500
Received: by mail-io0-f195.google.com with SMTP id j92so4659294ioi.0
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Nov 2016 03:13:39 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20161123212210.GA24103@localhost.localdomain>
References: <1478287254-5458-1-git-send-email-bo.li.liu@oracle.com>
 <b600e06c-f946-853a-d868-eed429f9097b@profihost.ag> <20161123212210.GA24103@localhost.localdomain>
From: Filipe Manana <fdmanana@gmail.com>
Date: Thu, 24 Nov 2016 11:13:37 +0000
Message-ID: <CAL3q7H4T35BVRh73pSoE51UygQwPCzdNSVHR1U1jbRqyO0j-rQ@mail.gmail.com>
Subject: Re: resend: Re: Btrfs: adjust len of writes if following a
 preallocated extent
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>, Josef Bacik <jbacik@fb.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 23, 2016 at 9:22 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> Hi,
>
> On Wed, Nov 23, 2016 at 06:21:35PM +0100, Stefan Priebe - Profihost AG wrote:
>> Hi,
>>
>> sorry last mail was from the wrong box.
>>
>> Am 04.11.2016 um 20:20 schrieb Liu Bo:
>> > If we have
>> >
>> > |0--hole--4095||4096--preallocate--12287|
>> >
>> > instead of using preallocated space, a 8K direct write will just
>> > create a new 8K extent and it'll end up with
>> >
>> > |0--new extent--8191||8192--preallocate--12287|
>> >
>> > It's because we find a hole em and then go to create a new 8K
>> > extent directly without adjusting @len.
>>
>> after applying that one on top of my 4.4 btrfs branch (includes patches
>> up to 4.10 / next). i'm getting deadlocks in btrfs.
>
> This is really interesting, thanks for the quick testing.
>
> After going through the stacks listed below, I think the patch has
> exposed a bug around BTRFS_I(inode)->dio_sem:
>
> 1. Since fsync has acquired inode_lock(), the dio write must be
> an overwrite within EOF.
>
> 2. Lets say the inode size is 16k and it already has a preallocated extent [4k, 8k],
> then we feed it with a dio write against [0k, 8k], with this patch
> applied, the write can be splitted into a new extent of [0, 4k] and a
> fill-write against the preallocated one [4k, 8k],
>
> 3.
>         dio                                                           fsync
> ->btrfs_direct_IO                                                  btrfs_sync_file
>  ->do_direct_IO
>   ->get_more_blocks()                                                ->inode_lock()
>     ->btrfs_get_blocks_direct() # for [0, 8k]                        ->btrfs_log_inode()
>       ->btrfs_new_direct_extent()                                      ->btrfs_log_changed_extents()
>         ->btrfs_create_dio_extent()
>           ->down_read(&BTRFS_I(inode)->dio_sem)
>             # dio write is splitted and
>             # em of [0, 4k] is inserted as well as
>             # the ordered extent.
>           ->up_read(&BTRFS_I(inode)->dio_sem)
>    # do_direct_IO tries to collect more pages
>    # before sending them down, so [0, 4k] is not
>    # yet submitted.
> --------------------------------------------------------------------------------------------------------
>                                                                          ->down_write(&BTRFS_I(inode)->dio_sem)
>                                                                          # found ordered extent of [0, 4k]
>                                                                          # wait for [0, 4k] to finish
>   ->get_more_blocks()
>     ->btrfs_get_blocks_direct() # for [4k, 8k]
>       ->btrfs_create_dio_extent()
>         -> up_read(&BTRFS_I(inode)->dio_sem)
>            # deadlock occurs
>
> 4. _Without_ this patch, we could hit the deadlock as well under space pressure,
> i.e. if we request [0, 8k], but btrfs_reserve_extent() returns only [0, 4k].
>
> (Filipe may correct me, cc'd Filipe.)

The analysis is correct Bo.
Originally to fix races between fsync and direct IO writes there was a
solution [1, 2] that didn't involve adding a semaphore and relied on
creating first the ordered extents and then the extent maps only in
the direct IO write path (we do things in the reverse order everywhere
else). It worked and was documented in comments but wasn't
particularly elegant and Josef was not happy because of that, so then
we added the semaphore and made direct IO write path create the extent
maps and ordered extents in the same order as everywhere else [3].

So here I can only see 2 simple solutions. Either revert [3] (which
added the semaphore) or acquire the semaphore at a higher level in
direct IO write path like this:

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1f980ef..b2c277d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7237,7 +7237,6 @@ static struct extent_map
*btrfs_create_dio_extent(struct inode *inode,
        struct extent_map *em = NULL;
        int ret;

-       down_read(&BTRFS_I(inode)->dio_sem);
        if (type != BTRFS_ORDERED_NOCOW) {
                em = create_pinned_em(inode, start, len, orig_start,
                                      block_start, block_len, orig_block_len,
@@ -7256,8 +7255,6 @@ static struct extent_map
*btrfs_create_dio_extent(struct inode *inode,
                em = ERR_PTR(ret);
        }
  out:
-       up_read(&BTRFS_I(inode)->dio_sem);
-
        return em;
 }

@@ -8715,11 +8712,14 @@ static ssize_t btrfs_direct_IO(struct kiocb
*iocb, struct iov_iter *iter)
                wakeup = false;
        }

+       if (iov_iter_rw(iter) == WRITE)
+               down_read(&BTRFS_I(inode)->dio_sem);
        ret = __blockdev_direct_IO(iocb, inode,

BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev,
                                   iter, btrfs_get_blocks_direct, NULL,
                                   btrfs_submit_direct, flags);
        if (iov_iter_rw(iter) == WRITE) {
+               up_read(&BTRFS_I(inode)->dio_sem);
                current->journal_info = NULL;
                if (ret < 0 && ret != -EIOCBQUEUED) {
                        if (dio_data.reserve)


Let me know what you think. Thanks.

[1] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=de0ee0edb21fbab4c7afa3e94573ecfebfb0244e
[2] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=0b901916a00bc7b14ee83cc8e41c3b0d561a8f22
[3] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=5f9a8a51d8b95505d8de8b7191ae2ed8c504d4af


>
> Thanks,
>
> -liubo
>
>>
>> Traces here:
>> INFO: task btrfs-transacti:604 blocked for more than 120 seconds.
>>       Not tainted 4.4.34 #1
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> btrfs-transacti D ffff8814e78cbe00     0   604      2 0x00080000
>>  ffff8814e78cbe00 ffff88017367a540 ffff8814e2f88000 ffff8814e78cc000
>>  ffff8814e78cbe38 ffff88123616c510 ffff8814e24c81f0 ffff88153fb0a000
>>  ffff8814e78cbe18 ffffffff816a8425 ffff8814e63165a0 ffff8814e78cbe88
>> Call Trace:
>>  [<ffffffff816a8425>] schedule+0x35/0x80
>>  [<ffffffffc03751a5>] btrfs_commit_transaction+0x275/0xa50 [btrfs]
>>  [<ffffffffc036fdd6>] transaction_kthread+0x1d6/0x200 [btrfs]
>>  [<ffffffff810a0cbb>] kthread+0xdb/0x100
>>  [<ffffffff816ac84f>] ret_from_fork+0x3f/0x70
>> DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
>>
>> Leftover inexact backtrace:
>>
>>  [<ffffffff810a0be0>] ? kthread_park+0x60/0x60
>> INFO: task mysqld:1977 blocked for more than 120 seconds.
>>       Not tainted 4.4.34 #1
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> mysqld          D ffff88142ef1bcf8     0  1977      1 0x00080000
>>  ffff88142ef1bcf8 ffffffff81e0f500 ffff8814dc2c4a80 ffff88142ef1c000
>>  ffff8814e32ed298 ffff8814e32ed2c0 ffff88110aa9a000 ffff8814e32ed000
>>  ffff88142ef1bd10 ffffffff816a8425 ffff8814e32ed000 ffff88142ef1bd60
>> Call Trace:
>>  [<ffffffff816a8425>] schedule+0x35/0x80
>>  [<ffffffffc03b38a2>] wait_for_writer+0xa2/0xb0 [btrfs]
>>  [<ffffffffc03bb439>] btrfs_sync_log+0xe9/0xa00 [btrfs]
>>  [<ffffffffc038d1bf>] btrfs_sync_file+0x35f/0x3d0 [btrfs]
>>  [<ffffffff8120055d>] vfs_fsync_range+0x3d/0xb0
>>  [<ffffffff8120062d>] do_fsync+0x3d/0x70
>>  [<ffffffff812008a0>] SyS_fsync+0x10/0x20
>>  [<ffffffff816ac4ee>] entry_SYSCALL_64_fastpath+0x12/0x71
>> DWARF2 unwinder stuck at entry_SYSCALL_64_fastpath+0x12/0x71
>>
>> Leftover inexact backtrace:
>>
>> INFO: task mysqld:3249 blocked for more than 120 seconds.
>>       Not tainted 4.4.34 #1
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> mysqld          D ffff881475fdfa40     0  3249      1 0x00080000
>>  ffff881475fdfa40 ffff88017367ca80 ffff8814433d2540 ffff881475fe0000
>>  ffff88040da39ba0 0000000000230000 ffff88040da39c20 0000000000238000
>>  ffff881475fdfa58 ffffffff816a8425 0000000000008000 ffff881475fdfb18
>> Call Trace:
>>  [<ffffffff816a8425>] schedule+0x35/0x80
>>  [<ffffffffc03b4cb7>]
>> wait_ordered_extents.isra.18.constprop.23+0x147/0x3d0 [btrfs]
>>  [<ffffffffc03b5182>] btrfs_log_changed_extents+0x242/0x610 [btrfs]
>>  [<ffffffffc03ba6a4>] btrfs_log_inode+0x874/0xb80 [btrfs]
>>  [<ffffffffc03bac6c>] btrfs_log_inode_parent+0x22c/0x910 [btrfs]
>>  [<ffffffffc03bc292>] btrfs_log_dentry_safe+0x62/0x80 [btrfs]
>>  [<ffffffffc038d0ec>] btrfs_sync_file+0x28c/0x3d0 [btrfs]
>>  [<ffffffff8120055d>] vfs_fsync_range+0x3d/0xb0
>>  [<ffffffff8120062d>] do_fsync+0x3d/0x70
>>  [<ffffffff812008a0>] SyS_fsync+0x10/0x20
>>  [<ffffffff816ac4ee>] entry_SYSCALL_64_fastpath+0x12/0x71
>> DWARF2 unwinder stuck at entry_SYSCALL_64_fastpath+0x12/0x71
>>
>> Leftover inexact backtrace:
>>
>> INFO: task mysqld:3250 blocked for more than 120 seconds.
>>       Not tainted 4.4.34 #1
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> mysqld          D ffff881374edb868     0  3250      1 0x00080000
>>  ffff881374edb868 ffff8801736b2540 ffff8814433d4a80 ffff881374edc000
>>  ffff8814e26f81c8 ffff8814e26f81e0 0000000000238000 00000000000a8000
>>  ffff881374edb880 ffffffff816a8425 ffff8814433d4a80 ffff881374edb8d8
>> Call Trace:
>>  [<ffffffff816a8425>] schedule+0x35/0x80
>>  [<ffffffff816aaffd>] rwsem_down_read_failed+0xed/0x130
>>  [<ffffffff813ce404>] call_rwsem_down_read_failed+0x14/0x30
>> DWARF2 unwinder stuck at call_rwsem_down_read_failed+0x14/0x30
>>
>> Leftover inexact backtrace:
>>
>>  [<ffffffff816aa5a7>] ? down_read+0x17/0x20
>>  [<ffffffffc0376cc6>] btrfs_create_dio_extent+0x46/0x1e0 [btrfs]
>>  [<ffffffffc0386a68>] btrfs_get_blocks_direct+0x3d8/0x730 [btrfs]
>>  [<ffffffffc0378b2e>] ? btrfs_submit_direct+0x1ce/0x740 [btrfs]
>>  [<ffffffff8120b2c7>] do_blockdev_direct_IO+0x11f7/0x2bc0
>>  [<ffffffffc0386690>] ? btrfs_page_exists_in_range+0xe0/0xe0 [btrfs]
>>  [<ffffffffc0378960>] ? btrfs_getattr+0xa0/0xa0 [btrfs]
>>  [<ffffffff8120ccd3>] __blockdev_direct_IO+0x43/0x50
>>  [<ffffffffc0378960>] ? btrfs_getattr+0xa0/0xa0 [btrfs]
>>  [<ffffffffc0377e11>] btrfs_direct_IO+0x1d1/0x380 [btrfs]
>>  [<ffffffffc0378960>] ? btrfs_getattr+0xa0/0xa0 [btrfs]
>>  [<ffffffff8115656a>] generic_file_direct_write+0xaa/0x170
>>  [<ffffffffc038d4de>] btrfs_file_write_iter+0x2ae/0x560 [btrfs]
>>  [<ffffffff810f73c1>] ? futex_wake+0x81/0x150
>>  [<ffffffff811cedd4>] new_sync_write+0x84/0xb0
>>  [<ffffffff811cee26>] __vfs_write+0x26/0x40
>>  [<ffffffff811cf419>] vfs_write+0xa9/0x190
>>  [<ffffffff810026af>] ? enter_from_user_mode+0x1f/0x50
>>  [<ffffffff811d027b>] SyS_pwrite64+0x6b/0xa0
>>  [<ffffffff81002b20>] ? syscall_return_slowpath+0xb0/0x130
>>  [<ffffffff816ac4ee>] entry_SYSCALL_64_fastpath+0x12/0x71
>> INFO: task btrfs-transacti:604 blocked for more than 120 seconds.
>>       Not tainted 4.4.34 #1
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> btrfs-transacti D ffff8814e78cbe00     0   604      2 0x00080000
>>  ffff8814e78cbe00 ffff88017367a540 ffff8814e2f88000 ffff8814e78cc000
>>  ffff8814e78cbe38 ffff88123616c510 ffff8814e24c81f0 ffff88153fb0a000
>>  ffff8814e78cbe18 ffffffff816a8425 ffff8814e63165a0 ffff8814e78cbe88
>> Call Trace:
>>  [<ffffffff816a8425>] schedule+0x35/0x80
>>  [<ffffffffc03751a5>] btrfs_commit_transaction+0x275/0xa50 [btrfs]
>>  [<ffffffffc036fdd6>] transaction_kthread+0x1d6/0x200 [btrfs]
>>  [<ffffffff810a0cbb>] kthread+0xdb/0x100
>>  [<ffffffff816ac84f>] ret_from_fork+0x3f/0x70
>> DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
>>
>> Leftover inexact backtrace:
>>
>>  [<ffffffff810a0be0>] ? kthread_park+0x60/0x60
>> INFO: task mysqld:1977 blocked for more than 120 seconds.
>>       Not tainted 4.4.34 #1
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> mysqld          D ffff88142ef1bcf8     0  1977      1 0x00080000
>>  ffff88142ef1bcf8 ffffffff81e0f500 ffff8814dc2c4a80 ffff88142ef1c000
>>  ffff8814e32ed298 ffff8814e32ed2c0 ffff88110aa9a000 ffff8814e32ed000
>>  ffff88142ef1bd10 ffffffff816a8425 ffff8814e32ed000 ffff88142ef1bd60
>> Call Trace:
>>  [<ffffffff816a8425>] schedule+0x35/0x80
>>  [<ffffffffc03b38a2>] wait_for_writer+0xa2/0xb0 [btrfs]
>>  [<ffffffffc03bb439>] btrfs_sync_log+0xe9/0xa00 [btrfs]
>>  [<ffffffffc038d1bf>] btrfs_sync_file+0x35f/0x3d0 [btrfs]
>>  [<ffffffff8120055d>] vfs_fsync_range+0x3d/0xb0
>>  [<ffffffff8120062d>] do_fsync+0x3d/0x70
>>  [<ffffffff812008a0>] SyS_fsync+0x10/0x20
>>  [<ffffffff816ac4ee>] entry_SYSCALL_64_fastpath+0x12/0x71
>> DWARF2 unwinder stuck at entry_SYSCALL_64_fastpath+0x12/0x71
>>
>> Leftover inexact backtrace:
>>
>> INFO: task mysqld:3249 blocked for more than 120 seconds.
>>       Not tainted 4.4.34 #1
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> mysqld          D ffff881475fdfa40     0  3249      1 0x00080000
>>  ffff881475fdfa40 ffff88017367ca80 ffff8814433d2540 ffff881475fe0000
>>  ffff88040da39ba0 0000000000230000 ffff88040da39c20 0000000000238000
>>  ffff881475fdfa58 ffffffff816a8425 0000000000008000 ffff881475fdfb18
>> Call Trace:
>>  [<ffffffff816a8425>] schedule+0x35/0x80
>>  [<ffffffffc03b4cb7>]
>> wait_ordered_extents.isra.18.constprop.23+0x147/0x3d0 [btrfs]
>>  [<ffffffffc03b5182>] btrfs_log_changed_extents+0x242/0x610 [btrfs]
>>  [<ffffffffc03ba6a4>] btrfs_log_inode+0x874/0xb80 [btrfs]
>>  [<ffffffffc03bac6c>] btrfs_log_inode_parent+0x22c/0x910 [btrfs]
>>  [<ffffffffc03bc292>] btrfs_log_dentry_safe+0x62/0x80 [btrfs]
>>  [<ffffffffc038d0ec>] btrfs_sync_file+0x28c/0x3d0 [btrfs]
>>  [<ffffffff8120055d>] vfs_fsync_range+0x3d/0xb0
>>  [<ffffffff8120062d>] do_fsync+0x3d/0x70
>>  [<ffffffff812008a0>] SyS_fsync+0x10/0x20
>>  [<ffffffff816ac4ee>] entry_SYSCALL_64_fastpath+0x12/0x71
>> DWARF2 unwinder stuck at entry_SYSCALL_64_fastpath+0x12/0x71
>>
>> Leftover inexact backtrace:
>>
>> INFO: task mysqld:3250 blocked for more than 120 seconds.
>>       Not tainted 4.4.34 #1
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> mysqld          D ffff881374edb868     0  3250      1 0x00080000
>>  ffff881374edb868 ffff8801736b2540 ffff8814433d4a80 ffff881374edc000
>>  ffff8814e26f81c8 ffff8814e26f81e0 0000000000238000 00000000000a8000
>>  ffff881374edb880 ffffffff816a8425 ffff8814433d4a80 ffff881374edb8d8
>> Call Trace:
>>  [<ffffffff816a8425>] schedule+0x35/0x80
>>  [<ffffffff816aaffd>] rwsem_down_read_failed+0xed/0x130
>>  [<ffffffff813ce404>] call_rwsem_down_read_failed+0x14/0x30
>> DWARF2 unwinder stuck at call_rwsem_down_read_failed+0x14/0x30
>>
>> Leftover inexact backtrace:
>>
>>  [<ffffffff816aa5a7>] ? down_read+0x17/0x20
>>  [<ffffffffc0376cc6>] btrfs_create_dio_extent+0x46/0x1e0 [btrfs]
>>  [<ffffffffc0386a68>] btrfs_get_blocks_direct+0x3d8/0x730 [btrfs]
>>  [<ffffffffc0378b2e>] ? btrfs_submit_direct+0x1ce/0x740 [btrfs]
>>  [<ffffffff8120b2c7>] do_blockdev_direct_IO+0x11f7/0x2bc0
>>  [<ffffffffc0386690>] ? btrfs_page_exists_in_range+0xe0/0xe0 [btrfs]
>>  [<ffffffffc0378960>] ? btrfs_getattr+0xa0/0xa0 [btrfs]
>>  [<ffffffff8120ccd3>] __blockdev_direct_IO+0x43/0x50
>>  [<ffffffffc0378960>] ? btrfs_getattr+0xa0/0xa0 [btrfs]
>>  [<ffffffffc0377e11>] btrfs_direct_IO+0x1d1/0x380 [btrfs]
>>  [<ffffffffc0378960>] ? btrfs_getattr+0xa0/0xa0 [btrfs]
>>  [<ffffffff8115656a>] generic_file_direct_write+0xaa/0x170
>>  [<ffffffffc038d4de>] btrfs_file_write_iter+0x2ae/0x560 [btrfs]
>>  [<ffffffff810f73c1>] ? futex_wake+0x81/0x150
>>  [<ffffffff811cedd4>] new_sync_write+0x84/0xb0
>>  [<ffffffff811cee26>] __vfs_write+0x26/0x40
>>  [<ffffffff811cf419>] vfs_write+0xa9/0x190
>>  [<ffffffff810026af>] ? enter_from_user_mode+0x1f/0x50
>>  [<ffffffff811d027b>] SyS_pwrite64+0x6b/0xa0
>>  [<ffffffff81002b20>] ? syscall_return_slowpath+0xb0/0x130
>>  [<ffffffff816ac4ee>] entry_SYSCALL_64_fastpath+0x12/0x71
>> INFO: task btrfs-transacti:604 blocked for more than 120 seconds.
>>       Not tainted 4.4.34 #1
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> btrfs-transacti D ffff8814e78cbe00     0   604      2 0x00080000
>>  ffff8814e78cbe00 ffff88017367a540 ffff8814e2f88000 ffff8814e78cc000
>>  ffff8814e78cbe38 ffff88123616c510 ffff8814e24c81f0 ffff88153fb0a000
>>  ffff8814e78cbe18 ffffffff816a8425 ffff8814e63165a0 ffff8814e78cbe88
>> Call Trace:
>>  [<ffffffff816a8425>] schedule+0x35/0x80
>>  [<ffffffffc03751a5>] btrfs_commit_transaction+0x275/0xa50 [btrfs]
>>  [<ffffffffc036fdd6>] transaction_kthread+0x1d6/0x200 [btrfs]
>>  [<ffffffff810a0cbb>] kthread+0xdb/0x100
>>  [<ffffffff816ac84f>] ret_from_fork+0x3f/0x70
>> DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
>>
>> Leftover inexact backtrace:
>>
>>  [<ffffffff810a0be0>] ? kthread_park+0x60/0x60
>> INFO: task mysqld:1977 blocked for more than 120 seconds.
>>       Not tainted 4.4.34 #1
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> mysqld          D ffff88142ef1bcf8     0  1977      1 0x00080000
>>  ffff88142ef1bcf8 ffffffff81e0f500 ffff8814dc2c4a80 ffff88142ef1c000
>>  ffff8814e32ed298 ffff8814e32ed2c0 ffff88110aa9a000 ffff8814e32ed000
>>  ffff88142ef1bd10 ffffffff816a8425 ffff8814e32ed000 ffff88142ef1bd60
>> Call Trace:
>>  [<ffffffff816a8425>] schedule+0x35/0x80
>>  [<ffffffffc03b38a2>] wait_for_writer+0xa2/0xb0 [btrfs]
>>  [<ffffffffc03bb439>] btrfs_sync_log+0xe9/0xa00 [btrfs]
>>  [<ffffffffc038d1bf>] btrfs_sync_file+0x35f/0x3d0 [btrfs]
>>  [<ffffffff8120055d>] vfs_fsync_range+0x3d/0xb0
>>  [<ffffffff8120062d>] do_fsync+0x3d/0x70
>>  [<ffffffff812008a0>] SyS_fsync+0x10/0x20
>>  [<ffffffff816ac4ee>] entry_SYSCALL_64_fastpath+0x12/0x71
>> DWARF2 unwinder stuck at entry_SYSCALL_64_fastpath+0x12/0x71
>>
>> Leftover inexact backtrace:
>>
>> Greets,
>> Stefan
>>
>> >
>> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
>> > Reviewed-by: Chris Mason <clm@fb.com>
>> > ---
>> >  fs/btrfs/inode.c | 8 +++++---
>> >  1 file changed, 5 insertions(+), 3 deletions(-)
>> >
>> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> > index 2b790bd..48e9356 100644
>> > --- a/fs/btrfs/inode.c
>> > +++ b/fs/btrfs/inode.c
>> > @@ -7783,10 +7783,12 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
>> >     }
>> >
>> >     /*
>> > -    * this will cow the extent, reset the len in case we changed
>> > -    * it above
>> > +    * this will cow the extent, if em is within [start, len], then
>> > +    * probably we've found a preallocated/existing extent, let's
>> > +    * give it a chance to use preallocated space.
>> >      */
>> > -   len = bh_result->b_size;
>> > +   len = min_t(u64, bh_result->b_size, em->len - (start - em->start));
>> > +   len = ALIGN(len, root->sectorsize);
>> >     free_extent_map(em);
>> >     em = btrfs_new_extent_direct(inode, start, len);
>> >     if (IS_ERR(em)) {
>> >



-- 
Filipe David Manana,

"People will forget what you said,
 people will forget what you did,
 but people will never forget how you made them feel."
