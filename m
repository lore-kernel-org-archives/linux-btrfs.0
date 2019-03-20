Return-Path: <SRS0=xnYl=RX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71EA2C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 03:45:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AEBE20857
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 03:45:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbfCTDp1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Mar 2019 23:45:27 -0400
Received: from james.kirk.hungrycats.org ([174.142.39.145]:34752 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727089AbfCTDp0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Mar 2019 23:45:26 -0400
Received: by james.kirk.hungrycats.org (Postfix, from userid 1002)
        id 0023426E397; Tue, 19 Mar 2019 23:45:23 -0400 (EDT)
Date:   Tue, 19 Mar 2019 23:45:22 -0400
From:   Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To:     linux-btrfs@vger.kernel.org
Subject: Re: A collection of btrfs lockup stack traces
Message-ID: <20190320034511.GB16651@hungrycats.org>
References: <20190320033957.GA16651@hungrycats.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="GID0FwUMdk1T2AWN"
Content-Disposition: inline
In-Reply-To: <20190320033957.GA16651@hungrycats.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--GID0FwUMdk1T2AWN
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
> Here's a recent lockup example with lockdep output, from 4.14.105 with
> the cherry-picked patches above:

And another:

[Fri Mar  8 03:50:32 2019] 1 lock held by khungtaskd/465:
[Fri Mar  8 03:50:32 2019]  #0:  (tasklist_lock){.+.+}, at: [<ffffffff870f0=
367>] debug_show_all_locks+0x37/0x190
[Fri Mar  8 03:50:32 2019] 3 locks held by btrfs-transacti/27078:
[Fri Mar  8 03:50:32 2019]  #0:  (&fs_info->transaction_kthread_mutex){+.+.=
}, at: [<ffffffff874352b4>] transaction_kthread+0x74/0x1d0
[Fri Mar  8 03:50:32 2019]  #1:  (&fs_info->delalloc_root_mutex){+.+.}, at:=
 [<ffffffff8744f728>] btrfs_start_delalloc_roots+0x58/0x380
[Fri Mar  8 03:50:32 2019]  #2:  (&root->delalloc_mutex){+.+.}, at: [<fffff=
fff8744f302>] __start_delalloc_inodes+0x52/0x320
[Fri Mar  8 03:50:32 2019] 4 locks held by crawl_290/13174:
[Fri Mar  8 03:50:32 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffff872d4e=
1b>] mnt_want_write_file+0x3b/0xb0
[Fri Mar  8 03:50:32 2019]  #1:  (&sb->s_type->i_mutex_key#14/1){+.+.}, at:=
 [<ffffffff87479bde>] btrfs_dedupe_file_range+0x8e/0x660
[Fri Mar  8 03:50:32 2019]  #2:  (&sb->s_type->i_mutex_key#14/2){+.+.}, at:=
 [<ffffffff87479bef>] btrfs_dedupe_file_range+0x9f/0x660
[Fri Mar  8 03:50:32 2019]  #3:  (sb_internal){.+.+}, at: [<ffffffff8743b5d=
6>] start_transaction+0x2b6/0x4d0
[Fri Mar  8 03:50:32 2019] 4 locks held by crawl_302/15836:
[Fri Mar  8 03:50:32 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffff872d4e=
1b>] mnt_want_write_file+0x3b/0xb0
[Fri Mar  8 03:50:32 2019]  #1:  (&sb->s_type->i_mutex_key#14/1){+.+.}, at:=
 [<ffffffff87479bde>] btrfs_dedupe_file_range+0x8e/0x660
[Fri Mar  8 03:50:32 2019]  #2:  (&sb->s_type->i_mutex_key#14/2){+.+.}, at:=
 [<ffffffff87479bef>] btrfs_dedupe_file_range+0x9f/0x660
[Fri Mar  8 03:50:32 2019]  #3:  (sb_internal){.+.+}, at: [<ffffffff8743b5d=
6>] start_transaction+0x2b6/0x4d0
[Fri Mar  8 03:50:32 2019] 4 locks held by crawl_275/15837:
[Fri Mar  8 03:50:32 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffff872d4e=
1b>] mnt_want_write_file+0x3b/0xb0
[Fri Mar  8 03:50:32 2019]  #1:  (&sb->s_type->i_mutex_key#14/1){+.+.}, at:=
 [<ffffffff87479bde>] btrfs_dedupe_file_range+0x8e/0x660
[Fri Mar  8 03:50:32 2019]  #2:  (&sb->s_type->i_mutex_key#14/2){+.+.}, at:=
 [<ffffffff87479bef>] btrfs_dedupe_file_range+0x9f/0x660
[Fri Mar  8 03:50:32 2019]  #3:  (sb_internal){.+.+}, at: [<ffffffff8743b5d=
6>] start_transaction+0x2b6/0x4d0
[Fri Mar  8 03:50:32 2019] 4 locks held by crawl_299/15838:
[Fri Mar  8 03:50:32 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffff872d4e=
1b>] mnt_want_write_file+0x3b/0xb0
[Fri Mar  8 03:50:32 2019]  #1:  (&sb->s_type->i_mutex_key#14/1){+.+.}, at:=
 [<ffffffff87479bde>] btrfs_dedupe_file_range+0x8e/0x660
[Fri Mar  8 03:50:32 2019]  #2:  (&sb->s_type->i_mutex_key#14/2){+.+.}, at:=
 [<ffffffff87479bef>] btrfs_dedupe_file_range+0x9f/0x660
[Fri Mar  8 03:50:32 2019]  #3:  (sb_internal){.+.+}, at: [<ffffffff8743b5d=
6>] start_transaction+0x2b6/0x4d0
[Fri Mar  8 03:50:32 2019] 4 locks held by crawl_290/15839:
[Fri Mar  8 03:50:32 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffff872d4e=
1b>] mnt_want_write_file+0x3b/0xb0
[Fri Mar  8 03:50:32 2019]  #1:  (&sb->s_type->i_mutex_key#14/1){+.+.}, at:=
 [<ffffffff87479bde>] btrfs_dedupe_file_range+0x8e/0x660
[Fri Mar  8 03:50:32 2019]  #2:  (&sb->s_type->i_mutex_key#14/2){+.+.}, at:=
 [<ffffffff87479bef>] btrfs_dedupe_file_range+0x9f/0x660
[Fri Mar  8 03:50:32 2019]  #3:  (sb_internal){.+.+}, at: [<ffffffff8743b5d=
6>] start_transaction+0x2b6/0x4d0
[Fri Mar  8 03:50:32 2019] 1 lock held by btrfs/9795:
[Fri Mar  8 03:50:32 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffff872d4e=
1b>] mnt_want_write_file+0x3b/0xb0
[Fri Mar  8 03:50:32 2019] 1 lock held by btrfs/9796:
[Fri Mar  8 03:50:32 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffff872d4e=
1b>] mnt_want_write_file+0x3b/0xb0
[Fri Mar  8 03:50:32 2019] 1 lock held by btrfs/9797:
[Fri Mar  8 03:50:32 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffff872d4e=
1b>] mnt_want_write_file+0x3b/0xb0
[Fri Mar  8 03:50:32 2019] 1 lock held by btrfs/9798:
[Fri Mar  8 03:50:32 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffff872d4e=
1b>] mnt_want_write_file+0x3b/0xb0
[Fri Mar  8 03:50:32 2019] 1 lock held by btrfs/9799:
[Fri Mar  8 03:50:32 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffff872d4e=
1b>] mnt_want_write_file+0x3b/0xb0
[Fri Mar  8 03:50:32 2019] 3 locks held by rsync/24322:
[Fri Mar  8 03:50:32 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffff872aa7=
cc>] do_sys_ftruncate.constprop.1+0xdc/0x180
[Fri Mar  8 03:50:32 2019]  #1:  (&sb->s_type->i_mutex_key#14){+.+.}, at: [=
<ffffffff872aa3ff>] do_truncate+0x4f/0x90
[Fri Mar  8 03:50:32 2019]  #2:  (sb_internal){.+.+}, at: [<ffffffff8743b5d=
6>] start_transaction+0x2b6/0x4d0
[Fri Mar  8 03:50:32 2019] 2 locks held by kworker/u8:20/20623:
[Fri Mar  8 03:50:32 2019]  #0:  ("%s-%s""btrfs", name){+.+.}, at: [<ffffff=
ff870ae2be>] process_one_work+0x17e/0x650
[Fri Mar  8 03:50:32 2019]  #1:  ((&work->normal_work)){+.+.}, at: [<ffffff=
ff870ae2be>] process_one_work+0x17e/0x650
[Fri Mar  8 03:50:32 2019] 3 locks held by mkdir/17020:
[Fri Mar  8 03:50:32 2019]  #0:  (sb_writers#8){.+.+}, at: [<ffffffff872d4d=
90>] mnt_want_write+0x20/0x50
[Fri Mar  8 03:50:32 2019]  #1:  (&type->i_mutex_dir_key#6/1){+.+.}, at: [<=
ffffffff872bf42f>] filename_create+0x6f/0x140
[Fri Mar  8 03:50:32 2019]  #2:  (sb_internal){.+.+}, at: [<ffffffff8743b5d=
6>] start_transaction+0x2b6/0x4d0

[Fri Mar  8 03:50:32 2019] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D

