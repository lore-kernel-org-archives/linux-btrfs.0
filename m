Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:34776 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbaADLU1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 4 Jan 2014 06:20:27 -0500
Received: from localhost (localhost [127.0.0.1])
	by csamuel.org (Postfix) with ESMTP id 37A11CC310
	for <linux-btrfs@vger.kernel.org>; Sat,  4 Jan 2014 22:20:27 +1100 (EST)
Received: from csamuel.org ([127.0.0.1])
 by localhost (csamuel.org [127.0.0.1]) (amavisd-maia, port 10024) with LMTP
 id 02298-09 for <linux-btrfs@vger.kernel.org>;
 Sat,  4 Jan 2014 22:20:27 +1100 (EST)
Received: from quad.localnet (ppp59-167-127-196.static.internode.on.net [59.167.127.196])
	by csamuel.org (Postfix) with ESMTPSA id CE4E6CC300
	for <linux-btrfs@vger.kernel.org>; Sat,  4 Jan 2014 22:20:26 +1100 (EST)
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs raid1 and btrfs raid10 arrays NOT REDUNDANT
Date: Sat, 04 Jan 2014 22:20:20 +1100
Message-ID: <1511915.CullaLvumH@quad>
In-Reply-To: <pan$4ef1f$8e2a9876$c1faa462$63914453@cox.net>
References: <52C73987.7000106@jrs-s.net> <7B4E55D1-BA9B-4560-8442-429EDD01C92A@colorremedies.com> <pan$4ef1f$8e2a9876$c1faa462$63914453@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart6069692.kE93b8KCSR"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart6069692.kE93b8KCSR
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

On Sat, 4 Jan 2014 06:10:14 AM Duncan wrote:

> Btrfs remains under development and there are clear warnings
> about using it without  backups one hasn't tested recovery from
> or are not otherwise prepared to  actually use.  It's stated in
> multiple locations on the wiki; it's stated on the kernel btrfs
> config option, and it's stated in mkfs.btrfs output when you
> create the filesystem.

Actually the scary warnings are gone from the Kconfig file for what wil=
l be the=20
3.13 kernel.  Removed by this commit:

commit 4204617d142c0887e45fda2562cb5c58097b918e
Author: David Sterba <dsterba@suse.cz>
Date:   Wed Nov 20 14:32:34 2013 +0100

    btrfs: update kconfig help text
   =20
    Reflect the current status. Portions of the text taken from the
    wiki pages.
   =20
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Chris Mason <chris.mason@fusionio.com>


=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
For more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart6069692.kE93b8KCSR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQEVAwUAUsfudI1yjaOTJg85AQLjFwf7BVEnADws6pkb7PJGV+bb505Yaw4QnuFT
mDT9c+/Bl4t/hRj0RhK/4rL5BoQkVWREye0zCu7RoCQ7VaKlCKMqcCckBaWvuzz5
WSTPFDvj9AhJ/QFTve6qNzjQ3QS/47gtX70nTDF9bflYsUOAsT+fFz9jT6BhHO8j
kcQuLgsyfrgMis4MM20/yJL2hBVwcRfpA6txAORhmMXhjl3yAI33GYvlnqaHqOaR
wHX2BkCwJ7lbn4OgWNSO2Dl05WscFF4ERUEwpkRTQPKiWfXLJpZ7hIa1yAqejG39
+I+kMkf4gejEWqDG/Xqt+sjlNN9KEEipcYqbcSZ+eb/0gpVa8nGgvw==
=NtpX
-----END PGP SIGNATURE-----

--nextPart6069692.kE93b8KCSR--

