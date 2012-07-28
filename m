Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-2.hut.fi ([130.233.228.92]:41737 "EHLO smtp-2.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533Ab2G1SvE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Jul 2012 14:51:04 -0400
Date: Sat, 28 Jul 2012 21:50:55 +0300
From: Sami Liedes <sami.liedes@iki.fi>
To: Arne Jansen <sensille@gmx.net>, linux-btrfs@vger.kernel.org,
        Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: btrfs GPF in read_extent_buffer() while scrubbing with kernel
 3.4.2
Message-ID: <20120728185054.GB8733@sli.dy.fi>
References: <4FF6C12A.10305@jan-o-sch.net>
 <20120706143350.GA10427@sli.dy.fi>
 <4FF6FF8C.4010007@jan-o-sch.net>
 <20120706234405.GB8933@sli.dy.fi>
 <4FFA9EEB.7060008@gmx.net>
 <20120710041625.GA8909@sli.dy.fi>
 <4FFBD24E.2050902@gmx.net>
 <5003CECC.2040908@gmx.net>
 <20120716212932.GB8653@sli.dy.fi>
 <20120728120846.GA8733@sli.dy.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="3uo+9/B/ebqu+fSQ"
In-Reply-To: <20120728120846.GA8733@sli.dy.fi>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--3uo+9/B/ebqu+fSQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 28, 2012 at 03:08:47PM +0300, Sami Liedes wrote:
> I have not yet figured out if this can be reproduced using a pristine,
> smaller btrfs filesystem in raid-1 configuration inside KVM or if
> there's something about my specific filesystem that causes this. I can
> investigate that too; it's easier to do for me than the above testing,
> as I don't need to have continuous physical access to the computer to
> do that.

It seems the bug doesn't happen with a new filesystem made with

   mkfs.btrfs -mraid1 -draid1 /dev/mapper/btrfs_crypt /dev/mapper/btrfs2_cr=
ypt

and subsequently filled with data... Unfortunate.

I started to wonder what's so special about the second device of my
filesystem. All the errors always seem to come from that device. The
only thing that comes to mind is that that device was not originally
part of the filesystem; it started as a single-device filesystem
formatted with mkfs.btrfs with default options and was subsequently
rebalanced under a 3.4.2 kernel.

So I started to play with btrfs fi balance in my KVM instance with my
two-device filesystem, and hit this oops, which may or may not be
related to my previous bug and/or dm-crypt...

------------------------------------------------------------
[   15.195342] device fsid a844eb60-eb9c-4e24-ae91-c1627bf2d439 devid 1 tra=
nsid 176 /dev/mapper/btrfs_crypt
[   15.196606] device fsid a844eb60-eb9c-4e24-ae91-c1627bf2d439 devid 2 tra=
nsid 176 /dev/mapper/btrfs2_crypt
[   15.197895] device fsid a844eb60-eb9c-4e24-ae91-c1627bf2d439 devid 1 tra=
nsid 176 /dev/mapper/btrfs_crypt
[   15.200202] btrfs: disk space caching is enabled
# btrfs device delete [something...]
[ 1462.242456] btrfs: unable to go below two devices on raid1
# btrfs fi balance start -mconvert=3Ddup -dconvert=3Draid0 /media
[ 1895.048075] btrfs: unable to start balance with target metadata profile =
32
# btrfs fi balance start -dconvert=3Draid0 /media
[ 1917.106536] btrfs: relocating block group 10229907456 flags 17
[ 1929.188609] btrfs: relocating block group 8887730176 flags 17
[ 1944.690916] btrfs: found 2152 extents
[ 1947.016210] btrfs: found 2152 extents
[ 1947.421397] btrfs: relocating block group 7545552896 flags 17
[ 2024.225203] btrfs: found 36762 extents
[ 2094.983055] btrfs: corrupt node block=3D8830455808,root=3D1: generation =
(197) too new in slot 0 (maximum expected 196)
[ 2094.984858] ------------[ cut here ]------------
[ 2094.986076] WARNING: at fs/btrfs/super.c:219 __btrfs_abort_transaction+0=
xa5/0xc0()
[ 2094.987912] Hardware name: Bochs
[ 2094.988735] btrfs: Transaction abortedPid: 1623, comm: btrfs-transacti N=
ot tainted 3.4.4 #9
[ 2094.988741] Call Trace:
[ 2094.989361]  [<ffffffff8103da65>] warn_slowpath_common+0x75/0xb0
[ 2094.990829]  [<ffffffff8103db11>] warn_slowpath_fmt+0x41/0x50
[ 2094.992243]  [<ffffffff8148a2b5>] __btrfs_abort_transaction+0xa5/0xc0
[ 2094.993521]  [<ffffffff81498463>] __btrfs_free_extent+0x213/0x7b0
[ 2094.994176]  [<ffffffff8149cac7>] ? run_clustered_refs+0xd7/0xa10
[ 2094.994835]  [<ffffffff8158d9fd>] ? do_raw_spin_unlock+0x5d/0xb0
[ 2094.995481]  [<ffffffff8149ce05>] run_clustered_refs+0x415/0xa10
[ 2094.996143]  [<ffffffff814f13e8>] ? find_ref_head+0xb8/0xe0
[ 2094.996806]  [<ffffffff8149d499>] ? btrfs_run_delayed_refs+0x99/0x430
[ 2094.997505]  [<ffffffff8149d56d>] btrfs_run_delayed_refs+0x16d/0x430
[ 2094.998188]  [<ffffffff81497c19>] ? next_block_group.isra.65+0x29/0x80
[ 2094.998890]  [<ffffffff8176f326>] ? _raw_spin_unlock+0x26/0x30
[ 2094.999520]  [<ffffffff8149d8e0>] btrfs_write_dirty_block_groups+0xb0/0x=
630
[ 2095.000281]  [<ffffffff814d365a>] ? free_extent_buffer+0x1a/0x70
[ 2095.000931]  [<ffffffff8176905d>] commit_cowonly_roots+0xe7/0x1c1
[ 2095.001610]  [<ffffffff814aed29>] btrfs_commit_transaction+0x519/0xa40
[ 2095.002317]  [<ffffffff8105f1d0>] ? abort_exclusive_wait+0xb0/0xb0
[ 2095.002997]  [<ffffffff814a7a25>] transaction_kthread+0x245/0x2c0
[ 2095.003673]  [<ffffffff814a77e0>] ? check_leaf.isra.105+0x300/0x300
[ 2095.004372]  [<ffffffff8105e57e>] kthread+0x8e/0xa0
[ 2095.004902]  [<ffffffff81771464>] kernel_thread_helper+0x4/0x10
[ 2095.005549]  [<ffffffff8105e4f0>] ? kthread_flush_work_fn+0x10/0x10
[ 2095.006222]  [<ffffffff81771460>] ? gs_change+0x13/0x13
[ 2095.006787] ---[ end trace 8341f112debcf176 ]---
[ 2095.007287] BTRFS error (device dm-1) in __btrfs_free_extent:5134: IO fa=
ilure
[ 2095.008059] btrfs is forced readonly
[ 2095.008454] btrfs: run_one_delayed_ref returned -5
[ 2095.008455] BTRFS error (device dm-1) in btrfs_run_delayed_refs:2454: IO=
 failure
[ 2176.876382] ------------[ cut here ]------------
[ 2176.877217] kernel BUG at fs/btrfs/relocation.c:3733!
[ 2176.878139] invalid opcode: 0000 [#1] SMP=20
[ 2176.879049] CPU 5=20
[ 2176.879435] Pid: 1676, comm: btrfs Tainted: G        W    3.4.4 #9 Bochs=
 Bochs
[ 2176.880383] RIP: 0010:[<ffffffff814f97d3>]  [<ffffffff814f97d3>] relocat=
e_block_group+0x643/0x690
[ 2176.880383] RSP: 0000:ffff880002bfdb08  EFLAGS: 00010206
[ 2176.880383] RAX: ffffffffffffffe2 RBX: ffffffffffffffe2 RCX: ffff880007a=
ade10
[ 2176.880383] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff880006f=
be800
[ 2176.880383] RBP: ffff880002bfdb88 R08: 0000000000000003 R09: 00000000000=
00000
[ 2176.880383] R10: 0000000100072905 R11: 0000000000000001 R12: ffff8800037=
a8020
[ 2176.880383] R13: 0000000000005ee7 R14: ffff880006bbae10 R15: ffff8800037=
a8000
[ 2176.880383] FS:  0000000000000000(0000) GS:ffff880007d40000(0063) knlGS:=
00000000f75be720
[ 2176.880383] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[ 2176.880383] CR2: 00000000f75c2c80 CR3: 0000000006664000 CR4: 00000000000=
006a0
[ 2176.880383] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[ 2176.880383] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[ 2176.880383] Process btrfs (pid: 1676, threadinfo ffff880002bfc000, task =
ffff880007aad880)
[ 2176.880383] Stack:
[ 2176.880383]  ffff880005c94fb0 ffff880002bfdb50 0000000000000001 00000000=
00000001
[ 2176.880383]  ffff880005c94bc8 0000000000000000 ffff880002bfdb88 00ffffff=
814afd9a
[ 2176.880383]  a800000001ebfdf0 000000000000c000 ffff8800037a8000 ffff8800=
037a8000
[ 2176.880383] Call Trace:
[ 2176.880383]  [<ffffffff814f99c4>] btrfs_relocate_block_group+0x1a4/0x2d0
[ 2176.880383]  [<ffffffff8106cbad>] ? __wake_up+0x2d/0x70
[ 2176.880383]  [<ffffffff814d67e5>] btrfs_relocate_chunk.isra.52+0x65/0x700
[ 2176.880383]  [<ffffffff814d365a>] ? free_extent_buffer+0x1a/0x70
[ 2176.880383]  [<ffffffff8158d9fd>] ? do_raw_spin_unlock+0x5d/0xb0
[ 2176.880383]  [<ffffffff8176f326>] ? _raw_spin_unlock+0x26/0x30
[ 2176.880383]  [<ffffffff814ce1e2>] ? release_extent_buffer.isra.41+0x32/0=
xc0
[ 2176.880383]  [<ffffffff814d365a>] ? free_extent_buffer+0x1a/0x70
[ 2176.880383]  [<ffffffff814d366a>] ? free_extent_buffer+0x2a/0x70
[ 2176.880383]  [<ffffffff814dacbf>] btrfs_balance+0x7ff/0xce0
[ 2176.880383]  [<ffffffff814df9d9>] btrfs_ioctl_balance.isra.51+0x139/0x430
[ 2176.880383]  [<ffffffff814e3245>] btrfs_ioctl+0x95/0x1260
[ 2176.880383]  [<ffffffff81063ace>] ? up_read+0x1e/0x40
[ 2176.880383]  [<ffffffff81024abc>] ? do_page_fault+0x1ac/0x490
[ 2176.880383]  [<ffffffff810ebf9b>] ? __vma_link_rb+0x2b/0x30
[ 2176.880383]  [<ffffffff81152796>] compat_sys_ioctl+0x96/0x1310
[ 2176.880383]  [<ffffffff81587a49>] ? lockdep_sys_exit_thunk+0x35/0x67
[ 2176.880383]  [<ffffffff81771612>] sysenter_dispatch+0x7/0x25
[ 2176.880383] Code: ff ff 66 0f 1f 44 00 00 41 0f b6 87 59 06 00 00 83 c8 =
08 41 88 87 59 06 00 00 e9 10 fe ff ff bb f4 ff ff ff e9 88 fc ff ff 0f 0b =
<0f> 0b c7 45 98 00 00 00 00 4c 89 f7 e8 cc 27 f9 ff 48 83 ca ff=20
[ 2176.880383] RIP  [<ffffffff814f97d3>] relocate_block_group+0x643/0x690
[ 2176.880383]  RSP <ffff880002bfdb08>
[ 2176.922828] ---[ end trace 8341f112debcf177 ]---
------------------------------------------------------------

	Sami

--3uo+9/B/ebqu+fSQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJQFDSOAAoJEKLT589SE0a0VdgQAILMprUc0tX6ZaGvMaHFKiZ/
ChRs12yd+fMwhBVd9AkexK4ZDrFvTSjYK5YnLP+AFeg3h9+r8UNyWxWjSMrjIOxa
gjRkiABsIz/Jm0tXft0pKTtt3HF8g1gkP6TuQnq9GskrwPwJb16LKXQid213z7VL
89Wxm3uX5hAqoGv16gcXOB+j64WgL09FIXM2T3Q0cPijQCh7igTXIlt4bxYY4YlL
eOM+agJeHs50RzNE5bEOwAIvcwFeHtSl/gtn+37xN+4FL742qB3bBC+nBzM1b2V+
onNxdzoiMjSI5CuiolYj5XXQWJ4zskWWwxQZDWXpTfsm94ZrRJn4axDx5KrZ8u1F
p9xJK0GHVX2i2peRYRWn5aoloF4LIt0+F61vnoIs/ZAIz0rLND+UQChcZBk7yhkz
cBUhK4un0H9eNGDPVCLj49TGwxJ2yNt2RAThHaOj139UI2xkVCrk7mZqUkjG0Wds
Upy2P8L42vo+zatanaqb8INOEQ5pnya8NOsDCiXqi+f42XDX/TAcd3mnkVBgKbUp
cZ+2UXw0JNVHmNFiLJusVfcOyaZKF02r3kb0OmI1qrYRdWOJbaFzUKWJv4KrzZu6
WFnz7v36wEUWsR+e57EwdN6rSKIGMvFS/i4UTUEScpinueSAcRZ8UKGgVKcnu9zC
U2cTROIgoqF98Gv1060k
=3tw8
-----END PGP SIGNATURE-----

--3uo+9/B/ebqu+fSQ--
