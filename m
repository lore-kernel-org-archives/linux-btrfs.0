Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:47853 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751330AbcFZTwD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Jun 2016 15:52:03 -0400
Date: Sun, 26 Jun 2016 15:52:00 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Andrei Borzenkov <arvidjaar@gmail.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Hugo Mills <hugo@carfax.org.uk>, kreijack@inwind.it,
        Roman Mamedov <rm@romanrm.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Adventures in btrfs raid5 disk recovery
Message-ID: <20160626195200.GF14667@hungrycats.org>
References: <20160624085014.GH3325@carfax.org.uk>
 <CAA91j0Uqg0FafFTG3NhQt=p8KkYRhTeMU5Bd+JuUxDntP6g8Ng@mail.gmail.com>
 <CAJCQCtQBQAng5_mNJZev+64Z15BSkBkG9f2qmz=ckPRqXRbbWA@mail.gmail.com>
 <576D6C0A.7070502@gmail.com>
 <CAJCQCtSskA4PC_a8tgQopHFNO83NQ=Gkx406haB7G0nBi5e=2A@mail.gmail.com>
 <c2a320a6-261b-723d-ab83-58f883e6315b@gmail.com>
 <CAJCQCtSqO4GNm8kBDuzUXEXYx+54zFgsD6=ARNsRgVUb53LQZw@mail.gmail.com>
 <CAJCQCtQhRbL_AWpspudPZzkkGkHT3O9T0QL94Of5LD8agmonwg@mail.gmail.com>
 <576F8A28.7060808@gmail.com>
 <CAJCQCtSTau3D39TarW2gag0HgW6U9tj8u3gXVTBMTNRy7wMUbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3oCie2+XPXTnK5a5"
In-Reply-To: <CAJCQCtSTau3D39TarW2gag0HgW6U9tj8u3gXVTBMTNRy7wMUbg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--3oCie2+XPXTnK5a5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 26, 2016 at 01:30:03PM -0600, Chris Murphy wrote:
> On Sun, Jun 26, 2016 at 1:54 AM, Andrei Borzenkov <arvidjaar@gmail.com> w=
rote:
> > 26.06.2016 00:52, Chris Murphy =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> >> Interestingly enough, so far I'm finding with full stripe writes, i.e.
> >> 3x raid5, exactly 128KiB data writes, devid 3 is always parity. This
> >> is raid4.
> >
> > That's not what code suggests and what I see in practice - parity seems
> > to be distributed across all disks; each new 128KiB file (extent) has
> > parity on new disk. At least as long as we can trust btrfs-map-logical
> > to always show parity as "mirror 2".
>=20
>=20
> tl;dr Andrei is correct there's no raid4 behavior here.
>=20
> Looks like mirror 2 is always parity, more on that below.
>=20
>=20
> >
> > Do you see consecutive full stripes in your tests? Or how do you
> > determine which devid has parity for a given full stripe?
>=20
> I do see consecutive full stripe writes, but it doesn't always happen.
> But not checking the consecutivity is where I became confused.
>=20
> [root@f24s ~]# filefrag -v /mnt/5/ab*
> Filesystem type is: 9123683e
> File size of /mnt/5/ab128_2.txt is 131072 (32 blocks of 4096 bytes)
>  ext:     logical_offset:        physical_offset: length:   expected: fla=
gs:
>    0:        0..      31:    3456128..   3456159:     32:             las=
t,eof
> /mnt/5/ab128_2.txt: 1 extent found
> File size of /mnt/5/ab128_3.txt is 131072 (32 blocks of 4096 bytes)
>  ext:     logical_offset:        physical_offset: length:   expected: fla=
gs:
>    0:        0..      31:    3456224..   3456255:     32:             las=
t,eof
> /mnt/5/ab128_3.txt: 1 extent found
> File size of /mnt/5/ab128_4.txt is 131072 (32 blocks of 4096 bytes)
>  ext:     logical_offset:        physical_offset: length:   expected: fla=
gs:
>    0:        0..      31:    3456320..   3456351:     32:             las=
t,eof
> /mnt/5/ab128_4.txt: 1 extent found
> File size of /mnt/5/ab128_5.txt is 131072 (32 blocks of 4096 bytes)
>  ext:     logical_offset:        physical_offset: length:   expected: fla=
gs:
>    0:        0..      31:    3456352..   3456383:     32:             las=
t,eof
> /mnt/5/ab128_5.txt: 1 extent found
> File size of /mnt/5/ab128_6.txt is 131072 (32 blocks of 4096 bytes)
>  ext:     logical_offset:        physical_offset: length:   expected: fla=
gs:
>    0:        0..      31:    3456384..   3456415:     32:             las=
t,eof
> /mnt/5/ab128_6.txt: 1 extent found
> File size of /mnt/5/ab128_7.txt is 131072 (32 blocks of 4096 bytes)
>  ext:     logical_offset:        physical_offset: length:   expected: fla=
gs:
>    0:        0..      31:    3456416..   3456447:     32:             las=
t,eof
> /mnt/5/ab128_7.txt: 1 extent found
> File size of /mnt/5/ab128_8.txt is 131072 (32 blocks of 4096 bytes)
>  ext:     logical_offset:        physical_offset: length:   expected: fla=
gs:
>    0:        0..      31:    3456448..   3456479:     32:             las=
t,eof
> /mnt/5/ab128_8.txt: 1 extent found
> File size of /mnt/5/ab128_9.txt is 131072 (32 blocks of 4096 bytes)
>  ext:     logical_offset:        physical_offset: length:   expected: fla=
gs:
>    0:        0..      31:    3456480..   3456511:     32:             las=
t,eof
> /mnt/5/ab128_9.txt: 1 extent found
> File size of /mnt/5/ab128.txt is 131072 (32 blocks of 4096 bytes)
>  ext:     logical_offset:        physical_offset: length:   expected: fla=
gs:
>    0:        0..      31:    3456096..   3456127:     32:             las=
t,eof
> /mnt/5/ab128.txt: 1 extent found
>=20
> Starting with the bottom file then from the top so they're in 4096
> byte block order; and the 2nd column is the difference in value:
>=20
> 3456096
> 3456128 32
> 3456224 96
> 3456320 96
> 3456352 32
> 3456384 32
> 3456416 32
> 3456448 32
> 3456480 32
>=20
> So the first two files are consecutive full stripe writes. The next
> two aren't. The next five are. They were all copied at the same time.
> I don't know why they aren't always consecutive writes.

