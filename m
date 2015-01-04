Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pl1.haspere.com ([209.177.156.123]:54560 "EHLO pl1.haspere.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586AbbADOuF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 4 Jan 2015 09:50:05 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Sun, 04 Jan 2015 08:50:04 -0600
From: Dyweni - BTRFS <Y4BwxfPC4k5h@dyweni.com>
To: linux-btrfs@vger.kernel.org
Subject: BTRFS: Transaction aborted (error -5)
Reply-To: Y4BwxfPC4k5h@dyweni.com
Message-ID: <4ac53d9eeb92abf031b2b68c1b130215@pl1.haspere.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi All,

Just wondering of a few things:

1. Has anyone seen a problem like this before (see below)?  This occurs 
when mounting the file system.  It mounts, but goes straight to 
read-only mode.
2. I've scanned the device (/dev/sdd) using 'badblocks -s v', which 
reports no bad blocks found.
3. What can be done to recover from this?  (I'm planning to upgrade to 
3.18 before trying recovery/repairs)

Thanks,
Dyweni



[32079.815291] BTRFS info (device sdd1): disk space caching is enabled
[32082.419524] BTRFS: sdd1 checksum verify failed on 588447744 wanted 
F90C810B found 6E0D3115 level 0
[32114.418433] BTRFS: sdd1 checksum verify failed on 588447744 wanted 
F90C810B found 6E0D3115 level 0
[32125.951446] BTRFS: sdd1 checksum verify failed on 588447744 wanted 
F90C810B found 6E0D3115 level 0
[32125.959497] BTRFS: sdd1 checksum verify failed on 588447744 wanted 
F90C810B found 24492BB3 level 0
[32125.959505] ------------[ cut here ]------------
[32125.959517] WARNING: CPU: 0 PID: 2601 at fs/btrfs/super.c:259 
__btrfs_abort_transaction+0x43/0x110()
[32125.959518] BTRFS: Transaction aborted (error -5)
[32125.959519] Modules linked in: iscsi_trgt(O)
[32125.959527] CPU: 0 PID: 2601 Comm: btrfs-cleaner Tainted: G           
O  3.16.5-gentoo-20150103-0758 #1
[32125.959528] Hardware name:    /MS-6570, BIOS 6.00 PG 11/07/2003
[32125.959530]  ec009e68 ec009e68 ec009e28 c14d581f ec009e58 c10333d0 
c15bcea0 ec009e84
[32125.959533]  00000a29 c15c9417 00000103 c11c8723 c11c8723 fffffffb 
f1c5d400 c14fd856
[32125.959537]  ec009e70 c103341e 00000009 ec009e68 c15bcea0 ec009e84 
ec009e9c c11c8723
[32125.959541] Call Trace:
[32125.959548]  [<c14d581f>] dump_stack+0x16/0x18
[32125.959553]  [<c10333d0>] warn_slowpath_common+0x70/0x90
[32125.959556]  [<c11c8723>] ? __btrfs_abort_transaction+0x43/0x110
[32125.959559]  [<c11c8723>] ? __btrfs_abort_transaction+0x43/0x110
[32125.959562]  [<c103341e>] warn_slowpath_fmt+0x2e/0x30
[32125.959565]  [<c11c8723>] __btrfs_abort_transaction+0x43/0x110
[32125.959571]  [<c11e2cc4>] btrfs_run_delayed_refs.part.74+0xd4/0x1d0
[32125.959574]  [<c11e2dcf>] btrfs_run_delayed_refs+0xf/0x20
[32125.959578]  [<c11f1854>] btrfs_should_end_transaction+0x34/0x50
[32125.959581]  [<c11e1461>] btrfs_drop_snapshot+0x1d1/0x6a0
[32125.959585]  [<c104fbfb>] ? default_wake_function+0xb/0x10
[32125.959590]  [<c105497f>] ? __wake_up_common+0x3f/0x70
[32125.959593]  [<c11f3222>] btrfs_clean_one_deleted_snapshot+0x62/0x90
[32125.959595]  [<c11ead3e>] cleaner_kthread+0xce/0x100
[32125.959597]  [<c11eac70>] ? btrfs_destroy_pinned_extent+0x120/0x120
[32125.959603]  [<c1048cf5>] kthread+0x95/0xb0
[32125.959606]  [<c14da0c0>] ret_from_kernel_thread+0x20/0x30
[32125.959609]  [<c1048c60>] ? kthread_worker_fn+0xb0/0xb0
[32125.959611] ---[ end trace 1e2cdbbae61fcdc1 ]---
[32125.959614] BTRFS: error (device sdd1) in 
btrfs_run_delayed_refs:2806: errno=-5 IO failure
[32125.959616] BTRFS info (device sdd1): forced readonly



