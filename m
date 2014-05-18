Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:42691 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbaERWye (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 18 May 2014 18:54:34 -0400
Received: by mail-la0-f45.google.com with SMTP id gl10so3475002lab.4
        for <linux-btrfs@vger.kernel.org>; Sun, 18 May 2014 15:54:33 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 18 May 2014 18:54:33 -0400
Message-ID: <CAF0CPRE0zZNeNaeBgEU1J3aCRFA4NB2QXTgvJ6g5yQFjG0=c9A@mail.gmail.com>
Subject: Help with crash on mount issue
From: Ross Skaliotis <rskaliotis@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I filed a bug for null pointer dereferences I started hitting:

https://bugzilla.kernel.org/show_bug.cgi?id=76451

Noticing qgroup in the trace, I tried disabling/re-enabling quota
support for the filesystem. That turned out to be a mistake. Now as
soon as I mount, I'm getting an oops thanks to
btrfs_qgroup_rescan_worker (see below). Is there any way to disable
quota support for an unmounted filesystem? I'd also appreciate any
help in troubleshooting the underlying corruption here. The corruption
occurred on 3.14.1, and trying 3.15.0-rc5 still gives me the same
crash on mount issues.

Thanks for the help.

---------------

May 18 17:09:26 gonzo kernel: BTRFS info (device dm-3): disk space
caching is enabled
May 18 17:09:36 gonzo kernel: BUG: unable to handle kernel NULL
pointer dereference at 00000004
May 18 17:09:36 gonzo kernel: IP: [<c14698c0>] ulist_next+0x10/0x40
May 18 17:09:36 gonzo kernel: *pdpt = 0000000000000000 *pde = f000eef3f000eef3
May 18 17:09:36 gonzo kernel: Oops: 0000 [#1] SMP
May 18 17:09:36 gonzo kernel: Modules linked in: r8169 evdev
May 18 17:09:36 gonzo kernel: CPU: 1 PID: 5086 Comm: btrfs-qgroup-re
Not tainted 3.14.1 #1
May 18 17:09:36 gonzo kernel: Hardware name: Gigabyte Technology Co.,
Ltd. To be filled by O.E.M./H77N-WIFI, BIOS F4 07/31/2013
May 18 17:09:36 gonzo kernel: task: f2afbc20 ti: ed8d6000 task.ti: ed8d6000
May 18 17:09:36 gonzo kernel: EIP: 0060:[<c14698c0>] EFLAGS: 00010292 CPU: 1
May 18 17:09:36 gonzo kernel: EIP is at ulist_next+0x10/0x40
May 18 17:09:36 gonzo kernel: EAX: 00000000 EBX: 00000004 ECX:
80240011 EDX: ed8d7e6c
May 18 17:09:36 gonzo kernel: ESI: f26e4000 EDI: ed8d7f00 EBP:
ed8d7e40 ESP: ed8d7e38
May 18 17:09:36 gonzo kernel: DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
May 18 17:09:36 gonzo kernel: CR0: 80050033 CR2: 00000004 CR3:
01fc7000 CR4: 001407f0
May 18 17:09:36 gonzo kernel: Stack:
May 18 17:09:36 gonzo kernel: 00000000 f26e4000 ed8d7e7c c14685aa
0e4dc000 00000a23 00000000 00000001
May 18 17:09:36 gonzo kernel: f2827f50 f2827f60 00000000 f26e4000
ef680000 eaccc950 00000cd4 00000000
May 18 17:09:36 gonzo kernel: ed8d7f00 ed8d7f10 c146a740 0e4dc000
00000a23 00000000 00000001 ed8d7f00
May 18 17:09:36 gonzo kernel: Call Trace:
May 18 17:09:36 gonzo kernel: [<c14685aa>] btrfs_find_all_roots+0x5a/0xf0
May 18 17:09:36 gonzo kernel: [<c146a740>]
btrfs_qgroup_rescan_worker+0x2b0/0x660
May 18 17:09:36 gonzo kernel: [<c143a496>] worker_loop+0x76/0x3f0
May 18 17:09:36 gonzo kernel: [<c10aab18>] ? __wake_up_common+0x48/0x70
May 18 17:09:36 gonzo kernel: [<c109341c>] kthread+0xac/0xd0
May 18 17:09:36 gonzo kernel: [<c143a420>] ? btrfs_queue_worker+0x2c0/0x2c0
May 18 17:09:36 gonzo kernel: [<c1b0c437>] ret_from_kernel_thread+0x1b/0x28
May 18 17:09:36 gonzo kernel: [<c1093370>] ? __kthread_parkme+0x60/0x60
May 18 17:09:36 gonzo kernel: Code: 89 1c 24 e8 73 fe ff ff 8b 5d f8
8b 75 fc c9 c3 8d 74 26 00 8d bc 27 00 00 00 00 55 89 e5 83 ec
08 89 1c 24 89 74 24 04 8d 58 04 <8b> 48 04 31 c0 39 cb 74 0b 8b 32 85
f6 75 11 89 0a 8d 41 f0 8b
May 18 17:09:36 gonzo kernel: EIP: [<c14698c0>] ulist_next+0x10/0x40
SS:ESP 0068:ed8d7e38
May 18 17:09:36 gonzo kernel: CR2: 0000000000000004
May 18 17:09:36 gonzo kernel: ---[ end trace 45ab777217abb631 ]---

---------------

# btrfsck /dev/mapper/sda2-open
Checking filesystem on /dev/mapper/sda2-open
UUID: 8cb470e6-13ae-4e8a-aeef-e30942cc1072
checking extents
checking free space cache
checking fs roots
checking csums
checking root refs
found 1165534378737 bytes used err is 0
total csum bytes: 2929733560
total tree bytes: 4212686848
total fs tree bytes: 766558208
total extent tree bytes: 282804224
btree space waste bytes: 369335816
file data blocks allocated: 3284956061696
 referenced 3305002033152
Btrfs v3.14.1
