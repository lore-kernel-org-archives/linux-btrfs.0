Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:32995 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751485AbcLEQCf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Dec 2016 11:02:35 -0500
Received: by mail-oi0-f44.google.com with SMTP id w63so344829324oiw.0
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Dec 2016 08:02:34 -0800 (PST)
MIME-Version: 1.0
From: Gerard Saraber <gsaraber@rarcoa.com>
Date: Mon, 5 Dec 2016 10:02:32 -0600
Message-ID: <CAPsdh32UTiXhHQG7zw80YFu8t-qry=XygCeD046dUX0aQsnubA@mail.gmail.com>
Subject: BTRFS kernel OOPS 4.8.11
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a NAS with a mix of 6, 4 and 3 TB drives:

shrapnel zm # btrfs filesystem df /home/exports
Data, RAID1: total=19.59TiB, used=19.51TiB
System, RAID1: total=32.00MiB, used=2.75MiB
Metadata, RAID1: total=76.00GiB, used=74.71GiB
GlobalReserve, single: total=512.00MiB, used=0.00B
shrapnel zm # btrfs filesystem usage /home/exports
Overall:
     Device size:                  63.68TiB
     Device allocated:             39.34TiB
     Device unallocated:           24.34TiB
     Device missing:                  0.00B
     Used:                         39.17TiB
     Free (estimated):             12.25TiB      (min: 12.25TiB)
     Data ratio:                       2.00
     Metadata ratio:                   2.00
     Global reserve:              512.00MiB      (used: 0.00B)

Data,RAID1: Size:19.59TiB, Used:19.51TiB
    /dev/sda        3.99TiB
    /dev/sdb        2.21TiB
    /dev/sdc        2.21TiB
    /dev/sdd        4.00TiB
    /dev/sde        2.21TiB
    /dev/sdf        3.99TiB
    /dev/sdg        1.30TiB
    /dev/sdh        4.00TiB
    /dev/sdj        1.30TiB
    /dev/sdk        1.30TiB
    /dev/sdl        1.30TiB
    /dev/sdm        2.21TiB
    /dev/sdo        2.18TiB
    /dev/sdp        2.21TiB
    /dev/sdq        2.21TiB
    /dev/sds        1.30TiB
    /dev/sdt        1.30TiB

Metadata,RAID1: Size:76.00GiB, Used:74.71GiB
    /dev/sda       35.00GiB
    /dev/sdb        1.00GiB
    /dev/sdc        3.00GiB
    /dev/sdd       32.00GiB
    /dev/sde        3.00GiB
    /dev/sdf       35.00GiB
    /dev/sdh       29.00GiB
    /dev/sdj        2.00GiB
    /dev/sdk        1.00GiB
    /dev/sdl        1.00GiB
    /dev/sdm        2.00GiB
    /dev/sdo        4.00GiB
    /dev/sds        3.00GiB
    /dev/sdt        1.00GiB

System,RAID1: Size:32.00MiB, Used:2.75MiB
    /dev/sdd       32.00MiB
    /dev/sdf       32.00MiB

Unallocated:
    /dev/sda        1.43TiB
    /dev/sdb        1.43TiB
    /dev/sdc        1.43TiB
    /dev/sdd        1.43TiB
    /dev/sde        1.43TiB
    /dev/sdf        1.43TiB
    /dev/sdg        1.43TiB
    /dev/sdh        1.43TiB
    /dev/sdj        1.43TiB
    /dev/sdk        1.43TiB
    /dev/sdl        1.43TiB
    /dev/sdm        1.43TiB
    /dev/sdo        1.46TiB
    /dev/sdp        1.43TiB
    /dev/sdq        1.43TiB
    /dev/sds        1.43TiB
    /dev/sdt        1.43TiB

One of them keeps throwing errors, during this command, the oops happened:
# btrfs device delete /dev/sdt /home/exports


