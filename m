Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cahost.average.org ([72.55.133.117]:35339 "EHLO
	cahost.average.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906Ab2LROZS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Dec 2012 09:25:18 -0500
Received: from [IPv6:2001:470:1f09:520:28c6:f500:82a3:b8b5] ([IPv6:2001:470:1f09:520:28c6:f500:82a3:b8b5])
	(authenticated bits=0)
	by cahost.average.org (8.14.3/8.14.3/Debian-9.4) with ESMTP id qBIEC7ge024988
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Dec 2012 18:12:10 +0400
Message-ID: <50D079AB.2030805@average.org>
Date: Tue, 18 Dec 2012 18:11:55 +0400
From: Eugene Crosser <crosser@average.org>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: btrfs in the kernel 2.6.31
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBE02E677CF288E17BBE95A78"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBE02E677CF288E17BBE95A78
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: quoted-printable

Hello all,

sorry for a user-level question,

I have a board based on PLX7821 aka OX820 ARM SoC. It is not supported in=
 the
mainline kernel; the vendor supplied the source of the kernel 2.6.31 with=

necessary updates for this platform, and it works. I understand that ther=
e have
been no successful attempts to bring support of this platform to newer ke=
rnels.

I would like to use btrfs on this system, but it is labelled "experimenta=
l" in
the kernel. My question is: is it "safe" to use btrfs as it is in 2.6.31?=
 In
other words, where there "data destroying" bugs found and fixed since the=
n? If
the answer is yes, then is it possible (and how difficult) to compile new=
er
btrfs code against this kernel, or backport the fixes?

Thanks,

Eugene


--------------enigBE02E677CF288E17BBE95A78
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iD8DBQFQ0Hmyfrw/cIw6UWkRAsAIAKCw7B6SMQqV962sW6dxfPOOXMlR4gCfazvl
wD5tOe+kqhfrcaYReXKJyOQ=
=5bws
-----END PGP SIGNATURE-----

--------------enigBE02E677CF288E17BBE95A78--
