Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:33838 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965144Ab2ERRYf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 May 2012 13:24:35 -0400
Message-ID: <4FB685C9.2050607@tuxadero.com>
Date: Fri, 18 May 2012 19:24:25 +0200
From: Martin Mailand <martin@tuxadero.com>
Reply-To: martin@tuxadero.com
MIME-Version: 1.0
To: Josef Bacik <josef@redhat.com>
CC: Christian Brunner <christian@brunner-muc.de>,
        Sage Weil <sage@newdream.net>, linux-btrfs@vger.kernel.org,
        ceph-devel@vger.kernel.org
Subject: Re: Ceph on btrfs 3.4rc
References: <20120511191623.GB3503@localhost.localdomain> <4FB11479.8060408@tuxadero.com> <20120514142048.GA3260@localhost.localdomain> <20120516192035.GA1910@localhost.localdomain> <4FB4D30C.7030301@tuxadero.com> <20120517144306.GA3011@dhcp231-144.rdu.redhat.com> <4FB51577.5090100@tuxadero.com> <20120517194358.GA9846@dhcp231-144.rdu.redhat.com> <CAJafhzTQJchdd600DiEnooUH-P9ZcLvW+oEczCMNskd+Ud4BmQ@mail.gmail.com> <4FB56B21.7070800@tuxadero.com> <20120518144759.GA1892@localhost.localdomain>
In-Reply-To: <20120518144759.GA1892@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,
there was one line before the bug.

[  995.725105] couldn't find orphan item for 524


Am 18.05.2012 16:48, schrieb Josef Bacik:
> Ok hopefully this will print something out that makes sense.  Thanks,

-martin

[  241.754693] Btrfs loaded
[  241.755148] device fsid 43c4ebd9-3824-4b07-a710-3ec39b012759 devid 1 
transid 4 /dev/sdc
[  241.755750] btrfs: setting nodatacow
[  241.755753] btrfs: enabling auto defrag
[  241.755754] btrfs: disk space caching is enabled
[  241.755755] btrfs flagging fs with big metadata feature
[  241.768683] device fsid e7e7f2df-6a4e-45b1-85cc-860cda849953 devid 1 
transid 4 /dev/sdd
[  241.769028] btrfs: setting nodatacow
[  241.769030] btrfs: enabling auto defrag
[  241.769031] btrfs: disk space caching is enabled
[  241.769032] btrfs flagging fs with big metadata feature
[  241.781360] device fsid 203fdd4c-baac-49f8-bfdb-08486c937989 devid 1 
transid 4 /dev/sde
[  241.781854] btrfs: setting nodatacow
[  241.781859] btrfs: enabling auto defrag
[  241.781861] btrfs: disk space caching is enabled
[  241.781864] btrfs flagging fs with big metadata feature
[  242.713741] device fsid 95c36e12-0098-48d7-a08d-9d54a299206b devid 1 
transid 4 /dev/sdf
[  242.714110] btrfs: setting nodatacow
[  242.714118] btrfs: enabling auto defrag
[  242.714121] btrfs: disk space caching is enabled
[  242.714125] btrfs flagging fs with big metadata feature
[  995.725105] couldn't find orphan item for 524
[  995.725126] ------------[ cut here ]------------
[  995.725134] kernel BUG at fs/btrfs/inode.c:2227!
[  995.725143] invalid opcode: 0000 [#1] SMP
[  995.725158] CPU 0
[  995.725162] Modules linked in: btrfs zlib_deflate libcrc32c ext2 
coretemp ghash_clmulni_intel aesni_intel bonding cryptd aes_x86_64 
microcode psmouse serio_raw sb_edac edac_core joydev mei(C) ses ioatdma 
enclosure mac_hid lp parport ixgbe usbhid hid isci libsas megaraid_sas 
scsi_transport_sas igb dca mdio
[  995.725285]
[  995.725290] Pid: 2972, comm: ceph-osd Tainted: G         C 
3.4.0-rc7.2012051800+ #14 Supermicro X9SRi/X9SRi
[  995.725324] RIP: 0010:[<ffffffffa028535f>]  [<ffffffffa028535f>] 
btrfs_orphan_del+0x14f/0x160 [btrfs]
[  995.725354] RSP: 0018:ffff881016ed9d18  EFLAGS: 00010292
[  995.725364] RAX: 0000000000000037 RBX: ffff88101485fdb0 RCX: 
00000000ffffffff
[  995.725378] RDX: 0000000000000000 RSI: 0000000000000082 RDI: 
0000000000000246
[  995.725392] RBP: ffff881016ed9d58 R08: 0000000000000000 R09: 
0000000000000000
[  995.725405] R10: 0000000000000000 R11: 00000000000000b6 R12: 
ffff88101efe9f90
[  995.725419] R13: ffff88101efe9c00 R14: 0000000000000001 R15: 
0000000000000001
[  995.725433] FS:  00007f58e5dbc700(0000) GS:ffff88107fc00000(0000) 
knlGS:0000000000000000
[  995.725466] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  995.725492] CR2: 0000000003f28000 CR3: 000000101acac000 CR4: 
00000000000407f0
[  995.725522] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  995.725551] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[  995.725581] Process ceph-osd (pid: 2972, threadinfo ffff881016ed8000, 
task ffff881016180000)
[  995.725626] Stack:
[  995.725646]  0c00000000000002 ffff88101deaf550 ffff881016ed9d38 
ffff88101deaf550
[  995.725700]  0000000000000000 ffff88101efe9c00 ffff88101485fdb0 
ffff880be890c1e0
[  995.725757]  ffff881016ed9e08 ffffffffa02897a8 ffff88101485fdb0 
0000000000000000
[  995.725807] Call Trace:
[  995.725835]  [<ffffffffa02897a8>] btrfs_truncate+0x5e8/0x6d0 [btrfs]
[  995.725869]  [<ffffffffa028b121>] btrfs_setattr+0xc1/0x1b0 [btrfs]
[  995.725898]  [<ffffffff811955c3>] notify_change+0x183/0x320
[  995.725925]  [<ffffffff8117889e>] do_truncate+0x5e/0xa0
[  995.725951]  [<ffffffff81178a24>] sys_truncate+0x144/0x1b0
[  995.725979]  [<ffffffff8165fd29>] system_call_fastpath+0x16/0x1b
[  995.726006] Code: 45 31 ff e9 3c ff ff ff 48 8b b3 58 fe ff ff 48 85 
f6 74 19 80 bb 60 fe ff ff 84 74 10 48 c7 c7 08 48 2e a0 31 c0 e8 09 7c 
3c e1 <0f> 0b 48 8b 73 40 eb ea 66 0f 1f 84 00 00 00 00 00 55 48 89 e5
[  995.726221] RIP  [<ffffffffa028535f>] btrfs_orphan_del+0x14f/0x160 
[btrfs]
[  995.726258]  RSP <ffff881016ed9d18>
[  995.726574] ---[ end trace 4bde8f513a6d106d ]---

