Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:58979 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459Ab3LNHHw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Dec 2013 02:07:52 -0500
Received: from localhost (localhost [127.0.0.1])
	by csamuel.org (Postfix) with ESMTP id 1B3C9CC1B3
	for <linux-btrfs@vger.kernel.org>; Sat, 14 Dec 2013 18:07:52 +1100 (EST)
Received: from csamuel.org ([127.0.0.1])
 by localhost (csamuel.org [127.0.0.1]) (amavisd-maia, port 10024) with LMTP
 id 21831-01 for <linux-btrfs@vger.kernel.org>;
 Sat, 14 Dec 2013 18:07:51 +1100 (EST)
Received: from quad.localnet (ppp59-167-127-196.static.internode.on.net [59.167.127.196])
	by csamuel.org (Postfix) with ESMTPSA id B370DCC1A7
	for <linux-btrfs@vger.kernel.org>; Sat, 14 Dec 2013 18:07:51 +1100 (EST)
From: Chris Samuel <chris@csamuel.org>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: moving a subvol
Date: Sat, 14 Dec 2013 18:07:49 +1100
Message-ID: <1663965.RJ0nqNbRyM@quad>
In-Reply-To: <52AB5F2E.8020209@czarc.net>
References: <52AB30D4.7050408@czarc.net> <6EDC30B8-CF2C-42FA-9E30-D9F4B0804152@colorremedies.com> <52AB5F2E.8020209@czarc.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3375344.3T3Yhj6fzv"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart3375344.3T3Yhj6fzv
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

On Fri, 13 Dec 2013 02:25:34 PM Gene Czarcinski wrote:

> Next it is to delete the old BTRFS volume, use fdisk to increase the=20=

> size of the partition and then attempt to increate the size of this n=
ew=20
> volume.  I hope I don't get bit in the rear end with this.

Just make sure you have good (tested) backups..

=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
For more info see: http://en.wikipedia.org/wiki/OpenPGP
--nextPart3375344.3T3Yhj6fzv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQEVAwUAUqwDxY1yjaOTJg85AQIeQgf/UtSP/QEHH92SqrJ0uwwRig++/aHDyKcy
/pWMX3Qp7PxSvAr8iEzrSaFazEQhAaI2qiJf5i+Hn7/tHsoPgN9Y873TACLLQYiS
CtCgU3M95hILTwl7HGiJuWIVRr8AesFdRVwApK4na2vN1DLYlJhVbpUEjwEJB7/q
HG+gAE4CHvaJ4D106WFxWx10FR5odnAmLd4idKbE5+XmZ1hs2Xq6kz49lgVqHV2V
OzncikOtr/nKPGUZoPJkZ+TQaA7dNVEevkDxs7ddnztGL8EQCCnGBHc9mTid7QM5
iAu8tqY0aHoFgAudje7rYg/wo342uS0E1KJGhtMdSHgsaWzGw0MEqw==
=UNSj
-----END PGP SIGNATURE-----

--nextPart3375344.3T3Yhj6fzv--

