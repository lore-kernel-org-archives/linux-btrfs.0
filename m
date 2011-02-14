From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: Copied Files from Btrfs partition larger than original
Date: Mon, 14 Feb 2011 09:46:16 +0000
Message-ID: <20110214094616.GC5484@carfax.org.uk>
References: <8534C054-C9D6-470F-BB5A-45493462A17C@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kfjH4zxOES6UT95V"
Cc: linux-btrfs@vger.kernel.org
To: MOB <digital.corpus@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <8534C054-C9D6-470F-BB5A-45493462A17C@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--kfjH4zxOES6UT95V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 14, 2011 at 12:41:46AM -0800, MOB wrote:
> So as I'm doing some maintenance on my personal video server, I'm noticing that when I'm copying files off of my btrfs partitions, they are getting larger...
> 
> First partition is the original:
> http://pastebin.com/GM5xWetR
> 
> I have 3 affected partitions, This appears to have started with 2.6.37 but could have started happening before. I have ~3300 video files where ~840 are on btrfs partitions that randomly get shuffled on/off for free space distribution

   Pastebins aren't forever. For the archives:

------ (begin)
ls -lah /mnt/store-p00/1280x720/~NCIS\ Los\ Angeles~2010-05-11~720.mov
-rw-rw-r-- 1 root hdhr 1.7G Nov  6 18:39 /mnt/store-p00/1280x720/~NCIS Los Angeles~2010-05-11~720.mov


ls -lah /hdhr/demux/1280x720/"~NCIS Los Angeles~2010-05-11~720.mov"
-rw-rw-r-- 1 root hdhr 3.7G Nov  6 18:39 /hdhr/demux/1280x720/~NCIS Los Angeles~2010-05-11~720.mov
------ (end)

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- Attempted murder, now honestly, what is that?  Do they give a ---  
                  Nobel Prize for attempted chemistry?                   

--kfjH4zxOES6UT95V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNWPnoIKyzvlFcI40RAi7pAJ9Xe9KJ9C6e3GNRbo9ev0q6D9JEygCdGNUG
QLothXkyeM/r37fUe+Ow/EY=
=TAno
-----END PGP SIGNATURE-----

--kfjH4zxOES6UT95V--
