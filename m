From: Sergei Trofimovich <slyich@gmail.com>
Subject: Re: [PATCH] Btrfs: fix easily get into ENOSPC in mixed case
Date: Sat, 9 Apr 2011 00:09:32 +0300
Message-ID: <20110409000932.6154c7b5@sf>
References: <20110402121946.6bf27f80@sf.home>
	<4D96EE76.5040208@cn.fujitsu.com>
	<20110402134132.0391f4fd@sf.home>
	<4D9708E0.6030206@cn.fujitsu.com>
	<20110402155545.2159043a@sf.home>
	<4D9ECAF5.50108@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/wFsohoC287OVuqp6ViuPv_L"; protocol="application/pgp-signature"
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <josef@redhat.com>,
	Arne Jansen <sensille@gmx.net>
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D9ECAF5.50108@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/wFsohoC287OVuqp6ViuPv_L
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 08 Apr 2011 16:44:37 +0800
liubo <liubo2009@cn.fujitsu.com> wrote:

>=20
> When a btrfs disk is created by mixed data & metadata option, it will hav=
e no
> pure data or pure metadata space info.
>=20
> In btrfs's for-linus branch, commit 78b1ea13838039cd88afdd62519b40b344d6c=
920
> (Btrfs: fix OOPS of empty filesystem after balance) initializes space inf=
os at
> the very beginning.  The problem is this initialization does not take the=
 mixed
> case into account, which will cause btrfs will easily get into ENOSPC in =
mixed
> case.
>=20
> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
> ---

Tried to apply this patch on top of 2.6.39-rc2 and booted on the same parti=
tion.
It has 3.2 GBs free. With patch it started to report -ENOSPC right out.
Attempt to delete some files caused OOps:

[  220.784098] ------------[ cut here ]------------
[  220.784416] kernel BUG at /mnt/archive/src/linux-2.6/fs/btrfs/inode.c:29=
62!
[  220.784700] invalid opcode: 0000 [#1] PREEMPT SMP=20
[  220.784969] last sysfs file: /sys/devices/virtual/bdi/0:26/uevent
[  220.785011] CPU 0=20
[  220.785011] Modules linked in: bridge stp llc btrfs zlib_deflate lzo_dec=
ompress lzo_compress crc32c libcrc32c tun kvm_amd kvm fuse nouveau ttm drm_=
kms_helper drm i2c_algo_bit i2c_core cfbcopyarea cfbimgblt 8139cp cfbfillre=
ct 8139too forcedeth
[  220.785011]=20
[  220.785011] Pid: 2881, comm: mc Not tainted 2.6.39-rc2+ #2 To Be Filled =
By O.E.M. To Be Filled By O.E.M./ALiveNF6G-VSTA
[  220.785011] RIP: 0010:[<ffffffffa024a141>]  [<ffffffffa024a141>] btrfs_u=
nlink+0xd1/0xe0 [btrfs]
[  220.785011] RSP: 0018:ffff88006898fe28  EFLAGS: 00010286
[  220.785011] RAX: 00000000ffffffe4 RBX: 00000000ffffffe4 RCX: 00000000000=
06d32
[  220.785011] RDX: 0000000000006d30 RSI: 00000000000196d0 RDI: ffffea0001a=
3d2b8
[  220.785011] RBP: ffff88006898fe58 R08: ffffffffa021e02a R09: ffff8800689=
8fb48
[  220.785011] R10: ffffffffffffffe4 R11: 0000000000000001 R12: ffff88005b5=
e2540
[  220.785011] R13: ffff88005b668040 R14: ffff880077344800 R15: ffff88005b6=
74578
[  220.785011] FS:  00007f8587265700(0000) GS:ffff88007bc00000(0000) knlGS:=
0000000000000000
[  220.785011] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  220.785011] CR2: 00007f8587277000 CR3: 0000000068a29000 CR4: 00000000000=
006f0
[  220.785011] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[  220.785011] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[  220.785011] Process mc (pid: 2881, threadinfo ffff88006898e000, task fff=
f880070a64230)
[  220.785011] Stack:
[  220.785011]  ffff88006898fe48 00000000fffffff0 ffff88005b5e2540 ffff8800=
5b674198
[  220.785011]  0000000000000000 00007fff6ee8d6b0 ffff88006898fe88 ffffffff=
810ed420
[  220.785011]  ffff88006898fe88 ffff88006898fe98 ffff88005b5e2540 ffff8800=
5b674578
[  220.785011] Call Trace:
[  220.785011]  [<ffffffff810ed420>] vfs_unlink+0x80/0xf0
[  220.785011]  [<ffffffff810ef773>] do_unlinkat+0x173/0x1b0
[  220.785011]  [<ffffffff81051a88>] ? sys_rt_sigaction+0x68/0xc0
[  220.785011]  [<ffffffff810f0cc1>] sys_unlink+0x11/0x20
[  220.785011]  [<ffffffff81574bbb>] system_call_fastpath+0x16/0x1b
[  220.785011] Code: 4c 8b 65 e0 48 8b 5d d8 4c 8b 6d e8 4c 8b 75 f0 4c 8b =
7d f8 c9 c3 0f 1f 40 00 4c 89 fe 4c 89 ef e8 25 d0 ff ff 85 c0 74 bb 0f 0b =
<0f> 0b 89 c3 eb cd 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 41 57=20
[  220.785011] RIP  [<ffffffffa024a141>] btrfs_unlink+0xd1/0xe0 [btrfs]
[  220.785011]  RSP <ffff88006898fe28>
[  220.809847] ---[ end trace ca8cb79df9da2e2a ]---


--=20

  Sergei

--Sig_/wFsohoC287OVuqp6ViuPv_L
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk2feZEACgkQcaHudmEf86qBhgCfW8vYBetHe2qtZCIbrR1cV/OI
QFUAn1njZuERjDXrj/Eky3W5rwtvB/KX
=0piy
-----END PGP SIGNATURE-----

--Sig_/wFsohoC287OVuqp6ViuPv_L--
