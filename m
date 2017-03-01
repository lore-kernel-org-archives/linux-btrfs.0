Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:53377 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750993AbdCATjl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Mar 2017 14:39:41 -0500
Received: from thetick.localnet ([93.181.44.247]) by mail.gmx.com (mrgmx002
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0LkgEO-1c8z4I0s2m-00aSpU for
 <linux-btrfs@vger.kernel.org>; Wed, 01 Mar 2017 19:44:10 +0100
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: [4.7.2] btrfs_run_delayed_refs:2963: errno=-17 Object already exists
Date: Wed, 01 Mar 2017 19:43:57 +0100
Message-ID: <18841534.ZaLHQ5fnBc@thetick>
In-Reply-To: <14737660.8idzxVKBRv@thetick>
References: <20160828152908.6e1325b5@jupiter.sol.kaishome.de> <63cf74bb-009a-b422-4390-7562395db31d@cn.fujitsu.com> <14737660.8idzxVKBRv@thetick>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2037212.38JYzxZTi9"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart2037212.38JYzxZTi9
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Wednesday 01 March 2017 19:14:07 Marc Joliet wrote:
> > > Also, the image is complete, so I only need to find somewhere whe=
re I
> > > can
> > > upload a 9.4 GB file.
> >
> >=20
> >
> > Is it a compressed dump? Dumped with btrfs-image -c9?
>=20
> It was created with:
>=20
> btrfs-image -s -w /dev/sdb2 - | xz -9 --stdout >
> ./btrfs_backup_drive_2.img.xz
>=20
> (Mainly because I felt more comfortable using a separate compression
> utility,  not for any rational reason.  Although if you really meant
> "image" above, I have the feeling I'll regret this decision.)

Ah, never mind, it's not as big as I was worried it would be:

% xz -l btrfs_backup_drive.img.xz=20
 Str.  Bl=C3=B6cke       Kompr.     Unkompr.  Verh.  Check   Dateiname
    1       1  9.589,6 MiB     81,4 GiB  0,115  CRC64  =20
btrfs_backup_drive.img.xz

So 81.4 GB uncompressed.  I have the space to uncompress it if need be.=


=2D-=20
Marc Joliet
=2D-
"People who think they know everything really annoy those of us who kno=
w we
don't" - Bjarne Stroustrup

--nextPart2037212.38JYzxZTi9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJYtxZtAAoJEL/Q5oYsiHj0J+gP/06Mh//APjvikhxBN8h3V9U9
ZJAiiG2Mx+URaix16+yDBhAG4/AdCTCxi1pq2RQI8qt3+comqTiOyZvc2wNjuKQn
d8+dF4z9tOuY0411FrzX48O9N9/zJeDW2RVo1RSLDTWa68NnqBzKO5JN94YRAp79
eGvZzHf9B+P5tsbm2xYhNwsTdwjatkPc1fPm7rvKEcEM9iA85OfSokDLaxJWjNSq
1h4gxI7q4FVfS9yLnodkU+yaKd3O3MoOg4mxjYHWIDppCVz5BvhR2lL1o4Mldrcj
XycXflvfYC6mSzvzMEBd0FU9M5NVN5OA0dEo5HN3FSbcVOWrJlD1IzD33GUyJ5Hx
lT1xGaH4t8zOsvVAQ1svoCX78z5ytJIA2fSsITcWsIXbezcZPEPpHLqTqu9T44Z+
sah/uQSVaIq9w2FUuReXHykJmd+Ew92F6zHM+0Ng51KVqdtV1cd6sRaMW2aLGRzq
GPa2+2hGU2xKYbPekgWmPbFUL0tOmmIGpPlAqfkU6dPyJeAgp0ZpBv9884Hjhk8U
oyjgeDO8Pu+DrgHbR6YB9q3HM1hxiBYpl/bXOXYfrvR2e9i3TjQHb1ExG+Kz+maa
CCs7tSnSU9kQ18vCrzdTbsIxoC57SC/FeRxrFJpfMMuDWL7Ed3uvonHphfCv7Oib
QcFvAj0xCKtKEyZIvLGQ
=su8t
-----END PGP SIGNATURE-----

--nextPart2037212.38JYzxZTi9--

