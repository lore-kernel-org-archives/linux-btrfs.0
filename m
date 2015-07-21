Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bastet.luchs.at ([77.244.242.186]:48073 "EHLO bastet.luchs.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415AbbGUIBc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jul 2015 04:01:32 -0400
Received: from localhost (localhost [127.0.0.1])
	by bastet.luchs.at (Postfix) with ESMTP id 790113FFCC
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Jul 2015 10:01:30 +0200 (CEST)
Received: from bastet.luchs.at ([127.0.0.1])
	by localhost (bastet.luchs.at [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uhaMWywjtkD1 for <linux-btrfs@vger.kernel.org>;
	Tue, 21 Jul 2015 10:01:30 +0200 (CEST)
Received: from nephtys.luchs.at (localhost [127.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(Client CN "nephtys.luchs.at", Issuer "luchs.at CA (Version 3.0)" (verified OK))
	by bastet.luchs.at (Postfix) with ESMTPS id C6B013FF75
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Jul 2015 10:01:29 +0200 (CEST)
Received: from nephtys.luchs.at (localhost [127.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(Client did not present a certificate)
	by nephtys.luchs.at (Postfix) with ESMTPS id 95ABFE8994
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Jul 2015 10:00:27 +0200 (CEST)
Date: Tue, 21 Jul 2015 10:00:26 +0200
From: =?iso-8859-15?Q?Ren=E9?= Pfeiffer <lynx@luchs.at>
To: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs progs release 4.1.2 (urgent fix, do not use 4.1.1)
Message-ID: <20150721080026.ZC5228@many.eyes.bnd.bund.de>
References: <20150714120603.GH15535@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="U+BazGySraz5kW0T"
In-Reply-To: <20150714120603.GH15535@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--U+BazGySraz5kW0T
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Jul 14, 2015 at 1406 +0200, David Sterba appeared and said:
> ...
> at the beginning of the output. Such filesystems must not be used and
> must be recreated. Read-only mount should be safe to retrieve the data,
> but at the moment this hasn't been verified.

I was able to copy my Btrfs filesystem to a new disk by setting the old one
(created by Btrfs progs 4.1.1) read-only. I copied 292 GB with 900,000+
files and directories without errors reading from the original.

Best,
Ren=E9.

--=20
  )\._.,--....,'``.  fL  Let GNU/Linux work for you while you take a nap.
 /,   _.. \   _\  (`._ ,. R. Pfeiffer <lynx at luchs.at> + http://web.luchs=
=2Eat/
`._.-(,_..'--(,_..'`-.;.'  - System administration + Consulting + Teaching -
Got mail delivery problems?  http://web.luchs.at/information/blockedmail.php

--U+BazGySraz5kW0T
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iF4EAREKAAYFAlWt/BoACgkQSPQ8C8rI6DuXswD7BChS9KxSC4Yv7kkLw3UVKbYH
e0PEyN8d8bTHsaQO5yUA/iccI8gUyP5TVS18cGWKP7l98V4StsALRJ8f/4oC79BA
=32hF
-----END PGP SIGNATURE-----

--U+BazGySraz5kW0T--