[Fri Mar  8 04:38:21 2019]   task                        PC stack   pid fat=
her
[Fri Mar  8 04:38:21 2019] btrfs-transacti D    0 27078      2 0x80000000
[Fri Mar  8 04:38:21 2019] Call Trace:
[Fri Mar  8 04:38:21 2019]  ? __schedule+0x429/0xbb0
[Fri Mar  8 04:38:21 2019]  schedule+0x39/0x90
[Fri Mar  8 04:38:21 2019]  schedule_timeout+0x20f/0x590
[Fri Mar  8 04:38:21 2019]  ? lock_acquire+0xbc/0x200
[Fri Mar  8 04:38:21 2019]  ? mark_held_locks+0x6a/0x90
[Fri Mar  8 04:38:21 2019]  ? _raw_spin_unlock_irq+0x29/0x40
[Fri Mar  8 04:38:21 2019]  ? wait_for_common+0x131/0x1f0
[Fri Mar  8 04:38:21 2019]  wait_for_common+0x131/0x1f0
[Fri Mar  8 04:38:21 2019]  ? wake_up_q+0x70/0x70
[Fri Mar  8 04:38:21 2019]  __start_delalloc_inodes+0x22f/0x320
[Fri Mar  8 04:38:21 2019]  btrfs_start_delalloc_roots+0x1cd/0x380
[Fri Mar  8 04:38:21 2019]  btrfs_commit_transaction+0x807/0xa20
[Fri Mar  8 04:38:21 2019]  ? start_transaction+0x89/0x4d0
[Fri Mar  8 04:38:21 2019]  transaction_kthread+0x194/0x1d0
[Fri Mar  8 04:38:21 2019]  kthread+0x10d/0x140
[Fri Mar  8 04:38:21 2019]  ? btrfs_cleanup_transaction+0x650/0x650
[Fri Mar  8 04:38:21 2019]  ? kthread_create_on_node+0x40/0x40
[Fri Mar  8 04:38:21 2019]  ret_from_fork+0x27/0x50
[Fri Mar  8 04:38:21 2019] hash_prefetch   D    0 27397  27345 0x00000000
[Fri Mar  8 04:38:21 2019] Call Trace:
[Fri Mar  8 04:38:21 2019]  ? __schedule+0x429/0xbb0
[Fri Mar  8 04:38:21 2019]  ? rwsem_down_write_failed+0x134/0x2b0
[Fri Mar  8 04:38:21 2019]  schedule+0x39/0x90
[Fri Mar  8 04:38:21 2019]  rwsem_down_write_failed+0x139/0x2b0
[Fri Mar  8 04:38:21 2019]  ? lock_acquire+0xbc/0x200
[Fri Mar  8 04:38:21 2019]  ? call_rwsem_down_write_failed+0x13/0x20
[Fri Mar  8 04:38:21 2019]  call_rwsem_down_write_failed+0x13/0x20
[Fri Mar  8 04:38:21 2019]  down_write_nested+0x87/0xb0
[Fri Mar  8 04:38:21 2019]  do_unlinkat+0x113/0x300
[Fri Mar  8 04:38:21 2019]  do_syscall_64+0x76/0x180
[Fri Mar  8 04:38:21 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Fri Mar  8 04:38:21 2019] RIP: 0033:0x7fdcc7534ed7
[Fri Mar  8 04:38:21 2019] RSP: 002b:00007fdbc2c4ce18 EFLAGS: 00000246 ORIG=
_RAX: 0000000000000107
[Fri Mar  8 04:38:21 2019] RAX: ffffffffffffffda RBX: 00007fdbc2c4ce40 RCX:=
 00007fdcc7534ed7
[Fri Mar  8 04:38:21 2019] RDX: 0000000000000000 RSI: 00007fdbb8002590 RDI:=
 0000000000000003
[Fri Mar  8 04:38:21 2019] RBP: 00005570f731f1a8 R08: 0000000000000000 R09:=
 00007fdbc2c4cef0
[Fri Mar  8 04:38:21 2019] R10: 00005570f6d65c80 R11: 0000000000000246 R12:=
 00007fdbc2c4cf50
[Fri Mar  8 04:38:21 2019] R13: 00007fdbc2c4d170 R14: 00007fdbb800af60 R15:=
 00007fdbc2c4d120
[Fri Mar  8 04:38:21 2019] crawl_writeback D    0 27400  27345 0x00000000
[Fri Mar  8 04:38:21 2019] Call Trace:
[Fri Mar  8 04:38:21 2019]  ? __schedule+0x429/0xbb0
[Fri Mar  8 04:38:21 2019]  ? prepare_to_wait_event+0x97/0x190
[Fri Mar  8 04:38:21 2019]  schedule+0x39/0x90
[Fri Mar  8 04:38:21 2019]  wait_current_trans+0xa3/0xf0
[Fri Mar  8 04:38:21 2019]  ? wait_woken+0xa0/0xa0
[Fri Mar  8 04:38:21 2019]  start_transaction+0x29b/0x4d0
[Fri Mar  8 04:38:21 2019]  btrfs_create+0x47/0x1d0
[Fri Mar  8 04:38:21 2019]  lookup_open+0x404/0x760
[Fri Mar  8 04:38:21 2019]  path_openat+0x4e9/0xcc0
[Fri Mar  8 04:38:21 2019]  do_filp_open+0x8a/0xf0
[Fri Mar  8 04:38:21 2019]  ? __alloc_fd+0xee/0x200
[Fri Mar  8 04:38:21 2019]  ? do_sys_open+0x130/0x200
[Fri Mar  8 04:38:21 2019]  do_sys_open+0x130/0x200
[Fri Mar  8 04:38:21 2019]  do_syscall_64+0x76/0x180
[Fri Mar  8 04:38:21 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Fri Mar  8 04:38:21 2019] RIP: 0033:0x7fdcc7533607
[Fri Mar  8 04:38:21 2019] RSP: 002b:00007fdbc1c4acc0 EFLAGS: 00000293 ORIG=
_RAX: 0000000000000101
[Fri Mar  8 04:38:21 2019] RAX: ffffffffffffffda RBX: 00000000000e09c1 RCX:=
 00007fdcc7533607
[Fri Mar  8 04:38:21 2019] RDX: 00000000000e09c1 RSI: 00007fdba40008f0 RDI:=
 0000000000000003
[Fri Mar  8 04:38:21 2019] RBP: 0000000000000003 R08: 0000000000000000 R09:=
 00007fdbc1c4b080
[Fri Mar  8 04:38:21 2019] R10: 0000000000000180 R11: 0000000000000293 R12:=
 00007fdba40008f0
[Fri Mar  8 04:38:21 2019] R13: 0000000000000003 R14: 00007fdbc1c4b3d0 R15:=
 00007fdbc1c4b350
[Fri Mar  8 04:38:21 2019] crawl_290       D    0 13174  27345 0x00000000
[Fri Mar  8 04:38:21 2019] Call Trace:
[Fri Mar  8 04:38:21 2019]  ? __schedule+0x429/0xbb0
[Fri Mar  8 04:38:21 2019]  ? prepare_to_wait_event+0x97/0x190
[Fri Mar  8 04:38:21 2019]  schedule+0x39/0x90
[Fri Mar  8 04:38:21 2019]  wait_current_trans+0xa3/0xf0
[Fri Mar  8 04:38:21 2019]  ? wait_woken+0xa0/0xa0
[Fri Mar  8 04:38:21 2019]  start_transaction+0x29b/0x4d0
[Fri Mar  8 04:38:21 2019]  btrfs_clone+0x5a3/0xcc0
[Fri Mar  8 04:38:21 2019]  btrfs_dedupe_file_range+0x5e3/0x660
[Fri Mar  8 04:38:21 2019]  vfs_dedupe_file_range+0x22e/0x280
[Fri Mar  8 04:38:21 2019]  do_vfs_ioctl+0x24d/0x6b0
[Fri Mar  8 04:38:21 2019]  ? __fget+0x11f/0x210
[Fri Mar  8 04:38:21 2019]  SyS_ioctl+0x74/0x80
[Fri Mar  8 04:38:21 2019]  do_syscall_64+0x76/0x180
[Fri Mar  8 04:38:21 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Fri Mar  8 04:38:21 2019] RIP: 0033:0x7fdcc7538dd7
[Fri Mar  8 04:38:21 2019] RSP: 002b:00007fdcc6451ac8 EFLAGS: 00000246 ORIG=
_RAX: 0000000000000010
[Fri Mar  8 04:38:21 2019] RAX: ffffffffffffffda RBX: 00007fdb9c5e4010 RCX:=
 00007fdcc7538dd7
[Fri Mar  8 04:38:21 2019] RDX: 00007fdb9c5e4010 RSI: 00000000c0189436 RDI:=
 0000000000000465
[Fri Mar  8 04:38:21 2019] RBP: 00007fdcc6451e40 R08: 00007fdb9c1e8510 R09:=
 0000000000000000
[Fri Mar  8 04:38:21 2019] R10: 00007fdb9c044b80 R11: 0000000000000246 R12:=
 0000000000000020
[Fri Mar  8 04:38:21 2019] R13: 0000000000000018 R14: 00007fdb9c1e8528 R15:=
 00007fdcc6451e48
