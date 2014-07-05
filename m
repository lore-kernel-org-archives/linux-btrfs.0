Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:49175 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727AbaGEXtQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 5 Jul 2014 19:49:16 -0400
Received: from localhost (localhost [127.0.0.1])
	by csamuel.org (Postfix) with ESMTP id 67E0DCC1D7
	for <linux-btrfs@vger.kernel.org>; Sun,  6 Jul 2014 09:49:15 +1000 (EST)
Received: from csamuel.org ([127.0.0.1])
 by localhost (csamuel.org [127.0.0.1]) (amavisd-maia, port 10024) with LMTP
 id 06944-02 for <linux-btrfs@vger.kernel.org>;
 Sun,  6 Jul 2014 09:49:15 +1000 (EST)
Received: from quad.localnet (2001-44b8-41dd-d500-41e5-d52a-ef02-a5ee.static.ipv6.internode.on.net [IPv6:2001:44b8:41dd:d500:41e5:d52a:ef02:a5ee])
	by csamuel.org (Postfix) with ESMTPSA id E6AE8CC164
	for <linux-btrfs@vger.kernel.org>; Sun,  6 Jul 2014 09:49:14 +1000 (EST)
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: A question about subvolumes
Date: Sun, 06 Jul 2014 09:49:09 +1000
Message-ID: <1795423.Nv12ijGxhf@quad>
In-Reply-To: <53B8227A.30809@gmail.com>
References: <53B6BC65.3080302@barrowhillfarm.org.uk> <53B7E4D1.9070803@barrowhillfarm.org.uk> <53B8227A.30809@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1755415.YWVrlG2HCf"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart1755415.YWVrlG2HCf
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

On Sat, 5 Jul 2014 12:06:18 PM Austin S Hemmelgarn wrote:

> I'm pretty certain that recent versions of the GNU Coreutils will
> automatically try a reflink for cp if the underlying filesystem is
> BTRFS.  I'm not 100% certain about this as I've just aliases cp to 'c=
p
> --reflink=3Dauto' on all my systems.

Doesn't appear to be the case in the current git I'm afraid.

http://git.savannah.gnu.org/cgit/coreutils.git/tree/src/cp.c

You could choose to patch cp.c to change:

  x->reflink_mode =3D REFLINK_NEVER;

to:

  x->reflink_mode =3D REFLINK_AUTO;

to change the default should you wish to.

All the best,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC


--nextPart1755415.YWVrlG2HCf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEVAwUAU7iO+I1yjaOTJg85AQITiQgAnQQNQjY4oX4o9i4Fd6Wy/sg3iJ16QDeX
9Bq4TDnXPG/FtFyUu0ROKk4d3xi1CO3Z2XlMmEXBYX4tWJOK958aM+EamYaMTQKn
nlNSBlESG8anNp7tYYaXn0N1QeYO/EvyNc3EjMPWsti5evHTLBH1bzDlVoUjX5Hn
8Xz47iF0Qpan3ezjYQxtQSHWSgpyQPU00PxabhyTSk5QSUezu9KnFZj82hqZEfUB
pvo1PmIqCLDqqwNOMMovRC4WxDwc3vTqTtUdxrOcZ27Amg1ZFQVJuSIcQqu60qxw
0xTUrOAfzIiEcUgCSmrfHmiIDIEWrGccSrX7GFtEhj32DGcDJ4oHEg==
=cRlS
-----END PGP SIGNATURE-----

--nextPart1755415.YWVrlG2HCf--

