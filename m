Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:60534 "EHLO
	arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbcDASMl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Apr 2016 14:12:41 -0400
Date: Fri, 1 Apr 2016 14:12:27 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Linux Kernel <linux-kernel@vger.kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs_destroy_inode WARN_ON.
Message-ID: <20160401181227.GA31426@codemonkey.org.uk>
References: <20160324225411.GA1612@codemonkey.org.uk>
 <20160328011400.GA19000@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160328011400.GA19000@codemonkey.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 27, 2016 at 09:14:00PM -0400, Dave Jones wrote:
 
 >  > WARNING: CPU: 2 PID: 32570 at fs/btrfs/inode.c:9261 btrfs_destroy_inode+0x389/0x3f0 [btrfs]
 >  > CPU: 2 PID: 32570 Comm: rm Not tainted 4.5.0-think+ #14
 >  >  ffffffffc039baf9 00000000ef721ef0 ffff88025966fc08 ffffffff8957bcdb
 >  >  0000000000000000 0000000000000000 ffff88025966fc50 ffffffff890b41f1
 >  >  ffff88045d918040 0000242d4eed6048 ffff88024eed6048 ffff88024eed6048
 >  > Call Trace:
 >  >  [<ffffffffc039baf9>] ? btrfs_destroy_inode+0x389/0x3f0 [btrfs]
 >  >  [<ffffffff8957bcdb>] dump_stack+0x68/0x9d
 >  >  [<ffffffff890b41f1>] __warn+0x111/0x130
 >  >  [<ffffffff890b43fd>] warn_slowpath_null+0x1d/0x20
 >  >  [<ffffffffc039baf9>] btrfs_destroy_inode+0x389/0x3f0 [btrfs]
 >  >  [<ffffffff89352307>] destroy_inode+0x67/0x90
 >  >  [<ffffffff893524e7>] evict+0x1b7/0x240
 >  >  [<ffffffff893529be>] iput+0x3ae/0x4e0
 >  >  [<ffffffff8934c93e>] ? dput+0x20e/0x460
 >  >  [<ffffffff8933ee26>] do_unlinkat+0x256/0x440
 >  >  [<ffffffff8933ebd0>] ? do_rmdir+0x350/0x350
 >  >  [<ffffffff890031e7>] ? syscall_trace_enter_phase1+0x87/0x260
 >  >  [<ffffffff89003160>] ? enter_from_user_mode+0x50/0x50
 >  >  [<ffffffff8913c3b5>] ? __lock_is_held+0x25/0xd0
 >  >  [<ffffffff891411f2>] ? mark_held_locks+0x22/0xc0
 >  >  [<ffffffff890034ed>] ? syscall_trace_enter_phase2+0x12d/0x3d0
 >  >  [<ffffffff893400b0>] ? SyS_rmdir+0x20/0x20
 >  >  [<ffffffff893400cb>] SyS_unlinkat+0x1b/0x30
 >  >  [<ffffffff89003ac4>] do_syscall_64+0xf4/0x240
 >  >  [<ffffffff89d520da>] entry_SYSCALL64_slow_path+0x25/0x25
 >  > ---[ end trace a48ce4e6a1b5e409 ]---
 >  > 
 >  > That's WARN_ON(BTRFS_I(inode)->csum_bytes);
 >  > 
 >  > *maybe* it's a bad disk, but there's no indication in dmesg of anything awry.
 >  > Spinning rust on SATA, nothing special.
 > 
 > Same WARN_ON is reachable from umount too..
 > 
 > WARNING: CPU: 2 PID: 20092 at fs/btrfs/inode.c:9261 btrfs_destroy_inode+0x40c/0x480 [btrfs]
 > CPU: 2 PID: 20092 Comm: umount Tainted: G        W       4.5.0-think+ #1
 >  00000000ffffffff 00000000a32c482b ffff8803cd187b60 ffffffff9d63af84
 >  0000000000000000 0000000000000000 ffffffffc05c5e40 ffffffffc04d316c
 >  ffff8803cd187ba8 ffffffff9d0c4c27 ffff880460d80040 0000242dcd187bb0
 > Call Trace:
 >  [<ffffffff9d63af84>] dump_stack+0x95/0xe1
 >  [<ffffffffc04d316c>] ? btrfs_destroy_inode+0x40c/0x480 [btrfs]
 >  [<ffffffff9d0c4c27>] __warn+0x147/0x170
 >  [<ffffffff9d0c4e91>] warn_slowpath_null+0x31/0x40
 >  [<ffffffffc04d316c>] btrfs_destroy_inode+0x40c/0x480 [btrfs]
 >  [<ffffffffc04d2d60>] ? btrfs_test_destroy_inode+0x40/0x40 [btrfs]
 >  [<ffffffff9d3bf7e7>] destroy_inode+0x77/0xb0
 >  [<ffffffff9d3bfa2e>] evict+0x20e/0x2c0
 >  [<ffffffff9d3bfb50>] dispose_list+0x70/0xb0
 >  [<ffffffff9d3c14ef>] evict_inodes+0x26f/0x2c0
 >  [<ffffffff9d3c1280>] ? inode_add_lru+0x60/0x60
 >  [<ffffffff9d40baa5>] ? fsnotify_unmount_inodes+0x215/0x2c0
 >  [<ffffffff9d38e336>] generic_shutdown_super+0x76/0x1c0
 >  [<ffffffff9d38e899>] kill_anon_super+0x29/0x40
 >  [<ffffffffc044c421>] btrfs_kill_super+0x31/0x130 [btrfs]
 >  [<ffffffff9d38ec1f>] deactivate_locked_super+0x6f/0xb0
 >  [<ffffffff9d38f2c9>] deactivate_super+0x99/0xb0
 >  [<ffffffff9d3c8610>] cleanup_mnt+0x70/0xd0
 >  [<ffffffff9d3c86db>] __cleanup_mnt+0x1b/0x20
 >  [<ffffffff9d103d1f>] task_work_run+0xef/0x130
 >  [<ffffffff9d0023c9>] exit_to_usermode_loop+0xf9/0x100
 >  [<ffffffff9d004068>] do_syscall_64+0x238/0x2b0
 >  [<ffffffff9df3831a>] entry_SYSCALL64_slow_path+0x25/0x25

