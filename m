From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [PATCH v2 1/7] added helper functions to iterate backrefs
Date: Thu, 23 Jun 2011 10:20:31 +0200
Message-ID: <4E02F74F.4020504@jan-o-sch.net>
References: <cover.1308397267.git.list.btrfs@jan-o-sch.net> <4e836f2ec21820d3be2022fa2a6d6a441fdff4b8.1308397267.git.list.btrfs@jan-o-sch.net> <20110621143736.GL12709@twin.jikos.cz> <4E00B4CE.9070908@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E00B4CE.9070908@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 21.06.2011 17:12, Jan Schmidt wrote:
> On 21.06.2011 16:37, David Sterba wrote:
>> [...]
> Something is going wrong here:
> 
>> Example:
>> ipath buffer and scratch are 32K, each, ie. the overly sized
>> ref_name_len will fit there:
>>
>> [ 8766.928232] btrfs: ino2name: 266  p1/
>> [ 8767.440964] i2p: [4] namelen 10, left 32766
>> [ 8767.446417] i2p: [7] path:
>> [ 8767.450445] i2p: [4] namelen 2, left 32755
>> [ 8767.455733] i2p: [7] path: /
>> [ 8767.459834] i2p: [2] p1/
> 
> Do I get that right? This is inode 266, which should refer to
> ./p1/d6/d7/d1f/c41 (as you state below). Already on second iteration,
> we're at something named "pl", which shouldn't happen as we construct
> the path bottom-up. And those namelen 0 in the following lines shouldn't
> happen, either. Furthermore, the path should change on every iteration
> (I guess, that might depend on the printk behind, of course).
> 
>> [ 8767.463593] i2p: [4] namelen 0, left 32752
>> [ 8767.468903] i2p: [7] path:
>> [ 8767.472908] i2p: [4] namelen 2, left 32751
>> [ 8767.478188] i2p: [7] path: /
>> [ 8767.482280] i2p: [2] p1/
>> [ 8767.486024] i2p: [4] namelen 0, left 32748
>> [ 8767.491293] i2p: [7] path:
>> [ 8767.495283] i2p: [4] namelen 2, left 32747
>> [ 8767.500587] i2p: [7] path: /
>> [ 8767.504680] i2p: [2] p1/
>> [ 8767.508430] i2p: [4] namelen 0, left 32744
>> [ 8767.513708] i2p: [7] path:
>> [ 8767.517702] i2p: [4] namelen 2, left 32743
>> [ 8767.522969] i2p: [7] path: /
>> [ 8767.527042] i2p: [2] p1/
>> [ 8767.530787] i2p: [4] namelen 0, left 32740
>> [ 8767.536049] i2p: [7] path:
>> [ 8767.539991] i2p: [4] namelen 2, left 32739
>> [ 8767.545282] i2p: [7] path: /
>> [ 8767.549374] i2p: [2] p1/
>> [ 8767.553109] i2p: [4] namelen 0, left 32736
>> [ 8767.558377] i2p: [7] path:
>> [ 8767.562354] i2p: [4] namelen 2, left 32735
>> [ 8767.567615] i2p: [7] path: /
>> [ 8767.571713] i2p: [2] p1/
>> [ 8767.575443] i2p: [4] namelen 0, left 32732
>> [ 8767.580701] i2p: [7] path:
>> [ 8767.584678] i2p: [4] namelen 2, left 32731
>> [ 8767.589933] i2p: [7] path: /
>> [ 8767.594007] i2p: [2] p1/
>> [ 8767.597713] i2p: [4] namelen 0, left 32728
>> [ 8767.602908] i2p: [7] path:
>> [ 8767.606832] i2p: [4] namelen 2, left 32727
>> [ 8767.612030] i2p: [7] path: /
>> [ 8767.616050] i2p: [2] p1/
>> [ 8767.619676] i2p: [4] namelen 0, left 32724
>> [ 8767.624873] i2p: [7] path:
>> [ 8767.628782] i2p: [4] namelen 2, left 32723
>> [ 8767.633970] i2p: [7] path: /
>> [ 8767.637962] i2p: [2] p1/
>> [ 8767.641639] i2p: [4] namelen 0, left 32720
>> [ 8767.646838] i2p: [7] path:
>> [ 8767.650757] i2p: [4] namelen 2, left 32719
>> [ 8767.655952] i2p: [7] path: /
>> [ 8767.659940] i2p: [2] p1/
>> [ 8767.663604] i2p: [4] namelen 0, left 32716
>> [ 8767.668790] i2p: [7] path:
>> [ 8767.672696] i2p: [4] namelen 2, left 32715
>> [ 8767.677881] i2p: [7] path: /
>> [ 8767.681878] i2p: [2] p1/
>> [ 8767.685549] i2p: [4] namelen 0, left 32712
>> [ 8767.690742] i2p: [7] path:
>> [ 8767.694655] i2p: [4] namelen 2, left 32711
>> [ 8767.699843] i2p: [7] path: /
>> [ 8767.703840] i2p: [2] p1/
>> [ 8767.707520] i2p: [4] namelen 19967, left 32708
>> [ 8767.713057] i2p: [7] path:
>> [ 8767.716955] BUG: unable to handle kernel NULL pointer dereference at           (null)
>> [ 8767.720932] IP: [<ffffffffa005f1d2>] read_extent_buffer+0xa2/0x220 [btrfs]
>> [ 8767.720932] PGD 77bd0067 PUD 79d35067 PMD 0
>> [ 8767.720932] Oops: 0000 [#1] SMP
>> [ 8767.720932] CPU 1
>> [ 8767.720932] Modules linked in: btrfs loop
>> [ 8767.720932]
>> [ 8767.720932] Pid: 10859, comm: btrfs-ino2path Not tainted 3.0.0-rc3-default+ #75 Intel Corporation Santa Rosa platform/Matanzas
>> [ 8767.720932] RIP: 0010:[<ffffffffa005f1d2>]  [<ffffffffa005f1d2>] read_extent_buffer+0xa2/0x220 [btrfs]
>> [ 8767.720932] RSP: 0018:ffff880074acbc58  EFLAGS: 00010202
>> [ 8767.720932] RAX: 0000000000000000 RBX: 0000000000003deb RCX: 0000000000001000
>> [ 8767.720932] RDX: 00000000000001e0 RSI: 0000000000000000 RDI: 0000000000000246
>> [ 8767.720932] RBP: ffff880074acbcb8 R08: 0000000000000000 R09: 0000000000000001
>> [ 8767.720932] R10: 0000000000000000 R11: 0000000000001c04 R12: 0000000000000002
>> [ 8767.720932] R13: 0000000000000000 R14: ffff880079bac1d9 R15: ffff880074acbfd8
>> [ 8767.720932] FS:  00007f1399198740(0000) GS:ffff88007de00000(0000) knlGS:0000000000000000
>> [ 8767.720932] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> [ 8767.720932] CR2: 0000000000000000 CR3: 0000000074b13000 CR4: 00000000000006e0
>> [ 8767.720932] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> [ 8767.720932] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> [ 8767.720932] Process btrfs-ino2path (pid: 10859, threadinfo ffff880074aca000, task ffff880077085340)
>> [ 8767.720932] Stack:
>> [ 8767.720932]  ffffffffa005f282 ffffffff81b21e74 ffff88002f2ef668 0000000000000000
>> [ 8767.720932]  ffff880073f94dd8 ffff880074acbfd8 ffff8800780bd000 00000000000031c5
>> [ 8767.720932]  00000000000031c5 0000000000000104 ffff880073f94dd8 ffff880074132130
>> [ 8767.720932] Call Trace:
>> [ 8767.720932]  [<ffffffffa005f282>] ? read_extent_buffer+0x152/0x220 [btrfs]
>> [ 8767.720932]  [<ffffffff81b21e74>] ? printk+0x68/0x6c
>> [ 8767.720932]  [<ffffffffa008924d>] inode_to_path+0x10d/0x2d0 [btrfs]
>> [ 8767.720932]  [<ffffffffa0089883>] paths_from_inode+0xe3/0x120 [btrfs]
>> [ 8767.720932]  [<ffffffffa006de9f>] btrfs_ioctl+0xb5f/0xf80 [btrfs]
>> [ 8767.720932]  [<ffffffff810d3e55>] ? trace_hardirqs_on_caller+0x155/0x1a0
>> [ 8767.720932]  [<ffffffff81080e4c>] ? finish_task_switch+0x7c/0x110
>> [ 8767.720932]  [<ffffffff81080e0f>] ? finish_task_switch+0x3f/0x110
>> [ 8767.720932]  [<ffffffff81193578>] do_vfs_ioctl+0x98/0x570
>> [ 8767.720932]  [<ffffffff811828be>] ? fget_light+0x33e/0x430
>> [ 8767.720932]  [<ffffffff81b2ed3a>] ? sysret_check+0x2e/0x69
>> [ 8767.720932]  [<ffffffff81193a9f>] sys_ioctl+0x4f/0x80
>> [ 8767.720932]  [<ffffffff81b2ed02>] system_call_fastpath+0x16/0x1b
>> [ 8767.720932] Code: 66 0f 1f 84 00 00 00 00 00 48 8b 55 c0 48 8b 42 30 48 89 c6 b9 00 10 00 00 4c 29 e9 48 39 d9 48 0f 47 cb 41 83 87 44 e0 ff ff 01
>> [ 8767.720932]  8b 00 48 c1 e8 2d 48 89 c2 48 c1 ea 08 48 8b 3c d5 00 95 f7
>> [ 8767.720932] RIP  [<ffffffffa005f1d2>] read_extent_buffer+0xa2/0x220 [btrfs]
>> [ 8767.720932]  RSP <ffff880074acbc58>
>> [ 8767.720932] CR2: 0000000000000000
>> [ 8768.067994] ---[ end trace b9afe483f6289b6f ]---
>>
>> Let's see the inode 266 by hand:
>>
>> dsterba@:/mnt/sda10$ find . -inum 266
>> ./p1/d6/d7/d1f/c41
>>
>> something is wrong ...
>>
>> The file hierarchy is a leftover from fs_mark runs, directories to depth 9,
>> short names.
> 
> Sounds like I missed something. There is definitely a bug in the path
> construction or lower iteration code I added.
> 
> I used a fs_mark created btrfs for my tests as well, but those worked
> well. If you could share that file system (image or debug-tree output),
> that'd be great help debugging this.

I got that fs from David (thanks) and it turned out that there was a
silly mistake in iref_to_path() in my code. I used the wrong extent
buffer which worked only as long as INODE_ITEM and INODE_REF resided in
the same leaf.

That's fixed now and I'll send a new version later. This will also
contain a fix to find EXTENT_DATA_REF that are not inline refs but
separately in the tree (v2 will miss some paths once you have more than
6 reflinks).

Thanks,
-Jan
