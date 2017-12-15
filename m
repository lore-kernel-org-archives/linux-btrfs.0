Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:42884 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754859AbdLOEBY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Dec 2017 23:01:24 -0500
Received: by mail-ot0-f193.google.com with SMTP id i1so6792538oth.9
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Dec 2017 20:01:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAA85sZvo8_39nhyoZP6SGiXTAEi4MCNPDLgqe75LNuUUwQSMqQ@mail.gmail.com>
References: <CAA85sZvo8_39nhyoZP6SGiXTAEi4MCNPDLgqe75LNuUUwQSMqQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 14 Dec 2017 21:01:22 -0700
Message-ID: <CAJCQCtQLYgaOL3VN5V3+Av9OT3NUtmc71CzAU37tgfNRiiSmEQ@mail.gmail.com>
Subject: Re: [4.14.3] btrfs out of space error
To: Ian Kumlien <ian.kumlien@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 14, 2017 at 5:39 PM, Ian Kumlien <ian.kumlien@gmail.com> wrote:
> Hi,
>
> Running a 4.14.3 kernel, this just happened, but there should have
> been another 20 gigs or so available.
>
> The filesystem seems fine after a reboot though
>
> [1070034.614893] ------------[ cut here ]------------
> [1070034.614899] WARNING: CPU: 4 PID: 18634 at fs/btrfs/inode.c:4647
> btrfs_truncate_inode_items+0xea5/0xfb0
> [1070034.614899] Modules linked in: mlx4_en chaoskey amdgpu mfd_core mlx4_core
> [1070034.614904] CPU: 4 PID: 18634 Comm: TaskSchedulerFo Not tainted 4.14.3 #165
> [1070034.614905] Hardware name: To be filled by O.E.M. To be filled by
> O.E.M./SABERTOOTH 990FX, BIOS 1604 10/16/2012
> [1070034.614906] task: ffff8bb0f2332c00 task.stack: ffff9630064c4000
> [1070034.614907] RIP: 0010:btrfs_truncate_inode_items+0xea5/0xfb0
> [1070034.614907] RSP: 0018:ffff9630064c7cc0 EFLAGS: 00010282
> [1070034.614909] RAX: 0000000000000026 RBX: ffff8bb11348a070 RCX:
> 0000000000000000
> [1070034.614909] RDX: ffff8bb13ed147b0 RSI: ffff8bb13ed0c9d8 RDI:
> ffff8bb13ed0c9d8
> [1070034.614910] RBP: ffff8baf61905c70 R08: 0000000000000001 R09:
> 00000000000005f1
> [1070034.614910] R10: 0000000000001000 R11: 0000000000000000 R12:
> ffff8bb1138e0800
> [1070034.614911] R13: 00000000000001e6 R14: ffff8baf60610ee0 R15:
> 00000000000000eb
> [1070034.614912] FS:  00007fad68b7f700(0000) GS:ffff8bb13ed00000(0000)
> knlGS:0000000000000000
> [1070034.614912] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [1070034.614913] CR2: 00001c7e020d0000 CR3: 0000000180a19000 CR4:
> 00000000000406e0
> [1070034.614913] Call Trace:
> [1070034.614918]  btrfs_truncate+0x11d/0x2c0
> [1070034.614919]  btrfs_setattr+0x27b/0x3c0
> [1070034.614921]  notify_change+0x29f/0x430
> [1070034.614923]  do_truncate+0x5e/0x90
> [1070034.614925]  do_sys_ftruncate.constprop.3+0x139/0x1a0
> [1070034.614927]  entry_SYSCALL_64_fastpath+0x13/0x94
> [1070034.614928] RIP: 0033:0x7fadd17c945e
> [1070034.614929] RSP: 002b:00007fad68b7e870 EFLAGS: 00000246 ORIG_RAX:
> 000000000000004d
> [1070034.614930] RAX: ffffffffffffffda RBX: 000023f3339a9710 RCX:
> 00007fadd17c945e
> [1070034.614930] RDX: 00000000000000bb RSI: 00000000000000eb RDI:
> 0000000000000304
> [1070034.614931] RBP: 00005604376778bd R08: 0023ff6cb6a33301 R09:
> 00007ffd8a3c0080
> [1070034.614931] R10: 0000000000000023 R11: 0000000000000246 R12:
> 000023f3339a96c0
> [1070034.614932] R13: 0000000000000001 R14: 00007fad68b7e938 R15:
> 000056043dfdbaf8
> [1070034.614933] Code: 48 8b 44 24 28 48 8b 40 60 f0 0f ba a8 08 ce 00
> 00 02 72 19 83 7c 24 58 fb 74 12 8b 74 24 58 48 c7 c7 e8 3b 22 93 e8
> 06 b5 c7 ff <0f> ff 8b 4c 24 58 ba 27 12 00 00 48 8b 7c 24 28 48 c7 c6
> 30 0b
> [1070034.614950] ---[ end trace c8eff7895ddacab0 ]---
> [1070034.614951] BTRFS: error (device sdb2) in
> btrfs_truncate_inode_items:4647: errno=-28 No space left
> [1070034.614954] BTRFS info (device sdb2): forced readonly
> [1070034.616386] BTRFS error (device sdb2): pending csums is 106496

This last line is concerning, I interpret that as csum tree flush did
not finish before the fs was forced read only. I'm not sure what the
future consequences of that will be.

You should probably run a scrub and also an offline readonly btrfs
check and see what that turns up.

-- 
Chris Murphy
