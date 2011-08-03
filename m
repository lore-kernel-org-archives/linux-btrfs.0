From: mck <mck@apache.org>
Subject: Re: Applications using fsync cause hangs for several seconds every
 few minutes
Date: Wed, 03 Aug 2011 17:50:10 +0200
Message-ID: <1312386610.23947.2.camel@localhost>
References: <BANLkTimMv_MMVmsJeVvr_1_wEVam1WZ6BA@mail.gmail.com>
	 <4E2478B1.60601@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Kpazn5FaXTYnh66fE0TQ"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E2478B1.60601@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>


--=-Kpazn5FaXTYnh66fE0TQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2011-07-18 at 14:17 -0400, Josef Bacik wrote:
> I've been looking into this and I have a suspicion.  Would you run
> with this patch and see if the problem goes away?=20

Didn't help me.

2.6.39 is not usable. 3.0.0 is ok for a few hours then too becomes
unusable. This is discussed in future threads, eg "Btrfs slowdown".

dumbing out fsync (libeatmydata) only gives marginal improvements...

~mck

--=20
Bombing for peace is like F***ing for virginity | www.semb.wever.org |
www.sesat.no | tech.finn.no | http://xss-http-filter.sf.net

--=-Kpazn5FaXTYnh66fE0TQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEABECAAYFAk45bjIACgkQkdPrePiuutNU6wCg/XzFm04L2FU7GJeaFm3ZvFIL
bYUAoLjjHOwGiv8XT4yRG+NKT5UmhsW8
=IjNM
-----END PGP SIGNATURE-----

--=-Kpazn5FaXTYnh66fE0TQ--


