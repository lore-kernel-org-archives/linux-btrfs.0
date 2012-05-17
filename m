Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47930 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758046Ab2EQUya (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 May 2012 16:54:30 -0400
Received: by yhmm54 with SMTP id m54so2311055yhm.19
        for <linux-btrfs@vger.kernel.org>; Thu, 17 May 2012 13:54:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120517194358.GA9846@dhcp231-144.rdu.redhat.com>
References: <20120510203523.GD2061@localhost.localdomain>
	<20120511133124.GB2089@localhost.localdomain>
	<4FAD5B7E.5040801@tuxadero.com>
	<20120511191623.GB3503@localhost.localdomain>
	<4FB11479.8060408@tuxadero.com>
	<20120514142048.GA3260@localhost.localdomain>
	<20120516192035.GA1910@localhost.localdomain>
	<4FB4D30C.7030301@tuxadero.com>
	<20120517144306.GA3011@dhcp231-144.rdu.redhat.com>
	<4FB51577.5090100@tuxadero.com>
	<20120517194358.GA9846@dhcp231-144.rdu.redhat.com>
Date: Thu, 17 May 2012 22:54:29 +0200
Message-ID: <CAJafhzTQJchdd600DiEnooUH-P9ZcLvW+oEczCMNskd+Ud4BmQ@mail.gmail.com>
Subject: Re: Ceph on btrfs 3.4rc
From: Christian Brunner <christian@brunner-muc.de>
To: Josef Bacik <josef@redhat.com>
Cc: Martin Mailand <martin@tuxadero.com>, Sage Weil <sage@newdream.net>,
        linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2012/5/17 Josef Bacik <josef@redhat.com>:
> On Thu, May 17, 2012 at 05:12:55PM +0200, Martin Mailand wrote:
>> Hi Josef,
>> no there was nothing above. Here the is another dmesg output.
>>
>
> Hrm ok give this a try and hopefully this is it, still couldn't reproduce.
> Thanks,
>
> Josef

Well, I hate to say it, but the new patch doesn't seem to change much...

Regards,
Christian

[  123.507444] Btrfs loaded
[  202.683630] device fsid 2aa7531c-0e3c-4955-8542-6aed7ab8c1a2 devid
1 transid 4 /dev/sda
[  202.693704] btrfs: use lzo compression
[  202.697999] btrfs: enabling inode map caching
[  202.702989] btrfs: enabling auto defrag
[  202.707190] btrfs: disk space caching is enabled
[  202.712721] btrfs flagging fs with big metadata feature
[  207.839761] device fsid f81ff6a1-c333-4daf-989f-a28139f15f08 devid
1 transid 4 /dev/sdb
[  207.849681] btrfs: use lzo compression
[  207.853987] btrfs: enabling inode map caching
[  207.858970] btrfs: enabling auto defrag
[  207.863173] btrfs: disk space caching is enabled
[  207.868635] btrfs flagging fs with big metadata feature
[  210.857328] device fsid 9b905faa-f4fa-4626-9cae-2cd0287b30f7 devid
1 transid 4 /dev/sdc
[  210.867265] btrfs: use lzo compression
[  210.871560] btrfs: enabling inode map caching
[  210.876550] btrfs: enabling auto defrag
[  210.880757] btrfs: disk space caching is enabled
[  210.886228] btrfs flagging fs with big metadata feature
[  214.296287] device fsid f7990e4c-90b0-4691-9502-92b60538574a devid
1 transid 4 /dev/sdd
[  214.306510] btrfs: use lzo compression
[  214.310855] btrfs: enabling inode map caching
[  214.315905] btrfs: enabling auto defrag
[  214.320174] btrfs: disk space caching is enabled
[  214.325706] btrfs flagging fs with big metadata feature
[ 1337.937379] ------------[ cut here ]------------
[ 1337.942526] kernel BUG at fs/btrfs/inode.c:2224!
[ 1337.947671] invalid opcode: 0000 [#1] SMP
[ 1337.952255] CPU 5
[ 1337.954300] Modules linked in: btrfs zlib_deflate libcrc32c xfs
exportfs sunrpc bonding ipv6 sg pcspkr serio_raw iTCO_wdt
iTCO_vendor_support iomemory_vsl(PO) ixgbe dca mdio i7core_edac
edac_core hpsa squashfs [last unloaded: scsi_wait_scan]
[ 1337.978570]
[ 1337.980230] Pid: 6812, comm: ceph-osd Tainted: P           O
3.3.5-1.fits.1.el6.x86_64 #1 HP ProLiant DL180 G6
[ 1337.991592] RIP: 0010:[<ffffffffa035675c>]  [<ffffffffa035675c>]
btrfs_orphan_del+0x14c/0x150 [btrfs]
[ 1338.001897] RSP: 0018:ffff8805e1171d38  EFLAGS: 00010282
[ 1338.007815] RAX: 00000000fffffffe RBX: ffff88061c3c8400 RCX: 0000000000b37f48
[ 1338.015768] RDX: 0000000000b37f47 RSI: ffff8805ec2a1cf0 RDI: ffffea0017b0a840
[ 1338.023724] RBP: ffff8805e1171d68 R08: 000060f9d88028a0 R09: ffffffffa033016a
[ 1338.031675] R10: 0000000000000000 R11: 0000000000000004 R12: ffff8805de7f57a0
[ 1338.039629] R13: 0000000000000001 R14: 0000000000000001 R15: ffff8805ec2a5280
[ 1338.047584] FS:  00007f4bffc6e700(0000) GS:ffff8806272a0000(0000)
knlGS:0000000000000000
[ 1338.056600] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1338.063003] CR2: ffffffffff600400 CR3: 00000005e34c3000 CR4: 00000000000006e0
[ 1338.070954] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1338.078909] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1338.086865] Process ceph-osd (pid: 6812, threadinfo
ffff8805e1170000, task ffff88060fa81940)
[ 1338.096268] Stack:
[ 1338.098509]  ffff8805e1171d68 ffff8805ec2a5280 ffff88051235b920
0000000000000000
[ 1338.106795]  ffff88051235b920 0000000000080000 ffff8805e1171e08
ffffffffa036043c
[ 1338.115082]  0000000000000000 0000000000000000 0000000000000000
0001000000001000
[ 1338.123367] Call Trace:
[ 1338.126111]  [<ffffffffa036043c>] btrfs_truncate+0x5bc/0x640 [btrfs]
[ 1338.133213]  [<ffffffffa03605b6>] btrfs_setattr+0xf6/0x1a0 [btrfs]
[ 1338.140105]  [<ffffffff811816fb>] notify_change+0x18b/0x2b0
[ 1338.146320]  [<ffffffff81276541>] ? selinux_inode_permission+0xd1/0x130
[ 1338.153699]  [<ffffffff81165f44>] do_truncate+0x64/0xa0
[ 1338.159527]  [<ffffffff81172669>] ? inode_permission+0x49/0x100
[ 1338.166128]  [<ffffffff81166197>] sys_truncate+0x137/0x150
[ 1338.172244]  [<ffffffff8158b1e9>] system_call_fastpath+0x16/0x1b
[ 1338.178936] Code: 89 e7 e8 88 7d fe ff eb 89 66 0f 1f 44 00 00 be
a4 08 00 00 48 c7 c7 59 49 3b a0 45 31 ed e8 5c 78 cf e0 45 31 f6 e9
30 ff ff ff <0f> 0b eb fe 55 48 89 e5 48 83 ec 40 48 89 5d d8 4c 89 65
e0 4c
[ 1338.200623] RIP  [<ffffffffa035675c>] btrfs_orphan_del+0x14c/0x150 [btrfs]
[ 1338.208317]  RSP <ffff8805e1171d38>
[ 1338.212681] ---[ end trace 86be14f0f863ea79 ]---
