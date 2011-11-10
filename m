From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Stupid newb tricks: making a subvolume of root.
Date: Thu, 10 Nov 2011 14:59:44 +0000
Message-ID: <20111110145944.GK28749@carfax.org.uk>
References: <6c5dc86169d45cbc1001d0daa2d51a08@www.jots.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="73fGQZLCrFzENemP"
Cc: linux-btrfs@vger.kernel.org
To: Ken D'Ambrosio <ken@jots.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <6c5dc86169d45cbc1001d0daa2d51a08@www.jots.org>
List-ID: <linux-btrfs.vger.kernel.org>


--73fGQZLCrFzENemP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 10, 2011 at 09:50:00AM -0500, Ken D'Ambrosio wrote:
> Hey, all.  I did a "convert" on my ext-3 system, and now I've got a monolithic
> btrfs volume.  I'd like to break / and /home into subvolumes.  /home is easy (I
> think): I just create a subvolume, and move stuff into it, and mount it.  Done.
>  But how do I do that for root?  (Don't worry about the actual mounting, grub,
> etc.,; I have a different system that works the way I want it to.)

   The top level of the filesystem is itself a subvolume, so you could
just leave it like that.

   Alternatively, if you want the top level to be simply a container
for subvolumes (and to use a default subvolume to mount / ), then you
could do the switch-over by making a snapshot of your current /,
remounting with the snapshot as / (possibly using "btrfs sub
set-default"), and then mounting subvolid=0 on /media/btrfs-management
to delete the old contents of /

   (I hope that made sense)

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- "He's a nutcase, you know. There's no getting away from it -- ---  
                     he'll end up with a knighthood"                     

--73fGQZLCrFzENemP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOu+bfIKyzvlFcI40RAnOWAJ9xQ6o2kiD9hn56lLznD20QxXxU3ACgmMER
Wc6Va0WiG8VGkwClkbZ0BwM=
=vNUn
-----END PGP SIGNATURE-----

--73fGQZLCrFzENemP--
