Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:42829 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519Ab3LZXSp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Dec 2013 18:18:45 -0500
Received: from localhost (localhost [127.0.0.1])
	by csamuel.org (Postfix) with ESMTP id E3685CC19B
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Dec 2013 10:18:44 +1100 (EST)
Received: from csamuel.org ([127.0.0.1])
 by localhost (csamuel.org [127.0.0.1]) (amavisd-maia, port 10024) with LMTP
 id 18605-01 for <linux-btrfs@vger.kernel.org>;
 Fri, 27 Dec 2013 10:18:44 +1100 (EST)
Received: from quad.localnet (ppp59-167-127-196.static.internode.on.net [59.167.127.196])
	by csamuel.org (Postfix) with ESMTPSA id 86DE7CC199
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Dec 2013 10:18:44 +1100 (EST)
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: Unmountable Array After Drive Failure During Device Deletion
Date: Fri, 27 Dec 2013 10:18:38 +1100
Message-ID: <7762191.E7zsbxQLzq@quad>
In-Reply-To: <pan$ba575$c4e4093$f5b3203$522a159c@cox.net>
References: <52B2BBE1.8090306@gmail.com> <CAN05THTwCnmMGh=A0zpgEHqDvoKmokNStfN6wyfVNaFoLxNxBQ@mail.gmail.com> <pan$ba575$c4e4093$f5b3203$522a159c@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2573246.ETHZEXBKxI"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart2573246.ETHZEXBKxI
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

On Sun, 22 Dec 2013 11:35:53 AM Duncan wrote:

> While the btrfs kernel config option no longer (as of 3.12 IIRC) dire=
ctly=20
> calls the filesystem unstable

It'll be in 3.13, the commit was:

$ git describe 4204617d142c0887e45fda2562cb5c58097b918e
v3.12-116-g4204617

The help text for btrfs now says:

          Btrfs is a general purpose copy-on-write filesystem with exte=
nts,
          writable snapshotting, support for multiple devices and many =
more
          features focused on fault tolerance, repair and easy administ=
ration.

          The filesystem disk format is no longer unstable, and it's no=
t
          expected to change unless there are strong reasons to do so. =
If there
          is a format change, file systems with a unchanged format will=

          continue to be mountable and usable by newer kernels.

          For more information, please see the web pages at
          http://btrfs.wiki.kernel.org.

cheers,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
For more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart2573246.ETHZEXBKxI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQEVAwUAUry5To1yjaOTJg85AQLeOggAvbw0OdKyqrPKBAfpLUOGoW8hfbneFbuV
7BpXGaZytHIAIdyuHO9SQoII50BHcBAERSjcEbk69ci6GTskxOBo00uhWgwcP1yC
bJP1H8ubpQb4y59EE7IOkOd/1Zr4PV4FFWdM+ycaHcgXHwIrS6wbyN6WLEUQaIge
GYCd4JZqZke8Xinit3EFY4Fz8JPohUXRyocjdvs9WZ+55qPS0EJnfb02WVER57a6
mjCmMIbZJDQAd8vbFm0VMgIB8Zt8q36BktenEiJ4mBuTxW5LTcU5TyQz9LhlrN3K
rZoXYPXtganbBf03xmD6jQ1Fut0pE/2FzSGgCgHdSTPSEMntrHPwmA==
=ZahA
-----END PGP SIGNATURE-----

--nextPart2573246.ETHZEXBKxI--

