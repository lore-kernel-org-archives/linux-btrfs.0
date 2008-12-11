From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Btrfs trees for linux-next
Date: Thu, 11 Dec 2008 14:14:36 +1100
Message-ID: <20081211141436.030c2d65.sfr@canb.auug.org.au>
References: <1227183484.6161.17.camel@think.oraclecorp.com>
	<1228962896.21376.11.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__11_Dec_2008_14_14_36_+1100_GOxscousBnZwLBrZ"
Cc: Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1228962896.21376.11.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

--Signature=_Thu__11_Dec_2008_14_14_36_+1100_GOxscousBnZwLBrZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Wed, 10 Dec 2008 21:34:56 -0500 Chris Mason <chris.mason@oracle.com> wro=
te:
>
> Just an update, while I still have a long todo list and plenty of things
> to fix in the code, these src trees have been updated with a disk format
> I hope to maintain compatibility with from here on.  There are still
> format changes planned, but should go in through the compat mechanisms
> in the sources now.
>=20
> The btrfs trees are still at 2.6.28-rc5, but I just tested against
> linux-next without problems.

Do you think this is ready to be added to the end of linux-next, yet?  Or
is this more -mm material?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__11_Dec_2008_14_14_36_+1100_GOxscousBnZwLBrZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklAhZwACgkQjjKRsyhoI8yYJwCfRO749pIw7+/FZIXk7776VO5j
27IAmwWCza0BGP8lIpPhdT1rxo23LlOl
=JsVf
-----END PGP SIGNATURE-----

--Signature=_Thu__11_Dec_2008_14_14_36_+1100_GOxscousBnZwLBrZ--
