Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from efeu.mur.at ([89.106.208.66]:48112 "EHLO efeu.mur.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbaJCKkl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Oct 2014 06:40:41 -0400
Received: from localhost (localhost [127.0.0.1])
	by efeu.mur.at (Postfix) with ESMTP id 4BFB422387
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Oct 2014 12:40:34 +0200 (CEST)
Received: from efeu.mur.at ([127.0.0.1])
	by localhost (efeu.mur.at [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id cRu3SZebcrvB for <linux-btrfs@vger.kernel.org>;
	Fri,  3 Oct 2014 12:40:34 +0200 (CEST)
Received: from [IPv6:2a02:3e0:1:0:6a68:68ff:fe00:79be] (unknown [IPv6:2a02:3e0:1:0:6a68:68ff:fe00:79be])
	by efeu.mur.at (Postfix) with ESMTPSA
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Oct 2014 12:40:34 +0200 (CEST)
Message-ID: <542E7D21.2030905@mur.at>
Date: Fri, 03 Oct 2014 12:40:33 +0200
From: =?UTF-8?B?Sm9naSBIb2Ztw7xsbGVy?= <jogi@mur.at>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs 3.16.2 does not recognize subvolumes correctly
References: <542D100F.9050502@mur.at>
In-Reply-To: <542D100F.9050502@mur.at>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="DGnvjr0awg4BG3HHro0X32WqoNjnhu9G9"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DGnvjr0awg4BG3HHro0X32WqoNjnhu9G9
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi all,

First of all, I am talking about btrfs-progs 3.16.2 if there was any doub=
t.

I did some more checking and found the following disturbing results.

I can still create snapshots of subvolumes and the default subvolume (/)
without problems.  But sending the snapshot fails with the error:

ERROR: /.SNAPSHOT doesn't belong to btrfs mount point

btrfs subvolume list -a /

ID 259 gen 21444 top level 5 path home
ID 260 gen 21443 top level 5 path var
ID 742 gen 18830 top level 5 path .SNAPSHOT
ID 743 gen 18832 top level 259 path home/.SNAPSHOT

But then again e.g.

btrfs subvolume show /home
ERROR: /home doesn't belong to btrfs mount point

All this is happening on my laptop running kernel 3.16.3. (Debian).

Interestingly enough I have another machine where only the default
subvolume makes problems but another subvolume can be snapshotted and
the snapshot send.  This machine uses kernel 3.14.15.

Please let me know what I can do to fix this.

Regards,
--=20
J.Hofm=C3=BCller

ich zitiere wie Espenlaub.

https://twitter.com/TheGurkenkaiser/status/463444397678690304


--DGnvjr0awg4BG3HHro0X32WqoNjnhu9G9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlQufSEACgkQkaXhaapqItlsXQD/eHQi5zXilufLRZEo0J4DDYU9
CBxM2wnKMlFjGMDBg8UA/iNEAdo+c6YOv42Z7HBqS4zlKIe4kQ5gIdOY7i8IIdg9
=BFER
-----END PGP SIGNATURE-----

--DGnvjr0awg4BG3HHro0X32WqoNjnhu9G9--
