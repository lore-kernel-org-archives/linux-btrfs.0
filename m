Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mehl.schokokeks.org ([46.4.40.247]:44955 "EHLO
	mehl.schokokeks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933206AbaCQMrR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Mar 2014 08:47:17 -0400
Date: Mon, 17 Mar 2014 13:47:09 +0100
From: Florian Bruhin <me@the-compiler.org>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS critical / kernel BUG / high load
Message-ID: <20140317124708.GF21978@lupin>
References: <20140317055754.GA21978@lupin>
 <CAL3q7H6c5z7N6k0ixT+KN6+qfEzOMgrBOWQRX30vsfqSZoViTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_mehl.schokokeks.org-24816-1395060430-0001-2"
In-Reply-To: <CAL3q7H6c5z7N6k0ixT+KN6+qfEzOMgrBOWQRX30vsfqSZoViTg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_mehl.schokokeks.org-24816-1395060430-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Filipe David Manana <fdmanana@gmail.com> [2014-03-17 11:16:35 +0000]:
> On Mon, Mar 17, 2014 at 5:57 AM, Florian Bruhin <me@the-compiler.org> wro=
te:
> > Hi,
> >
> > on one of my servers running btrfs, I noticed a very high load of
> > 26/26/26. After investigating further, this happened in my logs about
> > 5 minutes before the monitoring alerted me because of the load:
>
> This issue was fixed in kernel 3.14 by:
>=20
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?i=
d=3D5de865eebb8330eee19c37b31fb6f315a09d4273
>=20
> It was already backported to 3.12.14 but not yet to any 3.13 release.

Thanks, I see.

What about the free space error messages I got after the reboot?

Should I do anything or do I have to worry about anything being
corrupt? I'm running a scrub right now.

Florian

--=20
() ascii ribbon campaign - stop html mail    www.asciiribbon.org
/\ www.the-compiler.org  | I love long mails http://email.is-not-s.ms/
QOTD: "I haven't come far enough, and don't call me baby."=20

--=_mehl.schokokeks.org-24816-1395060430-0001-2
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTJu7MAAoJEJFusMj9VaByKRIQAJsA+I+S5azKcos0PZrVAeNN
w0WnUEHlWmlRUJgv/smCDU6Gp9PLmJm2h/OxnZLAZTVToIqzuSGmGzdgW93ScklK
jbtr0qWewvpkGuQpn5EMJ6IOHZ4TZ09nJYw8XwoPb3+FXFFnpfOIc58a5yo43gMg
mzmopbUV7ZHm/ShMfsyHM8BdOrq+ZY0feT8fKjMhmOyMA5MgS6vMk/+Gn/XUt1p4
atCRlhkWSYiC4jfbqUCAl/KYaua5a/b0yDtgRmeLyFy0EbjcEDLBLO6hvy5IRm4C
19+lCK6EK+TbrW7kn8jZLU6RFQ0cj4jpYlYQW53qfj12StyoGstyXg38Z3UgWAPz
zv3v7SA83O/r6qe/P577BymvApoqk8F8NCKyURtOppiPvoQfSMa0c7m2z3aTogCY
p/sN2cwWOnizoMQxUHPSYU4Wxl8W8w+nIoDiO+sLv/jZ/pXY4QMRmlFWkPn6vm6O
95CqxWJUllMaqBv/fmzFVjBsJZ2aJbmQpD+0SY+x0dDjxBQVD0Sslpkw5hQb9BXW
DruwoEo7Suc34V/an7YvTyIJyu+eU6ttUxJoM7au6NDsaHRafNkZ5q0a7YF5MCey
BBswozZXZdWCrGJaCnrkeQM343AYgQp2tX/iPzlrLhGjbGiFIk4y2RXAmf78M55w
u2lyR3tv72DrrxYc5STv
=4zun
-----END PGP SIGNATURE-----

--=_mehl.schokokeks.org-24816-1395060430-0001-2--
