From: Martin Mailand <martin@tuxadero.com>
Subject: Re: Ceph on btrfs 3.4rc
Date: Fri, 11 May 2012 20:33:34 +0200
Message-ID: <4FAD5B7E.5040801@tuxadero.com>
References: <CAJafhzSVZ3+1ApgJU=sQu6gM62BeWVGG4mqFPNYRHx79czYJtQ@mail.gmail.com> <20120424152141.GB3326@localhost.localdomain> <Pine.LNX.4.64.1204240922040.29159@cobra.newdream.net> <CAJafhzSgaQ3sx=Af0Ru0CiwQH37V5y8jgjoTo_8yozcjo9rpPA@mail.gmail.com> <20120510203523.GD2061@localhost.localdomain> <20120511133124.GB2089@localhost.localdomain>
Reply-To: martin@tuxadero.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Christian Brunner <christian@brunner-muc.de>,
	Sage Weil <sage@newdream.net>, linux-btrfs@vger.kernel.org,
	ceph-devel@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <20120511133124.GB2089@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

Am 11.05.2012 15:31, schrieb Josef Bacik:
> That previous patch was against btrfs-next, this patch is against 3.4-rc6 if you
> are on mainline.  Thanks,

I tried your patch against mainline, after a few minutes I hit this bug.

[ 1078.523655] ------------[ cut here ]------------
[ 1078.523667] kernel BUG at fs/btrfs/inode.c:2211!
[ 1078.523676] invalid opcode: 0000 [#1] SMP
[ 1078.523692] CPU 5
[ 1078.523696] Modules linked in: btrfs zlib_deflate libcrc32c mlx4_en 
bonding ext2 coretemp ghash_clmulni_intel aesni_intel cryptd aes_x86_64 
microcode psmouse serio_raw sb_edac edac_core mei(C) joydev ses ioatdma 
enclosure mac_hid lp parport isci libsas scsi_transport_sas usbhid hid 
igb megaraid_sas mlx4_core dca
[ 1078.523813]
[ 1078.523818] Pid: 4108, comm: ceph-osd Tainted: G         C 
3.4.0-rc6+ #5 Supermicro X9SRi/X9SRi
[ 1078.523841] RIP: 0010:[<ffffffffa022b2a2>]  [<ffffffffa022b2a2>] 
btrfs_orphan_del+0xb2/0xc0 [btrfs]
[ 1078.523867] RSP: 0018:ffff880ff14a5d38  EFLAGS: 00010282
[ 1078.523877] RAX: 00000000fffffffe RBX: ffff880ff004d6f0 RCX: 
0000000000117400
[ 1078.523891] RDX: 00000000001173ff RSI: ffff8810279f6ea0 RDI: 
ffffea00409e7d80
[ 1078.523905] RBP: ffff880ff14a5d58 R08: 000060ef80001400 R09: 
ffffffffa0202c6a
[ 1078.523918] R10: 0000000000000000 R11: 00000000000000ba R12: 
0000000000000001
[ 1078.523932] R13: ffff881017663c00 R14: 0000000000000001 R15: 
ffff88101776f5a0
[ 1078.523946] FS:  00007f1d2c03c700(0000) GS:ffff88107fca0000(0000) 
knlGS:0000000000000000
[ 1078.523961] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1078.523990] CR2: 00000000050f4000 CR3: 0000000ff2a57000 CR4: 
00000000000407e0
[ 1078.524019] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[ 1078.524048] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[ 1078.524077] Process ceph-osd (pid: 4108, threadinfo ffff880ff14a4000, 
task ffff880ff2aa44a0)
[ 1078.524121] Stack:
[ 1078.524141]  ffff8810279f7460 0000000000000000 ffff881017663c00 
ffff880ff004d6f0
[ 1078.524190]  ffff880ff14a5e08 ffffffffa022f5d8 ffff880ff004d6f0 
0000000000000000
[ 1078.524240]  ffff880ff14a5e18 ffffffff81188afd 0000800000000000 
0000800000001000
[ 1078.524289] Call Trace:
[ 1078.524317]  [<ffffffffa022f5d8>] btrfs_truncate+0x4d8/0x650 [btrfs]
[ 1078.524348]  [<ffffffff81188afd>] ? path_lookupat+0x6d/0x750
[ 1078.524380]  [<ffffffffa0230f91>] btrfs_setattr+0xc1/0x1b0 [btrfs]
[ 1078.524408]  [<ffffffff811955c3>] notify_change+0x183/0x320
[ 1078.524435]  [<ffffffff8117889e>] do_truncate+0x5e/0xa0
[ 1078.524461]  [<ffffffff81178a24>] sys_truncate+0x144/0x1b0
[ 1078.524489]  [<ffffffff8165fd69>] system_call_fastpath+0x16/0x1b
[ 1078.524516] Code: 8b 65 e8 4c 8b 6d f0 4c 8b 75 f8 c9 c3 0f 1f 40 00 
80 bb 60 fe ff ff 84 75 c1 eb bb 0f 1f 44 00 00 48 89 df e8 a0 73 fe ff 
eb c1 <0f> 0b 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 48 83 ec
[ 1078.524710] RIP  [<ffffffffa022b2a2>] btrfs_orphan_del+0xb2/0xc0 [btrfs]
[ 1078.524744]  RSP <ffff880ff14a5d38>
[ 1078.525013] ---[ end trace 88c92720204f7aa4 ]---


That's the drive with the broken btrfs.

[  212.843776] device fsid 28492275-01d3-4e89-9f1c-bd86057194bf devid 1 
transid 4 /dev/sdc
[  212.844630] btrfs: setting nodatacow
[  212.844637] btrfs: enabling auto defrag
[  212.844640] btrfs: disk space caching is enabled
[  212.844643] btrfs flagging fs with big metadata feature



-martin