Additional fallout:

BTRFS: assertion failed: num_extents, file: fs/btrfs/extent-tree.c, line: 5584
------------[ cut here ]------------
kernel BUG at fs/btrfs/ctree.h:4320!
invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC KASAN
CPU: 1 PID: 18815 Comm: trinity-c13 Tainted: G        W       4.6.0-rc1-think+ #1
task: ffff88045de10040 ti: ffff8803afa38000 task.ti: ffff8803afa38000
RIP: 0010:[<ffffffffc045caf3>]  [<ffffffffc045caf3>] assfail.constprop.88+0x2b/0x2d [btrfs]
RSP: 0018:ffff8803afa3f838  EFLAGS: 00010282
RAX: 000000000000004e RBX: ffffffffc046e200 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000003 RDI: ffffed0075f47efb
RBP: ffff8803afa3f848 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000001 R12: 00000000000015d0
R13: ffff8803fda0e048 R14: ffff8803fda0dc38 R15: ffff8803fda0dc58
FS:  00007fa0566d6700(0000) GS:ffff880468a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fa0566d9000 CR3: 0000000333bc4000 CR4: 00000000001406e0
DR0: 00007fa0554fb000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
Stack:
 0000000000000000 ffff8803fda0e048 ffff8803afa3f880 ffffffffc032288b
 0000000000000000 ffff880460bb33f8 ffff8803fda0e048 ffff8803fda0dc38
 ffff8803fda0dc58 ffff8803afa3f8c8 ffffffffc032f851 0000000000000001
