Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1207.opentransfer.com ([98.130.1.227]:59569 "EHLO
	mail1207.opentransfer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab3HTRQ3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Aug 2013 13:16:29 -0400
Message-ID: <5213A46C.20701@friendlyvirus.org>
Date: Tue, 20 Aug 2013 18:16:28 +0100
From: =?ISO-8859-1?Q?Miguel_Negr=E3o?=
	<miguel.negrao-lists@friendlyvirus.org>
MIME-Version: 1.0
To: "list, btrfs" <linux-btrfs@vger.kernel.org>
Subject: btrfs check : extent-tree.c:283: find_search_start: Assertion `!(1)'
 failed
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="3Tg44NxeIarXel1rgMk6fgehqJtCqCEXs"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3Tg44NxeIarXel1rgMk6fgehqJtCqCEXs
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

I have a btrfs partition on a usb external hard drive which doesn't
mount anymore. I tried doing a btrfs check on it, but it fails with the
error on the subject. The btrfs progs were compiled from git today. I
have a backup of this partition elsewhere, so I can restore from there
if all else fails.

The output of

sudo btrfs check --repair /dev/sdc1 > ~/log/btfs-repair-1.log 2>&1

was

parent transid verify failed on 7624175616 wanted 1431 found 1428
parent transid verify failed on 7624175616 wanted 1431 found 1428
Ignoring transid failure
leaf parent key incorrect 7624175616
checking extents
parent transid verify failed on 7624175616 wanted 1431 found 1428
Ignoring transid failure

=2E..


leaf parent key incorrect 7717249024
Unable to find block group for 0
btrfs: extent-tree.c:283: find_search_start: Assertion `!(1)' failed.
enabling repair mode
Checking filesystem on /dev/sdc1
UUID: 42688de3-f4ed-4592-bb34-02c9d5014e51



best,
--=20
Miguel Negr=E3o
http://www.friendlyvirus.org/miguelnegrao



--3Tg44NxeIarXel1rgMk6fgehqJtCqCEXs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSE6RsAAoJEPo6SjfPe12D044IAJxp4b03PdoYRezLORytPhCH
CQR67csiU/8r+iKAgoxNXmCg86zPdwUwTNr7++qb+02hOS41ahRr1+c0SBATkjrV
E4eSvqD194q8tJTSY/MJkQjmkbThJ0p1Kuy+B/eaeTNVZrc7b61ltkB3KBLC0To0
poV4Gk8asmnpyfJxjE2pWtTA69UwQh9NYiggveFOu4Ngk1KjnWu+ZG7LcD31qe9o
em7kVMFXfrBkj1eg/8OH/AZyiczqwogP2tEe9lT397d2YgWCmw/uwFydC3guBIBG
m2CH3r6jBiILDT5q5t3kR1/CwjhzGmadMCSozLBktF5Rsml5XsMa9kSVFNA1alI=
=3EOm
-----END PGP SIGNATURE-----

--3Tg44NxeIarXel1rgMk6fgehqJtCqCEXs--
