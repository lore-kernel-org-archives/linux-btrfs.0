From: Sergei Trofimovich <slyich@gmail.com>
Subject: Re: [PATCH] Btrfs: fix easily get into ENOSPC in mixed case
Date: Sat, 9 Apr 2011 00:55:55 +0300
Message-ID: <20110409005555.4b136f25@sf>
References: <20110402121946.6bf27f80@sf.home>
	<4D96EE76.5040208@cn.fujitsu.com>
	<20110402134132.0391f4fd@sf.home>
	<4D9708E0.6030206@cn.fujitsu.com>
	<20110402155545.2159043a@sf.home>
	<4D9ECAF5.50108@cn.fujitsu.com>
	<20110409000932.6154c7b5@sf>
	<20110409001920.089c4409@sf>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/rZbGx5rA3/fqdQja=IYaZtV"; protocol="application/pgp-signature"
Cc: liubo <liubo2009@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
	Josef Bacik <josef@redhat.com>, Arne Jansen <sensille@gmx.net>
To: Sergei Trofimovich <slyich@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110409001920.089c4409@sf>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/rZbGx5rA3/fqdQja=IYaZtV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

> > > In btrfs's for-linus branch, commit 78b1ea13838039cd88afdd62519b40b34=
4d6c920
> > > (Btrfs: fix OOPS of empty filesystem after balance) initializes space=
 infos at
> > > the very beginning.  The problem is this initialization does not take=
 the mixed
> > > case into account, which will cause btrfs will easily get into ENOSPC=
 in mixed
> > > case.
> > >=20
> > > Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
> > > ---

> Sorry, I was too fast. The same OOps is reproducible on vanilla 2.6.39-rc=
2. Will retest on 2.6.39-rc1.

2.6.39-rc1 (no patch):

[  155.038094] ------------[ cut here ]------------
[  155.038388] kernel BUG at /mnt/archive/src/linux-2.6/fs/btrfs/inode.c:29=
67!
[  155.038643] invalid opcode: 0000 [#1] PREEMPT SMP=20
[  155.038907] last sysfs file: /sys/devices/virtual/bdi/0:26/uevent
[  155.039011] CPU 0=20
[  155.039011] Modules linked in: bridge stp llc btrfs zlib_deflate lzo_dec=
ompress lzo_compress crc32c libcrc32c tun kvm_amd kvm fuse nouveau ttm 8139=
cp drm_kms_helper drm i2c_algo_bit i2c_core cfbcopyarea cfbimgblt cfbfillre=
ct 8139too forcedeth
[  155.039011]=20
[  155.039011] Pid: 2620, comm: rm Not tainted 2.6.39-rc1 #3 To Be Filled B=
y O.E.M. To Be Filled By O.E.M./ALiveNF6G-VSTA
[  155.039011] RIP: 0010:[<ffffffffa0249fd1>]  [<ffffffffa0249fd1>] btrfs_u=
nlink+0xd1/0xe0 [btrfs]
[  155.039011] RSP: 0018:ffff880073687e28  EFLAGS: 00010286
[  155.039011] RAX: 00000000ffffffe4 RBX: 00000000ffffffe4 RCX: 00000000000=
000e0
[  155.039011] RDX: 00000000000000de RSI: 00000000000196d0 RDI: ffffea0001a=
3d980
[  155.039011] RBP: ffff880073687e58 R08: ffffffffa021df4a R09: ffff8800736=
87b48
[  155.039011] R10: ffffffffffffffe4 R11: 0000000000000001 R12: ffff8800756=
eab40
[  155.039011] R13: ffff8800756eb000 R14: ffff880075e8e800 R15: ffff880077f=
7e858
[  155.039011] FS:  00007f99bdd9c700(0000) GS:ffff88007bc00000(0000) knlGS:=
0000000000000000
[  155.039011] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  155.039011] CR2: 00007f99be7480a8 CR3: 0000000073610000 CR4: 00000000000=
006f0
[  155.039011] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[  155.039011] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[  155.039011] Process rm (pid: 2620, threadinfo ffff880073686000, task fff=
f8800730cc230)
[  155.039011] Stack:
[  155.039011]  ffff880073687e48 00000000fffffff0 ffff8800756eab40 ffff8800=
77f7e478
[  155.039011]  0000000000000000 0000000000000000 ffff880073687e88 ffffffff=
810ed3a0
[  155.039011]  ffff880073687e88 ffff880073687e98 ffff8800756eab40 ffff8800=
77f7e858
[  155.039011] Call Trace:
[  155.039011]  [<ffffffff810ed3a0>] vfs_unlink+0x80/0xf0
[  155.039011]  [<ffffffff810ef6f3>] do_unlinkat+0x173/0x1b0
[  155.039011]  [<ffffffff8111727b>] ? fsnotify_find_inode_mark+0x3b/0x50
[  155.039011]  [<ffffffff810dff91>] ? filp_close+0x61/0x90
[  155.039011]  [<ffffffff810f0c0d>] sys_unlinkat+0x1d/0x40
[  155.039011]  [<ffffffff81574c3b>] system_call_fastpath+0x16/0x1b
[  155.039011] Code: 4c 8b 65 e0 48 8b 5d d8 4c 8b 6d e8 4c 8b 75 f0 4c 8b =
7d f8 c9 c3 0f 1f 40 00 4c 89 fe 4c 89 ef e8 05 d0 ff ff 85 c0 74 bb 0f 0b =
<0f> 0b 89 c3 eb cd 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 41 57=20
[  155.039011] RIP  [<ffffffffa0249fd1>] btrfs_unlink+0xd1/0xe0 [btrfs]
[  155.039011]  RSP <ffff880073687e28>
[  155.064611] ---[ end trace 47dc7dae76c74a2a ]---

