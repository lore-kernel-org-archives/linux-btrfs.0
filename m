Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:37137 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbaAHTyN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Jan 2014 14:54:13 -0500
MIME-Version: 1.0
In-Reply-To: <1389210102.23310.31.camel@ret.masoncoding.com>
References: <20140102053101.GA29352@localhost>
	<CAFR8uee-WTy6cj8bB4aMuGP1B0sZkc70sq1Drg7uhHS49EqHcg@mail.gmail.com>
	<20140106221036.GE9037@kmo>
	<CAFR8uef3XUEsHUvfnkAbzsXict8qD_28fTgUQyA7gjUk03OUsw@mail.gmail.com>
	<20140107055318.GA19016@localhost>
	<CAFR8ueeC_fqpN+M5YOr8AT_o3BDgr+o1ELQQJQSW7s8uDm2y5Q@mail.gmail.com>
	<1389126617.23310.19.camel@ret.masoncoding.com>
	<CAFR8ueezG4U5ULcp0ayhY690RUE7280UL68d55+tGCqDW9A1Kg@mail.gmail.com>
	<1389210102.23310.31.camel@ret.masoncoding.com>
Date: Wed, 8 Jan 2014 11:54:12 -0800
Message-ID: <CAFR8uefXjN_nzHWsTF=-PxNPDMWMj5Hw+ueFYQwa8-qBEGMGTw@mail.gmail.com>
Subject: Re: [block:for-3.14/core] kernel BUG at fs/bio.c:1748
From: Muthu Kumar <muthu.lkml@gmail.com>
To: Chris Mason <clm@fb.com>
Cc: "kmo@daterainc.com" <kmo@daterainc.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lkp@linux.intel.com" <lkp@linux.intel.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris,

[    8.336061] WARNING: CPU: 0 PID: 0 at fs/bio.c:1778 bio_endio+0xbe/0x100()
[    8.336062] bio_endio: bio for (unknown) without endio

This is my recent change to avoid memory leak in bio_endio. But I
think the problem is higher up, most likely bio_endio is called twice
on the same bio (which was freed before).

Are you running the unmodified for-3.14/core or do you have local patches?


Regards,
Muthu