[Fri Mar  8 04:38:21 2019] crawl_302       D    0 15836  27345 0x00000000
[Fri Mar  8 04:38:21 2019] Call Trace:
[Fri Mar  8 04:38:21 2019]  ? __schedule+0x429/0xbb0
[Fri Mar  8 04:38:21 2019]  ? prepare_to_wait_event+0x97/0x190
[Fri Mar  8 04:38:21 2019]  schedule+0x39/0x90
[Fri Mar  8 04:38:21 2019]  wait_current_trans+0xa3/0xf0
[Fri Mar  8 04:38:21 2019]  ? wait_woken+0xa0/0xa0
[Fri Mar  8 04:38:21 2019]  start_transaction+0x29b/0x4d0
[Fri Mar  8 04:38:21 2019]  btrfs_clone+0x5a3/0xcc0
[Fri Mar  8 04:38:21 2019]  btrfs_dedupe_file_range+0x5e3/0x660
[Fri Mar  8 04:38:21 2019]  vfs_dedupe_file_range+0x22e/0x280
[Fri Mar  8 04:38:21 2019]  do_vfs_ioctl+0x24d/0x6b0
[Fri Mar  8 04:38:21 2019]  ? __fget+0x11f/0x210
[Fri Mar  8 04:38:21 2019]  SyS_ioctl+0x74/0x80
[Fri Mar  8 04:38:21 2019]  do_syscall_64+0x76/0x180
[Fri Mar  8 04:38:21 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Fri Mar  8 04:38:21 2019] RIP: 0033:0x7fdcc7538dd7
[Fri Mar  8 04:38:21 2019] RSP: 002b:00007fdcc4c4f0a8 EFLAGS: 00000246 ORIG=
_RAX: 0000000000000010
[Fri Mar  8 04:38:21 2019] RAX: ffffffffffffffda RBX: 00007fdb98125c40 RCX:=
 00007fdcc7538dd7
[Fri Mar  8 04:38:21 2019] RDX: 00007fdb98125c40 RSI: 00000000c0189436 RDI:=
 0000000000000027
[Fri Mar  8 04:38:21 2019] RBP: 00007fdcc4c4f420 R08: 00007fdb9807ee10 R09:=
 0000000000000000
[Fri Mar  8 04:38:21 2019] R10: 00007fdb98090b70 R11: 0000000000000246 R12:=
 0000000000000020
[Fri Mar  8 04:38:21 2019] R13: 0000000000000018 R14: 00007fdb9807ee28 R15:=
 00007fdcc4c4f428
[Fri Mar  8 04:38:21 2019] crawl_275       D    0 15837  27345 0x00000000
[Fri Mar  8 04:38:21 2019] Call Trace:
[Fri Mar  8 04:38:21 2019]  ? __schedule+0x429/0xbb0
[Fri Mar  8 04:38:21 2019]  ? prepare_to_wait_event+0x97/0x190
[Fri Mar  8 04:38:21 2019]  schedule+0x39/0x90
[Fri Mar  8 04:38:21 2019]  wait_current_trans+0xa3/0xf0
[Fri Mar  8 04:38:21 2019]  ? wait_woken+0xa0/0xa0
[Fri Mar  8 04:38:21 2019]  start_transaction+0x29b/0x4d0
[Fri Mar  8 04:38:21 2019]  btrfs_clone+0x5a3/0xcc0
[Fri Mar  8 04:38:21 2019]  btrfs_dedupe_file_range+0x5e3/0x660
[Fri Mar  8 04:38:21 2019]  vfs_dedupe_file_range+0x22e/0x280
[Fri Mar  8 04:38:21 2019]  do_vfs_ioctl+0x24d/0x6b0
[Fri Mar  8 04:38:21 2019]  ? __fget+0x11f/0x210
[Fri Mar  8 04:38:21 2019]  SyS_ioctl+0x74/0x80
[Fri Mar  8 04:38:21 2019]  do_syscall_64+0x76/0x180
[Fri Mar  8 04:38:21 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Fri Mar  8 04:38:21 2019] RIP: 0033:0x7fdcc7538dd7
[Fri Mar  8 04:38:21 2019] RSP: 002b:00007fdcc3c4d0a8 EFLAGS: 00000246 ORIG=
_RAX: 0000000000000010
[Fri Mar  8 04:38:21 2019] RAX: ffffffffffffffda RBX: 00007fdba02014f0 RCX:=
 00007fdcc7538dd7
[Fri Mar  8 04:38:21 2019] RDX: 00007fdba02014f0 RSI: 00000000c0189436 RDI:=
 0000000000000029
[Fri Mar  8 04:38:21 2019] RBP: 00007fdcc3c4d420 R08: 00007fdba0010cc0 R09:=
 0000000000000000
[Fri Mar  8 04:38:21 2019] R10: 00007fdba0088130 R11: 0000000000000246 R12:=
 0000000000000020
[Fri Mar  8 04:38:21 2019] R13: 0000000000000018 R14: 00007fdba0010cd8 R15:=
 00007fdcc3c4d428
[Fri Mar  8 04:38:21 2019] crawl_299       D    0 15838  27345 0x00000000
[Fri Mar  8 04:38:21 2019] Call Trace:
[Fri Mar  8 04:38:21 2019]  ? __schedule+0x429/0xbb0
[Fri Mar  8 04:38:21 2019]  ? prepare_to_wait_event+0x97/0x190
[Fri Mar  8 04:38:21 2019]  schedule+0x39/0x90
[Fri Mar  8 04:38:21 2019]  wait_current_trans+0xa3/0xf0
[Fri Mar  8 04:38:21 2019]  ? wait_woken+0xa0/0xa0
[Fri Mar  8 04:38:21 2019]  start_transaction+0x29b/0x4d0
[Fri Mar  8 04:38:21 2019]  btrfs_clone+0x5a3/0xcc0
[Fri Mar  8 04:38:21 2019]  btrfs_dedupe_file_range+0x5e3/0x660
[Fri Mar  8 04:38:21 2019]  vfs_dedupe_file_range+0x22e/0x280
[Fri Mar  8 04:38:21 2019]  do_vfs_ioctl+0x24d/0x6b0
[Fri Mar  8 04:38:21 2019]  ? __fget+0x11f/0x210
[Fri Mar  8 04:38:21 2019]  SyS_ioctl+0x74/0x80
[Fri Mar  8 04:38:21 2019]  do_syscall_64+0x76/0x180
[Fri Mar  8 04:38:21 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Fri Mar  8 04:38:21 2019] RIP: 0033:0x7fdcc7538dd7
[Fri Mar  8 04:38:21 2019] RSP: 002b:00007fdcc444e0a8 EFLAGS: 00000246 ORIG=
_RAX: 0000000000000010
[Fri Mar  8 04:38:21 2019] RAX: ffffffffffffffda RBX: 00007fdb942937c0 RCX:=
 00007fdcc7538dd7
[Fri Mar  8 04:38:21 2019] RDX: 00007fdb942937c0 RSI: 00000000c0189436 RDI:=
 00000000000004a0
[Fri Mar  8 04:38:21 2019] RBP: 00007fdcc444e420 R08: 00007fdb94094dd0 R09:=
 0000000000000000
[Fri Mar  8 04:38:21 2019] R10: 00007fdb94049c10 R11: 0000000000000246 R12:=
 0000000000000020
[Fri Mar  8 04:38:21 2019] R13: 0000000000000018 R14: 00007fdb94094de8 R15:=
 00007fdcc444e428
[Fri Mar  8 04:38:21 2019] crawl_290       D    0 15839  27345 0x00000000
[Fri Mar  8 04:38:21 2019] Call Trace:
[Fri Mar  8 04:38:21 2019]  ? __schedule+0x429/0xbb0
[Fri Mar  8 04:38:21 2019]  ? prepare_to_wait_event+0x97/0x190
[Fri Mar  8 04:38:21 2019]  schedule+0x39/0x90
[Fri Mar  8 04:38:21 2019]  wait_current_trans+0xa3/0xf0
[Fri Mar  8 04:38:21 2019]  ? wait_woken+0xa0/0xa0
[Fri Mar  8 04:38:21 2019]  start_transaction+0x29b/0x4d0
[Fri Mar  8 04:38:21 2019]  btrfs_clone+0x5a3/0xcc0
[Fri Mar  8 04:38:21 2019]  btrfs_dedupe_file_range+0x5e3/0x660
[Fri Mar  8 04:38:21 2019]  vfs_dedupe_file_range+0x22e/0x280
[Fri Mar  8 04:38:21 2019]  do_vfs_ioctl+0x24d/0x6b0
[Fri Mar  8 04:38:21 2019]  ? __fget+0x11f/0x210
[Fri Mar  8 04:38:21 2019]  SyS_ioctl+0x74/0x80
[Fri Mar  8 04:38:21 2019]  do_syscall_64+0x76/0x180
[Fri Mar  8 04:38:21 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Fri Mar  8 04:38:21 2019] RIP: 0033:0x7fdcc7538dd7
[Fri Mar  8 04:38:21 2019] RSP: 002b:00007fdcc5c510a8 EFLAGS: 00000246 ORIG=
_RAX: 0000000000000010
[Fri Mar  8 04:38:21 2019] RAX: ffffffffffffffda RBX: 00007fdb8c4a6060 RCX:=
 00007fdcc7538dd7
[Fri Mar  8 04:38:21 2019] RDX: 00007fdb8c4a6060 RSI: 00000000c0189436 RDI:=
 00000000000004a1