Dec 05 08:33:30 [kernel] [259785.367744] BTRFS info (device sdt): csum
failed ino 122743909 extent 1473222864896 csum 879250177 wanted 3941849660
mirror 0
Dec 05 08:33:30 [kernel] [259785.387033] ------------[ cut here
]------------
Dec 05 08:33:30 [kernel] [259785.387049] kernel BUG at
fs/btrfs/extent_io.c:2041!
Dec 05 08:33:30 [kernel] [259785.387062] invalid opcode: 0000 [#1] SMP
Dec 05 08:33:30 [kernel] [259785.387072] Modules linked in: btrfs
zlib_deflate megaraid_sas
Dec 05 08:33:30 [kernel] [259785.387096] CPU: 2 PID: 14355 Comm:
kworker/u8:11 Tainted: G        W       4.8.11 #1
Dec 05 08:33:30 [kernel] [259785.387112] Hardware name: Supermicro
X7DB8/X7DB8, BIOS 6.00 06/23/2006
Dec 05 08:33:30 [kernel] [259785.387161] Workqueue: btrfs-endio
btrfs_endio_helper [btrfs]
Dec 05 08:33:30 [kernel] [259785.387177] task: ffff88081b8e8b00 task.stack:
ffff88046b490000
Dec 05 08:33:30 [kernel] [259785.387189] RIP: 0010:[<ffffffffa0084f21>]
  [<ffffffffa0084f21>] repair_io_failure+0x221/0x250 [btrfs]
Dec 05 08:33:30 [kernel] [259785.387223] RSP: 0018:ffff88046b493c30
  EFLAGS: 00010202
Dec 05 08:33:30 [kernel] [259785.387235] RAX: 0000000000000000 RBX:
000000006b4e0140 RCX: 0000000000000000
Dec 05 08:33:30 [kernel] [259785.387250] RDX: 0000000000000000 RSI:
0000000000000000 RDI: ffff88071dddc840
Dec 05 08:33:30 [kernel] [259785.387264] RBP: ffff88046b493c90 R08:
0000015701409000 R09: ffff88071dddc840
Dec 05 08:33:30 [kernel] [259785.387280] R10: 0000000001ac0000 R11:
000000006b4e37c0 R12: ffff88046b4e30a8
Dec 05 08:33:30 [kernel] [259785.387295] R13: 0000000000000000 R14:
00001df9496b9000 R15: ffff8801471b6000
Dec 05 08:33:30 [kernel] [259785.387560] FS:  0000000000000000(0000)
GS:ffff88083fd00000(0000) knlGS:0000000000000000
Dec 05 08:33:30 [kernel] [259785.387825] CS:  0010 DS: 0000 ES: 0000 CR0:
0000000080050033
Dec 05 08:33:30 [kernel] [259785.387962] CR2: 000000000226f000 CR3:
0000000255358000 CR4: 00000000000006e0
Dec 05 08:33:30 [kernel] [259785.388002] Stack:
Dec 05 08:33:30 [kernel] [259785.388002]  000000000283e000 ffff880703f4a370
0000000000001000 ffffea001d05ff40
Dec 05 08:33:30 [kernel] [259785.388002]  0000000000001000 0000000000007000
ffff88071dddc840 ffff880703f4a180
Dec 05 08:33:30 [kernel] [259785.388002]  000000000283e000 ffff8801471b6000
ffff880703f4a370 ffff880703f4a1e8
Dec 05 08:33:30 [kernel] [259785.388002] Call Trace:
Dec 05 08:33:30 [kernel] [259785.388002]  [<ffffffffa0085166>]
clean_io_failure+0x136/0x150 [btrfs]
Dec 05 08:33:30 [kernel] [259785.388002]  [<ffffffffa00858ee>]
end_bio_extent_readpage+0x2be/0x510 [btrfs]
Dec 05 08:33:30 [kernel] [259785.388002]  [<ffffffff813d9611>]
bio_endio+0x51/0x60
Dec 05 08:33:30 [kernel] [259785.388002]  [<ffffffffa005ab27>]
end_workqueue_fn+0x37/0x40 [btrfs]
Dec 05 08:33:30 [kernel] [259785.388002]  [<ffffffffa0096c22>]
btrfs_scrubparity_helper+0xc2/0x300 [btrfs]
Dec 05 08:33:30 [kernel] [259785.388002]  [<ffffffffa0096f49>]
btrfs_endio_helper+0x9/0x10 [btrfs]
Dec 05 08:33:30 [kernel] [259785.388002]  [<ffffffff810d78b6>]
process_one_work+0x146/0x4a0
Dec 05 08:33:30 [kernel] [259785.388002]  [<ffffffff810d7c53>]
worker_thread+0x43/0x4d0
Dec 05 08:33:30 [kernel] [259785.388002]  [<ffffffff81a96af7>] ?
__schedule+0x247/0x670
Dec 05 08:33:30 [kernel] [259785.388002]  [<ffffffff810d7c10>] ?
process_one_work+0x4a0/0x4a0
                 - Last output repeated twice -
Dec 05 08:33:30 [kernel] [259785.388002]  [<ffffffff810dd164>]
kthread+0xc4/0xe0
Dec 05 08:33:30 [kernel] [259785.388002]  [<ffffffff81a9ad3f>]
ret_from_fork+0x1f/0x40
Dec 05 08:33:30 [kernel] [259785.388002]  [<ffffffff810dd0a0>] ?
__kthread_parkme+0x70/0x70
Dec 05 08:33:30 [kernel] [259785.388002] Code: 41 bd fb ff ff ff e9 6b fe
ff ff be 01 00 00 00 4c 89 ff 41 bd fb ff ff ff e8 bc 4f 05 00 4c 89 e7 e8
74 46 35 e1 e9 4b fe ff ff <0f> 0b be 01 00 00 00 4c 89 ff 41 bd fb ff ff
ff e8 9a 4f 05 00