On Wed, Jan 8, 2014 at 11:41 AM, Chris Mason <clm@fb.com> wrote:
> On Tue, 2014-01-07 at 13:23 -0800, Muthu Kumar wrote:
>> Chris,
>> This is based off of Jens block tree, for-3.14/core branch...
>>
>
> Ok, Kent did pull in one of my hunks, one was a comment and the third
> was effectively the same as your patch.  I tried to test the end result
> today, but get these on boot with ext4:
>
> [    8.336061] WARNING: CPU: 0 PID: 0 at fs/bio.c:1778 bio_endio+0xbe/0x100()
> [    8.336062] bio_endio: bio for (unknown) without endio
> [    8.336063] Modules linked in: megaraid_sas(+)
> [    8.336065] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.13.0-rc7-mason+ #1
> [    8.336066] Hardware name: ZTSYSTEMS Echo Ridge T4  /A9DRPF-10D, BIOS 1.07 05/10/2012
> [    8.336069]  00000000000006f2 ffff88087fc03c28 ffffffff815cb8c6 00000000000006f2
> [    8.336071]  ffff88087fc03c78 ffff88087fc03c68 ffffffff81047497 ffff88085561a8e8
> [    8.336073]  ffff8808582b6d80 00000000000000fe 00000000fffffffb ffff8808582b6d80
> [    8.336073] Call Trace:
> [    8.336078]  <IRQ>  [<ffffffff815cb8c6>] dump_stack+0x49/0x5b
> [    8.336082]  [<ffffffff81047497>] warn_slowpath_common+0x87/0xb0
> [    8.336084]  [<ffffffff81047561>] warn_slowpath_fmt+0x41/0x50
> [    8.336086]  [<ffffffff813aa6b8>] ? scsi_request_fn+0xc8/0x6a0
> [    8.336087]  [<ffffffff8119bc8e>] bio_endio+0xbe/0x100
> [    8.336091]  [<ffffffff8128c1d3>] blk_update_request+0x243/0x3a0
> [    8.336092]  [<ffffffff8128c352>] blk_update_bidi_request+0x22/0xa0
> [    8.336094]  [<ffffffff8128ceca>] blk_end_bidi_request+0x2a/0x80
> [    8.336096]  [<ffffffff8128cf5b>] blk_end_request+0xb/0x10
> [    8.336098]  [<ffffffff813ab916>] scsi_io_completion+0xa6/0x700
> [    8.336100]  [<ffffffff813a2b68>] scsi_finish_command+0xc8/0x130
> [    8.336101]  [<ffffffff813ac0bf>] scsi_softirq_done+0x13f/0x160
> [    8.336104]  [<ffffffff812937ad>] blk_done_softirq+0x6d/0x80
> [    8.336106]  [<ffffffff8104c26b>] __do_softirq+0xdb/0x290
> [    8.336108]  [<ffffffff8104c51d>] irq_exit+0xbd/0xd0
> [    8.336110]  [<ffffffff81003db1>] do_IRQ+0x61/0xe0
> [    8.336112]  [<ffffffff815d012a>] common_interrupt+0x6a/0x6a
> [    8.336117]  <EOI>  [<ffffffff814e213a>] ? cpuidle_enter_state+0x4a/0xc0
> [    8.336119]  [<ffffffff814e2136>] ? cpuidle_enter_state+0x46/0xc0
> [    8.336121]  [<ffffffff814e2277>] cpuidle_idle_call+0xc7/0x160
> [    8.336123]  [<ffffffff8100b2c9>] arch_cpu_idle+0x9/0x20
> [    8.336126]  [<ffffffff8108fd8a>] cpu_startup_entry+0x9a/0x250
> [    8.336128]  [<ffffffff815c3702>] rest_init+0x72/0x80
> [    8.336131]  [<ffffffff81ac2047>] start_kernel+0x3fd/0x40a
> [    8.336133]  [<ffffffff81ac1a78>] ? repair_env_string+0x5b/0x5b
> [    8.336134]  [<ffffffff81ac159d>] x86_64_start_reservations+0x2a/0x2c
> [    8.336136]  [<ffffffff81ac16df>] x86_64_start_kernel+0x140/0x147
> [    8.336137] ---[ end trace d0966e2430ea53b4 ]---
> [    8.336146] ------------[ cut here ]------------
> [    8.336146] kernel BUG at fs/bio.c:523!
> [    8.336148] invalid opcode: 0000 [#1] SMP
> [    8.336148] Modules linked in: megaraid_sas(+)
> [    8.336150] CPU: 0 PID: 2911 Comm: scsi_id Tainted: G        W    3.13.0-rc7-mason+ #1
> [    8.336150] Hardware name: ZTSYSTEMS Echo Ridge T4  /A9DRPF-10D, BIOS 1.07 05/10/2012
> [    8.336151] task: ffff8808556b4150 ti: ffff8808556b6000 task.ti: ffff8808556b6000
> [    8.336153] RIP: 0010:[<ffffffff8119bbba>]  [<ffffffff8119bbba>] bio_put+0x8a/0xa0
> [    8.336153] RSP: 0018:ffff8808556b7b68  EFLAGS: 00010246
> [    8.336154] RAX: 0000000000000000 RBX: ffff8808582b6d80 RCX: 0000000000000000
> [    8.336155] RDX: ffff8808582b6dec RSI: 0000000000000003 RDI: ffff8808582b6d80
> [    8.336155] RBP: ffff8808556b7b78 R08: 0000000000000004 R09: 0000000000000000
> [    8.336156] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
> [    8.336156] R13: 0000000000000000 R14: ffff8808567ebe28 R15: ffff8808582b6d80
> [    8.336157] FS:  00007f16056bd700(0000) GS:ffff88087fc00000(0000) knlGS:0000000000000000
> [    8.336158] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    8.336159] CR2: ffffe8f7ffc00000 CR3: 0000000856303000 CR4: 00000000000407f0
> [    8.336159] Stack:
> [    8.336164]  ffff8808582b6d80 0000000000000000 ffff8808556b7ba8 ffffffff81291b37
> [    8.336168]  ffff8808556b7b88 ffff8808556b7cf8 ffff88085561a8e8 ffff880855685400
> [    8.336172]  ffff8808556b7c78 ffffffff8129b42d ffff8808556b7be8 ffffffff8119e09b
> [    8.336172] Call Trace:
> [    8.336174]  [<ffffffff81291b37>] blk_rq_unmap_user+0x47/0x60
> [    8.336177]  [<ffffffff8129b42d>] sg_io+0x26d/0x370
> [    8.336179]  [<ffffffff8119e09b>] ? bdget+0x11b/0x130
> [    8.336183]  [<ffffffff811068c9>] ? find_get_page+0x19/0xa0
> [    8.336185]  [<ffffffff8129bc79>] scsi_cmd_ioctl+0x409/0x480
> [    8.336186]  [<ffffffff81106af2>] ? unlock_page+0x22/0x30
> [    8.336189]  [<ffffffff81130949>] ? __do_fault+0x439/0x560
> [    8.336191]  [<ffffffff8129bd3c>] scsi_cmd_blk_ioctl+0x4c/0x70
> [    8.336194]  [<ffffffff81437d6f>] sd_ioctl+0xcf/0x160
> [    8.336196]  [<ffffffff81298003>] __blkdev_driver_ioctl+0x23/0x30
> [    8.336198]  [<ffffffff81298638>] blkdev_ioctl+0x1f8/0x790
> [    8.336199]  [<ffffffff8119d717>] block_ioctl+0x37/0x40
> [    8.336201]  [<ffffffff811790c7>] do_vfs_ioctl+0x87/0x4f0
> [    8.336204]  [<ffffffff8126374a>] ? file_has_perm+0x8a/0xa0
> [    8.336205]  [<ffffffff811795c1>] SyS_ioctl+0x91/0xa0
> [    8.336207]  [<ffffffff815d77e2>] system_call_fastpath+0x16/0x1b
> [    8.336218] Code: 8b 74 24 10 48 29 fb 48 89 df e8 a2 d2 f6 ff 48 8b 1c 24 4c 8b 64 24 08 c9 c3 0f 1f 80 00 00 00 00 48 89 df e8 38 60 fb ff eb 9a <0f> 0b 0f 1f 40 00 eb f
> a 66 66 66 66 66 2e 0f 1f 84 00 00 00 00
> [    8.336220] RIP  [<ffffffff8119bbba>] bio_put+0x8a/0xa0
> [    8.336220]  RSP <ffff8808556b7b68>
> [    8.336221] ---[ end trace d0966e2430ea53b5 ]---
>
> Trying to track it down.
>
> -chris
