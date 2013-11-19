Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from detritus.pyropus.ca ([64.5.53.58]:60312 "HELO
	detritus.pyropus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751628Ab3KSDEw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Nov 2013 22:04:52 -0500
Date: Mon, 18 Nov 2013 21:00:45 -0600
From: Charles Cazabon <charlesc-lists-btrfs@pyropus.ca>
To: btrfs list <linux-btrfs@vger.kernel.org>
Subject: linux-stable 3.11.8 oopses
Message-ID: <20131119030045.GA27334@pyropus.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Greetings,

This is more of just a report than anything else.  I run linux-stable, and
while btrfs in 3.11.7 seemed fine, I've had oopses ever since installating
3.11.8.  The server is not under heavy load when it happens, and it happens
fairly shortly after a clean boot.

The oopses all look like the following; here's a representative couple.

INFO: task btrfs-transacti:2103 blocked for more than 120 seconds.
btrfs-transacti D c1089143 0 2103 2 0x00000000
d2391e80 00000046 d2391e60 c1089143 00000002 f74a1980 c198a100 9204095a
000002b7 c198a100 f7bd7100 efbfa640 f74a1980 d2391e58 c10113a7 f7bd7148
00000000 00000002 efbfa960 d2391e60 c107a391 00000000 d1009a80 d1009bd0
Call Trace:
[<c1089143>] ? idle_balance+0x2a3/0x3b0
[<c10113a7>] ? __switch_to+0xc7/0x340
[<c107a391>] ? finish_task_switch+0x41/0xc0
[<c114c616>] ? kmem_cache_alloc+0xe6/0x100
[<f865d050>] ? btrfs_free_path+0x20/0x30 [btrfs]
[<c15e7e13>] schedule+0x23/0x60
[<c15e64b5>] schedule_timeout+0x1d5/0x240
[<c15e8b1d>] ? _raw_spin_lock+0xd/0x10
[<f869dc40>] ? btrfs_run_ordered_operations+0x270/0x2b0 [btrfs]
[<c103e628>] ? default_spin_lock_flags+0x8/0x10
[<c15e8cbf>] ? _raw_spin_lock_irqsave+0x2f/0x50
[<c106d418>] ? prepare_to_wait+0x48/0x70
[<f868418c>] btrfs_commit_transaction+0x34c/0xa50 [btrfs]
[<f8684cc4>] ? start_transaction+0x84/0x4a0 [btrfs]
[<c105aaa0>] ? cascade+0x130/0x130
[<c106d1b0>] ? wake_up_bit+0x30/0x30
[<f867d0d9>] transaction_kthread+0x169/0x1f0 [btrfs]
[<f867cf70>] ? btrfs_destroy_marked_extents.clone.96.clone.119+0x1e0/0x1e0
[btrfs]
[<c106ca0c>] kthread+0x9c/0xa0
[<c1070000>] ? run_posix_cpu_timers+0x360/0x820
[<c15efef7>] ret_from_kernel_thread+0x1b/0x28
[<c106c970>] ? flush_kthread_worker+0xb0/0xb0



INFO: task btrfs-transacti:2103 blocked for more than 120 seconds.
btrfs-transacti D c1089143 0 2103 2 0x00000000
d2391e80 00000046 d2391e60 c1089143 00000002 f74a1980 c198a100 9204095a
000002b7 c198a100 f7bd7100 efbfa640 f74a1980 d2391e58 c10113a7 f7bd7148
00000000 00000002 efbfa960 d2391e60 c107a391 00000000 d1009a80 d1009bd0
Call Trace:
[<c1089143>] ? idle_balance+0x2a3/0x3b0
[<c10113a7>] ? __switch_to+0xc7/0x340
[<c107a391>] ? finish_task_switch+0x41/0xc0
[<c114c616>] ? kmem_cache_alloc+0xe6/0x100
[<f865d050>] ? btrfs_free_path+0x20/0x30 [btrfs]
[<c15e7e13>] schedule+0x23/0x60
[<c15e64b5>] schedule_timeout+0x1d5/0x240
[<c15e8b1d>] ? _raw_spin_lock+0xd/0x10
[<f869dc40>] ? btrfs_run_ordered_operations+0x270/0x2b0 [btrfs]
[<c103e628>] ? default_spin_lock_flags+0x8/0x10
[<c15e8cbf>] ? _raw_spin_lock_irqsave+0x2f/0x50
[<c106d418>] ? prepare_to_wait+0x48/0x70
[<f868418c>] btrfs_commit_transaction+0x34c/0xa50 [btrfs]
[<f8684cc4>] ? start_transaction+0x84/0x4a0 [btrfs]
[<c105aaa0>] ? cascade+0x130/0x130
[<c106d1b0>] ? wake_up_bit+0x30/0x30
[<f867d0d9>] transaction_kthread+0x169/0x1f0 [btrfs]
[<f867cf70>] ? btrfs_destroy_marked_extents.clone.96.clone.119+0x1e0/0x1e0
[btrfs]
[<c106ca0c>] kthread+0x9c/0xa0
[<c1070000>] ? run_posix_cpu_timers+0x360/0x820
[<c15efef7>] ret_from_kernel_thread+0x1b/0x28
[<c106c970>] ? flush_kthread_worker+0xb0/0xb0


This is on x86_64, server-class hardware (ECC memory, etc).  I ran a scrub
overnight that reported no errors, and I'll do it again now that I've reverted
to 3.11.7.

Is there any other info that might be useful to the btrfs devs about this?

Charles
-- 
-----------------------------------------------------------------------
Charles Cazabon
GPL'ed software available at:               http://pyropus.ca/software/
-----------------------------------------------------------------------
