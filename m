Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:37483 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab2KPVT2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Nov 2012 16:19:28 -0500
Received: by mail-lb0-f174.google.com with SMTP id gp3so2507786lbb.19
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Nov 2012 13:19:26 -0800 (PST)
Date: Sat, 17 Nov 2012 00:19:09 +0300
From: Sergei Trofimovich <slyich@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fusionio.com>
Subject: 3.7.0-rc4: OOps on 'btrfs fi resize' (shrink lzo compressed FS)
Message-ID: <20121117001909.1710b978@sf>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/j+kiJC2OymD2uVvHyT6FdAq"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/j+kiJC2OymD2uVvHyT6FdAq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

It's a 4GB loop device
Mounted as:
/subvolumes/nocow-images/gentoo-16k.img on /gentoo-16k type btrfs (rw,noati=
me,nodiratime,nodatasum,compress=3Dlzo)

# btrfs fi df /gentoo-16k/
Data: total=3D417.56MB, used=3D163.17MB
System: total=3D4.00MB, used=3D16.00KB
Metadata: total=3D776.00MB, used=3D536.98MB

# time btrfs fi resize 1G /gentoo-16k/
Resize '/gentoo-16k/' of '1G'
SIGSEGV

# btrfs fi show
Label: 'gentoo-16k'  uuid: d9d52d75-5f4c-4145-8fd9-4ad686283abf
        Total devices 1 FS bytes used 700.11MB
        devid    1 size 1.00GB used 1.17GB path /dev/loop0

[468918.216084] ------------[ cut here ]------------
[468918.216127] kernel BUG at fs/btrfs/relocation.c:2615!
[468918.216163] invalid opcode: 0000 [#1] PREEMPT SMP=20
[468918.216204] Modules linked in: udf sr_mod cdrom binfmt_misc loop fuse u=
sb_storage tun snd_hda_codec_hdmi snd_hda_codec_via snd_hda_intel snd_hda_c=
odec snd_hwdep snd_pcm kvm_intel snd_page_alloc kvm snd_timer snd atl1c mic=
rocode soundcore
[468918.216401] CPU 2=20
[468918.216420] Pid: 20533, comm: btrfs Not tainted 3.7.0-rc4-00001-gdf07b0=
6 #275 Gigabyte Technology Co., Ltd. To be filled by O.E.M./H77M-D3H
[468918.216501] RIP: 0010:[<ffffffff812773dc>]  [<ffffffff812773dc>] do_rel=
ocation+0x53c/0x550
[468918.216564] RSP: 0018:ffff8802fc3eb948  EFLAGS: 00010246
[468918.216600] RAX: ffff8807fa387f30 RBX: 00000000ffffffe4 RCX: 0000000000=
000000
[468918.216647] RDX: 0000000000000087 RSI: ffff88053531f4c0 RDI: 0000000000=
000001
[468918.216694] RBP: ffff8802fc3eba28 R08: 00000000ffffffe4 R09: 0000000000=
004000
[468918.216740] R10: 0000000000000003 R11: ffffffff81256069 R12: ffff880584=
3dd0c0
[468918.216787] R13: ffff8807fbae0c00 R14: ffff8803e364cc80 R15: 0000000000=
004000
[468918.216834] FS:  00007fd3e37f2740(0000) GS:ffff88081f280000(0000) knlGS=
:0000000000000000
[468918.216886] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[468918.216925] CR2: 00007f6310140030 CR3: 00000007f975e000 CR4: 0000000000=
0407e0
[468918.216971] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000=
000000
[468918.217017] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000=
000400
[468918.217065] Process btrfs (pid: 20533, threadinfo ffff8802fc3ea000, tas=
k ffff8806fdba2d40)
[468918.217118] Stack:
[468918.217134]  ffff8807f7f11800 0000000001918000 ffff8807fa3876c0 0000000=
000010000
[468918.217193]  ffff880574ff3120 00000000489b4000 ffff8807fa387f30 ffff880=
7fbae0c40
[468918.217250]  ffff880574ff3000 ffff8805843dd3a0 00000001fc3eb9f8 ffff880=
7f848cd10
[468918.217308] Call Trace:
[468918.217332]  [<ffffffff81216e40>] ? block_rsv_add_bytes+0x50/0x70
[468918.217375]  [<ffffffff812799b4>] relocate_tree_blocks+0x624/0x650
[468918.217418]  [<ffffffff812776c9>] ? add_tree_block+0xe9/0x1a0
[468918.217458]  [<ffffffff8127a97d>] relocate_block_group+0x42d/0x6a0
[468918.217501]  [<ffffffff8127ad8d>] btrfs_relocate_block_group+0x19d/0x2d0
[468918.217548]  [<ffffffff81253ec5>] btrfs_relocate_chunk.isra.51+0x65/0x7=
60
[468918.217594]  [<ffffffff812512eb>] ? read_extent_buffer+0xbb/0x110
[468918.217637]  [<ffffffff815a59e1>] ? _raw_spin_unlock+0x11/0x40
[468918.217679]  [<ffffffff8124acc1>] ? release_extent_buffer.isra.28+0xb1/=
0xe0
[468918.217726]  [<ffffffff81250052>] ? free_extent_buffer+0x32/0x90
[468918.217767]  [<ffffffff81257143>] btrfs_shrink_device+0x1f3/0x410
[468918.217810]  [<ffffffff8125d100>] btrfs_ioctl_resize+0x2d0/0x320
[468918.217852]  [<ffffffff81364520>] ? do_output_char+0x180/0x220
[468918.217893]  [<ffffffff81261d62>] btrfs_ioctl+0x842/0x19a0
[468918.217933]  [<ffffffff8102daec>] ? __do_page_fault+0x1bc/0x480
[468918.217975]  [<ffffffff8114c2f7>] do_vfs_ioctl+0x97/0x600
[468918.218013]  [<ffffffff8114c8ab>] sys_ioctl+0x4b/0x90
[468918.218050]  [<ffffffff815a6a56>] system_call_fastpath+0x1a/0x1f
[468918.218089] Code: 89 4d 30 49 89 45 38 48 89 10 41 80 65 71 df e9 20 fe=
 ff ff 89 c3 e9 54 fe ff ff 0f 0b 0f 0b 0f 0b 0f 0b 0f 0b 0f 0b 0f 0b 0f 0b=
 <0f> 0b 48 83 7a 68 00 0f 84 fa fa ff ff 0f 0b 0f 1f 44 00 00 55=20
[468918.218376] RIP  [<ffffffff812773dc>] do_relocation+0x53c/0x550
[468918.218420]  RSP <ffff8802fc3eb948>
[468918.233287] ---[ end trace de505802f3765bf8 ]---

--=20

  Sergei

--Sig_/j+kiJC2OymD2uVvHyT6FdAq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEUEARECAAYFAlCmrdAACgkQcaHudmEf86qN8wCWNGFUtOAv4QrRejW4rZHXoW7N
3ACdF3A46zZPpH+bofQ2VBM5pwGk+/g=
=zZY+
-----END PGP SIGNATURE-----

--Sig_/j+kiJC2OymD2uVvHyT6FdAq--
