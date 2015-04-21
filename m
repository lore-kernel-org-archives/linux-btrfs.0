Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:41889 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750775AbbDUPRR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Apr 2015 11:17:17 -0400
Date: Tue, 21 Apr 2015 11:17:14 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Lukas Lueg <lukas.lueg@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Carefully crafted BTRFS-image causes kernel to crash
Message-ID: <20150421151714.GA19017@hungrycats.org>
References: <CAJF-kYngS4U6=oiXhs0ZF3Na3ezTGcMX1Wyd5HVVm887V61mWw@mail.gmail.com>
 <5535C11C.2050308@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
In-Reply-To: <5535C11C.2050308@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 21, 2015 at 11:16:44AM +0800, Qu Wenruo wrote:
> -------- Original Message  --------
> Subject: Carefully crafted BTRFS-image causes kernel to crash
> From: Lukas Lueg <lukas.lueg@gmail.com>
> To: <linux-btrfs@vger.kernel.org>
> Date: 2015=E5=B9=B404=E6=9C=8821=E6=97=A5 07:04
>=20
> >See also https://bugzilla.kernel.org/show_bug.cgi?id=3D96971
> >
> >
> >I've identified some problems in the btrfs code and attached a
> >btrfs-image which causes the userland tools to crash and the kernel to
> >immediately freeze once the filesystem get's mounted and one of the
> >files is accessed. Putting the image onto a usb-drive gives you a
> >freeze-on-a-stick :-)
> >
> >"btrfs check" crashes due to a SIGFPE in count_csum_range(). The
> >culprit is struct btrfs_root->fs_info->super_copy->csum_size being 0,
> >which goes unchecked before entering a division.
> >I was not able to identify where the kernel crashes (system goes down
> >the tubes), yet the problem is probably the same.
> Thanks for the bug report.
>=20
> Although we may add extra check for such problem to improve robustness,
> but IMHO it's not a real world problem.

It depends on context.

If your real world involves putting hostile USB sticks into your computer
(e.g. you are a lawyer and your day job involves receiving electronic
documents from hostile and sometimes technically sophisticated opponents),
then this is definitely a real world problem.  It needs to be treated as a
security vulnerability (a minor one, given the requirement for physical
access and no data loss except for the kernel crash), maybe assigned a
CVE, and fixed with some urgency.

If your real world involves running racks of machines with no USB ports
in a locked data center then this issue is irrelevant noise.  Other btrfs
issues are *much* more likely to crash the kernel before this one.  ;)

> For normal case, csum will not be zero for sure.
> And even for corrupted superblock, sb csum will prevent btrfs from using =
it.
>=20
> This problem will only happen, as your mentioned, by a specially
> crafted image or a known bug which btrfs will still use corruped sb
> even sb csum dismatches.
>=20
> Thanks,
> Qu
> >
> >"btrfs version" is v3.19.1; bug is also present in latest git (kdave
> >and unstable) as of 2015/04/21
> >
> >
> >Full gdb output:
> >
> >gdb btrfs
> >GNU gdb (GDB) Fedora 7.8.2-38.fc21
> >Copyright (C) 2014 Free Software Foundation, Inc.
> >License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.=
html>
> >This is free software: you are free to change and redistribute it.
> >There is NO WARRANTY, to the extent permitted by law.  Type "show copyin=
g"
> >and "show warranty" for details.
> >This GDB was configured as "x86_64-redhat-linux-gnu".
> >Type "show configuration" for configuration details.
> >For bug reporting instructions, please see:
> ><http://www.gnu.org/software/gdb/bugs/>.
> >Find the GDB manual and other documentation resources online at:
> ><http://www.gnu.org/software/gdb/documentation/>.
> >For help, type "help".
> >Type "apropos word" to search for commands related to "word"...
> >Reading symbols from btrfs...Reading symbols from
> >/usr/lib/debug/usr/sbin/btrfs.debug...done.
> >done.
> >(gdb) run check btrfs_fukked.bin
> >Starting program: /usr/sbin/btrfs check btrfs_fukked.bin
> >[Thread debugging using libthread_db enabled]
> >Using host libthread_db library "/lib64/libthread_db.so.1".
> >Checking filesystem on btrfs_fukked.bin
> >UUID: cdd8684f-9eb1-40a4-91ec-1ed7c3cb444c
> >checking extents
> >checking free space cache
> >checking fs roots
> >
> >Program received signal SIGFPE, Arithmetic exception.
> >count_csum_range (root=3D<optimized out>, root=3D<optimized out>,
> >     found=3D<synthetic pointer>, len=3D7385088, start=3D7471104) at cmd=
s-check.c:1455
> >1455 csum_end =3D key.offset + (size / csum_size) * root->sectorsize;
> >(gdb) bt
> >#0  count_csum_range (root=3D<optimized out>, root=3D<optimized out>,
> >     found=3D<synthetic pointer>, len=3D7385088, start=3D7471104) at cmd=
s-check.c:1455
> >#1  process_file_extent (active_node=3D0x7fffffffd710, key=3D0x7fffffffd=
680,
> >     slot=3D11, eb=3D<optimized out>, root=3D0x894b10) at cmds-check.c:1=
551
> >#2  process_one_leaf (wc=3D0x7fffffffd6c0, eb=3D<optimized out>, root=3D=
0x894b10)
> >     at cmds-check.c:1617
> >#3  walk_down_tree (level=3D<synthetic pointer>, wc=3D0x7fffffffd6c0,
> >     path=3D0x7fffffffd7f0, root=3D0x894b10) at cmds-check.c:1742
> >#4  check_fs_root (wc=3D0x7fffffffd6c0, root_cache=3D0x7fffffffdb20, roo=
t=3D0x894b10)
> >     at cmds-check.c:3380
> >#5  check_fs_roots (root_cache=3Droot_cache@entry=3D0x7fffffffdb20, root=
=3D0x894b10)
> >     at cmds-check.c:3516
> >#6  0x0000000000428aea in cmd_check (argc=3D<optimized out>,
> >     argv=3D<optimized out>) at cmds-check.c:9465
> >#7  0x000000000040e5a2 in main (argc=3D2, argv=3D0x7fffffffdeb0) at btrf=
s.c:245
> >(gdb) p csum_size
> >$2 =3D 0
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlU2afoACgkQgfmLGlazG5xoNgCeJiHVIsQ5Uf2SUnsQpiJqvh5f
fM0AoNAaJoCnHRmWyJqFX+e98Hrwz7IN
=DiUY
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
