Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:51891 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab3FQTKb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Jun 2013 15:10:31 -0400
Received: by mail-ee0-f51.google.com with SMTP id e52so2039297eek.24
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Jun 2013 12:10:29 -0700 (PDT)
Received: from [10.255.254.3] (p5DDD9939.dip0.t-ipconnect.de. [93.221.153.57])
        by mx.google.com with ESMTPSA id a4sm25441942eez.0.2013.06.17.12.10.28
        for <linux-btrfs@vger.kernel.org>
        (version=SSLv3 cipher=RC4-SHA bits=128/128);
        Mon, 17 Jun 2013 12:10:28 -0700 (PDT)
Message-ID: <1371496227.3925.44.camel@ivbl>
Subject: BUG at fs/btrfs/print-tree when trying to mount after a crash
From: Michael Zugelder <michael@zugelder.org>
To: linux-btrfs@vger.kernel.org
Date: Mon, 17 Jun 2013 21:10:27 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

my laptop with a btrfs on dm-crypt on SSD freezed today shortly after
resuming from suspend (it doesn't normally do that). I was running a
self compiled 3.9.6 at this point. There should be around 20 of 114 GiB
free on the file system and it was probably created with 16K leaf size.

After rebooting, mounting the rootfs didn't work anymore. I made a copy
of the disk and am now trying to fix it using my desktop. Trying to
mount it with -o recovery on 3.10-rc6 triggers the following bug:

> [  170.817246] BTRFS info (device dm-5): leaf 24297472 total ptrs 160 free space 3478
> [  170.817250]  item 0 key (19642265600 a8 53248) itemoff 16230 itemsize 53
> [  170.817251]          extent refs 18177 gen 189975 flags 34305
> [  170.817253]          extent data backref root 295 objectid 1647618 offset 1573046 count 162
> [  170.817254]  item 1 key (19642318848 a8 49152) itemoff 16177 itemsize 53
> [  170.817255]          extent refs 1 gen 150295 flags 1
> [  170.817257]          extent data backref root 259 objectid 1647675 offset 148434071453696 count 1
> [  170.817258]  item 2 key (19642368000 a8 53248) itemoff 16124 itemsize 53
> [  170.817259]          extent refs 1358954497 gen 335694615 flags 1124073473
> [  170.817260]          extent data backref root 1835267 objectid 1647675 offset 1835008 count 1
> [  170.817261]  item 3 key (19642421248 a8 45056) itemoff 16071 itemsize 53
> [  170.817262]          extent refs 1 gen 150295 flags 1
> [  170.817269] ------------[ cut here ]------------
> [  170.817292] kernel BUG at fs/btrfs/print-tree.c:136!
> [  170.817304] invalid opcode: 0000 [#1] PREEMPT SMP 
> [  170.817317] Modules linked in: mxm_wmi wmi i915 cfbfillrect cfbimgblt cfbcopyarea intel_agp intel_gtt drm_kms_helper
> [  170.817347] CPU: 1 PID: 3706 Comm: mount Tainted: G        W    3.10.0-rc6 #13
> [  170.817364] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./Z77 Extreme4, BIOS P2.80 01/17/2013
> [  170.817384] task: ffff88041980b9f0 ti: ffff8803d0dc4000 task.ti: ffff8803d0dc4000
> [  170.817400] RIP: 0010:[<ffffffff812e3156>]  [<ffffffff812e3156>] btrfs_print_leaf+0x806/0x910
> [  170.817421] RSP: 0018:ffff8803d0dc5768  EFLAGS: 00010a87
> [  170.817433] RAX: 6900000000000103 RBX: 00000000000000a0 RCX: 000000000000005a
> [  170.817448] RDX: 0000000000003000 RSI: 0000000000003f45 RDI: ffff8803ca8c03f0
> [  170.817463] RBP: ffff8803d0dc57d8 R08: 0000000000004000 R09: ffff8803d0dc5710
> [  170.817478] R10: 0000000000000000 R11: 0000000000000003 R12: 0000000000000003
> [  170.817493] R13: 0000000000003f44 R14: 000000000000005a R15: ffff8803ca8c03f0
> [  170.817508] FS:  00007fcb17a61840(0000) GS:ffff88042f240000(0000) knlGS:0000000000000000
> [  170.817526] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  170.817538] CR2: 0000000002a42d00 CR3: 00000003d0cf6000 CR4: 00000000001407e0
> [  170.817553] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  170.817568] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  170.817583] Stack:
> [  170.817588]  ffff880400000035 0000000000000035 000000000000b05a 0000000000000001
> [  170.817606]  00000035174c0d88 0000000000003f61 0000000000000020 a80000000492c790
> [  170.817623]  000000000000b000 ffff8804174c0d80 0000000492cb8000 0000000000000000
> [  170.817641] Call Trace:
> [  170.817649]  [<ffffffff812d9973>] __btrfs_free_extent+0x613/0xa20
> [  170.817663]  [<ffffffff8133501c>] ? btrfs_merge_delayed_refs+0x1fc/0x3c0
> [  170.817679]  [<ffffffff812dd25c>] run_clustered_refs+0x37c/0xd60
> [  170.817694]  [<ffffffff812e13e0>] btrfs_run_delayed_refs+0xd0/0x540
> [  170.817709]  [<ffffffff812ce157>] ? comp_keys+0x27/0x30
> [  170.817722]  [<ffffffff812f12c2>] btrfs_commit_transaction+0x82/0xac0
> [  170.817736]  [<ffffffff812d0f94>] ? btrfs_search_slot+0x504/0x920
> [  170.817750]  [<ffffffff812cbb42>] ? btrfs_release_path+0x22/0xb0
> [  170.817764]  [<ffffffff810adce0>] ? finish_wait+0x80/0x80
> [  170.817777]  [<ffffffff8132c543>] btrfs_recover_log_trees+0x3b3/0x480
> [  170.817791]  [<ffffffff81329a50>] ? add_inode_ref+0xa10/0xa10
> [  170.817804]  [<ffffffff812ee8b9>] open_ctree+0x1839/0x1f60
> [  170.817819]  [<ffffffff8170ee85>] ? ras_help+0x535/0xcd0
> [  170.817831]  [<ffffffff812c8483>] btrfs_mount+0x673/0x8f0
> [  170.817844]  [<ffffffff8111a0e6>] ? pcpu_next_pop+0x46/0x60
> [  170.817858]  [<ffffffff81152f2e>] mount_fs+0x3e/0x1b0
> [  170.817870]  [<ffffffff8116bdbf>] vfs_kern_mount+0x6f/0x110
> [  170.817883]  [<ffffffff8116e2b9>] do_mount+0x259/0xa20
> [  170.817897]  [<ffffffff8110a2b2>] ? __get_free_pages+0x12/0x50
> [  170.817911]  [<ffffffff8116dee1>] ? copy_mount_options+0x31/0x170
> [  170.817925]  [<ffffffff8116eb09>] SyS_mount+0x89/0xd0
> [  170.817938]  [<ffffffff817f0ad6>] system_call_fastpath+0x1a/0x1f
> [  170.817951] Code: ba 01 00 00 00 4c 89 ee 4c 89 ff 44 0f b6 f0 88 45 a0 e8 fe f7 ff ff 0f b6 4d a0 80 f9 b2 0f 84 d4 00 00 00 77 7a 80 f9 b0 74 33 <0f> 0b 44 89 e6 4c 89 ff e8 2c 59 50 00 4c 89 ff 89 c6 48 83 c6 
> [  170.818021] RIP  [<ffffffff812e3156>] btrfs_print_leaf+0x806/0x910
> [  170.818036]  RSP <ffff8803d0dc5768>
> [  170.822960] ---[ end trace 224779f5de794488 ]---
> [  170.822962] note: mount[3706] exited with preempt_count 2

