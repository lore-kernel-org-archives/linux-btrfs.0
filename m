From: Sergei Trofimovich <slyich@gmail.com>
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:2195! and WARNING: at
 fs/btrfs/extent-tree.c:5695 btrfs_alloc_free_block+0xc2/0x287 [btrfs]()
Date: Sat, 19 Mar 2011 01:21:00 +0200
Message-ID: <20110319012100.7847dc74@sf.home>
References: <20110318235836.52c19220@sf.home>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/XeDV3Xe77IAlOGQR2fX6Afz"; protocol="application/pgp-signature"
Cc: cwillu@cwillu.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110318235836.52c19220@sf.home>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/XeDV3Xe77IAlOGQR2fX6Afz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

> Hi list! I've built vanilla 2.6.38 and decided to try btrfs today.
>=20
> I've created 2GB image file on ext4 filesystem and
> setup a loop device /dev/loop0:
> $ dd if=3D/dev/zero of=3Dbtrfs.image bs=3D$((1024 * 1024)) count=3D2048
> $ losetup /dev/loop0 btrfs.image
> $ mkfs.btrfs -LBTRFS_TESTIE /dev/loop0
> $ losetup -a
> /dev/loop0: [0809]:24585 (/mnt/archive/btrfs.image)
> $ mount /dev/loop0 ut/
>=20
> Then I've copied ~150 000 small files there. They are 177MB
> of raw data and ~1GB on ext4.
>=20
> Some useless commands after:
> $ btrfs filesystem defrag ut/
> $ btrfs filesystem balance ut/
>=20
> And then I've decided to change owner for files:
> ut # chown -R slyfox:users .
> Segmentation Fault
>=20
> dmesg output contains two events: warning and OOOps
>=20
> [14116.052424] ------------[ cut here ]------------
> [14116.052457] WARNING: at fs/btrfs/extent-tree.c:5695 btrfs_alloc_free_b=
lock+0xc2/0x287 [btrfs]()
> [14116.052462] Hardware name: HP Compaq 2510p Notebook PC
> [14116.052466] Modules linked in: cpufreq_stats btrfs zlib_deflate crc32c=
 libcrc32c rfcomm l2cap bluetooth ext2 loop kvm_intel kvm fuse acpi_cpufreq=
 mperf scsi_wait_scan usb_storage tun iwlagn iwlcore pcmcia snd_hda_codec_a=
nalog mac80211 i915 cfg80211 yenta_socket snd_hda_intel drm_kms_helper sr_m=
od cdrom snd_hda_codec pcmcia_rsrc drm sdhci_pci i2c_algo_bit pcmcia_core c=
ontainer thermal sg battery e1000e sdhci fan mmc_core rfkill snd_hwdep ac p=
rocessor button
> [14116.052548] Pid: 26177, comm: chown Not tainted 2.6.38 #102
> [14116.052552] Call Trace:
> [14116.052565]  [<ffffffff81036c9a>] ? warn_slowpath_common+0x80/0x98
> [14116.052571]  [<ffffffff81036cc7>] ? warn_slowpath_null+0x15/0x17
> [14116.052590]  [<ffffffffa044b996>] ? btrfs_alloc_free_block+0xc2/0x287 =
[btrfs]
> [14116.052599]  [<ffffffff810308bc>] ? sub_preempt_count+0x92/0xa5
> [14116.052617]  [<ffffffffa0440791>] ? __btrfs_cow_block+0x164/0x85a [btr=
fs]
> [14116.052635]  [<ffffffffa0441604>] ? btrfs_cow_block+0x24b/0x268 [btrfs]
> [14116.052653]  [<ffffffffa0444989>] ? btrfs_search_slot+0x8c1/0x911 [btr=
fs]
> [14116.052660]  [<ffffffff8102fd80>] ? get_parent_ip+0x11/0x41
> [14116.052681]  [<ffffffffa044e6cc>] ? lookup_inline_extent_backref+0xd0/=
0x3bf [btrfs]
> [14116.052689]  [<ffffffff81098dd9>] ? __set_page_dirty_nobuffers+0x101/0=
x10e
> [14116.052709]  [<ffffffffa044f2bd>] ? insert_inline_extent_backref+0x5d/=
0xd4 [btrfs]
> [14116.052720]  [<ffffffff8139d68a>] ? _raw_spin_unlock+0x10/0x2b
> [14116.052740]  [<ffffffffa044f3cc>] ? __btrfs_inc_extent_ref+0x98/0x1b8 =
[btrfs]
> [14116.052760]  [<ffffffffa04506a2>] ? run_clustered_refs+0x68f/0x767 [bt=
rfs]
> [14116.052782]  [<ffffffffa0450846>] ? btrfs_run_delayed_refs+0xcc/0x1d1 =
[btrfs]
> [14116.052806]  [<ffffffffa045b02c>] ? __btrfs_end_transaction+0x67/0x1ed=
 [btrfs]
