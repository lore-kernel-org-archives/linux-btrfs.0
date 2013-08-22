Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1207.opentransfer.com ([98.130.1.227]:33095 "EHLO
	mail1207.opentransfer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab3HVK27 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Aug 2013 06:28:59 -0400
Message-ID: <5215E7E8.8030208@friendlyvirus.org>
Date: Thu, 22 Aug 2013 11:28:56 +0100
From: =?ISO-8859-1?Q?Miguel_Negr=E3o?=
	<miguel.negrao-lists@friendlyvirus.org>
MIME-Version: 1.0
To: "list, btrfs" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs check : extent-tree.c:283: find_search_start: Assertion
 `!(1)' failed
References: <5213A46C.20701@friendlyvirus.org>
In-Reply-To: <5213A46C.20701@friendlyvirus.org>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="CmO0TLx4JRW9RhPQQEqxVwtIQBNvBw9sr"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CmO0TLx4JRW9RhPQQEqxVwtIQBNvBw9sr
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

Forgot to ask the important question, is it still possible to recover
this filesystem or is it doomed ?

best,
Miguel

Em 20-08-2013 18:16, Miguel Negr=E3o escreveu:
> Hi,
>=20
> I have a btrfs partition on a usb external hard drive which doesn't
> mount anymore. I tried doing a btrfs check on it, but it fails with the=

> error on the subject. The btrfs progs were compiled from git today. I
> have a backup of this partition elsewhere, so I can restore from there
> if all else fails.
>=20
> The output of
>=20
> sudo btrfs check --repair /dev/sdc1 > ~/log/btfs-repair-1.log 2>&1
>=20
> was
>=20
> parent transid verify failed on 7624175616 wanted 1431 found 1428
> parent transid verify failed on 7624175616 wanted 1431 found 1428
> Ignoring transid failure
> leaf parent key incorrect 7624175616
> checking extents
> parent transid verify failed on 7624175616 wanted 1431 found 1428
> Ignoring transid failure
>=20
> ...
>=20
>=20
> leaf parent key incorrect 7717249024
> Unable to find block group for 0
> btrfs: extent-tree.c:283: find_search_start: Assertion `!(1)' failed.
> enabling repair mode
> Checking filesystem on /dev/sdc1
> UUID: 42688de3-f4ed-4592-bb34-02c9d5014e51
>=20
>=20
>=20
> best,
>=20


--=20
Miguel Negr=E3o
http://www.friendlyvirus.org/miguelnegrao


--CmO0TLx4JRW9RhPQQEqxVwtIQBNvBw9sr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSFefpAAoJEPo6SjfPe12DEo4H/0rKf39WbBsVlJsQ+B9i6Xws
JDkDXyIAttb33ZV1+cZ98JRsPkCZOWe283ndoXwvjfvwF9/gwdXOt3YoHNZunDWl
r+OQqDOo61axCciX5i+EhV0njL9nmykKfuuj46fZcFNyAe2e49u6V2gH9ww0ATaC
1oCD2tbv5iHo9vStrNrtqdKyggdSTeKN4c3BURyc2drOSWD6hwCJBfmf3LkLlb+R
dpBgnILziaUmo5jETbabpww7VJTSHPyi3Snw+ddzXAncyRK4Z6DkE+RD3rbhq2EF
F47bHPy4RowEpl0tfSl35fNuBE8JhSI/JkG3R28UZHQECLcTUR91s8JuP/UmYh8=
=veAa
-----END PGP SIGNATURE-----

--CmO0TLx4JRW9RhPQQEqxVwtIQBNvBw9sr--
