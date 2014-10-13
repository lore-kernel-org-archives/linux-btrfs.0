Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25683 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbaJMCP7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Oct 2014 22:15:59 -0400
Message-ID: <543B35D3.6050509@oracle.com>
Date: Sun, 12 Oct 2014 22:15:47 -0400
From: Sasha Levin <sasha.levin@oracle.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>, jbacik@fb.com
CC: linux-btrfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: btrfs: kernel BUG at fs/btrfs/extent_io.c:676!
References: <532F89B7.3030104@oracle.com>
In-Reply-To: <532F89B7.3030104@oracle.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ping?

This BUG_ON()ing due to GFP_ATOMIC allocation failure is really silly :(

On 03/23/2014 09:26 PM, Sasha Levin wrote:
> Hi all,
> 
> While fuzzing with trinity inside KVM tools guest running latest -next kernel
> I've stumbled on the following spew.
> 
> This is a result of a failed allocation in alloc_extent_state_atomic() which
> triggers a BUG_ON when the return value is NULL. It's a bit weird that it
> BUGs on failed allocations, since it's obviously not a critical failure.
> 
> [  447.705167] kernel BUG at fs/btrfs/extent_io.c:676!
> [  447.706201] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [  447.707732] Dumping ftrace buffer:
> [  447.708473]    (ftrace buffer empty)
> [  447.709684] Modules linked in:
> [  447.710246] CPU: 17 PID: 4195 Comm: kswapd17 Tainted: G        W     3.14.0-rc7-next-20140321-sasha-00018-g0516fe6-dirty #265
> [  447.710253] task: ffff88066be9b000 ti: ffff88066be82000 task.ti: ffff88066be82000
> [  447.710253] RIP:  clear_extent_bit (fs/btrfs/extent_io.c:676)
> [  447.710253] RSP: 0000:ffff88066be83768  EFLAGS: 00010246
> [  447.710253] RAX: 0000000000000000 RBX: 0000000000d00fff RCX: 0000000000000006
> [  447.710253] RDX: 00000000000058e0 RSI: ffff88066be9bd60 RDI: 0000000000000286
> [  447.710253] RBP: ffff88066be837e8 R08: 0000000000000000 R09: 0000000000000000
> [  447.710253] R10: 0000000000000001 R11: 454a4e495f544c55 R12: 0000000001ffffff
> [  447.710253] R13: 0000000000000000 R14: ffff88007b89fd08 R15: 0000000000d00000
> [  447.710253] FS:  0000000000000000(0000) GS:ffff8804acc00000(0000) knlGS:0000000000000000
> [  447.710253] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  447.710253] CR2: 0000000002aec968 CR3: 0000000005e29000 CR4: 00000000000006a0
> [  447.710253] DR0: 0000000000698000 DR1: 0000000000698000 DR2: 0000000000000000
> [  447.710253] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
> [  447.710253] Stack:
> [  447.710253]  ffff88066be83788 ffffffff844fc4d5 0000000000000000 ffff8804ab4800e8
> [  447.710253]  0000000000000000 0000000000000001 ffff8804ab4800c8 fffffffffffffbf7
> [  447.710253]  ffff88066be837c8 0000000000000000 0000000000000006 ffffea0007aaf340
> [  447.710253] Call Trace:
> [  447.710253]  ? _raw_spin_unlock (arch/x86/include/asm/preempt.h:98 include/linux/spinlock_api_smp.h:152 kernel/locking/spinlock.c:183)
> [  447.710253]  try_release_extent_mapping (fs/btrfs/extent_io.c:3998 fs/btrfs/extent_io.c:4058)
> [  447.710253]  __btrfs_releasepage (fs/btrfs/inode.c:7521)
> [  447.710253]  btrfs_releasepage (fs/btrfs/inode.c:7534)
> [  447.710253]  try_to_release_page (mm/filemap.c:2984)
> [  447.710253]  invalidate_inode_page (mm/truncate.c:165 mm/truncate.c:215)
> [  447.710253]  invalidate_mapping_pages (mm/truncate.c:517)
> [  447.710253]  inode_lru_isolate (arch/x86/include/asm/current.h:14 include/linux/swap.h:33 fs/inode.c:724)
> [  447.710253]  ? insert_inode_locked (fs/inode.c:687)
> [  447.710253]  list_lru_walk_node (mm/list_lru.c:89)
> [  447.710253]  prune_icache_sb (fs/inode.c:759)
> [  447.710253]  super_cache_scan (fs/super.c:96)
> [  447.710253]  shrink_slab_node (mm/vmscan.c:306)
> [  447.710253]  shrink_slab (mm/vmscan.c:381)
> [  447.710253]  kswapd_shrink_zone (mm/vmscan.c:2909)
> [  447.710253]  kswapd (mm/vmscan.c:3090 mm/vmscan.c:3296)
> [  447.710253]  ? mem_cgroup_shrink_node_zone (mm/vmscan.c:3213)
> [  447.710253]  kthread (kernel/kthread.c:219)
> [  447.710253]  ? __tick_nohz_task_switch (arch/x86/include/asm/paravirt.h:809 kernel/time/tick-sched.c:272)
> [  447.710253]  ? kthread_create_on_node (kernel/kthread.c:185)
> [  447.710253]  ret_from_fork (arch/x86/kernel/entry_64.S:555)
> [  447.710253]  ? kthread_create_on_node (kernel/kthread.c:185)
> [  447.710253] Code: e9 a9 00 00 00 0f 1f 00 48 39 c3 0f 82 87 00 00 00 4c 39 e3 0f 83 7e 00 00 00 48 8b 7d a0 e8 45 ef ff ff 48 85 c0 49 89 c5 75 05 <0f> 0b 0f 1f 00 48 8b 7d b0 48 8d 4b 01 48 89 c2 4c 89 f6 e8 c5
> [  447.710253] RIP  clear_extent_bit (fs/btrfs/extent_io.c:676)
> [  447.710253]  RSP <ffff88066be83768>
> 
> 
> Thanks,
> Sasha

