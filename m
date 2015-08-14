Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:64520 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753894AbbHNIGG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 04:06:06 -0400
Received: from thetick ([93.181.44.4]) by mail.gmx.com (mrgmx003) with ESMTPSA
 (Nemesis) id 0Mg42v-1ZBfvK2P49-00NRvi for <linux-btrfs@vger.kernel.org>; Fri,
 14 Aug 2015 10:06:03 +0200
Date: Fri, 14 Aug 2015 10:05:55 +0200
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: trim not working and irreparable errors from btrfsck
Message-ID: <20150814100555.24c01e93@thetick>
In-Reply-To: <CAJCQCtR_9L4oBOcLAfL1gC4UVt1APOU6iSkJ3TBrEcUb0hT3qg@mail.gmail.com>
References: <mlpb8i$dus$1@ger.gmane.org>
	<CAJCQCtQGzwQ=L4Vh19tsqSqPoPJuNaLyTo7q0SsbMteb2=tdMw@mail.gmail.com>
	<55816E7B.5040905@gmail.com>
	<CAJCQCtQnSSATHPkX-NgQVkXHB0Z+VJrt14sMk4bHaoQ4nS=Jcw@mail.gmail.com>
	<mls0gb$s7m$1@ger.gmane.org>
	<B7F2379062E32745A8651FBDB20F64595D40C1BD@Server.waterlogic.com.au>
	<5581ABA2.30906@gmail.com>
	<21893.29830.540787.159202@localhost.localdomain>
	<B7F2379062E32745A8651FBDB20F64595D45D284@Server.waterlogic.com.au>
	<20150813112331.297d15f6@thetick>
	<CAJCQCtR_9L4oBOcLAfL1gC4UVt1APOU6iSkJ3TBrEcUb0hT3qg@mail.gmail.com>
Reply-To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/rwXaRfa1hhtB0_nB7x5tU1e"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/rwXaRfa1hhtB0_nB7x5tU1e
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Am Thu, 13 Aug 2015 17:14:36 -0600
schrieb Chris Murphy <lists@colorremedies.com>:

> On Thu, Aug 13, 2015 at 3:23 AM, Marc Joliet <marcec@gmx.de> wrote:
>=20
> > Speaking as a user, since "fstrim -av" still always outputs 0 bytes tri=
mmed
> > on my system: what's the status of this?  Did anybody ever file a bug r=
eport?
>=20
> Since I'm not having this problem with my SSD, I'm not in a position
> to provide any meaningful information for such a report.
>=20
> The bug should whether this problem is reproducible with ext4 and XFS
> on the same device, and the complete details of the stacking (if this
> is not the full device or partition of it; e.g. if LVM, md, or
> encryption is between fs and physical device). And also the bug should
> include full dmesg as attachment, and strace of the fstrim command
> that results in 0 bytes trimmed. And probably separate bugs for each
> make/model of SSD, with the bug including make/model and firmware
> version.
>=20
> Right now I think there's no status because a.) no bug report and b.)
> not enough information.

I was mainly asking because apparently there *is* a patch that helps some
people affected by this, but nobody ever commented on it.  Perhaps there's a
reason for that, but I found it curious.  (I see now that it was submitted =
in
early January, in the thread "[PATCH V2] Btrfs: really fix trim 0 bytes aft=
er a
device delete".)

I can open a bug (I mean, that's part of being a user of btrfs at this stag=
e),
I'm just surprised that nobody else has.

BTW, is there a way to tell if the "discard" mount option does anything?  I=
'm
curious about whether it could behave differently.

--=20
Marc Joliet
--
"People who think they know everything really annoy those of us who know we
don't" - Bjarne Stroustrup

--Sig_/rwXaRfa1hhtB0_nB7x5tU1e
Content-Type: application/pgp-signature
Content-Description: Digitale Signatur von OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJVzaFqAAoJEL/Q5oYsiHj0SfUP/259ENem4tJ0hnYD1VJo1EW9
9GQPO9hdorIX2WbAXQRtJse5A9/02wDUJtGU8In22+fVe0sDAl3UZNgo6CWdSGI8
JFRLqexYgKhtXU9ig3cL4SAZu20uiIoSlanPZ7XpxBdjYe5I4kINCEkkuyYDb25p
UtkIEiKaPNV7xiWjpCmBBgb9I+gG3kjdRkCZ0wwGiWN9oupHUbjw27JTn9KXR5Id
Qsc0xxFMvI+aM4sYvP+Op7Yl+lvQjf5G1g8QrWFrJOfwMkOBHDzaq+3IPoZZpOwO
0+9BcB9KKfxJWM42CF3qdVcTQVx+SxStrTBp27Ya5HB3RcCvD/os6m0eT2JG1zJf
nA1xBxX//gYrsnBof9lo1EokXl3edTmRscb8dea1Z6qPZ8VEYDgTZtej+f1Rl0JD
6LJewn+PnrEYy/m8QdOvjUBeB/tMmUbd4fmIqJ1/pEIXoDw4zjjjoT51F4Tl+RgF
VabfuyO1Cp4vDIczioYW1TcS0R14DBGsLtnR9990ji/AzvT81QlKIC9LQ/bOLItN
1YuPf/lozqocBxttr4nB2NW4k+K9mG677B01NRmjm9AT4gVpttTGYq6/D3vdzsvK
lbj58p7qPi8ymWBO7UdeegU2RUVZ6wzv7OdBU+Ab5YMuO2NPjwn5lMXVkFhjz1tQ
2pOXeH8AtRGeDMSe7Lsg
=laz3
-----END PGP SIGNATURE-----

--Sig_/rwXaRfa1hhtB0_nB7x5tU1e--
