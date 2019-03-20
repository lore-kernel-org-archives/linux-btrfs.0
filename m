Return-Path: <SRS0=xnYl=RX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47376C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 03:40:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF6D3213F2
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 03:40:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbfCTDkG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Mar 2019 23:40:06 -0400
Received: from james.kirk.hungrycats.org ([174.142.39.145]:34386 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726896AbfCTDkG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Mar 2019 23:40:06 -0400
Received: by james.kirk.hungrycats.org (Postfix, from userid 1002)
        id 2897326E370; Tue, 19 Mar 2019 23:40:00 -0400 (EDT)
Date:   Tue, 19 Mar 2019 23:39:59 -0400
From:   Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To:     linux-btrfs@vger.kernel.org
Subject: A collection of btrfs lockup stack traces
Message-ID: <20190320033957.GA16651@hungrycats.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I haven't been able to easily reproduce these in a test environment;
however, they have been happening several times a year on servers in
production.

Kernel:  most recent observation on 4.14.105 + cherry-picked deadlock
and misc hang fixes:

	btrfs: wakeup cleaner thread when adding delayed iput
	Btrfs: fix deadlock when allocating tree block during leaf/node split
	Btrfs: use nofs context when initializing security xattrs to avoid deadlock
	Btrfs: fix deadlock with memory reclaim during scrub
	Btrfs: fix deadlock between clone/dedupe and rename

Also observed on 4.20.13, and 4.14.0..4.14.105 (4.14.106 is currently
running, but hasn't locked up yet).

Filesystem mount flags:  compress=zstd,ssd,flushoncommit,space_cache=v2.
Configuration is either -draid1/-mraid1 or -dsingle/-mraid1.  I've
also reproduced a lockup without flushoncommit.

The machines that are locking up all run the same workload:

	rsync receiving data continuously (gigabytes aren't enough,
	I can barely reproduce this once a month with 2TB of rsync
	traffic from 10 simulated clients)

	bees doing continuous dedupe

	snapshots daily and after each rsync

	snapshot deletes as required to maintain free space

	scrubs twice monthly plus after each crash

	watchdog does a 'mkdir foo; rmdir foo' every few seconds.
	If this takes longer than 50 minutes, collect a stack trace;
	longer than 60 minutes, reboot the machine.

Observations:

	In the past I've hit the known deadlocks between rsync
	(rename) and dedupe, and between snapshot delete and scrub.
	These deadlocks aren't those, and current kernels can still
	deadlock with fixes for those (and some others) applied.

	Deadlocks can occur when there are no snapshot deletes active
	and scrub is not running.  In a few cases there's been a snapshot
	create active during a deadlock event.

	The deadlocks occur in bursts, which correlate to periods
	of rapid data expansion on the filesystem.  e.g. after a big
	snapshot delete frees a TB or two of space, there are several
	lockups a few days (or even hours) apart.  When the filesystem
	gets near the free space threshold and a series of smaller
	snapshot deletes occur, so that allocated space stays relatively
	stable, then there can be months between lockups.

	Other bugs in 4.14 kernels break lockdep soon after boot, so
	there's only lockdep information in a few cases by the time the
	btrfs deadlock happens.

	There seem to be a few different identifiable behaviors, e.g.
	in some cases the 50-minute timer expires (so a stack trace is
	collected) but the 60-minute timer doesn't expire (so the machine
	got itself out of the lockup somehow, and doesn't reboot).

Distractions:

	In some cases increasing vm.dirty_ratio will unfreeze the
	filesystem, in other cases it does nothing.  Decreasing
	vm.dirty_ratio (e.g. to 2) locks up the filesystem almost
	immediately, but it can recover if vm.dirty_ratio is increased
	again.	I'm not sure if this is because there are two separate
	bugs, or just a single bug with corner cases.

Here's a recent lockup example with lockdep output, from 4.14.105 with
the cherry-picked patches above:

[Fri Mar 15 21:05:59 2019] 1 lock held by khungtaskd/465:
[Fri Mar 15 21:05:59 2019]  #0:  (tasklist_lock){.+.+}, at: [<ffffffff950f0367>] debug_show_all_locks+0x37/0x190
[Fri Mar 15 21:05:59 2019] 3 locks held by btrfs-transacti/31131:
[Fri Mar 15 21:05:59 2019]  #0:  (&fs_info->transaction_kthread_mutex){+.+.}, at: [<ffffffff954352b4>] transaction_kthread+0x74/0x1d0
[Fri Mar 15 21:05:59 2019]  #1:  (&fs_info->delalloc_root_mutex){+.+.}, at: [<ffffffff9544f728>] btrfs_start_delalloc_roots+0x58/0x380
[Fri Mar 15 21:05:59 2019]  #2:  (&root->delalloc_mutex){+.+.}, at: [<ffffffff9544f302>] __start_delalloc_inodes+0x52/0x320
[Fri Mar 15 21:05:59 2019] 4 locks held by crawl_61509/20348:
[Fri Mar 15 21:05:59 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffff952d4e1b>] mnt_want_write_file+0x3b/0xb0
[Fri Mar 15 21:05:59 2019]  #1:  (&sb->s_type->i_mutex_key#14/1){+.+.}, at: [<ffffffff95479bde>] btrfs_dedupe_file_range+0x8e/0x660
[Fri Mar 15 21:05:59 2019]  #2:  (&sb->s_type->i_mutex_key#14/2){+.+.}, at: [<ffffffff95479bef>] btrfs_dedupe_file_range+0x9f/0x660
[Fri Mar 15 21:05:59 2019]  #3:  (sb_internal){.+.+}, at: [<ffffffff9543b5d6>] start_transaction+0x2b6/0x4d0
[Fri Mar 15 21:05:59 2019] 2 locks held by crawl_294/20349:
[Fri Mar 15 21:05:59 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffff952d4e1b>] mnt_want_write_file+0x3b/0xb0
[Fri Mar 15 21:05:59 2019]  #1:  (&sb->s_type->i_mutex_key#14/1){+.+.}, at: [<ffffffff95479bde>] btrfs_dedupe_file_range+0x8e/0x660
[Fri Mar 15 21:05:59 2019] 4 locks held by crawl_294/20350:
[Fri Mar 15 21:05:59 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffff952d4e1b>] mnt_want_write_file+0x3b/0xb0
[Fri Mar 15 21:05:59 2019]  #1:  (&sb->s_type->i_mutex_key#14/1){+.+.}, at: [<ffffffff95479bde>] btrfs_dedupe_file_range+0x8e/0x660
[Fri Mar 15 21:05:59 2019]  #2:  (&sb->s_type->i_mutex_key#14/2){+.+.}, at: [<ffffffff95479bef>] btrfs_dedupe_file_range+0x9f/0x660
[Fri Mar 15 21:05:59 2019]  #3:  (sb_internal){.+.+}, at: [<ffffffff9543b5d6>] start_transaction+0x2b6/0x4d0
[Fri Mar 15 21:05:59 2019] 2 locks held by crawl_294/25732:
[Fri Mar 15 21:05:59 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffff952d4e1b>] mnt_want_write_file+0x3b/0xb0
[Fri Mar 15 21:05:59 2019]  #1:  (&sb->s_type->i_mutex_key#14/1){+.+.}, at: [<ffffffff95479bde>] btrfs_dedupe_file_range+0x8e/0x660
[Fri Mar 15 21:05:59 2019] 4 locks held by crawl_61509/25733:
[Fri Mar 15 21:05:59 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffff952d4e1b>] mnt_want_write_file+0x3b/0xb0
[Fri Mar 15 21:05:59 2019]  #1:  (&sb->s_type->i_mutex_key#14/1){+.+.}, at: [<ffffffff95479bde>] btrfs_dedupe_file_range+0x8e/0x660
[Fri Mar 15 21:05:59 2019]  #2:  (&sb->s_type->i_mutex_key#14/2){+.+.}, at: [<ffffffff95479bef>] btrfs_dedupe_file_range+0x9f/0x660
[Fri Mar 15 21:05:59 2019]  #3:  (sb_internal){.+.+}, at: [<ffffffff9543b5d6>] start_transaction+0x2b6/0x4d0
[Fri Mar 15 21:05:59 2019] 1 lock held by btrfs/14776:
[Fri Mar 15 21:05:59 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffff952d4e1b>] mnt_want_write_file+0x3b/0xb0
[Fri Mar 15 21:05:59 2019] 1 lock held by btrfs/14777:
[Fri Mar 15 21:05:59 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffff952d4e1b>] mnt_want_write_file+0x3b/0xb0
[Fri Mar 15 21:05:59 2019] 1 lock held by btrfs/14778:
[Fri Mar 15 21:05:59 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffff952d4e1b>] mnt_want_write_file+0x3b/0xb0
[Fri Mar 15 21:05:59 2019] 1 lock held by btrfs/14779:
[Fri Mar 15 21:05:59 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffff952d4e1b>] mnt_want_write_file+0x3b/0xb0
[Fri Mar 15 21:05:59 2019] 1 lock held by btrfs/14780:
[Fri Mar 15 21:05:59 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffff952d4e1b>] mnt_want_write_file+0x3b/0xb0
[Fri Mar 15 21:05:59 2019] 2 locks held by kworker/u8:5/5813:
[Fri Mar 15 21:05:59 2019]  #0:  ("%s-%s""btrfs", name){+.+.}, at: [<ffffffff950ae2be>] process_one_work+0x17e/0x650
[Fri Mar 15 21:05:59 2019]  #1:  ((&work->normal_work)){+.+.}, at: [<ffffffff950ae2be>] process_one_work+0x17e/0x650
[Fri Mar 15 21:05:59 2019] 4 locks held by rsync/26929:
[Fri Mar 15 21:05:59 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffff952d4d90>] mnt_want_write+0x20/0x50
[Fri Mar 15 21:05:59 2019]  #1:  (&type->i_mutex_dir_key#6/1){+.+.}, at: [<ffffffff952bf698>] do_rmdir+0x168/0x210
[Fri Mar 15 21:05:59 2019]  #2:  (&type->i_mutex_dir_key#6){++++}, at: [<ffffffff952bddcf>] vfs_rmdir+0x4f/0x140
[Fri Mar 15 21:05:59 2019]  #3:  (sb_internal){.+.+}, at: [<ffffffff9543b5d6>] start_transaction+0x2b6/0x4d0
[Fri Mar 15 21:05:59 2019] 1 lock held by rsync/2977:
[Fri Mar 15 21:05:59 2019]  #0:  (&type->i_mutex_dir_key#6){++++}, at: [<ffffffff952b9307>] lookup_slow+0xe7/0x210
[Fri Mar 15 21:05:59 2019] 3 locks held by mkdir/25975:
[Fri Mar 15 21:05:59 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffff952d4d90>] mnt_want_write+0x20/0x50
[Fri Mar 15 21:05:59 2019]  #1:  (&type->i_mutex_dir_key#6/1){+.+.}, at: [<ffffffff952bf42f>] filename_create+0x6f/0x140
[Fri Mar 15 21:05:59 2019]  #2:  (sb_internal){.+.+}, at: [<ffffffff9543b5d6>] start_transaction+0x2b6/0x4d0

[Fri Mar 15 21:05:59 2019] =============================================

[Fri Mar 15 21:53:36 2019] sysrq: SysRq : Show Blocked State
[Fri Mar 15 21:53:36 2019]   task                        PC stack   pid father
[Fri Mar 15 21:53:36 2019] btrfs-transacti D    0 31131      2 0x80000000
[Fri Mar 15 21:53:36 2019] Call Trace:
[Fri Mar 15 21:53:36 2019]  ? __schedule+0x429/0xbb0
[Fri Mar 15 21:53:36 2019]  schedule+0x39/0x90
[Fri Mar 15 21:53:36 2019]  schedule_timeout+0x20f/0x590
[Fri Mar 15 21:53:36 2019]  ? lock_acquire+0xbc/0x200
[Fri Mar 15 21:53:36 2019]  ? mark_held_locks+0x6a/0x90
[Fri Mar 15 21:53:36 2019]  ? _raw_spin_unlock_irq+0x29/0x40
[Fri Mar 15 21:53:36 2019]  ? wait_for_common+0x131/0x1f0
[Fri Mar 15 21:53:36 2019]  wait_for_common+0x131/0x1f0
[Fri Mar 15 21:53:36 2019]  ? wake_up_q+0x70/0x70
[Fri Mar 15 21:53:36 2019]  __start_delalloc_inodes+0x22f/0x320
[Fri Mar 15 21:53:36 2019]  btrfs_start_delalloc_roots+0x1cd/0x380
[Fri Mar 15 21:53:36 2019]  btrfs_commit_transaction+0x807/0xa20
[Fri Mar 15 21:53:36 2019]  ? start_transaction+0x89/0x4d0
[Fri Mar 15 21:53:36 2019]  transaction_kthread+0x194/0x1d0
[Fri Mar 15 21:53:36 2019]  kthread+0x10d/0x140
[Fri Mar 15 21:53:36 2019]  ? btrfs_cleanup_transaction+0x650/0x650
[Fri Mar 15 21:53:36 2019]  ? kthread_create_on_node+0x40/0x40
[Fri Mar 15 21:53:36 2019]  ret_from_fork+0x27/0x50
[Fri Mar 15 21:53:36 2019] hash_prefetch   D    0 31272  31220 0x00000000
[Fri Mar 15 21:53:36 2019] Call Trace:
[Fri Mar 15 21:53:36 2019]  ? __schedule+0x429/0xbb0
[Fri Mar 15 21:53:36 2019]  ? prepare_to_wait_event+0x97/0x190
[Fri Mar 15 21:53:36 2019]  schedule+0x39/0x90
[Fri Mar 15 21:53:36 2019]  wait_current_trans+0xa3/0xf0
[Fri Mar 15 21:53:36 2019]  ? wait_woken+0xa0/0xa0
[Fri Mar 15 21:53:36 2019]  start_transaction+0x29b/0x4d0
[Fri Mar 15 21:53:36 2019]  btrfs_create+0x47/0x1d0
[Fri Mar 15 21:53:36 2019]  lookup_open+0x404/0x760
[Fri Mar 15 21:53:36 2019]  path_openat+0x4e9/0xcc0
[Fri Mar 15 21:53:36 2019]  do_filp_open+0x8a/0xf0
[Fri Mar 15 21:53:36 2019]  ? __alloc_fd+0xee/0x200
[Fri Mar 15 21:53:36 2019]  ? do_sys_open+0x130/0x200
[Fri Mar 15 21:53:36 2019]  do_sys_open+0x130/0x200
[Fri Mar 15 21:53:36 2019]  do_syscall_64+0x76/0x180
[Fri Mar 15 21:53:36 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Fri Mar 15 21:53:36 2019] RIP: 0033:0x7fd690043607
[Fri Mar 15 21:53:36 2019] RSP: 002b:00007fd686ffbb80 EFLAGS: 00000293 ORIG_RAX: 0000000000000101
[Fri Mar 15 21:53:36 2019] RAX: ffffffffffffffda RBX: 00000000000e09c1 RCX: 00007fd690043607
[Fri Mar 15 21:53:36 2019] RDX: 00000000000e09c1 RSI: 00007fd574002590 RDI: 0000000000000003
[Fri Mar 15 21:53:36 2019] RBP: 0000000000000003 R08: 0000000000000000 R09: 00007fd686ffbf40
[Fri Mar 15 21:53:36 2019] R10: 0000000000000180 R11: 0000000000000293 R12: 00007fd574002590
[Fri Mar 15 21:53:36 2019] R13: 0000000000000003 R14: 00007fd57400b0f0 R15: 00007fd686ffc120
[Fri Mar 15 21:53:36 2019] crawl_writeback D    0 31275  31220 0x00000000
[Fri Mar 15 21:53:36 2019] Call Trace:
[Fri Mar 15 21:53:36 2019]  ? __schedule+0x429/0xbb0
[Fri Mar 15 21:53:36 2019]  ? rwsem_down_write_failed+0x134/0x2b0
[Fri Mar 15 21:53:36 2019]  schedule+0x39/0x90
[Fri Mar 15 21:53:36 2019]  rwsem_down_write_failed+0x139/0x2b0
[Fri Mar 15 21:53:36 2019]  ? lock_acquire+0xbc/0x200
[Fri Mar 15 21:53:36 2019]  ? call_rwsem_down_write_failed+0x13/0x20
[Fri Mar 15 21:53:36 2019]  call_rwsem_down_write_failed+0x13/0x20
[Fri Mar 15 21:53:36 2019]  down_write_nested+0x87/0xb0
[Fri Mar 15 21:53:36 2019]  do_unlinkat+0x113/0x300
[Fri Mar 15 21:53:36 2019]  do_syscall_64+0x76/0x180
[Fri Mar 15 21:53:36 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Fri Mar 15 21:53:36 2019] RIP: 0033:0x7fd690044ed7
[Fri Mar 15 21:53:36 2019] RSP: 002b:00007fd685ff9f58 EFLAGS: 00000246 ORIG_RAX: 0000000000000107
[Fri Mar 15 21:53:36 2019] RAX: ffffffffffffffda RBX: 00007fd685ff9f80 RCX: 00007fd690044ed7
[Fri Mar 15 21:53:36 2019] RDX: 0000000000000000 RSI: 00007fd56c0008f0 RDI: 0000000000000003
[Fri Mar 15 21:53:36 2019] RBP: 000055ccdac39f80 R08: 0000000000000000 R09: 00007fd685ffa030
[Fri Mar 15 21:53:36 2019] R10: 000055ccda9a4c80 R11: 0000000000000246 R12: 00007fd685ffa090
[Fri Mar 15 21:53:36 2019] R13: 00007fd685ffa400 R14: 00007fd685ffa3d0 R15: 00007fd685ffa350
[Fri Mar 15 21:53:36 2019] crawl_61509     D    0 20348  31220 0x00000000
[Fri Mar 15 21:53:36 2019] Call Trace:
[Fri Mar 15 21:53:36 2019]  ? __schedule+0x429/0xbb0
[Fri Mar 15 21:53:36 2019]  ? prepare_to_wait_event+0x97/0x190
[Fri Mar 15 21:53:36 2019]  schedule+0x39/0x90
[Fri Mar 15 21:53:36 2019]  wait_current_trans+0xa3/0xf0
[Fri Mar 15 21:53:36 2019]  ? wait_woken+0xa0/0xa0
[Fri Mar 15 21:53:36 2019]  start_transaction+0x29b/0x4d0
[Fri Mar 15 21:53:36 2019]  btrfs_clone+0x5a3/0xcc0
[Fri Mar 15 21:53:36 2019]  btrfs_dedupe_file_range+0x5e3/0x660
[Fri Mar 15 21:53:36 2019]  vfs_dedupe_file_range+0x22e/0x280
[Fri Mar 15 21:53:36 2019]  do_vfs_ioctl+0x24d/0x6b0
[Fri Mar 15 21:53:36 2019]  ? __fget+0x11f/0x210
[Fri Mar 15 21:53:36 2019]  SyS_ioctl+0x74/0x80
[Fri Mar 15 21:53:36 2019]  do_syscall_64+0x76/0x180
[Fri Mar 15 21:53:36 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Fri Mar 15 21:53:36 2019] RIP: 0033:0x7fd690048dd7
[Fri Mar 15 21:53:36 2019] RSP: 002b:00007fd68e760ac8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[Fri Mar 15 21:53:36 2019] RAX: ffffffffffffffda RBX: 00007fd57049edb0 RCX: 00007fd690048dd7
[Fri Mar 15 21:53:36 2019] RDX: 00007fd57049edb0 RSI: 00000000c0189436 RDI: 0000000000000627
[Fri Mar 15 21:53:36 2019] RBP: 00007fd68e760e40 R08: 00007fd5705d9950 R09: 0000000000000000
[Fri Mar 15 21:53:36 2019] R10: 00007fd5706227e0 R11: 0000000000000246 R12: 0000000000000020
[Fri Mar 15 21:53:36 2019] R13: 0000000000000018 R14: 00007fd5705d9968 R15: 00007fd68e760e48
[Fri Mar 15 21:53:36 2019] crawl_294       D    0 20349  31220 0x00000000
[Fri Mar 15 21:53:36 2019] Call Trace:
[Fri Mar 15 21:53:36 2019]  ? __schedule+0x429/0xbb0
[Fri Mar 15 21:53:36 2019]  ? rwsem_down_write_failed+0x134/0x2b0
[Fri Mar 15 21:53:36 2019]  schedule+0x39/0x90
[Fri Mar 15 21:53:36 2019]  rwsem_down_write_failed+0x139/0x2b0
[Fri Mar 15 21:53:36 2019]  ? call_rwsem_down_write_failed+0x13/0x20
[Fri Mar 15 21:53:36 2019]  call_rwsem_down_write_failed+0x13/0x20
[Fri Mar 15 21:53:36 2019]  down_write_nested+0x87/0xb0
[Fri Mar 15 21:53:36 2019]  btrfs_dedupe_file_range+0x8e/0x660
[Fri Mar 15 21:53:36 2019]  ? rcu_read_lock_sched_held+0x68/0x70
[Fri Mar 15 21:53:36 2019]  ? rcu_sync_lockdep_assert+0x30/0x60
[Fri Mar 15 21:53:36 2019]  ? __sb_start_write+0xcc/0x1b0
[Fri Mar 15 21:53:36 2019]  ? mnt_want_write_file+0x3b/0xb0
[Fri Mar 15 21:53:36 2019]  vfs_dedupe_file_range+0x22e/0x280
[Fri Mar 15 21:53:36 2019]  do_vfs_ioctl+0x24d/0x6b0
[Fri Mar 15 21:53:36 2019]  ? __fget+0x11f/0x210
[Fri Mar 15 21:53:36 2019]  SyS_ioctl+0x74/0x80
[Fri Mar 15 21:53:36 2019]  do_syscall_64+0x76/0x180
[Fri Mar 15 21:53:36 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Fri Mar 15 21:53:36 2019] RIP: 0033:0x7fd690048dd7
[Fri Mar 15 21:53:36 2019] RSP: 002b:00007fd687ffc0a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[Fri Mar 15 21:53:36 2019] RAX: ffffffffffffffda RBX: 00007fd568332780 RCX: 00007fd690048dd7
[Fri Mar 15 21:53:36 2019] RDX: 00007fd568332780 RSI: 00000000c0189436 RDI: 0000000000000067
[Fri Mar 15 21:53:36 2019] RBP: 00007fd687ffc420 R08: 00007fd56804c940 R09: 0000000000000000
[Fri Mar 15 21:53:36 2019] R10: 00007fd568022ed0 R11: 0000000000000246 R12: 0000000000000020
[Fri Mar 15 21:53:36 2019] R13: 0000000000000018 R14: 00007fd56804c958 R15: 00007fd687ffc428
[Fri Mar 15 21:53:36 2019] crawl_294       D    0 20350  31220 0x00000000
[Fri Mar 15 21:53:36 2019] Call Trace:
[Fri Mar 15 21:53:36 2019]  ? __schedule+0x429/0xbb0
[Fri Mar 15 21:53:36 2019]  ? prepare_to_wait_event+0x97/0x190
[Fri Mar 15 21:53:36 2019]  schedule+0x39/0x90
[Fri Mar 15 21:53:36 2019]  wait_current_trans+0xa3/0xf0
[Fri Mar 15 21:53:36 2019]  ? wait_woken+0xa0/0xa0
[Fri Mar 15 21:53:36 2019]  start_transaction+0x29b/0x4d0
[Fri Mar 15 21:53:36 2019]  btrfs_clone+0x5a3/0xcc0
[Fri Mar 15 21:53:36 2019]  btrfs_dedupe_file_range+0x5e3/0x660
[Fri Mar 15 21:53:36 2019]  vfs_dedupe_file_range+0x22e/0x280
[Fri Mar 15 21:53:36 2019]  do_vfs_ioctl+0x24d/0x6b0
[Fri Mar 15 21:53:36 2019]  ? __fget+0x11f/0x210
[Fri Mar 15 21:53:36 2019]  SyS_ioctl+0x74/0x80
[Fri Mar 15 21:53:36 2019]  do_syscall_64+0x76/0x180
[Fri Mar 15 21:53:36 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Fri Mar 15 21:53:36 2019] RIP: 0033:0x7fd690048dd7
[Fri Mar 15 21:53:36 2019] RSP: 002b:00007fd68cf5e0a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[Fri Mar 15 21:53:36 2019] RAX: ffffffffffffffda RBX: 00007fd55c224c70 RCX: 00007fd690048dd7
[Fri Mar 15 21:53:36 2019] RDX: 00007fd55c224c70 RSI: 00000000c0189436 RDI: 0000000000000067
[Fri Mar 15 21:53:36 2019] RBP: 00007fd68cf5e420 R08: 00007fd55c272c80 R09: 0000000000000000
[Fri Mar 15 21:53:36 2019] R10: 00007fd55c5effb0 R11: 0000000000000246 R12: 0000000000000020
[Fri Mar 15 21:53:36 2019] R13: 0000000000000018 R14: 00007fd55c272c98 R15: 00007fd68cf5e428
[Fri Mar 15 21:53:36 2019] crawl_294       D    0 25732  31220 0x00000000
[Fri Mar 15 21:53:36 2019] Call Trace:
[Fri Mar 15 21:53:36 2019]  ? __schedule+0x429/0xbb0
[Fri Mar 15 21:53:36 2019]  ? rwsem_down_write_failed+0x134/0x2b0
[Fri Mar 15 21:53:36 2019]  schedule+0x39/0x90
[Fri Mar 15 21:53:36 2019]  rwsem_down_write_failed+0x139/0x2b0
[Fri Mar 15 21:53:36 2019]  ? call_rwsem_down_write_failed+0x13/0x20
[Fri Mar 15 21:53:36 2019]  call_rwsem_down_write_failed+0x13/0x20
[Fri Mar 15 21:53:36 2019]  down_write_nested+0x87/0xb0
[Fri Mar 15 21:53:36 2019]  btrfs_dedupe_file_range+0x8e/0x660
[Fri Mar 15 21:53:36 2019]  ? rcu_read_lock_sched_held+0x68/0x70
[Fri Mar 15 21:53:36 2019]  ? rcu_sync_lockdep_assert+0x30/0x60
[Fri Mar 15 21:53:36 2019]  ? __sb_start_write+0xcc/0x1b0
[Fri Mar 15 21:53:36 2019]  ? mnt_want_write_file+0x3b/0xb0
[Fri Mar 15 21:53:36 2019]  vfs_dedupe_file_range+0x22e/0x280
[Fri Mar 15 21:53:36 2019]  do_vfs_ioctl+0x24d/0x6b0
[Fri Mar 15 21:53:36 2019]  ? __fget+0x11f/0x210
[Fri Mar 15 21:53:36 2019]  SyS_ioctl+0x74/0x80
[Fri Mar 15 21:53:36 2019]  do_syscall_64+0x76/0x180
[Fri Mar 15 21:53:36 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Fri Mar 15 21:53:36 2019] RIP: 0033:0x7fd690048dd7
[Fri Mar 15 21:53:36 2019] RSP: 002b:00007fd68ef620a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[Fri Mar 15 21:53:36 2019] RAX: ffffffffffffffda RBX: 00007fd5542c9590 RCX: 00007fd690048dd7
[Fri Mar 15 21:53:36 2019] RDX: 00007fd5542c9590 RSI: 00000000c0189436 RDI: 0000000000000067
[Fri Mar 15 21:53:36 2019] RBP: 00007fd68ef62420 R08: 00007fd5541acf90 R09: 0000000000000000
[Fri Mar 15 21:53:36 2019] R10: 00007fd5541b57a0 R11: 0000000000000246 R12: 0000000000000020
[Fri Mar 15 21:53:36 2019] R13: 0000000000000018 R14: 00007fd5541acfa8 R15: 00007fd68ef62428
[Fri Mar 15 21:53:36 2019] crawl_61509     D    0 25733  31220 0x00000000
[Fri Mar 15 21:53:36 2019] Call Trace:
[Fri Mar 15 21:53:36 2019]  ? __schedule+0x429/0xbb0
[Fri Mar 15 21:53:36 2019]  ? prepare_to_wait_event+0x97/0x190
[Fri Mar 15 21:53:36 2019]  schedule+0x39/0x90
[Fri Mar 15 21:53:36 2019]  wait_current_trans+0xa3/0xf0
[Fri Mar 15 21:53:36 2019]  ? wait_woken+0xa0/0xa0
[Fri Mar 15 21:53:36 2019]  start_transaction+0x29b/0x4d0
[Fri Mar 15 21:53:36 2019]  btrfs_clone+0x5a3/0xcc0
[Fri Mar 15 21:53:36 2019]  btrfs_dedupe_file_range+0x5e3/0x660
[Fri Mar 15 21:53:36 2019]  vfs_dedupe_file_range+0x22e/0x280
[Fri Mar 15 21:53:36 2019]  do_vfs_ioctl+0x24d/0x6b0
[Fri Mar 15 21:53:36 2019]  ? __fget+0x11f/0x210
[Fri Mar 15 21:53:36 2019]  SyS_ioctl+0x74/0x80
[Fri Mar 15 21:53:36 2019]  do_syscall_64+0x76/0x180
[Fri Mar 15 21:53:36 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Fri Mar 15 21:53:36 2019] RIP: 0033:0x7fd690048dd7
[Fri Mar 15 21:53:36 2019] RSP: 002b:00007fd68d75f0a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[Fri Mar 15 21:53:36 2019] RAX: ffffffffffffffda RBX: 00007fd56070c9b0 RCX: 00007fd690048dd7
[Fri Mar 15 21:53:36 2019] RDX: 00007fd56070c9b0 RSI: 00000000c0189436 RDI: 0000000000000427
[Fri Mar 15 21:53:36 2019] RBP: 00007fd68d75f420 R08: 00007fd560195fa0 R09: 0000000000000000
[Fri Mar 15 21:53:36 2019] R10: 00007fd56070cf80 R11: 0000000000000246 R12: 0000000000000020
[Fri Mar 15 21:53:36 2019] R13: 0000000000000018 R14: 00007fd560195fb8 R15: 00007fd68d75f428
[Fri Mar 15 21:53:36 2019] btrfs           D    0 14776  14768 0x00000000
[Fri Mar 15 21:53:36 2019] Call Trace:
[Fri Mar 15 21:53:36 2019]  ? __schedule+0x429/0xbb0
[Fri Mar 15 21:53:36 2019]  ? prepare_to_wait_event+0x97/0x190
[Fri Mar 15 21:53:36 2019]  schedule+0x39/0x90
[Fri Mar 15 21:53:36 2019]  wait_for_commit+0x3f/0x70
[Fri Mar 15 21:53:36 2019]  ? wait_woken+0xa0/0xa0
[Fri Mar 15 21:53:36 2019]  btrfs_wait_for_commit+0xf2/0x130
[Fri Mar 15 21:53:36 2019]  btrfs_inc_block_group_ro+0x52/0x170
[Fri Mar 15 21:53:36 2019]  scrub_enumerate_chunks+0x191/0x610
[Fri Mar 15 21:53:36 2019]  ? wait_woken+0x70/0xa0
[Fri Mar 15 21:53:36 2019]  btrfs_scrub_dev+0x1fa/0x650
[Fri Mar 15 21:53:36 2019]  ? mnt_want_write_file+0x3b/0xb0
[Fri Mar 15 21:53:36 2019]  btrfs_ioctl+0x1342/0x26a0
[Fri Mar 15 21:53:36 2019]  ? lock_acquire+0xbc/0x200
[Fri Mar 15 21:53:36 2019]  ? lock_acquire+0xbc/0x200
[Fri Mar 15 21:53:36 2019]  ? do_vfs_ioctl+0x92/0x6b0
[Fri Mar 15 21:53:36 2019]  do_vfs_ioctl+0x92/0x6b0
[Fri Mar 15 21:53:36 2019]  ? __fget+0x11f/0x210
[Fri Mar 15 21:53:36 2019]  SyS_ioctl+0x74/0x80
[Fri Mar 15 21:53:36 2019]  do_syscall_64+0x76/0x180
[Fri Mar 15 21:53:36 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Fri Mar 15 21:53:36 2019] RIP: 0033:0x7f3371ae0dd7
[Fri Mar 15 21:53:36 2019] RSP: 002b:00007f33719fed58 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[Fri Mar 15 21:53:36 2019] RAX: ffffffffffffffda RBX: 0000561c1b5de4f0 RCX: 00007f3371ae0dd7
[Fri Mar 15 21:53:36 2019] RDX: 0000561c1b5de4f0 RSI: 00000000c400941b RDI: 0000000000000003
[Fri Mar 15 21:53:36 2019] RBP: 0000000000000000 R08: 00007f33719ff700 R09: 0000000000000000
[Fri Mar 15 21:53:36 2019] R10: 00007f33719ff700 R11: 0000000000000246 R12: 0000000000000000
[Fri Mar 15 21:53:36 2019] R13: 00007ffe6a708eaf R14: 0000000000000000 R15: 00007f3372a7c040
[Fri Mar 15 21:53:36 2019] btrfs           D    0 14777  14768 0x00000000
[Fri Mar 15 21:53:36 2019] Call Trace:
[Fri Mar 15 21:53:36 2019]  ? __schedule+0x429/0xbb0
[Fri Mar 15 21:53:36 2019]  ? prepare_to_wait_event+0x97/0x190
[Fri Mar 15 21:53:36 2019]  schedule+0x39/0x90
[Fri Mar 15 21:53:36 2019]  wait_for_commit+0x3f/0x70
[Fri Mar 15 21:53:36 2019]  ? wait_woken+0xa0/0xa0
[Fri Mar 15 21:53:36 2019]  btrfs_wait_for_commit+0xf2/0x130
[Fri Mar 15 21:53:36 2019]  btrfs_inc_block_group_ro+0x52/0x170
[Fri Mar 15 21:53:36 2019]  scrub_enumerate_chunks+0x191/0x610
[Fri Mar 15 21:53:36 2019]  ? wait_woken+0x70/0xa0
[Fri Mar 15 21:53:36 2019]  btrfs_scrub_dev+0x1fa/0x650
[Fri Mar 15 21:53:36 2019]  ? mnt_want_write_file+0x3b/0xb0
[Fri Mar 15 21:53:36 2019]  btrfs_ioctl+0x1342/0x26a0
[Fri Mar 15 21:53:36 2019]  ? lock_acquire+0xbc/0x200
[Fri Mar 15 21:53:36 2019]  ? lock_acquire+0xbc/0x200
[Fri Mar 15 21:53:36 2019]  ? do_vfs_ioctl+0x92/0x6b0
[Fri Mar 15 21:53:36 2019]  do_vfs_ioctl+0x92/0x6b0
[Fri Mar 15 21:53:36 2019]  ? __fget+0x11f/0x210
[Fri Mar 15 21:53:36 2019]  SyS_ioctl+0x74/0x80
[Fri Mar 15 21:53:36 2019]  do_syscall_64+0x76/0x180
[Fri Mar 15 21:53:36 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Fri Mar 15 21:53:36 2019] RIP: 0033:0x7f3371ae0dd7
[Fri Mar 15 21:53:36 2019] RSP: 002b:00007f33711fdd58 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[Fri Mar 15 21:53:36 2019] RAX: ffffffffffffffda RBX: 0000561c1b5de970 RCX: 00007f3371ae0dd7
[Fri Mar 15 21:53:36 2019] RDX: 0000561c1b5de970 RSI: 00000000c400941b RDI: 0000000000000003
[Fri Mar 15 21:53:36 2019] RBP: 0000000000000000 R08: 00007f33711fe700 R09: 0000000000000000
[Fri Mar 15 21:53:36 2019] R10: 00007f33711fe700 R11: 0000000000000246 R12: 0000000000000000
[Fri Mar 15 21:53:36 2019] R13: 00007ffe6a708eaf R14: 0000000000000000 R15: 00007f3372a7c040
[Fri Mar 15 21:53:36 2019] btrfs           D    0 14778  14768 0x00000000
[Fri Mar 15 21:53:36 2019] Call Trace:
[Fri Mar 15 21:53:36 2019]  ? __schedule+0x429/0xbb0
[Fri Mar 15 21:53:36 2019]  ? prepare_to_wait_event+0x97/0x190
[Fri Mar 15 21:53:36 2019]  schedule+0x39/0x90
[Fri Mar 15 21:53:36 2019]  wait_for_commit+0x3f/0x70
[Fri Mar 15 21:53:36 2019]  ? wait_woken+0xa0/0xa0
[Fri Mar 15 21:53:36 2019]  btrfs_wait_for_commit+0xf2/0x130
[Fri Mar 15 21:53:36 2019]  btrfs_inc_block_group_ro+0x52/0x170
[Fri Mar 15 21:53:36 2019]  scrub_enumerate_chunks+0x191/0x610
[Fri Mar 15 21:53:36 2019]  ? wait_woken+0x70/0xa0
[Fri Mar 15 21:53:36 2019]  btrfs_scrub_dev+0x1fa/0x650
[Fri Mar 15 21:53:36 2019]  ? mnt_want_write_file+0x3b/0xb0
[Fri Mar 15 21:53:36 2019]  btrfs_ioctl+0x1342/0x26a0
[Fri Mar 15 21:53:36 2019]  ? lock_acquire+0xbc/0x200
[Fri Mar 15 21:53:36 2019]  ? lock_acquire+0xbc/0x200
[Fri Mar 15 21:53:36 2019]  ? do_vfs_ioctl+0x92/0x6b0
[Fri Mar 15 21:53:36 2019]  do_vfs_ioctl+0x92/0x6b0
[Fri Mar 15 21:53:36 2019]  ? __fget+0x11f/0x210
[Fri Mar 15 21:53:36 2019]  SyS_ioctl+0x74/0x80
[Fri Mar 15 21:53:36 2019]  do_syscall_64+0x76/0x180
[Fri Mar 15 21:53:36 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Fri Mar 15 21:53:36 2019] RIP: 0033:0x7f3371ae0dd7
[Fri Mar 15 21:53:36 2019] RSP: 002b:00007f33709fcd58 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[Fri Mar 15 21:53:36 2019] RAX: ffffffffffffffda RBX: 0000561c1b5dedf0 RCX: 00007f3371ae0dd7
[Fri Mar 15 21:53:36 2019] RDX: 0000561c1b5dedf0 RSI: 00000000c400941b RDI: 0000000000000003
[Fri Mar 15 21:53:36 2019] RBP: 0000000000000000 R08: 00007f33709fd700 R09: 0000000000000000
[Fri Mar 15 21:53:36 2019] R10: 00007f33709fd700 R11: 0000000000000246 R12: 0000000000000000
[Fri Mar 15 21:53:36 2019] R13: 00007ffe6a708eaf R14: 0000000000000000 R15: 00007f3372a7c040
[Fri Mar 15 21:53:36 2019] btrfs           D    0 14779  14768 0x00000000
[Fri Mar 15 21:53:36 2019] Call Trace:
[Fri Mar 15 21:53:36 2019]  ? __schedule+0x429/0xbb0
[Fri Mar 15 21:53:36 2019]  ? prepare_to_wait_event+0x97/0x190
[Fri Mar 15 21:53:36 2019]  schedule+0x39/0x90
[Fri Mar 15 21:53:36 2019]  wait_for_commit+0x3f/0x70
[Fri Mar 15 21:53:36 2019]  ? wait_woken+0xa0/0xa0
[Fri Mar 15 21:53:36 2019]  btrfs_wait_for_commit+0xf2/0x130
[Fri Mar 15 21:53:36 2019]  btrfs_inc_block_group_ro+0x52/0x170
[Fri Mar 15 21:53:36 2019]  scrub_enumerate_chunks+0x191/0x610
[Fri Mar 15 21:53:36 2019]  ? wait_woken+0x70/0xa0
[Fri Mar 15 21:53:36 2019]  btrfs_scrub_dev+0x1fa/0x650
[Fri Mar 15 21:53:36 2019]  ? mnt_want_write_file+0x3b/0xb0
[Fri Mar 15 21:53:36 2019]  btrfs_ioctl+0x1342/0x26a0
[Fri Mar 15 21:53:36 2019]  ? lock_acquire+0xbc/0x200
[Fri Mar 15 21:53:36 2019]  ? lock_acquire+0xbc/0x200
[Fri Mar 15 21:53:36 2019]  ? do_vfs_ioctl+0x92/0x6b0
[Fri Mar 15 21:53:36 2019]  do_vfs_ioctl+0x92/0x6b0
[Fri Mar 15 21:53:36 2019]  ? __fget+0x11f/0x210
[Fri Mar 15 21:53:36 2019]  SyS_ioctl+0x74/0x80
[Fri Mar 15 21:53:36 2019]  do_syscall_64+0x76/0x180
[Fri Mar 15 21:53:36 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Fri Mar 15 21:53:36 2019] RIP: 0033:0x7f3371ae0dd7
[Fri Mar 15 21:53:36 2019] RSP: 002b:00007f33701fbd58 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[Fri Mar 15 21:53:36 2019] RAX: ffffffffffffffda RBX: 0000561c1b5df270 RCX: 00007f3371ae0dd7
[Fri Mar 15 21:53:36 2019] RDX: 0000561c1b5df270 RSI: 00000000c400941b RDI: 0000000000000003
[Fri Mar 15 21:53:36 2019] RBP: 0000000000000000 R08: 00007f33701fc700 R09: 0000000000000000
[Fri Mar 15 21:53:36 2019] R10: 00007f33701fc700 R11: 0000000000000246 R12: 0000000000000000
[Fri Mar 15 21:53:36 2019] R13: 00007ffe6a708eaf R14: 0000000000000000 R15: 00007f3372a7c040
[Fri Mar 15 21:53:36 2019] btrfs           D    0 14780  14768 0x00000000
[Fri Mar 15 21:53:36 2019] Call Trace:
[Fri Mar 15 21:53:36 2019]  ? __schedule+0x429/0xbb0
[Fri Mar 15 21:53:36 2019]  ? prepare_to_wait_event+0x97/0x190
[Fri Mar 15 21:53:36 2019]  schedule+0x39/0x90
[Fri Mar 15 21:53:36 2019]  wait_for_commit+0x3f/0x70
[Fri Mar 15 21:53:36 2019]  ? wait_woken+0xa0/0xa0
[Fri Mar 15 21:53:36 2019]  btrfs_wait_for_commit+0xf2/0x130
[Fri Mar 15 21:53:36 2019]  btrfs_inc_block_group_ro+0x52/0x170
[Fri Mar 15 21:53:36 2019]  scrub_enumerate_chunks+0x191/0x610
[Fri Mar 15 21:53:36 2019]  ? wait_woken+0x70/0xa0
[Fri Mar 15 21:53:36 2019]  btrfs_scrub_dev+0x1fa/0x650
[Fri Mar 15 21:53:36 2019]  ? mnt_want_write_file+0x3b/0xb0
[Fri Mar 15 21:53:36 2019]  btrfs_ioctl+0x1342/0x26a0
[Fri Mar 15 21:53:36 2019]  ? lock_acquire+0xbc/0x200
[Fri Mar 15 21:53:36 2019]  ? lock_acquire+0xbc/0x200
[Fri Mar 15 21:53:36 2019]  ? do_vfs_ioctl+0x92/0x6b0
[Fri Mar 15 21:53:36 2019]  do_vfs_ioctl+0x92/0x6b0
[Fri Mar 15 21:53:36 2019]  ? __fget+0x11f/0x210
[Fri Mar 15 21:53:36 2019]  SyS_ioctl+0x74/0x80
[Fri Mar 15 21:53:36 2019]  do_syscall_64+0x76/0x180
[Fri Mar 15 21:53:36 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Fri Mar 15 21:53:36 2019] RIP: 0033:0x7f3371ae0dd7
[Fri Mar 15 21:53:36 2019] RSP: 002b:00007f336f9fad58 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[Fri Mar 15 21:53:36 2019] RAX: ffffffffffffffda RBX: 0000561c1b5df6f0 RCX: 00007f3371ae0dd7
[Fri Mar 15 21:53:36 2019] RDX: 0000561c1b5df6f0 RSI: 00000000c400941b RDI: 0000000000000003
[Fri Mar 15 21:53:36 2019] RBP: 0000000000000000 R08: 00007f336f9fb700 R09: 0000000000000000
[Fri Mar 15 21:53:36 2019] R10: 00007f336f9fb700 R11: 0000000000000246 R12: 0000000000000000
[Fri Mar 15 21:53:36 2019] R13: 00007ffe6a708eaf R14: 0000000000000000 R15: 00007f3372a7c040
[Fri Mar 15 21:53:36 2019] kworker/u8:5    D    0  5813      2 0x80000000
[Fri Mar 15 21:53:36 2019] Workqueue: btrfs-flush_delalloc btrfs_flush_delalloc_helper
[Fri Mar 15 21:53:36 2019] Call Trace:
[Fri Mar 15 21:53:36 2019]  ? __schedule+0x429/0xbb0
[Fri Mar 15 21:53:36 2019]  schedule+0x39/0x90
[Fri Mar 15 21:53:36 2019]  io_schedule+0x12/0x40
[Fri Mar 15 21:53:36 2019]  __lock_page+0x110/0x140
[Fri Mar 15 21:53:36 2019]  ? add_to_page_cache_lru+0xc0/0xc0
[Fri Mar 15 21:53:36 2019]  extent_write_cache_pages.constprop.27+0x2d9/0x3b0
[Fri Mar 15 21:53:36 2019]  ? lock_acquire+0xbc/0x200
[Fri Mar 15 21:53:36 2019]  extent_writepages+0x4e/0x70
[Fri Mar 15 21:53:36 2019]  ? btrfs_direct_IO+0x3e0/0x3e0
[Fri Mar 15 21:53:36 2019]  do_writepages+0x23/0x80
[Fri Mar 15 21:53:36 2019]  __filemap_fdatawrite_range+0xaa/0xe0
[Fri Mar 15 21:53:36 2019]  btrfs_run_delalloc_work+0x17/0x60
[Fri Mar 15 21:53:36 2019]  btrfs_scrubparity_helper+0x8f/0x640
[Fri Mar 15 21:53:36 2019]  process_one_work+0x204/0x650
[Fri Mar 15 21:53:36 2019]  worker_thread+0x4d/0x3b0
[Fri Mar 15 21:53:36 2019]  kthread+0x10d/0x140
[Fri Mar 15 21:53:36 2019]  ? process_one_work+0x650/0x650
[Fri Mar 15 21:53:36 2019]  ? kthread_create_on_node+0x40/0x40
[Fri Mar 15 21:53:36 2019]  ret_from_fork+0x27/0x50
[Fri Mar 15 21:53:36 2019] rsync           D    0 26929  26812 0x00000000
[Fri Mar 15 21:53:36 2019] Call Trace:
[Fri Mar 15 21:53:36 2019]  ? __schedule+0x429/0xbb0
[Fri Mar 15 21:53:36 2019]  ? prepare_to_wait_event+0x97/0x190
[Fri Mar 15 21:53:36 2019]  schedule+0x39/0x90
[Fri Mar 15 21:53:36 2019]  wait_current_trans+0xa3/0xf0
[Fri Mar 15 21:53:36 2019]  ? wait_woken+0xa0/0xa0
[Fri Mar 15 21:53:36 2019]  start_transaction+0x29b/0x4d0
[Fri Mar 15 21:53:36 2019]  btrfs_start_transaction_fallback_global_rsv+0x34/0x200
[Fri Mar 15 21:53:36 2019]  btrfs_rmdir+0x67/0x180
[Fri Mar 15 21:53:36 2019]  vfs_rmdir+0xbb/0x140
[Fri Mar 15 21:53:36 2019]  do_rmdir+0x1fe/0x210
[Fri Mar 15 21:53:36 2019]  do_syscall_64+0x76/0x180
[Fri Mar 15 21:53:36 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Fri Mar 15 21:53:36 2019] RIP: 0033:0x7ff34b804f07
[Fri Mar 15 21:53:36 2019] RSP: 002b:00007ffe20b69618 EFLAGS: 00000246 ORIG_RAX: 0000000000000054
[Fri Mar 15 21:53:36 2019] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007ff34b804f07
[Fri Mar 15 21:53:36 2019] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00007ffe20b69680
[Fri Mar 15 21:53:36 2019] RBP: 00000000000041ed R08: 0000000000000000 R09: 0000000000008000
[Fri Mar 15 21:53:36 2019] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe20b69680
[Fri Mar 15 21:53:36 2019] R13: 0000000000004000 R14: 0000000000000000 R15: 00000000000041ed
[Fri Mar 15 21:53:36 2019] mkdir           D    0 25975  25972 0x00000000
[Fri Mar 15 21:53:36 2019] Call Trace:
[Fri Mar 15 21:53:36 2019]  ? __schedule+0x429/0xbb0
[Fri Mar 15 21:53:36 2019]  ? prepare_to_wait_event+0x97/0x190
[Fri Mar 15 21:53:36 2019]  schedule+0x39/0x90
[Fri Mar 15 21:53:36 2019]  wait_current_trans+0xa3/0xf0
[Fri Mar 15 21:53:36 2019]  ? wait_woken+0xa0/0xa0
[Fri Mar 15 21:53:36 2019]  start_transaction+0x29b/0x4d0
[Fri Mar 15 21:53:36 2019]  btrfs_mkdir+0x50/0x1d0
[Fri Mar 15 21:53:36 2019]  vfs_mkdir+0x134/0x1c0
[Fri Mar 15 21:53:36 2019]  SyS_mkdirat+0xb3/0xf0
[Fri Mar 15 21:53:36 2019]  do_syscall_64+0x76/0x180
[Fri Mar 15 21:53:36 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Fri Mar 15 21:53:36 2019] RIP: 0033:0x7fa5def83447
[Fri Mar 15 21:53:36 2019] RSP: 002b:00007ffcd2af2258 EFLAGS: 00000206 ORIG_RAX: 0000000000000053
[Fri Mar 15 21:53:36 2019] RAX: ffffffffffffffda RBX: 00007ffcd2af2b28 RCX: 00007fa5def83447
[Fri Mar 15 21:53:36 2019] RDX: 0000000000000000 RSI: 00000000000001ff RDI: 00007ffcd2af2b4d
[Fri Mar 15 21:53:36 2019] RBP: 00007ffcd2af23d0 R08: 00000000000001ff R09: 000055775e473e10
[Fri Mar 15 21:53:36 2019] R10: 0000000000000376 R11: 0000000000000206 R12: 000055775e473e50
[Fri Mar 15 21:53:36 2019] R13: 00000000000001ff R14: 00007ffcd2af2570 R15: 0000000000000001
[Fri Mar 15 21:53:36 2019] rsync           D    0 13191  13160 0x00000000
[Fri Mar 15 21:53:36 2019] Call Trace:
[Fri Mar 15 21:53:36 2019]  ? __schedule+0x429/0xbb0
[Fri Mar 15 21:53:36 2019]  ? prepare_to_wait_event+0x97/0x190
[Fri Mar 15 21:53:36 2019]  schedule+0x39/0x90
[Fri Mar 15 21:53:36 2019]  wait_current_trans+0xa3/0xf0
[Fri Mar 15 21:53:36 2019]  ? wait_woken+0xa0/0xa0
[Fri Mar 15 21:53:36 2019]  start_transaction+0x29b/0x4d0
[Fri Mar 15 21:53:36 2019]  btrfs_create+0x47/0x1d0
[Fri Mar 15 21:53:36 2019]  lookup_open+0x404/0x760
[Fri Mar 15 21:53:36 2019]  ? __wake_up_common_lock+0x53/0x90
[Fri Mar 15 21:53:36 2019]  path_openat+0x4e9/0xcc0
[Fri Mar 15 21:53:36 2019]  ? filemap_map_pages+0x312/0x520
[Fri Mar 15 21:53:36 2019]  do_filp_open+0x8a/0xf0
[Fri Mar 15 21:53:36 2019]  ? __alloc_fd+0xee/0x200
[Fri Mar 15 21:53:36 2019]  ? do_sys_open+0x130/0x200
[Fri Mar 15 21:53:36 2019]  do_sys_open+0x130/0x200
[Fri Mar 15 21:53:36 2019]  do_syscall_64+0x76/0x180
[Fri Mar 15 21:53:36 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Fri Mar 15 21:53:36 2019] RIP: 0033:0x7f10ce1e34b0
[Fri Mar 15 21:53:36 2019] RSP: 002b:00007ffcc3812488 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
[Fri Mar 15 21:53:36 2019] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f10ce1e34b0
[Fri Mar 15 21:53:36 2019] RDX: 0000000000000180 RSI: 00000000000000c2 RDI: 00007ffcc38146f0
[Fri Mar 15 21:53:36 2019] RBP: 000000000003a2f8 R08: 000000000000c0ff R09: 00007f10ce235950
[Fri Mar 15 21:53:36 2019] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffcc3814707
[Fri Mar 15 21:53:36 2019] R13: 8421084210842109 R14: 00000000000000c2 R15: 00007f10ce271320
[Fri Mar 15 21:53:36 2019] rsync           D    0   530    529 0x00000000
[Fri Mar 15 21:53:36 2019] Call Trace:
[Fri Mar 15 21:53:36 2019]  ? __schedule+0x429/0xbb0
[Fri Mar 15 21:53:36 2019]  ? prepare_to_wait_event+0x97/0x190
[Fri Mar 15 21:53:36 2019]  schedule+0x39/0x90
[Fri Mar 15 21:53:36 2019]  wait_current_trans+0xa3/0xf0
[Fri Mar 15 21:53:36 2019]  ? wait_woken+0xa0/0xa0
[Fri Mar 15 21:53:36 2019]  start_transaction+0x29b/0x4d0
[Fri Mar 15 21:53:36 2019]  btrfs_create+0x47/0x1d0
[Fri Mar 15 21:53:36 2019]  lookup_open+0x404/0x760
[Fri Mar 15 21:53:36 2019]  ? __wake_up_common_lock+0x53/0x90
[Fri Mar 15 21:53:36 2019]  path_openat+0x4e9/0xcc0
[Fri Mar 15 21:53:36 2019]  ? filemap_map_pages+0x312/0x520
[Fri Mar 15 21:53:36 2019]  do_filp_open+0x8a/0xf0
[Fri Mar 15 21:53:36 2019]  ? __alloc_fd+0xee/0x200
[Fri Mar 15 21:53:36 2019]  ? do_sys_open+0x130/0x200
[Fri Mar 15 21:53:36 2019]  do_sys_open+0x130/0x200
[Fri Mar 15 21:53:36 2019]  do_syscall_64+0x76/0x180
[Fri Mar 15 21:53:36 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Fri Mar 15 21:53:36 2019] RIP: 0033:0x7f64876134b0
[Fri Mar 15 21:53:36 2019] RSP: 002b:00007ffe8bd0d108 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
[Fri Mar 15 21:53:36 2019] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f64876134b0
[Fri Mar 15 21:53:36 2019] RDX: 0000000000000180 RSI: 00000000000000c2 RDI: 00007ffe8bd0f370
[Fri Mar 15 21:53:36 2019] RBP: 000000000003a2f8 R08: 000000000000c0ff R09: 00007f6487665950
[Fri Mar 15 21:53:36 2019] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe8bd0f387
[Fri Mar 15 21:53:36 2019] R13: 8421084210842109 R14: 00000000000000c2 R15: 00007f64876a1320
[Fri Mar 15 21:53:36 2019] rsync           D    0  5301   5152 0x00000000
[Fri Mar 15 21:53:36 2019] Call Trace:
[Fri Mar 15 21:53:36 2019]  ? __schedule+0x429/0xbb0
[Fri Mar 15 21:53:36 2019]  ? prepare_to_wait_event+0x97/0x190
[Fri Mar 15 21:53:36 2019]  schedule+0x39/0x90
[Fri Mar 15 21:53:36 2019]  wait_current_trans+0xa3/0xf0
[Fri Mar 15 21:53:36 2019]  ? wait_woken+0xa0/0xa0
[Fri Mar 15 21:53:36 2019]  start_transaction+0x29b/0x4d0
[Fri Mar 15 21:53:36 2019]  btrfs_create+0x47/0x1d0
[Fri Mar 15 21:53:36 2019]  lookup_open+0x404/0x760
[Fri Mar 15 21:53:36 2019]  ? __wake_up_common_lock+0x53/0x90
[Fri Mar 15 21:53:36 2019]  path_openat+0x4e9/0xcc0
[Fri Mar 15 21:53:36 2019]  ? filemap_map_pages+0x312/0x520
[Fri Mar 15 21:53:36 2019]  do_filp_open+0x8a/0xf0
[Fri Mar 15 21:53:36 2019]  ? __alloc_fd+0xee/0x200
[Fri Mar 15 21:53:36 2019]  ? do_sys_open+0x130/0x200
[Fri Mar 15 21:53:36 2019]  do_sys_open+0x130/0x200
[Fri Mar 15 21:53:36 2019]  do_syscall_64+0x76/0x180
[Fri Mar 15 21:53:36 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Fri Mar 15 21:53:36 2019] RIP: 0033:0x7f8f498434b0
[Fri Mar 15 21:53:36 2019] RSP: 002b:00007ffc794a2168 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
[Fri Mar 15 21:53:36 2019] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f8f498434b0
[Fri Mar 15 21:53:36 2019] RDX: 0000000000000180 RSI: 00000000000000c2 RDI: 00007ffc794a43d0
[Fri Mar 15 21:53:36 2019] RBP: 000000000003a2f8 R08: 000000000000fff8 R09: 00007f8f49895f10
[Fri Mar 15 21:53:36 2019] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffc794a43ed
[Fri Mar 15 21:53:36 2019] R13: 8421084210842109 R14: 00000000000000c2 R15: 00007f8f498d1320
[Fri Mar 15 21:53:36 2019] rsync           D    0  7098   7002 0x00000000
[Fri Mar 15 21:53:36 2019] Call Trace:
[Fri Mar 15 21:53:36 2019]  ? __schedule+0x429/0xbb0
[Fri Mar 15 21:53:36 2019]  ? prepare_to_wait_event+0x97/0x190
[Fri Mar 15 21:53:36 2019]  schedule+0x39/0x90
[Fri Mar 15 21:53:36 2019]  wait_current_trans+0xa3/0xf0
[Fri Mar 15 21:53:36 2019]  ? wait_woken+0xa0/0xa0
[Fri Mar 15 21:53:36 2019]  start_transaction+0x29b/0x4d0
[Fri Mar 15 21:53:36 2019]  btrfs_create+0x47/0x1d0
[Fri Mar 15 21:53:36 2019]  lookup_open+0x404/0x760
[Fri Mar 15 21:53:36 2019]  ? __wake_up_common_lock+0x53/0x90
[Fri Mar 15 21:53:36 2019]  path_openat+0x4e9/0xcc0
[Fri Mar 15 21:53:36 2019]  ? filemap_map_pages+0x312/0x520
[Fri Mar 15 21:53:36 2019]  do_filp_open+0x8a/0xf0
[Fri Mar 15 21:53:36 2019]  ? __alloc_fd+0xee/0x200
[Fri Mar 15 21:53:36 2019]  ? do_sys_open+0x130/0x200
[Fri Mar 15 21:53:36 2019]  do_sys_open+0x130/0x200
[Fri Mar 15 21:53:36 2019]  do_syscall_64+0x76/0x180
[Fri Mar 15 21:53:36 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Fri Mar 15 21:53:36 2019] RIP: 0033:0x7fddb705b4b0
[Fri Mar 15 21:53:36 2019] RSP: 002b:00007ffcd2922968 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
[Fri Mar 15 21:53:36 2019] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fddb705b4b0
[Fri Mar 15 21:53:36 2019] RDX: 0000000000000180 RSI: 00000000000000c2 RDI: 00007ffcd2924bd0
[Fri Mar 15 21:53:36 2019] RBP: 000000000003a2f8 R08: 000000000000ffff R09: 00007fddb70adb30
[Fri Mar 15 21:53:36 2019] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffcd2924c10
[Fri Mar 15 21:53:36 2019] R13: 8421084210842109 R14: 00000000000000c2 R15: 00007fddb70e9320
[Fri Mar 15 21:53:36 2019] rsync           D    0 18905  18820 0x00000000
[Fri Mar 15 21:53:36 2019] Call Trace:
[Fri Mar 15 21:53:36 2019]  ? __schedule+0x429/0xbb0
[Fri Mar 15 21:53:36 2019]  ? prepare_to_wait_event+0x97/0x190
[Fri Mar 15 21:53:36 2019]  schedule+0x39/0x90
[Fri Mar 15 21:53:36 2019]  wait_current_trans+0xa3/0xf0
[Fri Mar 15 21:53:36 2019]  ? wait_woken+0xa0/0xa0
[Fri Mar 15 21:53:36 2019]  start_transaction+0x29b/0x4d0
[Fri Mar 15 21:53:36 2019]  btrfs_start_transaction_fallback_global_rsv+0x34/0x200
[Fri Mar 15 21:53:36 2019]  btrfs_unlink+0x30/0xd0
[Fri Mar 15 21:53:36 2019]  vfs_unlink+0xf8/0x190
[Fri Mar 15 21:53:36 2019]  do_unlinkat+0x287/0x300
[Fri Mar 15 21:53:36 2019]  do_syscall_64+0x76/0x180
[Fri Mar 15 21:53:36 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Fri Mar 15 21:53:36 2019] RIP: 0033:0x7f61535dcea7
[Fri Mar 15 21:53:36 2019] RSP: 002b:00007ffe50a14ae8 EFLAGS: 00000246 ORIG_RAX: 0000000000000057
[Fri Mar 15 21:53:36 2019] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007f61535dcea7
[Fri Mar 15 21:53:36 2019] RDX: 0000000000000000 RSI: 00000000000081a4 RDI: 00007ffe50a15c60
[Fri Mar 15 21:53:36 2019] RBP: 00000000000081a4 R08: 000000000000fccf R09: 00007f615362def0
[Fri Mar 15 21:53:36 2019] R10: 00007f615137300a R11: 0000000000000246 R12: 00007ffe50a15c60
[Fri Mar 15 21:53:36 2019] R13: 0000000000008000 R14: 0000000000000000 R15: 00000000000081a4
[Fri Mar 15 21:53:36 2019] rsync           D    0 26494  26493 0x00000000
[Fri Mar 15 21:53:36 2019] Call Trace:
[Fri Mar 15 21:53:36 2019]  ? __schedule+0x429/0xbb0
[Fri Mar 15 21:53:36 2019]  ? prepare_to_wait_event+0x97/0x190
[Fri Mar 15 21:53:36 2019]  schedule+0x39/0x90
[Fri Mar 15 21:53:36 2019]  wait_current_trans+0xa3/0xf0
[Fri Mar 15 21:53:36 2019]  ? wait_woken+0xa0/0xa0
[Fri Mar 15 21:53:36 2019]  start_transaction+0x29b/0x4d0
[Fri Mar 15 21:53:36 2019]  btrfs_create+0x47/0x1d0
[Fri Mar 15 21:53:36 2019]  lookup_open+0x404/0x760
[Fri Mar 15 21:53:36 2019]  ? __wake_up_common_lock+0x53/0x90
[Fri Mar 15 21:53:36 2019]  path_openat+0x4e9/0xcc0
[Fri Mar 15 21:53:36 2019]  ? filemap_map_pages+0x312/0x520
[Fri Mar 15 21:53:36 2019]  do_filp_open+0x8a/0xf0
[Fri Mar 15 21:53:36 2019]  ? __alloc_fd+0xee/0x200
[Fri Mar 15 21:53:36 2019]  ? do_sys_open+0x130/0x200
[Fri Mar 15 21:53:36 2019]  do_sys_open+0x130/0x200
[Fri Mar 15 21:53:36 2019]  do_syscall_64+0x76/0x180
[Fri Mar 15 21:53:36 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Fri Mar 15 21:53:36 2019] RIP: 0033:0x7fe53c5c34b0
[Fri Mar 15 21:53:36 2019] RSP: 002b:00007ffd48eca238 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
[Fri Mar 15 21:53:36 2019] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fe53c5c34b0
[Fri Mar 15 21:53:36 2019] RDX: 0000000000000180 RSI: 00000000000000c2 RDI: 00007ffd48ecc4a0
[Fri Mar 15 21:53:36 2019] RBP: 000000000003a2f8 R08: 000000000000c0ff R09: 00007fe53c615950
[Fri Mar 15 21:53:36 2019] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffd48ecc4b7
[Fri Mar 15 21:53:36 2019] R13: 8421084210842109 R14: 00000000000000c2 R15: 00007fe53c651320
[Fri Mar 15 21:53:36 2019] rsync           D    0 12384  12322 0x00000000
[Fri Mar 15 21:53:36 2019] Call Trace:
[Fri Mar 15 21:53:36 2019]  ? __schedule+0x429/0xbb0
[Fri Mar 15 21:53:36 2019]  ? prepare_to_wait_event+0x97/0x190
[Fri Mar 15 21:53:36 2019]  schedule+0x39/0x90
[Fri Mar 15 21:53:36 2019]  wait_current_trans+0xa3/0xf0
[Fri Mar 15 21:53:36 2019]  ? wait_woken+0xa0/0xa0
[Fri Mar 15 21:53:36 2019]  start_transaction+0x29b/0x4d0
[Fri Mar 15 21:53:36 2019]  btrfs_create+0x47/0x1d0
[Fri Mar 15 21:53:36 2019]  lookup_open+0x404/0x760
[Fri Mar 15 21:53:36 2019]  ? __wake_up_common_lock+0x53/0x90
[Fri Mar 15 21:53:36 2019]  path_openat+0x4e9/0xcc0
[Fri Mar 15 21:53:36 2019]  ? filemap_map_pages+0x312/0x520
[Fri Mar 15 21:53:36 2019]  do_filp_open+0x8a/0xf0
[Fri Mar 15 21:53:36 2019]  ? __alloc_fd+0xee/0x200
[Fri Mar 15 21:53:36 2019]  ? do_sys_open+0x130/0x200
[Fri Mar 15 21:53:36 2019]  do_sys_open+0x130/0x200
[Fri Mar 15 21:53:36 2019]  do_syscall_64+0x76/0x180
[Fri Mar 15 21:53:36 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Fri Mar 15 21:53:36 2019] RIP: 0033:0x7f57d716b4b0
[Fri Mar 15 21:53:36 2019] RSP: 002b:00007ffd8a2a00a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
[Fri Mar 15 21:53:36 2019] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f57d716b4b0
[Fri Mar 15 21:53:36 2019] RDX: 0000000000000180 RSI: 00000000000000c2 RDI: 00007ffd8a2a2310
[Fri Mar 15 21:53:36 2019] RBP: 000000000003a2f8 R08: 0000000000000000 R09: 00007f57d71be100
[Fri Mar 15 21:53:36 2019] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffd8a2a233b
[Fri Mar 15 21:53:36 2019] R13: 8421084210842109 R14: 00000000000000c2 R15: 00007f57d71f9320
[Fri Mar 15 21:53:36 2019] rsync           D    0 21369  21368 0x00000000
[Fri Mar 15 21:53:36 2019] Call Trace:
[Fri Mar 15 21:53:36 2019]  ? __schedule+0x429/0xbb0
[Fri Mar 15 21:53:36 2019]  ? prepare_to_wait_event+0x97/0x190
[Fri Mar 15 21:53:36 2019]  schedule+0x39/0x90
[Fri Mar 15 21:53:36 2019]  wait_current_trans+0xa3/0xf0
[Fri Mar 15 21:53:36 2019]  ? wait_woken+0xa0/0xa0
[Fri Mar 15 21:53:36 2019]  start_transaction+0x29b/0x4d0
[Fri Mar 15 21:53:36 2019]  btrfs_create+0x47/0x1d0
[Fri Mar 15 21:53:36 2019]  lookup_open+0x404/0x760
[Fri Mar 15 21:53:36 2019]  ? __wake_up_common_lock+0x53/0x90
[Fri Mar 15 21:53:36 2019]  path_openat+0x4e9/0xcc0
[Fri Mar 15 21:53:36 2019]  ? filemap_map_pages+0x312/0x520
[Fri Mar 15 21:53:36 2019]  do_filp_open+0x8a/0xf0
[Fri Mar 15 21:53:36 2019]  ? __alloc_fd+0xee/0x200
[Fri Mar 15 21:53:36 2019]  ? do_sys_open+0x130/0x200
[Fri Mar 15 21:53:36 2019]  do_sys_open+0x130/0x200
[Fri Mar 15 21:53:36 2019]  do_syscall_64+0x76/0x180
[Fri Mar 15 21:53:36 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Fri Mar 15 21:53:36 2019] RIP: 0033:0x7fae262bb4b0
[Fri Mar 15 21:53:36 2019] RSP: 002b:00007fff14b786b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
[Fri Mar 15 21:53:36 2019] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fae262bb4b0
[Fri Mar 15 21:53:36 2019] RDX: 0000000000000180 RSI: 00000000000000c2 RDI: 00007fff14b7a920
[Fri Mar 15 21:53:36 2019] RBP: 000000000003a2f8 R08: 000000000000c0ff R09: 00007fae2630d950
[Fri Mar 15 21:53:36 2019] R10: 0000000000000000 R11: 0000000000000246 R12: 00007fff14b7a937
[Fri Mar 15 21:53:36 2019] R13: 8421084210842109 R14: 00000000000000c2 R15: 00007fae26349320
[Fri Mar 15 21:53:36 2019] watchdog-mdtest D    0 30096  25972 0x00000000
[Fri Mar 15 21:53:36 2019] Call Trace:
[Fri Mar 15 21:53:36 2019]  ? __schedule+0x429/0xbb0
[Fri Mar 15 21:53:36 2019]  schedule+0x39/0x90
[Fri Mar 15 21:53:36 2019]  io_schedule+0x12/0x40
[Fri Mar 15 21:53:36 2019]  wait_on_page_bit+0x10d/0x140
[Fri Mar 15 21:53:36 2019]  ? add_to_page_cache_lru+0xc0/0xc0
[Fri Mar 15 21:53:36 2019]  read_extent_buffer_pages+0x215/0x2d0
[Fri Mar 15 21:53:36 2019]  ? free_root_pointers+0x60/0x60
[Fri Mar 15 21:53:36 2019]  btree_read_extent_buffer_pages+0x86/0x100
[Fri Mar 15 21:53:36 2019]  read_tree_block+0x2d/0x50
[Fri Mar 15 21:53:36 2019]  read_block_for_search.isra.11+0x117/0x310
[Fri Mar 15 21:53:36 2019]  btrfs_search_slot+0x3e7/0x9c0
[Fri Mar 15 21:53:36 2019]  btrfs_lookup_dir_item+0x69/0xb0
[Fri Mar 15 21:53:36 2019]  btrfs_lookup_dentry+0xa0/0x530
[Fri Mar 15 21:53:36 2019]  ? lookup_slow+0xe7/0x210
[Fri Mar 15 21:53:36 2019]  btrfs_lookup+0xe/0x30
[Fri Mar 15 21:53:36 2019]  lookup_slow+0x131/0x210
[Fri Mar 15 21:53:36 2019]  walk_component+0x1b2/0x2d0
[Fri Mar 15 21:53:36 2019]  path_lookupat+0x64/0x1f0
[Fri Mar 15 21:53:36 2019]  filename_lookup+0xa9/0x170
[Fri Mar 15 21:53:36 2019]  ? getname_flags+0x4a/0x1e0
[Fri Mar 15 21:53:36 2019]  ? __check_object_size+0xa7/0x190
[Fri Mar 15 21:53:36 2019]  ? strncpy_from_user+0x48/0x160
[Fri Mar 15 21:53:36 2019]  ? _raw_spin_unlock+0x24/0x30
[Fri Mar 15 21:53:36 2019]  ? vfs_statx+0x63/0xb0
[Fri Mar 15 21:53:36 2019]  vfs_statx+0x63/0xb0
[Fri Mar 15 21:53:36 2019]  SyS_newstat+0x2b/0x50
[Fri Mar 15 21:53:36 2019]  ? up_read+0x1c/0x40
[Fri Mar 15 21:53:36 2019]  ? trace_hardirqs_off_thunk+0x1a/0x1c
[Fri Mar 15 21:53:36 2019]  do_syscall_64+0x76/0x180
[Fri Mar 15 21:53:36 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Fri Mar 15 21:53:36 2019] RIP: 0033:0x7f5ec1373055
[Fri Mar 15 21:53:36 2019] RSP: 002b:00007ffd8121ace8 EFLAGS: 00000246 ORIG_RAX: 0000000000000004
[Fri Mar 15 21:53:36 2019] RAX: ffffffffffffffda RBX: 0000000000000024 RCX: 00007f5ec1373055
[Fri Mar 15 21:53:36 2019] RDX: 00007ffd8121acf0 RSI: 00007ffd8121acf0 RDI: 0000000001a55c48
[Fri Mar 15 21:53:36 2019] RBP: 0000000001a55c48 R08: 0000000000710710 R09: 00007f5ec13c57b0
[Fri Mar 15 21:53:36 2019] R10: 00007f5ec13c2430 R11: 0000000000000246 R12: 0000000001a55c48
[Fri Mar 15 21:53:36 2019] R13: 00007ffd8121ae00 R14: 00007ffd8121ae00 R15: 0000000001a546e8

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCXJG2CgAKCRCB+YsaVrMb
nJqwAKDVXEt1QUeVWzyAS1II4ibFWpcr1gCfbj3rSAT+q2haSgvaI6tj81xc2Gw=
=hVq4
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
