Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:44276 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932653Ab2GMM2m (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Jul 2012 08:28:42 -0400
Date: Fri, 13 Jul 2012 13:28:39 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org, Skylar Burtenshaw <daninfuchs@gmail.com>
Subject: Re: Can't mount, power failure - recoverable?
Message-ID: <20120713122839.GJ28701@carfax.org.uk>
References: <loom.20120317T051243-551@post.gmane.org>
 <CAG1y0sdg18Dv2YA_WDRSYp3eGTHO-V2xx99OXxDJQx=O4qqgHA@mail.gmail.com>
 <loom.20120326T104619-458@post.gmane.org>
 <201207131423.54019.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vkEkAx9hr54EJ73W"
In-Reply-To: <201207131423.54019.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--vkEkAx9hr54EJ73W
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 13, 2012 at 02:23:53PM +0200, Martin Steigerwald wrote:
> Am Montag, 26. M=E4rz 2012 schrieb Skylar Burtenshaw:
> > Fajar A. Nugraha <list <at> fajar.net> writes:
> > > Didn't Chris' last response basically say "use kernel 3.2 or newer,
> > > mount the fs (possibly with -o ro), and copy the data elsewhere"?
> >=20
> > Why yes, yes it did actually. I appreciate your spotlighting it, just
> > in case I somehow managed to miss it, though.
> >=20
> > > Have you done that?
> >=20
> > I have. In fact, in my first message, I stated that in all kernels up
> > to present 3.2 kernels, I get several minutes of disk churning, then a
> > stack trace. Also present in my messages is the fact that the
> > filesystem will not mount, as well as data output from the recovery
> > program etc which fail to recognize things in the filesystem that they
> > require in order to fix it. Did you have something you wished to
> > suggest, in order to help me? If so, I'd gladly listen to any proposed
> > ideas.
>=20
> Since I didn=B4t found any explicit mention on it:
>=20
> Did you try btrfs-zero-log on the partition prior to mounting it?
>=20
> All of my BTRFS will not mount after sudden write interruption cases have=
=20
> been solved by it. Except one with a BTRFS RAID 0 with lots of 2 TB drive=
s=20
> at a time where I didn=B4t know about btrfs-zero-log. Maybe it would have=
=20
> helped there, too.
>=20
> Of course I could be completely off track and this could be a completely=
=20
> different issue.

   I'm afraid you probably are -- there's nothing I can see in the
stack trace that would indicate that it's falling over in the log tree
replay, which is the only thing that btrfs-zero-log would help with.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- A diverse working environment:  Di longer you vork here, di ---  =20
                             verse it gets.                             =20

--vkEkAx9hr54EJ73W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFQABR2IKyzvlFcI40RAmB6AJ4sdWt5VcyRihb8IYywpgJE/fd/DACfa+sE
ofx24Wzqvb3ZLih586IKjl8=
=JIWA
-----END PGP SIGNATURE-----

--vkEkAx9hr54EJ73W--
