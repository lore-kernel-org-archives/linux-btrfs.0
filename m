Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:33261 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbcDKGpK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Apr 2016 02:45:10 -0400
Received: by mail-oi0-f51.google.com with SMTP id w85so196732216oiw.0
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Apr 2016 23:45:09 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 11 Apr 2016 08:45:08 +0200
Message-ID: <CAMdWP3GVfR+Jr7qpBUOP74c1Vo92APrEygr4n71tCktBgErp-A@mail.gmail.com>
Subject: refcount overflow in 4.4.6-grsec kernel
From: Tobias Hunger <tobias.hunger@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I updated my archlinux to use a grsec kernel (version 4.4.6). Now I
get lots of errors from PAX and all backtraces show mention btrfs.

Is this a known problem? Is there anything I can help to debug this?

This is the dump from the logs:

Apr 11 07:43:36 kernel: PAX: refcount overflow detected in:
pacman:11700, uid/euid: 0/0
Apr 11 07:43:36 kernel: CPU: 1 PID: 11700 Comm: pacman Not tainted
4.4.6.201604021734-1-grsec #1
Apr 11 07:43:36 kernel: Hardware name: LENOVO, BIOS 1.08 03/09/2016
Apr 11 07:43:36 kernel: task: ffff880524c28a80 ti: ffff880524c294a8
task.ti: ffff880524c294a8
Apr 11 07:43:36 kernel: RIP: 0010:[<ffffffffc02d66b3>]
[<ffffffffc02d66b3>] btrfs_qgroup_reserve_meta+0x73/0x90 [btrfs]
Apr 11 07:43:36 kernel: RSP: 0018:ffffc9000d6e3a90  EFLAGS: 00000a06
Apr 11 07:43:36 kernel: RAX: 0000000000000000 RBX: ffff8804fecc5050
RCX: 0000000000000000
Apr 11 07:43:36 kernel: RDX: ffff880524e708c8 RSI: ffffc9000d6e3a48
RDI: ffff880524c12d70
Apr 11 07:43:36 kernel: RBP: ffffc9000d6e3aa0 R08: 0000000000000000
R09: ffff88036cf5d048
Apr 11 07:43:36 kernel: R10: ffff8803739a0410 R11: 0000000000000000
R12: 0000000000014000
Apr 11 07:43:36 kernel: R13: ffff8804fecc5050 R14: 0000000000000005
R15: 0000000000014000
Apr 11 07:43:36 kernel: FS:  000003f0e634c740(0000)
GS:ffff880541440000(0000) knlGS:0000000000000000
Apr 11 07:43:36 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Apr 11 07:43:36 kernel: CR2: 000000000074a6a8 CR3: 000000000660c000
CR4: 00000000003606f0
Apr 11 07:43:36 kernel: DR0: 0000000000000000 DR1: 0000000000000000
DR2: 0000000000000000
Apr 11 07:43:36 kernel: DR3: 0000000000000000 DR6: 00000000fffe0ff0
DR7: 0000000000000400
Apr 11 07:43:36 kernel: Stack:
Apr 11 07:43:36 kernel:  0000000000000002 0000000000000201
ffffc9000d6e3af8 ffffffffc025ab06
Apr 11 07:43:36 kernel:  ffffffff861be853 ffffffffffff4111
ffff880373ccfa00 ffff8805250d0620
Apr 11 07:43:36 kernel:  ffff8804fecc5050 0000000000000005
ffff880448a4db88 0000000000000001
Apr 11 07:43:36 kernel: Call Trace:
Apr 11 07:43:36 kernel:  [<ffffffffc025ab06>]
start_transaction+0x346/0x430 [btrfs]
Apr 11 07:43:36 kernel:  [<ffffffff861be853>] ? lookup_fast+0x53/0x350
Apr 11 07:43:36 kernel:  [<ffffffffc025ac12>]
btrfs_start_transaction+0x22/0x30 [btrfs]
Apr 11 07:43:36 kernel:  [<ffffffffc026df26>] btrfs_create+0x46/0x250 [btrfs]
Apr 11 07:43:36 kernel:  [<ffffffff861bcacc>] ? __inode_permission+0x3c/0xc0
Apr 11 07:43:36 kernel:  [<ffffffff861bfe05>] vfs_create+0xa5/0xe0
Apr 11 07:43:36 kernel:  [<ffffffff861c1203>] path_openat+0x13c3/0x1400
Apr 11 07:43:36 kernel:  [<ffffffff861c29b6>] do_filp_open+0xb6/0x130
Apr 11 07:43:36 kernel:  [<ffffffff861ad931>] do_sys_open+0x151/0x230
Apr 11 07:43:36 kernel:  [<ffffffff861ada38>] SyS_open+0x28/0x40
Apr 11 07:43:36 kernel:  [<ffffffff865fbf70>]
entry_SYSCALL_64_fastpath+0x12/0x86
Apr 11 07:43:36 kernel:  [<ffffffff865fbfa3>] ?
entry_SYSCALL_64_fastpath+0x45/0x86
Apr 11 07:43:36 kernel:  [<ffffffff865fbfa3>] ?
entry_SYSCALL_64_fastpath+0x45/0x86
Apr 11 07:43:36 kernel: Code: 44 21 e0 41 39 c4 75 32 49 63 f4 48 89
df e8 b5 cb ff ff 85 c0 78 18 f0 44 01 a3 fc 04 00 00 71 0a f0 44 29
a3 fc 04 00 00 cd 04 <eb> 02 31 c0 5b 41 5c 5d 48 0f ba 2c 24 3f c3
A

Best Regards,
Tobias
