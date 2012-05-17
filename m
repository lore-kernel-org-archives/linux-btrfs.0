Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:55655 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933231Ab2EQPNF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 May 2012 11:13:05 -0400
Message-ID: <4FB51577.5090100@tuxadero.com>
Date: Thu, 17 May 2012 17:12:55 +0200
From: Martin Mailand <martin@tuxadero.com>
Reply-To: martin@tuxadero.com
MIME-Version: 1.0
To: Josef Bacik <josef@redhat.com>
CC: Christian Brunner <christian@brunner-muc.de>,
        Sage Weil <sage@newdream.net>, linux-btrfs@vger.kernel.org,
        ceph-devel@vger.kernel.org
Subject: Re: Ceph on btrfs 3.4rc
References: <Pine.LNX.4.64.1204240922040.29159@cobra.newdream.net> <CAJafhzSgaQ3sx=Af0Ru0CiwQH37V5y8jgjoTo_8yozcjo9rpPA@mail.gmail.com> <20120510203523.GD2061@localhost.localdomain> <20120511133124.GB2089@localhost.localdomain> <4FAD5B7E.5040801@tuxadero.com> <20120511191623.GB3503@localhost.localdomain> <4FB11479.8060408@tuxadero.com> <20120514142048.GA3260@localhost.localdomain> <20120516192035.GA1910@localhost.localdomain> <4FB4D30C.7030301@tuxadero.com> <20120517144306.GA3011@dhcp231-144.rdu.redhat.com>
In-Reply-To: <20120517144306.GA3011@dhcp231-144.rdu.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,
no there was nothing above. Here the is another dmesg output.

> Was there anything above those messages?  There should have been a WARN_ON() or
> something.  If not thats fine, I just need to know one way or the other so I can
> figure out what to do next.  Thanks,
>
> Josef

-martin

