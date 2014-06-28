Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:41413 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754536AbaF1AWU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jun 2014 20:22:20 -0400
Received: from localhost (localhost [127.0.0.1])
	by csamuel.org (Postfix) with ESMTP id 23CF641156
	for <linux-btrfs@vger.kernel.org>; Sat, 28 Jun 2014 10:22:20 +1000 (EST)
Received: from csamuel.org ([127.0.0.1])
 by localhost (csamuel.org [127.0.0.1]) (amavisd-maia, port 10024) with LMTP
 id 01750-09 for <linux-btrfs@vger.kernel.org>;
 Sat, 28 Jun 2014 10:22:20 +1000 (EST)
Received: from quad.localnet (2001-44b8-41dd-d500-edd5-ffd2-59eb-abca.static.ipv6.internode.on.net [IPv6:2001:44b8:41dd:d500:edd5:ffd2:59eb:abca])
	by csamuel.org (Postfix) with ESMTPSA id A4CAA41154
	for <linux-btrfs@vger.kernel.org>; Sat, 28 Jun 2014 10:22:19 +1000 (EST)
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: Blocked tasks on 3.15.1
Date: Sat, 28 Jun 2014 10:22:13 +1000
Message-ID: <3081460.dX0cLeJPhK@quad>
In-Reply-To: <pan$26aa0$13a0ca68$c41d00a9$e8c14640@cox.net>
References: <52e3cfababa49919100759860b59aa7c@admin.virtall.com> <4623589E-3298-4980-A257-665CFA9FB61B@colorremedies.com> <pan$26aa0$13a0ca68$c41d00a9$e8c14640@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart19521640.DhgU4RgbTj"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart19521640.DhgU4RgbTj
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

On Fri, 27 Jun 2014 05:20:41 PM Duncan wrote:

> If I'm not mistaken the fix for the 3.16 series bug was:
>=20
> ea4ebde02e08558b020c4b61bb9a4c0fcf63028e
>=20
> Btrfs: fix deadlocks with trylock on tree nodes.

That patch applies cleanly to 3.15.2 so if it is indeed the fix it shou=
ld=20
probably go to -stable for the next 3.15 release..

Unfortunately my test system died a while ago (hardware problem) and I'=
ve not=20
been able to resurrect it yet.

cheers,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC


--nextPart19521640.DhgU4RgbTj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEVAwUAU64KuI1yjaOTJg85AQIAjgf+Kmd3tqLdKUR7LkOEMZ1YRtc4/vg1htdJ
d93iblICrybq63q2H1aAkS09XxNMspjBmfmGLhRtH6xM4nLkr93TdcvEr8YhA77P
kKyBFzq7Z6R93gu3aR/5eV+aBUYydBzw3rwxcTJS4yjzCWIYf9/POYa68sXe/svK
N6DZQBIH5ixzZYj5Lae6fk6NXoVWgnHJccixQ2Dqsbr5hdz0KRn7UFXpr5wD0yiZ
KU1Xcd331XzbVmaJSJ3AJ1iv99x4XuAbHB4nifRlBHKaTCYSwWnowCaKttbuVZbk
zkpX4QkVWHeEW3GOdGjRKNXb1zsrsBfz6Yj5NYQbMjrQbRoqInZ5+Q==
=jpGM
-----END PGP SIGNATURE-----

--nextPart19521640.DhgU4RgbTj--

