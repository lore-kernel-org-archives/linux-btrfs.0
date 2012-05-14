From: Martin Mailand <martin@tuxadero.com>
Subject: Re: Ceph on btrfs 3.4rc
Date: Mon, 14 May 2012 16:19:37 +0200
Message-ID: <4FB11479.8060408@tuxadero.com>
References: <CAJafhzSVZ3+1ApgJU=sQu6gM62BeWVGG4mqFPNYRHx79czYJtQ@mail.gmail.com> <20120424152141.GB3326@localhost.localdomain> <Pine.LNX.4.64.1204240922040.29159@cobra.newdream.net> <CAJafhzSgaQ3sx=Af0Ru0CiwQH37V5y8jgjoTo_8yozcjo9rpPA@mail.gmail.com> <20120510203523.GD2061@localhost.localdomain> <20120511133124.GB2089@localhost.localdomain> <4FAD5B7E.5040801@tuxadero.com> <20120511191623.GB3503@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Christian Brunner <christian@brunner-muc.de>,
	Sage Weil <sage@newdream.net>, linux-btrfs@vger.kernel.org,
	ceph-devel@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <20120511191623.GB3503@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

Am 11.05.2012 21:16, schrieb Josef Bacik:
> Heh duh, sorry, try this one instead.  Thanks,

With this patch I got this Bug:

[ 8233.828722] ------------[ cut here ]------------
[ 8233.828737] kernel BUG at fs/btrfs/inode.c:2217!
[ 8233.828746] invalid opcode: 0000 [#1] SMP
[ 8233.828761] CPU 1
[ 8233.828766] Modules linked in: btrfs zlib_deflate libcrc32c ses 
enclosure bonding coretemp ghash_clmulni_intel psmouse aesni_intel 
sb_edac cryptd a     es_x86_64 ext2 microcode serio_raw edac_core mei(C) 
joydev ioatdma mac_hid lp parport usbhid hid isci libsas ixgbe 
scsi_transport_sas megaraid_sas igb      dca mdio
[ 8233.828885]
[ 8233.828891] Pid: 4444, comm: ceph-osd Tainted: G        WC 
3.4.0-rc6+ #6 Supermicro X9SRi/X9SRi
[ 8233.828915] RIP: 0010:[<ffffffffa02492d2>]  [<ffffffffa02492d2>] 
btrfs_orphan_del+0xe2/0xf0 [btrfs]
[ 8233.828947] RSP: 0018:ffff88101ce53d18  EFLAGS: 00010282
[ 8233.828957] RAX: 00000000fffffffe RBX: ffff880d194e2c50 RCX: 
0000000000d0a3be
[ 8233.828971] RDX: 0000000000d0a3bd RSI: ffff88101de2a000 RDI: 
ffffea0040778a80
[ 8233.828985] RBP: ffff88101ce53d58 R08: 000060ef80000f00 R09: 
ffffffffa0220c6a
[ 8233.828999] R10: 0000000000000000 R11: 00000000000000f0 R12: 
ffff88071bb1e790
[ 8233.829029] R13: ffff88071bb1e400 R14: 0000000000000001 R15: 
0000000000000001
[ 8233.829059] FS:  00007fdfa179b700(0000) GS:ffff88107fc20000(0000) 
knlGS:0000000000000000
[ 8233.829104] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 8233.829131] CR2: 000000000c614000 CR3: 00000001df9d2000 CR4: 
00000000000407e0
[ 8233.829160] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[ 8233.829190] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[ 8233.829220] Process ceph-osd (pid: 4444, threadinfo ffff88101ce52000, 
task ffff88101b7b96e0)
[ 8233.829265] Stack:
[ 8233.829286]  0c00000000000002 ffff88101de14cd0 ffff88101ce53d38 
ffff88101de14cd0
[ 8233.829336]  0000000000000000 ffff88071bb1e400 ffff880d194e2c50 
ffff881024680620
[ 8233.829386]  ffff88101ce53e08 ffffffffa024d608 ffff880d194e2c50 
0000000000000000
[ 8233.829436] Call Trace:
[ 8233.829472]  [<ffffffffa024d608>] btrfs_truncate+0x4d8/0x650 [btrfs]
[ 8233.829503]  [<ffffffff81188afd>] ? path_lookupat+0x6d/0x750
[ 8233.829537]  [<ffffffffa024efc1>] btrfs_setattr+0xc1/0x1b0 [btrfs]
[ 8233.829567]  [<ffffffff811955c3>] notify_change+0x183/0x320
[ 8233.829595]  [<ffffffff8117889e>] do_truncate+0x5e/0xa0
[ 8233.829621]  [<ffffffff81178a24>] sys_truncate+0x144/0x1b0
[ 8233.829649]  [<ffffffff8165fd69>] system_call_fastpath+0x16/0x1b
[ 8233.829676] Code: e8 4c 8b 75 f0 4c 8b 7d f8 c9 c3 66 0f 1f 44 00 00 
80 bb 60 fe ff ff 84 75 b4 eb ae 0f 1f 44 00 00 48 89 df e8 70 73 fe ff 
eb b8      <0f> 0b 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 48 83 ec
[ 8233.829875] RIP  [<ffffffffa02492d2>] btrfs_orphan_del+0xe2/0xf0 [btrfs]
[ 8233.829914]  RSP <ffff88101ce53d18>
[ 8233.830187] ---[ end trace 46dd4a711bf2979d ]---


-martin

