From: Andrew Lutomirski <luto@mit.edu>
Subject: [2.6.33 regression] btrfs mount causes memory corruption
Date: Thu, 25 Feb 2010 15:01:08 -0500
Message-ID: <cb0375e11002251201v7969b891n687f928e2402f7c9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Mounting btrfs corrupts memory and causes nasty crashes within a few
seconds.  This seems to happen even if the mount fails (note the
unrecognized mount option).  This is a regression from 2.6.32, and
I've attached an example.

--Andy

Btrfs loaded
device fsid cf4a8e080605f191-af91bbbf445c98b8 devid 2 transid 68136 /dev/dm-2
device fsid cf4a8e080605f191-af91bbbf445c98b8 devid 1 transid 68136 /dev/dm-1
device fsid cf4a8e080605f191-af91bbbf445c98b8 devid 2 transid 68136
/dev/mapper/big_2
device fsid cf4a8e080605f191-af91bbbf445c98b8 devid 1 transid 68136
/dev/mapper/big_1
device fsid cf4a8e080605f191-af91bbbf445c98b8 devid 1 transid 68136
/dev/mapper/big_1
btrfs: unrecognized mount option 'acl'
btrfs: open_ctree failed
------------[ cut here ]------------
kernel BUG at mm/slub.c:2969!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/kernel/mm/ksm/run
CPU 6
Pid: 2692, comm: bash Tainted: G        W  2.6.33 #2 P6T WS PRO/System
Product Name
RIP: 0010:[<ffffffff810fbbde>]  [<ffffffff810fbbde>] kfree+0x62/0xd5
RSP: 0018:ffff88019db87c68  EFLAGS: 00010246
RAX: 0040000000080000 RBX: ffff88019db87d18 RCX: ffff8801b175de20
RDX: ffffea0000000000 RSI: ffffea0003800000 RDI: ffff880100000000
RBP: ffff88019db87c88 R08: ffffffff81a57aa0 R09: ffff8801b551c240
R10: 00000002412fde13 R11: 0000000000000000 R12: ffff880100000000
R13: ffffffff811d9532 R14: 0000000000000010 R15: ffff88019db87ce8
FS:  00007fde0bce7700(0000) GS:ffff8800282c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f041b1b4600 CR3: 00000001b776a000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process bash (pid: 2692, threadinfo ffff88019db86000, task ffff88019d928000)
Stack:
 ffff8801b551c240 ffff88019db87d18 0000000000000000 ffff88019b65f164
<0> ffff88019db87ca8 ffffffff811d9532 ffff88019db87ce8 ffff8801b4b8f548
<0> ffff88019db87cc8 ffffffff811de035 ffff8801b4b8f548 ffff8801b644bba8
Call Trace:
 [<ffffffff811d9532>] ebitmap_destroy+0x21/0x3c
 [<ffffffff811de035>] context_destroy+0x58/0x6c
 [<ffffffff811e0787>] security_compute_sid+0x26d/0x282
 [<ffffffff811e0815>] security_transition_sid+0x1f/0x21
 [<ffffffff811d45d9>] selinux_bprm_set_creds+0xd1/0x25f
 [<ffffffff810e3510>] ? vma_link+0x88/0xb1
 [<ffffffff811d4a29>] ? selinux_vm_enough_memory+0x40/0x45
 [<ffffffff8120cc58>] ? spin_unlock_irqrestore+0x9/0xb
 [<ffffffff8120cce0>] ? __up_write+0x42/0x47
 [<ffffffff811c909d>] security_bprm_set_creds+0x13/0x15
 [<ffffffff8110cc3b>] prepare_binprm+0xc3/0xf0
 [<ffffffff8110d55e>] do_execve+0x150/0x2d2
 [<ffffffff81010eaf>] sys_execve+0x43/0x5a
 [<ffffffff8100a0ca>] stub_execve+0x6a/0xc0
Code: 83 c3 08 48 83 3b 00 eb ec 49 83 fc 10 0f 86 82 00 00 00 4c 89
e7 e8 c5 e2 ff ff 48 89 c6 48 8b 00 84 c0 78 14 66 a9 00 c0 75 04 <0f>
0b eb fe 48 89 f7 e8 ea 36 fd ff eb 5c 48 8b 4d 08 48 8b 7e
RIP  [<ffffffff810fbbde>] kfree+0x62/0xd5
 RSP <ffff88019db87c68>
---[ end trace 57f7151f6a5def07 ]---