2.6.39-rc1 (+patch):
[  100.499105] ------------[ cut here ]------------
[  100.499405] kernel BUG at /mnt/archive/src/linux-2.6/fs/btrfs/inode.c:29=
67!
[  100.499686] invalid opcode: 0000 [#1] PREEMPT SMP=20
[  100.499948] last sysfs file: /sys/devices/virtual/bdi/0:26/uevent
[  100.500011] CPU 1=20
[  100.500011] Modules linked in: bridge stp llc btrfs zlib_deflate lzo_dec=
ompress lzo_compress crc32c libcrc32c tun kvm_amd kvm fuse nouveau ttm drm_=
kms_helper drm i2c_algo_bit i2c_core cfbcopyarea cfbimgblt cfbfillrect forc=
edeth 8139cp 8139too
[  100.500011]=20
[  100.500011] Pid: 2447, comm: rm Not tainted 2.6.39-rc1+ #4 To Be Filled =
By O.E.M. To Be Filled By O.E.M./ALiveNF6G-VSTA
[  100.500011] RIP: 0010:[<ffffffffa024a011>]  [<ffffffffa024a011>] btrfs_u=
nlink+0xd1/0xe0 [btrfs]
[  100.500011] RSP: 0018:ffff880070b55e28  EFLAGS: 00010286
[  100.500011] RAX: 00000000ffffffe4 RBX: 00000000ffffffe4 RCX: 00000000000=
00013
[  100.500011] RDX: 0000000000000011 RSI: 00000000000196d0 RDI: ffffea00019=
aef80
[  100.500011] RBP: ffff880070b55e58 R08: ffffffffa021df4a R09: ffff880070b=
55b48
[  100.500011] R10: ffffffffffffffe4 R11: 0000000000000001 R12: ffff8800756=
a0c00
[  100.500011] R13: ffff880075692000 R14: ffff880075e3c800 R15: ffff880077f=
5e478
[  100.500011] FS:  00007f01e95c5700(0000) GS:ffff88007bd00000(0000) knlGS:=
0000000000000000
[  100.500011] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  100.500011] CR2: 00007fd0687a8ec4 CR3: 0000000070b29000 CR4: 00000000000=
006e0
[  100.500011] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[  100.500011] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[  100.500011] Process rm (pid: 2447, threadinfo ffff880070b54000, task fff=
f8800709cc230)
[  100.500011] Stack:
[  100.500011]  ffff880070b55e48 00000000fffffff0 ffff8800756a0c00 ffff8800=
77f5e098
[  100.500011]  0000000000000000 0000000000000000 ffff880070b55e88 ffffffff=
810ed3a0
[  100.500011]  ffff880070b55e88 ffff880070b55e98 ffff8800756a0c00 ffff8800=
77f5e478
[  100.500011] Call Trace:
[  100.500011]  [<ffffffff810ed3a0>] vfs_unlink+0x80/0xf0
[  100.500011]  [<ffffffff810ef6f3>] do_unlinkat+0x173/0x1b0
[  100.500011]  [<ffffffff8111727b>] ? fsnotify_find_inode_mark+0x3b/0x50
[  100.500011]  [<ffffffff810dff91>] ? filp_close+0x61/0x90
[  100.500011]  [<ffffffff810f0c0d>] sys_unlinkat+0x1d/0x40
[  100.500011]  [<ffffffff81574c3b>] system_call_fastpath+0x16/0x1b
[  100.500011] Code: 4c 8b 65 e0 48 8b 5d d8 4c 8b 6d e8 4c 8b 75 f0 4c 8b =
7d f8 c9 c3 0f 1f 40 00 4c 89 fe 4c 89 ef e8 05 d0 ff ff 85 c0 74 bb 0f 0b =
<0f> 0b 89 c3 eb cd 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 41 57=20
[  100.500011] RIP  [<ffffffffa024a011>] btrfs_unlink+0xd1/0xe0 [btrfs]
[  100.500011]  RSP <ffff880070b55e28>
[  100.525672] ---[ end trace 7e63b9144b7307fe ]---

Looks like I won't be able to test your patch until this thing will go away=
 first.

--=20

  Sergei

--Sig_/rZbGx5rA3/fqdQja=IYaZtV
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk2fhHQACgkQcaHudmEf86pCSgCeMdv9XkIYtrgrrGZE7pzhCZX1
YnMAnjADIvNYRIU/gFDmRonB3y71cJtf
=6PYl
-----END PGP SIGNATURE-----

--Sig_/rZbGx5rA3/fqdQja=IYaZtV--
