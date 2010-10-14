From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Metadata size
Date: Thu, 14 Oct 2010 12:20:58 +0100
Message-ID: <20101014112058.GA2315@selene>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   I'm a little concerned about the size of my metadata. I'm doing
raid10 on both data and metadata, and:

hrm@vlad:mnt $ sudo btrfs fi df /mnt
Data: total=488.01GB, used=487.23GB
Metadata: total=3.01GB, used=677.73MB
System: total=11.88MB, used=52.00KB

hrm@vlad:mnt $ find /mnt | wc -l
20137

   By my calculations, that's something on the order of 17.5K per
filesystem object. This is mostly media files, plus some small
metadata files. 17.5K on average seems very large to me. I have quite
a bit of space on this system, so I'm not too concerned, but I wasn't
sure if this kind of figure was representative or not.

   Overall file count by size:

0-10        21
10-100     153
100-1K     778
1K-10K     279
10K-100K    96
100K-1M    238
1M-10M   12556
10M-100M  3452
100M-1G    332
1G-10G     171

0-1K	   952
1K-1M      613
1M-1G    16340
1G+        171

   Interestingly, the metadata value was closer to 15K/object until my
last batch of writing, which was the 171 1G+ files (and a few in the
100M-1G range), plus an equal number of small (<2K) files.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Trouble rather the tiger in his lair than the sage amongst ---    
        his books for to you kingdoms and their armies are mighty        
        and enduring,  but to him they are but toys of the moment        
              to be overturned by the flicking of a finger.              

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFMtueaIKyzvlFcI40RAqjlAKCfs8AD5Lpg+nhB6NtvHJYgjP7d/ACfRPHR
lrn6IGTsSCYvqNu2Qs2bM3k=
=QfiF
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