I presume the "btrfs_recover_log_trees" line is a good sign for my data?
I have daily backups of 99% of the data, but would have to reinstall
some distro.

Btrfsck from git master (650e656a) spits out the following, before crashing:

> corrupt extent record: key 19642421248 168 45056
> corrupt extent record: key 19642904576 168 40960
> corrupt extent record: key 19643248640 168 49152
> corrupt extent record: key 19644252160 168 49152
> corrupt extent record: key 19644645376 168 40960
> corrupt extent record: key 19645878272 168 4096
> corrupt extent record: key 19646754816 168 524288
> ref mismatch on [19642265600 53248] extent item 18177, found 1
> Backref 19642265600 root 259 owner 1647675 offset 1572864 num_refs 0 not found in extent tree
> Incorrect local backref count on 19642265600 root 259 owner 1647675 offset 1572864 found 1 wanted 0 back 0x7c4b250
> Incorrect local backref count on 19642265600 root 295 owner 1647618 offset 1573046 found 0 wanted 162 back 0x3846100
> backpointer mismatch on [19642265600 53248]
[ ... snip, many similar errors ... ]
> Errors found in extent allocation tree
> checking free space cache
> btrfs: unable to add free space :-17
> btrfsck: free-space-cache.c:813: btrfs_add_free_space: Assertion `!(ret == -17)' failed.

I also took a picture when I first saw the problems directly after the
reboot and it showed an additional BUG. It is reproducible with the self
compiled kernel, but not with the Fedora 18 3.9.5 kernel. Maybe because
Fedora doesn't compile with CONFIG_PREEMPT?

> BUG: scheduling while atomic: mount/354/0x10000003
> Modules linked in: nouveau ttm mxm_wmi wmi
> Pid: 354, comm: mount Tainted: G      D W    3.9.6 #11
> Call Trace:
>  __schedule_bug
>  __schedule
>  __cond_resched
>  _cond_resched
>  unmap_single_vma
>  unmap_vmas
>  exit_mmap
>  ? lock_hrtimer_base.isra.31
>  ? _raw_spin_unlock_irqrestore
>  ? _raw_spin_unlock_irq
>  mmput
>  do_exit
>  ? kmsg_dump
>  oops_end
>  die
>  do_trap
>  ? atomic_notifier_call_chain
>  do_invalid_op
>  btrfs_print_leaf
[...]


Any suggestions? Never had a problem before running btrfs on that
machine and SSD for about 2 years now.


Thanks
Michael

