Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:20004 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992473Ab2KAQB3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Nov 2012 12:01:29 -0400
Message-ID: <50929CD4.3080800@jan-o-sch.net>
Date: Thu, 01 Nov 2012 17:01:24 +0100
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
CC: Liu Bo <bo.li.liu@oracle.com>, Franke <ttfranke@googlemail.com>
Subject: Re: Crashes in extent_io.c after "btrfs bad mapping eb" notice
References: <20121031005736.306fd86b@googlemail.com> <50907514.3060400@oracle.com> <20121031210032.303c1c36@googlemail.com> <5091E0E4.5080804@oracle.com> <5092638C.2070505@jan-o-sch.net>
In-Reply-To: <5092638C.2070505@jan-o-sch.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, November 01, 2012 at 12:57 (+0100), Jan Schmidt wrote:
> I'm trying to reproduce the problems in the meantime.

Looks like it worked :-/ And it also looks like it can either bug or deadlock,
depending on the things going on in the kernel at the same time.

I did a parallel fsmark on a qgroup enabled volume while scrubbing it, reaching
at a page fault after four hours of iteration:

<1>[194521.851156] BUG: unable to handle kernel paging request at ffff880137c52a08
<1>[194659.159461] IP: [<ffffffff810e3642>] __lock_acquire+0x62/0x1630
<4>[194659.231741] PGD 1e0c063 PUD be586067 PMD be745067 PTE 8000000137c52160
<4>[194659.311717] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
<4>[194659.375976] Modules linked in: btrfs mpt2sas scsi_transport_sas raid_class
<4>[194659.460230] CPU 6 
<4>[194659.483318] Pid: 20466, comm: btrfs-scrub-3 Tainted: G        W    3.6.0+ #3 Supermicro X8SIL/X8SIL
<4>[194659.595327] RIP: 0010:[<ffffffff810e3642>]  [<ffffffff810e3642>] __lock_acquire+0x62/0x1630
<4>[194659.696829] RSP: 0018:ffff880138ab7c50  EFLAGS: 00010046
<4>[194659.761725] RAX: 0000000000000046 RBX: ffff880137c52a08 RCX: 0000000000000000
<4>[194659.848565] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff880137c52a08
<4>[194659.935405] RBP: ffff880138ab7d20 R08: 0000000000000002 R09: 0000000000000001
<4>[194660.022245] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8802273ba3b0
<4>[194660.108984] R13: 0000000000000002 R14: 0000000000000000 R15: 0000000000000000
<4>[194660.195717] FS:  0000000000000000(0000) GS:ffff880237200000(0000) knlGS:0000000000000000
<4>[194660.293997] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
<4>[194660.363990] CR2: ffff880137c52a08 CR3: 0000000001e0b000 CR4: 00000000000007e0
<4>[194660.450726] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
<4>[194660.537564] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
<4>[194660.624406] Process btrfs-scrub-3 (pid: 20466, threadinfo ffff880138ab6000, task ffff8802273ba3b0)
<4>[194660.733189] Stack:
<4>[194660.758357]  0000000000000286 ffff8802353a4000 ffff8802273ba3b0 ffffffff00000000
<4>[194660.848733]  ffff880138ab7c90 0000000000000286 ffff880138ab7d20 ffff8802353a4000
<4>[194660.939212]  ffff8802273baa78 ffffffff8245f100 ffff880138ab7cc0 0000000000000286
<4>[194661.029589] Call Trace:
<4>[194661.059969]  [<ffffffff8109811a>] ? del_timer_sync+0x8a/0xc0
<4>[194661.128964]  [<ffffffff81098090>] ? try_to_del_timer_sync+0x70/0x70
<4>[194661.205367]  [<ffffffffa00a306a>] ? worker_loop+0x35a/0x5b0 [btrfs]
<4>[194661.281688]  [<ffffffff810e4ca5>] lock_acquire+0x95/0x140
<4>[194661.347634]  [<ffffffffa00a306a>] ? worker_loop+0x35a/0x5b0 [btrfs]
<4>[194661.423964]  [<ffffffff819380c0>] _raw_spin_lock+0x40/0x80
<4>[194661.490953]  [<ffffffffa00a306a>] ? worker_loop+0x35a/0x5b0 [btrfs]
<4>[194661.567283]  [<ffffffffa00a306a>] worker_loop+0x35a/0x5b0 [btrfs]
<4>[194661.641539]  [<ffffffffa00a2d10>] ? btrfs_queue_worker+0x300/0x300 [btrfs]
<4>[194661.725249]  [<ffffffff810ac3d6>] kthread+0xa6/0xb0
<4>[194661.784961]  [<ffffffff819409a4>] kernel_thread_helper+0x4/0x10
<4>[194661.857120]  [<ffffffff8193901d>] ? retint_restore_args+0xe/0xe
<4>[194661.929294]  [<ffffffff810ac330>] ? __init_kthread_worker+0x70/0x70
<4>[194662.005632]  [<ffffffff819409a0>] ? gs_change+0xb/0xb
<4>[194662.067405] Code: 48 89 5d d8 4c 89 7d f8 45 0f 45 e8 85 c0 48 89 fb 4c 8b 55 10 0f 84 4e 04 00 00 44 8b 3d 2b be 0c 01 45 85 ff 0f 84 56 04 00 00 <48> 81 3b e0 5a 1f 82 b8 01 00 00 00 44 0f 44 e8 83 fe 01 0f 86 
<1>[194662.302652] RIP  [<ffffffff810e3642>] __lock_acquire+0x62/0x1630
<4>[194662.375973]  RSP <ffff880138ab7c50>
<4>[194662.418821] CR2: ffff880137c52a08
<4>[194662.460051] ---[ end trace 85e160ea023efd39 ]---

debug config enabled:
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_SLUB_DEBUG=y
CONFIG_DEBUG_FS=y
CONFIG_DEBUG_KERNEL=y
CONFIG_LOCKDEP=y

-Jan