[Fri Mar  8 04:38:21 2019] RBP: 00007fdcc5c51420 R08: 00007fdb8c060170 R09:=
 0000000000000000
[Fri Mar  8 04:38:21 2019] R10: 00007fdb8c07dd40 R11: 0000000000000246 R12:=
 0000000000000020
[Fri Mar  8 04:38:21 2019] R13: 0000000000000018 R14: 00007fdb8c060188 R15:=
 00007fdcc5c51428
[Fri Mar  8 04:38:21 2019] btrfs           D    0  9795   9787 0x00000000
[Fri Mar  8 04:38:21 2019] Call Trace:
[Fri Mar  8 04:38:21 2019]  ? __schedule+0x429/0xbb0
[Fri Mar  8 04:38:21 2019]  ? prepare_to_wait_event+0x97/0x190
[Fri Mar  8 04:38:21 2019]  schedule+0x39/0x90
[Fri Mar  8 04:38:21 2019]  wait_for_commit+0x3f/0x70
[Fri Mar  8 04:38:21 2019]  ? wait_woken+0xa0/0xa0
[Fri Mar  8 04:38:21 2019]  btrfs_wait_for_commit+0xf2/0x130
[Fri Mar  8 04:38:21 2019]  btrfs_inc_block_group_ro+0x52/0x170
[Fri Mar  8 04:38:21 2019]  scrub_enumerate_chunks+0x191/0x610
[Fri Mar  8 04:38:21 2019]  ? wait_woken+0x70/0xa0
[Fri Mar  8 04:38:21 2019]  btrfs_scrub_dev+0x1fa/0x650
[Fri Mar  8 04:38:21 2019]  ? mnt_want_write_file+0x3b/0xb0
[Fri Mar  8 04:38:21 2019]  btrfs_ioctl+0x1342/0x26a0
[Fri Mar  8 04:38:21 2019]  ? lock_acquire+0xbc/0x200
[Fri Mar  8 04:38:21 2019]  ? lock_acquire+0xbc/0x200
[Fri Mar  8 04:38:21 2019]  ? do_vfs_ioctl+0x92/0x6b0
[Fri Mar  8 04:38:21 2019]  do_vfs_ioctl+0x92/0x6b0
[Fri Mar  8 04:38:21 2019]  ? __fget+0x11f/0x210
[Fri Mar  8 04:38:21 2019]  SyS_ioctl+0x74/0x80
[Fri Mar  8 04:38:21 2019]  do_syscall_64+0x76/0x180
[Fri Mar  8 04:38:21 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Fri Mar  8 04:38:21 2019] RIP: 0033:0x7f0ab8c50dd7
[Fri Mar  8 04:38:21 2019] RSP: 002b:00007f0ab8b6ed58 EFLAGS: 00000246 ORIG=
_RAX: 0000000000000010
[Fri Mar  8 04:38:21 2019] RAX: ffffffffffffffda RBX: 00005601803ae4f0 RCX:=
 00007f0ab8c50dd7
[Fri Mar  8 04:38:21 2019] RDX: 00005601803ae4f0 RSI: 00000000c400941b RDI:=
 0000000000000003
[Fri Mar  8 04:38:21 2019] RBP: 0000000000000000 R08: 00007f0ab8b6f700 R09:=
 0000000000000000
[Fri Mar  8 04:38:21 2019] R10: 00007f0ab8b6f700 R11: 0000000000000246 R12:=
 0000000000000000
[Fri Mar  8 04:38:21 2019] R13: 00007ffd74e35cdf R14: 0000000000000000 R15:=
 00007f0ab9bec040
[Fri Mar  8 04:38:21 2019] btrfs           D    0  9796   9787 0x00000000
[Fri Mar  8 04:38:21 2019] Call Trace:
[Fri Mar  8 04:38:21 2019]  ? __schedule+0x429/0xbb0
[Fri Mar  8 04:38:21 2019]  ? prepare_to_wait_event+0x97/0x190
[Fri Mar  8 04:38:21 2019]  schedule+0x39/0x90
[Fri Mar  8 04:38:21 2019]  wait_for_commit+0x3f/0x70
[Fri Mar  8 04:38:21 2019]  ? wait_woken+0xa0/0xa0
[Fri Mar  8 04:38:21 2019]  btrfs_wait_for_commit+0xf2/0x130
[Fri Mar  8 04:38:21 2019]  btrfs_inc_block_group_ro+0x52/0x170
[Fri Mar  8 04:38:21 2019]  scrub_enumerate_chunks+0x191/0x610
[Fri Mar  8 04:38:21 2019]  ? wait_woken+0x70/0xa0
[Fri Mar  8 04:38:21 2019]  btrfs_scrub_dev+0x1fa/0x650
[Fri Mar  8 04:38:21 2019]  ? mnt_want_write_file+0x3b/0xb0
[Fri Mar  8 04:38:21 2019]  btrfs_ioctl+0x1342/0x26a0
[Fri Mar  8 04:38:21 2019]  ? lock_acquire+0xbc/0x200
[Fri Mar  8 04:38:21 2019]  ? lock_acquire+0xbc/0x200
[Fri Mar  8 04:38:21 2019]  ? do_vfs_ioctl+0x92/0x6b0
[Fri Mar  8 04:38:21 2019]  do_vfs_ioctl+0x92/0x6b0
[Fri Mar  8 04:38:21 2019]  ? __fget+0x11f/0x210
[Fri Mar  8 04:38:21 2019]  SyS_ioctl+0x74/0x80
[Fri Mar  8 04:38:21 2019]  do_syscall_64+0x76/0x180
[Fri Mar  8 04:38:21 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Fri Mar  8 04:38:21 2019] RIP: 0033:0x7f0ab8c50dd7
[Fri Mar  8 04:38:21 2019] RSP: 002b:00007f0ab836dd58 EFLAGS: 00000246 ORIG=
_RAX: 0000000000000010
[Fri Mar  8 04:38:21 2019] RAX: ffffffffffffffda RBX: 00005601803ae970 RCX:=
 00007f0ab8c50dd7
[Fri Mar  8 04:38:21 2019] RDX: 00005601803ae970 RSI: 00000000c400941b RDI:=
 0000000000000003
[Fri Mar  8 04:38:21 2019] RBP: 0000000000000000 R08: 00007f0ab836e700 R09:=
 0000000000000000
[Fri Mar  8 04:38:21 2019] R10: 00007f0ab836e700 R11: 0000000000000246 R12:=
 0000000000000000
[Fri Mar  8 04:38:21 2019] R13: 00007ffd74e35cdf R14: 0000000000000000 R15:=
 00007f0ab9bec040
[Fri Mar  8 04:38:21 2019] btrfs           D    0  9797   9787 0x00000000
[Fri Mar  8 04:38:21 2019] Call Trace:
[Fri Mar  8 04:38:21 2019]  ? __schedule+0x429/0xbb0
[Fri Mar  8 04:38:21 2019]  ? prepare_to_wait_event+0x97/0x190
[Fri Mar  8 04:38:21 2019]  schedule+0x39/0x90
[Fri Mar  8 04:38:21 2019]  wait_for_commit+0x3f/0x70
[Fri Mar  8 04:38:21 2019]  ? wait_woken+0xa0/0xa0
[Fri Mar  8 04:38:21 2019]  btrfs_wait_for_commit+0xf2/0x130
[Fri Mar  8 04:38:21 2019]  btrfs_inc_block_group_ro+0x52/0x170
[Fri Mar  8 04:38:21 2019]  scrub_enumerate_chunks+0x191/0x610
[Fri Mar  8 04:38:21 2019]  ? wait_woken+0x70/0xa0
[Fri Mar  8 04:38:21 2019]  btrfs_scrub_dev+0x1fa/0x650
[Fri Mar  8 04:38:21 2019]  ? mnt_want_write_file+0x3b/0xb0
[Fri Mar  8 04:38:21 2019]  btrfs_ioctl+0x1342/0x26a0
[Fri Mar  8 04:38:21 2019]  ? lock_acquire+0xbc/0x200
[Fri Mar  8 04:38:21 2019]  ? lock_acquire+0xbc/0x200
[Fri Mar  8 04:38:21 2019]  ? do_vfs_ioctl+0x92/0x6b0
[Fri Mar  8 04:38:21 2019]  do_vfs_ioctl+0x92/0x6b0
[Fri Mar  8 04:38:21 2019]  ? __fget+0x11f/0x210
[Fri Mar  8 04:38:21 2019]  SyS_ioctl+0x74/0x80
[Fri Mar  8 04:38:21 2019]  do_syscall_64+0x76/0x180
[Fri Mar  8 04:38:21 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Fri Mar  8 04:38:21 2019] RIP: 0033:0x7f0ab8c50dd7
[Fri Mar  8 04:38:21 2019] RSP: 002b:00007f0ab7b6cd58 EFLAGS: 00000246 ORIG=
_RAX: 0000000000000010
[Fri Mar  8 04:38:21 2019] RAX: ffffffffffffffda RBX: 00005601803aedf0 RCX:=
 00007f0ab8c50dd7
[Fri Mar  8 04:38:21 2019] RDX: 00005601803aedf0 RSI: 00000000c400941b RDI:=
 0000000000000003
[Fri Mar  8 04:38:21 2019] RBP: 0000000000000000 R08: 00007f0ab7b6d700 R09:=
 0000000000000000
