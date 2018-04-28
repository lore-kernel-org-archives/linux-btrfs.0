Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:58745 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759215AbeD1CGG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Apr 2018 22:06:06 -0400
Subject: Re: NVMe SSD + compression - benchmarking
To: Brendan Hide <brendan@swiftspirit.co.za>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <5be6d7f3-c905-dc7b-56e0-4c4be60ea952@swiftspirit.co.za>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <e80e34ff-3d1c-99da-e622-4576c2dc8329@gmx.com>
Date: Sat, 28 Apr 2018 10:05:57 +0800
MIME-Version: 1.0
In-Reply-To: <5be6d7f3-c905-dc7b-56e0-4c4be60ea952@swiftspirit.co.za>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2Xu6uChV3DxNqKau2rrv6rRTivWa7TWbS"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2Xu6uChV3DxNqKau2rrv6rRTivWa7TWbS
Content-Type: multipart/mixed; boundary="7Fon5sbN6czSYEIcr6jPIrQSS2Z6kOzEE";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Brendan Hide <brendan@swiftspirit.co.za>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <e80e34ff-3d1c-99da-e622-4576c2dc8329@gmx.com>
Subject: Re: NVMe SSD + compression - benchmarking
References: <5be6d7f3-c905-dc7b-56e0-4c4be60ea952@swiftspirit.co.za>
In-Reply-To: <5be6d7f3-c905-dc7b-56e0-4c4be60ea952@swiftspirit.co.za>

--7Fon5sbN6czSYEIcr6jPIrQSS2Z6kOzEE
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B404=E6=9C=8828=E6=97=A5 01:41, Brendan Hide wrote:
> Hey, all
>=20
> I'm following up on the queries I had last week since I have installed
> the NVMe SSD into the PCI-e adapter. I'm having difficulty knowing
> whether or not I'm doing these benchmarks correctly.
>=20
> As a first test, I put together a 4.7GB .tar containing mostly
> duplicated copies of the kernel source code (rather compressible).
> Writing this to the SSD I was seeing repeatable numbers - but noted tha=
t
> the new (supposedly faster) zstd compression is noticeably slower than
> all other methods. Perhaps this is partly due to lack of
> multi-threading? No matter, I did also notice a supposedly impossible
> stat when there is no compression, in that it seems to be faster than
> the PCI-E 2.0 bus theoretically can deliver:

I'd say the test method is more like real world usage other than benchmar=
k.
Moreover, the kernel source copying is not that good for compression, as
mostly of the files are smaller than 128K, which means they can't take
much advantage of multi thread split based on 128K.

And kernel source is consistent of multiple small files, and btrfs is
really slow for metadata heavy workload.

I'd recommend to start with simpler workload, then go step by step
towards more complex workload.

Large file sequence write with large block size would be a nice start
point, as it could take all advantage of multithread compression.


Another advice here is, if you really want a super fast storage, and
there is plenty memory, brd module will be your best friend.
And for modern mainstream hardware, brd could provide performance over
1GiB/s:
$ sudo modprobe brd rd_nr=3D1 rd_size=3D2097152
$ LANG=3DC dd if=3D/dev/zero  bs=3D1M of=3D/dev/ram0  count=3D2048
2048+0 records in
2048+0 records out
2147483648 bytes (2.1 GB, 2.0 GiB) copied, 1.45593 s, 1.5 GB/s

Thanks,
Qu

>=20
> compression type / write speed / read speed (in GBps)
> zlib / 1.24 / 2.07
> lzo / 1.17 / 2.04
> zstd / 0.75 / 1.97
> no / 1.42 / 2.79
>=20
> The SSD is PCI-E 3.0 4-lane capable and is connected to a PCI-E 2.0
> 16-lane slot. lspci -vv confirms it is using 4 lanes. This means it's
> peak throughput *should* be 2.0 GBps - but above you can see the averag=
e
> read benchmark is 2.79GBps. :-/
>=20
> The crude timing script I've put together does the following:
> - Format the SSD anew with btrfs and no custom settings
> - wait 180 seconds for possible hardware TRIM to settle (possibly
> overkill since the SSD is new)
> - Mount the fs using all defaults except for compression, which could b=
e
> of zlib, lzo, zstd, or no
> - sync
> - Drop all caches
> - Time the following
> =C2=A0- Copy the file to the test fs (source is a ramdisk)
> =C2=A0- sync
> - Drop all caches
> - Time the following
> =C2=A0- Copy back from the test fs to ramdisk
> =C2=A0- sync
> - unmount
>=20
> I can see how, with compression, it *can* be faster than 2 GBps (though=

> it isn't). But I cannot see how having no compression could possibly be=

> faster than 2 GBps. :-/
>=20
> I can of course get more info if it'd help figure out this puzzle:
>=20
> Kernel info:
> Linux localhost.localdomain 4.16.3-1-vfio #1 SMP PREEMPT Sun Apr 22
> 12:35:45 SAST 2018 x86_64 GNU/Linux
> ^ Close to the regular ArchLinux kernel - but with vfio, and compiled
> with -arch=3Dnative. See https://aur.archlinux.org/pkgbase/linux-vfio/
>=20
> CPU model:
> model name=C2=A0=C2=A0=C2=A0 : Intel(R) Core(TM) i7-3770 CPU @ 3.40GHz
>=20
> Motherboard model:
> Product Name: Z68MA-G45 (MS-7676)
>=20
> lspci output for the slot:
> 02:00.0 Non-Volatile memory controller: Samsung Electronics Co Ltd NVMe=

> SSD Controller SM961/PM961
> ^ The disk id sans serial is Samsung_SSD_960_EVO_1TB
>=20
> dmidecode output for the slot:
> Handle 0x001E, DMI type 9, 17 bytes
> System Slot Information
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Designation: J8B4
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Type: x16 PCI Express
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Current Usage: In Use
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Length: Long
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ID: 4
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Characteristics:
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 3.3 V is provided
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 Opening is shared
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 PME signal is supported
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Bus Address: 0000:02:01.1
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--7Fon5sbN6czSYEIcr6jPIrQSS2Z6kOzEE--

--2Xu6uChV3DxNqKau2rrv6rRTivWa7TWbS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrj1wUACgkQwj2R86El
/qge6gf8DppGuflFx6XdKBhSLPjqv+fh29fXAodJYP1o1F1bVzlzyLA5gSfe0sxf
OTsMgJdd4fhNSymo4J+O+MLKf/dGztPcazE88TuVIXhjqaXWwr1NCtGADTvnGSJ8
M3hx/RfBy6F7jMLq2/4C4o41qgSkDLWyz+Tj+fTaxWPP7g1cD229/pKSQtrIVnVL
kD83KxkrcUvYZDA1IMqQMkCAB++LiRt+vvSVdzV4jLGGGzT/U/q7ZrkUOalIpnqR
8v9CKWOoBP9BFh4TAfs15VEEdd8Cnm46ItKOPAIGKJwrCiGyNLUejgLIvSNPt0Qh
z8KeFSPdItapEDaP1ohLFmjL+T0NhA==
=Aw2T
-----END PGP SIGNATURE-----

--2Xu6uChV3DxNqKau2rrv6rRTivWa7TWbS--
