From: Sergei Trofimovich <slyich@gmail.com>
Subject: Re: [PATCH] btrfs progs: fix extra metadata chunk allocation in
 --mixed case
Date: Fri, 6 May 2011 23:39:46 +0300
Message-ID: <20110506233946.17f8899b@sf>
References: <1304604972-31585-1-git-send-email-sensille@gmx.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/PD8iP4MXQQx0TA+mZhGjyKZ"; protocol="application/pgp-signature"
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
	josef@redhat.com
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1304604972-31585-1-git-send-email-sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/PD8iP4MXQQx0TA+mZhGjyKZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

> The additional chunk probably confused block_rsv calculation, which in tu=
rn
> led to severeal ENOSPC Oopses.

I confirm. This patch __FIXES__ ENOSPC OOpses like the following for me:
(with applied http://www.spinics.net/lists/linux-btrfs/msg09400.html on top
to avoid earlier OOpses)

[14198.695903] BUG: unable to handle kernel NULL pointer dereference at 000=
0000000000030
[14198.695937] IP: [<ffffffffa021f597>] btrfs_print_leaf+0x27/0x890 [btrfs]
[14198.695978] PGD 70b04067 PUD 6b9ef067 PMD 0=20
[14198.695991] Oops: 0000 [#1] PREEMPT SMP=20
[14198.696003] last sysfs file: /sys/devices/virtual/vtconsole/vtcon1/uevent
[14198.696015] CPU 0=20
[14198.696020] Modules linked in: bridge stp llc btrfs zlib_deflate lzo_dec=
ompress lzo_compress crc32c libcrc32c tun kvm_amd kvm fuse nouveau ttm drm_=
kms_helper drm forcedeth i2c_algo_bit i2c_core cfbcopyarea cfbimgblt cfbfil=
lrect
[14198.696088]=20
[14198.696095] Pid: 1356, comm: btrfs-transacti Not tainted 2.6.39-rc5+ #10=
 To Be Filled By O.E.M. To Be Filled By O.E.M./ALiveNF6G-VSTA
[14198.696116] RIP: 0010:[<ffffffffa021f597>]  [<ffffffffa021f597>] btrfs_p=
rint_leaf+0x27/0x890 [btrfs]
[14198.696139] RSP: 0018:ffff880076ecfad0  EFLAGS: 00010283
[14198.696147] RAX: 00000000ffffffe4 RBX: 0000000000000000 RCX: 00000000fff=
fffe4
[14198.696157] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000000=
00001
[14198.696167] RBP: ffff880076ecfb50 R08: 0000000000000000 R09: 00000001000=
00000
[14198.696178] R10: ffffffffffffffe4 R11: 0000000000000002 R12: 00000000000=
00002
[14198.696188] R13: ffff88007611b000 R14: 0000000000000000 R15: 00000000000=
00000
[14198.696200] FS:  00007f924fc1b700(0000) GS:ffff88007bc00000(0000) knlGS:=
0000000000000000
[14198.696212] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[14198.696221] CR2: 0000000000000030 CR3: 000000006b9b9000 CR4: 00000000000=
006f0
[14198.696231] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[14198.696242] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[14198.696253] Process btrfs-transacti (pid: 1356, threadinfo ffff880076ece=
000, task ffff8800760cac20)
[14198.696265] Stack:
[14198.696271]  000000010ce53000 ffffffff00000000 ffff88007611b000 00000000=
00000001
[14198.696287]  ffff880076ecfbe0 ffff880077f37510 000000010ce53000 00000000=
001000a8
[14198.696305]  ffff880076ecfb00 ffffffff810d29a7 ffff880076b9a840 ffff8800=
77f37510
[14198.696322] Call Trace:
[14198.696339]  [<ffffffff810d29a7>] ? kmem_cache_alloc+0x97/0xb0
[14198.696352]  [<ffffffffa0217907>] __btrfs_free_extent+0x647/0x700 [btrfs]
[14198.696352]  [<ffffffff8103b371>] ? get_parent_ip+0x11/0x50
[14198.696352]  [<ffffffff8103b371>] ? get_parent_ip+0x11/0x50
[14198.696352]  [<ffffffff8103b371>] ? get_parent_ip+0x11/0x50
[14198.696352]  [<ffffffffa021a3f1>] run_clustered_refs+0x381/0x860 [btrfs]
[14198.696352]  [<ffffffffa026b200>] ? btrfs_find_ref_cluster+0x60/0x180 [b=
trfs]
[14198.696352]  [<ffffffffa021a990>] btrfs_run_delayed_refs+0xc0/0x210 [btr=
fs]
[14198.696352]  [<ffffffff81574700>] ? _raw_spin_unlock+0x10/0x40
[14198.696352]  [<ffffffffa022b878>] btrfs_commit_transaction+0x78/0x780 [b=
trfs]
[14198.696352]  [<ffffffff8105c640>] ? wake_up_bit+0x40/0x40
[14198.696352]  [<ffffffffa022518b>] transaction_kthread+0x27b/0x290 [btrfs]
[14198.696352]  [<ffffffff8103b445>] ? sub_preempt_count+0x95/0xd0
[14198.696352]  [<ffffffffa0224f10>] ? btrfs_congested_fn+0x90/0x90 [btrfs]
[14198.696352]  [<ffffffff8105c166>] kthread+0x96/0xa0
[14198.696352]  [<ffffffff81576014>] kernel_thread_helper+0x4/0x10
[14198.696352]  [<ffffffff8105c0d0>] ? kthread_worker_fn+0x190/0x190
[14198.696352]  [<ffffffff81576010>] ? gs_change+0xb/0xb
[14198.696352] Code: 00 00 00 00 55 48 89 e5 48 83 c4 80 4c 89 6d e8 49 89 =
fd bf 01 00 00 00 48 89 5d d8 4c 89 65 e0 48 89 f3 4c 89 75 f0 4c 89 7d f8 =
<4c> 8b 66 30 e8 e0 be e1 e0 48 b8 00 00 00 00 00 16 00 00 49 01=20
[14198.696352] RIP  [<ffffffffa021f597>] btrfs_print_leaf+0x27/0x890 [btrfs]
[14198.696352]  RSP <ffff880076ecfad0>
[14198.696352] CR2: 0000000000000030
[14198.700320] ---[ end trace e55b8b088e0f1338 ]---

--=20

  Sergei

--Sig_/PD8iP4MXQQx0TA+mZhGjyKZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk3EXJcACgkQcaHudmEf86q8yACfc0CHuJEoK54nlV4e5TcribBg
jRYAn0GWuv1lAfvy/sZXcevKTuF8Zn9U
=K1qv
-----END PGP SIGNATURE-----

--Sig_/PD8iP4MXQQx0TA+mZhGjyKZ--
