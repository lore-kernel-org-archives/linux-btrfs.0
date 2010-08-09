From: Simon Kirby <sim@hostway.ca>
Subject: Re: Intermittent no space errors
Date: Mon, 9 Aug 2010 16:25:36 -0700
Message-ID: <20100809232536.GC16872@hostway.ca>
References: <AANLkTik_Dbk7cyS6FR0G9r-MFYq1bCCmbJ-HyHKgpUBr@mail.gmail.com> <AANLkTimVKtyPHi3zadx66i0dbPKzF4CbGJT=OEukLM6R@mail.gmail.com> <AANLkTimir3SMbevD_PCXOUQgda-3BkiAE01cYcAMz_BR@mail.gmail.com> <AANLkTikP_q7zhA2J69Rai964StGtMqCrhf2hGKPA9+J7@mail.gmail.com> <20100804002415.GA23720@hostway.ca> <AANLkTimc57W-o7eTwfKPjeb8qwwWy0gw53aobU3+NqX9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Cundiff <syshackmin@gmail.com>, linux-btrfs@vger.kernel.org
To: "Yan, Zheng" <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimc57W-o7eTwfKPjeb8qwwWy0gw53aobU3+NqX9@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 04, 2010 at 07:21:00PM +0800, Yan, Zheng  wrote:

> > We're seeing this too, since upgrading from 2.6.33.2 + merged old git btrfs
> > unstable HEAD to plain 2.6.35.
> >
> > [sroot@backup01:.../.rmagic]# rm *
> > rm: cannot remove `WEEKLY_bar3d.png': No space left on device
> > rm: cannot remove `WEEKLY.html': No space left on device
> > rm: cannot remove `YEARLY_bar3d.png': No space left on device
> > rm: cannot remove `YEARLY.html': No space left on device
>...
> > Aug ?3 18:44:44 backup01 kernel: ------------[ cut here ]------------
> > Aug ?3 18:44:44 backup01 kernel: WARNING: at fs/btrfs/extent-tree.c:3441 btrfs_block_rsv_check+0x151/0x180()
>...
> 
> These warning is because btrfs in 2.6.35 reserves more metadata space
> for internal use
> than older kernel. Your FS is too full, btrfs can't reserve enough
> metadata space.

Hello!

Is it possible that 2.6.33.2 btrfs has mucked up the on-disk stuff in a
way that causes 2.6.35 to be unhappy?  The file system in question was
reported to be 85% full, according to "df".

In the meantime, we've been having some other problems on 2.6.35; for
example, rsync has been trying to append a block to a file for the past
5 days.  The file system is reported as 45% full:

[sroot@backup01:/root]# df -Pt btrfs /backup/bu000/vol05/
Filesystem         1024-blocks      Used Available Capacity Mounted on
/dev/mapper/bu000-vol05 3221225472 1429529324 1791696148      45% /backup/bu000/vol05
[sroot@backup01:/root]# btrfs files df /backup/bu000/vol05
Data: total=1.57TB, used=1.31TB
Metadata: total=15.51GB, used=10.48GB
System: total=12.00MB, used=192.00KB

At some point today, the kernel also spat this out:

BUG: soft lockup - CPU#3 stuck for 61s! [rsync:21903]
Modules linked in: ipmi_devintf ipmi_si ipmi_msghandler aoe bnx2
CPU 3
Modules linked in: ipmi_devintf ipmi_si ipmi_msghandler aoe bnx2