[Fri Mar  8 04:38:21 2019] R10: 00007f0ab7b6d700 R11: 0000000000000246 R12:=
 0000000000000000
[Fri Mar  8 04:38:21 2019] R13: 00007ffd74e35cdf R14: 0000000000000000 R15:=
 00007f0ab9bec040
[Fri Mar  8 04:38:21 2019] btrfs           D    0  9798   9787 0x00000000
[Fri Mar  8 04:38:21 2019] Call Trace:
[Fri Mar  8 04:38:21 2019]  ? __schedule+0x429/0xbb0
[Fri Mar  8 04:38:21 2019]  ? prepare_to_wait_event+0x97/0x190
[Fri Mar  8 04:38:21 2019]  schedule+0x39/0x90
[Fri Mar  8 04:38:21 2019]  wait_for_commit+0x3f/0x70
[Fri Mar  8 04:38:21 2019]  ? wait_woken+0xa0/0xa0
[Fri Mar  8 04:38:21 2019]  btrfs_wait_for_commit+0xf2/0x130
[Fri Mar  8 04:38:21 2019]  btrfs_inc_block_group_ro+0x52/0x170
[Fri Mar  8 04:38:21 2019]  scrub_enumerate_chunks+0x191/0x610
[Fri Mar  8 04:38:21 2019]  ? wait_woken+0x70/0xa0
[Fri Mar  8 04:38:21 2019]  btrfs_scrub_dev+0x1fa/0x650
[Fri Mar  8 04:38:21 2019]  ? mnt_want_write_file+0x3b/0xb0
[Fri Mar  8 04:38:21 2019]  btrfs_ioctl+0x1342/0x26a0
[Fri Mar  8 04:38:21 2019]  ? lock_acquire+0xbc/0x200
[Fri Mar  8 04:38:21 2019]  ? lock_acquire+0xbc/0x200
[Fri Mar  8 04:38:21 2019]  ? do_vfs_ioctl+0x92/0x6b0
[Fri Mar  8 04:38:21 2019]  do_vfs_ioctl+0x92/0x6b0
[Fri Mar  8 04:38:21 2019]  ? __fget+0x11f/0x210
[Fri Mar  8 04:38:21 2019]  SyS_ioctl+0x74/0x80
[Fri Mar  8 04:38:21 2019]  do_syscall_64+0x76/0x180
[Fri Mar  8 04:38:21 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Fri Mar  8 04:38:21 2019] RIP: 0033:0x7f0ab8c50dd7
[Fri Mar  8 04:38:21 2019] RSP: 002b:00007f0ab736bd58 EFLAGS: 00000246 ORIG=
_RAX: 0000000000000010
[Fri Mar  8 04:38:21 2019] RAX: ffffffffffffffda RBX: 00005601803af270 RCX:=
 00007f0ab8c50dd7
[Fri Mar  8 04:38:21 2019] RDX: 00005601803af270 RSI: 00000000c400941b RDI:=
 0000000000000003
[Fri Mar  8 04:38:21 2019] RBP: 0000000000000000 R08: 00007f0ab736c700 R09:=
 0000000000000000
[Fri Mar  8 04:38:21 2019] R10: 00007f0ab736c700 R11: 0000000000000246 R12:=
 0000000000000000
[Fri Mar  8 04:38:21 2019] R13: 00007ffd74e35cdf R14: 0000000000000000 R15:=
 00007f0ab9bec040
[Fri Mar  8 04:38:21 2019] btrfs           D    0  9799   9787 0x00000000
[Fri Mar  8 04:38:21 2019] Call Trace:
[Fri Mar  8 04:38:21 2019]  ? __schedule+0x429/0xbb0
[Fri Mar  8 04:38:21 2019]  ? prepare_to_wait_event+0x97/0x190
[Fri Mar  8 04:38:21 2019]  schedule+0x39/0x90
[Fri Mar  8 04:38:21 2019]  wait_for_commit+0x3f/0x70
[Fri Mar  8 04:38:21 2019]  ? wait_woken+0xa0/0xa0
[Fri Mar  8 04:38:21 2019]  btrfs_wait_for_commit+0xf2/0x130
[Fri Mar  8 04:38:21 2019]  btrfs_inc_block_group_ro+0x52/0x170
[Fri Mar  8 04:38:21 2019]  scrub_enumerate_chunks+0x191/0x610
[Fri Mar  8 04:38:21 2019]  ? wait_woken+0x70/0xa0
[Fri Mar  8 04:38:21 2019]  btrfs_scrub_dev+0x1fa/0x650
[Fri Mar  8 04:38:21 2019]  ? mnt_want_write_file+0x3b/0xb0
[Fri Mar  8 04:38:21 2019]  btrfs_ioctl+0x1342/0x26a0
[Fri Mar  8 04:38:21 2019]  ? lock_acquire+0xbc/0x200
[Fri Mar  8 04:38:21 2019]  ? lock_acquire+0xbc/0x200
[Fri Mar  8 04:38:21 2019]  ? do_vfs_ioctl+0x92/0x6b0
[Fri Mar  8 04:38:21 2019]  do_vfs_ioctl+0x92/0x6b0
[Fri Mar  8 04:38:21 2019]  ? __fget+0x11f/0x210
[Fri Mar  8 04:38:21 2019]  SyS_ioctl+0x74/0x80
[Fri Mar  8 04:38:21 2019]  do_syscall_64+0x76/0x180
[Fri Mar  8 04:38:21 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Fri Mar  8 04:38:21 2019] RIP: 0033:0x7f0ab8c50dd7
[Fri Mar  8 04:38:21 2019] RSP: 002b:00007f0ab6b6ad58 EFLAGS: 00000246 ORIG=
_RAX: 0000000000000010
[Fri Mar  8 04:38:21 2019] RAX: ffffffffffffffda RBX: 00005601803af6f0 RCX:=
 00007f0ab8c50dd7
[Fri Mar  8 04:38:21 2019] RDX: 00005601803af6f0 RSI: 00000000c400941b RDI:=
 0000000000000003
[Fri Mar  8 04:38:21 2019] RBP: 0000000000000000 R08: 00007f0ab6b6b700 R09:=
 0000000000000000
[Fri Mar  8 04:38:21 2019] R10: 00007f0ab6b6b700 R11: 0000000000000246 R12:=
 0000000000000000
[Fri Mar  8 04:38:21 2019] R13: 00007ffd74e35cdf R14: 0000000000000000 R15:=
 00007f0ab9bec040
[Fri Mar  8 04:38:21 2019] rsync           D    0 12329  12200 0x00000000
[Fri Mar  8 04:38:21 2019] Call Trace:
[Fri Mar  8 04:38:21 2019]  ? __schedule+0x429/0xbb0
[Fri Mar  8 04:38:21 2019]  ? prepare_to_wait_event+0x97/0x190
[Fri Mar  8 04:38:21 2019]  schedule+0x39/0x90
[Fri Mar  8 04:38:21 2019]  wait_current_trans+0xa3/0xf0
[Fri Mar  8 04:38:21 2019]  ? wait_woken+0xa0/0xa0
[Fri Mar  8 04:38:21 2019]  start_transaction+0x29b/0x4d0
[Fri Mar  8 04:38:21 2019]  btrfs_create+0x47/0x1d0
[Fri Mar  8 04:38:21 2019]  lookup_open+0x404/0x760
[Fri Mar  8 04:38:21 2019]  ? __wake_up_common_lock+0x53/0x90
[Fri Mar  8 04:38:21 2019]  path_openat+0x4e9/0xcc0
[Fri Mar  8 04:38:21 2019]  do_filp_open+0x8a/0xf0
[Fri Mar  8 04:38:21 2019]  ? __alloc_fd+0xee/0x200
[Fri Mar  8 04:38:21 2019]  ? do_sys_open+0x130/0x200
[Fri Mar  8 04:38:21 2019]  do_sys_open+0x130/0x200
[Fri Mar  8 04:38:21 2019]  do_syscall_64+0x76/0x180
[Fri Mar  8 04:38:21 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Fri Mar  8 04:38:21 2019] RIP: 0033:0x7f37f89b34b0
[Fri Mar  8 04:38:21 2019] RSP: 002b:00007ffdd3371078 EFLAGS: 00000246 ORIG=
_RAX: 0000000000000002
[Fri Mar  8 04:38:21 2019] RAX: ffffffffffffffda RBX: 0000000000000000 RCX:=
 00007f37f89b34b0
[Fri Mar  8 04:38:21 2019] RDX: 0000000000000180 RSI: 00000000000000c2 RDI:=
 00007ffdd33732e0
[Fri Mar  8 04:38:21 2019] RBP: 000000000003a2f8 R08: 000000000000001e R09:=
 00007f37f8a06120
[Fri Mar  8 04:38:21 2019] R10: 0000000000000000 R11: 0000000000000246 R12:=
 00007ffdd33732f6
[Fri Mar  8 04:38:21 2019] R13: 8421084210842109 R14: 00000000000000c2 R15:=
 00007f37f8a41320
