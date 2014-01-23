Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1207.opentransfer.com ([98.130.1.227]:47902 "EHLO
	mail1207.opentransfer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbaAWJ3e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jan 2014 04:29:34 -0500
Message-ID: <52E0DF6B.2080200@friendlyvirus.org>
Date: Thu, 23 Jan 2014 09:22:51 +0000
From: =?ISO-8859-1?Q?Miguel_Negr=E3o?=
	<miguel.negrao-lists@friendlyvirus.org>
MIME-Version: 1.0
To: "list, btrfs" <linux-btrfs@vger.kernel.org>
Subject: btrfs send 3.11 vs 3.12
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="WdWdWheopU5W5m2uw3QQTR2MmH5sipSTu"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WdWdWheopU5W5m2uw3QQTR2MmH5sipSTu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi

Sending snapshots incrementally started to fail on the 3.11 kernel on my
system after I once booted with 3.12 and did the incremental send of a
snapshot. After when I booted back to 3.11 I can no longer send the
snapshots incrementally based on the last one sent (I could still send
based on the last one sent from 3.11), although booting again to 3.12 I
can send me fine again.

It this intenteded ?

best,
--=20
Miguel Negr=E3o
http://www.friendlyvirus.org/miguelnegrao


--WdWdWheopU5W5m2uw3QQTR2MmH5sipSTu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJS4N9rAAoJEPo6SjfPe12D1UEIAIKs/8X4EHRRvCYPmD68FxoX
DpC9qIfP0hqoqSPzbwjK4eXpuCLOljs+3rBqMj+NkTS3qrUkYLuprvwvd9sxhWOr
+Ju8U+mhGrdDL+X+TxhHBSvGxm3jceZx7apRt+UHLOZKSs8ocqlG4N2IDVsGa30K
AXh/YsyOnQ1jlQU88tf+HKSnrulUwxjBS/pS8TzYCcYhJ1FDvLnj7GZW4/zlF4pc
GZVT0BMdHu5or1XYLm6bAw2lnc2dCAxG3a3Q5PRkVFXdfsqHaW1jwDCeQ3cAemNg
8JnIbvr8rVqN46K0CDQp5TO9uvZWiN2h8LmQJ+YG7u4+SacsrtkC2d+88X4D2Zs=
=OXHV
-----END PGP SIGNATURE-----

--WdWdWheopU5W5m2uw3QQTR2MmH5sipSTu--