Pid: 21903, comm: rsync Tainted: G        W   2.6.35-hw #2 0NK937/PowerEdge 1950
RIP: 0010:[<ffffffff81101a2d>]  [<ffffffff81101a2d>] iput+0x5d/0x70
RSP: 0018:ffff8802c14abb48  EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffff8802c14abb58 RCX: 0000000000000003
RDX: 0000000000000000 RSI: 0000000000000002 RDI: ffff88007c075980
RBP: ffffffff8100a84e R08: 0000000000000001 R09: 8000000000000000
R10: 0000000000000002 R11: 0000000000000000 R12: ffffffffffffff66
R13: ffffffff81af04e0 R14: 0000000000000000 R15: 7fffffffffffffff
FS:  00007fd13bbb06e0(0000) GS:ffff880001cc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000002f5a108 CR3: 00000001eb94a000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process rsync (pid: 21903, threadinfo ffff8802c14aa000, task ffff880080b04b00)
Stack:
ffff88007c075888 ffff88007c0757b0 ffff8802c14abb98 ffffffff812d7439
<0> ffffffff81664cde 0000000000000001 0000000004d80000 0000000000004000
<0> ffff88042a708178 ffff88042a708000 ffff8802c14abc08 ffffffff812c599c
Call Trace:
[<ffffffff812d7439>] ? btrfs_start_one_delalloc_inode+0x129/0x160
[<ffffffff81664cde>] ? _raw_spin_lock+0xe/0x20
[<ffffffff812c599c>] ? shrink_delalloc+0x8c/0x130
[<ffffffff812c5f39>] ? btrfs_delalloc_reserve_metadata+0x189/0x190
[<ffffffff8110180e>] ? file_update_time+0x11e/0x180
[<ffffffff812c5f83>] ? btrfs_delalloc_reserve_space+0x43/0x60
[<ffffffff812e2a98>] ? btrfs_file_aio_write+0x508/0x970
[<ffffffff8100a84e>] ? apic_timer_interrupt+0xe/0x20
[<ffffffff810ec1b1>] ? do_sync_write+0xd1/0x120
[<ffffffff810fc767>] ? poll_select_copy_remaining+0xf7/0x140
[<ffffffff810ecd2b>] ? vfs_write+0xcb/0x1a0
[<ffffffff810ecef0>] ? sys_write+0x50/0x90
[<ffffffff81009f02>] ? system_call_fastpath+0x16/0x1b
Code: 00 01 00 00 48 c7 c2 a0 2c 10 81 48 8b 40 30 48 85 c0 74 12 48 8b 50 20 48 c7 c0 a0 2c 10 81 48 85 d2 48 0
Call Trace:
[<ffffffff812d7439>] ? btrfs_start_one_delalloc_inode+0x129/0x160
[<ffffffff81664cde>] ? _raw_spin_lock+0xe/0x20
[<ffffffff812c599c>] ? shrink_delalloc+0x8c/0x130
[<ffffffff812c5f39>] ? btrfs_delalloc_reserve_metadata+0x189/0x190
[<ffffffff8110180e>] ? file_update_time+0x11e/0x180
[<ffffffff812c5f83>] ? btrfs_delalloc_reserve_space+0x43/0x60
[<ffffffff812e2a98>] ? btrfs_file_aio_write+0x508/0x970
[<ffffffff8100a84e>] ? apic_timer_interrupt+0xe/0x20
[<ffffffff810ec1b1>] ? do_sync_write+0xd1/0x120
[<ffffffff810fc767>] ? poll_select_copy_remaining+0xf7/0x140
[<ffffffff810ecd2b>] ? vfs_write+0xcb/0x1a0
[<ffffffff810ecef0>] ? sys_write+0x50/0x90
[<ffffffff81009f02>] ? system_call_fastpath+0x16/0x1b

[sroot@backup01:/root]# ls -l /proc/21903/fd/1
lrwx------ 1 root root 64 2010-08-09 18:21 /proc/21903/fd/1 -> /backup/bu000/vol05/vg005_web11_backup/2010-08-04-17-00/64/54/.../customer file.mov.aYX4Js
[sroot@backup01:/root]# ls -lL /proc/21903/fd/1
-rw------- 1 root root 977797120 2010-08-04 20:39 /proc/21903/fd/1
[sroot@backup01:/root]# ps auxw|grep rsync
root     21903 73.2  0.0  12912   192 ?        R    Aug04 5177:08 rsync -aHq --numeric-ids --exclude-from=/etc/backups/backup.exclude --delete --delete-excluded /storage/vg005/web11/64/54/ /backup/bu000/vol05/vg005_web11_backup/2010-08-04-17-00/64/54

In other words, the rsync has made no progress for 5 days (or at least
the mtime hasn't changed since then).

"perf top" still shows output like this, showing that btrfs is trying
to btrfs_find_space_cluster all of the time:

     samples  pcnt function                       DSO
     _______ _____ ______________________________ _________________

     2127.00 11.9% find_next_bit                  [kernel]
     1914.00 10.7% find_next_zero_bit             [kernel]
     1580.00  8.8% schedule                       [kernel]
     1340.00  7.5% btrfs_find_space_cluster       [kernel]
     1238.00  6.9% _raw_spin_lock_irqsave         [kernel]
     1017.00  5.7% _raw_spin_lock                 [kernel]
      662.00  3.7% sched_clock_local              [kernel]
      615.00  3.4% native_read_tsc                [kernel]
      590.00  3.3% _raw_spin_lock_irq             [kernel]
      468.00  2.6% _raw_spin_unlock_irqrestore    [kernel]
      405.00  2.3% schedule_timeout               [kernel]
      338.00  1.9% native_sched_clock             [kernel]
      329.00  1.8% update_curr                    [kernel]
      323.00  1.8% lock_timer_base                [kernel]
      297.00  1.7% btrfs_start_one_delalloc_inode [kernel]
      285.00  1.6% pick_next_task_fair            [kernel]
      267.00  1.5% try_to_del_timer_sync          [kernel]
      248.00  1.4% sched_clock_cpu                [kernel]
      245.00  1.4% deflate_fast                   [kernel]

So, is it possible that the older btrfs code left things in a way that
wouldn't have happened if we had started with 3.6.35 to begin with? 
In the case of the 45% full file system, it seems it should be
able to allocate more space without issue.

Simon-
