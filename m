Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([176.31.121.172]:47059 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759912Ab3B0EGD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 23:06:03 -0500
Date: Wed, 27 Feb 2013 10:05:58 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: "Fajar A. Nugraha" <list@fajar.net>
Cc: Martin Steigerwald <Martin@lichtvoll.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Mike Fleetwood <mike.fleetwood@googlemail.com>,
        Suman C <schakrava@gmail.com>
Subject: Re: lvm volume like support
Message-ID: <20130227100558.37d86d82@natsu>
In-Reply-To: <CAG1y0sfYqcZTyHffV=t95R09qyJc911ZE-F-YPM1rKmV1wj7CA@mail.gmail.com>
References: <CAPF83msjTJWjWJgJOAWsQ2GoxAC-cZ4GkK_+H11tAyA689KD_w@mail.gmail.com>
	<CAMU1PDhQqm6s5FUbVJa5nwOD4Ewf-6Cr2gx2khHHwrBxUqsQDA@mail.gmail.com>
	<CAG1y0scOg2QGCZdCTkKHBn5xxNh5GGmdXTcS8rOesup4r1JsXQ@mail.gmail.com>
	<201302261130.31494.Martin@lichtvoll.de>
	<CAG1y0sfYqcZTyHffV=t95R09qyJc911ZE-F-YPM1rKmV1wj7CA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/5NT=kY_7y4FARM.+i4NCxTC"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/5NT=kY_7y4FARM.+i4NCxTC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 27 Feb 2013 13:23:23 +1100
"Fajar A. Nugraha" <list@fajar.net> wrote:

> Not to mention the hassle in accessing the data if it resides on a=20
> partition inside the file (e.g. you need losetup + kpartx to access it,
> and you must remember to do the reverse when you're finished with it).

>=20
> In zfsonlinux it's very easy to do so since a zvol is treated pretty
> much like a disk, and whenever there's a partition inside a zvol, a
> coressponding device noed is also created automatically.

So I'd say what you (we) need is a generic Linux kernel framework that would
allow treating any regular file pretty much like a disk. Not some
filesystem-specific block device emulation kludge.

Btw some years ago there was a patchset adding proper automatic partition
support to 'loop'; but it seems like that went nowhere, and I have no idea =
why
something this useful did not end up being added into the mainline kernel.

--=20
With respect,
Roman

--Sig_/5NT=kY_7y4FARM.+i4NCxTC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlEthiYACgkQTLKSvz+PZwjDEgCfVz3vhCBbe0SnJMYL/uwt9hpA
Hw4AnAiIkBmyCRi8fBsZL8hi3l37AlTE
=cSAb
-----END PGP SIGNATURE-----

--Sig_/5NT=kY_7y4FARM.+i4NCxTC--
