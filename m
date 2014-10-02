Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from efeu.mur.at ([89.106.208.66]:49003 "EHLO efeu.mur.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942AbaJBIvM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Oct 2014 04:51:12 -0400
Received: from localhost (localhost [127.0.0.1])
	by efeu.mur.at (Postfix) with ESMTP id 3CD0F222FD
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Oct 2014 10:42:56 +0200 (CEST)
Received: from efeu.mur.at ([127.0.0.1])
	by localhost (efeu.mur.at [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id axuz58ej5hps for <linux-btrfs@vger.kernel.org>;
	Thu,  2 Oct 2014 10:42:56 +0200 (CEST)
Received: from [IPv6:2a02:3e0:1:0:6a68:68ff:fe00:79be] (unknown [IPv6:2a02:3e0:1:0:6a68:68ff:fe00:79be])
	by efeu.mur.at (Postfix) with ESMTPSA
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Oct 2014 10:42:55 +0200 (CEST)
Message-ID: <542D100F.9050502@mur.at>
Date: Thu, 02 Oct 2014 10:42:55 +0200
From: =?UTF-8?B?Sm9naSBIb2Ztw7xsbGVy?= <jogi@mur.at>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: btrfs 3.16.2 does not recognize subvolumes correctly
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6mKpTBKkKiPUwHU9cWq4foHPHtOKNcFxp"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6mKpTBKkKiPUwHU9cWq4foHPHtOKNcFxp
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi all,

I just noticed that when doing a 'btrfs subvolume show /' I get the
error 'ERROR: / doesn't belong to btrfs mount point', which is not quite
true.  I get the same error for all the other subvolumes as well.  It
worked fine until 3.14.1.

Regards,
--=20
J.Hofm=C3=BCller

ich zitiere wie Espenlaub.

https://twitter.com/TheGurkenkaiser/status/463444397678690304


--6mKpTBKkKiPUwHU9cWq4foHPHtOKNcFxp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlQtEA8ACgkQkaXhaapqItnKTAD7BUF885OtHjNom39zPkcFqMjd
uI/PnP92OhP+5pEFGhgA/jL/XlKVwINmniyV6d4d8O5rT1TsHjkTMGS30+up6jlr
=65h3
-----END PGP SIGNATURE-----

--6mKpTBKkKiPUwHU9cWq4foHPHtOKNcFxp--