[Fri Mar  8 04:38:21 2019] rsync           D    0 15392  15306 0x00000000
[Fri Mar  8 04:38:21 2019] Call Trace:
[Fri Mar  8 04:38:21 2019]  ? __schedule+0x429/0xbb0
[Fri Mar  8 04:38:21 2019]  ? prepare_to_wait_event+0x97/0x190
[Fri Mar  8 04:38:21 2019]  schedule+0x39/0x90
[Fri Mar  8 04:38:21 2019]  wait_current_trans+0xa3/0xf0
[Fri Mar  8 04:38:21 2019]  ? wait_woken+0xa0/0xa0
[Fri Mar  8 04:38:21 2019]  start_transaction+0x29b/0x4d0
[Fri Mar  8 04:38:21 2019]  btrfs_create+0x47/0x1d0
[Fri Mar  8 04:38:21 2019]  lookup_open+0x404/0x760
[Fri Mar  8 04:38:21 2019]  ? __wake_up_common_lock+0x53/0x90
[Fri Mar  8 04:38:21 2019]  path_openat+0x4e9/0xcc0
[Fri Mar  8 04:38:21 2019]  do_filp_open+0x8a/0xf0
[Fri Mar  8 04:38:21 2019]  ? __alloc_fd+0xee/0x200
[Fri Mar  8 04:38:21 2019]  ? do_sys_open+0x130/0x200
[Fri Mar  8 04:38:21 2019]  do_sys_open+0x130/0x200
[Fri Mar  8 04:38:21 2019]  do_syscall_64+0x76/0x180
[Fri Mar  8 04:38:21 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Fri Mar  8 04:38:21 2019] RIP: 0033:0x7ff710ce34b0
[Fri Mar  8 04:38:21 2019] RSP: 002b:00007ffc267318a8 EFLAGS: 00000246 ORIG=
_RAX: 0000000000000002
[Fri Mar  8 04:38:21 2019] RAX: ffffffffffffffda RBX: 0000000000000000 RCX:=
 00007ff710ce34b0
[Fri Mar  8 04:38:21 2019] RDX: 0000000000000180 RSI: 00000000000000c2 RDI:=
 00007ffc26733b10
[Fri Mar  8 04:38:21 2019] RBP: 000000000003a2f8 R08: 0000000000000000 R09:=
 00007ff710d35b30
[Fri Mar  8 04:38:21 2019] R10: 0000000000000000 R11: 0000000000000246 R12:=
 00007ffc26733b3f
[Fri Mar  8 04:38:21 2019] R13: 8421084210842109 R14: 00000000000000c2 R15:=
 00007ff710d71320
[Fri Mar  8 04:38:21 2019] rsync           D    0 24322  12266 0x00000000
[Fri Mar  8 04:38:21 2019] Call Trace:
[Fri Mar  8 04:38:21 2019]  ? __schedule+0x429/0xbb0
[Fri Mar  8 04:38:21 2019]  ? prepare_to_wait_event+0x97/0x190
[Fri Mar  8 04:38:21 2019]  schedule+0x39/0x90
[Fri Mar  8 04:38:21 2019]  wait_current_trans+0xa3/0xf0
[Fri Mar  8 04:38:21 2019]  ? wait_woken+0xa0/0xa0
[Fri Mar  8 04:38:21 2019]  start_transaction+0x29b/0x4d0
[Fri Mar  8 04:38:21 2019]  btrfs_setattr+0x1e6/0x3b0
[Fri Mar  8 04:38:21 2019]  notify_change+0x2ed/0x450
[Fri Mar  8 04:38:21 2019]  do_truncate+0x5e/0x90
[Fri Mar  8 04:38:21 2019]  ? rcu_read_lock_sched_held+0x68/0x70
[Fri Mar  8 04:38:21 2019]  do_sys_ftruncate.constprop.1+0x120/0x180
[Fri Mar  8 04:38:21 2019]  ? trace_hardirqs_off_thunk+0x1a/0x1c
[Fri Mar  8 04:38:21 2019]  do_syscall_64+0x76/0x180
[Fri Mar  8 04:38:21 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Fri Mar  8 04:38:21 2019] RIP: 0033:0x7f2994512c87
[Fri Mar  8 04:38:21 2019] RSP: 002b:00007fff6ffc5be8 EFLAGS: 00000246 ORIG=
_RAX: 000000000000004d
[Fri Mar  8 04:38:21 2019] RAX: ffffffffffffffda RBX: 0000000000000000 RCX:=
 00007f2994512c87
[Fri Mar  8 04:38:21 2019] RDX: 0000000000000000 RSI: 0000000004648f62 RDI:=
 0000000000000004
[Fri Mar  8 04:38:21 2019] RBP: 0000000000000004 R08: 0000000000000000 R09:=
 00007f299455d7b8
[Fri Mar  8 04:38:21 2019] R10: 0000000000000000 R11: 0000000000000246 R12:=
 0000000004648f62
[Fri Mar  8 04:38:21 2019] R13: 00000000000008a1 R14: 0000000000001f78 R15:=
 0000000000000005
[Fri Mar  8 04:38:21 2019] rsync           D    0 25113  12114 0x00000000
[Fri Mar  8 04:38:21 2019] Call Trace:
[Fri Mar  8 04:38:21 2019]  ? __schedule+0x429/0xbb0
[Fri Mar  8 04:38:21 2019]  ? prepare_to_wait_event+0x97/0x190
[Fri Mar  8 04:38:21 2019]  schedule+0x39/0x90
[Fri Mar  8 04:38:21 2019]  wait_current_trans+0xa3/0xf0
[Fri Mar  8 04:38:21 2019]  ? wait_woken+0xa0/0xa0
[Fri Mar  8 04:38:21 2019]  start_transaction+0x29b/0x4d0
[Fri Mar  8 04:38:21 2019]  __btrfs_setxattr+0x61/0x110
[Fri Mar  8 04:38:21 2019]  __vfs_setxattr+0x66/0x80
[Fri Mar  8 04:38:21 2019]  __vfs_setxattr_noperm+0x6d/0x1b0
[Fri Mar  8 04:38:21 2019]  vfs_setxattr+0xa0/0xb0
[Fri Mar  8 04:38:21 2019]  setxattr+0x131/0x1a0
[Fri Mar  8 04:38:21 2019]  ? lock_acquire+0xbc/0x200
[Fri Mar  8 04:38:21 2019]  ? rcu_read_lock_sched_held+0x68/0x70
[Fri Mar  8 04:38:21 2019]  ? rcu_sync_lockdep_assert+0x30/0x60
[Fri Mar  8 04:38:21 2019]  ? __sb_start_write+0xcc/0x1b0
[Fri Mar  8 04:38:21 2019]  ? mnt_want_write+0x20/0x50
[Fri Mar  8 04:38:21 2019]  path_setxattr+0x94/0xc0
[Fri Mar  8 04:38:21 2019]  SyS_lsetxattr+0xd/0x10
[Fri Mar  8 04:38:21 2019]  do_syscall_64+0x76/0x180
[Fri Mar  8 04:38:21 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Fri Mar  8 04:38:21 2019] RIP: 0033:0x7f1934b64229
[Fri Mar  8 04:38:21 2019] RSP: 002b:00007ffc0ca30b38 EFLAGS: 00000246 ORIG=
_RAX: 00000000000000bd
[Fri Mar  8 04:38:21 2019] RAX: ffffffffffffffda RBX: 0000000000000000 RCX:=
 00007f1934b64229
[Fri Mar  8 04:38:21 2019] RDX: 00007ffc0ca30c70 RSI: 000055cb645696dd RDI:=
 00007ffc0ca33050
[Fri Mar  8 04:38:21 2019] RBP: 00007ffc0ca30c70 R08: 0000000000000000 R09:=
 00000000000003ea
[Fri Mar  8 04:38:21 2019] R10: 0000000000000014 R11: 0000000000000246 R12:=
 0000000000000000
[Fri Mar  8 04:38:21 2019] R13: 00007ffc0ca33050 R14: 00000000000081a4 R15:=
 00007f19355af7ec
[Fri Mar  8 04:38:21 2019] rsync           D    0 14184  14076 0x00000000
[Fri Mar  8 04:38:21 2019] Call Trace:
[Fri Mar  8 04:38:21 2019]  ? __schedule+0x429/0xbb0
[Fri Mar  8 04:38:21 2019]  ? prepare_to_wait_event+0x97/0x190
[Fri Mar  8 04:38:21 2019]  schedule+0x39/0x90
[Fri Mar  8 04:38:21 2019]  wait_current_trans+0xa3/0xf0
[Fri Mar  8 04:38:21 2019]  ? wait_woken+0xa0/0xa0
[Fri Mar  8 04:38:21 2019]  start_transaction+0x29b/0x4d0
[Fri Mar  8 04:38:21 2019]  btrfs_start_transaction_fallback_global_rsv+0x3=
4/0x200
[Fri Mar  8 04:38:21 2019]  btrfs_unlink+0x30/0xd0
[Fri Mar  8 04:38:21 2019]  vfs_unlink+0xf8/0x190
[Fri Mar  8 04:38:21 2019]  do_unlinkat+0x287/0x300
[Fri Mar  8 04:38:21 2019]  do_syscall_64+0x76/0x180
[Fri Mar  8 04:38:21 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Fri Mar  8 04:38:21 2019] RIP: 0033:0x7fc9a562cea7
[Fri Mar  8 04:38:21 2019] RSP: 002b:00007ffd3cbd9a18 EFLAGS: 00000246 ORIG=
_RAX: 0000000000000057
[Fri Mar  8 04:38:21 2019] RAX: ffffffffffffffda RBX: 0000000000000002 RCX:=
 00007fc9a562cea7
