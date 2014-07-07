Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:47086 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220AbaGGIaF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Jul 2014 04:30:05 -0400
Received: from localhost (localhost [127.0.0.1])
	by csamuel.org (Postfix) with ESMTP id C4DA8CC042
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Jul 2014 18:30:03 +1000 (EST)
Received: from csamuel.org ([127.0.0.1])
 by localhost (csamuel.org [127.0.0.1]) (amavisd-maia, port 10024) with LMTP
 id 18788-03 for <linux-btrfs@vger.kernel.org>;
 Mon,  7 Jul 2014 18:30:03 +1000 (EST)
Received: from quad.localnet (2001-44b8-41dd-d500-f8a2-d7b7-ccc6-8642.static.ipv6.internode.on.net [IPv6:2001:44b8:41dd:d500:f8a2:d7b7:ccc6:8642])
	by csamuel.org (Postfix) with ESMTPSA id 45E1DCC03B
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Jul 2014 18:30:03 +1000 (EST)
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs loopback problems
Date: Mon, 07 Jul 2014 18:29:36 +1000
Message-ID: <1493301.7J9ZoDEm6J@quad>
In-Reply-To: <53BA11FE.9080101@cn.fujitsu.com>
References: <11089039.dk0RppNMoi@xev> <53BA11FE.9080101@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart22665198.yBkd4SUMkV"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart22665198.yBkd4SUMkV
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

On Mon, 7 Jul 2014 11:20:30 AM Qu Wenruo wrote:

> As Chris Mason mentioned, fixed in the following patch:
> https://patchwork.kernel.org/patch/4143821/

That should probably go to -stable (if it hasn't already), especially a=
s 3.14=20
is a new LTS kernel.

cheers,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC


--nextPart22665198.yBkd4SUMkV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEVAwUAU7paiI1yjaOTJg85AQK3owgApU2BS891ziVDKef4aX9I9MfoyQCwFrZi
TTGxlahsaYNWYOMmuP5TJFI+aRSyM17ufd8sVbQwS+vjfFBTJ1A59XMrzbRwNC/m
i65k1e31tQqoJ+1H0kg0pay3MRrBZLaINn3OvhodQPVUhA2719yBvbrMti5pHBJS
1p/iI3Uc5NaxU4yZqWcZ4FRwtEIxCVog3aIMSqDB6G7i5TDdZle3tScyksWlMbCR
KtOIil4b7dKre/kIRCDf1/0xNr0JCuNlCn+64yR5SQ4Jg6pzshSSQSwnzr/u7zFQ
N94iD9Efd5mJsgHv9WNcpeeiWmTQ7ZRm4kX+fvv95/6IB5kC4+UKig==
=LLHW
-----END PGP SIGNATURE-----

--nextPart22665198.yBkd4SUMkV--

