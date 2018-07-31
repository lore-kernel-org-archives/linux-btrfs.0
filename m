Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:46393 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731288AbeGaCef (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Jul 2018 22:34:35 -0400
Subject: Re: csum failed on raid1 even after clean scrub?
To: Sterling Windmill <swindmill@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAMOu_z0HuviCqK9fFFjFA52GMbbWCVmd4GgORzwx754j+JAfDg@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <09e9001a-b624-cc78-eee5-3dd139eb02bc@gmx.com>
Date: Tue, 31 Jul 2018 08:56:51 +0800
MIME-Version: 1.0
In-Reply-To: <CAMOu_z0HuviCqK9fFFjFA52GMbbWCVmd4GgORzwx754j+JAfDg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vLamB3h80WXq2GhWEMYb80i4Yk9Gn43wx"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vLamB3h80WXq2GhWEMYb80i4Yk9Gn43wx
Content-Type: multipart/mixed; boundary="AhIFSMheJHaIPCVSsYA5wp8vQUlsWJ6NW";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Sterling Windmill <swindmill@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <09e9001a-b624-cc78-eee5-3dd139eb02bc@gmx.com>
Subject: Re: csum failed on raid1 even after clean scrub?
References: <CAMOu_z0HuviCqK9fFFjFA52GMbbWCVmd4GgORzwx754j+JAfDg@mail.gmail.com>
In-Reply-To: <CAMOu_z0HuviCqK9fFFjFA52GMbbWCVmd4GgORzwx754j+JAfDg@mail.gmail.com>

--AhIFSMheJHaIPCVSsYA5wp8vQUlsWJ6NW
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8831=E6=97=A5 08:43, Sterling Windmill wrote:
> I am using a two disk raid1 btrfs filesystem spanning two external hard=

> drives connected via USB 3.0.

Is there any speed difference between the two device?
And are these 2 devices under the same USB3.0 root hub or different root
hubs?

lsusb output could help to determine the hierarchy.

>=20
> While copying ~6TB of data from this filesystem to local disk via rsync=

> I am seeing messages like the following in dmesg output:
>=20
> [ 2213.406267] BTRFS warning (device sdj1): csum failed root 5 ino 830
> off 2124197888 csum 0xb5da0cd2 expected csum 0x6e478250 mirror 2

Since only one copy shows the problem, the other copy should be good
thus the read should work without problem.

> [ 4890.178727] BTRFS warning (device sdj1): csum failed root 5 ino 1058=

> off 26052067328 csum 0x8ccd1067 expected csum 0x4adb8254 mirror 2
> [27463.940218] BTRFS warning (device sdj1): csum failed root 5 ino 5372=

> off 7954096128 csum 0x9f9b697e expected csum 0xbd61a0e2 mirror 2
> [29405.832643] BTRFS warning (device sdj1): csum failed root 5 ino 3137=
4
> off 7893983232 csum 0x12fd0ddc expected csum 0xddcd2f8e mirror 2
> [31224.279082] BTRFS warning (device sdj1): csum failed root 5 ino
> 150903 off 183635968 csum 0xea025eb4 expected csum 0x46d64878 mirror 2
> [32282.635615] BTRFS warning (device sdj1): csum failed root 5 ino
> 162774 off 31092424704 csum 0x1ee9b38d expected csum 0x4022e3de mirror =
2
> [41052.643493] BTRFS warning (device sdj1): csum failed root 5 ino
> 163742 off 52214816768 csum 0x6723208c expected csum 0x0377e68a mirror =
2
> [47723.500430] BTRFS warning (device sdj1): csum failed root 5 ino
> 470775 off 12533760 csum 0x9f50f9a0 expected csum 0x23ddc68e mirror 2
> [60060.843425] BTRFS warning (device sdj1): csum failed root 5 ino
> 786762 off 4178321408 csum 0xcd520ead expected csum 0x46fe6ebc mirror 2=

> [60900.058745] BTRFS warning (device sdj1): csum failed root 5 ino
> 786900 off 896303104 csum 0x4c7e26e7 expected csum 0x86554095 mirror 2
> [68149.417236] BTRFS warning (device sdj1): csum failed root 5 ino 1058=

> off 3101224960 csum 0x2b8c363c expected csum 0x8df2991a mirror 1
> [69072.272010] BTRFS warning (device sdj1): csum failed root 5 ino 1141=

> off 2939588608 csum 0xa2969f63 expected csum 0xddf33efd mirror 1
> [71342.354453] BTRFS warning (device sdj1): csum failed root 5 ino 1328=

> off 57047568384 csum 0xd57f5bb7 expected csum 0x421f96e5 mirror 1
>=20
> Because the device was consistent, it seemed that one of the disks held=

> bad data. I wasn't sure if btrfs was correcting the issue by using the
> other seemingly good copy on the second disk or if I was copying bad
> data to the destination filesystem, so I aborted the copy and ran a
> scrub of the filesystem that includes sdj1 by issuing the following com=
mand:
>=20
> btrfs scrub start /external
>=20
> I let the scrub finish and monitored the result using the following com=
mand:
>=20
> btrfs scrub status /external
>=20
> Which showed the following output:
>=20
> scrub status for ece518d2-4af0-4ef7-a31d-8c89b13a5ad9
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 scrub started at Sun Jul 29 11:34:44 2018 a=
nd finished after
> 14:34:58
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 total bytes scrubbed: 12.80TiB with 0 error=
s

Would you provide the dmesg during the scrub?

>=20
> Alright, perhaps btrfs had already fixed the issues upon encountering
> them. I ran my copy again only to see very similar messages show up in
> dmesg:
>=20
> [154842.551604] BTRFS warning (device sdj1): csum failed root 5 ino 128=
4
> off 858886144 csum 0x8caf203c expected csum 0x9a3acab6 mirror 2

At least the corrupted ino and offset is different, thus the old
corruption is fixed, but somehow it introduced new corruption.

> [159949.727412] BTRFS warning (device sdj1): csum failed root 5 ino 163=
6
> off 4463370240 csum 0x8dfaf00c expected csum 0xa7ab457e mirror 2
> [160911.893913] BTRFS warning (device sdj1): csum failed root 5 ino 172=
9
> off 8181428224 csum 0xd57845b5 expected csum 0x6904c54e mirror 2
> [165210.245890] BTRFS warning (device sdj1): csum failed root 5 ino 292=
7
> off 1013219328 csum 0xf2d2820d expected csum 0x812222bb mirror 2
> [169279.620570] BTRFS warning (device sdj1): csum failed root 5 ino 336=
3
> off 900493312 csum 0x6c6a35a2 expected csum 0x2a983a9c mirror 2
> [169990.401373] BTRFS warning (device sdj1): csum failed root 5 ino 427=
7
> off 186707968 csum 0xbdd075d5 expected csum 0xf302e9df mirror 2
> [171411.085425] BTRFS warning (device sdj1): csum failed root 5 ino 471=
9
> off 593842176 csum 0xcdabc7e6 expected csum 0xc137d47a mirror 2
> [173370.025471] BTRFS warning (device sdj1): csum failed root 5 ino 526=
7
> off 2605592576 csum 0xcd2cb8a8 expected csum 0x9de364e9 mirror 2
> [180329.942125] BTRFS warning (device sdj1): csum failed root 5 ino
> 162774 off 22459506688 csum 0xc38e7a53 expected csum 0xad11854c mirror =
2

Since all corruption showed above is about mirror 2, would you mind to
try scrub certain device other than the whole fs and attach the dmesg?

# btrfs scrub start <device>



>=20
> I would have expected the scrub to find these issues or to show some
> number of corrected errors. Perhaps I misunderstand what scrub does?

Your understanding is completely correct.
In fact reading from corrupted block should trigger re-write on
corrupted data.

I'm wondering if it's related to some scrub race, since for multi-device
btrfs, full fs scrub is addressed by doing multiple scrub
simultaneously, one scrub for each device.
It used to cause problem for raid5/6, but never heard of corruption for
raid1.

Would you provide the kernel version and full dmesg (including reading
error and scrub, and later read)?

>=20
> I also tried tracking down individual files via the referenced inode
> numbers with the following command:
>=20
> btrfs inspect-internal inode-resolve $INODE /external
>=20
> And ran checksums of the source and destination versions of these files=

> to find them to be identical. So at least the copy on the source and
> destination appear to match.

Since btrfs will switch to the good copy, the data should be correct.

>=20
> Maybe I'm experiencing some sort of intermittent USB device / bus issue=
?

Full dmesg may help, if there is something related to usb.

Thanks,
Qu

> Can anyone help explain what might be happening here?
>=20
> Thanks!
>=20
>=20
>=20
>=20


--AhIFSMheJHaIPCVSsYA5wp8vQUlsWJ6NW--

--vLamB3h80WXq2GhWEMYb80i4Yk9Gn43wx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltfs9MACgkQwj2R86El
/qg8+gf+O4H7aYCH+bDLDbTs7M30B6wVFbM/dZY+6/vLrk+37gEr/Djm3s41VEyQ
aKbsCPsi1BnKkogL/6LxarxscorYA2DNOyPZQCbLqm0BOulsg8QzajIAdvZ7RRC0
XZbOccbAmO3a71pwkdhT3wRHBu7Cnq/uvRwAqwzRpxrEc7LD5AQhy0/OqcanIw0P
BWsw6oM3cTpt0ohjDTIvWvaUef1VhqNcfUpoQyR8YT047vRskUZHNnb2XE0MqWdZ
tEct9fRaZ6XJ1C/pLWJZ9uRjKImPEuLIWF36TLD6SovpY15sNaCFh+qOFWMJUKkT
sGxIi627J7ro64g1X7CLakrrobWtoA==
=ZhJ7
-----END PGP SIGNATURE-----

--vLamB3h80WXq2GhWEMYb80i4Yk9Gn43wx--