[Fri Mar  8 04:38:21 2019] RDX: 0000000000000000 RSI: 00000000000081a4 RDI:=
 00007ffd3cbdaad0
[Fri Mar  8 04:38:21 2019] RBP: 00000000000081a4 R08: 000000000000fff0 R09:=
 00007fc9a567d770
[Fri Mar  8 04:38:21 2019] R10: 632e766c6f736572 R11: 0000000000000246 R12:=
 00007ffd3cbdaad0
[Fri Mar  8 04:38:21 2019] R13: 0000000000008000 R14: 0000000000000000 R15:=
 00000000000081a4
[Fri Mar  8 04:38:21 2019] kworker/u8:20   D    0 20623      2 0x80000000
[Fri Mar  8 04:38:21 2019] Workqueue: btrfs-flush_delalloc btrfs_flush_dela=
lloc_helper
[Fri Mar  8 04:38:21 2019] Call Trace:
[Fri Mar  8 04:38:21 2019]  ? __schedule+0x429/0xbb0
[Fri Mar  8 04:38:21 2019]  schedule+0x39/0x90
[Fri Mar  8 04:38:21 2019]  io_schedule+0x12/0x40
[Fri Mar  8 04:38:21 2019]  __lock_page+0x110/0x140
[Fri Mar  8 04:38:21 2019]  ? add_to_page_cache_lru+0xc0/0xc0
[Fri Mar  8 04:38:21 2019]  extent_write_cache_pages.constprop.27+0x2d9/0x3=
b0
[Fri Mar  8 04:38:21 2019]  ? lock_acquire+0xbc/0x200
[Fri Mar  8 04:38:21 2019]  extent_writepages+0x4e/0x70
[Fri Mar  8 04:38:21 2019]  ? btrfs_direct_IO+0x3e0/0x3e0
[Fri Mar  8 04:38:21 2019]  do_writepages+0x23/0x80
[Fri Mar  8 04:38:21 2019]  __filemap_fdatawrite_range+0xaa/0xe0
[Fri Mar  8 04:38:21 2019]  btrfs_run_delalloc_work+0x17/0x60
[Fri Mar  8 04:38:21 2019]  btrfs_scrubparity_helper+0x8f/0x640
[Fri Mar  8 04:38:21 2019]  process_one_work+0x204/0x650
[Fri Mar  8 04:38:21 2019]  worker_thread+0x4d/0x3b0
[Fri Mar  8 04:38:21 2019]  kthread+0x10d/0x140
[Fri Mar  8 04:38:21 2019]  ? process_one_work+0x650/0x650
[Fri Mar  8 04:38:21 2019]  ? kthread_create_on_node+0x40/0x40
[Fri Mar  8 04:38:21 2019]  ret_from_fork+0x27/0x50
[Fri Mar  8 04:38:21 2019] mkdir           D    0 17020  17013 0x00000000
[Fri Mar  8 04:38:21 2019] Call Trace:
[Fri Mar  8 04:38:21 2019]  ? __schedule+0x429/0xbb0
[Fri Mar  8 04:38:21 2019]  ? prepare_to_wait_event+0x97/0x190
[Fri Mar  8 04:38:21 2019]  schedule+0x39/0x90
[Fri Mar  8 04:38:21 2019]  wait_current_trans+0xa3/0xf0
[Fri Mar  8 04:38:21 2019]  ? wait_woken+0xa0/0xa0
[Fri Mar  8 04:38:21 2019]  start_transaction+0x29b/0x4d0
[Fri Mar  8 04:38:21 2019]  btrfs_mkdir+0x50/0x1d0
[Fri Mar  8 04:38:21 2019]  vfs_mkdir+0x134/0x1c0
[Fri Mar  8 04:38:21 2019]  SyS_mkdirat+0xb3/0xf0
[Fri Mar  8 04:38:21 2019]  do_syscall_64+0x76/0x180
[Fri Mar  8 04:38:21 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Fri Mar  8 04:38:21 2019] RIP: 0033:0x7fed308fb447
[Fri Mar  8 04:38:21 2019] RSP: 002b:00007ffcfc5df778 EFLAGS: 00000206 ORIG=
_RAX: 0000000000000053
[Fri Mar  8 04:38:21 2019] RAX: ffffffffffffffda RBX: 00007ffcfc5e1b28 RCX:=
 00007fed308fb447
[Fri Mar  8 04:38:21 2019] RDX: 0000000000000000 RSI: 00000000000001ff RDI:=
 00007ffcfc5e1b4d
[Fri Mar  8 04:38:21 2019] RBP: 00007ffcfc5df8f0 R08: 00000000000001ff R09:=
 000056093bb17e10
[Fri Mar  8 04:38:21 2019] R10: 0000000000000376 R11: 0000000000000206 R12:=
 000056093bb17e50
[Fri Mar  8 04:38:21 2019] R13: 00000000000001ff R14: 00007ffcfc5dfa90 R15:=
 0000000000000001
[Fri Mar  8 04:38:21 2019] rsync           D    0  2327   2261 0x00000000
[Fri Mar  8 04:38:21 2019] Call Trace:
[Fri Mar  8 04:38:21 2019]  ? __schedule+0x429/0xbb0
[Fri Mar  8 04:38:21 2019]  ? prepare_to_wait_event+0x97/0x190
[Fri Mar  8 04:38:21 2019]  schedule+0x39/0x90
[Fri Mar  8 04:38:21 2019]  wait_current_trans+0xa3/0xf0
[Fri Mar  8 04:38:21 2019]  ? wait_woken+0xa0/0xa0
[Fri Mar  8 04:38:21 2019]  start_transaction+0x29b/0x4d0
[Fri Mar  8 04:38:21 2019]  btrfs_create+0x47/0x1d0
[Fri Mar  8 04:38:21 2019]  lookup_open+0x404/0x760
[Fri Mar  8 04:38:21 2019]  ? __wake_up_common_lock+0x53/0x90
[Fri Mar  8 04:38:21 2019]  path_openat+0x4e9/0xcc0
[Fri Mar  8 04:38:21 2019]  ? filemap_map_pages+0x312/0x520
[Fri Mar  8 04:38:21 2019]  do_filp_open+0x8a/0xf0
[Fri Mar  8 04:38:21 2019]  ? __alloc_fd+0xee/0x200
[Fri Mar  8 04:38:21 2019]  ? do_sys_open+0x130/0x200
[Fri Mar  8 04:38:21 2019]  do_sys_open+0x130/0x200
[Fri Mar  8 04:38:21 2019]  do_syscall_64+0x76/0x180
[Fri Mar  8 04:38:21 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Fri Mar  8 04:38:21 2019] RIP: 0033:0x7f084cebb4b0
[Fri Mar  8 04:38:21 2019] RSP: 002b:00007ffea5c6f238 EFLAGS: 00000246 ORIG=
_RAX: 0000000000000002
[Fri Mar  8 04:38:21 2019] RAX: ffffffffffffffda RBX: 0000000000000000 RCX:=
 00007f084cebb4b0
[Fri Mar  8 04:38:21 2019] RDX: 0000000000000180 RSI: 00000000000000c2 RDI:=
 00007ffea5c714a0
[Fri Mar  8 04:38:21 2019] RBP: 000000000003a2f8 R08: 000000000000f000 R09:=
 00007f084cf0e300
[Fri Mar  8 04:38:21 2019] R10: 0000000000000000 R11: 0000000000000246 R12:=
 00007ffea5c714e6
[Fri Mar  8 04:38:21 2019] R13: 8421084210842109 R14: 00000000000000c2 R15:=
 00007f084cf49320
[Fri Mar  8 04:38:21 2019] rsync           D    0  6002   6001 0x00000000
[Fri Mar  8 04:38:21 2019] Call Trace:
[Fri Mar  8 04:38:21 2019]  ? __schedule+0x429/0xbb0
[Fri Mar  8 04:38:21 2019]  ? prepare_to_wait_event+0x97/0x190
[Fri Mar  8 04:38:21 2019]  schedule+0x39/0x90
[Fri Mar  8 04:38:21 2019]  wait_current_trans+0xa3/0xf0
[Fri Mar  8 04:38:21 2019]  ? wait_woken+0xa0/0xa0
[Fri Mar  8 04:38:21 2019]  start_transaction+0x29b/0x4d0
[Fri Mar  8 04:38:21 2019]  btrfs_create+0x47/0x1d0
[Fri Mar  8 04:38:21 2019]  lookup_open+0x404/0x760
[Fri Mar  8 04:38:21 2019]  ? __wake_up_common_lock+0x53/0x90
[Fri Mar  8 04:38:21 2019]  path_openat+0x4e9/0xcc0
[Fri Mar  8 04:38:21 2019]  ? filemap_map_pages+0x312/0x520
[Fri Mar  8 04:38:21 2019]  do_filp_open+0x8a/0xf0
[Fri Mar  8 04:38:21 2019]  ? __alloc_fd+0xee/0x200
[Fri Mar  8 04:38:21 2019]  ? do_sys_open+0x130/0x200
[Fri Mar  8 04:38:21 2019]  do_sys_open+0x130/0x200
[Fri Mar  8 04:38:21 2019]  do_syscall_64+0x76/0x180
[Fri Mar  8 04:38:21 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Fri Mar  8 04:38:21 2019] RIP: 0033:0x7f8e8d0b34b0
[Fri Mar  8 04:38:21 2019] RSP: 002b:00007ffeaa16f288 EFLAGS: 00000246 ORIG=
_RAX: 0000000000000002
[Fri Mar  8 04:38:21 2019] RAX: ffffffffffffffda RBX: 0000000000000000 RCX:=
 00007f8e8d0b34b0
