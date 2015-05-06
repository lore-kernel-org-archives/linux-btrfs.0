Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.lqfe.com ([72.14.186.34]:44078 "EHLO mail.lqfe.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbbEFV4Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 May 2015 17:56:25 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.lqfe.com (Postfix) with ESMTP id A0372160A79
	for <linux-btrfs@vger.kernel.org>; Wed,  6 May 2015 16:56:23 -0500 (CDT)
Received: from mail.lqfe.com ([127.0.0.1])
	by localhost (mail.lqfe.com [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id E2gmV6KXjlKR for <linux-btrfs@vger.kernel.org>;
	Wed,  6 May 2015 16:56:22 -0500 (CDT)
Received: from localhost (localhost [127.0.0.1])
	by mail.lqfe.com (Postfix) with ESMTP id CD33A16262B
	for <linux-btrfs@vger.kernel.org>; Wed,  6 May 2015 16:56:22 -0500 (CDT)
Received: from mail.lqfe.com ([127.0.0.1])
	by localhost (mail.lqfe.com [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id aeYGghzlKvXO for <linux-btrfs@vger.kernel.org>;
	Wed,  6 May 2015 16:56:22 -0500 (CDT)
Received: from [192.168.168.20] (unknown [206.126.223.13])
	by mail.lqfe.com (Postfix) with ESMTPSA id 76512160A79
	for <linux-btrfs@vger.kernel.org>; Wed,  6 May 2015 16:56:22 -0500 (CDT)
From: Anthony Plack <anthony@plack.net>
Content-Type: text/plain; charset=utf-8
Subject: Kernel Dump scanning directory
Message-Id: <C42E48E9-4DA9-442D-8FAC-B1982EA5DF4B@plack.net>
Date: Wed, 6 May 2015 16:56:21 -0500
To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey guys, I have some dump data from BTRFS.  This occurred when running rsync -nav to my backup server.  Data is all there (as far as I can tell about 9TB of data).  If I unmount the drive, and remount it, it will be writable (echo ‘b’ > b) for days, but I start the rsync and very quickly it will dump and switch to read-only.  Scrub finished successful (mount was still RW after completion) yesterday.  Let me know what else I can get you.

May  6 11:17:47 fatdrive kernel: verify_parent_transid: 19 callbacks suppressed
May  6 11:17:47 fatdrive kernel: BTRFS (device sdm): parent transid verify failed on 94051291136 wanted 150686 found 150687
May  6 11:17:47 fatdrive kernel: BTRFS (device sdm): parent transid verify failed on 94051291136 wanted 150686 found 150687
May  6 11:17:47 fatdrive kernel: ------------[ cut here ]------------
May  6 11:17:47 fatdrive kernel: WARNING: CPU: 0 PID: 9426 at fs/btrfs/super.c:260 __btrfs_abort_transaction+0x5a/0x130()
May  6 11:17:47 fatdrive kernel: BTRFS: Transaction aborted (error -5)
May  6 11:17:47 fatdrive kernel: Modules linked in: nfsd exportfs kvm_amd r8168(O) kvm k10temp ata_generic acpi_cpufreq
May  6 11:17:47 fatdrive kernel: CPU: 0 PID: 9426 Comm: kworker/u12:4 Tainted: G        W  O    4.0.0-gentoo #1
May  6 11:17:47 fatdrive kernel: Hardware name: BIOSTAR Group TA880G HD/TA880G HD, BIOS 080015  11/11/2011
May  6 11:17:47 fatdrive kernel: Workqueue: btrfs-extent-refs btrfs_extent_refs_helper
May  6 11:17:47 fatdrive kernel:  ffffffff81a9729e ffff8801704abc38 ffffffff817e6414 0000000000000000
May  6 11:17:47 fatdrive kernel:  ffff8801704abc88 ffff8801704abc78 ffffffff81049e60 0000000000000000
May  6 11:17:47 fatdrive kernel:  ffff8802142b22c0 ffff88020ce81800 00000000fffffffb ffffffff81869b50
May  6 11:17:47 fatdrive kernel: Call Trace:
May  6 11:17:47 fatdrive kernel:  [<ffffffff817e6414>] dump_stack+0x45/0x57
May  6 11:17:47 fatdrive kernel:  [<ffffffff81049e60>] warn_slowpath_common+0x90/0xd0
May  6 11:17:47 fatdrive kernel:  [<ffffffff81049ee1>] warn_slowpath_fmt+0x41/0x50
May  6 11:17:47 fatdrive kernel:  [<ffffffff812d9e7a>] __btrfs_abort_transaction+0x5a/0x130
May  6 11:17:47 fatdrive kernel:  [<ffffffff812f6fa1>] btrfs_run_delayed_refs.part.65+0x121/0x270
May  6 11:17:47 fatdrive kernel:  [<ffffffff812f7190>] delayed_ref_async_start+0x80/0xa0
May  6 11:17:47 fatdrive kernel:  [<ffffffff81336e07>] normal_work_helper+0xb7/0x2b0
May  6 11:17:47 fatdrive kernel:  [<ffffffff8133711d>] btrfs_extent_refs_helper+0xd/0x10
May  6 11:17:47 fatdrive kernel:  [<ffffffff810606c7>] process_one_work+0x147/0x3f0
May  6 11:17:47 fatdrive kernel:  [<ffffffff81060a88>] worker_thread+0x118/0x440
May  6 11:17:47 fatdrive kernel:  [<ffffffff81060970>] ? process_one_work+0x3f0/0x3f0
May  6 11:17:47 fatdrive kernel:  [<ffffffff81065624>] kthread+0xc4/0xe0
May  6 11:17:47 fatdrive kernel:  [<ffffffff81065560>] ? kthread_create_on_node+0x190/0x190
May  6 11:17:47 fatdrive kernel:  [<ffffffff817ee488>] ret_from_fork+0x58/0x90
May  6 11:17:47 fatdrive kernel:  [<ffffffff81065560>] ? kthread_create_on_node+0x190/0x190
May  6 11:17:47 fatdrive kernel: ---[ end trace f948e8ffd1f550c0 ]---
May  6 11:17:47 fatdrive kernel: BTRFS warning (device sdm): btrfs_run_delayed_refs:2790: Aborting unused transaction(IO failure).
May  6 11:17:47 fatdrive kernel: BTRFS (device sdm): parent transid verify failed on 94051291136 wanted 150686 found 150687
May  6 11:17:47 fatdrive kernel: BTRFS (device sdm): parent transid verify failed on 94051291136 wanted 150686 found 150687
May  6 11:17:47 fatdrive kernel: BTRFS warning (device sdm): btrfs_run_delayed_refs:2790: Aborting unused transaction(IO failure).
May  6 11:17:47 fatdrive kernel: BTRFS (device sdm): parent transid verify failed on 94051291136 wanted 150686 found 150687
May  6 11:17:47 fatdrive kernel: BTRFS (device sdm): parent transid verify failed on 94051291136 wanted 150686 found 150687
May  6 11:17:47 fatdrive kernel: BTRFS warning (device sdm): btrfs_run_delayed_refs:2790: Aborting unused transaction(IO failure).
May  6 11:17:47 fatdrive kernel: BTRFS (device sdm): parent transid verify failed on 94051291136 wanted 150686 found 150687
May  6 11:17:47 fatdrive kernel: BTRFS (device sdm): parent transid verify failed on 94051291136 wanted 150686 found 150687
May  6 11:17:47 fatdrive kernel: BTRFS warning (device sdm): btrfs_run_delayed_refs:2790: Aborting unused transaction(IO failure).
May  6 11:17:47 fatdrive kernel: BTRFS (device sdm): parent transid verify failed on 94051291136 wanted 150686 found 150687
May  6 11:17:47 fatdrive kernel: BTRFS (device sdm): parent transid verify failed on 94051291136 wanted 150686 found 150687
May  6 11:17:47 fatdrive kernel: BTRFS warning (device sdm): btrfs_run_delayed_refs:2790: Aborting unused transaction(IO failure).
May  6 11:17:47 fatdrive kernel: BTRFS warning (device sdm): btrfs_run_delayed_refs:2790: Aborting unused transaction(IO failure).
May  6 11:17:47 fatdrive kernel: BTRFS warning (device sdm): btrfs_run_delayed_refs:2790: Aborting unused transaction(IO failure).
May  6 11:17:47 fatdrive kernel: BTRFS warning (device sdm): btrfs_run_delayed_refs:2790: Aborting unused transaction(IO failure).
May  6 11:17:47 fatdrive kernel: BTRFS warning (device sdm): btrfs_run_delayed_refs:2790: Aborting unused transaction(IO failure).
May  6 11:17:47 fatdrive kernel: BTRFS warning (device sdm): btrfs_run_delayed_refs:2790: Aborting unused transaction(IO failure).
May  6 11:17:47 fatdrive kernel: BTRFS warning (device sdm): btrfs_run_delayed_refs:2790: Aborting unused transaction(IO failure).
May  6 11:17:47 fatdrive kernel: BTRFS warning (device sdm): btrfs_run_delayed_refs:2790: Aborting unused transaction(IO failure).
May  6 11:17:47 fatdrive kernel: BTRFS warning (device sdm): btrfs_run_delayed_refs:2790: Aborting unused transaction(IO failure).
May  6 11:17:47 fatdrive kernel: BTRFS warning (device sdm): btrfs_run_delayed_refs:2790: Aborting unused transaction(IO failure).
May  6 11:17:47 fatdrive kernel: BTRFS warning (device sdm): btrfs_run_delayed_refs:2790: Aborting unused transaction(IO failure).
May  6 11:17:47 fatdrive kernel: BTRFS warning (device sdm): btrfs_run_delayed_refs:2790: Aborting unused transaction(IO failure).
May  6 11:17:47 fatdrive kernel: ------------[ cut here ]------------
May  6 11:17:47 fatdrive kernel: WARNING: CPU: 1 PID: 9414 at fs/btrfs/delayed-ref.c:438 btrfs_select_ref_head+0x124/0x140()
May  6 11:17:47 fatdrive kernel: Modules linked in: nfsd exportfs kvm_amd r8168(O) kvm k10temp ata_generic acpi_cpufreq
May  6 11:17:47 fatdrive kernel: CPU: 1 PID: 9414 Comm: kworker/u12:0 Tainted: G        W  O    4.0.0-gentoo #1
May  6 11:17:47 fatdrive kernel: Hardware name: BIOSTAR Group TA880G HD/TA880G HD, BIOS 080015  11/11/2011
May  6 11:17:47 fatdrive kernel: Workqueue: btrfs-extent-refs btrfs_extent_refs_helper
May  6 11:17:47 fatdrive kernel:  ffffffff81a98a02 ffff88006476bb58 ffffffff817e6414 0000000000000000
May  6 11:17:47 fatdrive kernel:  0000000000000000 ffff88006476bb98 ffffffff81049e60 ffff88006476bbd8
May  6 11:17:47 fatdrive kernel:  ffff880214300320 ffff880178aec120 0000000000000000 ffff880178aec208
May  6 11:17:47 fatdrive kernel: Call Trace:
May  6 11:17:47 fatdrive kernel:  [<ffffffff817e6414>] dump_stack+0x45/0x57
May  6 11:17:47 fatdrive kernel:  [<ffffffff81049e60>] warn_slowpath_common+0x90/0xd0
May  6 11:17:47 fatdrive kernel:  [<ffffffff81049f45>] warn_slowpath_null+0x15/0x20
May  6 11:17:47 fatdrive kernel:  [<ffffffff81351f04>] btrfs_select_ref_head+0x124/0x140
May  6 11:17:47 fatdrive kernel:  [<ffffffff812f1f15>] __btrfs_run_delayed_refs+0x1f5/0x11f0
May  6 11:17:47 fatdrive kernel:  [<ffffffff8106e6cd>] ? check_preempt_curr+0x8d/0xa0
May  6 11:17:47 fatdrive kernel:  [<ffffffff8106e6f8>] ? ttwu_do_wakeup+0x18/0xd0
May  6 11:17:47 fatdrive kernel:  [<ffffffff812f6eea>] btrfs_run_delayed_refs.part.65+0x6a/0x270
May  6 11:17:47 fatdrive kernel:  [<ffffffff812f7190>] delayed_ref_async_start+0x80/0xa0
May  6 11:17:47 fatdrive kernel:  [<ffffffff81336e07>] normal_work_helper+0xb7/0x2b0
May  6 11:17:47 fatdrive kernel:  [<ffffffff8133711d>] btrfs_extent_refs_helper+0xd/0x10
May  6 11:17:47 fatdrive kernel:  [<ffffffff810606c7>] process_one_work+0x147/0x3f0
May  6 11:17:47 fatdrive kernel:  [<ffffffff81060a88>] worker_thread+0x118/0x440
May  6 11:17:47 fatdrive kernel:  [<ffffffff81060970>] ? process_one_work+0x3f0/0x3f0
May  6 11:17:47 fatdrive kernel:  [<ffffffff81065624>] kthread+0xc4/0xe0
May  6 11:17:47 fatdrive kernel:  [<ffffffff81065560>] ? kthread_create_on_node+0x190/0x190
May  6 11:17:47 fatdrive kernel:  [<ffffffff817ee488>] ret_from_fork+0x58/0x90
May  6 11:17:47 fatdrive kernel:  [<ffffffff81065560>] ? kthread_create_on_node+0x190/0x190
May  6 11:17:47 fatdrive kernel: ---[ end trace f948e8ffd1f550c1 ]---
May  6 11:17:47 fatdrive kernel: BTRFS: error (device sdm) in btrfs_run_delayed_refs:2790: errno=-5 IO failure
May  6 11:17:47 fatdrive kernel: BTRFS info (device sdm): forced readonly
May  6 11:17:47 fatdrive kernel: BTRFS: error (device sdm) in btrfs_run_delayed_refs:2790: errno=-5 IO failure
May  6 11:17:47 fatdrive kernel: BTRFS: error (device sdm) in btrfs_run_delayed_refs:2790: errno=-5 IO failure
May  6 11:18:16 fatdrive kernel: verify_parent_transid: 28 callbacks suppressed
May  6 11:18:16 fatdrive kernel: BTRFS (device sdm): parent transid verify failed on 7645497978880 wanted 148829 found 147711


fatdrive data # uname -a && btrfs filesystem show /mnt/data
Linux fatdrive 4.0.0-gentoo #1 SMP Sat Apr 25 22:56:50 CDT 2015 x86_64 AMD Athlon(tm) II X2 240 Processor AuthenticAMD GNU/Linux
Label: 'data'  uuid: f591ac13-1a69-476d-bd30-346f87a491da
	Total devices 11 FS bytes used 9.85TiB
	devid    1 size 1.82TiB used 1.82TiB path /dev/sdm
	devid    2 size 1.82TiB used 1.82TiB path /dev/sdh
	devid    3 size 1.82TiB used 1.82TiB path /dev/sdg
	devid    4 size 1.82TiB used 1.81TiB path /dev/sdf
	devid    5 size 1.82TiB used 1.81TiB path /dev/sdc
	devid    6 size 1.82TiB used 1.82TiB path /dev/sdb
	devid    7 size 1.82TiB used 1.82TiB path /dev/sdk
	devid    8 size 1.82TiB used 1.82TiB path /dev/sdd
	devid    9 size 2.73TiB used 2.63TiB path /dev/sde
	devid   10 size 1.82TiB used 1.82TiB path /dev/sdl
	devid   11 size 1.82TiB used 836.00GiB path /dev/sda

btrfs-progs v3.19.1

fatdrive data # btrfs device stat /mnt/data
[/dev/sdm].write_io_errs   0
[/dev/sdm].read_io_errs    0
[/dev/sdm].flush_io_errs   0
[/dev/sdm].corruption_errs 0
[/dev/sdm].generation_errs 0
[/dev/sdh].write_io_errs   0
[/dev/sdh].read_io_errs    0
[/dev/sdh].flush_io_errs   0
[/dev/sdh].corruption_errs 0
[/dev/sdh].generation_errs 0
[/dev/sdg].write_io_errs   0
[/dev/sdg].read_io_errs    0
[/dev/sdg].flush_io_errs   0
[/dev/sdg].corruption_errs 0
[/dev/sdg].generation_errs 0
[/dev/sdf].write_io_errs   0
[/dev/sdf].read_io_errs    0
[/dev/sdf].flush_io_errs   0
[/dev/sdf].corruption_errs 0
[/dev/sdf].generation_errs 0
[/dev/sdc].write_io_errs   0
[/dev/sdc].read_io_errs    0
[/dev/sdc].flush_io_errs   0
[/dev/sdc].corruption_errs 0
[/dev/sdc].generation_errs 3
[/dev/sdb].write_io_errs   0
[/dev/sdb].read_io_errs    0
[/dev/sdb].flush_io_errs   0
[/dev/sdb].corruption_errs 0
[/dev/sdb].generation_errs 0
[/dev/sdk].write_io_errs   0
[/dev/sdk].read_io_errs    0
[/dev/sdk].flush_io_errs   0
[/dev/sdk].corruption_errs 0
[/dev/sdk].generation_errs 3
[/dev/sdd].write_io_errs   0
[/dev/sdd].read_io_errs    0
[/dev/sdd].flush_io_errs   0
[/dev/sdd].corruption_errs 0
[/dev/sdd].generation_errs 0
[/dev/sde].write_io_errs   0
[/dev/sde].read_io_errs    0
[/dev/sde].flush_io_errs   0
[/dev/sde].corruption_errs 0
[/dev/sde].generation_errs 0
[/dev/sdl].write_io_errs   0
[/dev/sdl].read_io_errs    0
[/dev/sdl].flush_io_errs   0
[/dev/sdl].corruption_errs 0
[/dev/sdl].generation_errs 0
[/dev/sda].write_io_errs   0
[/dev/sda].read_io_errs    0
[/dev/sda].flush_io_errs   0
[/dev/sda].corruption_errs 0
[/dev/sda].generation_errs 0

fatdrive data # btrfs scrub stat /mnt/data
scrub status for f591ac13-1a69-476d-bd30-346f87a491da
	scrub started at Mon May  4 13:21:02 2015 and was aborted after 25599 seconds
	total bytes scrubbed: 13.12TiB with 6 errors
	error details: verify=6
	corrected errors: 0, uncorrectable errors: 6, unverified errors: 0



