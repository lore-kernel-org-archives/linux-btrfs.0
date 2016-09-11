Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.crc.id.au ([203.56.246.92]:41224 "EHLO mail.crc.id.au"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751425AbcIKJ5D (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Sep 2016 05:57:03 -0400
Received: from dhcp-10-1-1-187.lan.crc.id.au (2407-e400-b000-201-4175-b1e5-ad5-c0ce-cpe.spintel.net.au [IPv6:2407:e400:b000:201:4175:b1e5:ad5:c0ce])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        by mail.crc.id.au (Postfix) with ESMTPSA id 6B5E13A00E9
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Sep 2016 19:56:57 +1000 (AEST)
Subject: Re: Is stability a joke?
To: linux-btrfs@vger.kernel.org
References: <57D51BF9.2010907@online.no>
From: Steven Haigh <netwiz@crc.id.au>
Message-ID: <02c31694-a4a7-3b49-11c1-6df9dd08e4f6@crc.id.au>
Date: Sun, 11 Sep 2016 19:56:52 +1000
MIME-Version: 1.0
In-Reply-To: <57D51BF9.2010907@online.no>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="tK6GBOCCKr5rG6pFhVVtmshlIgxUETe3j"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tK6GBOCCKr5rG6pFhVVtmshlIgxUETe3j
Content-Type: multipart/mixed; boundary="cgR0Rw4h0glQscUsXqCrb0vHLGE31MwP1"
From: Steven Haigh <netwiz@crc.id.au>
To: linux-btrfs@vger.kernel.org
Message-ID: <02c31694-a4a7-3b49-11c1-6df9dd08e4f6@crc.id.au>
Subject: Re: Is stability a joke?
References: <57D51BF9.2010907@online.no>
In-Reply-To: <57D51BF9.2010907@online.no>

--cgR0Rw4h0glQscUsXqCrb0vHLGE31MwP1
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

This. So much this.

After being burned badly by the documentation / wiki etc making RAID5/6
seem stable, I think its a joke how the features of BTRFS are promoted.

A lot that is marked as 'Implemented' or 'Complete' is little more than
a "In theory, it works" - but will eat your data.

Having a simple reference as to the status of what is going on, and what
will eat your data would probably save Tb's of data in the next few
months and lots of reputation for BTRFS...

On 11/09/16 18:55, Waxhead wrote:
> I have been following BTRFS for years and have recently been starting t=
o
> use BTRFS more and more and as always BTRFS' stability is a hot topic.
> Some says that BTRFS is a dead end research project while others claim
> the opposite.
>=20
> Taking a quick glance at the wiki does not say much about what is safe
> to use or not and it also points to some who are using BTRFS in product=
ion.
> While BTRFS can apparently work well in production it does have some
> caveats, and finding out what features is safe or not can be problemati=
c
> and I especially think that new users of BTRFS can easily be bitten if
> they do not do a lot of research on it first.
>=20
> The Debian wiki for BTRFS (which is recent by the way) contains a bunch=

> of warnings and recommendations and is for me a bit better than the
> official BTRFS wiki when it comes to how to decide what features to use=
=2E
>=20
> The Nouveau graphics driver have a nice feature matrix on it's webpage
> and I think that BTRFS perhaps should consider doing something like tha=
t
> on it's official wiki as well
>=20
> For example something along the lines of .... (the statuses are taken
> our of thin air just for demonstration purposes)
>=20
> Kernel version 4.7
> +----------------------------+--------+-----+-------+-------+--------+-=
------+--------+
>=20
> | Feature / Redundancy level | Single | Dup | Raid0 | Raid1 | Raid10 |
> Raid5 | Raid 6 |
> +----------------------------+--------+-----+-------+-------+--------+-=
------+--------+
>=20
> | Subvolumes                 | Ok     | Ok  | Ok    | Ok    | Ok   | Ba=
d
>   | Bad    |
> +----------------------------+--------+-----+-------+-------+--------+-=
------+--------+
>=20
> | Snapshots                  | Ok     | Ok  | Ok    | Ok    | Ok     |
> Bad   | Bad    |
> +----------------------------+--------+-----+-------+-------+--------+-=
------+--------+
>=20
> | LZO Compression            | Bad(1) | Bad | Bad   | Bad(2)| Bad    |
> Bad   | Bad    |
> +----------------------------+--------+-----+-------+-------+--------+-=
------+--------+
>=20
> | ZLIB Compression           | Ok     | Ok  | Ok    | Ok    | Ok     |
> Bad   | Bad    |
> +----------------------------+--------+-----+-------+-------+--------+-=
------+--------+
>=20
> | Autodefrag                 | Ok     | Bad | Bad(3)| Ok    | Ok     |
> Bad   | Bad    |
> +----------------------------+--------+-----+-------+-------+--------+-=
------+--------+
>=20
>=20
> (1) Some explanation here...
> (2) Some explanation there....
> (3) And some explanation elsewhere...
>=20
> ...etc...etc...
>=20
> I therefore would like to propose that some sort of feature / stability=

> matrix for the latest kernel is added to the wiki preferably somewhere
> where it is easy to find. It would be nice to archive old matrix'es as
> well in case someone runs on a bit older kernel (we who use Debian tend=

> to like older kernels). In my opinion it would make things bit easier
> and perhaps a bit less scary too. Remember if you get bitten badly once=

> you tend to stay away from from it all just in case, if you on the othe=
r
> hand know what bites you can safely pet the fluffy end instead :)


--=20
Steven Haigh

Email: netwiz@crc.id.au
Web: https://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897


--cgR0Rw4h0glQscUsXqCrb0vHLGE31MwP1--

--tK6GBOCCKr5rG6pFhVVtmshlIgxUETe3j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJX1SpoAAoJEEGvNdV6fTHcqEMP/12/NHsOYrCCiotF38vEZHCm
/JdvFpGsDiZ0sGvLMWKKBM3Aza7gKlZRyVjrUGImluCo5MB1Ws3OIh2+uhJUQk7r
C2qSddqxxRXz8UC/9ycCL6HL+2xI4FrOJL4XCyG0Bs/DiiGc1CWBB64A+V73SmxM
Og7N34i/aRS62sJMKPBlTBUAJoP/GprjUP5Yn5xq0lTE1hOnCVMGVHNOn1K3SGxw
bfMyoLIGgC9Koywd3OEe8M9p5xYQONn/bMl0NOxh7j1nuPLAWgdVJEpSqxaa7E25
MwBrB55vzP9vSDe2oV9c8Cd07Xv/qWltJ6LgK4qFw7kR/6f3ygV84GXGhbSSrJUX
cQBL/7ZreUML4spP//z06cNwpJ+Q+L1e5/PPN+FPHX2CODS2heEvm5dkzCTckqye
AjmAlOt8uRuiP8OBZWrnTsyj6Odv0Hmqwq3xDBJJO/2h5mbe/8/YGFvgMOgj1Z0W
PhUvHAISLt96rOEMGowtC6kuTMIC4EEDI5cfjE3u/a14694I3W3WQcZy6TVNb5N7
ZLNq2r2zwYA/Shge91nvrDotnVX1VcL/wvIFM3FxbiS5NHQMsOV66rixVuyt3uur
WjmweUMVPNP2iDi3tEKx+KrZBasnI0wIGE7p3NF2bU0jQVdrBovun5r86PJk3vkJ
h+Gu3QCXf+//aKAK1eim
=IIws
-----END PGP SIGNATURE-----

--tK6GBOCCKr5rG6pFhVVtmshlIgxUETe3j--
