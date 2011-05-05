From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Converting 1-drive ext4 to 4-drive raid10 btrfs
Date: Thu, 5 May 2011 23:04:33 +0100
Message-ID: <20110505220433.GA7220@carfax.org.uk>
References: <N1-PULWkPAV2U@Safe-mail.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
Cc: linux-btrfs@vger.kernel.org
To: Paul Schroeder <prq@Safe-mail.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <N1-PULWkPAV2U@Safe-mail.net>
List-ID: <linux-btrfs.vger.kernel.org>


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 05, 2011 at 05:01:04PM -0400, Paul Schroeder wrote:
> I have a 1 TB ext4 drive that's quite full (~50 GB free space, though I
> could free up another 100 GB or so if necessary) and two empty 0.5 TB
> drives.
> 
> Is it possible to get another 1 TB drive and combine the four drives to
> a btrfs raid10 setup without (if all goes well) losing my data?

   Not at the moment. You'd have to be able to change RAID levels for
your FS configuration, which isn't implemented yet.

   It's planned, but nobody's got round to it yet. (I'll probably
start looking at it as my next btrfs patch, if nobody else gets there
first).

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- "Your problem is that you have a negative personality." ---     
                             "No,  I don't!"                             

--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNwx7wIKyzvlFcI40RAt6iAJwNMCzhZ+cIAkZkas0qwaafxmGSRQCcDqDZ
GHmEB0GnnZ7oI0Wr8WUuha4=
=OJpf
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--
