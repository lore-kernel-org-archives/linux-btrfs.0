From: Michal Hrusecky <mhrusecky@suse.cz>
Subject: Re: Segfault when transid verify fails
Date: Sat, 5 Dec 2009 13:06:02 +0100
Message-ID: <20091205120602.GA4476@misibook.miska.isageek.net>
References: <20091204122802.GA1644@misibook.miska.isageek.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i0/AhcQY5QxfSsSZ"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091204122802.GA1644@misibook.miska.isageek.net>
List-ID: <linux-btrfs.vger.kernel.org>


--i0/AhcQY5QxfSsSZ
Content-Type: multipart/mixed; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Michal Hrusecky - 13:28  4.12.09 wrote:
> Hi,
>=20
> I'm trying to use btrfs on my other Linux installation as a root
> filesystem. Somehow I cannot boot any longer and I've got dmesg full of
> repeating error lines. So I booted up my other Linux system and tried to
> run btrfsck, but it segfaults after producing similar error message:
>=20
> # btrfsck /dev/disk/by-label/suse
> parent transid verify failed on 67510272 wanted 352 found 394
> Segmentation fault
>=20
> I tried both btrfs-progs 0.19 and current git of btrfs-progs. I'm
> running 2.6.32 vanilla kernel. I can provide strace and probably try to
> obtain some backtrace, but I guess as I cannot boot system with this
> rootfs that the error will be somewhere deeper...

Attaching backtrace.

My guess is that this is a bug and kernel shouldn't be stuck in endless
loop and btrfsck shouldn't crash, but suggest some solution. Didn't
found btrfs bugzilla so reporting via mailing list.

Bets Regards,
	Michal Hrusecky

--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="btrc.txt"
Content-Transfer-Encoding: quoted-printable

GNU gdb (Gentoo 7.0 p1) 7.0
Copyright (C) 2009 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.htm=
l>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "x86_64-pc-linux-gnu".
For bug reporting instructions, please see:
<http://bugs.gentoo.org/>...
Reading symbols from /sbin/btrfsck...done.
(gdb) run /dev/sda3
Starting program: /sbin/btrfsck /dev/sda3

Program received signal SIGSEGV, Segmentation fault.
find_first_block_group (root=3D0x6231b0, path=3D0x624650, key=3D0x7fffffffd=
be0) at ctree.h:1411
	in ctree.h
(gdb) bt full
#0  find_first_block_group (root=3D0x6231b0, path=3D0x624650, key=3D0x7ffff=
fffdbe0) at ctree.h:1411
        ret =3D <value optimized out>
        leaf =3D 0x0
        slot =3D 0
#1  0x000000000040e6d0 in btrfs_read_block_groups (root=3D<value optimized =
out>) at extent-tree.c:3072
        path =3D 0x624650
        ret =3D 506462208
        bit =3D 4
        cache =3D 0x624e30
        info =3D 0x623830
        space_info =3D 0x624eb0
        block_group_cache =3D 0x623908
        key =3D {objectid =3D 540016640, type =3D 192 '\300', offset =3D 0}
        found_key =3D {objectid =3D 33554432, type =3D 192 '\300', offset =
=3D 506462208}
        leaf =3D <value optimized out>
        __PRETTY_FUNCTION__ =3D "btrfs_read_block_groups"
#2  0x000000000040c3a5 in open_ctree_fd (fp=3D<value optimized out>, path=
=3D<value optimized out>, sb_bytenr=3D<value optimized out>,=20
    writes=3D<value optimized out>) at disk-io.c:760
        sectorsize =3D <value optimized out>
        nodesize =3D 4096
        leafsize =3D 4096
        blocksize =3D <value optimized out>
        stripesize =3D <value optimized out>
        generation =3D <value optimized out>
        key =3D {objectid =3D 0, type =3D 53 '5', offset =3D 549755281190}
        tree_root =3D 0x623010
        extent_root =3D 0x6231b0
        chunk_root =3D <value optimized out>
        dev_root =3D 0x6234f0
        csum_root =3D 0x623690
        fs_info =3D 0x623830
        ret =3D <value optimized out>
        fs_devices =3D 0x6255e0
        total_devs =3D 1
        features =3D <value optimized out>
        __PRETTY_FUNCTION__ =3D "open_ctree_fd"
#3  0x000000000040c469 in open_ctree (filename=3D0x7fffffffe1b1 "/dev/sda3"=
, sb_bytenr=3D0, writes=3D0) at disk-io.c:587
        fp =3D 0
        root =3D <value optimized out>
        flags =3D <value optimized out>
#4  0x0000000000405b1f in main (ac=3D<value optimized out>, av=3D0x7fffffff=
de78) at btrfsck.c:2824
        root_cache =3D {root =3D {rb_node =3D 0x0, rotate_notify =3D 0x41a7=
45 <__libc_csu_init+69>}}
        root =3D <value optimized out>
        ret =3D <value optimized out>
(gdb) quit
A debugging session is active.

	Inferior 1 [process 28846] will be killed.

Quit anyway? (y or n)=20
--NzB8fVQJ5HfG6fxh--

--i0/AhcQY5QxfSsSZ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.13 (GNU/Linux)

iEYEARECAAYFAksaTKoACgkQJkqfF/7WVvbt7ACfasQWZ7z7W0iGiu2DZ8XzFanh
uakAniWocI4q7YGEfGlsq/1uCPox0MWE
=9Xql
-----END PGP SIGNATURE-----

--i0/AhcQY5QxfSsSZ--
