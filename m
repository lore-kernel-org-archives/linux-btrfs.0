From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: balance on only one subvolume
Date: Sat, 9 Jul 2011 09:41:02 +0100
Message-ID: <20110709084102.GF4325@carfax.org.uk>
References: <CAJ1PRSksnE8D6K3HCLG-0Kcc5wrEJDqDjxROafJh-NHKpus2-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3oCie2+XPXTnK5a5"
Cc: linux-btrfs@vger.kernel.org
To: "krzf83@gmail.com " <krzf83@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAJ1PRSksnE8D6K3HCLG-0Kcc5wrEJDqDjxROafJh-NHKpus2-w@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--3oCie2+XPXTnK5a5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jul 09, 2011 at 01:40:19AM +0200, krzf83@gmail.com  wrote:
> btrfs balance takes very long time on large filesystems. Possibility
> of running balance on only one subvolume 

   That doesn't make a great deal of sense in terms of the on-disk
data structures.

> or running balance to reclaim
> only after deleing subvolume would be usefull.

   Reclaim what? Deleting a subvolme doesn't need a balance following
it to reclaim *anything*. What exactly are you trying to achieve?

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                       ---   __(_'>  Squeak!   ---                       

--3oCie2+XPXTnK5a5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOGBQdIKyzvlFcI40RAju8AJ9deaVocE34aXyzGpy/J8d9bHwe+ACgryAH
NUsDGk+HFkfJoRuO17eaypc=
=7CP3
-----END PGP SIGNATURE-----

--3oCie2+XPXTnK5a5--