Call Trace:
 [<ffffffffc032288b>] drop_outstanding_extent+0x10b/0x130 [btrfs]
 [<ffffffffc032f851>] btrfs_delalloc_release_metadata+0x71/0x480 [btrfs]
 [<ffffffffc03879bf>] ? __btrfs_buffered_write+0xa6f/0xb50 [btrfs]
 [<ffffffffc032fc87>] btrfs_delalloc_release_space+0x27/0x50 [btrfs]
 [<ffffffffc0387978>] __btrfs_buffered_write+0xa28/0xb50 [btrfs]
 [<ffffffffc0386f50>] ? btrfs_dirty_pages+0x1c0/0x1c0 [btrfs]
 [<ffffffff982bb6fe>] ? filemap_fdatawait_range+0x3e/0x50
 [<ffffffff982c16a7>] ? generic_file_direct_write+0x237/0x2f0
 [<ffffffff982c1470>] ? filemap_write_and_wait_range+0xa0/0xa0
 [<ffffffffc038dc00>] ? btrfs_file_write_iter+0x670/0x9a0 [btrfs]
 [<ffffffffc038dcdd>] btrfs_file_write_iter+0x74d/0x9a0 [btrfs]
 [<ffffffff983886e3>] do_iter_readv_writev+0x153/0x1f0
 [<ffffffffc038d590>] ? btrfs_sync_file+0x920/0x920 [btrfs]
 [<ffffffff98388590>] ? vfs_iter_read+0x1e0/0x1e0
 [<ffffffff98112179>] ? preempt_count_sub+0xb9/0x130
 [<ffffffff98154577>] ? percpu_down_read+0x57/0xa0
 [<ffffffff9838f94e>] ? __sb_start_write+0xee/0x130
 [<ffffffffc038d590>] ? btrfs_sync_file+0x920/0x920 [btrfs]
 [<ffffffff9838a09f>] do_readv_writev+0x30f/0x460
 [<ffffffff98389d90>] ? vfs_write+0x2b0/0x2b0
 [<ffffffff9815be00>] ? debug_check_no_locks_freed+0x1b0/0x1b0
 [<ffffffff98256a5d>] ? trace_preempt_off+0x3d/0x1c0
 [<ffffffff9815ed67>] ? lock_release+0x547/0x8f0
 [<ffffffff98674c7b>] ? check_preemption_disabled+0x3b/0x160
 [<ffffffff982568bd>] ? trace_preempt_on+0x3d/0x1a0
 [<ffffffff98112179>] ? preempt_count_sub+0xb9/0x130
 [<ffffffff982b886b>] ? __context_tracking_exit.part.5+0x9b/0x2b0
 [<ffffffff9800347c>] ? syscall_trace_enter_phase1+0xbc/0x2a0
 [<ffffffff9838a638>] vfs_writev+0x78/0xa0
 [<ffffffff9838a967>] do_pwritev+0x117/0x140
 [<ffffffff9838c9f0>] ? SyS_preadv2+0x80/0x80
 [<ffffffff9838ca25>] SyS_pwritev+0x35/0x40
 [<ffffffff98003f33>] do_syscall_64+0x103/0x2b0
 [<ffffffff98f3881a>] entry_SYSCALL64_slow_path+0x25/0x25
Code: 55 48 89 e5 41 54 41 89 f4 53 48 89 fb e8 e6 95 da d7 44 89 e1 48 89 de 48 c7 c2 60 de 46 c0 48 c7 c7 a0 e1 46 c0 e8 fc d5 e5 d7 <0f> 0b 55 48 89 e5 41 57 45 89 c7 41 56 49 89 ce 41 55 49 89 d5 
RIP  [<ffffffffc045caf3>] assfail.constprop.88+0x2b/0x2d [btrfs]
 RSP <ffff8803afa3f838>
---[ end trace 40e67d85fcda7cb2 ]---
BUG: workqueue lockup - pool cpus=1 node=0 flags=0x0 nice=0 stuck for 30s!
Showing busy workqueues and worker pools:
workqueue events: flags=0x0
  pwq 6: cpus=3 node=0 flags=0x0 nice=0 active=1/256
    pending: vmstat_shepherd
  pwq 4: cpus=2 node=0 flags=0x0 nice=0 active=1/256
    pending: check_corruption
  pwq 2: cpus=1 node=0 flags=0x0 nice=0 active=3/256
    pending: usb_serial_port_work, lru_add_drain_per_cpu BAR(17230), e1000_watchdog_task
workqueue events_power_efficient: flags=0x82
  pwq 8: cpus=0-3 flags=0x4 nice=0 active=3/256
    pending: fb_flashcursor, neigh_periodic_work, neigh_periodic_work
workqueue events_freezable_power_: flags=0x86
  pwq 8: cpus=0-3 flags=0x4 nice=0 active=1/256
    pending: disk_events_workfn
workqueue netns: flags=0x6000a
  pwq 8: cpus=0-3 flags=0x4 nice=0 active=1/1
    in-flight: 10038:cleanup_net
workqueue writeback: flags=0x4e
  pwq 8: cpus=0-3 flags=0x4 nice=0 active=2/256
    pending: wb_workfn, wb_workfn
workqueue kblockd: flags=0x18
  pwq 3: cpus=1 node=0 flags=0x0 nice=-20 active=2/256
    pending: blk_mq_timeout_work, blk_mq_timeout_work
workqueue vmstat: flags=0xc
  pwq 4: cpus=2 node=0 flags=0x0 nice=0 active=1/256
    pending: vmstat_update
  pwq 2: cpus=1 node=0 flags=0x0 nice=0 active=1/256
    pending: vmstat_update
  pwq 0: cpus=0 node=0 flags=0x0 nice=0 active=1/256
    pending: vmstat_update
pool 8: cpus=0-3 flags=0x4 nice=0 hung=0s workers=11 idle: 11638 10276 609 17937 606 9237 605 891 15998 14100
note: trinity-c13[18815] exited with preempt_count 1

