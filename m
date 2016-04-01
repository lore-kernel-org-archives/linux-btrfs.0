Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:60602 "EHLO
	arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbcDASTA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Apr 2016 14:19:00 -0400
Date: Fri, 1 Apr 2016 14:18:54 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Linux Kernel <linux-kernel@vger.kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs_destroy_inode WARN_ON.
Message-ID: <20160401181854.GA32269@codemonkey.org.uk>
References: <20160324225411.GA1612@codemonkey.org.uk>
 <20160328011400.GA19000@codemonkey.org.uk>
 <20160401181227.GA31426@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160401181227.GA31426@codemonkey.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 01, 2016 at 02:12:27PM -0400, Dave Jones wrote:
 > BUG: workqueue lockup - pool cpus=1 node=0 flags=0x0 nice=0 stuck for 30s!
 > Showing busy workqueues and worker pools:
 > workqueue events: flags=0x0
 >   pwq 6: cpus=3 node=0 flags=0x0 nice=0 active=1/256
 >     pending: vmstat_shepherd
 >   pwq 4: cpus=2 node=0 flags=0x0 nice=0 active=1/256
 >     pending: check_corruption
 >   pwq 2: cpus=1 node=0 flags=0x0 nice=0 active=3/256
 >     pending: usb_serial_port_work, lru_add_drain_per_cpu BAR(17230), e1000_watchdog_task
 > workqueue events_power_efficient: flags=0x82
 >   pwq 8: cpus=0-3 flags=0x4 nice=0 active=3/256
 >     pending: fb_flashcursor, neigh_periodic_work, neigh_periodic_work
 > workqueue events_freezable_power_: flags=0x86
 >   pwq 8: cpus=0-3 flags=0x4 nice=0 active=1/256
 >     pending: disk_events_workfn
 > workqueue netns: flags=0x6000a
 >   pwq 8: cpus=0-3 flags=0x4 nice=0 active=1/1
 >     in-flight: 10038:cleanup_net
 > workqueue writeback: flags=0x4e
 >   pwq 8: cpus=0-3 flags=0x4 nice=0 active=2/256
 >     pending: wb_workfn, wb_workfn
 > workqueue kblockd: flags=0x18
 >   pwq 3: cpus=1 node=0 flags=0x0 nice=-20 active=2/256
 >     pending: blk_mq_timeout_work, blk_mq_timeout_work
 > workqueue vmstat: flags=0xc
 >   pwq 4: cpus=2 node=0 flags=0x0 nice=0 active=1/256
 >     pending: vmstat_update
 >   pwq 2: cpus=1 node=0 flags=0x0 nice=0 active=1/256
 >     pending: vmstat_update
 >   pwq 0: cpus=0 node=0 flags=0x0 nice=0 active=1/256
 >     pending: vmstat_update
 > pool 8: cpus=0-3 flags=0x4 nice=0 hung=0s workers=11 idle: 11638 10276 609 17937 606 9237 605 891 15998 14100
 > note: trinity-c13[18815] exited with preempt_count 1

This has wedged userspace too:

23082 pts/2    SN+    0:00  |   \_ /bin/bash scripts/test-multi.sh
14140 pts/2    SNL+   0:15  |       \_ ../trinity -q -l off -N 1000000 -a64 -x fsync -x fdatasync
16900 ?        DNs    0:04  |           \_ ../trinity -q -l off -N 1000000 -a64 -x fsync -x fdata
18894 ?        DNs    0:02  |           \_ ../trinity -q -l off -N 1000000 -a64 -x fsync -x fdata

(14:16:02:davej@think:trinity[master])$ stack 16900
[<ffffffff982c1fb6>] wait_on_page_bit_killable+0x156/0x1b0
[<ffffffff982c3182>] __lock_page_or_retry+0x112/0x1b0
[<ffffffff982c3587>] filemap_fault+0x367/0xb30
[<ffffffff983194a7>] __do_fault+0x167/0x3d0
[<ffffffff983216b7>] handle_mm_fault+0x1837/0x2520
[<ffffffff9807e1e8>] __do_page_fault+0x248/0x770
[<ffffffff9807e749>] do_page_fault+0x39/0xa0
[<ffffffff98f3a49f>] page_fault+0x1f/0x30
[<ffffffff980bf9fc>] mm_release+0x1ec/0x230
[<ffffffff980c9370>] do_exit+0x5d0/0x18c0
[<ffffffff980cce5c>] do_group_exit+0xac/0x190
[<ffffffff980e537f>] get_signal+0x48f/0xeb0
[<ffffffff9802ee40>] do_signal+0xa0/0xb50
[<ffffffff980023a9>] exit_to_usermode_loop+0xd9/0x100
[<ffffffff98004068>] do_syscall_64+0x238/0x2b0
[<ffffffff98f3881a>] return_from_SYSCALL_64+0x0/0x7a
[<ffffffffffffffff>] 0xffffffffffffffff

(14:16:09:davej@think:trinity[master])$ stack 18894
[<ffffffffc038d678>] btrfs_file_write_iter+0xe8/0x9a0 [btrfs]
[<ffffffff98387e69>] __vfs_write+0x279/0x2e0
[<ffffffff98389bfe>] vfs_write+0x11e/0x2b0
[<ffffffff9838c342>] SyS_write+0xd2/0x1a0
[<ffffffff98003f33>] do_syscall_64+0x103/0x2b0
[<ffffffff98f3881a>] return_from_SYSCALL_64+0x0/0x7a
[<ffffffffffffffff>] 0xffffffffffffffff

I tried to ftrace the latter process, and the box completely hung.

	Dave
