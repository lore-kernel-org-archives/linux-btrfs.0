Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from manchmal.in-ulm.de ([217.10.9.201]:56974 "EHLO
	manchmal.in-ulm.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbbFTO7a (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Jun 2015 10:59:30 -0400
Date: Sat, 20 Jun 2015 16:53:24 +0200
From: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
To: linux-btrfs@vger.kernel.org
Subject: NULL pointer dereference during snapshot removal
Message-ID: <1434811494@msgid.manchmal.in-ulm.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="cvVnyQ+4j833TQvp"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--cvVnyQ+4j833TQvp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi there,

I'm having trouble with btrfs where removing a snapshot causes a
kernel Oops at blk_get_backing_dev_info+0x10/0x1c (plus or minus a
byte bytes). Is this a known issue? Else I'll dig further. Stack
traces below.

In general these snapshot operations work as expected. In a specific
setup they fail every time. I can try to trim this down to a simple
and public reproducer but I expect this will take some time. Basically
this is a private Debian buildd using sbuild/schroot with btrfs
snapshots. Building a certain package results in the trouble. That
package is not public but does a lot of nasty things during the build,
including probing block devices[1]. The build runs as expected, the
cleanup however does not.

* btrfs-tools is v3.17
* kernel is the latest 4.0.x stable series. Note even yesterday's=20
  4.0.6-rc1 is affected.
* userland is both Debian wheezy and jessie
* the build chroot is Debian jessie, Debian wheezy is not affected

    Christoph

[1] Those who are familiar with sbuild: Build dependencies include
    dmsetup, lvm2, mdadm, and udev. Starting daemons is disabled
    by an according policy-rd.d sniplet but I expect somebody isn't
    playing nice here. An still, this must not affect btrfs is such a
    way.

Unable to handle kernel NULL pointer dereference at virtual address 00000204
pgd =3D ec0b8000
[00000204] *pgd=3D6e22f831, *pte=3D00000000, *ppte=3D00000000
Internal error: Oops: 17 [#1] SMP ARM
Modules linked in: nfsd btrfs xor raid6_pq sunxi_sid
CPU: 1 PID: 7351 Comm: btrfs Not tainted 4.0.6-rc1 #1
Hardware name: Allwinner sun7i (A20) Family
task: eca16040 ti: e1022000 task.ti: e1022000
PC is at blk_get_backing_dev_info+0x10/0x1c
LR is at inode_to_bdi+0x38/0x48
pc : [<c02df05c>]    lr : [<c012b794>]    psr: 20070013
sp : e1023b60  ip : e1023b70  fp : e1023b6c
r10: e16e51c8  r9 : 7fffffff  r8 : ffffffff
r7 : 00000000  r6 : 00000000  r5 : edc03890  r4 : ee027000
r3 : 00000000  r2 : 00000000  r1 : 7fffffff  r0 : edc03800
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 10c5387d  Table: 6c0b806a  DAC: 00000015
Process btrfs (pid: 7351, stack limit =3D 0xe1022218)
Stack: (0xe1023b60 to 0xe1024000)
3b60: e1023b84 e1023b70 c012b794 c02df058 00000000 edc03964 e1023bbc e1023b=
88
3b80: c00bd708 c012b768 7fffffff 00000000 00000000 00000000 ffffffff 7fffff=
ff
3ba0: 00000001 00000000 ffffffff 7fffffff e1023be4 e1023bc0 c00be5c0 c00bd6=
d0
3bc0: ffffffff 7fffffff 00000001 e58a2910 e16e51c8 7fffffff e1023c14 e1023b=
e8
3be0: bf14d354 c00be5a8 ffffffff 7fffffff 00000000 ffffffff fffffffe ffffff=
ff
3c00: 00000000 e16e50b0 e1023c5c e1023c18 bf1530b8 bf14d334 ffffffff 7fffff=
ff
3c20: ffffffff 7fffffff 00000000 00000000 ffffffff 00000000 e16e51c8 ffffff=
ff
3c40: ffffffff 00000000 e16e50b0 e16e50cc e1023ccc e1023c60 bf140e1c bf1530=
28
3c60: ffffffff ffffffff e1023cb4 e1023c78 c012ae1c c005e134 e16e5234 000000=
07
3c80: 00000000 00000000 00001000 ec5f7800 e1023c90 e1023c90 c09ca300 e16e51=
c8
3ca0: e16e5270 e16e51c8 e16e5270 c09ca300 bf1c28d4 0000015e 00000000 ec5f78=
00
3cc0: e1023cec e1023cd0 c011e338 bf140ba0 e16e51c8 ed4ba800 e16e5218 bf1c28=
d4
3ce0: e1023d0c e1023cf0 c011eed4 c011e294 e16e513c ec5f7b50 e16e51c8 000000=
00
3d00: e1023d3c e1023d10 bf14132c c011ed5c 2dc0a000 ec942000 ec645000 ec5f78=
00
3d20: eb04fc38 eb0b9920 ec826dc0 00000000 e1023dcc e1023d40 bf173e88 bf1411=
7c
3d40: 00000139 00000000 ea52f388 00000038 c0a15380 ec5f7800 eb04fc38 ec5f7b=
68
3d60: ede805d8 c00c3794 eb0b9990 ede6abd8 ec645000 00000004 00000000 000000=
00
3d80: 00000000 00000000 ed9f6600 00060006 00070001 00000000 00000000 000000=
00
3da0: 00024800 ede6ab68 ec826dc0 ec645000 5000940f ede6ab68 bea3d7a8 ec826d=
c0
3dc0: e1023ef4 e1023dd0 bf177408 bf1738c8 c09cb880 ee02fe00 eea7adb4 ed81d7=
78
3de0: eea7adb4 ed81d740 eea7adb4 0136c000 ed81d778 eea7adb4 e1023e1c e1023e=
08
3e00: 00000103 ed5553f8 0136c000 ed81d778 e1023eb4 e1023e20 c00e11e0 c001d3=
b4
3e20: 00000024 ec826dc0 00000000 00000000 ede6ab68 e1023e40 c0110680 ec826d=
c0
3e40: e1023ed0 e1023f5c ec0b8048 00000000 00000040 000005b0 0000016c 000000=
09
3e60: c0112e54 c010e3e4 e1023e94 b6dd0000 e1023f40 bea3d6b0 00000079 e9dd17=
40
3e80: e1023fb0 ee02fe00 e1023eb4 e1023fb0 ed81d740 eca16040 0136c0e4 ed5553=
f8
3ea0: ed81d77c 00000817 e1023f04 e1023eb8 c001c8f8 c0060268 e1023f4c e1023e=
c8
3ec0: c0113e88 c0112dc8 00000043 ede6ab68 ec826dc0 bea3d7a8 5000940f 000000=
03
3ee0: e1022000 00000000 e1023f7c e1023ef8 c011607c bf175fd8 e1023fac e1023f=
08
3f00: c0008588 c001c79c ede6ab68 40000020 c09cbc34 ec942000 ec942000 ec826d=
c0
3f20: 40000020 ede6ab68 e1023f4c e1023f38 c01134c4 c00f8348 eca16040 000000=
03
3f40: e1023f94 e1023f50 e1023f7c e1023f58 c0114f00 c0121254 ec826dc0 ec826d=
c0
3f60: bea3d7a8 5000940f 00000003 e1022000 e1023fa4 e1023f80 c0116670 c01160=
08
3f80: bea3d7a8 0006f000 00000000 00000003 00000036 c000f528 00000000 e1023f=
a8
3fa0: c000f360 c011663c 0006f000 00000000 00000003 5000940f bea3d7a8 bea3d7=
a8
3fc0: 0006f000 00000000 00000003 00000036 01364068 0136407f bea3eab7 013640=
10
3fe0: b6df3ed1 bea3d734 0001b1f3 b6df3ed6 80070030 00000003 72657270 202020=
6d
Backtrace:=20
[<c02df04c>] (blk_get_backing_dev_info) from [<c012b794>] (inode_to_bdi+0x3=
8/0x48)
[<c012b75c>] (inode_to_bdi) from [<c00bd708>] (__filemap_fdatawrite_range+0=
x44/0x68)
 r5:edc03964 r4:00000000
[<c00bd6c4>] (__filemap_fdatawrite_range) from [<c00be5c0>] (filemap_fdataw=
rite_range+0x24/0x2c)
 r5:7fffffff r4:ffffffff
[<c00be59c>] (filemap_fdatawrite_range) from [<bf14d354>] (btrfs_fdatawrite=
_range+0x2c/0x60 [btrfs])
 r5:7fffffff r4:e16e51c8
[<bf14d328>] (btrfs_fdatawrite_range [btrfs]) from [<bf1530b8>] (btrfs_wait=
_ordered_range+0x9c/0x180 [btrfs])
 r9:e16e50b0 r8:00000000 r7:ffffffff r6:fffffffe r4:ffffffff
[<bf15301c>] (btrfs_wait_ordered_range [btrfs]) from [<bf140e1c>] (btrfs_ev=
ict_inode+0x288/0x5dc [btrfs])
 r10:e16e50cc r9:e16e50b0 r8:00000000 r7:ffffffff r6:ffffffff r5:e16e51c8
 r4:00000000
[<bf140b94>] (btrfs_evict_inode [btrfs]) from [<c011e338>] (evict+0xb0/0x18=
0)
 r10:ec5f7800 r9:00000000 r8:0000015e r7:bf1c28d4 r6:c09ca300 r5:e16e5270
 r4:e16e51c8
[<c011e288>] (evict) from [<c011eed4>] (iput+0x184/0x1e4)
 r7:bf1c28d4 r6:e16e5218 r5:ed4ba800 r4:e16e51c8
[<c011ed50>] (iput) from [<bf14132c>] (btrfs_invalidate_inodes+0x1bc/0x264 =
[btrfs])
 r7:00000000 r6:e16e51c8 r5:ec5f7b50 r4:e16e513c
[<bf141170>] (btrfs_invalidate_inodes [btrfs]) from [<bf173e88>] (btrfs_ioc=
tl_snap_destroy+0x5cc/0x80c [btrfs])
 r10:00000000 r9:ec826dc0 r8:eb0b9920 r7:eb04fc38 r6:ec5f7800 r5:ec645000
 r4:ec942000 r3:2dc0a000
[<bf1738bc>] (btrfs_ioctl_snap_destroy [btrfs]) from [<bf177408>] (btrfs_io=
ctl+0x143c/0x2a6c [btrfs])
 r10:ec826dc0 r9:bea3d7a8 r8:ede6ab68 r7:5000940f r6:ec645000 r5:ec826dc0
 r4:ede6ab68
[<bf175fcc>] (btrfs_ioctl [btrfs]) from [<c011607c>] (do_vfs_ioctl+0x80/0x6=
34)
 r10:00000000 r9:e1022000 r8:00000003 r7:5000940f r6:bea3d7a8 r5:ec826dc0
 r4:ede6ab68
[<c0115ffc>] (do_vfs_ioctl) from [<c0116670>] (SyS_ioctl+0x40/0x5c)
 r9:e1022000 r8:00000003 r7:5000940f r6:bea3d7a8 r5:ec826dc0 r4:ec826dc0
[<c0116630>] (SyS_ioctl) from [<c000f360>] (ret_fast_syscall+0x0/0x3c)
 r8:c000f528 r7:00000036 r6:00000003 r5:00000000 r4:0006f000 r3:bea3d7a8
Code: e1a0c00d e92dd800 e24cb004 e590305c (e5930204)=20
---[ end trace 676778a94c6e90af ]---

Same on amd64:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000348
IP: [<ffffffff812f518c>] blk_get_backing_dev_info+0xc/0x20
PGD 11c0d6067 PUD 11fda7067 PMD 0=20
Oops: 0000 [#1] PREEMPT SMP=20
Modules linked in: smsc75xx usbnet mii sg uvcvideo ctr ccm bnep rfcomm blue=
tooth binfmt_misc quota_v2 quota_tree nbd bridge stp llc kvm_intel dummy bt=
rfs xor arc4 videobuf2_vmalloc videobuf2_memops iwldvm raid6_pq videobuf2_c=
ore mac80211 v4l2_common snd_hda_codec_hdmi videodev snd_hda_codec_conexant=
 e1000e ptp snd_hda_codec_generic pps_core joydev snd_hda_intel snd_hda_con=
troller snd_hda_codec iwlwifi cfg80211 i2c_i801 [last unloaded: uvcvideo]
CPU: 3 PID: 601834 Comm: btrfs Not tainted 4.0.5 #1
task: ffff8800054a3370 ti: ffff880130bfc000 task.ti: ffff880130bfc000
RIP: 0010:[<ffffffff812f518c>]  [<ffffffff812f518c>] blk_get_backing_dev_in=
fo+0xc/0x20
RSP: 0018:ffff880130bffa60  EFLAGS: 00010202
RAX: 0000000000000000 RBX: ffff880214cfa5f0 RCX: 0000000000000001
RDX: 7fffffffffffffff RSI: 0000000000000000 RDI: ffff880214cfa500
RBP: ffff880130bffa78 R08: ffff88012410e558 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: ffff88021506f800
R13: 7fffffffffffffff R14: ffffffffa03c86e0 R15: 7fffffffffffffff
FS:  00007f1f5d685880(0000) GS:ffff88021e2c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000348 CR3: 000000011e816000 CR4: 00000000000426e0
Stack:
 ffffffff811b6938 ffff880214cfa740 0000000000000000 ffff880130bffac8
 ffffffff811434ed ffff880130bffad8 7fffffffffffffff 0000000000000000
 0000000000000000 7fffffffffffffff 0000000000000001 7fffffffffffffff
Call Trace:
 [<ffffffff811b6938>] ? inode_to_bdi+0x58/0x70
 [<ffffffff811434ed>] __filemap_fdatawrite_range+0x3d/0x60
 [<ffffffff811441be>] filemap_fdatawrite_range+0xe/0x10
 [<ffffffffa0366316>] btrfs_fdatawrite_range+0x26/0x70 [btrfs]
 [<ffffffffa036b6b7>] btrfs_wait_ordered_range+0x47/0x120 [btrfs]
 [<ffffffffa035c6da>] btrfs_evict_inode+0x20a/0x4b0 [btrfs]
 [<ffffffff811b5f28>] ? __inode_wait_for_writeback+0x68/0xc0
 [<ffffffff811a9853>] evict+0xb3/0x180
 [<ffffffff811a9fca>] iput+0x14a/0x1b0
 [<ffffffffa035cb0c>] btrfs_invalidate_inodes+0x18c/0x1e0 [btrfs]
 [<ffffffffa038571a>] btrfs_ioctl_snap_destroy+0x55a/0x740 [btrfs]
 [<ffffffffa038864a>] btrfs_ioctl+0x12fa/0x29f0 [btrfs]
 [<ffffffff8114e616>] ? lru_cache_add_active_or_unevictable+0x26/0x90
 [<ffffffff81167d4f>] ? handle_mm_fault+0xc7f/0x1400
 [<ffffffff811a147e>] do_vfs_ioctl+0x7e/0x550
 [<ffffffff81070e28>] ? __do_page_fault+0x168/0x390
 [<ffffffff811a19e1>] SyS_ioctl+0x91/0xb0
 [<ffffffff8107108c>] ? do_page_fault+0xc/0x10
 [<ffffffff81840e72>] system_call_fastpath+0x12/0x17
Code: 66 43 c7 44 25 00 0a 00 48 8b 45 c8 e9 26 ff ff ff b8 01 00 00 00 45 =
31 e4 eb d5 90 90 90 90 48 8b 87 98 00 00 00 55 48 89 e5 5d <48> 8b 80 48 0=
3 00 00 48 05 80 01 00 00 c3 66 0f 1f 44 00 00 55=20
RIP  [<ffffffff812f518c>] blk_get_backing_dev_info+0xc/0x20
 RSP <ffff880130bffa60>
CR2: 0000000000000348
---[ end trace a10587c277e69e6e ]---


--cvVnyQ+4j833TQvp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJUKyfgAAoJEMQsWOtZFJL9S1cQANfCrmhPyWpjOdz8VG9wEEdi
rWVYtVLTx5l8g+O6KRdQZe6voWisXFfbk+uKHO2XOfJjETK904Ei6wJhXESqhuNW
ANvDxqdyIqCgVo1BvG18JVlfZWzxATOMo3/SnjErA7fzQDPbZ6+AiwDtstC/spy8
sawt1RtML2PuFx/RpsgGiIqrPFo/c1/nJ1l8JggDhJ/c+KfJzCeGOXXm/UNLLtn4
LL2ulC5TvZyhkv/AShMI/CER54vHOcGiASSbZ0hUnV814aMx6myc8ZSygO/5LosO
KFj0S/H+9mLYYTpMRC9sCUUKC7o7fwOe7zDz4/WQ5xhL5mWUCP40pjc0b01bDGTx
a8SackqgvJ0Ti2ATepZl5g+c6LiKnnjmgcey2lPKO2gsgpxok6NHsOWnN5tEXI9c
DQ+qhsz1fsDNPeh/wJV9mLhfU7nleBMqw57x13/VHIk6IIlgUt0UMqKReJIXxsei
XuYBhzYyokBMXfHcnbte/MfaGZ9opfoVnlp9xlkpXYew+QXQ7AfL0iN6yL/Etpd3
fEhDjpRawBGCS5pRf/mYolGZsQOm7sBn9xxSVTh+C3ydtsCSAbEbvlmJbzGQEDG0
EbskqnURm3V9htetDa4IRgogzapO3t/HdFjBzODa+DJHkCy41II5m8Q/1HJHIwQb
YRC2K6m+SVdJj0otwW0F
=MoQR
-----END PGP SIGNATURE-----

--cvVnyQ+4j833TQvp--
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
