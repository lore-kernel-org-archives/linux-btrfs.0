Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:52540 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755186AbaDKOPk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Apr 2014 10:15:40 -0400
Received: from localhost (localhost [127.0.0.1])
	by csamuel.org (Postfix) with ESMTP id 440F941861
	for <linux-btrfs@vger.kernel.org>; Sat, 12 Apr 2014 00:15:40 +1000 (EST)
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: How to debug very very slow file delete? (btrfs on md-raid5)
Date: Sat, 12 Apr 2014 00:15:14 +1000
Message-ID: <2708828.vpfalmJ0Wi@quad>
In-Reply-To: <20140325164142.GN12833@merlins.org>
References: <20140325164142.GN12833@merlins.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1560463.GMdcPnJuaE"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart1560463.GMdcPnJuaE
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

On Tue, 25 Mar 2014 09:41:42 AM Marc MERLIN wrote:

> 4 hours to stat 700K files. That's bad...
> Even 11mn to restat them just to count them looks bad too.

One way to get an idea of where that's happening is to run the command =
with=20
"strace -c" to build up a table of times spent in each system call, use=
cs per=20
call (average) and number of calls.

Best of luck!
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC


--nextPart1560463.GMdcPnJuaE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQEVAwUAU0f48o1yjaOTJg85AQIlJAgAoPn2xgnagAKpIlDiY8NyUobFiG7YpAzh
YNMu6nstWAq11TXtnbG6PYLEh3PV6PjTRnBxDivI8NQH4pY72wFGeG/U6ytislRH
eNrZUXJMVc+Rsgzyxj3A6XRFnuGhoflfPBDFiMjwbdEIjCDYBTPNvc4soqrK3rU+
LS14Oj1yJdkRCeHDNoMnIgfktmfzJNrfV36CQNLjOr2omPQE0GjNpRSDrrMLTY6t
zxydH8bWryk+YOkkSzptRxv1vF+ZiPS3E6Rp897oJiIbGGKTul6A1Z9acXTsSAgl
I8BSNPjZVdkauY3J/qUjdrzrOcLyHPtZncYNqjgELULBRoAU3hE05Q==
=xxbr
-----END PGP SIGNATURE-----

--nextPart1560463.GMdcPnJuaE--

