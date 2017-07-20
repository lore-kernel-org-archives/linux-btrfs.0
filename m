Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:60104 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935802AbdGTVCx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Jul 2017 17:02:53 -0400
Subject: Re: kernel btrfs file system wedged -- is it toast?
To: Paul Jackson <pj@usa.net>, linux-btrfs@vger.kernel.org
References: <1500576442.3508802.1047392992.202A4606@webmail.messagingengine.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <3dd83854-362d-001a-e075-2156931a5cc2@mendix.com>
Date: Thu, 20 Jul 2017 23:02:49 +0200
MIME-Version: 1.0
In-Reply-To: <1500576442.3508802.1047392992.202A4606@webmail.messagingengine.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 07/20/2017 08:47 PM, Paul Jackson wrote:
> 
> This may be a repeat, in a slightly variant form, of the problem that
> Marc MERLIN reports in:
> 
>   https://www.spinics.net/lists/linux-btrfs/msg67393.html
>   20170716160658.r4uxuqlfe24hgi5n@merlins.org
>   BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2960: errno=-17 Object already exists (since 3.4 / 2012)

No, it's not the same. You don't have an 'errno=-17 Object already
exists' error in btrfs_run_delayed_refs.

> [...]
> I was running both a "btrfs balance" and a "btrfs receive" into the same file system.

Just curious, what was the reason for using balance?

> Then I noticed that the disk light (on an 8TB helium filled 5400 RPM drive) stopped blinking
> (it should have been blinking for many more hours, just on the btrfs balance command.)
> 
> My dmesg output shows (including the last few successful balance entries):
> 
> ======================
> [50583.100966] BTRFS info (device sde1): relocating block group 5980234448896 flags data
> [50607.655851] BTRFS info (device sde1): found 5076 extents
> [50650.791868] BTRFS info (device sde1): found 5076 extents
> [50651.561918] BTRFS info (device sde1): relocating block group 5979160707072 flags data
> [50671.583960] BTRFS info (device sde1): found 5326 extents
> [50715.786757] BTRFS info (device sde1): found 5326 extents
> [50716.365571] BTRFS info (device sde1): relocating block group 5978086965248 flags data
> [50738.280469] BTRFS info (device sde1): found 5539 extents
> [50779.009891] BTRFS info (device sde1): found 5539 extents
> [50781.939661] BTRFS info (device sde1): relocating block group 5977013223424 flags data
> [50805.881194] BTRFS info (device sde1): found 10658 extents
> [...]

Here's the first one, the cleaner thread, which is apparently looking
around if it can delete block groups that are completely empty to return
them as unallocated space. It's waiting for another thread which is
keeping a lock, it seems.

> [51239.838954] INFO: task btrfs-cleaner:9958 blocked for more than 120 seconds.
> [51239.838956]       Tainted: G           O    4.11.10-1-MANJARO #1
> [51239.838956] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [51239.838957] btrfs-cleaner   D    0  9958      2 0x00000000
> [51239.838959] Call Trace:
> [51239.838964]  __schedule+0x22e/0x8e0
> [51239.838965]  schedule+0x3d/0x90
> [51239.838966]  schedule_preempt_disabled+0x15/0x20
> [51239.838967]  __mutex_lock.isra.0+0x2ac/0x530
> [51239.838969]  __mutex_lock_slowpath+0x13/0x20
> [51239.838970]  ? __mutex_lock_slowpath+0x13/0x20
> [51239.838970]  mutex_lock+0x25/0x30
> [51239.838980]  btrfs_delete_unused_bgs+0xc2/0x3b0 [btrfs]
> [51239.838981]  ? iput+0x1ae/0x240
> [51239.838987]  cleaner_kthread+0x15e/0x170 [btrfs]
> [51239.838988]  kthread+0x125/0x140
> [51239.838993]  ? btrfs_destroy_pinned_extent+0xd0/0xd0 [btrfs]
> [51239.838994]  ? kthread_create_on_node+0x70/0x70
> [51239.838995]  ret_from_fork+0x25/0x30

Second one is the btrfs balance, which is relocating a block group, and
wants to complete a transaction, and waits for that to happen:

