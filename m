Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from srv1.host37.de ([176.28.54.59]:50619 "EHLO srv1.host37.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbaCXFJu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Mar 2014 01:09:50 -0400
Received: from [172.18.1.2] (p5DDA7924.dip0.t-ipconnect.de [93.218.121.36])
	(using TLSv1 with cipher ECDHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by srv1.host37.de (Postfix) with ESMTPSA id 3FF94159B
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Mar 2014 05:47:10 +0100 (CET)
Message-ID: <532FBD00.3080504@jue.yt>
Date: Mon, 24 Mar 2014 06:05:04 +0100
From: Jue <me@jue.yt>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Mysterious Kernel Bug
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

I'm using btrfs on this system:
> Linux qmap02 3.11.0-18-generic #32-Ubuntu SMP Tue Feb 18 21:11:14 UTC 
> 2014 x86_64 x86_64 x86_64 GNU/Linux

During a task with heavy I/O (it's a database server) suddenly every 
disk-accessing process freezes. Dmesg outputs the following when this 
happend:
> [38108.895509] ------------[ cut here ]------------
> [38108.895663] kernel BUG at 
> /build/buildd/linux-3.11.0/fs/btrfs/ctree.c:2964!
> [38108.895825] invalid opcode: 0000 [#1] SMP
> [38108.895970] Modules linked in: cirrus ttm drm_kms_helper drm 
> syscopyarea sysfillrect sysimgblt kvm_intel kvm virtio_balloon 
> i2c_piix4 mac_hid virtio_console psmouse serio_raw microcode lp 
> parport btrfs xor zlib_deflate raid6_pq libcrc32c floppy
> [38108.896013] CPU: 1 PID: 29950 Comm: btrfs-endio-wri Not tainted 
> 3.11.0-18-generic #32-Ubuntu
> [38108.896013] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
> [38108.896013] task: ffff880dcf2c2ee0 ti: ffff8809b9230000 task.ti: 
> ffff8809b9230000
> [38108.896013] RIP: 0010:[<ffffffffa0058db1>] [<ffffffffa0058db1>] 
> btrfs_set_item_key_safe+0x161/0x170 [btrfs]
> [38108.896013] RSP: 0018:ffff8809b9231b20  EFLAGS: 00010286
> [38108.896013] RAX: 00000000ffffffff RBX: 0000000000000018 RCX: 
> 0000000017466000
> [38108.896013] RDX: 00000000ffffffff RSI: ffff8809b9231c26 RDI: 
> ffff8809b9231b3f
> [38108.896013] RBP: ffff8809b9231b78 R08: 0000000000017340 R09: 
> 0000000000000000
> [38108.896013] R10: 0000000017468000 R11: 0000000000000000 R12: 
> ffff8809b9231b2e
> [38108.896013] R13: ffff880dced2bd80 R14: ffff8809b9231c26 R15: 
> ffff880b95815680
> [38108.896013] FS:  0000000000000000(0000) GS:ffff880e1fc40000(0000) 
> knlGS:0000000000000000
> [38108.896013] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [38108.896013] CR2: 000000000085f001 CR3: 0000000c4dbcf000 CR4: 
> 00000000000006e0
> [38108.896013] Stack:
> [38108.896013]  ffff880cee276000 081a000000000000 006c000000000000 
> 1a00000000174640
> [38108.896013]  6c00000000000008 0000000017464000 ffff880b95815680 
> 0000000017466000
> [38108.896013]  0000000000000000 0000000000000ad3 ffff880dced2bd80 
> ffff8809b9231c70
> [38108.896013] Call Trace:
> [38108.896013]  [<ffffffffa008fba1>] __btrfs_drop_extents+0x421/0xae0 
> [btrfs]
> [38108.896013]  [<ffffffffa0090d50>] btrfs_drop_extents+0x60/0x90 [btrfs]
> [38108.896013]  [<ffffffffa007f6ec>] 
> insert_reserved_file_extent.constprop.58+0x6c/0x290 [btrfs]
> [38108.896013]  [<ffffffff816ef78e>] ? _raw_spin_lock+0xe/0x20
> [38108.896013]  [<ffffffffa0088aff>] 
> btrfs_finish_ordered_io+0x4ef/0x910 [btrfs]
> [38108.896013]  [<ffffffff81141f07>] ? mempool_free_slab+0x17/0x20
> [38108.896013]  [<ffffffff811422d9>] ? mempool_free+0x49/0x90
> [38108.896013]  [<ffffffff811ddcad>] ? bio_put+0x7d/0xa0
> [38108.896013]  [<ffffffffa00be498>] ? 
> end_compressed_bio_write+0xe8/0xf0 [btrfs]
> [38108.896013]  [<ffffffffa0089105>] finish_ordered_fn+0x15/0x20 [btrfs]
> [38108.896013]  [<ffffffffa00a954e>] worker_loop+0x15e/0x550 [btrfs]
> [38108.896013]  [<ffffffffa00a93f0>] ? btrfs_queue_worker+0x320/0x320 
> [btrfs]
> [38108.896013]  [<ffffffff810848d0>] kthread+0xc0/0xd0
> [38108.896013]  [<ffffffff81084810>] ? kthread_create_on_node+0x120/0x120
> [38108.896013]  [<ffffffff816f836c>] ret_from_fork+0x7c/0xb0
> [38108.896013]  [<ffffffff81084810>] ? kthread_create_on_node+0x120/0x120
> [38108.896013] Code: 48 8b 45 bf 48 8d 7d c7 4c 89 f6 48 89 45 d0 0f 
> b6 45 be 88 45 cf 48 8b 45 b6 48 89 45 c7 e8 c7 f2 ff ff 85 c0 0f 8f 
> 48 ff ff ff <0f> 0b 0f 0b 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 
> 00 55
> [38108.896013] RIP  [<ffffffffa0058db1>] 
> btrfs_set_item_key_safe+0x161/0x170 [btrfs]
> [38108.896013]  RSP <ffff8809b9231b20>
> [38108.947225] ---[ end trace f5739e163e2811a8 ]---

Does anybody have any idea what this problem causes and how to solve it?

Thank you a lot!

Regards,
Juergen Fitschen
