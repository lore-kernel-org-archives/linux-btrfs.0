From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: recursive subvolume delete
Date: Sun, 2 Oct 2011 17:06:44 +0100
Message-ID: <20111002160644.GL2459@carfax.org.uk>
References: <CAJ1PRS=7HGupXFP1ma-rTyFnxvtCge2Ajipg1wLmGhZTAuDKrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PpocKf6TCvdC9BKE"
Cc: linux-btrfs@vger.kernel.org
To: "krzf83@gmail.com " <krzf83@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAJ1PRS=7HGupXFP1ma-rTyFnxvtCge2Ajipg1wLmGhZTAuDKrg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--PpocKf6TCvdC9BKE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Oct 02, 2011 at 04:38:21PM +0200, krzf83@gmail.com  wrote:
> btrfs is missing recursive subvolume delete. You can't delete
> subvolume if there is other subvolumes/snapshots in it. Also I think
> there are no real tools to find out which directories are
> subvolumes/snapshots

$ btrfs sub list /mountpoint

   This will tell you what subvolumes you have on any given filesystem.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- There's an infinite number of monkeys outside who want to ---    
               talk to us about this new script for Hamlet               
                           they've worked out!                           

--PpocKf6TCvdC9BKE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOiIwUIKyzvlFcI40RArmOAKCKTx7V/MW2KxzLrzqmRYUyy2bAOACgz9Q7
QgxuLE9hrS1k4uidtTeP0kM=
=UQvy
-----END PGP SIGNATURE-----

--PpocKf6TCvdC9BKE--
