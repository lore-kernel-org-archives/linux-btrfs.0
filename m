Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:49196 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119AbaARHUh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 18 Jan 2014 02:20:37 -0500
Received: from localhost (localhost [127.0.0.1])
	by csamuel.org (Postfix) with ESMTP id 067E6409D2
	for <linux-btrfs@vger.kernel.org>; Sat, 18 Jan 2014 18:20:37 +1100 (EST)
Received: from csamuel.org ([127.0.0.1])
 by localhost (csamuel.org [127.0.0.1]) (amavisd-maia, port 10024) with LMTP
 id 06697-07 for <linux-btrfs@vger.kernel.org>;
 Sat, 18 Jan 2014 18:20:36 +1100 (EST)
Received: from quad.localnet (ppp59-167-127-196.static.internode.on.net [59.167.127.196])
	by csamuel.org (Postfix) with ESMTPSA id 9BFA6409C9
	for <linux-btrfs@vger.kernel.org>; Sat, 18 Jan 2014 18:20:36 +1100 (EST)
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfsck does not fix
Date: Sat, 18 Jan 2014 18:20:30 +1100
Message-ID: <1992297.bYFikluJQe@quad>
In-Reply-To: <C8D65D2E-6D7D-4E4A-A649-F092A624943D@colorremedies.com>
References: <52C7127F.3060902@friedels.name> <pan$8a0dd$9f46c908$89053e7c$efd0a239@cox.net> <C8D65D2E-6D7D-4E4A-A649-F092A624943D@colorremedies.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2564575.MOUyfPdcOr"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart2564575.MOUyfPdcOr
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

On Tue, 14 Jan 2014 10:17:19 AM Chris Murphy wrote:

> -c 9 is max compression although I don't know what algorithm btrfs-im=
age
> uses off hand. If I use xz on it, 193MB becomes 192MB.

Be interesting to generate the same image without compression in btrfs-=
image=20
and then xz it, in case it can do better with the raw data.

cheers!
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
For more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart2564575.MOUyfPdcOr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQEVAwUAUtorPo1yjaOTJg85AQKNZggAi1d+cETQ5l7CrQpXeH/ojykhfC3GexnB
B5csnwwFynsENrBt1wdri07YUjEc0u8OPsXCVR9tia1nCwI9o5NJ8xPN5HM6G2mE
29A1uVOtdu2RBwPAurjdviZnqVF0yvb3HHGIk4Hx7RbO4MvSePD3xwdOmMwEs07C
OZTc/PXIo7q6H7hlkK/5E5aOy8a4vNW9zVV1ysBGO1A9GJ8H5F95VBxywbAE0a0U
pF68nlWVC7H9a5lgnT45xIA4ZfIBzADyG3NisJR4ye4lid7qt04PF6qR51Pjw3I+
8kaTLBsDsOXLtOQZoZwG8v1KGWVhAvOVq66UeZxY2pDNVB9ea+stWw==
=VpdZ
-----END PGP SIGNATURE-----

--nextPart2564575.MOUyfPdcOr--

