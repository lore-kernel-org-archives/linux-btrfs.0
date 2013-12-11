Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:3318 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751436Ab3LKK6a (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Dec 2013 05:58:30 -0500
Message-ID: <52A84599.50208@cn.fujitsu.com>
Date: Wed, 11 Dec 2013 18:59:37 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs/024 is unhappy on current HEAD
References: <20131211103938.GA22293@infradead.org>
In-Reply-To: <20131211103938.GA22293@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This bug has been fixed by

https://patchwork.kernel.org/patch/3222061/

Thanks
Miao

On 	wed, 11 Dec 2013 02:39:38 -0800, Christoph Hellwig wrote:
> btrfs/024	[  159.416857] btrfs: device fsid
> c8802dbf-ca95-45c5-af67-18f13ef243ea devid 1 transid 4 /dev/vdc
> [  159.430449] btrfs: setting nodatacow, compression disabled
> [  159.431668] btrfs: disk space caching is enabled
> [  159.439418] btrfs: creating UUID tree
> [  159.466146] ------------[ cut here ]------------
> [  159.467547] WARNING: CPU: 3 PID: 8127 at /work/hch/linux/kernel/locking/lockdep.c:3160 __lock_acquire+0x1f18/0x1fa0()
> [  159.468075] btrfs: device fsid c8802dbf-ca95-45c5-af67-18f13ef243ea devid 1 transid 5 /dev/vdc
> [  159.469411] DEBUG_LOCKS_WARN_ON(id >= MAX_LOCKDEP_KEYS)
> [  159.469411] Modules linked in:
> [  159.469411] CPU: 3 PID: 8127 Comm: btrfs-delalloc- Not tainted 3.13.0-rc3+ #72
> [  159.469411] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
> [  159.469411]  0000000000000009 ffff880070787948 ffffffff81c6aeb2 ffff88006fecc050
> [  159.469411]  ffff880070787998 ffff880070787988 ffffffff81092e97 0000000000000ef2
> [  159.469411]  ffff88006fecc700 0000000000000002 ffffffff82f65940 0000000000000000
> [  159.469411] Call Trace:
> [  159.469411]  [<ffffffff81c6aeb2>] dump_stack+0x46/0x58
> [  159.469411]  [<ffffffff81092e97>] warn_slowpath_common+0x87/0xb0
> [  159.469411]  [<ffffffff81092f61>] warn_slowpath_fmt+0x41/0x50
> [  159.469411]  [<ffffffff810da0b8>] __lock_acquire+0x1f18/0x1fa0
> [  159.469411]  [<ffffffff810da708>] lock_acquire+0x98/0x120
> [  159.469411]  [<ffffffff8165b44d>] ? find_workspace+0x9d/0x1c0
> [  159.469411]  [<ffffffff81c73a6c>] _raw_spin_lock+0x2c/0x40
> [  159.469411]  [<ffffffff8165b44d>] ? find_workspace+0x9d/0x1c0
> [  159.469411]  [<ffffffff8165b44d>] find_workspace+0x9d/0x1c0
> [  159.469411]  [<ffffffff8114b54d>] ? clear_page_dirty_for_io+0xed/0x110
> [  159.469411]  [<ffffffff8165c624>] btrfs_compress_pages+0x34/0xc0
> [  159.469411]  [<ffffffff810db28d>] ? trace_hardirqs_on+0xd/0x10
> [  159.469411]  [<ffffffff8161f82f>] compress_file_range+0x1df/0x650
> [  159.469411]  [<ffffffff8161fcd0>] async_cow_start+0x30/0x50
> [  159.469411]  [<ffffffff81645097>] worker_loop+0x157/0x590
> [  159.469411]  [<ffffffff810db28d>] ? trace_hardirqs_on+0xd/0x10
> [  159.469411]  [<ffffffff81644f40>] ? btrfs_queue_worker+0x310/0x310
> [  159.469411]  [<ffffffff810b6b0f>] kthread+0xdf/0x100
> [  159.469411]  [<ffffffff81c741eb>] ? _raw_spin_unlock_irq+0x2b/0x40
> [  159.469411]  [<ffffffff810b6a30>] ? __init_kthread_worker+0x70/0x70
> [  159.469411]  [<ffffffff81c7c5cc>] ret_from_fork+0x7c/0xb0
> [  159.469411]  [<ffffffff810b6a30>] ? __init_kthread_worker+0x70/0x70
> [  159.469411] ---[ end trace ce7bfbef1159b87c ]---
> [  159.537771] BUG: unable to handle kernel NULL pointer dereference at 0000000000000003
> [  159.540789] IP: [<ffffffff8165b4c0>] find_workspace+0x110/0x1c0
> [  159.541065] PGD 6ec6d067 PUD 7b53d067 PMD 0 
> [  159.541065] Oops: 0000 [#1] SMP 
> [  159.541065] Modules linked in:
> [  159.541065] CPU: 3 PID: 8127 Comm: btrfs-delalloc- Tainted: G
> W    3.13.0-rc3+ #72
> [  159.541065] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
> [  159.541065] task: ffff88006fecc050 ti: ffff880070786000 task.ti: ffff880070786000
> [  159.541065] RIP: 0010:[<ffffffff8165b4c0>]  [<ffffffff8165b4c0>] find_workspace+0x110/0x1c0
> [  159.541065] RSP: 0018:ffff880070787b98  EFLAGS: 00010296
> [  159.541065] RAX: 0000000000000003 RBX: ffffffff82f65928 RCX: 0000000000000100
> [  159.541065] RDX: 0000000000000000 RSI: ffffffff820a0070 RDI: ffffffff82f65928
> [  159.541065] RBP: ffff880070787c18 R08: 0000000000000002 R09: 0000000000000000
> [  159.541065] R10: ffffffff81dfae80 R11: 0000000000000322 R12: ffffffff82f65930
> [  159.541065] R13: ffffffff82f659cc R14: 0000000000000004 R15: ffff880070787bd8
> [  159.541065] FS:  0000000000000000(0000) GS:ffff88007fd80000(0000) knlGS:0000000000000000
> [  159.541065] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  159.541065] CR2: 0000000000000003 CR3: 000000006fed8000 CR4: 00000000000006e0
> [  159.541065] Stack:
> [  159.541065]  ffff880070787c18 ffff88006fecc050 ffffffffffffffff ffffffff82f65998
> [  159.541065]  ffff880000000000 0000000000000046 0000000000000082 0000000000000246
> [  159.541065]  00000000707a86f0 ffff88006fecc050 ffffffff8114b54d 0000000000000000
> [  159.541065] Call Trace:
> [  159.541065]  [<ffffffff8114b54d>] ? clear_page_dirty_for_io+0xed/0x110
> [  159.541065]  [<ffffffff8165c624>] btrfs_compress_pages+0x34/0xc0
> [  159.541065]  [<ffffffff810db28d>] ? trace_hardirqs_on+0xd/0x10
> [  159.541065]  [<ffffffff8161f82f>] compress_file_range+0x1df/0x650
> [  159.541065]  [<ffffffff8161fcd0>] async_cow_start+0x30/0x50
> [  159.541065]  [<ffffffff81645097>] worker_loop+0x157/0x590
> [  159.541065]  [<ffffffff810db28d>] ? trace_hardirqs_on+0xd/0x10
> [  159.541065]  [<ffffffff81644f40>] ? btrfs_queue_worker+0x310/0x310
> [  159.541065]  [<ffffffff810b6b0f>] kthread+0xdf/0x100
> [  159.541065]  [<ffffffff81c741eb>] ? _raw_spin_unlock_irq+0x2b/0x40
> [  159.541065]  [<ffffffff810b6a30>] ? __init_kthread_worker+0x70/0x70
> [  159.541065]  [<ffffffff81c7c5cc>] ret_from_fork+0x7c/0xb0
> [  159.541065]  [<ffffffff810b6a30>] ? __init_kthread_worker+0x70/0x70
> [  159.541065] Code: 8d 75 a8 e8 b3 4e a7 ff 41 8b 45 00 41 39 c6 7d 92 48 8b 55 90 8b 04 95 70 5a f6 82 85 c0 75 83 e8 06 45 61 00 e9 79 ff ff ff 90 <48> 8b 08 48 89 df 48 8b 50 08 48 89 51 08 48 89 0a 48 ba 00 01 
> [  159.541065] RIP  [<ffffffff8165b4c0>] find_workspace+0x110/0x1c0
> [  159.541065]  RSP <ffff880070787b98>
> [  159.541065] CR2: 0000000000000003
> [  159.541065] ---[ end trace ce7bfbef1159b87d ]---
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

