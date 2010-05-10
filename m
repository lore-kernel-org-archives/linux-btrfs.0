From: Bruce Guenter <bruce@untroubled.org>
Subject: Disk space accounting and subvolume delete
Date: Mon, 10 May 2010 12:23:52 -0600
Message-ID: <20100510182352.GA21154@untroubled.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi.

When deleting a snapshot, I have observed that the disk space used by
that snapshot is not immediately released (according to statvfs or df).
Neither "sync" nor "btrfs filesystem sync" releases the disk space
neither.  The only way I have found to actually fully release the disk
space is to issue the sync and then sleep until the statvfs free numbers
stop changing.

This is a rather problematic approach to managing disk space.  Is there
any way to either force a wait until the disk space has been released?

My application is automatically managing disk space in the presence of
snapshots.  I allow the disk (a backup) to fill up with snapshots until
it is nearly full, and then to delete snapshots until I have a threshold
free.  However, without the disk space being released promptly and no
way to wait until it is released, the loop can't tell how many snapshots
to delete.

--=20
Bruce Guenter <bruce@untroubled.org>                http://untroubled.org/

--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAkvoTzgACgkQ6W+y3GmZgOiOKwCfYCQ29CD/ygU3qY6CSVbFeTRp
Si8AnRaaDJjAVHpl0cS+VIblvZl74KtO
=6ACm
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--