> [51239.838997] INFO: task btrfs:23561 blocked for more than 120 seconds.
> [51239.838997]       Tainted: G           O    4.11.10-1-MANJARO #1
> [51239.838997] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [51239.838998] btrfs           D    0 23561   5610 0x00000000
> [51239.838999] Call Trace:
> [51239.839000]  __schedule+0x22e/0x8e0
> [51239.839001]  schedule+0x3d/0x90
> [51239.839002]  schedule_timeout+0x224/0x3c0
> [51239.839004]  ? wake_up_process+0x15/0x20
> [51239.839005]  wait_for_common+0xb9/0x180
> [51239.839005]  ? wait_for_common+0xb9/0x180
> [51239.839006]  ? wake_up_q+0x80/0x80
> [51239.839007]  wait_for_completion+0x1d/0x20
> [51239.839012]  btrfs_async_run_delayed_refs+0x119/0x140 [btrfs]
> [51239.839017]  __btrfs_end_transaction+0x1fa/0x300 [btrfs]
> [51239.839022]  btrfs_end_transaction_throttle+0x13/0x20 [btrfs]
> [51239.839028]  relocate_block_group+0x3f2/0x620 [btrfs]
> [51239.839034]  btrfs_relocate_block_group+0x18c/0x270 [btrfs]
> [51239.839040]  btrfs_relocate_chunk+0x38/0xd0 [btrfs]
> [51239.839045]  btrfs_balance+0xbdc/0x1340 [btrfs]
> [51239.839046]  ? ttwu_do_wakeup.isra.16+0x1e/0x170
> [51239.839053]  btrfs_ioctl_balance+0x316/0x380 [btrfs]
> [51239.839058]  btrfs_ioctl+0x1177/0x24a0 [btrfs]
> [51239.839060]  ? tty_flip_buffer_push+0x2b/0x30
> [51239.839061]  ? remove_wait_queue+0x4d/0x60
> [51239.839062]  ? __wake_up+0x44/0x50
> [51239.839064]  do_vfs_ioctl+0xa5/0x600
> [51239.839065]  ? do_vfs_ioctl+0xa5/0x600
> [51239.839066]  ? vfs_write+0x168/0x1a0
> [51239.839067]  SyS_ioctl+0x79/0x90
> [51239.839069]  entry_SYSCALL_64_fastpath+0x1a/0xa9
> [51239.839069] RIP: 0033:0x7fb06bfe6c47
> [51239.839070] RSP: 002b:00007ffdc77cd118 EFLAGS: 00000206 ORIG_RAX: 0000000000000010
> [51239.839071] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007fb06bfe6c47
> [51239.839071] RDX: 00007ffdc77cd1b0 RSI: 00000000c4009420 RDI: 0000000000000003
> [51239.839072] RBP: 0000000000000003 R08: 00007fb06cf2f8c0 R09: 00007fb06cf2f8c0
> [51239.839072] R10: 0000000000000545 R11: 0000000000000206 R12: 00007ffdc77cd1b0
> [51239.839073] R13: 0000000000480525 R14: 0000000000000000 R15: 00007ffdc77cf591

Third one is probably btrfs receive, which is also waiting for the
transaction:

> [51239.839076] INFO: task btrfs:29186 blocked for more than 120 seconds.
> [51239.839077]       Tainted: G           O    4.11.10-1-MANJARO #1
> [51239.839077] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [51239.839078] btrfs           D    0 29186  27726 0x00000000
> [51239.839079] Call Trace:
> [51239.839080]  __schedule+0x22e/0x8e0
> [51239.839081]  schedule+0x3d/0x90
> [51239.839082]  schedule_timeout+0x224/0x3c0
> [51239.839086]  ? btrfs_leaf_free_space+0x54/0xa0 [btrfs]
> [51239.839087]  ? wake_up_process+0x15/0x20
> [51239.839088]  wait_for_common+0xb9/0x180
> [51239.839089]  ? wait_for_common+0xb9/0x180
> [51239.839089]  ? wake_up_q+0x80/0x80
> [51239.839090]  wait_for_completion+0x1d/0x20
> [51239.839095]  btrfs_async_run_delayed_refs+0x119/0x140 [btrfs]
> [51239.839100]  __btrfs_end_transaction+0x1fa/0x300 [btrfs]
> [51239.839105]  btrfs_end_transaction+0x10/0x20 [btrfs]
> [51239.839110]  btrfs_setattr+0x129/0x3b0 [btrfs]
> [51239.839111]  notify_change+0x2c7/0x430
> [51239.839112]  do_truncate+0x73/0xc0
> [51239.839113]  vfs_truncate+0x14e/0x190
> [51239.839114]  ? user_path_at_empty+0x36/0x40
> [51239.839115]  do_sys_truncate.part.0+0x8a/0xa0
> [51239.839116]  SyS_truncate+0x13/0x20
> [51239.839117]  entry_SYSCALL_64_fastpath+0x1a/0xa9
> [51239.839118] RIP: 0033:0x7f325f704ce7
> [51239.839118] RSP: 002b:00007ffda084a908 EFLAGS: 00000297 ORIG_RAX: 000000000000004c
> [51239.839119] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f325f704ce7
> [51239.839119] RDX: 0000000000000000 RSI: 000000001124aa3b RDI: 00007ffda084a910
> [51239.839120] RBP: 00007ffda084ba20 R08: 0000000000000057 R09: 0000000001e56170
> [51239.839120] R10: 0000000001e561c0 R11: 0000000000000297 R12: 000000000000000f
> [51239.839121] R13: 000000000000c06b R14: 00000000e37b700a R15: 00007ffda084ba24
> [...]

