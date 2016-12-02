Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:35255 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759485AbcLBMZW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Dec 2016 07:25:22 -0500
Received: by mail-io0-f195.google.com with SMTP id h133so8174373ioe.2
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Dec 2016 04:25:22 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20161202014111.GA11558@dhcp-whq-twvpn-2-vpnpool-10-159-164-218.vpn.oracle.com>
References: <1478287254-5458-1-git-send-email-bo.li.liu@oracle.com>
 <b600e06c-f946-853a-d868-eed429f9097b@profihost.ag> <20161123212210.GA24103@localhost.localdomain>
 <CAL3q7H4T35BVRh73pSoE51UygQwPCzdNSVHR1U1jbRqyO0j-rQ@mail.gmail.com> <20161202014111.GA11558@dhcp-whq-twvpn-2-vpnpool-10-159-164-218.vpn.oracle.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Fri, 2 Dec 2016 12:25:19 +0000
Message-ID: <CAL3q7H4_KhCpjtfQguNW41EsKFzj=+hRVOixi4ppbOgsVDggKw@mail.gmail.com>
Subject: Re: resend: Re: Btrfs: adjust len of writes if following a
 preallocated extent
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>, Josef Bacik <jbacik@fb.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 2, 2016 at 1:41 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> On Thu, Nov 24, 2016 at 11:13:37AM +0000, Filipe Manana wrote:
>> On Wed, Nov 23, 2016 at 9:22 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
>> > Hi,
>> >
>> > On Wed, Nov 23, 2016 at 06:21:35PM +0100, Stefan Priebe - Profihost AG wrote:
>> >> Hi,
>> >>
>> >> sorry last mail was from the wrong box.
>> >>
>> >> Am 04.11.2016 um 20:20 schrieb Liu Bo:
>> >> > If we have
>> >> >
>> >> > |0--hole--4095||4096--preallocate--12287|
>> >> >
>> >> > instead of using preallocated space, a 8K direct write will just
>> >> > create a new 8K extent and it'll end up with
>> >> >
>> >> > |0--new extent--8191||8192--preallocate--12287|
>> >> >
>> >> > It's because we find a hole em and then go to create a new 8K
>> >> > extent directly without adjusting @len.
>> >>
>> >> after applying that one on top of my 4.4 btrfs branch (includes patches
>> >> up to 4.10 / next). i'm getting deadlocks in btrfs.
>> >
>> > This is really interesting, thanks for the quick testing.
>> >
>> > After going through the stacks listed below, I think the patch has
>> > exposed a bug around BTRFS_I(inode)->dio_sem:
>> >
>> > 1. Since fsync has acquired inode_lock(), the dio write must be
>> > an overwrite within EOF.
>> >
>> > 2. Lets say the inode size is 16k and it already has a preallocated extent [4k, 8k],
>> > then we feed it with a dio write against [0k, 8k], with this patch
>> > applied, the write can be splitted into a new extent of [0, 4k] and a
>> > fill-write against the preallocated one [4k, 8k],
>> >
>> > 3.
>> >         dio                                                           fsync
>> > ->btrfs_direct_IO                                                  btrfs_sync_file
>> >  ->do_direct_IO
>> >   ->get_more_blocks()                                                ->inode_lock()
>> >     ->btrfs_get_blocks_direct() # for [0, 8k]                        ->btrfs_log_inode()
>> >       ->btrfs_new_direct_extent()                                      ->btrfs_log_changed_extents()
>> >         ->btrfs_create_dio_extent()
>> >           ->down_read(&BTRFS_I(inode)->dio_sem)
>> >             # dio write is splitted and
>> >             # em of [0, 4k] is inserted as well as
>> >             # the ordered extent.
>> >           ->up_read(&BTRFS_I(inode)->dio_sem)
>> >    # do_direct_IO tries to collect more pages
>> >    # before sending them down, so [0, 4k] is not
>> >    # yet submitted.
>> > --------------------------------------------------------------------------------------------------------
>> >                                                                          ->down_write(&BTRFS_I(inode)->dio_sem)
>> >                                                                          # found ordered extent of [0, 4k]
>> >                                                                          # wait for [0, 4k] to finish
>> >   ->get_more_blocks()
>> >     ->btrfs_get_blocks_direct() # for [4k, 8k]
>> >       ->btrfs_create_dio_extent()
>> >         -> up_read(&BTRFS_I(inode)->dio_sem)
>> >            # deadlock occurs
>> >
>> > 4. _Without_ this patch, we could hit the deadlock as well under space pressure,
>> > i.e. if we request [0, 8k], but btrfs_reserve_extent() returns only [0, 4k].
>> >
>> > (Filipe may correct me, cc'd Filipe.)
>>
>> The analysis is correct Bo.
>> Originally to fix races between fsync and direct IO writes there was a
>> solution [1, 2] that didn't involve adding a semaphore and relied on
>> creating first the ordered extents and then the extent maps only in
>> the direct IO write path (we do things in the reverse order everywhere
>> else). It worked and was documented in comments but wasn't
>> particularly elegant and Josef was not happy because of that, so then
>> we added the semaphore and made direct IO write path create the extent
>> maps and ordered extents in the same order as everywhere else [3].
>>
>> So here I can only see 2 simple solutions. Either revert [3] (which
>> added the semaphore) or acquire the semaphore at a higher level in
>> direct IO write path like this:
>>
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index 1f980ef..b2c277d 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -7237,7 +7237,6 @@ static struct extent_map
>> *btrfs_create_dio_extent(struct inode *inode,
>>         struct extent_map *em = NULL;
>>         int ret;
>>
>> -       down_read(&BTRFS_I(inode)->dio_sem);
>>         if (type != BTRFS_ORDERED_NOCOW) {
>>                 em = create_pinned_em(inode, start, len, orig_start,
>>                                       block_start, block_len, orig_block_len,
>> @@ -7256,8 +7255,6 @@ static struct extent_map
>> *btrfs_create_dio_extent(struct inode *inode,
>>                 em = ERR_PTR(ret);
>>         }
>>   out:
>> -       up_read(&BTRFS_I(inode)->dio_sem);
>> -
>>         return em;
>>  }
>>
>> @@ -8715,11 +8712,14 @@ static ssize_t btrfs_direct_IO(struct kiocb
>> *iocb, struct iov_iter *iter)
>>                 wakeup = false;
>>         }
>>
>> +       if (iov_iter_rw(iter) == WRITE)
>> +               down_read(&BTRFS_I(inode)->dio_sem);
>>         ret = __blockdev_direct_IO(iocb, inode,
>>
>> BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev,
>>                                    iter, btrfs_get_blocks_direct, NULL,
>>                                    btrfs_submit_direct, flags);
>>         if (iov_iter_rw(iter) == WRITE) {
>> +               up_read(&BTRFS_I(inode)->dio_sem);
>>                 current->journal_info = NULL;
>>                 if (ret < 0 && ret != -EIOCBQUEUED) {
>>                         if (dio_data.reserve)
>>
>>
>> Let me know what you think. Thanks.
>
> Hi Filipe,
>
> After going over again fs/direct-io.c, the AIO dio_complete is diffrent from the
> 'Note that' part in your patch [1], what am I missing?
>
> -------------------------------------------------------------------------
> static ssize_t dio_complete(struct dio *dio, ssize_t ret, bool is_async)
> {
>         ...
>         if (!(dio->flags & DIO_SKIP_DIO_COUNT))
>                 inode_dio_end(dio->inode);
>
>         if (is_async) {
>                 /*
>                  * generic_write_sync expects ki_pos to have been updated
>                  * already, but the submission path only does this for
>                  * synchronous I/O.
>                  */
>                 dio->iocb->ki_pos += transferred;
>
>                 if (dio->op == REQ_OP_WRITE)
>                         ret = generic_write_sync(dio->iocb,  transferred);
>                 dio->iocb->ki_complete(dio->iocb, ret, 0);
>         }
>         ...
> }

It's still the same as when I checked. The problem is that even after
that call to inode_dio_end(), the inode->i_dio_count() is still
non-zero (it's 1 iirc).
I don't have any longer the debugging patch I used to find out that
out (nor remember all the details), but I just tried again the
approach of calling inode_dio_wait() in btrfs_sync_file() after
locking the inode:

https://friendpaste.com/pRwJkgsFXv6HglftK1BqH

And the same deadlock ends up happening, which is trivial to reproduce
with fstest generic/113:

[ 2593.870593] run fstests generic/113 at 2016-12-02 11:19:39
[ 2594.308402] BTRFS info (device sdb): disk space caching is enabled
[ 2594.309654] BTRFS info (device sdb): has skinny extents
[ 2595.460142] BTRFS info (device sdb): disk space caching is enabled
[ 2595.461161] BTRFS info (device sdb): has skinny extents
[ 2597.011706] BTRFS info (device sdb): disk space caching is enabled
[ 2597.012918] BTRFS info (device sdb): has skinny extents
[ 2605.098582] BTRFS info (device sdb): disk space caching is enabled
[ 2605.099324] BTRFS info (device sdb): has skinny extents
[ 2677.131447] systemd-journald[571]: Sent WATCHDOG=1 notification.
[ 2727.133247] systemd-journald[571]: Sent WATCHDOG=1 notification.
[ 2782.176191] INFO: task aio-stress:17143 blocked for more than 120 seconds.
[ 2782.177659]       Not tainted 4.8.0-rc8-btrfs-next-35+ #1
[ 2782.178722] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2782.180484] aio-stress      D ffff8800b30c7a98     0 17143  16641 0x00000000
[ 2782.181652]  ffff8800b30c7a98 0000000000000282 00ff8800b30c7a50
ffff88023f3175c0
[ 2782.183042]  ffff8802156b1680 ffff8800b60fc280 ffff8800b30c8000
ffff8800b60fc280
[ 2782.184586]  fffffffe00000001 ffff8800b60fc280 ffff8800b1e8e4e0
ffff8800b30c7ab0
[ 2782.186266] Call Trace:
[ 2782.186884]  [<ffffffff814b514b>] schedule+0x8b/0xa3
[ 2782.187965]  [<ffffffff81098982>]
__rwsem_down_write_failed_common+0x340/0x401
[ 2782.190039]  [<ffffffff814b81e1>] rwsem_down_write_failed+0x13/0x15
[ 2782.191195]  [<ffffffff814b81e1>] ? rwsem_down_write_failed+0x13/0x15
[ 2782.192413]  [<ffffffff81286cf7>] call_rwsem_down_write_failed+0x17/0x30
[ 2782.193829]  [<ffffffff810907b4>] __down_write+0x1f/0x21
[ 2782.194908]  [<ffffffff814b7b8b>] down_write+0x43/0x57
[ 2782.195963]  [<ffffffffa04dd48c>] ? btrfs_direct_IO+0x26e/0x280 [btrfs]
[ 2782.197235]  [<ffffffffa04dd48c>] btrfs_direct_IO+0x26e/0x280 [btrfs]
[ 2782.198439]  [<ffffffff811299bc>] generic_file_direct_write+0xb1/0x125
[ 2782.199692]  [<ffffffffa04ee700>] btrfs_file_write_iter+0x24d/0x4a4 [btrfs]
[ 2782.200976]  [<ffffffffa04ee4b3>] ? btrfs_sync_file+0x43a/0x43a [btrfs]
[ 2782.202356]  [<ffffffff811ca6cd>] aio_run_iocb+0x161/0x245
[ 2782.203556]  [<ffffffff81091300>] ? arch_local_irq_save+0x9/0xc
[ 2782.204777]  [<ffffffff81151964>] ? __might_fault+0x37/0x84
[ 2782.205821]  [<ffffffff81151964>] ? __might_fault+0x37/0x84
[ 2782.206909]  [<ffffffff811cb482>] do_io_submit+0x2e4/0x37b
[ 2782.207888]  [<ffffffff811cb482>] ? do_io_submit+0x2e4/0x37b
[ 2782.209121]  [<ffffffff81093fe9>] ? trace_hardirqs_on_caller+0x17b/0x197
[ 2782.210470]  [<ffffffff811cb529>] SyS_io_submit+0x10/0x12
[ 2782.211529]  [<ffffffff811cb529>] ? SyS_io_submit+0x10/0x12
[ 2782.212724]  [<ffffffff814b9565>] entry_SYSCALL_64_fastpath+0x18/0xa8
[ 2782.214026]  [<ffffffff81091b08>] ? trace_hardirqs_off_caller+0x3f/0xaa
[ 2782.215547] 2 locks held by aio-stress/17143:
[ 2782.216444]  #0:  (sb_writers#12){.+.+.+}, at: [<ffffffff8118cb3c>]
__sb_start_write+0x5f/0xb0
[ 2782.217857]  #1:  (&sb->s_type->i_mutex_key#15){+.+.+.}, at:
[<ffffffffa04dd48c>] btrfs_direct_IO+0x26e/0x280 [btrfs]
[ 2782.219450] INFO: task dio/sdb:17146 blocked for more than 120 seconds.
[ 2782.220397]       Not tainted 4.8.0-rc8-btrfs-next-35+ #1
[ 2782.221378] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2782.222950] dio/sdb         D ffff8800b28a3ae8     0 17146      2 0x00000000
[ 2782.224438] Workqueue: dio/sdb dio_aio_complete_work
[ 2782.225462]  ffff8800b28a3ae8 ffffffff814b8f06 00fffffe00000001
ffff88023f3175c0
[ 2782.227141]  ffff88002a3a40c0 ffff8800baad1940 ffff8800b28a4000
ffff8800baad1940
[ 2782.228745]  fffffffe00000001 ffff8800baad1940 ffff8800b1e8e4e0
ffff8800b28a3b00
[ 2782.230345] Call Trace:
[ 2782.230888]  [<ffffffff814b8f06>] ? _raw_spin_unlock_irq+0x2c/0x4a
[ 2782.232833]  [<ffffffff814b514b>] schedule+0x8b/0xa3
[ 2782.233814]  [<ffffffff81098982>]
__rwsem_down_write_failed_common+0x340/0x401
[ 2782.235243]  [<ffffffff814b81e1>] rwsem_down_write_failed+0x13/0x15
[ 2782.236443]  [<ffffffff814b81e1>] ? rwsem_down_write_failed+0x13/0x15
[ 2782.237918]  [<ffffffff81286cf7>] call_rwsem_down_write_failed+0x17/0x30
[ 2782.238890]  [<ffffffff810907b4>] __down_write+0x1f/0x21
[ 2782.239790]  [<ffffffff814b7b8b>] down_write+0x43/0x57
[ 2782.240769]  [<ffffffffa04ee1ca>] ? btrfs_sync_file+0x151/0x43a [btrfs]
[ 2782.242060]  [<ffffffffa04ee1ca>] btrfs_sync_file+0x151/0x43a [btrfs]
[ 2782.243410]  [<ffffffff8106c476>] ? rescuer_thread+0xf6/0x2b3
[ 2782.244525]  [<ffffffff811b5882>] vfs_fsync_range+0x8c/0x9e
[ 2782.245632]  [<ffffffff811bd260>] dio_complete+0xf0/0x144
[ 2782.246731]  [<ffffffff811bd3f3>] dio_aio_complete_work+0x1c/0x1e
[ 2782.248037]  [<ffffffff8106c0d3>] process_one_work+0x273/0x4ed
[ 2782.249126]  [<ffffffff8106c379>] process_scheduled_works+0x2c/0x33
[ 2782.250279]  [<ffffffff8106c530>] rescuer_thread+0x1b0/0x2b3
[ 2782.251399]  [<ffffffff8106c380>] ? process_scheduled_works+0x33/0x33
[ 2782.252674]  [<ffffffff81071e20>] kthread+0xd4/0xdc
[ 2782.253652]  [<ffffffff814b977f>] ret_from_fork+0x1f/0x40
[ 2782.254631]  [<ffffffff81071d4c>] ? kthread_stop+0x28a/0x28a
[ 2782.255824] 3 locks held by dio/sdb/17146:
[ 2782.256699]  #0:  ("dio/%s"sb->s_id){++++..}, at:
[<ffffffff8106bfb4>] process_one_work+0x154/0x4ed
[ 2782.258711]  #1:  ((&dio->complete_work)){+.+...}, at:
[<ffffffff8106bfb4>] process_one_work+0x154/0x4ed
[ 2782.260676]  #2:  (&sb->s_type->i_mutex_key#15){+.+.+.}, at:
[<ffffffffa04ee1ca>] btrfs_sync_file+0x151/0x43a [btrfs]
[ 2782.262831] INFO: task kworker/4:8:17191 blocked for more than 120 seconds.
[ 2782.264195]       Not tainted 4.8.0-rc8-btrfs-next-35+ #1
[ 2782.265215] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2782.266750] kworker/4:8     D ffff8800b6187c18     0 17191      2 0x00000000
[ 2782.268353] Workqueue: dio/sdb dio_aio_complete_work
[ 2782.269194]  ffff8800b6187c18 ffff8800b6187bd8 00ffffff81094012
ffff88023f3175c0
[ 2782.270729]  ffff8800b4059240 ffff8802144e1740 ffff8800b6188000
ffff88023ffa66c8
[ 2782.272279]  ffff8800b6187c58 0000000000000001 ffff880215784a80
ffff8800b6187c30
[ 2782.273810] Call Trace:
[ 2782.274364]  [<ffffffff814b514b>] schedule+0x8b/0xa3
[ 2782.275290]  [<ffffffff811a13e6>] inode_dio_wait+0x9e/0xc3
[ 2782.276340]  [<ffffffff8108af0a>] ? autoremove_wake_function+0x3a/0x3a
[ 2782.277553]  [<ffffffffa04ee1d2>] btrfs_sync_file+0x159/0x43a [btrfs]
[ 2782.278537]  [<ffffffff81094903>] ? __lock_acquire+0x669/0xe86
[ 2782.279193]  [<ffffffff811b5882>] vfs_fsync_range+0x8c/0x9e
[ 2782.280252]  [<ffffffff811bd260>] dio_complete+0xf0/0x144
[ 2782.281195]  [<ffffffff811bd3f3>] dio_aio_complete_work+0x1c/0x1e
[ 2782.282205]  [<ffffffff8106c0d3>] process_one_work+0x273/0x4ed
[ 2782.283264]  [<ffffffff8106c81e>] worker_thread+0x1eb/0x2c9
[ 2782.284410]  [<ffffffff8106c633>] ? rescuer_thread+0x2b3/0x2b3
[ 2782.285478]  [<ffffffff81071e20>] kthread+0xd4/0xdc
[ 2782.286350]  [<ffffffff814b977f>] ret_from_fork+0x1f/0x40
[ 2782.287469]  [<ffffffff81071d4c>] ? kthread_stop+0x28a/0x28a
[ 2782.288572] 3 locks held by kworker/4:8/17191:
[ 2782.289263]  #0:  ("dio/%s"sb->s_id){++++..}, at:
[<ffffffff8106bfb4>] process_one_work+0x154/0x4ed
[ 2782.290930]  #1:  ((&dio->complete_work)){+.+...}, at:
[<ffffffff8106bfb4>] process_one_work+0x154/0x4ed
[ 2782.292603]  #2:  (&sb->s_type->i_mutex_key#15){+.+.+.}, at:
[<ffffffffa04ee1ca>] btrfs_sync_file+0x151/0x43a [btrfs]
[ 2782.294547] INFO: task kworker/4:9:17192 blocked for more than 120 seconds.
[ 2782.295650]       Not tainted 4.8.0-rc8-btrfs-next-35+ #1
[ 2782.304623] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2782.305783] kworker/4:9     D ffff8800b618bb38     0 17192      2 0x00000000
[ 2782.306974] Workqueue: dio/sdb dio_aio_complete_work
[ 2782.307741]  ffff8800b618bb38 ffffffff814b8f06 00fffffe00000001
ffff88023f3175c0
[ 2782.309254]  ffff8800b1525100 ffff8800b4059240 ffff8800b618c000
ffff8800b4059240
[ 2782.310678]  fffffffe00000001 ffff8800b4059240 ffff8800b1e8e4e0
ffff8800b618bb50
[ 2782.312090] Call Trace:
[ 2782.312478]  [<ffffffff814b8f06>] ? _raw_spin_unlock_irq+0x2c/0x4a
[ 2782.313555]  [<ffffffff814b514b>] schedule+0x8b/0xa3
[ 2782.314299]  [<ffffffff81098982>]
__rwsem_down_write_failed_common+0x340/0x401
[ 2782.315464]  [<ffffffff814b81e1>] rwsem_down_write_failed+0x13/0x15
[ 2782.316531]  [<ffffffff814b81e1>] ? rwsem_down_write_failed+0x13/0x15
[ 2782.317478]  [<ffffffff81286cf7>] call_rwsem_down_write_failed+0x17/0x30
[ 2782.318598]  [<ffffffff810907b4>] __down_write+0x1f/0x21
[ 2782.319406]  [<ffffffff814b7b8b>] down_write+0x43/0x57
[ 2782.320241]  [<ffffffffa04ee1ca>] ? btrfs_sync_file+0x151/0x43a [btrfs]
[ 2782.321300]  [<ffffffffa04ee1ca>] btrfs_sync_file+0x151/0x43a [btrfs]
[ 2782.322220]  [<ffffffff81094903>] ? __lock_acquire+0x669/0xe86
[ 2782.323133]  [<ffffffff811b5882>] vfs_fsync_range+0x8c/0x9e
[ 2782.323993]  [<ffffffff811bd260>] dio_complete+0xf0/0x144
[ 2782.324871]  [<ffffffff811bd3f3>] dio_aio_complete_work+0x1c/0x1e
[ 2782.325816]  [<ffffffff8106c0d3>] process_one_work+0x273/0x4ed
[ 2782.326523]  [<ffffffff8106c81e>] worker_thread+0x1eb/0x2c9
[ 2782.327301]  [<ffffffff8106c633>] ? rescuer_thread+0x2b3/0x2b3
[ 2782.327869]  [<ffffffff81071e20>] kthread+0xd4/0xdc
[ 2782.328539]  [<ffffffff814b977f>] ret_from_fork+0x1f/0x40
[ 2782.329402]  [<ffffffff81071d4c>] ? kthread_stop+0x28a/0x28a
[ 2782.330230] 3 locks held by kworker/4:9/17192:
[ 2782.330897]  #0:  ("dio/%s"sb->s_id){++++..}, at:
[<ffffffff8106bfb4>] process_one_work+0x154/0x4ed
[ 2782.332445]  #1:  ((&dio->complete_work)){+.+...}, at:
[<ffffffff8106bfb4>] process_one_work+0x154/0x4ed
[ 2782.334011]  #2:  (&sb->s_type->i_mutex_key#15){+.+.+.}, at:
[<ffffffffa04ee1ca>] btrfs_sync_file+0x151/0x43a [btrfs]
[ 2782.335776] INFO: task kworker/4:10:17193 blocked for more than 120 seconds.
[ 2782.336905]       Not tainted 4.8.0-rc8-btrfs-next-35+ #1
[ 2782.337693] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2782.338956] kworker/4:10    D ffff8800b618fb38     0 17193      2 0x00000000
[ 2782.339986] Workqueue: dio/sdb dio_aio_complete_work
[ 2782.340766]  ffff8800b618fb38 ffffffff814b8f06 00fffffe00000001
ffff88023f3175c0
[ 2782.341956]  ffff8800b65c1340 ffff8800b1525100 ffff8800b6190000
ffff8800b1525100
[ 2782.343201]  fffffffe00000001 ffff8800b1525100 ffff8800b1e8e4e0
ffff8800b618fb50
[ 2782.344469] Call Trace:
[ 2782.344896]  [<ffffffff814b8f06>] ? _raw_spin_unlock_irq+0x2c/0x4a
[ 2782.345713]  [<ffffffff814b514b>] schedule+0x8b/0xa3
[ 2782.346505]  [<ffffffff81098982>]
__rwsem_down_write_failed_common+0x340/0x401
[ 2782.347610]  [<ffffffff814b81e1>] rwsem_down_write_failed+0x13/0x15
[ 2782.348621]  [<ffffffff814b81e1>] ? rwsem_down_write_failed+0x13/0x15
[ 2782.349652]  [<ffffffff81286cf7>] call_rwsem_down_write_failed+0x17/0x30
[ 2782.350598]  [<ffffffff810907b4>] __down_write+0x1f/0x21
[ 2782.351414]  [<ffffffff814b7b8b>] down_write+0x43/0x57
[ 2782.352229]  [<ffffffffa04ee1ca>] ? btrfs_sync_file+0x151/0x43a [btrfs]
[ 2782.353221]  [<ffffffffa04ee1ca>] btrfs_sync_file+0x151/0x43a [btrfs]
[ 2782.354204]  [<ffffffff81094903>] ? __lock_acquire+0x669/0xe86
[ 2782.355110]  [<ffffffff811b5882>] vfs_fsync_range+0x8c/0x9e
[ 2782.355873]  [<ffffffff811bd260>] dio_complete+0xf0/0x144
[ 2782.356771]  [<ffffffff811bd3f3>] dio_aio_complete_work+0x1c/0x1e
[ 2782.357707]  [<ffffffff8106c0d3>] process_one_work+0x273/0x4ed
[ 2782.358662]  [<ffffffff8106c81e>] worker_thread+0x1eb/0x2c9
[ 2782.359499]  [<ffffffff8106c633>] ? rescuer_thread+0x2b3/0x2b3
[ 2782.360364]  [<ffffffff81071e20>] kthread+0xd4/0xdc
[ 2782.361136]  [<ffffffff814b977f>] ret_from_fork+0x1f/0x40
[ 2782.361982]  [<ffffffff81071d4c>] ? kthread_stop+0x28a/0x28a
[ 2782.362951] 3 locks held by kworker/4:10/17193:
[ 2782.363719]  #0:  ("dio/%s"sb->s_id){++++..}, at:
[<ffffffff8106bfb4>] process_one_work+0x154/0x4ed
[ 2782.365256]  #1:  ((&dio->complete_work)){+.+...}, at:
[<ffffffff8106bfb4>] process_one_work+0x154/0x4ed
[ 2782.366944]  #2:  (&sb->s_type->i_mutex_key#15){+.+.+.}, at:
[<ffffffffa04ee1ca>] btrfs_sync_file+0x151/0x43a [btrfs]
[ 2782.368823] INFO: task kworker/4:11:17194 blocked for more than 120 seconds.
[ 2782.370066]       Not tainted 4.8.0-rc8-btrfs-next-35+ #1
[ 2782.370927] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2782.372287] kworker/4:11    D ffff8800b65c7b38     0 17194      2 0x00000000
[ 2782.373432] Workqueue: dio/sdb dio_aio_complete_work
[ 2782.374214]  ffff8800b65c7b38 ffffffff814b8f06 00fffffe00000001
ffff88023f3175c0
[ 2782.375494]  ffff8800b9339400 ffff8800b65c1340 ffff8800b65c8000
ffff8800b65c1340
[ 2782.376806]  fffffffe00000001 ffff8800b65c1340 ffff8800b1e8e4e0
ffff8800b65c7b50
[ 2782.378164] Call Trace:
[ 2782.378640]  [<ffffffff814b8f06>] ? _raw_spin_unlock_irq+0x2c/0x4a
[ 2782.379665]  [<ffffffff814b514b>] schedule+0x8b/0xa3
[ 2782.380493]  [<ffffffff81098982>]
__rwsem_down_write_failed_common+0x340/0x401
[ 2782.381691]  [<ffffffff814b81e1>] rwsem_down_write_failed+0x13/0x15
[ 2782.382660]  [<ffffffff814b81e1>] ? rwsem_down_write_failed+0x13/0x15
[ 2782.383720]  [<ffffffff81286cf7>] call_rwsem_down_write_failed+0x17/0x30
[ 2782.384768]  [<ffffffff810907b4>] __down_write+0x1f/0x21
[ 2782.385722]  [<ffffffff814b7b8b>] down_write+0x43/0x57
[ 2782.386605]  [<ffffffffa04ee1ca>] ? btrfs_sync_file+0x151/0x43a [btrfs]
[ 2782.387679]  [<ffffffffa04ee1ca>] btrfs_sync_file+0x151/0x43a [btrfs]
[ 2782.388806]  [<ffffffff81094903>] ? __lock_acquire+0x669/0xe86
[ 2782.389841]  [<ffffffff811b5882>] vfs_fsync_range+0x8c/0x9e
[ 2782.390741]  [<ffffffff811bd260>] dio_complete+0xf0/0x144
[ 2782.391582]  [<ffffffff811bd3f3>] dio_aio_complete_work+0x1c/0x1e
[ 2782.392523]  [<ffffffff8106c0d3>] process_one_work+0x273/0x4ed
[ 2782.393442]  [<ffffffff8106c81e>] worker_thread+0x1eb/0x2c9
[ 2782.394295]  [<ffffffff8106c633>] ? rescuer_thread+0x2b3/0x2b3
[ 2782.395225]  [<ffffffff81071e20>] kthread+0xd4/0xdc
[ 2782.395978]  [<ffffffff814b977f>] ret_from_fork+0x1f/0x40
[ 2782.396790]  [<ffffffff81071d4c>] ? kthread_stop+0x28a/0x28a
[ 2782.397614] 3 locks held by kworker/4:11/17194:
[ 2782.398314]  #0:  ("dio/%s"sb->s_id){++++..}, at:
[<ffffffff8106bfb4>] process_one_work+0x154/0x4ed
[ 2782.419771]  #1:  ((&dio->complete_work)){+.+...}, at:
[<ffffffff8106bfb4>] process_one_work+0x154/0x4ed
[ 2782.422252]  #2:  (&sb->s_type->i_mutex_key#15){+.+.+.}, at:
[<ffffffffa04ee1ca>] btrfs_sync_file+0x151/0x43a [btrfs]
[ 2782.424843] INFO: task kworker/4:16:17333 blocked for more than 120 seconds.
[ 2782.426557]       Not tainted 4.8.0-rc8-btrfs-next-35+ #1
[ 2782.427804] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2782.441453] kworker/4:16    D ffff8800b2a2fb38     0 17333      2 0x00000000
[ 2782.443148] Workqueue: dio/sdb dio_aio_complete_work
[ 2782.444158]  ffff8800b2a2fb38 ffffffff814b8f06 00fffffe00000001
ffff88023f3175c0
[ 2782.445657]  ffff8800b14a8a40 ffff8800b2a299c0 ffff8800b2a30000
ffff8800b2a299c0
[ 2782.447384]  fffffffe00000001 ffff8800b2a299c0 ffff8800b1e8e4e0
ffff8800b2a2fb50
[ 2782.449001] Call Trace:
[ 2782.449605]  [<ffffffff814b8f06>] ? _raw_spin_unlock_irq+0x2c/0x4a
[ 2782.450740]  [<ffffffff814b514b>] schedule+0x8b/0xa3
[ 2782.451802]  [<ffffffff81098982>]
__rwsem_down_write_failed_common+0x340/0x401
[ 2782.453466]  [<ffffffff814b81e1>] rwsem_down_write_failed+0x13/0x15
[ 2782.454656]  [<ffffffff814b81e1>] ? rwsem_down_write_failed+0x13/0x15
[ 2782.456114]  [<ffffffff81286cf7>] call_rwsem_down_write_failed+0x17/0x30
[ 2782.457408]  [<ffffffff810907b4>] __down_write+0x1f/0x21
[ 2782.458456]  [<ffffffff814b7b8b>] down_write+0x43/0x57
[ 2782.459603]  [<ffffffffa04ee1ca>] ? btrfs_sync_file+0x151/0x43a [btrfs]
[ 2782.461098]  [<ffffffffa04ee1ca>] btrfs_sync_file+0x151/0x43a [btrfs]
[ 2782.462503]  [<ffffffff81094903>] ? __lock_acquire+0x669/0xe86
[ 2782.463803]  [<ffffffff811b5882>] vfs_fsync_range+0x8c/0x9e
[ 2782.465057]  [<ffffffff811bd260>] dio_complete+0xf0/0x144
[ 2782.466265]  [<ffffffff811bd3f3>] dio_aio_complete_work+0x1c/0x1e
[ 2782.467396]  [<ffffffff8106c0d3>] process_one_work+0x273/0x4ed
[ 2782.468650]  [<ffffffff8106c81e>] worker_thread+0x1eb/0x2c9
[ 2782.469855]  [<ffffffff8106c633>] ? rescuer_thread+0x2b3/0x2b3
[ 2782.471156]  [<ffffffff81071e20>] kthread+0xd4/0xdc
[ 2782.472290]  [<ffffffff814b977f>] ret_from_fork+0x1f/0x40
[ 2782.473417]  [<ffffffff81071d4c>] ? kthread_stop+0x28a/0x28a
[ 2782.474284] 3 locks held by kworker/4:16/17333:
[ 2782.474941]  #0:  ("dio/%s"sb->s_id){++++..}, at:
[<ffffffff8106bfb4>] process_one_work+0x154/0x4ed
[ 2782.476541]  #1:  ((&dio->complete_work)){+.+...}, at:
[<ffffffff8106bfb4>] process_one_work+0x154/0x4ed
[ 2782.478453]  #2:  (&sb->s_type->i_mutex_key#15){+.+.+.}, at:
[<ffffffffa04ee1ca>] btrfs_sync_file+0x151/0x43a [btrfs]
[ 2857.131317] systemd-journald[571]: Sent WATCHDOG=1 notification.
[ 2903.008172] INFO: task aio-stress:17143 blocked for more than 120 seconds.
[ 2903.009649]       Not tainted 4.8.0-rc8-btrfs-next-35+ #1
[ 2903.010530] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2903.012326] aio-stress      D ffff8800b30c7a98     0 17143  16641 0x00000000
[ 2903.013807]  ffff8800b30c7a98 0000000000000282 00ff8800b30c7a50
ffff88023f3175c0
[ 2903.015553]  ffff8802156b1680 ffff8800b60fc280 ffff8800b30c8000
ffff8800b60fc280
[ 2903.017383]  fffffffe00000001 ffff8800b60fc280 ffff8800b1e8e4e0
ffff8800b30c7ab0
[ 2903.019364] Call Trace:
[ 2903.020085]  [<ffffffff814b514b>] schedule+0x8b/0xa3
[ 2903.020963]  [<ffffffff81098982>]
__rwsem_down_write_failed_common+0x340/0x401
[ 2903.022745]  [<ffffffff814b81e1>] rwsem_down_write_failed+0x13/0x15
[ 2903.024136]  [<ffffffff814b81e1>] ? rwsem_down_write_failed+0x13/0x15
[ 2903.036455]  [<ffffffff81286cf7>] call_rwsem_down_write_failed+0x17/0x30
[ 2903.037884]  [<ffffffff810907b4>] __down_write+0x1f/0x21
[ 2903.038942]  [<ffffffff814b7b8b>] down_write+0x43/0x57
[ 2903.040098]  [<ffffffffa04dd48c>] ? btrfs_direct_IO+0x26e/0x280 [btrfs]
[ 2903.041480]  [<ffffffffa04dd48c>] btrfs_direct_IO+0x26e/0x280 [btrfs]
[ 2903.042808]  [<ffffffff811299bc>] generic_file_direct_write+0xb1/0x125
[ 2903.044274]  [<ffffffffa04ee700>] btrfs_file_write_iter+0x24d/0x4a4 [btrfs]
[ 2903.045882]  [<ffffffffa04ee4b3>] ? btrfs_sync_file+0x43a/0x43a [btrfs]
[ 2903.047293]  [<ffffffff811ca6cd>] aio_run_iocb+0x161/0x245
[ 2903.048545]  [<ffffffff81091300>] ? arch_local_irq_save+0x9/0xc
[ 2903.049829]  [<ffffffff81151964>] ? __might_fault+0x37/0x84
[ 2903.051047]  [<ffffffff81151964>] ? __might_fault+0x37/0x84
[ 2903.052343]  [<ffffffff811cb482>] do_io_submit+0x2e4/0x37b
[ 2903.053608]  [<ffffffff811cb482>] ? do_io_submit+0x2e4/0x37b
[ 2903.054837]  [<ffffffff81093fe9>] ? trace_hardirqs_on_caller+0x17b/0x197
[ 2903.056280]  [<ffffffff811cb529>] SyS_io_submit+0x10/0x12
[ 2903.057416]  [<ffffffff811cb529>] ? SyS_io_submit+0x10/0x12
[ 2903.058569]  [<ffffffff814b9565>] entry_SYSCALL_64_fastpath+0x18/0xa8
[ 2903.059978]  [<ffffffff81091b08>] ? trace_hardirqs_off_caller+0x3f/0xaa
[ 2903.061360] 2 locks held by aio-stress/17143:
[ 2903.062410]  #0:  (sb_writers#12){.+.+.+}, at: [<ffffffff8118cb3c>]
__sb_start_write+0x5f/0xb0
[ 2903.064445]  #1:  (&sb->s_type->i_mutex_key#15){+.+.+.}, at:
[<ffffffffa04dd48c>] btrfs_direct_IO+0x26e/0x280 [btrfs]
[ 2903.066711] INFO: task dio/sdb:17146 blocked for more than 120 seconds.
[ 2903.068153]       Not tainted 4.8.0-rc8-btrfs-next-35+ #1
[ 2903.069288] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2903.070790] dio/sdb         D ffff8800b28a3ae8     0 17146      2 0x00000000
[ 2903.072289] Workqueue: dio/sdb dio_aio_complete_work
[ 2903.073331]  ffff8800b28a3ae8 ffffffff814b8f06 00fffffe00000001
ffff88023f3175c0
[ 2903.074942]  ffff88002a3a40c0 ffff8800baad1940 ffff8800b28a4000
ffff8800baad1940
[ 2903.076601]  fffffffe00000001 ffff8800baad1940 ffff8800b1e8e4e0
ffff8800b28a3b00
[ 2903.078005] Call Trace:
[ 2903.078589]  [<ffffffff814b8f06>] ? _raw_spin_unlock_irq+0x2c/0x4a
[ 2903.079635]  [<ffffffff814b514b>] schedule+0x8b/0xa3
[ 2903.080600]  [<ffffffff81098982>]
__rwsem_down_write_failed_common+0x340/0x401
[ 2903.082051]  [<ffffffff814b81e1>] rwsem_down_write_failed+0x13/0x15
[ 2903.083246]  [<ffffffff814b81e1>] ? rwsem_down_write_failed+0x13/0x15
[ 2903.084396]  [<ffffffff81286cf7>] call_rwsem_down_write_failed+0x17/0x30
[ 2903.085592]  [<ffffffff810907b4>] __down_write+0x1f/0x21
[ 2903.086583]  [<ffffffff814b7b8b>] down_write+0x43/0x57
[ 2903.087636]  [<ffffffffa04ee1ca>] ? btrfs_sync_file+0x151/0x43a [btrfs]
[ 2903.088947]  [<ffffffffa04ee1ca>] btrfs_sync_file+0x151/0x43a [btrfs]
[ 2903.089950]  [<ffffffff8106c476>] ? rescuer_thread+0xf6/0x2b3
[ 2903.091011]  [<ffffffff811b5882>] vfs_fsync_range+0x8c/0x9e
[ 2903.092101]  [<ffffffff811bd260>] dio_complete+0xf0/0x144
[ 2903.092916]  [<ffffffff811bd3f3>] dio_aio_complete_work+0x1c/0x1e
[ 2903.093766]  [<ffffffff8106c0d3>] process_one_work+0x273/0x4ed
[ 2903.094888]  [<ffffffff8106c379>] process_scheduled_works+0x2c/0x33
[ 2903.095976]  [<ffffffff8106c530>] rescuer_thread+0x1b0/0x2b3
[ 2903.096960]  [<ffffffff8106c380>] ? process_scheduled_works+0x33/0x33
[ 2903.098150]  [<ffffffff81071e20>] kthread+0xd4/0xdc
[ 2903.099018]  [<ffffffff814b977f>] ret_from_fork+0x1f/0x40
[ 2903.100044]  [<ffffffff81071d4c>] ? kthread_stop+0x28a/0x28a
[ 2903.101121] 3 locks held by dio/sdb/17146:
[ 2903.101897]  #0:  ("dio/%s"sb->s_id){++++..}, at:
[<ffffffff8106bfb4>] process_one_work+0x154/0x4ed
[ 2903.103901]  #1:  ((&dio->complete_work)){+.+...}, at:
[<ffffffff8106bfb4>] process_one_work+0x154/0x4ed
[ 2903.105768]  #2:  (&sb->s_type->i_mutex_key#15){+.+.+.}, at:
[<ffffffffa04ee1ca>] btrfs_sync_file+0x151/0x43a [btrfs]
[ 2903.107926] INFO: task kworker/4:8:17191 blocked for more than 120 seconds.
[ 2903.109139]       Not tainted 4.8.0-rc8-btrfs-next-35+ #1
[ 2903.110129] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2903.111629] kworker/4:8     D ffff8800b6187c18     0 17191      2 0x00000000
[ 2903.112859] Workqueue: dio/sdb dio_aio_complete_work
[ 2903.113793]  ffff8800b6187c18 ffff8800b6187bd8 00ffffff81094012
ffff88023f3175c0
[ 2903.115276]  ffff8800b4059240 ffff8802144e1740 ffff8800b6188000
ffff88023ffa66c8
[ 2903.116829]  ffff8800b6187c58 0000000000000001 ffff880215784a80
ffff8800b6187c30
[ 2903.118250] Call Trace:
[ 2903.118749]  [<ffffffff814b514b>] schedule+0x8b/0xa3
[ 2903.119624]  [<ffffffff811a13e6>] inode_dio_wait+0x9e/0xc3
[ 2903.120625]  [<ffffffff8108af0a>] ? autoremove_wake_function+0x3a/0x3a
[ 2903.121786]  [<ffffffffa04ee1d2>] btrfs_sync_file+0x159/0x43a [btrfs]
[ 2903.122851]  [<ffffffff81094903>] ? __lock_acquire+0x669/0xe86
[ 2903.123749]  [<ffffffff811b5882>] vfs_fsync_range+0x8c/0x9e
[ 2903.124735]  [<ffffffff811bd260>] dio_complete+0xf0/0x144
[ 2903.125806]  [<ffffffff811bd3f3>] dio_aio_complete_work+0x1c/0x1e
[ 2903.126844]  [<ffffffff8106c0d3>] process_one_work+0x273/0x4ed
[ 2903.127835]  [<ffffffff8106c81e>] worker_thread+0x1eb/0x2c9
[ 2903.128816]  [<ffffffff8106c633>] ? rescuer_thread+0x2b3/0x2b3
[ 2903.129811]  [<ffffffff81071e20>] kthread+0xd4/0xdc
[ 2903.130679]  [<ffffffff814b977f>] ret_from_fork+0x1f/0x40
[ 2903.131620]  [<ffffffff81071d4c>] ? kthread_stop+0x28a/0x28a
[ 2903.132571] 3 locks held by kworker/4:8/17191:
[ 2903.133310]  #0:  ("dio/%s"sb->s_id){++++..}, at:
[<ffffffff8106bfb4>] process_one_work+0x154/0x4ed
[ 2903.134845]  #1:  ((&dio->complete_work)){+.+...}, at:
[<ffffffff8106bfb4>] process_one_work+0x154/0x4ed
[ 2903.136723]  #2:  (&sb->s_type->i_mutex_key#15){+.+.+.}, at:
[<ffffffffa04ee1ca>] btrfs_sync_file+0x151/0x43a [btrfs]

