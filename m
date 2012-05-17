Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:48927 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760949Ab2EQK3m (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 May 2012 06:29:42 -0400
Message-ID: <4FB4D30C.7030301@tuxadero.com>
Date: Thu, 17 May 2012 12:29:32 +0200
From: Martin Mailand <martin@tuxadero.com>
Reply-To: martin@tuxadero.com
MIME-Version: 1.0
To: Josef Bacik <josef@redhat.com>
CC: Christian Brunner <christian@brunner-muc.de>,
        Sage Weil <sage@newdream.net>, linux-btrfs@vger.kernel.org,
        ceph-devel@vger.kernel.org
Subject: Re: Ceph on btrfs 3.4rc
References: <CAJafhzSVZ3+1ApgJU=sQu6gM62BeWVGG4mqFPNYRHx79czYJtQ@mail.gmail.com> <20120424152141.GB3326@localhost.localdomain> <Pine.LNX.4.64.1204240922040.29159@cobra.newdream.net> <CAJafhzSgaQ3sx=Af0Ru0CiwQH37V5y8jgjoTo_8yozcjo9rpPA@mail.gmail.com> <20120510203523.GD2061@localhost.localdomain> <20120511133124.GB2089@localhost.localdomain> <4FAD5B7E.5040801@tuxadero.com> <20120511191623.GB3503@localhost.localdomain> <4FB11479.8060408@tuxadero.com> <20120514142048.GA3260@localhost.localdomain> <20120516192035.GA1910@localhost.localdomain>
In-Reply-To: <20120516192035.GA1910@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

somehow I still get the kernel Bug messages, I used your patch from the 
16th against rc7.

-martin

Am 16.05.2012 21:20, schrieb Josef Bacik:
> Hrm ok so I finally got some time to try and debug it and let the test run a
> good long while (5 hours almost) and I couldn't hit either the original bug or
> the one you guys were hitting.  So either my extra little bit of locking did the
> trick or I get to keep my "Worst reproducer ever" award.  Can you guys give this
> one a whirl and if it panics send the entire dmesg since it should spit out a
> WARN_ON() to let me know what I thought was the problem was it.  Thanks,

[ 2868.813236] ------------[ cut here ]------------
[ 2868.813297] kernel BUG at fs/btrfs/inode.c:2220!
[ 2868.813355] invalid opcode: 0000 [#2] SMP
[ 2868.813479] CPU 2
[ 2868.813516] Modules linked in: btrfs zlib_deflate libcrc32c ext2 
bonding coretemp ghash_clmulni_intel aesni_intel cryptd aes_x86_64 
microcode psmouse serio_raw sb_edac edac_core joydev mei(C) ses ioatdma 
enclosure mac_hid lp parport isci libsas scsi_transport_sas usbhid hid 
ixgbe igb megaraid_sas dca mdio
[ 2868.814871]
[ 2868.814925] Pid: 5325, comm: ceph-osd Tainted: G      D  C 
3.4.0-rc7+ #10 Supermicro X9SRi/X9SRi
[ 2868.815108] RIP: 0010:[<ffffffffa02212f2>]  [<ffffffffa02212f2>] 
btrfs_orphan_del+0xe2/0xf0 [btrfs]
[ 2868.815236] RSP: 0018:ffff880296e89d18  EFLAGS: 00010282
[ 2868.815294] RAX: 00000000fffffffe RBX: ffff88101ef3c390 RCX: 
0000000000562497
[ 2868.815355] RDX: 0000000000562496 RSI: ffff88101ef10000 RDI: 
ffffea00407bc400
[ 2868.815416] RBP: ffff880296e89d58 R08: 000060ef80000fd0 R09: 
ffffffffa01f8c6a
[ 2868.815476] R10: 0000000000000000 R11: 000000000000011d R12: 
ffff880fdf602790
[ 2868.815537] R13: ffff880fdf602400 R14: 0000000000000001 R15: 
0000000000000001
[ 2868.815598] FS:  00007f07d5512700(0000) GS:ffff88107fc40000(0000) 
knlGS:0000000000000000
[ 2868.815675] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2868.815734] CR2: 000000000ab16000 CR3: 000000082a6b2000 CR4: 
00000000000407e0
[ 2868.815796] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[ 2868.815858] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[ 2868.815920] Process ceph-osd (pid: 5325, threadinfo ffff880296e88000, 
task ffff8810170616e0)
[ 2868.815997] Stack:
[ 2868.816049]  0c00000000000007 ffff88101ef12960 ffff880296e89d38 
ffff88101ef12960
[ 2868.816262]  0000000000000000 ffff880fdf602400 ffff88101ef3c390 
ffff880b4ce2f260
[ 2868.816485]  ffff880296e89e08 ffffffffa0225628 ffff88101ef3c390 
0000000000000000
[ 2868.816694] Call Trace:
[ 2868.816755]  [<ffffffffa0225628>] btrfs_truncate+0x4d8/0x650 [btrfs]
[ 2868.816817]  [<ffffffff81188afd>] ? path_lookupat+0x6d/0x750
[ 2868.816880]  [<ffffffffa0227021>] btrfs_setattr+0xc1/0x1b0 [btrfs]
[ 2868.816940]  [<ffffffff811955c3>] notify_change+0x183/0x320
[ 2868.816998]  [<ffffffff8117889e>] do_truncate+0x5e/0xa0
[ 2868.817056]  [<ffffffff81178a24>] sys_truncate+0x144/0x1b0
[ 2868.817115]  [<ffffffff8165fd29>] system_call_fastpath+0x16/0x1b
[ 2868.817173] Code: e8 4c 8b 75 f0 4c 8b 7d f8 c9 c3 66 0f 1f 44 00 00 
80 bb 60 fe ff ff 84 75 b4 eb ae 0f 1f 44 00 00 48 89 df e8 50 73 fe ff 
eb b8 <0f> 0b 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 48 83 ec
[ 2868.819501] RIP  [<ffffffffa02212f2>] btrfs_orphan_del+0xe2/0xf0 [btrfs]
[ 2868.819602]  RSP <ffff880296e89d18>
[ 2868.819703] ---[ end trace 94d17b770b376c84 ]---
[ 3249.857453] ------------[ cut here ]------------
[ 3249.857481] kernel BUG at fs/btrfs/inode.c:2220!
[ 3249.857506] invalid opcode: 0000 [#3] SMP
[ 3249.857534] CPU 0
[ 3249.857538] Modules linked in: btrfs zlib_deflate libcrc32c ext2 
bonding coretemp ghash_clmulni_intel aesni_intel cryptd aes_x86_64 
microcode psmouse serio_raw sb_edac edac_core joydev mei(C) ses ioatdma 
enclosure mac_hid lp parport isci libsas scsi_transport_sas usbhid hid 
ixgbe igb megaraid_sas dca mdio
[ 3249.857721]
[ 3249.857740] Pid: 5384, comm: ceph-osd Tainted: G      D  C 
3.4.0-rc7+ #10 Supermicro X9SRi/X9SRi
[ 3249.857791] RIP: 0010:[<ffffffffa02212f2>]  [<ffffffffa02212f2>] 
btrfs_orphan_del+0xe2/0xf0 [btrfs]
[ 3249.857847] RSP: 0018:ffff880abe8b5d18  EFLAGS: 00010282
[ 3249.857873] RAX: 00000000fffffffe RBX: ffff8807eb8b6670 RCX: 
000000000077a084
[ 3249.857902] RDX: 000000000077a083 RSI: ffff88101ee497e0 RDI: 
ffffea00407b9240
[ 3249.857931] RBP: ffff880abe8b5d58 R08: 000060ef80000fd0 R09: 
ffffffffa01f8c6a
[ 3249.857959] R10: 0000000000000000 R11: 0000000000000153 R12: 
ffff880d56825390
[ 3249.857988] R13: ffff880d56825000 R14: 0000000000000001 R15: 
0000000000000001
[ 3249.858017] FS:  00007f06bd13b700(0000) GS:ffff88107fc00000(0000) 
knlGS:0000000000000000
[ 3249.858062] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3249.858088] CR2: 00000000043d2000 CR3: 0000000e7ebe5000 CR4: 
00000000000407f0
[ 3249.858117] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[ 3249.858146] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[ 3249.858175] Process ceph-osd (pid: 5384, threadinfo ffff880abe8b4000, 
task ffff880eb7a596e0)
[ 3249.858219] Stack:
[ 3249.858239]  0c00000000000002 ffff88101ede4d70 ffff880abe8b5d38 
ffff88101ede4d70
[ 3249.858288]  0000000000000000 ffff880d56825000 ffff8807eb8b6670 
ffff880546925e00
[ 3249.858338]  ffff880abe8b5e08 ffffffffa0225628 ffff8807eb8b6670 
0000000000000000
[ 3249.858387] Call Trace:
[ 3249.858415]  [<ffffffffa0225628>] btrfs_truncate+0x4d8/0x650 [btrfs]
[ 3249.858445]  [<ffffffff81188afd>] ? path_lookupat+0x6d/0x750
[ 3249.858477]  [<ffffffffa0227021>] btrfs_setattr+0xc1/0x1b0 [btrfs]
[ 3249.858505]  [<ffffffff811955c3>] notify_change+0x183/0x320
[ 3249.858533]  [<ffffffff8117889e>] do_truncate+0x5e/0xa0
[ 3249.858559]  [<ffffffff81178a24>] sys_truncate+0x144/0x1b0
[ 3249.858587]  [<ffffffff8165fd29>] system_call_fastpath+0x16/0x1b
[ 3249.858614] Code: e8 4c 8b 75 f0 4c 8b 7d f8 c9 c3 66 0f 1f 44 00 00 
80 bb 60 fe ff ff 84 75 b4 eb ae 0f 1f 44 00 00 48 89 df e8 50 73 fe ff 
eb b8 <0f> 0b 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 48 83 ec
[ 3249.858813] RIP  [<ffffffffa02212f2>] btrfs_orphan_del+0xe2/0xf0 [btrfs]
[ 3249.858852]  RSP <ffff880abe8b5d18>
[ 3249.859140] ---[ end trace 94d17b770b376c85 ]---
