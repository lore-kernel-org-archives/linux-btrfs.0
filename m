Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ud10.udmedia.de ([194.117.254.50]:41782 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122AbbLJPQb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Dec 2015 10:16:31 -0500
Date: Thu, 10 Dec 2015 16:09:49 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Dave Jones <davej@codemonkey.org.uk>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: !PageLocked BUG_ON hit in clear_page_dirty_for_io
Message-ID: <20151210150949.GA319@x4>
References: <20151209042528.GA2413@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151209042528.GA2413@codemonkey.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015.12.08 at 23:25 -0500, Dave Jones wrote:
> Not sure if I've already reported this one, but I've been seeing this
> a lot this last couple days.
> 
> kernel BUG at mm/page-writeback.c:2654!

Just hit the same issue trying to build ghc-7.10.3:

[55704.436096] ------------[ cut here ]------------
[55704.436155] kernel BUG at mm/page-writeback.c:2654!
[55704.436213] invalid opcode: 0000 [#1] SMP 
[55704.436261] CPU: 2 PID: 17177 Comm: ghc Not tainted 4.4.0-rc4-00060-g9a0f76fde9ad-dirty #69
[55704.436370] Hardware name: System manufacturer System Product Name/M4A78T-E, BIOS 3503    04/13/2011
[55704.436491] task: ffff88015c2c1d40 ti: ffff880199268000 task.ti: ffff880199268000
[55704.436585] RIP: 0010:[<ffffffff8113b4bd>]  [<ffffffff8113b4bd>] clear_page_dirty_for_io+0xdd/0x180
[55704.436710] RSP: 0018:ffff88019926bcd0  EFLAGS: 00010246
[55704.436770] RAX: 4000000000000868 RBX: ffffea00029f2080 RCX: 0000000000000000
[55704.436860] RDX: 0000000000000000 RSI: 0000000000000286 RDI: ffffea00029f2080
[55704.436949] RBP: ffff8801c7900e30 R08: 0000a2bc9694357c R09: 0000000000000000
[55704.437037] R10: 0000000000000000 R11: ffff88015c2c1da0 R12: ffff8801c7900e30
[55704.437131] R13: ffff88019926bda0 R14: 0007ffffffffffff R15: ffffea00029f2080
[55704.437222] FS:  00007f79ba21e700(0000) GS:ffff88021fd00000(0000) knlGS:0000000000000000
[55704.437326] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[55704.437395] CR2: 00007fffa6d2cff8 CR3: 000000007ee1b000 CR4: 00000000000006e0
[55704.437485] Stack:
[55704.437495]  ffff88019926bd38 ffff88019926be78 ffff8801c7900e30 ffffffff812f81ae
[55704.437595]  ffff88019926bdd8 0000000000400000 0000000000000000 0000000000000000
[55704.437693]  ffff8801c7900cf0 000000000000000e 000000000000000e 0000000000000000
[55704.437792] Call Trace:
[55704.437812]  [<ffffffff812f81ae>] ? extent_write_cache_pages.isra.39.constprop.74+0x14e/0x320
[55704.437925]  [<ffffffff812f8f0b>] ? extent_writepages+0x4b/0x120
[55704.437998]  [<ffffffff812d4840>] ? __start_delalloc_inodes+0x3a0/0x3a0
[55704.438080]  [<ffffffff8113ba45>] ? do_writepages+0x25/0x80
[55704.438152]  [<ffffffff81056747>] ? do_signal+0x2c7/0x540
[55704.438228]  [<ffffffff811299c5>] ? filemap_flush+0x65/0xa0
[55704.438303]  [<ffffffff812e2fee>] ? btrfs_release_file+0x2e/0x40
[55704.438378]  [<ffffffff81182dec>] ? ____fput+0xcc/0x1c0
[55704.438438]  [<ffffffff810b22ec>] ? task_work_run+0x6c/0xa0
[55704.438510]  [<ffffffff8100268c>] ? syscall_return_slowpath+0xcc/0xe0
[55704.438591]  [<ffffffff8108f2e3>] ? int_ret_from_sys_call+0x25/0x8f
[55704.438672] Code: e1 81 74 19 49 8b 44 24 18 48 3b 05 be e2 d2 00 0f 84 8a 00 00 00 48 8b a8 c8 00 00 00 f0 0f ba 33 04 72 82 31 c0 e9 76 ff ff ff <0f> 0b 48 c7 c0 60 ce e1 81 e9 59 ff ff ff 48 89 df e8 4d 00 01 
[55704.439055] RIP  [<ffffffff8113b4bd>] clear_page_dirty_for_io+0xdd/0x180
[55704.439144]  RSP <ffff88019926bcd0>
[55704.475600] ---[ end trace 09f06afe4a05a024 ]---

-- 
Markus
