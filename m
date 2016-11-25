Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:32946 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750762AbcKYIag (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Nov 2016 03:30:36 -0500
Received: from hch by bombadil.infradead.org with local (Exim 4.85_2 #1 (Red Hat Linux))
        id 1cABXX-00055s-Ck
        for linux-btrfs@vger.kernel.org; Fri, 25 Nov 2016 08:07:23 +0000
Date: Fri, 25 Nov 2016 00:07:23 -0800
From: Christoph Hellwig <hch@infradead.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: reproducable oops in btrfs/130 with latests mainline
Message-ID: <20161125080723.GA12776@infradead.org>
References: <20161114123529.GA12093@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161114123529.GA12093@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Any chance to get someone look at this or the next bug report?

On Mon, Nov 14, 2016 at 04:35:29AM -0800, Christoph Hellwig wrote:
> btrfs/130	[  384.645337] run fstests btrfs/130 at 2016-11-14
> 12:33:26
> [  384.827333] BTRFS: device fsid bf118b00-e2e0-4a96-a177-765789170093 devid 1 transid 3 /dev/vdc
> [  384.851643] BTRFS info (device vdc): disk space caching is enabled
> [  384.852113] BTRFS info (device vdc): flagging fs with big metadata feature
> [  384.857043] BTRFS info (device vdc): creating UUID tree
> [  384.988347] BTRFS: device fsid 3b92b8c1-295d-4099-8623-d71a3cb270f8 devid 1 transid 3 /dev/vdc
> [  385.001946] BTRFS info (device vdc): disk space caching is enabled
> [  385.002846] BTRFS info (device vdc): flagging fs with big metadata
> feature
> [  385.008870] BTRFS info (device vdc): creating UUID tree
> [  416.318581] NMI watchdog: BUG: soft lockup - CPU#3 stuck for 22s! [btrfs:12782]
> [  416.319139] Modules linked in:
> [  416.319366] CPU: 3 PID: 12782 Comm: btrfs Not tainted 4.9.0-rc1 #826
> [  416.319789] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [  416.320466] task: ffff8801355a4140 task.stack: ffffc900000a4000
> [  416.320864] RIP: 0010:[<ffffffff816a197d>]  [<ffffffff816a197d>] find_parent_nodes+0xb7d/0x1530
> [  416.321455] RSP: 0018:ffffc900000a79b0  EFLAGS: 00000286
> [  416.321811] RAX: ffff88012de45640 RBX: 0000000000000000 RCX: ffffc900000a7a28
> [  416.322285] RDX: ffff88012de45660 RSI: 0000000001ca8000 RDI: ffff88013b803e40
> [  416.322759] RBP: ffffc900000a7ab0 R08: 0000000002400040 R09: ffff88010077a478
> [  416.323317] R10: ffff880127652f70 R11: ffff880127652f08 R12: ffff880000000000
> [  416.323791] R13: 6db6db6db6db6db7 R14: ffff8801295093b0 R15: 0000000000000000
> [  416.324262] FS:  00007f83ef8398c0(0000) GS:ffff88013fd80000(0000) knlGS:0000000000000000
> [  416.324795] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  416.325176] CR2: 00007f83ee4dbe38 CR3: 0000000136b56000 CR4: 00000000000006e0
> [  416.325649] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  416.326120] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  416.326590] Stack:
> [  416.326730]  0000000000000000 ffff880102400040 ffff88012a340000 0000000000001063
> [  416.327257]  0000000100000001 ffff88012dd0e800 ffff88012a340000 0000000000000001
> [  416.327780]  ffff88012a340000 0000000000000000 ffff88013b803e40 0000000000c40000
> [  416.328304] Call Trace:
> [  416.328475]  [<ffffffff816afbe0>] ? changed_cb+0xb70/0xb70
> [  416.328841]  [<ffffffff816a2eb7>] iterate_extent_inodes+0xe7/0x270
> [  416.329251]  [<ffffffff8165ecf6>] ? release_extent_buffer+0x26/0xc0
> [  416.329657]  [<ffffffff8165f266>] ? free_extent_buffer+0x46/0x80
> [  416.330068]  [<ffffffff816adb8f>] process_extent+0x69f/0xb00
> [  416.330452]  [<ffffffff816af33b>] changed_cb+0x2cb/0xb70
> [  416.330811]  [<ffffffff8165fa52>] ? read_extent_buffer+0xe2/0x140
> [  416.331380]  [<ffffffff81615e82>] ? btrfs_search_slot_for_read+0xc2/0x1b0
> [  416.331905]  [<ffffffff816b0ff7>] btrfs_ioctl_send+0x1187/0x12c0
> [  416.332309]  [<ffffffff811de83a>] ? kmem_cache_alloc+0x8a/0x160
> [  416.332704]  [<ffffffff81675edc>] btrfs_ioctl+0x7dc/0x21f0
> [  416.333071]  [<ffffffff8109076c>] ? flat_send_IPI_mask+0xc/0x10
> [  416.333465]  [<ffffffff8108cd6d>] ? default_send_IPI_single+0x2d/0x30
> [  416.333893]  [<ffffffff81088e87>] ? native_smp_send_reschedule+0x27/0x40
> [  416.334340]  [<ffffffff810f1d3d>] ? resched_curr+0xad/0xb0
> [  416.334706]  [<ffffffff811f83db>] do_vfs_ioctl+0x8b/0x5b0
> [  416.335065]  [<ffffffff810cba02>] ? _do_fork+0x132/0x390
> [  416.335423]  [<ffffffff811f893c>] SyS_ioctl+0x3c/0x70
> [  416.335763]  [<ffffffff81df2177>] entry_SYSCALL_64_fastpath+0x1a/0xa9
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
