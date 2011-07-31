From: "Providence M. SALUMU" <providence.salumu@gmail.com>
Subject: kernel BUG at fs/btrfs/tree-log.c:1657!
Date: Sun, 31 Jul 2011 10:01:50 +0200
Message-ID: <CAHzCyiQs27_fX1ifnMEO=8asYZbYot794m5cFBByOnpADFAVyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi folks,

A few days back, I had a hard reset of my computer while syncing my
data with rsync -avz. I am using btrfs as the rootfs, and since then I
can't mount my filesystem anymore. mount -t btrfs segfaults!
Btrfs version in use and dmesg traces follow...

Can someone help figure out what is wrong?

Thanks and regards!

# uname -a
Linux aristote 2.6.39-gentoo-r3 #1 SMP Sat Jul 30 19:18:34 CEST 2011
x86_64 Intel(R) Core(TM) i7 CPU M 640 @ 2.80GHz GenuineIntel GNU/Linux

Btrfs Btrfs v0.19

# btrfsck /dev/sdg1
found 138016948224 bytes used err is 0
total csum bytes: 133460268
total tree bytes: 1353633792
total fs tree bytes: 859410432
btree space waste bytes: 145574086
file data blocks allocated: 136674172928
referenced 144586403840
Btrfs Btrfs v0.19


------------[ cut here ]------------
kernel BUG at fs/btrfs/tree-log.c:1657!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/devices/virtual/bdi/btrfs-3/uevent
CPU 0
[...]
Pid: 32643, comm: mount Not tainted 2.6.39-gentoo-r3 #1 innotek GmbH Vi=
rtualBox
RIP: 0010:[<ffffffffa0539942>] =C2=A0[<ffffffffa0539942>]
replay_one_buffer+0x25b/0x2b7 [btrfs]
RSP: 0018:ffff88011e03f988 =C2=A0EFLAGS: 00010282
RAX: 00000000fffffffb RBX: ffff88011e03fb38 RCX: ffff88011a40cd90
RDX: 000000000005b9cc RSI: 0000000000000001 RDI: 0000000000000292
RBP: ffff88010d36f8d8 R08: ffff88010d36f8d8 R09: ffff880101c65428
R10: ffff88011e03f9e8 R11: ffff88011e03f9e8 R12: ffff88011a40ce20
R13: ffff8800b462d800 R14: 0000000000000000 R15: ffff88011e03f9e8
=46S: =C2=A000007f053741f740(0000) GS:ffff88011fc00000(0000) knlGS:0000=
000000000000
CS: =C2=A00010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007fffc26f03b8 CR3: 0000000102fc5000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process mount (pid: 32643, threadinfo ffff88011e03e000, task ffff88011f=
6fb710)
Stack:
ffff88011e03f9f8 0000001900000004 6db6db6db6db6db7 0000160000000000
0000000000000065 0000000000000000 ffff88011dfda800 0000001ea05284bf
0000000000042657 000000000000006c 0000000000000000 ffff880100000004
Call Trace:
[<ffffffffa0536f70>] ? walk_down_log_tree+0x204/0x3eb [btrfs]
[<ffffffffa053721f>] ? walk_log_tree+0xc8/0x213 [btrfs]
[<ffffffffa05382b4>] ? btrfs_recover_log_trees+0x1d3/0x2e0 [btrfs]
[<ffffffffa05396e7>] ? replay_one_dir_item+0xbe/0xbe [btrfs]
[<ffffffffa0507b45>] ? btree_read_extent_buffer_pages+0x76/0xbc [btrfs]
[<ffffffffa050c2ab>] ? open_ctree+0x1000/0x1335 [btrfs]
[<ffffffff81240e50>] ? ida_get_new_above+0x196/0x1b7
[<ffffffff81099109>] ? sget+0x389/0x39e
[<ffffffffa04efccb>] ? btrfs_mount+0x22c/0x41d [btrfs]
[<ffffffff81080084>] ? pcpu_alloc+0x859/0x8a2
[<ffffffff81098282>] ? mount_fs+0xc/0xa6
[<ffffffff810add8a>] ? vfs_kern_mount+0x61/0x97
[<ffffffff810ade1f>] ? do_kern_mount+0x49/0xd6
[<ffffffff810ae59d>] ? do_mount+0x6f1/0x758
[<ffffffff8107ca8f>] ? memdup_user+0x36/0x52
[<ffffffff810ae68c>] ? sys_mount+0x88/0xcc
[<ffffffff813eb892>] ? system_call_fastpath+0x16/0x1b
Code: fe 74 54 85 c0 74 50 0f 0b eb fe 3c 6c 75 20 48 8b 7b 20 4d 89
f9 45 89 f0 48 89 e9 4c 89 e2 4c 89 ee e8 20 f6 ff ff 85 c0 74 2c <0f>
0b eb fe 3c 60 74 04 3c 54 75 20 48 8b 7b 20 4d 89 f9 45 89
RIP =C2=A0[<ffffffffa0539942>] replay_one_buffer+0x25b/0x2b7 [btrfs]
RSP <ffff88011e03f988>
---[ end trace 83412c652e29ad1a ]---
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