There's probably another process, I suspect it being the
btrfs-transaction kernel thread, that is actually active at the same
time, taking long to get its work done, letting the other processes
wait, and maybe also even holding the lock which the cleaner is waiting for.

> ======================
> 
> I also have issued a "btrfs balance pause" command, which is now in an unkillable
> wait in the kernel.

Yes, that just waits for the balance to finish the block group it's
currently busy with, and then makes sure it doesn't start working on a
new one. So it's just joining the queue with blocked processes.

> I will reboot after sending this present email and see what I can see.

Rebooting while all those things are still busy is possible, but I think
it means you'll probably lose whatever was part of this transaction that
was being finished.

> But based on Marc's thread mentioned above, I am quite concerned
> that I should NEVER trust this particular btrfs file system again, and
> that I should reformat that 8 TB disk partition and rebuild the file
> store on that disk from scratch.
> 
> If so, I must conclude that I should NEVER trust btrfs again.

Don't panic. There's no big error anywhere yet.

Find out which process is the actually running process (all the other
ones reported in the log are waiting for that one), and see what it's
doing. 100% cpu? or a lot of disk reads and writes?

> ======================
> 
> Questions:
> 
> Is there anyway to recover this receiving btrfs file system?

Wait a bit until the busy process completes, and in the meantime try to
figure out what it's doing. Maybe the people on IRC can help a bit.

> Is there anyway to know, with confidence, that this receiving btrfs  file
> system is healthy?

I think there are no really big unhealty things happening yet, although
it's a bit inconvenient.

> If not is there any reliable way to avoid hitting this disaster again?

Doing 'big things' at the same time can lead to situations in which
similar things as seen above happen. Just avoid them. Don't remove 100
subvolumes at the same time as doing a receive and doing balance and
also doing another send somewhere. Or pointing balance at metadata and
then remove subvolumes (last time I saw that explode was in a 4.5 kernel).

The only really problematic combination I know is using send and balance
at the same time. Last two times I (accidentally) tried that I ended up
with one filesystem that ended up being broken in memory, crashed, and
was fine after a reboot again because it couldn't write its broken state
to disk. The other one crashed its send process in the kernel, and was
also fine again after a reboot.

> ===
> 
> If not that either, then know that I will necessarily throw out the
> last couple of months work I've spent, developing a backup system
> for my particular purposes that relies heavily on btrfs snapshots,
> sent and received to create off-site and off-line backups from multiple
> locations.
> 
> Just rebuilding the file system I was sending to would take me days
> of work.  This target file system contains backups of a half dozen
> other btrfs file systems.

Yeah, well... Btrfs is great, especially for things like backup servers
with snapshots (I'm doing that myself too), but you have to be very careful.

As I already said above, don't fire up too many fancy things at once. It
might go well, or they're already disallowed to do dangerous things at
the same time (leading to one being able to work, and the others hang
and wait), or it can trigger bugs which are lurking around in the
multithreaded code.

Also, choose your kernel versions wisely. Right now, the 4.9 LTS kernel
is a good bet. New kernels have fixes, new features but also new bugs.
In the case of btrfs, the LTS kernel sadly usually doesn't get most of
the bugfixes that fix "inconveniences" which are not causing actual data
corruption, but at least you can find out what the known issues are.
Data corruption bugs have a high chance of showing up in the latest LTS
though.

And if it all suddenly falls apart on a sunday night at 4AM and eats all
your data... then you're left with the pieces.

> [...]
> 
> P.S. -- About 50 minutes after issuing the above "btrfs balance pause",
> just before I was about to hit send on this email, I noticed:
> 
> 1.  my disk light flashing again
> 2.  that pause command returnedto the shell prompt (pause command exited),
> 3. the in progress balance command also exited, stating "balance paused by user"), and
> 4. the sequence of "btrfs receives" into that file system resumed progress.
> 
> Is that good news, bad news, or impossible to say news?

Well, there it is. :-) Whatever the busy thread was doing finished and
allowed the other ones to also continue again.

-- 
Hans van Kranenburg
