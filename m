Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:59000 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726730AbeHUV4t (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Aug 2018 17:56:49 -0400
Subject: Re: [PATCH 0/2] address lock contention of btree root
To: bo.liu@linux.alibaba.com
Cc: linux-btrfs@vger.kernel.org
References: <1534453645-17714-1-git-send-email-bo.liu@linux.alibaba.com>
 <5E5CC82C-57F8-4834-9630-B7DD7CA23C9E@fb.com>
 <20180821181521.nj4cxyjqt5fo5vng@US-160370MP2.local>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <ef175ddd-4e8a-04d4-5fcb-f339248155ab@applied-asynchrony.com>
Date: Tue, 21 Aug 2018 20:35:30 +0200
MIME-Version: 1.0
In-Reply-To: <20180821181521.nj4cxyjqt5fo5vng@US-160370MP2.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/21/18 20:15, Liu Bo wrote:
> I just realize that patch 2 can result in softlockup as
> btrfs_search_slot() may return a path with all nodes being in spinning
> lock, and if the callers want to sleep, we're in trouble.  I've
> removed patch 2 and am re-running the test (xfstests, fsmark and
> dbench).

You mean like this, when trying to balance? :)
Got it only once so far, subsequent attempts worked. Otherwise everything
seems fine.

-h

kernel: BTRFS info (device sdc1): relocating block group 4128424067072 flags data
kernel: BTRFS info (device sdc1): found 1706 extents
kernel: INFO: rcu_sched self-detected stall on CPU
kernel: ^I3-....: (17999 ticks this GP) idle=f5e/1/4611686018427387906 softirq=269430/269430 fqs=5999
kernel: ^I (t=18000 jiffies g=232869 c=232868 q=4365)
kernel: NMI backtrace for cpu 3
kernel: CPU: 3 PID: 4287 Comm: kworker/u8:0 Not tainted 4.18.3 #1
kernel: Hardware name: System manufacturer System Product Name/P8Z68-V LX, BIOS 4105 07/01/2013
kernel: Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
kernel: Call Trace:
kernel:  <IRQ>
kernel:  dump_stack+0x46/0x60
kernel:  nmi_cpu_backtrace.cold.0+0x13/0x57
kernel:  ? lapic_can_unplug_cpu.cold.5+0x34/0x34
kernel:  nmi_trigger_cpumask_backtrace+0x8f/0x91
kernel:  rcu_dump_cpu_stacks+0x87/0xb2
kernel:  rcu_check_callbacks.cold.59+0x2ac/0x430
kernel:  ? tick_sched_handle.isra.6+0x40/0x40
kernel:  update_process_times+0x28/0x60
kernel:  tick_sched_handle.isra.6+0x35/0x40
kernel:  tick_sched_timer+0x3b/0x80
kernel:  __hrtimer_run_queues+0xfe/0x270
kernel:  hrtimer_interrupt+0xf4/0x210
kernel:  smp_apic_timer_interrupt+0x56/0x110
kernel:  apic_timer_interrupt+0xf/0x20
kernel:  </IRQ>
kernel: RIP: 0010:queued_write_lock_slowpath+0x4a/0x80
kernel: Code: ff 00 00 00 f0 0f b1 13 85 c0 74 32 f0 81 03 00 01 00 00 ba ff 00 00 00 b9 00 01 00 00 8b 03 3d 00 01 00 00 74 0b f3 90 8b 03 <3d> 00 01 00 00 75 f5 89 c8 f0 0f b1 13 3d 00 01 00 00 75 df c6 43
kernel: RSP: 0018:ffffc9000040fc40 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
kernel: RAX: 0000000000000300 RBX: ffff88071abf86f0 RCX: 0000000000000100
kernel: RDX: 00000000000000ff RSI: ffff880000000000 RDI: ffff88071abf86f0
kernel: RBP: 0000000000000000 R08: ffff88071abf8690 R09: ffff880724ebeb58
kernel: R10: ffff880724ebeb80 R11: 0000000000000000 R12: 0000000000000001
kernel: R13: ffff8803d0db5f54 R14: 0000160000000000 R15: 0000000000000006
kernel:  btrfs_try_tree_write_lock+0x23/0x60 [btrfs]
kernel:  btrfs_search_slot+0x2df/0x970 [btrfs]
kernel:  btrfs_mark_extent_written+0xb0/0xac0 [btrfs]
kernel:  ? kmem_cache_alloc+0x1a5/0x1b0
kernel:  btrfs_finish_ordered_io+0x2e2/0x7a0 [btrfs]
kernel:  normal_work_helper+0xad/0x2c0 [btrfs]
kernel:  process_one_work+0x1e3/0x390
kernel:  worker_thread+0x2d/0x3c0
kernel:  ? process_one_work+0x390/0x390
kernel:  kthread+0x111/0x130
kernel:  ? kthread_flush_work_fn+0x10/0x10
kernel:  ret_from_fork+0x1f/0x30
