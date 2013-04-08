Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([176.31.121.172]:44938 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757022Ab3DHLWE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Apr 2013 07:22:04 -0400
Date: Mon, 8 Apr 2013 17:22:00 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: Harald Glatt <mail@hachre.de>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs can't complete balance
Message-ID: <20130408172200.19f003ca@natsu>
In-Reply-To: <CAFWF=am5sBw+APOu6yAUBnjvpt+vbr_7vw0F8o1ZAGk-JDbhmg@mail.gmail.com>
References: <CAFWF=ameE9p4W5XT-yLoU2H=by0Y4yp3VUmiLOXSOtOzBHaYwQ@mail.gmail.com>
	<20130408171443.5339e82f@natsu>
	<CAFWF=am5sBw+APOu6yAUBnjvpt+vbr_7vw0F8o1ZAGk-JDbhmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/tdQLMaa32/MmD6uxAcgZIew"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/tdQLMaa32/MmD6uxAcgZIew
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 8 Apr 2013 13:19:13 +0200
Harald Glatt <mail@hachre.de> wrote:

> You're right, I'm seeing this 'object already exists' message in my
> dmesg log. Nice catch!!

See this thread:
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg23514.html

This patch fixes the problem:
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg23534.html

But it is / will be only in the very latest kernels (including 'stable'
updates), because it was posted only like a week ago.

--=20
With respect,
Roman

--Sig_/tdQLMaa32/MmD6uxAcgZIew
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlFiqFgACgkQTLKSvz+PZwhyvQCeOFweJ66vEEL6Pa9r7e3lt74O
xZIAnjFi0bVIh/cnoN/XWDrqATYuNO6P
=UljK
-----END PGP SIGNATURE-----

--Sig_/tdQLMaa32/MmD6uxAcgZIew--