[   63.027277] Btrfs loaded
[   63.027485] device fsid 266726e1-439f-4d89-a374-7ef92d355daf devid 1 
transid 4 /dev/sdc
[   63.027750] btrfs: setting nodatacow
[   63.027752] btrfs: enabling auto defrag
[   63.027753] btrfs: disk space caching is enabled
[   63.027754] btrfs flagging fs with big metadata feature
[   63.036347] device fsid 070e2c6c-2ea5-478d-bc07-7ce3a954e2e4 devid 1 
transid 4 /dev/sdd
[   63.036624] btrfs: setting nodatacow
[   63.036626] btrfs: enabling auto defrag
[   63.036627] btrfs: disk space caching is enabled
[   63.036628] btrfs flagging fs with big metadata feature
[   63.045628] device fsid 6f7b82a9-a1b7-40c6-8b00-2c2a44481066 devid 1 
transid 4 /dev/sde
[   63.045910] btrfs: setting nodatacow
[   63.045912] btrfs: enabling auto defrag
[   63.045913] btrfs: disk space caching is enabled
[   63.045914] btrfs flagging fs with big metadata feature
[   63.831278] device fsid 46890b76-45c2-4ea2-96ee-2ea88e29628b devid 1 
transid 4 /dev/sdf
[   63.831577] btrfs: setting nodatacow
[   63.831579] btrfs: enabling auto defrag
[   63.831579] btrfs: disk space caching is enabled
[   63.831580] btrfs flagging fs with big metadata feature
[ 1521.820412] ------------[ cut here ]------------
[ 1521.820424] kernel BUG at fs/btrfs/inode.c:2220!
[ 1521.820433] invalid opcode: 0000 [#1] SMP
[ 1521.820448] CPU 4
[ 1521.820452] Modules linked in: btrfs zlib_deflate libcrc32c ext2 ses 
enclosure bonding coretemp ghash_clmulni_intel aesni_intel cryptd 
aes_x86_64 psmouse microcode serio_raw sb_edac edac_core mei(C) joydev 
ioatdma mac_hid lp parport isci libsas scsi_transport_sas usbhid hid 
ixgbe igb dca megaraid_sas mdio
[ 1521.820562]
[ 1521.820567] Pid: 3095, comm: ceph-osd Tainted: G         C 
3.4.0-rc7+ #10 Supermicro X9SRi/X9SRi
[ 1521.820591] RIP: 0010:[<ffffffffa02532f2>]  [<ffffffffa02532f2>] 
btrfs_orphan_del+0xe2/0xf0 [btrfs]
[ 1521.820616] RSP: 0018:ffff881013da9d18  EFLAGS: 00010282
[ 1521.820626] RAX: 00000000fffffffe RBX: ffff881013a3b7f0 RCX: 
0000000000395dcf
[ 1521.820640] RDX: 0000000000395dce RSI: ffff88101df77480 RDI: 
ffffea004077ddc0
[ 1521.820654] RBP: ffff881013da9d58 R08: 000060ef800010d0 R09: 
ffffffffa022ac6a
[ 1521.820667] R10: 0000000000000000 R11: 000000000000010a R12: 
ffff88101e378790
[ 1521.820681] R13: ffff88101e378400 R14: 0000000000000001 R15: 
0000000000000001
[ 1521.820695] FS:  00007faa45d30700(0000) GS:ffff88107fc80000(0000) 
knlGS:0000000000000000
[ 1521.820710] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1521.820738] CR2: 00007fe0efba6010 CR3: 0000001016fec000 CR4: 
00000000000407e0
[ 1521.820767] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[ 1521.820796] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[ 1521.820825] Process ceph-osd (pid: 3095, threadinfo ffff881013da8000, 
task ffff881013da44a0)
[ 1521.820870] Stack:
[ 1521.820889]  0c00000000000005 ffff88101df9c230 ffff881013da9d38 
ffff88101df9c230
[ 1521.820939]  0000000000000000 ffff88101e378400 ffff881013a3b7f0 
ffff880c6880f840
[ 1521.820988]  ffff881013da9e08 ffffffffa0257628 ffff881013a3b7f0 
0000000000000000
[ 1521.821038] Call Trace:
[ 1521.821066]  [<ffffffffa0257628>] btrfs_truncate+0x4d8/0x650 [btrfs]
[ 1521.821096]  [<ffffffff81188afd>] ? path_lookupat+0x6d/0x750
[ 1521.821128]  [<ffffffffa0259021>] btrfs_setattr+0xc1/0x1b0 [btrfs]
[ 1521.821156]  [<ffffffff811955c3>] notify_change+0x183/0x320
[ 1521.821183]  [<ffffffff8117889e>] do_truncate+0x5e/0xa0
[ 1521.821209]  [<ffffffff81178a24>] sys_truncate+0x144/0x1b0
[ 1521.821237]  [<ffffffff8165fd29>] system_call_fastpath+0x16/0x1b
[ 1521.821265] Code: e8 4c 8b 75 f0 4c 8b 7d f8 c9 c3 66 0f 1f 44 00 00 
80 bb 60 fe ff ff 84 75 b4 eb ae 0f 1f 44 00 00 48 89 df e8 50 73 fe ff 
eb b8 <0f> 0b 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 48 83 ec
[ 1521.821458] RIP  [<ffffffffa02532f2>] btrfs_orphan_del+0xe2/0xf0 [btrfs]
[ 1521.821492]  RSP <ffff881013da9d18>
[ 1521.821758] ---[ end trace aee4c5fe92ee2a67 ]---
[ 6888.637508] btrfs: truncated 1 orphans
[ 7641.701736] ------------[ cut here ]------------
[ 7641.701764] kernel BUG at fs/btrfs/inode.c:2220!
[ 7641.701789] invalid opcode: 0000 [#2] SMP
[ 7641.701816] CPU 3
[ 7641.701819] Modules linked in: btrfs zlib_deflate libcrc32c ext2 ses 
enclosure bonding coretemp ghash_clmulni_intel aesni_intel cryptd 
aes_x86_64 psmouse microcode serio_raw sb_edac edac_core mei(C) joydev 
ioatdma mac_hid lp parport isci libsas scsi_transport_sas usbhid hid 
ixgbe igb dca megaraid_sas mdio
[ 7641.702000]
[ 7641.702030] Pid: 3064, comm: ceph-osd Tainted: G      D  C 
3.4.0-rc7+ #10 Supermicro X9SRi/X9SRi
[ 7641.702081] RIP: 0010:[<ffffffffa02532f2>]  [<ffffffffa02532f2>] 
btrfs_orphan_del+0xe2/0xf0 [btrfs]
[ 7641.702140] RSP: 0018:ffff881013c51d18  EFLAGS: 00010282
[ 7641.702166] RAX: 00000000fffffffe RBX: ffff881010871130 RCX: 
00000000013df293
[ 7641.702195] RDX: 00000000013df292 RSI: ffff88101701c1b0 RDI: 
ffffea00405c0700
[ 7641.702224] RBP: ffff881013c51d58 R08: 000060ef800010d0 R09: 
ffffffffa022ac6a
[ 7641.702253] R10: 0000000000000000 R11: 000000000000013f R12: 
ffff88101e379390
[ 7641.702282] R13: ffff88101e379000 R14: 0000000000000001 R15: 
0000000000000001
[ 7641.702311] FS:  00007fcb27307700(0000) GS:ffff88107fc60000(0000) 
knlGS:0000000000000000
[ 7641.702368] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 7641.702395] CR2: 0000000010713018 CR3: 0000001016e95000 CR4: 
00000000000407e0
[ 7641.702425] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[ 7641.702454] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[ 7641.702484] Process ceph-osd (pid: 3064, threadinfo ffff881013c50000, 
task ffff881015e35b80)
[ 7641.702529] Stack:
[ 7641.702557]  0c00000000000004 ffff88101701d820 ffff881013c51d38 
ffff88101701d820
[ 7641.702618]  0000000000000000 ffff88101e379000 ffff881010871130 
ffff880503e70b80
[ 7641.702678]  ffff881013c51e08 ffffffffa0257628 ffff881010871130 
0000000000000000
[ 7641.702729] Call Trace:
[ 7641.702761]  [<ffffffffa0257628>] btrfs_truncate+0x4d8/0x650 [btrfs]
[ 7641.702792]  [<ffffffff81188afd>] ? path_lookupat+0x6d/0x750
[ 7641.702828]  [<ffffffffa0259021>] btrfs_setattr+0xc1/0x1b0 [btrfs]
[ 7641.702858]  [<ffffffff811955c3>] notify_change+0x183/0x320
[ 7641.702886]  [<ffffffff8117889e>] do_truncate+0x5e/0xa0
[ 7641.702913]  [<ffffffff81178a24>] sys_truncate+0x144/0x1b0
[ 7641.702942]  [<ffffffff8165fd29>] system_call_fastpath+0x16/0x1b
[ 7641.702969] Code: e8 4c 8b 75 f0 4c 8b 7d f8 c9 c3 66 0f 1f 44 00 00 
80 bb 60 fe ff ff 84 75 b4 eb ae 0f 1f 44 00 00 48 89 df e8 50 73 fe ff 
eb b8 <0f> 0b 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 48 83 ec
[ 7641.703185] RIP  [<ffffffffa02532f2>] btrfs_orphan_del+0xe2/0xf0 [btrfs]
[ 7641.703224]  RSP <ffff881013c51d18>
[ 7641.703591] ---[ end trace aee4c5fe92ee2a68 ]---

