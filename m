Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:45488 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbaCOEGd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Mar 2014 00:06:33 -0400
Received: from localhost (localhost [127.0.0.1])
	by csamuel.org (Postfix) with ESMTP id B3CAED480A
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Mar 2014 15:06:32 +1100 (EST)
Received: from csamuel.org ([127.0.0.1])
 by localhost (csamuel.org [127.0.0.1]) (amavisd-maia, port 10024) with LMTP
 id 22358-10 for <linux-btrfs@vger.kernel.org>;
 Sat, 15 Mar 2014 15:06:32 +1100 (EST)
Received: from quad.localnet (ppp59-167-127-196.static.internode.on.net [59.167.127.196])
	by csamuel.org (Postfix) with ESMTPSA id 557BDD4806
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Mar 2014 15:06:32 +1100 (EST)
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: discard synchronous on most SSDs?
Date: Sat, 15 Mar 2014 15:06:25 +1100
Message-ID: <1908923.tvpl1fFKJ5@quad>
In-Reply-To: <5289248.oqpgSKG6td@quad>
References: <531C1CC4.701@gmail.com> <20140314051750.GY6143@merlins.org> <5289248.oqpgSKG6td@quad>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart39859021.pc7ydWa81R"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart39859021.pc7ydWa81R
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

On Fri, 14 Mar 2014 06:33:24 PM Chris Samuel wrote:

> I *think* you want smartctl -i instead, and look for the field that s=
ays=20
> something like:
>=20
> ATA Version is:   ATA8-ACS, ACS-2 T13/2015-D revision 3

Late night, cut and pasted the wrong line of output, mine says:

SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)

Of course that's what the drive is reporting it supports, I'm not sure =
whether=20
that's the result of what has been negotiated between the controller an=
d drive=20
or purely what the drive supports.

To get more information from smartctl you can use the --identify=3Dwb o=
ption=20
instead of -i and that should give you a lot more detail about what the=
n=20
drives claims to (and not to) support.   On the version in Kubuntu 13.1=
0=20
(6.1+svn3812-1) it only reports 3 things regarding TRIM for my drives.

chris@quad:/tmp$ sudo smartctl --identify=3Dwb -d sat /dev/sdb | egrep =
=2Di 'trim|
discard'
  69     14          1   Deterministic data after trim supported
  69      5          0   Trimmed LBA range(s) returning zeroed data sup=
ported
 169      0          1   Trim bit in DATA SET MANAGEMENT command suppor=
ted

I'm currently doing a git clone of their SVN repo to see if there's any=
 new=20
functionality that will gather any more information.

cheers,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC


--nextPart39859021.pc7ydWa81R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQEVAwUAUyPRwY1yjaOTJg85AQLIpQf9FX20+cqAWuhbbsI7MhL/lZJJs9//ydhO
9VGyhinsjeMFqTei4LgT9wvWFZ2rxA6VZv4LmsQ3ABkclLjk1YMHxJOjwAgtTuXv
HHLFk5I6GjNdZ94K9ybe9cOcSKuyBzoqJ4bpktUhfmzD0unNRaiM062V9/kcFBB5
SU2xHGcaLE+YGvfZN/+1ODd9JJYrcEsd2QzEdQ0hVr4nrAdA8jo0/QOJSCoHkhWj
VmrvQms/vjyLbCHm6WyNCLRG3H3uRGRja9sy9buatNNJk6reZmoSosgpslMHVFb/
8rU4KD/OGp+oPYKJlLdLvsqY55JQ9cMaJG4dW1jqweMCWswLzOzFEg==
=4F0x
-----END PGP SIGNATURE-----

--nextPart39859021.pc7ydWa81R--

