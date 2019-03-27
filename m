Return-Path: <SRS0=arzm=R6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33770C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 02:37:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D85C420811
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 02:37:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732733AbfC0ChK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Mar 2019 22:37:10 -0400
Received: from james.kirk.hungrycats.org ([174.142.39.145]:41406 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727452AbfC0ChK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Mar 2019 22:37:10 -0400
Received: by james.kirk.hungrycats.org (Postfix, from userid 1002)
        id 77F4527F119; Tue, 26 Mar 2019 22:37:07 -0400 (EDT)
Date:   Tue, 26 Mar 2019 22:37:06 -0400
From:   Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To:     linux-btrfs@vger.kernel.org
Subject: Re: A collection of btrfs lockup stack traces (4.14.106, no
 __sb_start_write)
Message-ID: <20190327023703.GM16651@hungrycats.org>
References: <20190320033957.GA16651@hungrycats.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190320033957.GA16651@hungrycats.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 19, 2019 at 11:39:59PM -0400, Zygo Blaxell wrote:
> I haven't been able to easily reproduce these in a test environment;
> however, they have been happening several times a year on servers in
> production.
> 
> Kernel:  most recent observation on 4.14.105 + cherry-picked deadlock
> and misc hang fixes:
> 
> 	btrfs: wakeup cleaner thread when adding delayed iput
> 	Btrfs: fix deadlock when allocating tree block during leaf/node split
> 	Btrfs: use nofs context when initializing security xattrs to avoid deadlock
> 	Btrfs: fix deadlock with memory reclaim during scrub
> 	Btrfs: fix deadlock between clone/dedupe and rename
> 
> Also observed on 4.20.13, and 4.14.0..4.14.105 (4.14.106 is currently
> running, but hasn't locked up yet).
> 
> Filesystem mount flags:  compress=zstd,ssd,flushoncommit,space_cache=v2.
> Configuration is either -draid1/-mraid1 or -dsingle/-mraid1.  I've
> also reproduced a lockup without flushoncommit.
> 
> The machines that are locking up all run the same workload:
> 
> 	rsync receiving data continuously (gigabytes aren't enough,
> 	I can barely reproduce this once a month with 2TB of rsync
> 	traffic from 10 simulated clients)
> 
> 	bees doing continuous dedupe
> 
> 	snapshots daily and after each rsync
> 
> 	snapshot deletes as required to maintain free space
> 
> 	scrubs twice monthly plus after each crash
> 
> 	watchdog does a 'mkdir foo; rmdir foo' every few seconds.
> 	If this takes longer than 50 minutes, collect a stack trace;
> 	longer than 60 minutes, reboot the machine.
> 
[...]

> Here's a recent lockup example with lockdep output, from 4.14.105 with
> the cherry-picked patches above:

The above had __sb_start_write in the call stack, which occurs in 7 out of 15
call traces on one machine:

> [Fri Mar 15 21:53:36 2019] crawl_294       D    0 20349  31220 0x00000000
> [Fri Mar 15 21:53:36 2019] Call Trace:
> [Fri Mar 15 21:53:36 2019]  ? __schedule+0x429/0xbb0
> [Fri Mar 15 21:53:36 2019]  ? rwsem_down_write_failed+0x134/0x2b0
> [Fri Mar 15 21:53:36 2019]  schedule+0x39/0x90
> [Fri Mar 15 21:53:36 2019]  rwsem_down_write_failed+0x139/0x2b0
> [Fri Mar 15 21:53:36 2019]  ? call_rwsem_down_write_failed+0x13/0x20
> [Fri Mar 15 21:53:36 2019]  call_rwsem_down_write_failed+0x13/0x20
> [Fri Mar 15 21:53:36 2019]  down_write_nested+0x87/0xb0
> [Fri Mar 15 21:53:36 2019]  btrfs_dedupe_file_range+0x8e/0x660
> [Fri Mar 15 21:53:36 2019]  ? rcu_read_lock_sched_held+0x68/0x70
> [Fri Mar 15 21:53:36 2019]  ? rcu_sync_lockdep_assert+0x30/0x60
> [Fri Mar 15 21:53:36 2019]  ? __sb_start_write+0xcc/0x1b0
> [Fri Mar 15 21:53:36 2019]  ? mnt_want_write_file+0x3b/0xb0
> [Fri Mar 15 21:53:36 2019]  vfs_dedupe_file_range+0x22e/0x280
> [Fri Mar 15 21:53:36 2019]  do_vfs_ioctl+0x24d/0x6b0
> [Fri Mar 15 21:53:36 2019]  ? __fget+0x11f/0x210
> [Fri Mar 15 21:53:36 2019]  SyS_ioctl+0x74/0x80
> [Fri Mar 15 21:53:36 2019]  do_syscall_64+0x76/0x180
> [Fri Mar 15 21:53:36 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
> [Fri Mar 15 21:53:36 2019] RIP: 0033:0x7fd690048dd7
> [Fri Mar 15 21:53:36 2019] RSP: 002b:00007fd687ffc0a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> [Fri Mar 15 21:53:36 2019] RAX: ffffffffffffffda RBX: 00007fd568332780 RCX: 00007fd690048dd7
> [Fri Mar 15 21:53:36 2019] RDX: 00007fd568332780 RSI: 00000000c0189436 RDI: 0000000000000067
> [Fri Mar 15 21:53:36 2019] RBP: 00007fd687ffc420 R08: 00007fd56804c940 R09: 0000000000000000
> [Fri Mar 15 21:53:36 2019] R10: 00007fd568022ed0 R11: 0000000000000246 R12: 0000000000000020
> [Fri Mar 15 21:53:36 2019] R13: 0000000000000018 R14: 00007fd56804c958 R15: 00007fd687ffc428

Here's an example of a deadlock on 4.14.106 that doesn't call
__sb_start_write:

	[Sat Mar 23 06:13:07 2019] sysrq: SysRq : Show Blocked State
	[Sat Mar 23 06:13:07 2019]   task                        PC stack   pid father
	[Sat Mar 23 06:13:07 2019] btrfs-transacti D    0 28857      2 0x80000000
	[Sat Mar 23 06:13:07 2019] Call Trace:
	[Sat Mar 23 06:13:07 2019]  ? __schedule+0x429/0xbb0
	[Sat Mar 23 06:13:07 2019]  schedule+0x39/0x90
	[Sat Mar 23 06:13:07 2019]  schedule_timeout+0x20f/0x590
	[Sat Mar 23 06:13:07 2019]  ? lock_acquire+0xbc/0x200
	[Sat Mar 23 06:13:07 2019]  ? wait_for_common+0x3c/0x1f0
	[Sat Mar 23 06:13:07 2019]  ? wait_for_common+0x131/0x1f0
	[Sat Mar 23 06:13:07 2019]  wait_for_common+0x131/0x1f0
	[Sat Mar 23 06:13:07 2019]  ? wake_up_q+0x70/0x70
	[Sat Mar 23 06:13:07 2019]  __start_delalloc_inodes+0x22f/0x320
	[Sat Mar 23 06:13:07 2019]  btrfs_start_delalloc_roots+0x1cd/0x380
	[Sat Mar 23 06:13:07 2019]  btrfs_commit_transaction+0x807/0xa20
	[Sat Mar 23 06:13:07 2019]  ? start_transaction+0x89/0x4d0
	[Sat Mar 23 06:13:07 2019]  transaction_kthread+0x194/0x1d0
	[Sat Mar 23 06:13:07 2019]  kthread+0x10d/0x140
	[Sat Mar 23 06:13:07 2019]  ? btrfs_cleanup_transaction+0x650/0x650
	[Sat Mar 23 06:13:07 2019]  ? kthread_create_on_node+0x40/0x40
	[Sat Mar 23 06:13:07 2019]  ret_from_fork+0x27/0x50
	[Sat Mar 23 06:13:07 2019] crawl_writeback D    0 10240   9418 0x00000000
	[Sat Mar 23 06:13:07 2019] Call Trace:
	[Sat Mar 23 06:13:07 2019]  ? __schedule+0x429/0xbb0
	[Sat Mar 23 06:13:07 2019]  ? prepare_to_wait_event+0x97/0x190
	[Sat Mar 23 06:13:07 2019]  schedule+0x39/0x90
	[Sat Mar 23 06:13:07 2019]  wait_current_trans+0xa3/0xf0
	[Sat Mar 23 06:13:07 2019]  ? wait_woken+0xa0/0xa0
	[Sat Mar 23 06:13:07 2019]  start_transaction+0x29b/0x4d0
	[Sat Mar 23 06:13:07 2019]  btrfs_create+0x47/0x1d0
	[Sat Mar 23 06:13:07 2019]  lookup_open+0x404/0x760
	[Sat Mar 23 06:13:07 2019]  path_openat+0x4e9/0xcc0
	[Sat Mar 23 06:13:07 2019]  do_filp_open+0x8a/0xf0
	[Sat Mar 23 06:13:07 2019]  ? __alloc_fd+0x34/0x200
	[Sat Mar 23 06:13:07 2019]  ? expand_files+0x3a/0x2a0
	[Sat Mar 23 06:13:07 2019]  ? do_sys_open+0x130/0x200
	[Sat Mar 23 06:13:07 2019]  do_sys_open+0x130/0x200
	[Sat Mar 23 06:13:07 2019]  do_syscall_64+0x76/0x180
	[Sat Mar 23 06:13:07 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
	[Sat Mar 23 06:13:07 2019] RIP: 0033:0x7fbb538ab607
	[Sat Mar 23 06:13:07 2019] RSP: 002b:00007fbb497f8cc0 EFLAGS: 00000293 ORIG_RAX: 0000000000000101
	[Sat Mar 23 06:13:07 2019] RAX: ffffffffffffffda RBX: 00000000000e09c1 RCX: 00007fbb538ab607
	[Sat Mar 23 06:13:07 2019] RDX: 00000000000e09c1 RSI: 00007fba300008f0 RDI: 0000000000000003
	[Sat Mar 23 06:13:07 2019] RBP: 0000000000000003 R08: 0000000000000000 R09: 00007fbb497f9080
	[Sat Mar 23 06:13:07 2019] R10: 0000000000000180 R11: 0000000000000293 R12: 00007fba300008f0
	[Sat Mar 23 06:13:07 2019] R13: 0000000000000003 R14: 00007fbb497f93d0 R15: 00007fbb497f9350
	[Sat Mar 23 06:13:07 2019] crawl_61509     D    0 27096   9418 0x00000000
	[Sat Mar 23 06:13:07 2019] Call Trace:
	[Sat Mar 23 06:13:07 2019]  ? __schedule+0x429/0xbb0
	[Sat Mar 23 06:13:07 2019]  ? prepare_to_wait_event+0x97/0x190
	[Sat Mar 23 06:13:07 2019]  schedule+0x39/0x90
	[Sat Mar 23 06:13:07 2019]  wait_current_trans+0xa3/0xf0
	[Sat Mar 23 06:13:07 2019]  ? wait_woken+0xa0/0xa0
	[Sat Mar 23 06:13:07 2019]  start_transaction+0x29b/0x4d0
	[Sat Mar 23 06:13:07 2019]  btrfs_clone+0x5a3/0xcc0
	[Sat Mar 23 06:13:07 2019]  btrfs_dedupe_file_range+0x5e3/0x660
	[Sat Mar 23 06:13:07 2019]  vfs_dedupe_file_range+0x22e/0x280
	[Sat Mar 23 06:13:07 2019]  do_vfs_ioctl+0x24d/0x6b0
	[Sat Mar 23 06:13:07 2019]  ? __fget+0x11f/0x210
	[Sat Mar 23 06:13:07 2019]  SyS_ioctl+0x74/0x80
	[Sat Mar 23 06:13:07 2019]  do_syscall_64+0x76/0x180
	[Sat Mar 23 06:13:07 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
	[Sat Mar 23 06:13:07 2019] RIP: 0033:0x7fbb538b0dd7
	[Sat Mar 23 06:13:07 2019] RSP: 002b:00007fbb51fc90a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
	[Sat Mar 23 06:13:07 2019] RAX: ffffffffffffffda RBX: 00007fba18b67e40 RCX: 00007fbb538b0dd7
	[Sat Mar 23 06:13:07 2019] RDX: 00007fba18b67e40 RSI: 00000000c0189436 RDI: 0000000000000752
	[Sat Mar 23 06:13:07 2019] RBP: 00007fbb51fc9420 R08: 00007fba18405480 R09: 0000000000000000
	[Sat Mar 23 06:13:07 2019] R10: 00007fba19e4e0e0 R11: 0000000000000246 R12: 0000000000000020
	[Sat Mar 23 06:13:07 2019] R13: 0000000000000018 R14: 00007fba18405498 R15: 00007fbb51fc9428
	[Sat Mar 23 06:13:07 2019] sysrq: SysRq : Show Locks Held
	[Sat Mar 23 06:13:07 2019] crawl_61509     D
	[Sat Mar 23 06:13:07 2019] INFO: lockdep is turned off.
	[Sat Mar 23 06:13:07 2019]     0  2421   9418 0x00000000
	[Sat Mar 23 06:13:07 2019] Call Trace:
	[Sat Mar 23 06:13:07 2019]  ? __schedule+0x429/0xbb0
	[Sat Mar 23 06:13:07 2019]  ? prepare_to_wait_event+0x97/0x190
	[Sat Mar 23 06:13:07 2019]  schedule+0x39/0x90
	[Sat Mar 23 06:13:07 2019]  wait_current_trans+0xa3/0xf0
	[Sat Mar 23 06:13:07 2019]  ? wait_woken+0xa0/0xa0
	[Sat Mar 23 06:13:07 2019]  start_transaction+0x29b/0x4d0
	[Sat Mar 23 06:13:07 2019]  btrfs_clone+0x5a3/0xcc0
	[Sat Mar 23 06:13:07 2019]  btrfs_dedupe_file_range+0x5e3/0x660
	[Sat Mar 23 06:13:07 2019]  vfs_dedupe_file_range+0x22e/0x280
	[Sat Mar 23 06:13:07 2019]  do_vfs_ioctl+0x24d/0x6b0
	[Sat Mar 23 06:13:07 2019]  ? __fget+0x11f/0x210
	[Sat Mar 23 06:13:07 2019]  SyS_ioctl+0x74/0x80
	[Sat Mar 23 06:13:07 2019]  do_syscall_64+0x76/0x180
	[Sat Mar 23 06:13:07 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
	[Sat Mar 23 06:13:07 2019] RIP: 0033:0x7fbb538b0dd7
	[Sat Mar 23 06:13:07 2019] RSP: 002b:00007fbb527c9ac8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
	[Sat Mar 23 06:13:07 2019] RAX: ffffffffffffffda RBX: 00007fba2e672370 RCX: 00007fbb538b0dd7
	[Sat Mar 23 06:13:07 2019] RDX: 00007fba2e672370 RSI: 00000000c0189436 RDI: 000000000000074d
	[Sat Mar 23 06:13:07 2019] RBP: 00007fbb527c9e40 R08: 00007fba2dcb3970 R09: 0000000000000000
	[Sat Mar 23 06:13:07 2019] R10: 00007fba2d008300 R11: 0000000000000246 R12: 0000000000000020
	[Sat Mar 23 06:13:07 2019] R13: 0000000000000018 R14: 00007fba2dcb3988 R15: 00007fbb527c9e48
	[Sat Mar 23 06:13:07 2019] crawl_61509     D    0 17948   9418 0x00000000
	[Sat Mar 23 06:13:07 2019] Call Trace:
	[Sat Mar 23 06:13:07 2019]  ? __schedule+0x429/0xbb0
	[Sat Mar 23 06:13:07 2019]  ? prepare_to_wait_event+0x97/0x190
	[Sat Mar 23 06:13:07 2019]  schedule+0x39/0x90
	[Sat Mar 23 06:13:07 2019]  wait_current_trans+0xa3/0xf0
	[Sat Mar 23 06:13:07 2019]  ? wait_woken+0xa0/0xa0
	[Sat Mar 23 06:13:07 2019]  start_transaction+0x29b/0x4d0
	[Sat Mar 23 06:13:07 2019]  btrfs_clone+0x5a3/0xcc0
	[Sat Mar 23 06:13:07 2019]  btrfs_dedupe_file_range+0x5e3/0x660
	[Sat Mar 23 06:13:07 2019]  vfs_dedupe_file_range+0x22e/0x280
	[Sat Mar 23 06:13:07 2019]  do_vfs_ioctl+0x24d/0x6b0
	[Sat Mar 23 06:13:07 2019]  ? __fget+0x11f/0x210
	[Sat Mar 23 06:13:07 2019]  SyS_ioctl+0x74/0x80
	[Sat Mar 23 06:13:07 2019]  do_syscall_64+0x76/0x180
	[Sat Mar 23 06:13:07 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
	[Sat Mar 23 06:13:07 2019] RIP: 0033:0x7fbb538b0dd7
	[Sat Mar 23 06:13:07 2019] RSP: 002b:00007fbb50fc6ac8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
	[Sat Mar 23 06:13:07 2019] RAX: ffffffffffffffda RBX: 00007fba34402eb0 RCX: 00007fbb538b0dd7
	[Sat Mar 23 06:13:07 2019] RDX: 00007fba34402eb0 RSI: 00000000c0189436 RDI: 00000000000006fb
	[Sat Mar 23 06:13:07 2019] RBP: 00007fbb50fc6e40 R08: 00007fba3428f630 R09: 0000000000000000
	[Sat Mar 23 06:13:07 2019] R10: 00007fba361733c0 R11: 0000000000000246 R12: 0000000000000020
	[Sat Mar 23 06:13:07 2019] R13: 0000000000000018 R14: 00007fba3428f648 R15: 00007fbb50fc6e48
	[Sat Mar 23 06:13:07 2019] crawl_61509     D    0 17949   9418 0x00000000
	[Sat Mar 23 06:13:07 2019] Call Trace:
	[Sat Mar 23 06:13:07 2019]  ? __schedule+0x429/0xbb0
	[Sat Mar 23 06:13:07 2019]  ? prepare_to_wait_event+0x97/0x190
	[Sat Mar 23 06:13:07 2019]  schedule+0x39/0x90
	[Sat Mar 23 06:13:07 2019]  wait_current_trans+0xa3/0xf0
	[Sat Mar 23 06:13:07 2019]  ? wait_woken+0xa0/0xa0
	[Sat Mar 23 06:13:07 2019]  start_transaction+0x29b/0x4d0
	[Sat Mar 23 06:13:07 2019]  btrfs_clone+0x5a3/0xcc0
	[Sat Mar 23 06:13:07 2019]  btrfs_dedupe_file_range+0x5e3/0x660
	[Sat Mar 23 06:13:07 2019]  vfs_dedupe_file_range+0x22e/0x280
	[Sat Mar 23 06:13:07 2019]  do_vfs_ioctl+0x24d/0x6b0
	[Sat Mar 23 06:13:07 2019]  ? __fget+0x11f/0x210
	[Sat Mar 23 06:13:07 2019]  SyS_ioctl+0x74/0x80
	[Sat Mar 23 06:13:07 2019]  do_syscall_64+0x76/0x180
	[Sat Mar 23 06:13:07 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
	[Sat Mar 23 06:13:07 2019] RIP: 0033:0x7fbb538b0dd7
	[Sat Mar 23 06:13:07 2019] RSP: 002b:00007fbb4b7fb0a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
	[Sat Mar 23 06:13:07 2019] RAX: ffffffffffffffda RBX: 00007fba1e1f8870 RCX: 00007fbb538b0dd7
	[Sat Mar 23 06:13:07 2019] RDX: 00007fba1e1f8870 RSI: 00000000c0189436 RDI: 0000000000000754
	[Sat Mar 23 06:13:07 2019] RBP: 00007fbb4b7fb420 R08: 00007fba1e25cc60 R09: 0000000000000000
	[Sat Mar 23 06:13:07 2019] R10: 00007fba1dbcb0c0 R11: 0000000000000246 R12: 0000000000000020
	[Sat Mar 23 06:13:07 2019] R13: 0000000000000018 R14: 00007fba1e25cc78 R15: 00007fbb4b7fb428
	[Sat Mar 23 06:13:07 2019] crawl_61509     D    0 18445   9418 0x00000000
	[Sat Mar 23 06:13:07 2019] Call Trace:
	[Sat Mar 23 06:13:07 2019]  ? __schedule+0x429/0xbb0
	[Sat Mar 23 06:13:07 2019]  ? prepare_to_wait_event+0x97/0x190
	[Sat Mar 23 06:13:07 2019]  schedule+0x39/0x90
	[Sat Mar 23 06:13:07 2019]  wait_current_trans+0xa3/0xf0
	[Sat Mar 23 06:13:07 2019]  ? wait_woken+0xa0/0xa0
	[Sat Mar 23 06:13:07 2019]  start_transaction+0x29b/0x4d0
	[Sat Mar 23 06:13:07 2019]  btrfs_clone+0x5a3/0xcc0
	[Sat Mar 23 06:13:07 2019]  btrfs_dedupe_file_range+0x5e3/0x660
	[Sat Mar 23 06:13:07 2019]  vfs_dedupe_file_range+0x22e/0x280
	[Sat Mar 23 06:13:07 2019]  do_vfs_ioctl+0x24d/0x6b0
	[Sat Mar 23 06:13:07 2019]  ? __fget+0x11f/0x210
	[Sat Mar 23 06:13:07 2019]  SyS_ioctl+0x74/0x80
	[Sat Mar 23 06:13:07 2019]  do_syscall_64+0x76/0x180
	[Sat Mar 23 06:13:07 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
	[Sat Mar 23 06:13:07 2019] RIP: 0033:0x7fbb538b0dd7
	[Sat Mar 23 06:13:07 2019] RSP: 002b:00007fbb4bffc0a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
	[Sat Mar 23 06:13:07 2019] RAX: ffffffffffffffda RBX: 00007fba200fb8c0 RCX: 00007fbb538b0dd7
	[Sat Mar 23 06:13:07 2019] RDX: 00007fba200fb8c0 RSI: 00000000c0189436 RDI: 0000000000000753
	[Sat Mar 23 06:13:07 2019] RBP: 00007fbb4bffc420 R08: 00007fba21a8c680 R09: 0000000000000000
	[Sat Mar 23 06:13:07 2019] R10: 00007fba20736910 R11: 0000000000000246 R12: 0000000000000020
	[Sat Mar 23 06:13:07 2019] R13: 0000000000000018 R14: 00007fba21a8c698 R15: 00007fbb4bffc428
	[Sat Mar 23 06:13:07 2019] rsync           D    0  1718   8245 0x00000000
	[Sat Mar 23 06:13:07 2019] Call Trace:
	[Sat Mar 23 06:13:07 2019]  ? __schedule+0x429/0xbb0
	[Sat Mar 23 06:13:07 2019]  ? prepare_to_wait_event+0x97/0x190
	[Sat Mar 23 06:13:07 2019]  schedule+0x39/0x90
	[Sat Mar 23 06:13:07 2019]  wait_current_trans+0xa3/0xf0
	[Sat Mar 23 06:13:07 2019]  ? wait_woken+0xa0/0xa0
	[Sat Mar 23 06:13:07 2019]  start_transaction+0x29b/0x4d0
	[Sat Mar 23 06:13:07 2019]  btrfs_setattr+0x1e6/0x3b0
	[Sat Mar 23 06:13:07 2019]  notify_change+0x2ed/0x450
	[Sat Mar 23 06:13:07 2019]  do_truncate+0x5e/0x90
	[Sat Mar 23 06:13:07 2019]  do_sys_ftruncate.constprop.1+0x120/0x180
	[Sat Mar 23 06:13:07 2019]  ? trace_hardirqs_off_thunk+0x1a/0x1c
	[Sat Mar 23 06:13:07 2019]  do_syscall_64+0x76/0x180
	[Sat Mar 23 06:13:07 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
	[Sat Mar 23 06:13:07 2019] RIP: 0033:0x7f105ec2ac87
	[Sat Mar 23 06:13:07 2019] RSP: 002b:00007fff425b6b38 EFLAGS: 00000246 ORIG_RAX: 000000000000004d
	[Sat Mar 23 06:13:07 2019] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f105ec2ac87
	[Sat Mar 23 06:13:07 2019] RDX: 0000000000000000 RSI: 0000000000f04e27 RDI: 0000000000000004
	[Sat Mar 23 06:13:07 2019] RBP: 0000000000000004 R08: 0000000000000000 R09: 00007f105ec757b8
	[Sat Mar 23 06:13:07 2019] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000f04e27
	[Sat Mar 23 06:13:07 2019] R13: 0000000000005bbf R14: 0000000000000f78 R15: 0000000000000005
	[Sat Mar 23 06:13:07 2019] kworker/u8:8    D    0 22026      2 0x80000000
	[Sat Mar 23 06:13:07 2019] Workqueue: btrfs-flush_delalloc btrfs_flush_delalloc_helper
	[Sat Mar 23 06:13:07 2019] Call Trace:
	[Sat Mar 23 06:13:07 2019]  ? __schedule+0x429/0xbb0
	[Sat Mar 23 06:13:07 2019]  schedule+0x39/0x90
	[Sat Mar 23 06:13:07 2019]  io_schedule+0x12/0x40
	[Sat Mar 23 06:13:07 2019]  __lock_page+0x110/0x140
	[Sat Mar 23 06:13:07 2019]  ? add_to_page_cache_lru+0xc0/0xc0
	[Sat Mar 23 06:13:07 2019]  extent_write_cache_pages.constprop.27+0x2d9/0x3b0
	[Sat Mar 23 06:13:07 2019]  ? lock_acquire+0xbc/0x200
	[Sat Mar 23 06:13:07 2019]  extent_writepages+0x4e/0x70
	[Sat Mar 23 06:13:07 2019]  ? btrfs_direct_IO+0x3e0/0x3e0
	[Sat Mar 23 06:13:07 2019]  do_writepages+0x23/0x80
	[Sat Mar 23 06:13:07 2019]  __filemap_fdatawrite_range+0xaa/0xe0
	[Sat Mar 23 06:13:07 2019]  btrfs_run_delalloc_work+0x17/0x60
	[Sat Mar 23 06:13:07 2019]  btrfs_scrubparity_helper+0x8f/0x640
	[Sat Mar 23 06:13:07 2019]  process_one_work+0x204/0x650
	[Sat Mar 23 06:13:07 2019]  worker_thread+0x4d/0x3b0
	[Sat Mar 23 06:13:07 2019]  kthread+0x10d/0x140
	[Sat Mar 23 06:13:07 2019]  ? process_one_work+0x650/0x650
	[Sat Mar 23 06:13:07 2019]  ? kthread_create_on_node+0x40/0x40
	[Sat Mar 23 06:13:07 2019]  ret_from_fork+0x27/0x50
	[Sat Mar 23 06:13:07 2019] rsync           D    0 10508  10507 0x00000000
	[Sat Mar 23 06:13:07 2019] Call Trace:
	[Sat Mar 23 06:13:07 2019]  ? __schedule+0x429/0xbb0
	[Sat Mar 23 06:13:07 2019]  ? prepare_to_wait_event+0x97/0x190
	[Sat Mar 23 06:13:07 2019]  schedule+0x39/0x90
	[Sat Mar 23 06:13:07 2019]  wait_current_trans+0xa3/0xf0
	[Sat Mar 23 06:13:07 2019]  ? wait_woken+0xa0/0xa0
	[Sat Mar 23 06:13:07 2019]  start_transaction+0x29b/0x4d0
	[Sat Mar 23 06:13:07 2019]  btrfs_create+0x47/0x1d0
	[Sat Mar 23 06:13:07 2019]  lookup_open+0x404/0x760
	[Sat Mar 23 06:13:07 2019]  path_openat+0x4e9/0xcc0
	[Sat Mar 23 06:13:07 2019]  ? __might_fault+0x3e/0x90
	[Sat Mar 23 06:13:07 2019]  do_filp_open+0x8a/0xf0
	[Sat Mar 23 06:13:07 2019]  ? __alloc_fd+0x34/0x200
	[Sat Mar 23 06:13:07 2019]  ? expand_files+0x3a/0x2a0
	[Sat Mar 23 06:13:07 2019]  ? do_sys_open+0x130/0x200
	[Sat Mar 23 06:13:07 2019]  do_sys_open+0x130/0x200
	[Sat Mar 23 06:13:07 2019]  do_syscall_64+0x76/0x180
	[Sat Mar 23 06:13:07 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
	[Sat Mar 23 06:13:07 2019] RIP: 0033:0x7f35b016b4b0
	[Sat Mar 23 06:13:07 2019] RSP: 002b:00007ffd7c166a28 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
	[Sat Mar 23 06:13:07 2019] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f35b016b4b0
	[Sat Mar 23 06:13:07 2019] RDX: 0000000000000180 RSI: 00000000000000c2 RDI: 00007ffd7c168c90
	[Sat Mar 23 06:13:07 2019] RBP: 000000000003a2f8 R08: 000000000000c0ff R09: 00007f35b01bdf10
	[Sat Mar 23 06:13:07 2019] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffd7c168ca3
	[Sat Mar 23 06:13:07 2019] R13: 8421084210842109 R14: 00000000000000c2 R15: 00007f35b01f9320
	[Sat Mar 23 06:13:07 2019] mkdir           D    0 11463  11460 0x00000000
	[Sat Mar 23 06:13:07 2019] Call Trace:
	[Sat Mar 23 06:13:07 2019]  ? __schedule+0x429/0xbb0
	[Sat Mar 23 06:13:07 2019]  ? prepare_to_wait_event+0x97/0x190
	[Sat Mar 23 06:13:07 2019]  schedule+0x39/0x90
	[Sat Mar 23 06:13:07 2019]  wait_current_trans+0xa3/0xf0
	[Sat Mar 23 06:13:07 2019]  ? wait_woken+0xa0/0xa0
	[Sat Mar 23 06:13:07 2019]  start_transaction+0x29b/0x4d0
	[Sat Mar 23 06:13:07 2019]  btrfs_mkdir+0x50/0x1d0
	[Sat Mar 23 06:13:07 2019]  vfs_mkdir+0x134/0x1c0
	[Sat Mar 23 06:13:07 2019]  SyS_mkdirat+0xb3/0xf0
	[Sat Mar 23 06:13:07 2019]  do_syscall_64+0x76/0x180
	[Sat Mar 23 06:13:07 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
	[Sat Mar 23 06:13:07 2019] RIP: 0033:0x7f09ce6ab447
	[Sat Mar 23 06:13:07 2019] RSP: 002b:00007ffc0d353648 EFLAGS: 00000206 ORIG_RAX: 0000000000000053
	[Sat Mar 23 06:13:07 2019] RAX: ffffffffffffffda RBX: 00007ffc0d354b28 RCX: 00007f09ce6ab447
	[Sat Mar 23 06:13:07 2019] RDX: 0000000000000000 RSI: 00000000000001ff RDI: 00007ffc0d354b4d
	[Sat Mar 23 06:13:07 2019] RBP: 00007ffc0d3537c0 R08: 00000000000001ff R09: 000055d022f36e10
	[Sat Mar 23 06:13:07 2019] R10: 0000000000000376 R11: 0000000000000206 R12: 000055d022f36e50
	[Sat Mar 23 06:13:07 2019] R13: 00000000000001ff R14: 00007ffc0d353960 R15: 0000000000000001
	[Sat Mar 23 06:13:07 2019] rsync           D    0 17989  17923 0x00000000
	[Sat Mar 23 06:13:07 2019] Call Trace:
	[Sat Mar 23 06:13:07 2019]  ? __schedule+0x429/0xbb0
	[Sat Mar 23 06:13:07 2019]  ? prepare_to_wait_event+0x97/0x190
	[Sat Mar 23 06:13:07 2019]  schedule+0x39/0x90
	[Sat Mar 23 06:13:07 2019]  wait_current_trans+0xa3/0xf0
	[Sat Mar 23 06:13:07 2019]  ? wait_woken+0xa0/0xa0
	[Sat Mar 23 06:13:07 2019]  start_transaction+0x29b/0x4d0
	[Sat Mar 23 06:13:07 2019]  btrfs_create+0x47/0x1d0
	[Sat Mar 23 06:13:07 2019]  lookup_open+0x404/0x760
	[Sat Mar 23 06:13:07 2019]  path_openat+0x4e9/0xcc0
	[Sat Mar 23 06:13:07 2019]  ? filemap_map_pages+0x312/0x520
	[Sat Mar 23 06:13:07 2019]  ? lock_acquire+0xbc/0x200
	[Sat Mar 23 06:13:07 2019]  do_filp_open+0x8a/0xf0
	[Sat Mar 23 06:13:07 2019]  ? __alloc_fd+0x34/0x200
	[Sat Mar 23 06:13:07 2019]  ? expand_files+0x3a/0x2a0
	[Sat Mar 23 06:13:07 2019]  ? do_sys_open+0x130/0x200
	[Sat Mar 23 06:13:07 2019]  do_sys_open+0x130/0x200
	[Sat Mar 23 06:13:07 2019]  do_syscall_64+0x76/0x180
	[Sat Mar 23 06:13:07 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
	[Sat Mar 23 06:13:07 2019] RIP: 0033:0x7fa5521834b0
	[Sat Mar 23 06:13:07 2019] RSP: 002b:00007fff48155588 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
	[Sat Mar 23 06:13:07 2019] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fa5521834b0
	[Sat Mar 23 06:13:07 2019] RDX: 0000000000000180 RSI: 00000000000000c2 RDI: 00007fff481577f0
	[Sat Mar 23 06:13:07 2019] RBP: 000000000003a2f8 R08: 000000000000ffff R09: 00007fa5521d5d40
	[Sat Mar 23 06:13:07 2019] R10: 0000000000000000 R11: 0000000000000246 R12: 00007fff48157805
	[Sat Mar 23 06:13:07 2019] R13: 8421084210842109 R14: 00000000000000c2 R15: 00007fa552211320
	[Sat Mar 23 06:13:07 2019] rsync           D    0 24892  24891 0x00000000
	[Sat Mar 23 06:13:07 2019] Call Trace:
	[Sat Mar 23 06:13:07 2019]  ? __schedule+0x429/0xbb0
	[Sat Mar 23 06:13:07 2019]  ? prepare_to_wait_event+0x97/0x190
	[Sat Mar 23 06:13:07 2019]  schedule+0x39/0x90
	[Sat Mar 23 06:13:07 2019]  wait_current_trans+0xa3/0xf0
	[Sat Mar 23 06:13:07 2019]  ? wait_woken+0xa0/0xa0
	[Sat Mar 23 06:13:07 2019]  start_transaction+0x29b/0x4d0
	[Sat Mar 23 06:13:07 2019]  btrfs_create+0x47/0x1d0
	[Sat Mar 23 06:13:07 2019]  lookup_open+0x404/0x760
	[Sat Mar 23 06:13:07 2019]  path_openat+0x4e9/0xcc0
	[Sat Mar 23 06:13:07 2019]  ? filemap_map_pages+0x312/0x520
	[Sat Mar 23 06:13:07 2019]  ? lock_acquire+0xbc/0x200
	[Sat Mar 23 06:13:07 2019]  do_filp_open+0x8a/0xf0
	[Sat Mar 23 06:13:07 2019]  ? __alloc_fd+0x34/0x200
	[Sat Mar 23 06:13:07 2019]  ? expand_files+0x3a/0x2a0
	[Sat Mar 23 06:13:07 2019]  ? do_sys_open+0x130/0x200
	[Sat Mar 23 06:13:07 2019]  do_sys_open+0x130/0x200
	[Sat Mar 23 06:13:07 2019]  do_syscall_64+0x76/0x180
	[Sat Mar 23 06:13:07 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
	[Sat Mar 23 06:13:07 2019] RIP: 0033:0x7f6a4ed8b4b0
	[Sat Mar 23 06:13:07 2019] RSP: 002b:00007ffdf6712108 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
	[Sat Mar 23 06:13:07 2019] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f6a4ed8b4b0
	[Sat Mar 23 06:13:07 2019] RDX: 0000000000000180 RSI: 00000000000000c2 RDI: 00007ffdf6714370
	[Sat Mar 23 06:13:07 2019] RBP: 000000000003a2f8 R08: 000000000000c0ff R09: 00007f6a4eddd950
	[Sat Mar 23 06:13:07 2019] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffdf6714387
	[Sat Mar 23 06:13:07 2019] R13: 8421084210842109 R14: 00000000000000c2 R15: 00007f6a4ee19320
	[Sat Mar 23 06:13:07 2019] rsync           D    0 12215  12151 0x00000000
	[Sat Mar 23 06:13:07 2019] Call Trace:
	[Sat Mar 23 06:13:07 2019]  ? __schedule+0x429/0xbb0
	[Sat Mar 23 06:13:07 2019]  ? prepare_to_wait_event+0x97/0x190
	[Sat Mar 23 06:13:07 2019]  schedule+0x39/0x90
	[Sat Mar 23 06:13:07 2019]  wait_current_trans+0xa3/0xf0
	[Sat Mar 23 06:13:07 2019]  ? wait_woken+0xa0/0xa0
	[Sat Mar 23 06:13:07 2019]  start_transaction+0x29b/0x4d0
	[Sat Mar 23 06:13:07 2019]  btrfs_create+0x47/0x1d0
	[Sat Mar 23 06:13:07 2019]  lookup_open+0x404/0x760
	[Sat Mar 23 06:13:07 2019]  path_openat+0x4e9/0xcc0
	[Sat Mar 23 06:13:07 2019]  ? filemap_map_pages+0x312/0x520
	[Sat Mar 23 06:13:07 2019]  ? lock_acquire+0xbc/0x200
	[Sat Mar 23 06:13:07 2019]  do_filp_open+0x8a/0xf0
	[Sat Mar 23 06:13:07 2019]  ? __alloc_fd+0x34/0x200
	[Sat Mar 23 06:13:07 2019]  ? expand_files+0x3a/0x2a0
	[Sat Mar 23 06:13:07 2019]  ? do_sys_open+0x130/0x200
	[Sat Mar 23 06:13:07 2019]  do_sys_open+0x130/0x200
	[Sat Mar 23 06:13:07 2019]  do_syscall_64+0x76/0x180
	[Sat Mar 23 06:13:07 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
	[Sat Mar 23 06:13:07 2019] RIP: 0033:0x7f8110fb34b0
	[Sat Mar 23 06:13:07 2019] RSP: 002b:00007ffcce477ec8 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
	[Sat Mar 23 06:13:07 2019] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f8110fb34b0
	[Sat Mar 23 06:13:07 2019] RDX: 0000000000000180 RSI: 00000000000000c2 RDI: 00007ffcce47a130
	[Sat Mar 23 06:13:07 2019] RBP: 000000000003a2f8 R08: 000000000000fff8 R09: 00007f8111005f10
	[Sat Mar 23 06:13:07 2019] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffcce47a14d
	[Sat Mar 23 06:13:07 2019] R13: 8421084210842109 R14: 00000000000000c2 R15: 00007f8111041320
	[Sat Mar 23 06:13:07 2019] rsync           D    0 27127  27028 0x00000000
	[Sat Mar 23 06:13:07 2019] Call Trace:
	[Sat Mar 23 06:13:07 2019]  ? __schedule+0x429/0xbb0
	[Sat Mar 23 06:13:07 2019]  ? prepare_to_wait_event+0x97/0x190
	[Sat Mar 23 06:13:07 2019]  schedule+0x39/0x90
	[Sat Mar 23 06:13:07 2019]  wait_current_trans+0xa3/0xf0
	[Sat Mar 23 06:13:07 2019]  ? wait_woken+0xa0/0xa0
	[Sat Mar 23 06:13:07 2019]  start_transaction+0x29b/0x4d0
	[Sat Mar 23 06:13:07 2019]  btrfs_create+0x47/0x1d0
	[Sat Mar 23 06:13:07 2019]  lookup_open+0x404/0x760
	[Sat Mar 23 06:13:07 2019]  path_openat+0x4e9/0xcc0
	[Sat Mar 23 06:13:07 2019]  ? filemap_map_pages+0x312/0x520
	[Sat Mar 23 06:13:07 2019]  ? lock_acquire+0xbc/0x200
	[Sat Mar 23 06:13:07 2019]  do_filp_open+0x8a/0xf0
	[Sat Mar 23 06:13:07 2019]  ? __alloc_fd+0x34/0x200
	[Sat Mar 23 06:13:07 2019]  ? expand_files+0x3a/0x2a0
	[Sat Mar 23 06:13:07 2019]  ? do_sys_open+0x130/0x200
	[Sat Mar 23 06:13:07 2019]  do_sys_open+0x130/0x200
	[Sat Mar 23 06:13:07 2019]  do_syscall_64+0x76/0x180
	[Sat Mar 23 06:13:07 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
	[Sat Mar 23 06:13:07 2019] RIP: 0033:0x7f65a9c1b4b0
	[Sat Mar 23 06:13:07 2019] RSP: 002b:00007ffea8320a18 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
	[Sat Mar 23 06:13:07 2019] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f65a9c1b4b0
	[Sat Mar 23 06:13:07 2019] RDX: 0000000000000180 RSI: 00000000000000c2 RDI: 00007ffea8322c80
	[Sat Mar 23 06:13:07 2019] RBP: 000000000003a2f8 R08: 000000000000ffff R09: 00007f65a9c6e300
	[Sat Mar 23 06:13:07 2019] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffea8322cc6
	[Sat Mar 23 06:13:07 2019] R13: 8421084210842109 R14: 00000000000000c2 R15: 00007f65a9ca9320
	[Sat Mar 23 06:13:07 2019] rsync           D    0  3891   3890 0x00000000
	[Sat Mar 23 06:13:07 2019] Call Trace:
	[Sat Mar 23 06:13:07 2019]  ? __schedule+0x429/0xbb0
	[Sat Mar 23 06:13:07 2019]  ? prepare_to_wait_event+0x97/0x190
	[Sat Mar 23 06:13:07 2019]  schedule+0x39/0x90
	[Sat Mar 23 06:13:07 2019]  wait_current_trans+0xa3/0xf0
	[Sat Mar 23 06:13:07 2019]  ? wait_woken+0xa0/0xa0
	[Sat Mar 23 06:13:07 2019]  start_transaction+0x29b/0x4d0
	[Sat Mar 23 06:13:07 2019]  btrfs_create+0x47/0x1d0
	[Sat Mar 23 06:13:07 2019]  lookup_open+0x404/0x760
	[Sat Mar 23 06:13:07 2019]  path_openat+0x4e9/0xcc0
	[Sat Mar 23 06:13:07 2019]  ? filemap_map_pages+0x312/0x520
	[Sat Mar 23 06:13:07 2019]  ? lock_acquire+0xbc/0x200
	[Sat Mar 23 06:13:07 2019]  do_filp_open+0x8a/0xf0
	[Sat Mar 23 06:13:07 2019]  ? __alloc_fd+0x34/0x200
	[Sat Mar 23 06:13:07 2019]  ? expand_files+0x3a/0x2a0
	[Sat Mar 23 06:13:07 2019]  ? do_sys_open+0x130/0x200
	[Sat Mar 23 06:13:07 2019]  do_sys_open+0x130/0x200
	[Sat Mar 23 06:13:07 2019]  do_syscall_64+0x76/0x180
	[Sat Mar 23 06:13:07 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
	[Sat Mar 23 06:13:07 2019] RIP: 0033:0x7fa6d9f8b4b0
	[Sat Mar 23 06:13:07 2019] RSP: 002b:00007ffff60095b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
	[Sat Mar 23 06:13:07 2019] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fa6d9f8b4b0
	[Sat Mar 23 06:13:07 2019] RDX: 0000000000000180 RSI: 00000000000000c2 RDI: 00007ffff600b820
	[Sat Mar 23 06:13:07 2019] RBP: 000000000003a2f8 R08: 000000000000ffff R09: 00007fa6d9fde520
	[Sat Mar 23 06:13:07 2019] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffff600b833
	[Sat Mar 23 06:13:07 2019] R13: 8421084210842109 R14: 00000000000000c2 R15: 00007fa6da019320
	[Sat Mar 23 06:13:07 2019] rsync           D    0 26758  26728 0x00000000
	[Sat Mar 23 06:13:07 2019] Call Trace:
	[Sat Mar 23 06:13:07 2019]  ? __schedule+0x429/0xbb0
	[Sat Mar 23 06:13:07 2019]  ? prepare_to_wait_event+0x97/0x190
	[Sat Mar 23 06:13:07 2019]  schedule+0x39/0x90
	[Sat Mar 23 06:13:07 2019]  wait_current_trans+0xa3/0xf0
	[Sat Mar 23 06:13:07 2019]  ? wait_woken+0xa0/0xa0
	[Sat Mar 23 06:13:07 2019]  start_transaction+0x29b/0x4d0
	[Sat Mar 23 06:13:07 2019]  btrfs_create+0x47/0x1d0
	[Sat Mar 23 06:13:07 2019]  lookup_open+0x404/0x760
	[Sat Mar 23 06:13:07 2019]  path_openat+0x4e9/0xcc0
	[Sat Mar 23 06:13:07 2019]  ? filemap_map_pages+0x312/0x520
	[Sat Mar 23 06:13:07 2019]  ? lock_acquire+0xbc/0x200
	[Sat Mar 23 06:13:07 2019]  do_filp_open+0x8a/0xf0
	[Sat Mar 23 06:13:07 2019]  ? __alloc_fd+0x34/0x200
	[Sat Mar 23 06:13:07 2019]  ? expand_files+0x3a/0x2a0
	[Sat Mar 23 06:13:07 2019]  ? do_sys_open+0x130/0x200
	[Sat Mar 23 06:13:07 2019]  do_sys_open+0x130/0x200
	[Sat Mar 23 06:13:07 2019]  do_syscall_64+0x76/0x180
	[Sat Mar 23 06:13:07 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
	[Sat Mar 23 06:13:07 2019] RIP: 0033:0x7fe51da8b4b0
	[Sat Mar 23 06:13:07 2019] RSP: 002b:00007ffd1ad7aca8 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
	[Sat Mar 23 06:13:07 2019] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fe51da8b4b0
	[Sat Mar 23 06:13:07 2019] RDX: 0000000000000180 RSI: 00000000000000c2 RDI: 00007ffd1ad7cf10
	[Sat Mar 23 06:13:07 2019] RBP: 000000000003a2f8 R08: 000000000000c0ff R09: 00007fe51dadd950
	[Sat Mar 23 06:13:07 2019] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffd1ad7cf27
	[Sat Mar 23 06:13:07 2019] R13: 8421084210842109 R14: 00000000000000c2 R15: 00007fe51db19320
	[Sat Mar 23 06:13:07 2019] rsync           D    0 12327  12326 0x00000000
	[Sat Mar 23 06:13:07 2019] Call Trace:
	[Sat Mar 23 06:13:07 2019]  ? __schedule+0x429/0xbb0
	[Sat Mar 23 06:13:07 2019]  ? prepare_to_wait_event+0x97/0x190
	[Sat Mar 23 06:13:07 2019]  schedule+0x39/0x90
	[Sat Mar 23 06:13:07 2019]  wait_current_trans+0xa3/0xf0
	[Sat Mar 23 06:13:07 2019]  ? wait_woken+0xa0/0xa0
	[Sat Mar 23 06:13:07 2019]  start_transaction+0x29b/0x4d0
	[Sat Mar 23 06:13:07 2019]  btrfs_create+0x47/0x1d0
	[Sat Mar 23 06:13:07 2019]  lookup_open+0x404/0x760
	[Sat Mar 23 06:13:07 2019]  path_openat+0x4e9/0xcc0
	[Sat Mar 23 06:13:07 2019]  ? filemap_map_pages+0x312/0x520
	[Sat Mar 23 06:13:07 2019]  ? lock_acquire+0xbc/0x200
	[Sat Mar 23 06:13:07 2019]  do_filp_open+0x8a/0xf0
	[Sat Mar 23 06:13:07 2019]  ? __alloc_fd+0x34/0x200
	[Sat Mar 23 06:13:07 2019]  ? expand_files+0x3a/0x2a0
	[Sat Mar 23 06:13:07 2019]  ? do_sys_open+0x130/0x200
	[Sat Mar 23 06:13:07 2019]  do_sys_open+0x130/0x200
	[Sat Mar 23 06:13:07 2019]  do_syscall_64+0x76/0x180
	[Sat Mar 23 06:13:07 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
	[Sat Mar 23 06:13:07 2019] RIP: 0033:0x7fdd14d1b4b0
	[Sat Mar 23 06:13:07 2019] RSP: 002b:00007ffc83bc5938 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
	[Sat Mar 23 06:13:07 2019] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fdd14d1b4b0
	[Sat Mar 23 06:13:07 2019] RDX: 0000000000000180 RSI: 00000000000000c2 RDI: 00007ffc83bc7ba0
	[Sat Mar 23 06:13:07 2019] RBP: 000000000003a2f8 R08: 000000000000c0ff R09: 00007fdd14d6d950
	[Sat Mar 23 06:13:07 2019] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffc83bc7bb7
	[Sat Mar 23 06:13:07 2019] R13: 8421084210842109 R14: 00000000000000c2 R15: 00007fdd14da9320
	[Sat Mar 23 06:13:07 2019] rsync           D    0 16793  16762 0x00000000
	[Sat Mar 23 06:13:07 2019] Call Trace:
	[Sat Mar 23 06:13:07 2019]  ? __schedule+0x429/0xbb0
	[Sat Mar 23 06:13:07 2019]  ? prepare_to_wait_event+0x97/0x190
	[Sat Mar 23 06:13:07 2019]  schedule+0x39/0x90
	[Sat Mar 23 06:13:07 2019]  wait_current_trans+0xa3/0xf0
	[Sat Mar 23 06:13:08 2019]  ? wait_woken+0xa0/0xa0
	[Sat Mar 23 06:13:08 2019]  start_transaction+0x29b/0x4d0
	[Sat Mar 23 06:13:08 2019]  btrfs_create+0x47/0x1d0
	[Sat Mar 23 06:13:08 2019]  lookup_open+0x404/0x760
	[Sat Mar 23 06:13:08 2019]  path_openat+0x4e9/0xcc0
	[Sat Mar 23 06:13:08 2019]  ? filemap_map_pages+0x312/0x520
	[Sat Mar 23 06:13:08 2019]  ? lock_acquire+0xbc/0x200
	[Sat Mar 23 06:13:08 2019]  do_filp_open+0x8a/0xf0
	[Sat Mar 23 06:13:08 2019]  ? __alloc_fd+0x34/0x200
	[Sat Mar 23 06:13:08 2019]  ? expand_files+0x3a/0x2a0
	[Sat Mar 23 06:13:08 2019]  ? do_sys_open+0x130/0x200
	[Sat Mar 23 06:13:08 2019]  do_sys_open+0x130/0x200
	[Sat Mar 23 06:13:08 2019]  do_syscall_64+0x76/0x180
	[Sat Mar 23 06:13:08 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
	[Sat Mar 23 06:13:08 2019] RIP: 0033:0x7f89056234b0
	[Sat Mar 23 06:13:08 2019] RSP: 002b:00007ffc38a789a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
	[Sat Mar 23 06:13:08 2019] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f89056234b0
	[Sat Mar 23 06:13:08 2019] RDX: 0000000000000180 RSI: 00000000000000c2 RDI: 00007ffc38a7ac10
	[Sat Mar 23 06:13:08 2019] RBP: 000000000003a2f8 R08: 000000000000c0ff R09: 00007f8905675950
	[Sat Mar 23 06:13:08 2019] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffc38a7ac27
	[Sat Mar 23 06:13:08 2019] R13: 8421084210842109 R14: 00000000000000c2 R15: 00007f89056b1320
	[Sat Mar 23 06:13:08 2019] watchdog-mdtest D    0 20886  11460 0x00000000
	[Sat Mar 23 06:13:08 2019] Call Trace:
	[Sat Mar 23 06:13:08 2019]  ? __schedule+0x429/0xbb0
	[Sat Mar 23 06:13:08 2019]  schedule+0x39/0x90
	[Sat Mar 23 06:13:08 2019]  io_schedule+0x12/0x40
	[Sat Mar 23 06:13:08 2019]  wait_on_page_bit+0x10d/0x140
	[Sat Mar 23 06:13:08 2019]  ? add_to_page_cache_lru+0xc0/0xc0
	[Sat Mar 23 06:13:08 2019]  read_extent_buffer_pages+0x215/0x2d0
	[Sat Mar 23 06:13:08 2019]  ? free_root_pointers+0x60/0x60
	[Sat Mar 23 06:13:08 2019]  btree_read_extent_buffer_pages+0x86/0x100
	[Sat Mar 23 06:13:08 2019]  read_tree_block+0x2d/0x50
	[Sat Mar 23 06:13:08 2019]  read_block_for_search.isra.11+0x117/0x310
	[Sat Mar 23 06:13:08 2019]  ? _raw_read_lock+0x3b/0x70
	[Sat Mar 23 06:13:08 2019]  btrfs_search_slot+0x3e7/0x9c0
	[Sat Mar 23 06:13:08 2019]  btrfs_lookup_dir_item+0x69/0xb0
	[Sat Mar 23 06:13:08 2019]  btrfs_lookup_dentry+0xa0/0x530
	[Sat Mar 23 06:13:08 2019]  btrfs_lookup+0xe/0x30
	[Sat Mar 23 06:13:08 2019]  lookup_slow+0x131/0x210
	[Sat Mar 23 06:13:08 2019]  walk_component+0x1b2/0x2d0
	[Sat Mar 23 06:13:08 2019]  path_lookupat+0x64/0x1f0
	[Sat Mar 23 06:13:08 2019]  ? trace_hardirqs_on_caller+0x12/0x1c0
	[Sat Mar 23 06:13:08 2019]  filename_lookup+0xa9/0x170
	[Sat Mar 23 06:13:08 2019]  ? __check_object_size+0xa7/0x190
	[Sat Mar 23 06:13:08 2019]  ? strncpy_from_user+0x48/0x160
	[Sat Mar 23 06:13:08 2019]  ? _raw_spin_unlock+0x24/0x30
	[Sat Mar 23 06:13:08 2019]  ? vfs_statx+0x63/0xb0
	[Sat Mar 23 06:13:08 2019]  vfs_statx+0x63/0xb0
	[Sat Mar 23 06:13:08 2019]  SyS_newstat+0x2b/0x50
	[Sat Mar 23 06:13:08 2019]  ? up_read+0x1c/0x40
	[Sat Mar 23 06:13:08 2019]  ? trace_hardirqs_off_caller+0x1b/0xe0
	[Sat Mar 23 06:13:08 2019]  ? trace_hardirqs_off_thunk+0x1a/0x1c
	[Sat Mar 23 06:13:08 2019]  ? trace_hardirqs_on_caller+0x12/0x1c0
	[Sat Mar 23 06:13:08 2019]  do_syscall_64+0x76/0x180
	[Sat Mar 23 06:13:08 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
	[Sat Mar 23 06:13:08 2019] RIP: 0033:0x7fe3ffd7b055
	[Sat Mar 23 06:13:08 2019] RSP: 002b:00007ffea6aaeed8 EFLAGS: 00000246 ORIG_RAX: 0000000000000004
	[Sat Mar 23 06:13:08 2019] RAX: ffffffffffffffda RBX: 0000000000000024 RCX: 00007fe3ffd7b055
	[Sat Mar 23 06:13:08 2019] RDX: 00007ffea6aaeee0 RSI: 00007ffea6aaeee0 RDI: 00000000014e13c8
	[Sat Mar 23 06:13:08 2019] RBP: 00000000014e13c8 R08: 0000000000710710 R09: 00007fe3ffdcdf20
	[Sat Mar 23 06:13:08 2019] R10: 00007fe3ffdca430 R11: 0000000000000246 R12: 00000000014e13c8
	[Sat Mar 23 06:13:08 2019] R13: 00007ffea6aaeff0 R14: 00007ffea6aaeff0 R15: 00000000014dfda8
	[Sat Mar 23 06:13:08 2019] tee             D    0 20887  11460 0x80000000
	[Sat Mar 23 06:13:08 2019] Call Trace:
	[Sat Mar 23 06:13:08 2019]  ? __schedule+0x429/0xbb0
	[Sat Mar 23 06:13:08 2019]  schedule+0x39/0x90
	[Sat Mar 23 06:13:08 2019]  io_schedule+0x12/0x40
	[Sat Mar 23 06:13:08 2019]  wait_on_page_bit_killable+0x114/0x170
	[Sat Mar 23 06:13:08 2019]  ? add_to_page_cache_lru+0xc0/0xc0
	[Sat Mar 23 06:13:08 2019]  __lock_page_or_retry+0xa1/0xe0
	[Sat Mar 23 06:13:08 2019]  filemap_fault+0x244/0x830
	[Sat Mar 23 06:13:08 2019]  __do_fault+0x3e/0x170
	[Sat Mar 23 06:13:08 2019]  __handle_mm_fault+0x118e/0x18b0
	[Sat Mar 23 06:13:08 2019]  handle_mm_fault+0x15c/0x300
	[Sat Mar 23 06:13:08 2019]  __do_page_fault+0x1fa/0x520
	[Sat Mar 23 06:13:08 2019]  page_fault+0x25/0x50
	[Sat Mar 23 06:13:08 2019] RIP: 0010:__clear_user+0x3d/0x60
	[Sat Mar 23 06:13:08 2019] RSP: 0018:ffff9b32495a7d68 EFLAGS: 00010202
	[Sat Mar 23 06:13:08 2019] RAX: 0000000000000000 RBX: 00000000000001b0 RCX: 00000000000001b0
	[Sat Mar 23 06:13:08 2019] RDX: 0000000000000000 RSI: 0000000000000008 RDI: 000055feabb1c280
	[Sat Mar 23 06:13:08 2019] RBP: 000055feabb1c280 R08: 0000000000000001 R09: 0000000000000000
	[Sat Mar 23 06:13:08 2019] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
	[Sat Mar 23 06:13:08 2019] R13: ffff9b32495a4000 R14: ffff8d636f181a00 R15: ffff8d6307e816c0
	[Sat Mar 23 06:13:08 2019]  ? __clear_user+0x1e/0x60
	[Sat Mar 23 06:13:08 2019]  load_elf_binary+0x101a/0x170d
	[Sat Mar 23 06:13:08 2019]  search_binary_handler+0xa0/0x1f0
	[Sat Mar 23 06:13:08 2019]  do_execveat_common.isra.13+0x689/0x9a0
	[Sat Mar 23 06:13:08 2019]  SyS_execve+0x2c/0x40
	[Sat Mar 23 06:13:08 2019]  do_syscall_64+0x76/0x180
	[Sat Mar 23 06:13:08 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
	[Sat Mar 23 06:13:08 2019] RIP: 0033:0x7fe3ffd58647
	[Sat Mar 23 06:13:08 2019] RSP: 002b:00007ffea6aaf038 EFLAGS: 00000202 ORIG_RAX: 000000000000003b
	[Sat Mar 23 06:13:08 2019] RAX: ffffffffffffffda RBX: 00000000014dec28 RCX: 00007fe3ffd58647
	[Sat Mar 23 06:13:08 2019] RDX: 00000000014cf608 RSI: 00000000014e1688 RDI: 00000000014dec28
	[Sat Mar 23 06:13:08 2019] RBP: 0000000000000000 R08: 0000000000710710 R09: 0000000000000000
	[Sat Mar 23 06:13:08 2019] R10: 000000000000059a R11: 0000000000000202 R12: 0000000000000000
	[Sat Mar 23 06:13:08 2019] R13: 00000000014e1688 R14: 00000000014cf608 R15: 0000000000000040
	[Sat Mar 23 06:13:08 2019] watchdog-mdtest D    0 20890  11460 0x00000000
	[Sat Mar 23 06:13:08 2019] Call Trace:
	[Sat Mar 23 06:13:08 2019]  ? __schedule+0x429/0xbb0
	[Sat Mar 23 06:13:08 2019]  schedule+0x39/0x90
	[Sat Mar 23 06:13:08 2019]  io_schedule+0x12/0x40
	[Sat Mar 23 06:13:08 2019]  wait_on_page_bit+0x10d/0x140
	[Sat Mar 23 06:13:08 2019]  ? add_to_page_cache_lru+0xc0/0xc0
	[Sat Mar 23 06:13:08 2019]  read_extent_buffer_pages+0x215/0x2d0
	[Sat Mar 23 06:13:08 2019]  ? free_root_pointers+0x60/0x60
	[Sat Mar 23 06:13:08 2019]  btree_read_extent_buffer_pages+0x86/0x100
	[Sat Mar 23 06:13:08 2019]  read_tree_block+0x2d/0x50
	[Sat Mar 23 06:13:08 2019]  read_block_for_search.isra.11+0x117/0x310
	[Sat Mar 23 06:13:08 2019]  ? _raw_read_lock+0x3b/0x70
	[Sat Mar 23 06:13:08 2019]  btrfs_search_slot+0x3e7/0x9c0
	[Sat Mar 23 06:13:08 2019]  btrfs_lookup_dir_item+0x69/0xb0
	[Sat Mar 23 06:13:08 2019]  btrfs_lookup_dentry+0xa0/0x530
	[Sat Mar 23 06:13:08 2019]  btrfs_lookup+0xe/0x30
	[Sat Mar 23 06:13:08 2019]  lookup_slow+0x131/0x210
	[Sat Mar 23 06:13:08 2019]  walk_component+0x1b2/0x2d0
	[Sat Mar 23 06:13:08 2019]  path_lookupat+0x64/0x1f0
	[Sat Mar 23 06:13:08 2019]  ? trace_hardirqs_on_caller+0x12/0x1c0
	[Sat Mar 23 06:13:08 2019]  filename_lookup+0xa9/0x170
	[Sat Mar 23 06:13:08 2019]  ? __check_object_size+0xa7/0x190
	[Sat Mar 23 06:13:08 2019]  ? strncpy_from_user+0x48/0x160
	[Sat Mar 23 06:13:08 2019]  ? finish_task_switch+0x64/0x230
	[Sat Mar 23 06:13:08 2019]  ? vfs_statx+0x63/0xb0
	[Sat Mar 23 06:13:08 2019]  vfs_statx+0x63/0xb0
	[Sat Mar 23 06:13:08 2019]  ? finish_task_switch+0xa0/0x230
	[Sat Mar 23 06:13:08 2019]  ? finish_task_switch+0x64/0x230
	[Sat Mar 23 06:13:08 2019]  SyS_newstat+0x2b/0x50
	[Sat Mar 23 06:13:08 2019]  ? trace_hardirqs_off_caller+0x1b/0xe0
	[Sat Mar 23 06:13:08 2019]  ? trace_hardirqs_off_thunk+0x1a/0x1c
	[Sat Mar 23 06:13:08 2019]  ? trace_hardirqs_on_caller+0x12/0x1c0
	[Sat Mar 23 06:13:08 2019]  do_syscall_64+0x76/0x180
	[Sat Mar 23 06:13:08 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
	[Sat Mar 23 06:13:08 2019] RIP: 0033:0x7fe3ffd7b055
	[Sat Mar 23 06:13:08 2019] RSP: 002b:00007ffea6aaee08 EFLAGS: 00000246 ORIG_RAX: 0000000000000004
	[Sat Mar 23 06:13:08 2019] RAX: ffffffffffffffda RBX: 0000000000000024 RCX: 00007fe3ffd7b055
	[Sat Mar 23 06:13:08 2019] RDX: 00007ffea6aaee10 RSI: 00007ffea6aaee10 RDI: 00000000014cdea8
	[Sat Mar 23 06:13:08 2019] RBP: 00000000014cdea8 R08: 0000000000710710 R09: 00007fe3ffdcd7b0
	[Sat Mar 23 06:13:08 2019] R10: ffffffffffffffe0 R11: 0000000000000246 R12: 00000000014cdea8
	[Sat Mar 23 06:13:08 2019] R13: 00007ffea6aaef20 R14: 00007ffea6aaef20 R15: 00000000014cde88
	[Sat Mar 23 06:13:08 2019] tee             D    0 20892  11460 0x80000000
	[Sat Mar 23 06:13:08 2019] Call Trace:
	[Sat Mar 23 06:13:08 2019]  ? __schedule+0x429/0xbb0
	[Sat Mar 23 06:13:08 2019]  schedule+0x39/0x90
	[Sat Mar 23 06:13:08 2019]  io_schedule+0x12/0x40
	[Sat Mar 23 06:13:08 2019]  wait_on_page_bit_killable+0x114/0x170
	[Sat Mar 23 06:13:08 2019]  ? add_to_page_cache_lru+0xc0/0xc0
	[Sat Mar 23 06:13:08 2019]  __lock_page_or_retry+0xa1/0xe0
	[Sat Mar 23 06:13:08 2019]  filemap_fault+0x244/0x830
	[Sat Mar 23 06:13:08 2019]  __do_fault+0x3e/0x170
	[Sat Mar 23 06:13:08 2019]  __handle_mm_fault+0x118e/0x18b0
	[Sat Mar 23 06:13:08 2019]  handle_mm_fault+0x15c/0x300
	[Sat Mar 23 06:13:08 2019]  __do_page_fault+0x1fa/0x520
	[Sat Mar 23 06:13:08 2019]  page_fault+0x25/0x50
	[Sat Mar 23 06:13:08 2019] RIP: 0010:__clear_user+0x3d/0x60
	[Sat Mar 23 06:13:08 2019] RSP: 0018:ffff9b32495d7d68 EFLAGS: 00010202
	[Sat Mar 23 06:13:08 2019] RAX: 0000000000000000 RBX: 00000000000001b0 RCX: 00000000000001b0
	[Sat Mar 23 06:13:08 2019] RDX: 0000000000000000 RSI: 0000000000000008 RDI: 000055f378ec1280
	[Sat Mar 23 06:13:08 2019] RBP: 000055f378ec1280 R08: 0000000000000001 R09: 0000000000000000
	[Sat Mar 23 06:13:08 2019] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
	[Sat Mar 23 06:13:08 2019] R13: ffff9b32495d4000 R14: ffff8d656a48ae00 R15: ffff8d63146576c0
	[Sat Mar 23 06:13:08 2019]  ? __clear_user+0x1e/0x60
	[Sat Mar 23 06:13:08 2019]  load_elf_binary+0x101a/0x170d
	[Sat Mar 23 06:13:08 2019]  search_binary_handler+0xa0/0x1f0
	[Sat Mar 23 06:13:08 2019]  do_execveat_common.isra.13+0x689/0x9a0
	[Sat Mar 23 06:13:08 2019]  SyS_execve+0x2c/0x40
	[Sat Mar 23 06:13:08 2019]  do_syscall_64+0x76/0x180
	[Sat Mar 23 06:13:08 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
	[Sat Mar 23 06:13:08 2019] RIP: 0033:0x7fe3ffd58647
	[Sat Mar 23 06:13:08 2019] RSP: 002b:00007ffea6aaef68 EFLAGS: 00000202 ORIG_RAX: 000000000000003b
	[Sat Mar 23 06:13:08 2019] RAX: ffffffffffffffda RBX: 00000000014dfda8 RCX: 00007fe3ffd58647
	[Sat Mar 23 06:13:08 2019] RDX: 00000000014cf608 RSI: 00000000014d3608 RDI: 00000000014dfda8
	[Sat Mar 23 06:13:08 2019] RBP: 0000000000000000 R08: 0000000000710710 R09: 0000000000000000
	[Sat Mar 23 06:13:08 2019] R10: 000000000000059a R11: 0000000000000202 R12: 0000000000000000
	[Sat Mar 23 06:13:08 2019] R13: 00000000014d3608 R14: 00000000014cf608 R15: 0000000000000040

This looks like it may be a distinct deadlock bug on 4.14.  Statistically,
it's very unlikely that there's only one.