> [14116.052830]  [<ffffffffa045b1e6>] ? btrfs_end_transaction+0x10/0x12 [b=
trfs]
> [14116.052854]  [<ffffffffa04610ab>] ? btrfs_dirty_inode+0xfb/0x104 [btrf=
s]
> [14116.052862]  [<ffffffff810eb64a>] ? __mark_inode_dirty+0x2c/0x1b9
> [14116.052887]  [<ffffffffa046572d>] ? btrfs_setattr+0x229/0x253 [btrfs]
> [14116.052895]  [<ffffffff810e34fc>] ? notify_change+0x164/0x24e
> [14116.052904]  [<ffffffff810ccf8e>] ? chown_common+0x68/0x7f
> [14116.052910]  [<ffffffff810e5a58>] ? mnt_want_write+0x54/0x75
> [14116.052917]  [<ffffffff810cd1e5>] ? sys_fchownat+0x56/0x81
> [14116.052925]  [<ffffffff81001ffb>] ? system_call_fastpath+0x16/0x1b
> [14116.052945] ---[ end trace 7d78d14c5b4b187f ]---
>=20
> What does that kind of warnings mean?
>=20
> [14116.052972] ------------[ cut here ]------------
> [14116.053009] kernel BUG at fs/btrfs/extent-tree.c:2195!
> [14116.053009] invalid opcode: 0000 [#1] PREEMPT SMP=20
> [14116.053009] last sysfs file: /sys/devices/LNXSYSTM:00/device:00/PNP0C0=
A:00/power_supply/C23D/uevent
> [14116.053009] CPU 1=20
> [14116.053009] Modules linked in: cpufreq_stats btrfs zlib_deflate crc32c=
 libcrc32c rfcomm l2cap bluetooth ext2 loop kvm_intel kvm fuse acpi_cpufreq=
 mperf scsi_wait_scan usb_storage tun iwlagn iwlcore pcmcia snd_hda_codec_a=
nalog mac80211 i915 cfg80211 yenta_socket snd_hda_intel drm_kms_helper sr_m=
od cdrom snd_hda_codec pcmcia_rsrc drm sdhci_pci i2c_algo_bit pcmcia_core c=
ontainer thermal sg battery e1000e sdhci fan mmc_core rfkill snd_hwdep ac p=
rocessor button
> [14116.053009]=20
> [14116.053009] Pid: 26177, comm: chown Tainted: G        W   2.6.38 #102 =
Hewlett-Packard HP Compaq 2510p Notebook PC/30C9
> [14116.053009] RIP: 0010:[<ffffffffa04506ed>]  [<ffffffffa04506ed>] run_c=
lustered_refs+0x6da/0x767 [btrfs]
> [14116.053009] RSP: 0018:ffff88001816fbc8  EFLAGS: 00010286
> [14116.053009] RAX: 00000000ffffffe4 RBX: ffff88002018cd20 RCX: ffff88007=
961e990
> [14116.053009] RDX: 0000000000000000 RSI: ffffea0001a8d690 RDI: ffff88007=
961e480
> [14116.053009] RBP: ffff88001816fca8 R08: 0000000000000000 R09: ffff88000=
5c16000
> [14116.053009] R10: 0000000000000000 R11: 0000000000000000 R12: 000000000=
0000000
> [14116.053009] R13: ffff8800200e6880 R14: ffff880005c16000 R15: ffff88004=
14344c0
> [14116.053009] FS:  00007f8b4ef83700(0000) GS:ffff88007e500000(0000) knlG=
S:0000000000000000
> [14116.053009] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [14116.053009] CR2: 0000000000432065 CR3: 000000000c345000 CR4: 000000000=
00006e0
> [14116.053009] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000=
0000000
> [14116.053009] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 000000000=
0000400
> [14116.053009] Process chown (pid: 26177, threadinfo ffff88001816e000, ta=
sk ffff880048bd0000)
> [14116.054894] Stack:
> [14116.054894]  0000000000024ecc 0000000000000000 ffff880000000001 000000=
0000000000
> [14116.054894]  ffff88001816fc18 ffff88003eb4c748 ffff88001816fcc0 ffff88=
001816fce8
> [14116.054894]  ffff88001816fcb0 0000000000000000 ffff88003eb4c690 ffff88=
003eb4c750
> [14116.054894] Call Trace:
> [14116.054894]  [<ffffffffa0450846>] btrfs_run_delayed_refs+0xcc/0x1d1 [b=
trfs]
> [14116.054894]  [<ffffffffa045b02c>] __btrfs_end_transaction+0x67/0x1ed [=
btrfs]
> [14116.054894]  [<ffffffffa045b1e6>] btrfs_end_transaction+0x10/0x12 [btr=
fs]
> [14116.054894]  [<ffffffffa04610ab>] btrfs_dirty_inode+0xfb/0x104 [btrfs]
> [14116.054894]  [<ffffffff810eb64a>] __mark_inode_dirty+0x2c/0x1b9
> [14116.054894]  [<ffffffffa046572d>] btrfs_setattr+0x229/0x253 [btrfs]
> [14116.054894]  [<ffffffff810e34fc>] notify_change+0x164/0x24e
> [14116.054894]  [<ffffffff810ccf8e>] chown_common+0x68/0x7f
> [14116.054894]  [<ffffffff810e5a58>] ? mnt_want_write+0x54/0x75
> [14116.054894]  [<ffffffff810cd1e5>] sys_fchownat+0x56/0x81
> [14116.054894]  [<ffffffff81001ffb>] system_call_fastpath+0x16/0x1b
> [14116.054894] Code: 10 48 8b 7b 48 48 89 7c 24 08 48 8b 7b 40 48 89 3c 2=
4 4c 89 f6 4c 89 ff e8 a9 f0 ff ff eb 08 0f 0b eb fe 0f 0b eb fe 85 c0 74 0=
4 <0f> 0b eb fe 8b 53 28 48 8d 43 28 85 d2 75 1f 48 89 85 40 ff ff=20
> [14116.054894] RIP  [<ffffffffa04506ed>] run_clustered_refs+0x6da/0x767 [=
btrfs]
> [14116.054894]  RSP <ffff88001816fbc8>
> [14116.092454] ---[ end trace 7d78d14c5b4b1880 ]---
>=20
> Some diagnostics by willu on #btrfs:
> < cwillu> 14116.053009] RAX: 00000000ffffffe4 RBX: ffff88002018cd20 RCX: =
ffff88007961e990
> < cwillu> ffffffe4 =3D=3D -28 =3D=3D enospc
>=20
> Attached full dmesg and kernel config.

I've applied patch adding '--mixed' for mkfs.btrfs  (needed minimal conflic=
t resolution)
    http://kerneltrap.org/mailarchive/linux-btrfs/2010/10/27/6885910
on top of
    git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstabl=
e.git
and redone whole test with one change:

> $ mkfs.btrfs -LBTRFS_TESTIE --mixed /dev/loop0

chown finished successfully this time and dmesg does not contain backtraces.

--=20

  Sergei

--Sig_/XeDV3Xe77IAlOGQR2fX6Afz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk2D6NwACgkQcaHudmEf86p4jwCfTyi2ictAvvMkNfClQRKGJakI
57wAn0FFYfgddEDzIwqEfvtQc0K5BoPb
=qjEd
-----END PGP SIGNATURE-----

--Sig_/XeDV3Xe77IAlOGQR2fX6Afz--
