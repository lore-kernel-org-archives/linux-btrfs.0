From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: convert raid-10 to raid-0?
Date: Sun, 5 Jun 2011 11:54:32 +0100
Message-ID: <20110605105432.GE8002@carfax.org.uk>
References: <20110605013645.GD8111@taz.net.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ns7jmDPpOpCD+GE/"
Cc: linux-btrfs@vger.kernel.org
To: Craig Sanders <cas@taz.net.au>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110605013645.GD8111@taz.net.au>
List-ID: <linux-btrfs.vger.kernel.org>


--Ns7jmDPpOpCD+GE/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 05, 2011 at 11:36:45AM +1000, Craig Sanders wrote:
> Please CC me on any replies as I am not subscribed to this list. Thanks.
> 
> Is it possible to convert an existing 4-disk btrfs volume created as
> raid-10 to a btrfs raid-0/striped volume?

   Not at present.

> i've got a btrfs raid-10 volume made with 4x1TB drives that's running
> out of space, and i'd prefer not to reformat it if i don't have to.

   There's a GSoC student due to be working on this over the summer.
(I was looking at it, but I've stopped to give the student a clear run
at it).

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                   --- Ceci n'est pas une pipe:  | ---                   

--Ns7jmDPpOpCD+GE/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFN62BnIKyzvlFcI40RAjQJAJ99IztEg+7xI+74jaiPD7ZXBaNCvQCeJCJ6
HFvrwpi6VBHGHuvepmiT8Iw=
=jwrc
-----END PGP SIGNATURE-----

--Ns7jmDPpOpCD+GE/--
