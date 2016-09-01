Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53534 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754052AbcIADKW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Aug 2016 23:10:22 -0400
Subject: Re:
To: Fennec Fox <fennectech@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAD1x5BA5k9MUdzT-s0kzFfb5+idoJSFaOux0xQS-jd_D0HTDWA@mail.gmail.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <57C79C15.4020508@suse.com>
Date: Wed, 31 Aug 2016 23:10:13 -0400
MIME-Version: 1.0
In-Reply-To: <CAD1x5BA5k9MUdzT-s0kzFfb5+idoJSFaOux0xQS-jd_D0HTDWA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WmeA7ohbmPnOrfke7jwni4jLxixbRHoJA"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WmeA7ohbmPnOrfke7jwni4jLxixbRHoJA
Content-Type: multipart/mixed; boundary="mfI8467PavOit59AsxnPusQccriqFSG83"
From: Jeff Mahoney <jeffm@suse.com>
To: Fennec Fox <fennectech@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <57C79C15.4020508@suse.com>
Subject: Re:
References: <CAD1x5BA5k9MUdzT-s0kzFfb5+idoJSFaOux0xQS-jd_D0HTDWA@mail.gmail.com>
In-Reply-To: <CAD1x5BA5k9MUdzT-s0kzFfb5+idoJSFaOux0xQS-jd_D0HTDWA@mail.gmail.com>

--mfI8467PavOit59AsxnPusQccriqFSG83
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 8/31/16 10:02 PM, Fennec Fox wrote:
> Linux Titanium 4.7.2-1-MANJARO #1 SMP PREEMPT Sun Aug 21 15:04:37 UTC
> 2016 x86_64 GNU/Linux
> btrfs-progs v4.7
>=20
> Data, single: total=3D30.01GiB, used=3D18.95GiB
> System, single: total=3D4.00MiB, used=3D16.00KiB
> Metadata, single: total=3D1.01GiB, used=3D422.17MiB
> GlobalReserve, single: total=3D144.00MiB, used=3D0.00B
>=20
> {02:50} Wed Aug 31
> [fennectech@Titanium ~]$  sudo fstrim -v /
> [sudo] password for fennectech:
> Sorry, try again.
> [sudo] password for fennectech:
> /: 99.8 GiB (107167244288 bytes) trimmed
>=20
> {03:08} Wed Aug 31
> [fennectech@Titanium ~]$  sudo fstrim -v /
> [sudo] password for fennectech:
> /: 99.9 GiB (107262181376 bytes) trimmed
>=20
>   I ran these commands minutes after echother ane each time it is
> trimming the entire free space
>=20
> Anyone else seen this?   the filesystem is the root FS and is compresse=
d
>=20

Yes.  It's working as intended.  We don't track what space has already
been trimmed anywhere, so it trims all unallocated space.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--mfI8467PavOit59AsxnPusQccriqFSG83--

--WmeA7ohbmPnOrfke7jwni4jLxixbRHoJA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIcBAEBCAAGBQJXx5wZAAoJEB57S2MheeWy/HIP+gPYLN3Ps+GVsfYUJjBUBR2q
hvwZuTpcdwkIBnaSDNAtYs1ZfVWeLtmM2uwv+KpDEyym30fsey3VRHecdwOmv1Bs
fTfSS9aeMFp4vCe8FHhVmPikJ6lpyk1TOszJikSmw11Bzj6DnErrwQv79gvTXq1r
+RxPlJJ1RA1n5GO1krR/oWx9xmnwMMHKYTfCN1o6piPThB8+bX0WvLgljaftaMXM
YjCMmDcOr7RSqV3zaQweSZp1WnXjKY2JAd8xnpf5x6ybZVoRTPFv9XczAMDP/PA2
NnPRSFgD46IIKRzhgKzYrRfgne7GSA/808U/iYiBbcNVJ3GMnGHL0ZDjUd2c1qvT
6MMCPfDYeGiamvNYPCwowWQJRJTs+S9mFyQIMD8614DIP8z9O1FOZRgFJdP5TrsA
dlbaURGBbwe00ihyY5nrn3FaicfYlZRIMOazz05lLFYJs9ROX4fCYDxoL0zx2Wzd
wc5r6zda50eEcKs6RIFJBe6UOBA9CAnk3eWgdZIXOewwKKaUvMFI0PR2hCnZoIGa
OsSuRnPxKDyd1KOL4shlWPzZysvtkpz+YF4FUvBZEttuNIvwyU2lT8u7zBh/A21M
6kHpJk61aCbV9N1R3hE+jIlUWkcIssjZkAWLJNjUSGQlRTU18sOzJim7Ge00tmvj
5C30ba1XYdXpqf8+2KF8
=D4Ws
-----END PGP SIGNATURE-----

--WmeA7ohbmPnOrfke7jwni4jLxixbRHoJA--
