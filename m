Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:39992 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751880AbeBBB3D (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Feb 2018 20:29:03 -0500
Received: by mail-wm0-f50.google.com with SMTP id v123so9242028wmd.5
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Feb 2018 17:29:03 -0800 (PST)
MIME-Version: 1.0
From: "Janos Toth F." <toth.f.janos@gmail.com>
Date: Fri, 2 Feb 2018 02:28:46 +0100
Message-ID: <CANznX5Eza4E--py7nzj+-vZB_-_Stj-_4LP=Fb2hbTkQQ7LGsA@mail.gmail.com>
Subject: Writeback errors in kernel log with Linux 4.15 (m=s=raid1, d=raid5, 5 disks)
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I started seeing these on my d=raid5 filesystem after upgrading to Linux 4.15.

Some files created since the upgrade seem to be corrupted.

The disks seem to be fine (according to btrfs device stats and
smartmontools device logs).

The rest of the Btrfs filesystems (with m=s=d=single profiles) do not
seem to have any issues but it could be linked to the specific load
the d=raid5 filesystem handles (unlikely since it's nothing too
fancy).

The mount options are (for all Btrfs filesystems on this machine):
noatime,max_inline=0,commit=300,space_cache=v2,flushoncommit

dmesg is full of these:

[12848.106644] Code: 8d 74 24 08 e8 ec fd ff ff 48 89 ee 48 89 df e8
d1 fe ff ff 48 8b 44 24 48 65 48 33 04 25 28 00 00 00 75 0b 48 83 c4
50 5b 5d c3 <0f> ff eb c0 e8 71 70 ef ff 90 53 48 c7 c3 60 62 83 9d 48
85 ff
[12848.106664] ---[ end trace bb7f6cdb25fa37db ]---
[12850.114566] WARNING: CPU: 0 PID: 7277 at fs/fs-writeback.c:2339
__writeback_inodes_sb_nr+0xc6/0xd0
[12850.114573] CPU: 0 PID: 7277 Comm: btrfs Tainted: G        W
4.15.0-gentoo #2
[12850.114575] Hardware name: Gigabyte Technology Co., Ltd. X150M-PRO
ECC/X150M-PRO ECC-CF, BIOS F22b 07/04/2017
[12850.114581] RIP: 0010:__writeback_inodes_sb_nr+0xc6/0xd0
[12850.114584] RSP: 0018:ffffa2e7c619b9c0 EFLAGS: 00010246
[12850.114588] RAX: 0000000000000000 RBX: ffff8963b99ca800 RCX: 0000000000000000
[12850.114591] RDX: 0000000000000002 RSI: 0000000000002fcf RDI: ffff8963b982a800
[12850.114593] RBP: ffffa2e7c619b9c4 R08: fffffffffffffffe R09: 0000000000000003
[12850.114596] R10: fffff2ec00094c40 R11: 000000000000008f R12: ffff89612accc400
[12850.114598] R13: ffff8963b98235b8 R14: ffff8961166a5000 R15: ffff8963b98235e0
[12850.114602] FS:  00007f9c6280c8c0(0000) GS:ffff8963bec00000(0000)
knlGS:0000000000000000
[12850.114605] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[12850.114607] CR2: 00007ffd26332e78 CR3: 000000024443a005 CR4: 00000000002606f0
[12850.114609] Call Trace:
[12850.114618]  btrfs_commit_transaction+0x776/0x860
[12850.114626]  prepare_to_merge+0x226/0x240
[12850.114632]  relocate_block_group+0x234/0x620
[12850.114638]  btrfs_relocate_block_group+0x17e/0x230
[12850.114643]  btrfs_relocate_chunk+0x2e/0xc0
[12850.114647]  btrfs_balance+0xb42/0x1270
[12850.114654]  ? terminate_walk+0x8c/0x100
[12850.114660]  btrfs_ioctl_balance+0x330/0x390
[12850.114665]  btrfs_ioctl+0x4a6/0x23da
[12850.114674]  ? __alloc_pages_nodemask+0xa9/0x130
[12850.114678]  ? do_vfs_ioctl+0x9f/0x620
[12850.114684]  ? btrfs_ioctl_get_supported_features+0x20/0x20
[12850.114687]  do_vfs_ioctl+0x9f/0x620
[12850.114692]  SyS_ioctl+0x36/0x70
[12850.114698]  ? get_vtime_delta+0x9/0x40
[12850.114702]  do_syscall_64+0x72/0x360
[12850.114707]  ? get_vtime_delta+0x9/0x40
[12850.114711]  ? get_vtime_delta+0x9/0x40
[12850.114716]  ? __vtime_account_system+0x10/0x50
[12850.114722]  entry_SYSCALL64_slow_path+0x25/0x25
[12850.114726] RIP: 0033:0x7f9c616063a7
[12850.114728] RSP: 002b:00007ffe0d33a3d8 EFLAGS: 00000206 ORIG_RAX:
0000000000000010
[12850.114733] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f9c616063a7
[12850.114735] RDX: 00007ffe0d33a470 RSI: 00000000c4009420 RDI: 0000000000000003
[12850.114738] RBP: 0000000000000003 R08: 0000000000000003 R09: 0000000000000001
[12850.114740] R10: 0000000000000559 R11: 0000000000000206 R12: 00007ffe0d33a470
[12850.114743] R13: 00007ffe0d33a470 R14: 0000000000000001 R15: 00007ffe0d33caf6
