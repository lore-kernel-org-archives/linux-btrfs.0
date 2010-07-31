From: "Adi" <adalbert.b@gmx.de>
Subject: Re: wanted X found X-1 but you got X-2
Date: Sat, 31 Jul 2010 18:34:24 +0200
Message-ID: <20100731163424.105410@gmx.net>
References: <20100729131103.323870@gmx.net> <4C526516.30709@cn.fujitsu.com>
 <20100730071354.257500@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: "Adi" <adalbert.b@gmx.de>, liubo2009@cn.fujitsu.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100730071354.257500@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

ok, i have tried the 2.6.35-rc6 kernel, as TiCPU on #btrfs suggested, b=
ut i also got an error. i don't think it has something to do with kcryp=
t, as i can mount another partition without any problems.

hm, and btw, that dump was made on another pc.

here is a dmesg-dump:

***************************************
device fsid 184f65b363e9d585-fc67ce9a295b44a3 devid 1 transid 103380 /d=
ev/mapper/vg2-root
parent transid verify failed on 5403553792 wanted 103380 found 103378
------------[ cut here ]------------
kernel BUG at fs/btrfs/async-thread.c:603!
invalid opcode: 0000 [#1] PREEMPT=20
last sysfs file: /sys/devices/virtual/block/dm-1/dm/name
Modules linked in: btrfs

Pid: 12496, comm: kcryptd Not tainted 2.6.35-rc6 #1 MS-6382/8366-8233
EIP: 0060:[<f0de865b>] EFLAGS: 00010046 CPU: 0
EIP is at btrfs_queue_worker+0x30b/0x320 [btrfs]
EAX: 00000000 EBX: e2257b0c ECX: e2257b28 EDX: 00000003
ESI: 00000246 EDI: e2257b30 EBP: ee64bd00 ESP: e231bf54
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process kcryptd (pid: 12496, ti=3De231a000 task=3De21a77f0 task.ti=3De2=
31a000)
Stack:
 e2257b28 e2257b30 ee64bd00 dc72d61c ef239560 ef239560 c13fc670 c10d99e=
1
<0> c10d99e1 c10d99e1 c1041032 e21a796c c1040f40 00000000 c156d3ab e21a=
77f0
<0> ef239568 e21a77f0 e21a77f0 e21a79c8 00000000 e21a77f0 c10448d0 e231=
bfb0
Call Trace:
 [<c13fc670>] ? kcryptd_crypt+0x0/0x360
 [<c10d99e1>] ? bio_endio+0x11/0x30
 [<c10d99e1>] ? bio_endio+0x11/0x30
 [<c10d99e1>] ? bio_endio+0x11/0x30
 [<c1041032>] ? worker_thread+0xf2/0x230
 [<c1040f40>] ? worker_thread+0x0/0x230
 [<c156d3ab>] ? schedule+0x1ab/0x4c0
 [<c10448d0>] ? autoremove_wake_function+0x0/0x40
 [<c1040f40>] ? worker_thread+0x0/0x230
 [<c10444f4>] ? kthread+0x74/0x80
 [<c1044480>] ? kthread+0x0/0x80
 [<c1002fb6>] ? kernel_thread_helper+0x6/0x10
Code: 30 83 c3 2c 89 5d 1c 89 45 20 89 10 e9 47 ff ff ff 8d b4 26 00 00=
 00 00 8b 6c 24 08 e9 f0 fe ff ff e8 ca 51 78 d0 e9 74 fd ff ff <0f> 0b=
 8d 76 00 eb fb e8 b9 51 78 d0 e9 06 fe ff ff 8d 74 26 00=20
EIP: [<f0de865b>] btrfs_queue_worker+0x30b/0x320 [btrfs] SS:ESP 0068:e2=
31bf54
---[ end trace 8e44f3e11659c3d0 ]---
note: kcryptd[12496] exited with preempt_count 1

****************************

-------- Original-Nachricht --------
> hi,
>=20
> i used a current stable gentoo with a 2.6.34-r2 gentoo-kernel. the bt=
rfs
> filesystem is on a lvm, which is on a luks-partition.
> i think i corrupted the filesystem with a 2.6.34 tuxonice kernel, wit=
ch
> ran fine without suspend-to-disk, but after suspending i couldn't reb=
oot
> anymore.
> this debug is made on a sysrescuecd 1.5.8, after i try to btrfsck it.=
 if i
> try to mount it, the terminal hangs, but i can switch to another.
> would it help if i copy some data off the filesystem?
>=20
> ciao, adi
>=20
> > On 07/29/2010 09:11 PM, Adi wrote:
> > > hi,
> > > i have a problem with mounting a btrfspartition. i think it corru=
pted
> > somehow. btrfsck also didn't work.
> > > here is the demesg output, if i try to btrfsck it:
> > >
> > >  =20
> >=20
> > Hi, Adi
> >=20
> > can you give us some steps with which the bug can be reproduced?
> >=20
> > Thanks,
> > liubo
> >=20
> >=20
> > > ***********************************
> > >
> > > device-mapper: ioctl: unable to remove open device
> > temporary-cryptsetup-2466
> > > device fsid 184f65b363e9d585-fc67ce9a295b44a3 devid 1 transid 103=
380
> > /dev/dm-1
> > > end_request: I/O error, dev fd0, sector 0
> > > device fsid 184f65b363e9d585-fc67ce9a295b44a3 devid 1 transid 103=
380
> > /dev/mapper/vg2-root
> > > parent transid verify failed on 5403553792 wanted 103380 found 10=
3378
> > > ------------[ cut here ]------------
> > > kernel BUG at fs/btrfs/async-thread.c:602!
> > > invalid opcode: 0000 [#1] SMP=20
> > > last sysfs file: /sys/devices/virtual/bdi/btrfs-1/uevent
> > > Modules linked in: sha256_generic serpent dm_crypt ipv6 arc4 ecb =
ath5k
> > cm4000_cs ppdev mac80211 iTCO_wdt iTCO_vendor_support parport_pc at=
h
> video
> > thinkpad_acpi yenta_socket parport i2c_i801 output rsrc_nonstatic
> cfg80211
> > joydev i2c_core pcspkr rfkill raid10 raid456 async_raid6_recov asyn=
c_pq
> > raid6_pq async_xor xor async_memcpy async_tx raid1 raid0 multipath
> linear e100
> > mii floppy
> > >
> > > Pid: 2501, comm: kcryptd Not tainted 2.6.34.01-alt158-i386 #2
> > 2373189/2373189
> > > EIP: 0060:[<c06cee9a>] EFLAGS: 00010046 CPU: 0
> > > EIP is at btrfs_queue_worker+0xe7/0x1f8
> > > EAX: 00000000 EBX: f53ea04c ECX: 00000000 EDX: 00000000
> > > ESI: 00000000 EDI: f63bc5c0 EBP: f51e7e34 ESP: f51e7e14
> > >  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> > > Process kcryptd (pid: 2501, ti=3Df51e6000 task=3Df51e9520
> task.ti=3Df51e6000)
> > > Stack:
> > >  00000206 f53ea070 00000246 f53ea068 f53ea088 f53e8000 f516cd60
> 00000000
> > > <0> f51e7e40 c06abcc1 f520b850 f51e7e48 c04e804e f51e7e64 c0851a4=
0
> > 00000000
> > > <0> f526df80 f526dc80 00000000 f5365790 f51e7e84 c0851bb5 f520b85=
0
> > f5214000
> > > Call Trace:
> > >  [<c06abcc1>] ? end_workqueue_bio+0x56/0x59
> > >  [<c04e804e>] ? bio_endio+0x22/0x24
> > >  [<c0851a40>] ? dec_pending+0x124/0x12b
> > >  [<c0851bb5>] ? clone_endio+0x96/0x9e
> > >  [<c04e804e>] ? bio_endio+0x22/0x24
> > >  [<c0851a40>] ? dec_pending+0x124/0x12b
> > >  [<c0851bb5>] ? clone_endio+0x96/0x9e
> > >  [<c04e804e>] ? bio_endio+0x22/0x24
> > >  [<fa376677>] ? 0xfa376677
> > >  [<fa376ece>] ? 0xfa376ece
> > >  [<c0448c51>] ? worker_thread+0x14c/0x251
> > >  [<c0448c93>] ? worker_thread+0x18e/0x251
> > >  [<c0448c51>] ? worker_thread+0x14c/0x251
> > >  [<fa376c12>] ? 0xfa376c12
> > >  [<c044c1c1>] ? autoremove_wake_function+0x0/0x2f
> > >  [<c0448b05>] ? worker_thread+0x0/0x251
> > >  [<c044be5e>] ? kthread+0x6a/0x6f
> > >  [<c044bdf4>] ? kthread+0x0/0x6f
> > >  [<c0403abe>] ? kernel_thread_helper+0x6/0x10
> > > Code: 00 00 89 d8 e8 0e fe ff ff e9 65 ff ff ff 8b 43 1c 31 d2 3b=
 45
> ec
> > 8b 73 24 0f 95 c2 f7 da 21 d0 3b 75 e4 75 02 89 c6 85 f6 75 04 <0f>=
 0b
> eb
> > fe 83 ee 14 3e ff 46 20 8b 55 e8 8b 45 f0 e8 81 ef 24=20
> > > EIP: [<c06cee9a>] btrfs_queue_worker+0xe7/0x1f8 SS:ESP 0068:f51e7=
e14
> > > ---[ end trace 2d2977bc6fb46ae8 ]---
> > >
> > > ***********************************
> > >
> > > that was on a sysrescuecd 1.5.8.
> > > i'll try the new git-version, lets see what happens.
> > >
> > > ciao, adi
> > >  =20
>=20
> --=20
> Neu: GMX De-Mail - Einfach wie E-Mail, sicher wie ein Brief! =20
> Jetzt De-Mail-Adresse reservieren: http://portal.gmx.net/de/go/demail

--=20
GRATIS f=C3=BCr alle GMX-Mitglieder: Die maxdome Movie-FLAT!
Jetzt freischalten unter http://portal.gmx.net/de/go/maxdome
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
