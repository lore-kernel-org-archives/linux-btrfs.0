From: Ian Kumlien <pomac@vapor.com>
Subject: Re: [bug] Reclaim space.
Date: Wed, 10 Feb 2010 00:13:49 +0100
Message-ID: <1265757229.5943.13.camel@pi>
References: <1265740911.5943.7.camel@pi>
	 <m3iqa62n8t.fsf@pullcord.laptop.org>  <m3d40e2kdn.fsf@pullcord.laptop.org>
Reply-To: pomac@vapor.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-XcqiIfS5wX/Tc+nD/goZ"
Cc: linux-btrfs@vger.kernel.org
To: Chris Ball <cjb@laptop.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m3d40e2kdn.fsf@pullcord.laptop.org>
List-ID: <linux-btrfs.vger.kernel.org>


--=-XcqiIfS5wX/Tc+nD/goZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On tis, 2010-02-09 at 16:02 -0500, Chris Ball wrote:
> Hi,
>=20
>    > Here's a patch to btrfsck from Josef that should fix this:
>=20
> Sorry, that was an older patch.  This is the working one:

It didn't apply cleanly to latest git, so i remerged the patch...
The new output sure looks better in my eyes:

/dev/mapper/root      145G  135G   11G  93% /

=3D)

Thanks, I do wonder btw, btrfsck always seems to segfault when you check
a filesystem in real use - ie loged in users and daemons running - but
not on a normal 'single' user boot. Anything that could be done with
this? (It doesn't inspire confidence ;))

--=20
Ian Kumlien <pomac () vapor ! com> -- http://pomac.netswarm.net

--=-XcqiIfS5wX/Tc+nD/goZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEABECAAYFAktx7CwACgkQ7F3Euyc51N9X4QCfdcBW3+fGW8UgbtP8l99mPIZm
+r0AnAwBw9S5n9c33Di64yXERcJsbjQn
=FxOd
-----END PGP SIGNATURE-----

--=-XcqiIfS5wX/Tc+nD/goZ--