[Fri Mar  8 04:38:21 2019] RDX: 0000000000000180 RSI: 00000000000000c2 RDI:=
 00007ffeaa1714f0
[Fri Mar  8 04:38:21 2019] RBP: 000000000003a2f8 R08: 000000000000c0ff R09:=
 00007f8e8d105950
[Fri Mar  8 04:38:21 2019] R10: 0000000000000000 R11: 0000000000000246 R12:=
 00007ffeaa171507
[Fri Mar  8 04:38:21 2019] R13: 8421084210842109 R14: 00000000000000c2 R15:=
 00007f8e8d141320
[Fri Mar  8 04:38:21 2019] rsync           D    0 24698  24688 0x00000000
[Fri Mar  8 04:38:21 2019] Call Trace:
[Fri Mar  8 04:38:21 2019]  ? __schedule+0x429/0xbb0
[Fri Mar  8 04:38:21 2019]  ? prepare_to_wait_event+0x97/0x190
[Fri Mar  8 04:38:21 2019]  schedule+0x39/0x90
[Fri Mar  8 04:38:21 2019]  wait_current_trans+0xa3/0xf0
[Fri Mar  8 04:38:21 2019]  ? wait_woken+0xa0/0xa0
[Fri Mar  8 04:38:21 2019]  start_transaction+0x29b/0x4d0
[Fri Mar  8 04:38:21 2019]  btrfs_create+0x47/0x1d0
[Fri Mar  8 04:38:21 2019]  lookup_open+0x404/0x760
[Fri Mar  8 04:38:21 2019]  ? __wake_up_common_lock+0x53/0x90
[Fri Mar  8 04:38:21 2019]  path_openat+0x4e9/0xcc0
[Fri Mar  8 04:38:21 2019]  ? filemap_map_pages+0x312/0x520
[Fri Mar  8 04:38:21 2019]  do_filp_open+0x8a/0xf0
[Fri Mar  8 04:38:21 2019]  ? __alloc_fd+0xee/0x200
[Fri Mar  8 04:38:21 2019]  ? do_sys_open+0x130/0x200
[Fri Mar  8 04:38:21 2019]  do_sys_open+0x130/0x200
[Fri Mar  8 04:38:21 2019]  do_syscall_64+0x76/0x180
[Fri Mar  8 04:38:21 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Fri Mar  8 04:38:21 2019] RIP: 0033:0x7f062ff5b4b0
[Fri Mar  8 04:38:21 2019] RSP: 002b:00007ffce5979488 EFLAGS: 00000246 ORIG=
_RAX: 0000000000000002
[Fri Mar  8 04:38:21 2019] RAX: ffffffffffffffda RBX: 0000000000000000 RCX:=
 00007f062ff5b4b0
[Fri Mar  8 04:38:21 2019] RDX: 0000000000000180 RSI: 00000000000000c2 RDI:=
 00007ffce597b6f0
[Fri Mar  8 04:38:21 2019] RBP: 000000000003a2f8 R08: 000000000000c0ff R09:=
 00007f062ffad950
[Fri Mar  8 04:38:21 2019] R10: 0000000000000000 R11: 0000000000000246 R12:=
 00007ffce597b707
[Fri Mar  8 04:38:21 2019] R13: 8421084210842109 R14: 00000000000000c2 R15:=
 00007f062ffe9320
[Fri Mar  8 04:38:21 2019] rsync           D    0 10903  10902 0x00000000
[Fri Mar  8 04:38:21 2019] Call Trace:
[Fri Mar  8 04:38:21 2019]  ? __schedule+0x429/0xbb0
[Fri Mar  8 04:38:21 2019]  ? prepare_to_wait_event+0x97/0x190
[Fri Mar  8 04:38:21 2019]  schedule+0x39/0x90
[Fri Mar  8 04:38:21 2019]  wait_current_trans+0xa3/0xf0
[Fri Mar  8 04:38:21 2019]  ? wait_woken+0xa0/0xa0
[Fri Mar  8 04:38:21 2019]  start_transaction+0x29b/0x4d0
[Fri Mar  8 04:38:21 2019]  btrfs_create+0x47/0x1d0
[Fri Mar  8 04:38:21 2019]  lookup_open+0x404/0x760
[Fri Mar  8 04:38:21 2019]  ? __wake_up_common_lock+0x53/0x90
[Fri Mar  8 04:38:21 2019]  path_openat+0x4e9/0xcc0
[Fri Mar  8 04:38:21 2019]  ? filemap_map_pages+0x312/0x520
[Fri Mar  8 04:38:21 2019]  do_filp_open+0x8a/0xf0
[Fri Mar  8 04:38:21 2019]  ? __alloc_fd+0xee/0x200
[Fri Mar  8 04:38:21 2019]  ? do_sys_open+0x130/0x200
[Fri Mar  8 04:38:21 2019]  do_sys_open+0x130/0x200
[Fri Mar  8 04:38:21 2019]  do_syscall_64+0x76/0x180
[Fri Mar  8 04:38:21 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Fri Mar  8 04:38:21 2019] RIP: 0033:0x7fe4adc8b4b0
[Fri Mar  8 04:38:21 2019] RSP: 002b:00007fff53e747a8 EFLAGS: 00000246 ORIG=
_RAX: 0000000000000002
[Fri Mar  8 04:38:21 2019] RAX: ffffffffffffffda RBX: 0000000000000000 RCX:=
 00007fe4adc8b4b0
[Fri Mar  8 04:38:21 2019] RDX: 0000000000000180 RSI: 00000000000000c2 RDI:=
 00007fff53e76a10
[Fri Mar  8 04:38:21 2019] RBP: 000000000003a2f8 R08: 000000000000c0ff R09:=
 00007fe4adcddf10
[Fri Mar  8 04:38:21 2019] R10: 0000000000000000 R11: 0000000000000246 R12:=
 00007fff53e76a23
[Fri Mar  8 04:38:21 2019] R13: 8421084210842109 R14: 00000000000000c2 R15:=
 00007fe4add19320
[Fri Mar  8 04:38:21 2019] rsync           D    0 14079  13983 0x00000000
[Fri Mar  8 04:38:21 2019] Call Trace:
[Fri Mar  8 04:38:21 2019]  ? __schedule+0x429/0xbb0
[Fri Mar  8 04:38:21 2019]  ? prepare_to_wait_event+0x97/0x190
[Fri Mar  8 04:38:21 2019]  schedule+0x39/0x90
[Fri Mar  8 04:38:21 2019]  wait_current_trans+0xa3/0xf0
[Fri Mar  8 04:38:21 2019]  ? wait_woken+0xa0/0xa0
[Fri Mar  8 04:38:21 2019]  start_transaction+0x29b/0x4d0
[Fri Mar  8 04:38:21 2019]  btrfs_create+0x47/0x1d0
[Fri Mar  8 04:38:21 2019]  lookup_open+0x404/0x760
[Fri Mar  8 04:38:21 2019]  ? __wake_up_common_lock+0x53/0x90
[Fri Mar  8 04:38:21 2019]  path_openat+0x4e9/0xcc0
[Fri Mar  8 04:38:21 2019]  ? filemap_map_pages+0x312/0x520
[Fri Mar  8 04:38:21 2019]  do_filp_open+0x8a/0xf0
[Fri Mar  8 04:38:21 2019]  ? __alloc_fd+0xee/0x200
[Fri Mar  8 04:38:21 2019]  ? do_sys_open+0x130/0x200
[Fri Mar  8 04:38:21 2019]  do_sys_open+0x130/0x200
[Fri Mar  8 04:38:21 2019]  do_syscall_64+0x76/0x180
[Fri Mar  8 04:38:21 2019]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[Fri Mar  8 04:38:21 2019] RIP: 0033:0x7f4bb133b4b0
[Fri Mar  8 04:38:21 2019] RSP: 002b:00007ffe9a1d4a48 EFLAGS: 00000246 ORIG=
_RAX: 0000000000000002
[Fri Mar  8 04:38:21 2019] RAX: ffffffffffffffda RBX: 0000000000000000 RCX:=
 00007f4bb133b4b0
[Fri Mar  8 04:38:21 2019] RDX: 0000000000000180 RSI: 00000000000000c2 RDI:=
 00007ffe9a1d6cb0
[Fri Mar  8 04:38:21 2019] RBP: 000000000003a2f8 R08: 000000000000fff8 R09:=
 00007f4bb138df10
[Fri Mar  8 04:38:21 2019] R10: 0000000000000000 R11: 0000000000000246 R12:=
 00007ffe9a1d6ccd
[Fri Mar  8 04:38:21 2019] R13: 8421084210842109 R14: 00000000000000c2 R15:=
 00007f4bb13c9320

--GID0FwUMdk1T2AWN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCXJG3RgAKCRCB+YsaVrMb
nNnxAJ4spCwPRKFpo5XIA2YkzxpkKgWakACdGjXuKS1DE9LjyTBqL08Y9DtuD/U=
=sx+9
-----END PGP SIGNATURE-----

--GID0FwUMdk1T2AWN--