I don't have the time to go now figure out all the details of the aio
code path again as I'm on vacation. But it's pretty evident that that
solution doesn't work unfortunately.
Thanks.

> -------------------------------------------------------------------------
>
> [1] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=de0ee0edb21fbab4c7afa3e94573ecfebfb0244e
>
> Thanks,
>
> -liubo
>
>>
>> [1] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=de0ee0edb21fbab4c7afa3e94573ecfebfb0244e
>> [2] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=0b901916a00bc7b14ee83cc8e41c3b0d561a8f22
>> [3] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=5f9a8a51d8b95505d8de8b7191ae2ed8c504d4af
>>
>>
>> >
>> > Thanks,
>> >
>> > -liubo
>> >
>> >>
>> >> Traces here:
>> >> INFO: task btrfs-transacti:604 blocked for more than 120 seconds.
>> >>       Not tainted 4.4.34 #1
>> >> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> >> btrfs-transacti D ffff8814e78cbe00     0   604      2 0x00080000
>> >>  ffff8814e78cbe00 ffff88017367a540 ffff8814e2f88000 ffff8814e78cc000
>> >>  ffff8814e78cbe38 ffff88123616c510 ffff8814e24c81f0 ffff88153fb0a000
>> >>  ffff8814e78cbe18 ffffffff816a8425 ffff8814e63165a0 ffff8814e78cbe88
>> >> Call Trace:
>> >>  [<ffffffff816a8425>] schedule+0x35/0x80
>> >>  [<ffffffffc03751a5>] btrfs_commit_transaction+0x275/0xa50 [btrfs]
>> >>  [<ffffffffc036fdd6>] transaction_kthread+0x1d6/0x200 [btrfs]
>> >>  [<ffffffff810a0cbb>] kthread+0xdb/0x100
>> >>  [<ffffffff816ac84f>] ret_from_fork+0x3f/0x70
>> >> DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
>> >>
>> >> Leftover inexact backtrace:
>> >>
>> >>  [<ffffffff810a0be0>] ? kthread_park+0x60/0x60
>> >> INFO: task mysqld:1977 blocked for more than 120 seconds.
>> >>       Not tainted 4.4.34 #1
>> >> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> >> mysqld          D ffff88142ef1bcf8     0  1977      1 0x00080000
>> >>  ffff88142ef1bcf8 ffffffff81e0f500 ffff8814dc2c4a80 ffff88142ef1c000
>> >>  ffff8814e32ed298 ffff8814e32ed2c0 ffff88110aa9a000 ffff8814e32ed000
>> >>  ffff88142ef1bd10 ffffffff816a8425 ffff8814e32ed000 ffff88142ef1bd60
>> >> Call Trace:
>> >>  [<ffffffff816a8425>] schedule+0x35/0x80
>> >>  [<ffffffffc03b38a2>] wait_for_writer+0xa2/0xb0 [btrfs]
>> >>  [<ffffffffc03bb439>] btrfs_sync_log+0xe9/0xa00 [btrfs]
>> >>  [<ffffffffc038d1bf>] btrfs_sync_file+0x35f/0x3d0 [btrfs]
>> >>  [<ffffffff8120055d>] vfs_fsync_range+0x3d/0xb0
>> >>  [<ffffffff8120062d>] do_fsync+0x3d/0x70
>> >>  [<ffffffff812008a0>] SyS_fsync+0x10/0x20
>> >>  [<ffffffff816ac4ee>] entry_SYSCALL_64_fastpath+0x12/0x71
>> >> DWARF2 unwinder stuck at entry_SYSCALL_64_fastpath+0x12/0x71
>> >>
>> >> Leftover inexact backtrace:
>> >>
>> >> INFO: task mysqld:3249 blocked for more than 120 seconds.
>> >>       Not tainted 4.4.34 #1
>> >> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> >> mysqld          D ffff881475fdfa40     0  3249      1 0x00080000
>> >>  ffff881475fdfa40 ffff88017367ca80 ffff8814433d2540 ffff881475fe0000
>> >>  ffff88040da39ba0 0000000000230000 ffff88040da39c20 0000000000238000
>> >>  ffff881475fdfa58 ffffffff816a8425 0000000000008000 ffff881475fdfb18
>> >> Call Trace:
>> >>  [<ffffffff816a8425>] schedule+0x35/0x80
>> >>  [<ffffffffc03b4cb7>]
>> >> wait_ordered_extents.isra.18.constprop.23+0x147/0x3d0 [btrfs]
>> >>  [<ffffffffc03b5182>] btrfs_log_changed_extents+0x242/0x610 [btrfs]
>> >>  [<ffffffffc03ba6a4>] btrfs_log_inode+0x874/0xb80 [btrfs]
>> >>  [<ffffffffc03bac6c>] btrfs_log_inode_parent+0x22c/0x910 [btrfs]
>> >>  [<ffffffffc03bc292>] btrfs_log_dentry_safe+0x62/0x80 [btrfs]
>> >>  [<ffffffffc038d0ec>] btrfs_sync_file+0x28c/0x3d0 [btrfs]
>> >>  [<ffffffff8120055d>] vfs_fsync_range+0x3d/0xb0
>> >>  [<ffffffff8120062d>] do_fsync+0x3d/0x70
>> >>  [<ffffffff812008a0>] SyS_fsync+0x10/0x20
>> >>  [<ffffffff816ac4ee>] entry_SYSCALL_64_fastpath+0x12/0x71
>> >> DWARF2 unwinder stuck at entry_SYSCALL_64_fastpath+0x12/0x71
>> >>
>> >> Leftover inexact backtrace:
>> >>
>> >> INFO: task mysqld:3250 blocked for more than 120 seconds.
>> >>       Not tainted 4.4.34 #1
>> >> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> >> mysqld          D ffff881374edb868     0  3250      1 0x00080000
>> >>  ffff881374edb868 ffff8801736b2540 ffff8814433d4a80 ffff881374edc000
>> >>  ffff8814e26f81c8 ffff8814e26f81e0 0000000000238000 00000000000a8000
>> >>  ffff881374edb880 ffffffff816a8425 ffff8814433d4a80 ffff881374edb8d8
>> >> Call Trace:
>> >>  [<ffffffff816a8425>] schedule+0x35/0x80
>> >>  [<ffffffff816aaffd>] rwsem_down_read_failed+0xed/0x130
>> >>  [<ffffffff813ce404>] call_rwsem_down_read_failed+0x14/0x30
>> >> DWARF2 unwinder stuck at call_rwsem_down_read_failed+0x14/0x30
>> >>
>> >> Leftover inexact backtrace:
>> >>
>> >>  [<ffffffff816aa5a7>] ? down_read+0x17/0x20
>> >>  [<ffffffffc0376cc6>] btrfs_create_dio_extent+0x46/0x1e0 [btrfs]
>> >>  [<ffffffffc0386a68>] btrfs_get_blocks_direct+0x3d8/0x730 [btrfs]
>> >>  [<ffffffffc0378b2e>] ? btrfs_submit_direct+0x1ce/0x740 [btrfs]
>> >>  [<ffffffff8120b2c7>] do_blockdev_direct_IO+0x11f7/0x2bc0
>> >>  [<ffffffffc0386690>] ? btrfs_page_exists_in_range+0xe0/0xe0 [btrfs]
>> >>  [<ffffffffc0378960>] ? btrfs_getattr+0xa0/0xa0 [btrfs]
>> >>  [<ffffffff8120ccd3>] __blockdev_direct_IO+0x43/0x50
>> >>  [<ffffffffc0378960>] ? btrfs_getattr+0xa0/0xa0 [btrfs]
>> >>  [<ffffffffc0377e11>] btrfs_direct_IO+0x1d1/0x380 [btrfs]
>> >>  [<ffffffffc0378960>] ? btrfs_getattr+0xa0/0xa0 [btrfs]
>> >>  [<ffffffff8115656a>] generic_file_direct_write+0xaa/0x170
>> >>  [<ffffffffc038d4de>] btrfs_file_write_iter+0x2ae/0x560 [btrfs]
>> >>  [<ffffffff810f73c1>] ? futex_wake+0x81/0x150
>> >>  [<ffffffff811cedd4>] new_sync_write+0x84/0xb0
>> >>  [<ffffffff811cee26>] __vfs_write+0x26/0x40
>> >>  [<ffffffff811cf419>] vfs_write+0xa9/0x190
>> >>  [<ffffffff810026af>] ? enter_from_user_mode+0x1f/0x50
>> >>  [<ffffffff811d027b>] SyS_pwrite64+0x6b/0xa0
>> >>  [<ffffffff81002b20>] ? syscall_return_slowpath+0xb0/0x130
>> >>  [<ffffffff816ac4ee>] entry_SYSCALL_64_fastpath+0x12/0x71
>> >> INFO: task btrfs-transacti:604 blocked for more than 120 seconds.
>> >>       Not tainted 4.4.34 #1
>> >> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> >> btrfs-transacti D ffff8814e78cbe00     0   604      2 0x00080000
>> >>  ffff8814e78cbe00 ffff88017367a540 ffff8814e2f88000 ffff8814e78cc000
>> >>  ffff8814e78cbe38 ffff88123616c510 ffff8814e24c81f0 ffff88153fb0a000
>> >>  ffff8814e78cbe18 ffffffff816a8425 ffff8814e63165a0 ffff8814e78cbe88
>> >> Call Trace:
>> >>  [<ffffffff816a8425>] schedule+0x35/0x80
>> >>  [<ffffffffc03751a5>] btrfs_commit_transaction+0x275/0xa50 [btrfs]
>> >>  [<ffffffffc036fdd6>] transaction_kthread+0x1d6/0x200 [btrfs]
>> >>  [<ffffffff810a0cbb>] kthread+0xdb/0x100
>> >>  [<ffffffff816ac84f>] ret_from_fork+0x3f/0x70
>> >> DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
>> >>
>> >> Leftover inexact backtrace:
>> >>
>> >>  [<ffffffff810a0be0>] ? kthread_park+0x60/0x60
>> >> INFO: task mysqld:1977 blocked for more than 120 seconds.
>> >>       Not tainted 4.4.34 #1
>> >> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> >> mysqld          D ffff88142ef1bcf8     0  1977      1 0x00080000
>> >>  ffff88142ef1bcf8 ffffffff81e0f500 ffff8814dc2c4a80 ffff88142ef1c000
>> >>  ffff8814e32ed298 ffff8814e32ed2c0 ffff88110aa9a000 ffff8814e32ed000
>> >>  ffff88142ef1bd10 ffffffff816a8425 ffff8814e32ed000 ffff88142ef1bd60
>> >> Call Trace:
>> >>  [<ffffffff816a8425>] schedule+0x35/0x80
>> >>  [<ffffffffc03b38a2>] wait_for_writer+0xa2/0xb0 [btrfs]
>> >>  [<ffffffffc03bb439>] btrfs_sync_log+0xe9/0xa00 [btrfs]
>> >>  [<ffffffffc038d1bf>] btrfs_sync_file+0x35f/0x3d0 [btrfs]
>> >>  [<ffffffff8120055d>] vfs_fsync_range+0x3d/0xb0
>> >>  [<ffffffff8120062d>] do_fsync+0x3d/0x70
>> >>  [<ffffffff812008a0>] SyS_fsync+0x10/0x20
>> >>  [<ffffffff816ac4ee>] entry_SYSCALL_64_fastpath+0x12/0x71
>> >> DWARF2 unwinder stuck at entry_SYSCALL_64_fastpath+0x12/0x71
>> >>
>> >> Leftover inexact backtrace:
>> >>
>> >> INFO: task mysqld:3249 blocked for more than 120 seconds.
>> >>       Not tainted 4.4.34 #1
>> >> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> >> mysqld          D ffff881475fdfa40     0  3249      1 0x00080000
>> >>  ffff881475fdfa40 ffff88017367ca80 ffff8814433d2540 ffff881475fe0000
>> >>  ffff88040da39ba0 0000000000230000 ffff88040da39c20 0000000000238000
>> >>  ffff881475fdfa58 ffffffff816a8425 0000000000008000 ffff881475fdfb18
>> >> Call Trace:
>> >>  [<ffffffff816a8425>] schedule+0x35/0x80
>> >>  [<ffffffffc03b4cb7>]
>> >> wait_ordered_extents.isra.18.constprop.23+0x147/0x3d0 [btrfs]
>> >>  [<ffffffffc03b5182>] btrfs_log_changed_extents+0x242/0x610 [btrfs]
>> >>  [<ffffffffc03ba6a4>] btrfs_log_inode+0x874/0xb80 [btrfs]
>> >>  [<ffffffffc03bac6c>] btrfs_log_inode_parent+0x22c/0x910 [btrfs]
>> >>  [<ffffffffc03bc292>] btrfs_log_dentry_safe+0x62/0x80 [btrfs]
>> >>  [<ffffffffc038d0ec>] btrfs_sync_file+0x28c/0x3d0 [btrfs]
>> >>  [<ffffffff8120055d>] vfs_fsync_range+0x3d/0xb0
>> >>  [<ffffffff8120062d>] do_fsync+0x3d/0x70
>> >>  [<ffffffff812008a0>] SyS_fsync+0x10/0x20
>> >>  [<ffffffff816ac4ee>] entry_SYSCALL_64_fastpath+0x12/0x71
>> >> DWARF2 unwinder stuck at entry_SYSCALL_64_fastpath+0x12/0x71
>> >>
>> >> Leftover inexact backtrace:
>> >>
>> >> INFO: task mysqld:3250 blocked for more than 120 seconds.
>> >>       Not tainted 4.4.34 #1
>> >> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> >> mysqld          D ffff881374edb868     0  3250      1 0x00080000
>> >>  ffff881374edb868 ffff8801736b2540 ffff8814433d4a80 ffff881374edc000
>> >>  ffff8814e26f81c8 ffff8814e26f81e0 0000000000238000 00000000000a8000
>> >>  ffff881374edb880 ffffffff816a8425 ffff8814433d4a80 ffff881374edb8d8
>> >> Call Trace:
>> >>  [<ffffffff816a8425>] schedule+0x35/0x80
>> >>  [<ffffffff816aaffd>] rwsem_down_read_failed+0xed/0x130
>> >>  [<ffffffff813ce404>] call_rwsem_down_read_failed+0x14/0x30
>> >> DWARF2 unwinder stuck at call_rwsem_down_read_failed+0x14/0x30
>> >>
>> >> Leftover inexact backtrace:
>> >>
>> >>  [<ffffffff816aa5a7>] ? down_read+0x17/0x20
>> >>  [<ffffffffc0376cc6>] btrfs_create_dio_extent+0x46/0x1e0 [btrfs]
>> >>  [<ffffffffc0386a68>] btrfs_get_blocks_direct+0x3d8/0x730 [btrfs]
>> >>  [<ffffffffc0378b2e>] ? btrfs_submit_direct+0x1ce/0x740 [btrfs]
>> >>  [<ffffffff8120b2c7>] do_blockdev_direct_IO+0x11f7/0x2bc0
>> >>  [<ffffffffc0386690>] ? btrfs_page_exists_in_range+0xe0/0xe0 [btrfs]
>> >>  [<ffffffffc0378960>] ? btrfs_getattr+0xa0/0xa0 [btrfs]
>> >>  [<ffffffff8120ccd3>] __blockdev_direct_IO+0x43/0x50
>> >>  [<ffffffffc0378960>] ? btrfs_getattr+0xa0/0xa0 [btrfs]
>> >>  [<ffffffffc0377e11>] btrfs_direct_IO+0x1d1/0x380 [btrfs]
>> >>  [<ffffffffc0378960>] ? btrfs_getattr+0xa0/0xa0 [btrfs]
>> >>  [<ffffffff8115656a>] generic_file_direct_write+0xaa/0x170
>> >>  [<ffffffffc038d4de>] btrfs_file_write_iter+0x2ae/0x560 [btrfs]
>> >>  [<ffffffff810f73c1>] ? futex_wake+0x81/0x150
>> >>  [<ffffffff811cedd4>] new_sync_write+0x84/0xb0
>> >>  [<ffffffff811cee26>] __vfs_write+0x26/0x40
>> >>  [<ffffffff811cf419>] vfs_write+0xa9/0x190
>> >>  [<ffffffff810026af>] ? enter_from_user_mode+0x1f/0x50
>> >>  [<ffffffff811d027b>] SyS_pwrite64+0x6b/0xa0
>> >>  [<ffffffff81002b20>] ? syscall_return_slowpath+0xb0/0x130
>> >>  [<ffffffff816ac4ee>] entry_SYSCALL_64_fastpath+0x12/0x71
>> >> INFO: task btrfs-transacti:604 blocked for more than 120 seconds.
>> >>       Not tainted 4.4.34 #1
>> >> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> >> btrfs-transacti D ffff8814e78cbe00     0   604      2 0x00080000
>> >>  ffff8814e78cbe00 ffff88017367a540 ffff8814e2f88000 ffff8814e78cc000
>> >>  ffff8814e78cbe38 ffff88123616c510 ffff8814e24c81f0 ffff88153fb0a000
>> >>  ffff8814e78cbe18 ffffffff816a8425 ffff8814e63165a0 ffff8814e78cbe88
>> >> Call Trace:
>> >>  [<ffffffff816a8425>] schedule+0x35/0x80
>> >>  [<ffffffffc03751a5>] btrfs_commit_transaction+0x275/0xa50 [btrfs]
>> >>  [<ffffffffc036fdd6>] transaction_kthread+0x1d6/0x200 [btrfs]
>> >>  [<ffffffff810a0cbb>] kthread+0xdb/0x100
>> >>  [<ffffffff816ac84f>] ret_from_fork+0x3f/0x70
>> >> DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
>> >>
>> >> Leftover inexact backtrace:
>> >>
>> >>  [<ffffffff810a0be0>] ? kthread_park+0x60/0x60
>> >> INFO: task mysqld:1977 blocked for more than 120 seconds.
>> >>       Not tainted 4.4.34 #1
>> >> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> >> mysqld          D ffff88142ef1bcf8     0  1977      1 0x00080000
>> >>  ffff88142ef1bcf8 ffffffff81e0f500 ffff8814dc2c4a80 ffff88142ef1c000
>> >>  ffff8814e32ed298 ffff8814e32ed2c0 ffff88110aa9a000 ffff8814e32ed000
>> >>  ffff88142ef1bd10 ffffffff816a8425 ffff8814e32ed000 ffff88142ef1bd60
>> >> Call Trace:
>> >>  [<ffffffff816a8425>] schedule+0x35/0x80
>> >>  [<ffffffffc03b38a2>] wait_for_writer+0xa2/0xb0 [btrfs]
>> >>  [<ffffffffc03bb439>] btrfs_sync_log+0xe9/0xa00 [btrfs]
>> >>  [<ffffffffc038d1bf>] btrfs_sync_file+0x35f/0x3d0 [btrfs]
>> >>  [<ffffffff8120055d>] vfs_fsync_range+0x3d/0xb0
>> >>  [<ffffffff8120062d>] do_fsync+0x3d/0x70
>> >>  [<ffffffff812008a0>] SyS_fsync+0x10/0x20
>> >>  [<ffffffff816ac4ee>] entry_SYSCALL_64_fastpath+0x12/0x71
>> >> DWARF2 unwinder stuck at entry_SYSCALL_64_fastpath+0x12/0x71
>> >>
>> >> Leftover inexact backtrace:
>> >>
>> >> Greets,
>> >> Stefan
>> >>
>> >> >
>> >> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
>> >> > Reviewed-by: Chris Mason <clm@fb.com>
>> >> > ---
>> >> >  fs/btrfs/inode.c | 8 +++++---
>> >> >  1 file changed, 5 insertions(+), 3 deletions(-)
>> >> >
>> >> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> >> > index 2b790bd..48e9356 100644
>> >> > --- a/fs/btrfs/inode.c
>> >> > +++ b/fs/btrfs/inode.c
>> >> > @@ -7783,10 +7783,12 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
>> >> >     }
>> >> >
>> >> >     /*
>> >> > -    * this will cow the extent, reset the len in case we changed
>> >> > -    * it above
>> >> > +    * this will cow the extent, if em is within [start, len], then
>> >> > +    * probably we've found a preallocated/existing extent, let's
>> >> > +    * give it a chance to use preallocated space.
>> >> >      */
>> >> > -   len = bh_result->b_size;
>> >> > +   len = min_t(u64, bh_result->b_size, em->len - (start - em->start));
>> >> > +   len = ALIGN(len, root->sectorsize);
>> >> >     free_extent_map(em);
>> >> >     em = btrfs_new_extent_direct(inode, start, len);
>> >> >     if (IS_ERR(em)) {
>> >> >
>>
>>
>>
>> --
>> Filipe David Manana,
>>
>> "People will forget what you said,
>>  people will forget what you did,
>>  but people will never forget how you made them feel."
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"People will forget what you said,
 people will forget what you did,
 but people will never forget how you made them feel."
