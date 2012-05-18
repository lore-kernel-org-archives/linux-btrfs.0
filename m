Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:38456 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967306Ab2ERULY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 May 2012 16:11:24 -0400
Message-ID: <4FB6ACE5.3060204@tuxadero.com>
Date: Fri, 18 May 2012 22:11:17 +0200
From: Martin Mailand <martin@tuxadero.com>
Reply-To: martin@tuxadero.com
MIME-Version: 1.0
To: Josef Bacik <josef@redhat.com>
CC: Christian Brunner <christian@brunner-muc.de>,
        Sage Weil <sage@newdream.net>, linux-btrfs@vger.kernel.org,
        ceph-devel@vger.kernel.org
Subject: Re: Ceph on btrfs 3.4rc
References: <20120514142048.GA3260@localhost.localdomain> <20120516192035.GA1910@localhost.localdomain> <4FB4D30C.7030301@tuxadero.com> <20120517144306.GA3011@dhcp231-144.rdu.redhat.com> <4FB51577.5090100@tuxadero.com> <20120517194358.GA9846@dhcp231-144.rdu.redhat.com> <CAJafhzTQJchdd600DiEnooUH-P9ZcLvW+oEczCMNskd+Ud4BmQ@mail.gmail.com> <4FB56B21.7070800@tuxadero.com> <20120518144759.GA1892@localhost.localdomain> <4FB685C9.2050607@tuxadero.com> <20120518190105.GB1892@localhost.localdomain>
In-Reply-To: <20120518190105.GB1892@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,
now I get
[ 2081.142669] couldn't find orphan item for 2039, nlink 1, root 269, 
root being deleted no

-martin

Am 18.05.2012 21:01, schrieb Josef Bacik:
> *sigh*  ok try this, hopefully it will point me in the right direction.  Thanks,


[  126.389847] Btrfs loaded
[  126.390284] device fsid 0c9d8c6d-2982-4604-b32a-fc443c4e2c50 devid 1 
transid 4 /dev/sdc
[  126.391246] btrfs: setting nodatacow
[  126.391252] btrfs: enabling auto defrag
[  126.391254] btrfs: disk space caching is enabled
[  126.391257] btrfs flagging fs with big metadata feature
[  126.405700] device fsid e8a0dc27-8714-49bd-a14f-ac37525febb1 devid 1 
transid 4 /dev/sdd
[  126.406162] btrfs: setting nodatacow
[  126.406167] btrfs: enabling auto defrag
[  126.406170] btrfs: disk space caching is enabled
[  126.406172] btrfs flagging fs with big metadata feature
[  126.419819] device fsid f67cd977-ebf4-41f2-9821-f2989e985954 devid 1 
transid 4 /dev/sde
[  126.420198] btrfs: setting nodatacow
[  126.420206] btrfs: enabling auto defrag
[  126.420210] btrfs: disk space caching is enabled
[  126.420214] btrfs flagging fs with big metadata feature
[  127.274555] device fsid 3001355e-c2e2-46c7-9eba-dfecb441d6a6 devid 1 
transid 4 /dev/sdf
[  127.274980] btrfs: setting nodatacow
[  127.274986] btrfs: enabling auto defrag
[  127.274989] btrfs: disk space caching is enabled
[  127.274992] btrfs flagging fs with big metadata feature
[ 2081.142669] couldn't find orphan item for 2039, nlink 1, root 269, 
root being deleted no
[ 2081.142735] ------------[ cut here ]------------
[ 2081.142750] kernel BUG at fs/btrfs/inode.c:2228!
[ 2081.142766] invalid opcode: 0000 [#1] SMP
[ 2081.142786] CPU 10
[ 2081.142794] Modules linked in: btrfs zlib_deflate libcrc32c ext2 
bonding coretemp ghash_clmulni_intel aesni_intel cryptd aes_x86_64 
microcode psmouse serio_raw sb_edac edac_core joydev mei(C) ioatdma ses 
enclosure mac_hid lp parport usbhid hid megaraid_sas isci libsas 
scsi_transport_sas igb ixgbe dca mdio
[ 2081.142974]
[ 2081.142985] Pid: 2966, comm: ceph-osd Tainted: G         C 
3.4.0-rc7.2012051802+ #16 Supermicro X9SRi/X9SRi
[ 2081.143020] RIP: 0010:[<ffffffffa0269383>]  [<ffffffffa0269383>] 
btrfs_orphan_del+0x173/0x180 [btrfs]
[ 2081.143080] RSP: 0018:ffff881016d83d18  EFLAGS: 00010292
[ 2081.143096] RAX: 0000000000000062 RBX: ffff881017ad4770 RCX: 
00000000ffffffff
[ 2081.143115] RDX: 0000000000000000 RSI: 0000000000000082 RDI: 
0000000000000246
[ 2081.143134] RBP: ffff881016d83d58 R08: 0000000000000000 R09: 
0000000000000000
[ 2081.143154] R10: 0000000000000000 R11: 0000000000000116 R12: 
ffff88101e7baf90
[ 2081.143173] R13: ffff88101e7bac00 R14: 0000000000000001 R15: 
0000000000000001
[ 2081.143193] FS:  00007fcc1e736700(0000) GS:ffff88107fd40000(0000) 
knlGS:0000000000000000
[ 2081.143243] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2081.143274] CR2: 0000000009269000 CR3: 000000101ba87000 CR4: 
00000000000407e0
[ 2081.143308] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[ 2081.143341] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[ 2081.143376] Process ceph-osd (pid: 2966, threadinfo ffff881016d82000, 
task ffff881023c744a0)
[ 2081.143424] Stack:
[ 2081.143447]  0c00000000000007 ffff88101e1dac30 ffff881016d83d38 
ffff88101e1dac30
[ 2081.143510]  0000000000000000 ffff88101e7bac00 ffff881017ad4770 
ffff88101f0f7d60
[ 2081.143572]  ffff881016d83e08 ffffffffa026d7c8 ffff881017ad4770 
0000000000000000
[ 2081.143634] Call Trace:
[ 2081.143684]  [<ffffffffa026d7c8>] btrfs_truncate+0x5e8/0x6d0 [btrfs]
[ 2081.143737]  [<ffffffffa026f141>] btrfs_setattr+0xc1/0x1b0 [btrfs]
[ 2081.143773]  [<ffffffff811955c3>] notify_change+0x183/0x320
[ 2081.143807]  [<ffffffff8117889e>] do_truncate+0x5e/0xa0
[ 2081.143839]  [<ffffffff81178a24>] sys_truncate+0x144/0x1b0
[ 2081.143873]  [<ffffffff8165fd29>] system_call_fastpath+0x16/0x1b
[ 2081.143903] Code: a0 49 8b 8d f0 02 00 00 8b 53 48 4c 0f 44 c0 48 85 
f6 74 19 80 bb 60 fe ff ff 84 74 10 48 c7 c7 10 88 2c a0 31 c0 e8 e5 3b 
3e e1 <0f> 0b 48 8b 73 40 eb ea 0f 1f 44 00 00 55 48 89 e5 48 83 ec 10
[ 2081.144199] RIP  [<ffffffffa0269383>] btrfs_orphan_del+0x173/0x180 
[btrfs]
[ 2081.144258]  RSP <ffff881016d83d18>
[ 2081.144614] ---[ end trace 8d0829d100639242 ]---

