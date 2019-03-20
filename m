Return-Path: <SRS0=xnYl=RX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0E8EC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 03:52:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C31520857
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 03:52:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727593AbfCTDug (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Mar 2019 23:50:36 -0400
Received: from james.kirk.hungrycats.org ([174.142.39.145]:35016 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726896AbfCTDug (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Mar 2019 23:50:36 -0400
Received: by james.kirk.hungrycats.org (Postfix, from userid 1002)
        id 8CF2826E3AF; Tue, 19 Mar 2019 23:49:52 -0400 (EDT)
Date:   Tue, 19 Mar 2019 23:49:51 -0400
From:   Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To:     linux-btrfs@vger.kernel.org
Subject: Re: A collection of btrfs lockup stack traces (4.20.13)
Message-ID: <20190320034950.GC16651@hungrycats.org>
References: <20190320033957.GA16651@hungrycats.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="+nBD6E3TurpgldQp"
Content-Disposition: inline
In-Reply-To: <20190320033957.GA16651@hungrycats.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--+nBD6E3TurpgldQp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 19, 2019 at 11:39:59PM -0400, Zygo Blaxell wrote:
> I haven't been able to easily reproduce these in a test environment;
> however, they have been happening several times a year on servers in
> production.
>=20
> Kernel:  most recent observation on 4.14.105 + cherry-picked deadlock
> and misc hang fixes:
>=20
> 	btrfs: wakeup cleaner thread when adding delayed iput
> 	Btrfs: fix deadlock when allocating tree block during leaf/node split
> 	Btrfs: use nofs context when initializing security xattrs to avoid deadl=
ock
> 	Btrfs: fix deadlock with memory reclaim during scrub
> 	Btrfs: fix deadlock between clone/dedupe and rename
>=20
> Also observed on 4.20.13, and 4.14.0..4.14.105 (4.14.106 is currently
> running, but hasn't locked up yet).
>=20
> Filesystem mount flags:  compress=3Dzstd,ssd,flushoncommit,space_cache=3D=
v2.
> Configuration is either -draid1/-mraid1 or -dsingle/-mraid1.  I've
> also reproduced a lockup without flushoncommit.
>=20
> The machines that are locking up all run the same workload:
>=20
> 	rsync receiving data continuously (gigabytes aren't enough,
> 	I can barely reproduce this once a month with 2TB of rsync
> 	traffic from 10 simulated clients)
>=20
> 	bees doing continuous dedupe
>=20
> 	snapshots daily and after each rsync
>=20
> 	snapshot deletes as required to maintain free space
>=20
> 	scrubs twice monthly plus after each crash
>=20
> 	watchdog does a 'mkdir foo; rmdir foo' every few seconds.
> 	If this takes longer than 50 minutes, collect a stack trace;
> 	longer than 60 minutes, reboot the machine.
>=20
> Observations:
>=20
> 	In the past I've hit the known deadlocks between rsync
> 	(rename) and dedupe, and between snapshot delete and scrub.
> 	These deadlocks aren't those, and current kernels can still
> 	deadlock with fixes for those (and some others) applied.
>=20
> 	Deadlocks can occur when there are no snapshot deletes active
> 	and scrub is not running.  In a few cases there's been a snapshot
> 	create active during a deadlock event.
>=20
> 	The deadlocks occur in bursts, which correlate to periods
> 	of rapid data expansion on the filesystem.  e.g. after a big
> 	snapshot delete frees a TB or two of space, there are several
> 	lockups a few days (or even hours) apart.  When the filesystem
> 	gets near the free space threshold and a series of smaller
> 	snapshot deletes occur, so that allocated space stays relatively
> 	stable, then there can be months between lockups.
>=20
> 	Other bugs in 4.14 kernels break lockdep soon after boot, so
> 	there's only lockdep information in a few cases by the time the
> 	btrfs deadlock happens.
>=20
> 	There seem to be a few different identifiable behaviors, e.g.
> 	in some cases the 50-minute timer expires (so a stack trace is
> 	collected) but the 60-minute timer doesn't expire (so the machine
> 	got itself out of the lockup somehow, and doesn't reboot).
>=20
> Distractions:
>=20
> 	In some cases increasing vm.dirty_ratio will unfreeze the
> 	filesystem, in other cases it does nothing.  Decreasing
> 	vm.dirty_ratio (e.g. to 2) locks up the filesystem almost
> 	immediately, but it can recover if vm.dirty_ratio is increased
> 	again.	I'm not sure if this is because there are two separate
> 	bugs, or just a single bug with corner cases.
>=20

Here's one on 4.20.13.  Alas, no lockdep output in this one.  I note
that there is both rename and dedupe in here, but they don't seem to be
deadlocked with each other (that case would have lock_two_nondirectories
in the stack, and that isn't present here).

[573870.943159] sysrq: SysRq : Show Blocked State
[573870.948005]   task                        PC stack   pid father
[573870.954068] btrfs-transacti D    0  4481      2 0x80000000
[573870.960142] Call Trace:
[573870.963075]  ? __schedule+0x3cf/0xb60
[573870.967334]  schedule+0x39/0x90
[573870.971170]  btrfs_commit_transaction+0x2a7/0x990
[573870.976658]  ? wait_woken+0xa0/0xa0
[573870.980761]  transaction_kthread+0x149/0x180
[573870.985725]  kthread+0x106/0x140
[573870.989529]  ? btrfs_cleanup_transaction+0x620/0x620
[573870.995281]  ? kthread_park+0x90/0x90
[573870.999734]  ret_from_fork+0x3a/0x50
[573871.003985] crawl_5         D    0  4547   4537 0x00000000
[573871.010913] Call Trace:
[573871.014051]  ? __schedule+0x3cf/0xb60
[573871.018543]  schedule+0x39/0x90
[573871.022735]  wait_current_trans+0xc3/0x100
[573871.027895]  ? wait_woken+0xa0/0xa0
[573871.032218]  start_transaction+0x13f/0x460
[573871.035587]  btrfs_clone+0x5cd/0xcf0
[573871.037992]  ? do_raw_spin_lock+0xa0/0xb0
[573871.041436]  btrfs_extent_same_range+0x380/0x440
[573871.045232]  btrfs_remap_file_range+0x2d8/0x300
[573871.049143]  vfs_dedupe_file_range_one+0x10c/0x160
[573871.053176]  vfs_dedupe_file_range+0x14c/0x1e0
[573871.056805]  do_vfs_ioctl+0x278/0x6f0
[573871.059844]  ? __fget+0x11f/0x210
[573871.062627]  ksys_ioctl+0x70/0x80
[573871.064115]  __x64_sys_ioctl+0x16/0x20
[573871.065819]  do_syscall_64+0x60/0x190
[573871.068437]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[573871.071756] RIP: 0033:0x7fd5eda85017
[573871.072514] Code: Bad RIP value.
[573871.074543] RSP: 002b:00007fd5ed19e998 EFLAGS: 00000246 ORIG_RAX: 00000=
00000000010
[573871.079062] RAX: ffffffffffffffda RBX: 00007fd5880c2070 RCX: 00007fd5ed=
a85017
[573871.084890] RDX: 00007fd5880c2070 RSI: 00000000c0189436 RDI: 0000000000=
000249
[573871.090847] RBP: 00007fd5ed19ed20 R08: 00007fd5885a9f20 R09: 0000000000=
000000
[573871.096633] R10: 00007fd5ed19ef40 R11: 0000000000000246 R12: 0000000000=
000001
[573871.102273] R13: 0000000000000018 R14: 00007fd5885a9f38 R15: 00007fd5ed=
19ed28
[573871.107906] hash_writeback  D    0  4551   4537 0x00000000
[573871.112175] Call Trace:
[573871.114219]  ? __schedule+0x3cf/0xb60
[573871.117138]  ? _raw_spin_unlock_irqrestore+0x32/0x60
[573871.121025]  schedule+0x39/0x90
[573871.123576]  schedule_timeout+0x1de/0x4e0
[573871.126728]  ? collect_expired_timers+0xb0/0xb0
[573871.130113]  io_schedule_timeout+0x19/0x40
[573871.133246]  balance_dirty_pages+0x354/0xeb0
[573871.136407]  ? lock_acquire+0xbc/0x1c0
[573871.139268]  ? kvm_sched_clock_read+0x14/0x30
[573871.142567]  balance_dirty_pages_ratelimited+0x5e0/0xae0
[573871.146543]  btrfs_buffered_write.isra.4+0x40a/0x7b0
[573871.150250]  btrfs_file_write_iter+0x224/0x5c3
[573871.153632]  __vfs_write+0x113/0x1a0
[573871.156478]  vfs_write+0xc5/0x1b0
[573871.159245]  ksys_pwrite64+0x74/0x90
[573871.162194]  do_syscall_64+0x60/0x190
[573871.165247]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[573871.169292] RIP: 0033:0x7fd5ee5f0983
[573871.172240] Code: Bad RIP value.
[573871.174953] RSP: 002b:00007fd5e6ffc390 EFLAGS: 00000293 ORIG_RAX: 00000=
00000000012
[573871.180664] RAX: ffffffffffffffda RBX: 0000000000020000 RCX: 00007fd5ee=
5f0983
[573871.186068] RDX: 0000000000020000 RSI: 00007fd59c000d80 RDI: 0000000000=
000005
[573871.191469] RBP: 000000001f7e0000 R08: 00007fd59c000d80 R09: 0000000000=
020010
[573871.196794] R10: 000000001f7e0000 R11: 0000000000000293 R12: 00007fd5e6=
ffc5c0
[573871.202069] R13: 0000000000020000 R14: 00007fd5bf7e0000 R15: 00007fd59c=
020d80
[573871.207279] hash_prefetch   D    0  4552   4537 0x00000000
[573871.211333] Call Trace:
[573871.213305]  ? __schedule+0x3cf/0xb60
[573871.216119]  ? mark_held_locks+0x6a/0x90
[573871.219125]  ? rwsem_down_write_failed+0x165/0x300
[573871.222752]  schedule+0x39/0x90
[573871.225294]  rwsem_down_write_failed+0x16a/0x300
[573871.228933]  ? call_rwsem_down_write_failed+0x13/0x20
[573871.232925]  call_rwsem_down_write_failed+0x13/0x20
[573871.236742]  down_write_nested+0x87/0xb0
[573871.239851]  do_unlinkat+0x130/0x310
[573871.242747]  do_syscall_64+0x60/0x190
[573871.245683]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[573871.249591] RIP: 0033:0x7fd5eda81117
[573871.252454] Code: Bad RIP value.
[573871.255045] RSP: 002b:00007fd5e67fae18 EFLAGS: 00000246 ORIG_RAX: 00000=
00000000107
[573871.261002] RAX: ffffffffffffffda RBX: 00007fd5e67fae40 RCX: 00007fd5ed=
a81117
[573871.266855] RDX: 0000000000000000 RSI: 00007fd598003d70 RDI: 0000000000=
000003
[573871.272742] RBP: 0000563346f72f78 R08: 0000000000000000 R09: 00007fd5e6=
7faef0
[573871.274377] R10: 000056334558ec60 R11: 0000000000000246 R12: 00007fd5e6=
7faf50
[573871.280664] R13: 00007fd5e67fb170 R14: 00007fd59800b4b0 R15: 00007fd5e6=
7fb120
[573871.286681] crawl_writeback D    0  4554   4537 0x00000000
[573871.291274] Call Trace:
[573871.293418]  ? __schedule+0x3cf/0xb60
[573871.296478]  schedule+0x39/0x90
[573871.299132]  wait_current_trans+0xc3/0x100
[573871.302523]  ? wait_woken+0xa0/0xa0
[573871.305539]  start_transaction+0x13f/0x460
[573871.308956]  btrfs_create+0x58/0x1f0
[573871.311985]  lookup_open+0x451/0x770
[573871.315006]  path_openat+0x435/0xbb0
[573871.318000]  do_filp_open+0x99/0x110
[573871.321097]  ? __alloc_fd+0xee/0x200
[573871.324301]  ? do_raw_spin_unlock+0x49/0xc0
[573871.328074]  ? do_sys_open+0x14a/0x210
[573871.331430]  do_sys_open+0x14a/0x210
[573871.334633]  do_syscall_64+0x60/0x190
[573871.337905]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[573871.342230] RIP: 0033:0x7fd5eda7f847
[573871.345333] Code: Bad RIP value.
[573871.348248] RSP: 002b:00007fd5e499fcc0 EFLAGS: 00000293 ORIG_RAX: 00000=
00000000101
[573871.354668] RAX: ffffffffffffffda RBX: 00000000000e09c1 RCX: 00007fd5ed=
a7f847
[573871.360572] RDX: 00000000000e09c1 RSI: 00007fd594000b20 RDI: 0000000000=
000003
[573871.366456] RBP: 0000000000000003 R08: 0000000000000000 R09: 00007fd5e4=
9a0080
[573871.372160] R10: 0000000000000180 R11: 0000000000000293 R12: 00007fd594=
000b20
[573871.377834] R13: 0000000000000003 R14: 00007fd5e49a03d0 R15: 00007fd5e4=
9a0350
[573871.383707] kworker/u8:0    D    0 27279      2 0x80000000
[573871.388290] Workqueue: btrfs-endio-write btrfs_endio_write_helper
[573871.393359] Call Trace:
[573871.395574]  ? __schedule+0x3cf/0xb60
[573871.398743]  schedule+0x39/0x90
[573871.401438]  wait_current_trans+0xc3/0x100
[573871.404926]  ? wait_woken+0xa0/0xa0
[573871.407881]  start_transaction+0x21a/0x460
[573871.411309]  btrfs_finish_ordered_io+0x492/0x7e0
[573871.415121]  normal_work_helper+0x95/0x530
[573871.418555]  process_one_work+0x223/0x5d0
[573871.421998]  worker_thread+0x4f/0x3b0
[573871.425198]  kthread+0x106/0x140
[573871.428121]  ? process_one_work+0x5d0/0x5d0
[573871.431825]  ? kthread_park+0x90/0x90
[573871.435066]  ret_from_fork+0x3a/0x50
[573871.438181] kworker/u8:14   D    0 15161      2 0x80000000
[573871.442785] Workqueue: btrfs-endio-write btrfs_endio_write_helper
[573871.447777] Call Trace:
[573871.449916]  ? __schedule+0x3cf/0xb60
[573871.452971]  schedule+0x39/0x90
[573871.455716]  wait_current_trans+0xc3/0x100
[573871.459181]  ? wait_woken+0xa0/0xa0
[573871.462174]  start_transaction+0x21a/0x460
[573871.465633]  btrfs_finish_ordered_io+0x492/0x7e0
[573871.469430]  normal_work_helper+0x95/0x530
[573871.472784]  process_one_work+0x223/0x5d0
[573871.476078]  worker_thread+0x4f/0x3b0
[573871.479116]  kthread+0x106/0x140
[573871.481819]  ? process_one_work+0x5d0/0x5d0
[573871.485236]  ? kthread_park+0x90/0x90
[573871.488292]  ret_from_fork+0x3a/0x50
[573871.491453] kworker/u8:17   D    0 23801      2 0x80000000
[573871.496239] Workqueue: btrfs-flush_delalloc btrfs_flush_delalloc_helper
[573871.501882] Call Trace:
[573871.504102]  ? __schedule+0x3cf/0xb60
[573871.507305]  schedule+0x39/0x90
[573871.510091]  btrfs_start_ordered_extent+0x10a/0x1b0
[573871.514178]  ? wait_woken+0xa0/0xa0
[573871.517248]  btrfs_run_ordered_extent_work+0x21/0x30
[573871.519956]  normal_work_helper+0x95/0x530
[573871.521156]  process_one_work+0x223/0x5d0
[573871.525102]  worker_thread+0x4f/0x3b0
[573871.527891]  kthread+0x106/0x140
[573871.531303]  ? process_one_work+0x5d0/0x5d0
[573871.534825]  ? kthread_park+0x90/0x90
[573871.537987]  ret_from_fork+0x3a/0x50
[573871.541073] kworker/u8:10   D    0  4421      2 0x80000000
[573871.546477] Workqueue: btrfs-endio-write btrfs_endio_write_helper
[573871.552581] Call Trace:
[573871.554839]  ? __schedule+0x3cf/0xb60
[573871.558046]  schedule+0x39/0x90
[573871.560804]  wait_current_trans+0xc3/0x100
[573871.564327]  ? wait_woken+0xa0/0xa0
[573871.568464]  start_transaction+0x21a/0x460
[573871.572087]  btrfs_finish_ordered_io+0x492/0x7e0
[573871.576026]  normal_work_helper+0x95/0x530
[573871.580231]  process_one_work+0x223/0x5d0
[573871.583564]  worker_thread+0x4f/0x3b0
[573871.586649]  kthread+0x106/0x140
[573871.589343]  ? process_one_work+0x5d0/0x5d0
[573871.592762]  ? kthread_park+0x90/0x90
[573871.595837]  ret_from_fork+0x3a/0x50
[573871.598912] kworker/u8:1    D    0 17773      2 0x80000000
[573871.603488] Workqueue: btrfs-endio-write btrfs_endio_write_helper
[573871.608535] Call Trace:
[573871.610722]  ? __schedule+0x3cf/0xb60
[573871.613924]  schedule+0x39/0x90
[573871.616706]  wait_current_trans+0xc3/0x100
[573871.620241]  ? wait_woken+0xa0/0xa0
[573871.623248]  start_transaction+0x21a/0x460
[573871.626734]  btrfs_finish_ordered_io+0x492/0x7e0
[573871.630627]  normal_work_helper+0x95/0x530
[573871.634232]  process_one_work+0x223/0x5d0
[573871.637772]  worker_thread+0x4f/0x3b0
[573871.641029]  kthread+0x106/0x140
[573871.643825]  ? process_one_work+0x5d0/0x5d0
[573871.647422]  ? kthread_park+0x90/0x90
[573871.648344]  ret_from_fork+0x3a/0x50
[573871.649126] rsync           D    0  3068   3054 0x00000000
[573871.650256] Call Trace:
[573871.650789]  ? __schedule+0x3cf/0xb60
[573871.651589]  schedule+0x39/0x90
[573871.652283]  wait_current_trans+0xc3/0x100
[573871.653191]  ? wait_woken+0xa0/0xa0
[573871.654236]  start_transaction+0x21a/0x460
[573871.655154]  btrfs_evict_inode+0x47d/0x520
[573871.656043]  ? dput+0x25/0x2e0
[573871.656726]  evict+0xbf/0x1c0
[573871.657394]  __dentry_kill+0xca/0x1b0
[573871.658198]  dentry_kill+0x50/0x1d0
[573871.658929]  ? dput+0x25/0x2e0
[573871.659588]  dput+0x286/0x2e0
[573871.660224]  do_renameat2+0x3fc/0x570
[573871.661000]  __x64_sys_rename+0x1c/0x20
[573871.661806]  do_syscall_64+0x60/0x190
[573871.662741]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[573871.663971] RIP: 0033:0x7f539eaa4d47
[573871.664867] Code: Bad RIP value.
[573871.665663] RSP: 002b:00007ffc71486c68 EFLAGS: 00000246 ORIG_RAX: 00000=
00000000052
[573871.667489] RAX: ffffffffffffffda RBX: 00007ffc71488e30 RCX: 00007f539e=
aa4d47
[573871.669223] RDX: 0000000000000000 RSI: 00007ffc71486e30 RDI: 00007ffc71=
488e30
[573871.671126] RBP: 00007ffc71486e30 R08: 0000000000000000 R09: 0000000000=
000001
[573871.672985] R10: 0000000000000100 R11: 0000000000000246 R12: 0000000000=
000000
[573871.674899] R13: 0000000000000004 R14: 0000000000008180 R15: 0000000000=
000001
[573871.676784] rsync           D    0  9157   9148 0x00000000
[573871.678162] Call Trace:
[573871.678789]  ? __schedule+0x3cf/0xb60
[573871.679835]  schedule+0x39/0x90
[573871.680703]  wait_current_trans+0xc3/0x100
[573871.681829]  ? wait_woken+0xa0/0xa0
[573871.682690]  start_transaction+0x21a/0x460
[573871.683789]  btrfs_dirty_inode+0x42/0xd0
[573871.684748]  btrfs_setattr+0xab/0x590
[573871.685693]  ? current_time+0x4d/0x90
[573871.686610]  notify_change+0x2f0/0x450
[573871.687603]  chown_common+0x1ac/0x1d0
[573871.688485]  ? rcu_read_lock_sched_held+0x68/0x70
[573871.689743]  do_fchownat+0xbc/0xf0
[573871.690650]  __x64_sys_lchown+0x21/0x30
[573871.691594]  do_syscall_64+0x60/0x190
[573871.692460]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[573871.693756] RIP: 0033:0x7f8cc9ac29b7
[573871.694648] Code: Bad RIP value.
[573871.695452] RSP: 002b:00007ffd2bdbd5a8 EFLAGS: 00000246 ORIG_RAX: 00000=
0000000005e
[573871.697377] RAX: ffffffffffffffda RBX: 00000000000041c0 RCX: 00007f8cc9=
ac29b7
[573871.699268] RDX: 00000000000003e8 RSI: 00000000000003e8 RDI: 00007ffd2b=
dbfa10
[573871.701174] RBP: 00007ffd2bdbfa10 R08: 0000000000000000 R09: 0000000000=
000000
[573871.702972] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffd2b=
dbd8e0
[573871.704864] R13: 00000000000003e8 R14: 0000558019715758 R15: 0000000000=
000001
[573871.706837] rsync           D    0 10148  10138 0x00000000
[573871.708286] Call Trace:
[573871.708921]  ? __schedule+0x3cf/0xb60
[573871.710017]  schedule+0x39/0x90
[573871.710865]  wait_current_trans+0xc3/0x100
[573871.711956]  ? wait_woken+0xa0/0xa0
[573871.712942]  start_transaction+0x13f/0x460
[573871.714018]  btrfs_link+0xb1/0x280
[573871.714899]  vfs_link+0x23e/0x310
[573871.715746]  do_linkat+0x296/0x340
[573871.716742]  __x64_sys_link+0x1c/0x20
[573871.717664]  do_syscall_64+0x60/0x190
[573871.718691]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[573871.720020] RIP: 0033:0x7f0ad9ccbfc7
[573871.720964] Code: Bad RIP value.
[573871.721808] RSP: 002b:00007ffe17e262a8 EFLAGS: 00000246 ORIG_RAX: 00000=
00000000056
[573871.723825] RAX: ffffffffffffffda RBX: 0000561a33fcd098 RCX: 00007f0ad9=
ccbfc7
[573871.725767] RDX: 0000000000000000 RSI: 00007ffe17e262f0 RDI: 0000561a30=
3452c0
[573871.727529] RBP: 0000561a303452c0 R08: 0000000000000000 R09: 00007ffe17=
e2a710
[573871.729252] R10: 0000000000000064 R11: 0000000000000246 R12: 00007ffe17=
e262f0
[573871.731148] R13: 0000000000000000 R14: 0000561a303452c0 R15: 0000561a33=
fcd098
[573871.732946] kworker/u8:5    D    0  1064      2 0x80000000
[573871.734371] Workqueue: btrfs-endio-write btrfs_endio_write_helper
[573871.735956] Call Trace:
[573871.736625]  ? __schedule+0x3cf/0xb60
[573871.737644]  schedule+0x39/0x90
[573871.738424]  wait_current_trans+0xc3/0x100
[573871.739520]  ? wait_woken+0xa0/0xa0
[573871.740416]  start_transaction+0x21a/0x460
[573871.741506]  btrfs_finish_ordered_io+0x492/0x7e0
[573871.742726]  normal_work_helper+0x95/0x530
[573871.743747]  process_one_work+0x223/0x5d0
[573871.744868]  worker_thread+0x4f/0x3b0
[573871.745812]  kthread+0x106/0x140
[573871.746603]  ? process_one_work+0x5d0/0x5d0
[573871.747753]  ? kthread_park+0x90/0x90
[573871.748751]  ret_from_fork+0x3a/0x50
[573871.749713] kworker/u8:9    D    0  6027      2 0x80000000
[573871.751135] Workqueue: btrfs-endio-write btrfs_endio_write_helper
[573871.752691] Call Trace:
[573871.753233]  ? __schedule+0x3cf/0xb60
[573871.754177]  schedule+0x39/0x90
[573871.754957]  wait_current_trans+0xc3/0x100
[573871.755864]  ? wait_woken+0xa0/0xa0
[573871.756777]  start_transaction+0x21a/0x460
[573871.757843]  btrfs_finish_ordered_io+0x492/0x7e0
[573871.759189]  normal_work_helper+0x95/0x530
[573871.760342]  process_one_work+0x223/0x5d0
[573871.761526]  worker_thread+0x4f/0x3b0
[573871.762559]  kthread+0x106/0x140
[573871.763463]  ? process_one_work+0x5d0/0x5d0
[573871.764592]  ? kthread_park+0x90/0x90
[573871.765657]  ret_from_fork+0x3a/0x50
[573871.766674] btrfs           D    0 19926   4537 0x00000000
[573871.768208] Call Trace:
[573871.768956]  ? __schedule+0x3cf/0xb60
[573871.770052]  schedule+0x39/0x90
[573871.770905]  schedule_timeout+0x228/0x4e0
[573871.771996]  ? mark_held_locks+0x6a/0x90
[573871.772961]  ? _raw_spin_unlock_irq+0x29/0x40
[573871.774157]  wait_for_common+0x155/0x220
[573871.775262]  ? wake_up_q+0x70/0x70
[573871.776133]  btrfs_wait_ordered_extents+0x27c/0x400
[573871.777477]  btrfs_mksubvol+0x3cd/0x5e0
[573871.778450]  ? rcu_read_lock_sched_held+0x68/0x70
[573871.779637]  ? rcu_sync_lockdep_assert+0x30/0x60
[573871.780829]  ? __sb_start_write+0xcc/0x1b0
[573871.781831]  ? mnt_want_write_file+0x24/0x50
[573871.783016]  btrfs_ioctl_snap_create_transid+0x169/0x1a0
[573871.784449]  btrfs_ioctl_snap_create_v2+0x11d/0x170
[573871.785716]  btrfs_ioctl+0x1351/0x2cb0
[573871.786692]  ? kvm_sched_clock_read+0x14/0x30
[573871.787778]  ? __handle_mm_fault+0x1067/0x1810
[573871.788844]  ? do_raw_spin_unlock+0x49/0xc0
[573871.789842]  ? _raw_spin_unlock+0x24/0x30
[573871.790882]  ? __handle_mm_fault+0x1067/0x1810
[573871.791917]  ? do_vfs_ioctl+0xa2/0x6f0
[573871.792901]  ? btrfs_ioctl_get_supported_features+0x30/0x30
[573871.794404]  do_vfs_ioctl+0xa2/0x6f0
[573871.795263]  ? __do_page_fault+0x1fa/0x5a0
[573871.796289]  ? entry_SYSCALL_64_after_hwframe+0x3e/0xbe
[573871.797557]  ksys_ioctl+0x70/0x80
[573871.798431]  __x64_sys_ioctl+0x16/0x20
[573871.799384]  do_syscall_64+0x60/0x190
[573871.800254]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[573871.801407] RIP: 0033:0x7f4657246017
[573871.802177] Code: Bad RIP value.
[573871.802975] RSP: 002b:00007fffb9cdb928 EFLAGS: 00000206 ORIG_RAX: 00000=
00000000010
[573871.804897] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f4657=
246017
[573871.806659] RDX: 00007fffb9cdb968 RSI: 0000000050009417 RDI: 0000000000=
000003
[573871.808372] RBP: 00000000013e1010 R08: 0000000000000008 R09: 0000000000=
000048
[573871.810129] R10: 0000000000000541 R11: 0000000000000206 R12: 0000000001=
3e1040
[573871.811974] R13: 00000000013e1040 R14: 0000000000000004 R15: 0000000000=
000003

--+nBD6E3TurpgldQp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCXJG4XgAKCRCB+YsaVrMb
nDJsAKCbwIHkIjYHgtM3NvVeK48irm926QCgj6Mzt949iSu2r27PyJszJKwP7oU=
=RpIi
-----END PGP SIGNATURE-----

--+nBD6E3TurpgldQp--