The logical addresses don't include parity stripes, so you won't find
them with FIEMAP.  Parity locations are calculated after the logical ->
(disk, chunk_offset) translation is done (it's the same chunk_offset on
every disk, but one of the disks is parity while the others are data).

> [root@f24s ~]# btrfs-map-logical -l $[4096*3456096] /dev/VG/a
> mirror 1 logical 14156169216 physical 1108541440 device /dev/mapper/VG-a
> mirror 2 logical 14156169216 physical 2182283264 device /dev/mapper/VG-c
> [root@f24s ~]# btrfs-map-logical -l $[4096*3456128] /dev/VG/a
> mirror 1 logical 14156300288 physical 1075052544 device /dev/mapper/VG-b
> mirror 2 logical 14156300288 physical 1108606976 device /dev/mapper/VG-a
> [root@f24s ~]# btrfs-map-logical -l $[4096*3456224] /dev/VG/a
> mirror 1 logical 14156693504 physical 1075249152 device /dev/mapper/VG-b
> mirror 2 logical 14156693504 physical 1108803584 device /dev/mapper/VG-a
> [root@f24s ~]# btrfs-map-logical -l $[4096*3456320] /dev/VG/a
> mirror 1 logical 14157086720 physical 1075445760 device /dev/mapper/VG-b
> mirror 2 logical 14157086720 physical 1109000192 device /dev/mapper/VG-a
> [root@f24s ~]# btrfs-map-logical -l $[4096*3456352] /dev/VG/a
> mirror 1 logical 14157217792 physical 2182807552 device /dev/mapper/VG-c
> mirror 2 logical 14157217792 physical 1075511296 device /dev/mapper/VG-b
> [root@f24s ~]# btrfs-map-logical -l $[4096*3456384] /dev/VG/a
> mirror 1 logical 14157348864 physical 1109131264 device /dev/mapper/VG-a
> mirror 2 logical 14157348864 physical 2182873088 device /dev/mapper/VG-c
> [root@f24s ~]# btrfs-map-logical -l $[4096*3456416] /dev/VG/a
> mirror 1 logical 14157479936 physical 1075642368 device /dev/mapper/VG-b
> mirror 2 logical 14157479936 physical 1109196800 device /dev/mapper/VG-a
> [root@f24s ~]# btrfs-map-logical -l $[4096*3456448] /dev/VG/a
> mirror 1 logical 14157611008 physical 2183004160 device /dev/mapper/VG-c
> mirror 2 logical 14157611008 physical 1075707904 device /dev/mapper/VG-b
> [root@f24s ~]# btrfs-map-logical -l $[4096*3456480] /dev/VG/a
> mirror 1 logical 14157742080 physical 1109327872 device /dev/mapper/VG-a
> mirror 2 logical 14157742080 physical 2183069696 device /dev/mapper/VG-c
>=20
>=20
> To confirm/deny mirror 2 is parity (128KiB file is 64KiB "a", 64KiB
> "b", so expected parity is 0x03; if it's always 128KiB of the same
> value then parity is 0x00 and can result in confusion/mistakes with
> unwritten free space).
>=20
> [root@f24s ~]# dd if=3D/dev/VG/c bs=3D1 count=3D65536 skip=3D2182283264
> 2>/dev/null | hexdump -C
> 00000000  03 03 03 03 03 03 03 03  03 03 03 03 03 03 03 03  |............=
=2E...|
> *
> 00010000
> [root@f24s ~]# dd if=3D/dev/VG/a bs=3D1 count=3D65536 skip=3D1108606976
> 2>/dev/null | hexdump -C
> 00000000  03 03 03 03 03 03 03 03  03 03 03 03 03 03 03 03  |............=
=2E...|
> *
> 00010000
> [root@f24s ~]# dd if=3D/dev/VG/a bs=3D1 count=3D65536 skip=3D1108803584
> 2>/dev/null | hexdump -C
> 00000000  03 03 03 03 03 03 03 03  03 03 03 03 03 03 03 03  |............=
=2E...|
> *
> 00010000
> [root@f24s ~]# dd if=3D/dev/VG/a bs=3D1 count=3D65536 skip=3D1109000192
> 2>/dev/null | hexdump -C
> 00000000  03 03 03 03 03 03 03 03  03 03 03 03 03 03 03 03  |............=
=2E...|
> *
> 00010000
> [root@f24s ~]# dd if=3D/dev/VG/b bs=3D1 count=3D65536 skip=3D1075511296
> 2>/dev/null | hexdump -C
> 00000000  03 03 03 03 03 03 03 03  03 03 03 03 03 03 03 03  |............=
=2E...|
> *
> 00010000
> [root@f24s ~]# dd if=3D/dev/VG/c bs=3D1 count=3D65536 skip=3D2182873088
> 2>/dev/null | hexdump -C
> 00000000  03 03 03 03 03 03 03 03  03 03 03 03 03 03 03 03  |............=
=2E...|
> *
> 00010000
> [root@f24s ~]# dd if=3D/dev/VG/a bs=3D1 count=3D65536 skip=3D1109196800
> 2>/dev/null | hexdump -C
> 00000000  03 03 03 03 03 03 03 03  03 03 03 03 03 03 03 03  |............=
=2E...|
> *
> 00010000
> [root@f24s ~]# dd if=3D/dev/VG/b bs=3D1 count=3D65536 skip=3D1075707904
> 2>/dev/null | hexdump -C
> 00000000  03 03 03 03 03 03 03 03  03 03 03 03 03 03 03 03  |............=
=2E...|
> *
> 00010000
> [root@f24s ~]# dd if=3D/dev/VG/c bs=3D1 count=3D65536 skip=3D2183069696
> 2>/dev/null | hexdump -C
> 00000000  03 03 03 03 03 03 03 03  03 03 03 03 03 03 03 03  |............=
=2E...|
> *
> 00010000
>=20
> Ok so in particular the last five, parity is on device b, c, a, b, c -
> that suggests it's distributing parity on consecutive full stripe
> writes.
>=20
> Where I became confused is, there's not always a consecutive write,
> and that's what ends up causing parity to end up on one device less
> often. In the above example, parity goes 4x VG/a, 3x VG/c, and 2x
> VG/b.
>=20
> Basically it's a bad test. The sample size is too small. I'd need to
> increase the sample size by a ton in order to know for sure if this is
> really a problem.
>=20
>=20
> >This
> > information is not actually stored anywhere, it is computed based on
> > block group geometry and logical stripe offset.
>=20
> I think you're right. A better test is a scrub or balance on a raid5
> that's exhibiting slowness, and find out if there's disk contention on
> that system, and whether it's the result of parity not being
> distributed enough.
>=20
>=20
> > P.S. usage of "stripe" to mean "stripe element" actually adds to
> > confusion when reading code :)
>=20
> It's confusing everywhere. mdadm chunk =3D strip =3D stripe element. And
> then LVM introduces -i --stripes which means "data strips" i.e. if you
> choose -i 3 with raid6 segment type, you get 5 strips per stripe (3
> data 2 parity). It's horrible.
>=20
>=20
>=20
>=20
> --=20
> Chris Murphy
>=20

--3oCie2+XPXTnK5a5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAldwMmAACgkQgfmLGlazG5wpvwCgxn2t24Jmf9oSTNsqKWakUcCr
/eYAniFPRgpGU1Zyfz39XtCyZMCTMWnp
=bLDl
-----END PGP SIGNATURE-----

--3oCie2+XPXTnK5a5--
