Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:48187 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235Ab2FJIqp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Jun 2012 04:46:45 -0400
Received: from localhost (localhost [127.0.0.1])
	by csamuel.org (Postfix) with ESMTP id EE73840857
	for <linux-btrfs@vger.kernel.org>; Sun, 10 Jun 2012 18:46:44 +1000 (EST)
Received: from csamuel.org ([127.0.0.1])
 by localhost (csamuel.org [127.0.0.1]) (amavisd-maia, port 10024) with LMTP
 id 29381-01 for <linux-btrfs@vger.kernel.org>;
 Sun, 10 Jun 2012 18:46:44 +1000 (EST)
Received: from quad.localnet (ppp59-167-127-196.static.internode.on.net [59.167.127.196])
	by csamuel.org (Postfix) with ESMTPS id 8A52340856
	for <linux-btrfs@vger.kernel.org>; Sun, 10 Jun 2012 18:46:44 +1000 (EST)
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Removing btrfsctl, btrfs-vol, btrfs-show
Date: Sun, 10 Jun 2012 18:46:38 +1000
References: <1339223060-6256-1-git-send-email-kreijack@inwind.it> <1339223060-6256-2-git-send-email-kreijack@inwind.it>
In-Reply-To: <1339223060-6256-2-git-send-email-kreijack@inwind.it>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1413009.Om2tHbuGP9";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <201206101846.41496.chris@csamuel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1413009.Om2tHbuGP9
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Saturday 09 June 2012 16:24:19 Goffredo Baroncelli wrote:

> This commit removes all the related code.

This doesn't seem to apply cleanly with patch (though git am
seems to apply it OK) to the git repo master from:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git

=46YI patch complains thus:

patching file INSTALL
patching file Makefile
patching file btrfs-show.c
patching file btrfs-vol.c
patching file btrfsctl.c
patching file Makefile
Hunk #1 FAILED at 6.
Hunk #2 FAILED at 17.
2 out of 2 hunks FAILED -- saving rejects to file Makefile.rej
patching file btrfs-image.8.in
Hunk #1 FAILED at 31.
1 out of 1 hunk FAILED -- saving rejects to file btrfs-image.8.in.rej
The next patch would delete the file btrfs-show.8.in,
which does not exist!  Assume -R? [n]=20
Apply anyway? [n]=20
Skipping patch.
1 out of 1 hunk ignored
patching file btrfsck.8.in
Hunk #1 FAILED at 14.
1 out of 1 hunk FAILED -- saving rejects to file btrfsck.8.in.rej
The next patch would delete the file btrfsctl.8.in,
which does not exist!  Assume -R? [n]=20
Apply anyway? [n]=20
Skipping patch.
1 out of 1 hunk ignored


=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart1413009.Om2tHbuGP9
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUAT9Re741yjaOTJg85AQIp1QgAoNdeMoAfHV4e792bqbEbvNhIsHuu6aFs
zX/UKqALV+KRya28EN/rB3gpeUBzN5hVYxzeq9iXZFcN8LuUKGDpJHqNzFPyQWD8
+h8aB16UuV1UmY3Nr2wDquJ656PIV5YhxLaNgzjikg4FyUAnKtUJHr2DwTFUa2Tq
uEdW22MQ75PCpPdn52LnVNe92jXZYLcjO9zeTmHUv65FhqtsWxG/CsBdOkgODX7i
PaKp4buYO1wxuHfchKN3ryYEyoP46pLAogXitCeVq5I4/P5aE3R2Hi0fYjEQDJbb
iLt0Vsifrmoe2nhd+jUYW6hbXD4za81d0HJ6/GCRbeqVblwlgqLa5g==
=qBEh
-----END PGP SIGNATURE-----

--nextPart1413009.Om2tHbuGP9--
