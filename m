Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:35666 "EHLO
	mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbcGQDV6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Jul 2016 23:21:58 -0400
Received: by mail-lf0-f52.google.com with SMTP id f93so111373903lfi.2
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Jul 2016 20:21:57 -0700 (PDT)
Subject: Re: Size reported differently between profiles
To: =?UTF-8?Q?S=c3=a9bastien_Luttringer?= <seblu@seblu.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <1468721359.19617.169.camel@seblu.net>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <578AF9CC.2060404@gmail.com>
Date: Sun, 17 Jul 2016 06:21:48 +0300
MIME-Version: 1.0
In-Reply-To: <1468721359.19617.169.camel@seblu.net>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="wV4KSBCDmCEj2VBfeJUBFqIqJkmSDHGB3"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wV4KSBCDmCEj2VBfeJUBFqIqJkmSDHGB3
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

17.07.2016 05:09, S=C3=A9bastien Luttringer =D0=BF=D0=B8=D1=88=D0=B5=D1=82=
:
> Hello,
>=20
> =C2=ABbtrfs fi usage=C2=BB report size differently between single,RAID0=
,RAID1,RAID5,RAID6
> and RAID10.
>=20
> The test is done with 2 files of 1.4GiB each on 4x10GiB devices. I used=
 balance
> to get size between profiles.
>=20
> Data,single: Size:4.00GiB, Used:2.85GiB
>    /dev/sdb	   1.00GiB
>    /dev/sdc	   1.00GiB
>    /dev/sdd	   1.00GiB
>    /dev/sde	   1.00GiB
>=20
> Data,RAID0: Size:8.00GiB, Used:2.85GiB
>    /dev/sdb	   2.00GiB
>    /dev/sdc	   2.00GiB
>    /dev/sdd	   2.00GiB
>    /dev/sde	   2.00GiB
>=20
> Data,RAID1: Size:4.00GiB, Used:2.85GiB
>    /dev/sdb	   2.00GiB
>    /dev/sdc	   2.00GiB
>    /dev/sdd	   2.00GiB
>    /dev/sde	   2.00GiB
>=20
> Data,RAID5: Size:6.00GiB, Used:2.85GiB
>    /dev/sdb	   2.00GiB
>    /dev/sdc	   2.00GiB
>    /dev/sdd	   2.00GiB
>    /dev/sde	   2.00GiB
>=20
> Data,RAID6: Size:6.00GiB, Used:2.85GiB
>    /dev/sdb	   3.00GiB
>    /dev/sdc	   3.00GiB
>    /dev/sdd	   3.00GiB
>    /dev/sde	   3.00GiB
>=20
> Data,RAID10: Size:4.00GiB, Used:2.85GiB
>    /dev/sdb	   1.00GiB
>    /dev/sdc	   1.00GiB
>    /dev/sdd	   1.00GiB
>    /dev/sde	   1.00GiB
>=20
> For single,RAID0,RAID10 profiles, the sum of device sizes is equal to
> total size. Like total size is the "byte allocated size" for all
> devices.
>=20
> For RAID1,RAID5,RAID6 profiles, sum of devices sizes is more than the
> total size. Looks like the redundancy was subtracted from the total.=20
> Like total size is the "profile size allocated".
>=20
> So, why RAID1 and RAID10 are reporting their sizes differently? This
> confuse me.
>=20

In your example only RAID10 is different. RAID1 shows 4GiB on 8GiB total
disks which matches "redundancy subtracted". But yes, I also wonder why
RAID10 does not respect it.


--wV4KSBCDmCEj2VBfeJUBFqIqJkmSDHGB3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAleK+dIACgkQR6LMutpd94zqtwCgvmNOUUht5sRALe0nqcpBLEyJ
foYAn0hcenJvCqcbLj0mH55h0MqpByHP
=Ocqn
-----END PGP SIGNATURE-----

--wV4KSBCDmCEj2VBfeJUBFqIqJkmSDHGB3--
