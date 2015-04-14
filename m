Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moh3-ve2.go2.pl ([193.17.41.86]:35286 "EHLO moh3-ve1.go2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753376AbbDNMWL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Apr 2015 08:22:11 -0400
Received: from moh3-ve1.go2.pl (unknown [10.0.0.157])
	by moh3-ve1.go2.pl (Postfix) with ESMTP id 23AF1AF697A
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Apr 2015 14:22:01 +0200 (CEST)
Received: from unknown (unknown [10.0.0.108])
	by moh3-ve1.go2.pl (Postfix) with SMTP
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Apr 2015 14:22:00 +0200 (CEST)
Date: Tue, 14 Apr 2015 14:21:49 +0200
From: Piotr Szymaniak <szarpaj@grubelek.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs balance {,meta}data to raid5 not working?
Message-ID: <20150414122149.GA2056@wloczykij>
References: <20150410221049.GE9470@wloczykij>
 <pan$577b$aa7780a2$54c1424a$5329065c@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
In-Reply-To: <pan$577b$aa7780a2$54c1424a$5329065c@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 11, 2015 at 02:14:44AM +0000, Duncan wrote:
> But you could try the latest 4.0-rc7+ kernel and see if it works with=20
> that, yet.

Will try that.


> 2b) If instead your intention was to convert it to raid5 before upgrading=
=20
> it to three devices, just add the third device first, then do the balance-
> conversion.  It'll save quite some time over effectively doing the=20
> balance-conversion twice.

I want to grow it later to 3 or 4 devices. Now it is still a test setup
and I want to try convert to raid5 and also check +- time it takes (and
if it will end OK).


Piotr Szymaniak.
--=20
 - Zam=C3=B3wi=C5=82e=C5=9B baby-sitterk=C4=99? - chcia=C5=82a wiedzie=C4=
=87 Maggie.
  -- Graham Masterton, "Zakl=C4=99ci" (prze=C5=82o=C5=BCy=C5=82 Juliusz Gar=
ztecki)

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJVLQZdAAoJEEMpAov1cw9lBB8P/R/lbfl5YXGXgRhKzx2T1uRM
KcrYWCm7waOINpEiSzecD/D9JvNZxWaWuCqZW/sYP4XKaSSiYTZtXEl5MyCHiBXO
cIwTc2cei8ieyA+Zo8SpZ8zU9sz3BzkBTtblUePxmlCPJVzLRYyuvSGSqPN+PS5U
Fcj2wGzzzvf5tsVjD2J4v1IF1ZVmME7DkPJmANPSwDiesbSYfnT12bV4IAlZi8pL
wtht2QvBBStu9Tx5zlxKr5SHdoFiO4GAwAXpIjuP0QBUaaERqzjYNJBBUHeifWaZ
+Op9vEpTCrKwj9NgqZUubMRB2vk+QeGKs+4tzR4H+pUAadXebB5v+J45cs78kLpY
7ldEFMXc2mHRcUTZzJb+RzFYvlArKL5ySekcJhkalgO1Y1WWbi823zi6SfRVMF1v
8R+zatB1A6hj9sbP0rXWVks9t8Vh4MgeJRXZjx7vZqAEYfIpEpLKI2jKIJYM+5Ya
RIXxYsVAQ9iZDGCw2/SoPSzW0sQZtg1OSfjo9fg2kvcuRPQQQbv54W/U6KGry2AI
Dxm1BPe1wDDzZEOMsuyKrqQGLdNwmN6QEQIWjK04s6sabwWx4r6yLj6A2TggK7vg
oV01Q0VtqtPgKsRzokWDRsxaLnrZWAH3SqCbBcu34fixDJyzIcIb3bBj/FNokmTe
I4ue2zN6b+VSfc6qUzcW
=cIEg
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
