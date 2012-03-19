From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: "not enough space" with "data raid0"
Date: Mon, 19 Mar 2012 17:58:50 +0000
Message-ID: <20120319175850.GO3172@carfax.org.uk>
References: <C52pxfli1uB@helmut.hullen.de>
 <loom.20120317T131420-684@post.gmane.org>
 <20120317122522.GD3172@carfax.org.uk>
 <loom.20120317T141129-14@post.gmane.org>
 <20120317140057.GF3172@carfax.org.uk>
 <loom.20120319T160836-470@post.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3snK74p7ddXn3Qrx"
Cc: linux-btrfs@vger.kernel.org
To: Alex <alex@bpmit.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20120319T160836-470@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>


--3snK74p7ddXn3Qrx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 19, 2012 at 03:14:19PM +0000, Alex wrote:
> 
> >    I'm working on a comprehensive explanation of the limits on btrfs's
> > space usage, and a little JavaScript tool to help plan/explain disk
> > usage.
> 
> Thank you Hugo.
> 
> Given the kernel 3.3 release yesterday [1] we've gained the ability to restripe
> to different raid levels after the fact. So I guess I don't have too much to
> worry about with decent backups.

   Yes, you do. RAID is not a backup: What happens if you accidentally
write zeroes over all your superblocks? Or rm -rf /home? RAID will not
help you here.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- In the future, terrorists won't be carrying their ID cards. ---   
                   They'll be carrying yours. -- Henry                   
                         Porter,  Suspect Nation                         

--3snK74p7ddXn3Qrx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPZ3PaIKyzvlFcI40RAr6rAKCkzZ5LVCa3GFzzu1TdTlF4hKiI3wCeMrES
GEV1cFz5EM6DV304HloSXZc=
=NLwX
-----END PGP SIGNATURE-----

--3snK74p7ddXn3Qrx--
