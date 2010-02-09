From: Ian Kumlien <pomac@vapor.com>
Subject: Re: [bug] Reclaim space.
Date: Tue, 09 Feb 2010 22:13:39 +0100
Message-ID: <1265750019.5943.9.camel@pi>
References: <1265740911.5943.7.camel@pi>
	 <m3iqa62n8t.fsf@pullcord.laptop.org> <m3d40e2kdn.fsf@pullcord.laptop.org>
	 <1265749549.5943.8.camel@pi>  <m38wb22k5m.fsf@pullcord.laptop.org>
Reply-To: pomac@vapor.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-EdBZSDHHrHZuGZ+sc3Cb"
Cc: linux-btrfs@vger.kernel.org
To: Chris Ball <cjb@laptop.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m38wb22k5m.fsf@pullcord.laptop.org>
List-ID: <linux-btrfs.vger.kernel.org>


--=-EdBZSDHHrHZuGZ+sc3Cb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On tis, 2010-02-09 at 16:07 -0500, Chris Ball wrote:
> Hi,
>=20
>    > Will this also fix the directory that i can't delete?
>=20
> No, I think you need "btrfsctl -D" for that.

btrfsctl -D ext2_saved/
ioctl:: Invalid argument

uname -r
2.6.33-rc7

So i assume it's not merged yet?

> - Chris.

--=20
Ian Kumlien <pomac () vapor ! com> -- http://pomac.netswarm.net

--=-EdBZSDHHrHZuGZ+sc3Cb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEABECAAYFAktx0AMACgkQ7F3Euyc51N8E5wCgsDpkaSQh5BlZ97b/3Q8q0USm
5PgAoIK9dwOQLtHIyeKkKhqZCb4ZO5KL
=ORht
-----END PGP SIGNATURE-----

--=-EdBZSDHHrHZuGZ+sc3Cb--

