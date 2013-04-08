Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([176.31.121.172]:44017 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759657Ab3DHLOr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Apr 2013 07:14:47 -0400
Date: Mon, 8 Apr 2013 17:14:43 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: Harald Glatt <mail@hachre.de>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs can't complete balance
Message-ID: <20130408171443.5339e82f@natsu>
In-Reply-To: <CAFWF=ameE9p4W5XT-yLoU2H=by0Y4yp3VUmiLOXSOtOzBHaYwQ@mail.gmail.com>
References: <CAFWF=ameE9p4W5XT-yLoU2H=by0Y4yp3VUmiLOXSOtOzBHaYwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/SDxDd=qYFF48LluyQfG.rKq"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/SDxDd=qYFF48LluyQfG.rKq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 8 Apr 2013 09:48:55 +0200
Harald Glatt <mail@hachre.de> wrote:

> At some point 'btrfs send' stopped working but gave no better error
> message than invalid argument.

Usually in cases like this there are more details in 'dmesg'.

> I did a balance on the drive which resulted in a kernel panic after a
> while of working.

Maybe you faced the same problem that I had recently with "Object already
exists" . Could've been useful if you saved the actual kernel panic message.

--=20
With respect,
Roman

--Sig_/SDxDd=qYFF48LluyQfG.rKq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlFipqMACgkQTLKSvz+PZwjdNwCgi5g4KLzeE7xoYnggU+lLtotG
6vUAnjHoVrz1VdiZdX1FY6Qh5RbHm54N
=zrSv
-----END PGP SIGNATURE-----

--Sig_/SDxDd=qYFF48LluyQfG.rKq--
