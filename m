From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Odd block-count behaviour
Date: Wed, 16 Jun 2010 13:47:30 +0100
Message-ID: <20100616124730.GA1727@vlad.carfax.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   Hi,

   I've just been copying large quantities of data from one btrfs
volume to another, and while watching the progress of the copy, I've
noticed something odd.

$ mv source-dir dest-dir
$ watch du -ms source-dir dest-dir

   This gives me a count of the size of the source and target
directories, every 2 seconds. As expected, the size of the source dir
stays constant, and the size of the destination directory increases.
Except when it doesn't.

   Occasionally, while copying, the size of the dest-dir *drops* by
several (tens of) megabytes. I'm not too worried about this, as it all
seems to be copying the data OK, but it just seems a bit odd, and was
wondering of there was a sane explanation for this behaviour.

   I'm running a linux.org 2.6.32.2 kernel, and the destination
filesystem has just been created using the most recent btrfs tools.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- There's many a slip 'twixt wicket-keeper and gully. ---       

--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQFMGMfiIKyzvlFcI40RAq30AJ4oABH5mZLd97803NRI+ju7c9TpxgCdG4J6
InoRv35M5gLDoq5lKMN6Fsg=
=Tc4S
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--
