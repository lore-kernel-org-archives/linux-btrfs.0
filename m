From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Subvolume level allocation policy
Date: Sun, 23 Oct 2011 19:52:38 +0100
Message-ID: <20111023185238.GC29548@carfax.org.uk>
References: <4EA4620A.3060702@cfl.rr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O3RTKUHj+75w1tg5"
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Phillip Susi <psusi@cfl.rr.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EA4620A.3060702@cfl.rr.com>
List-ID: <linux-btrfs.vger.kernel.org>


--O3RTKUHj+75w1tg5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Oct 23, 2011 at 02:50:50PM -0400, Phillip Susi wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Is it ( yet? ) possible to manipulate the allocation policy on a
> subvolume level instead of the fs level?  For example, to make / use
> raid1, and /home use raid0?  Or to have / allocated from an ssd and
> /home allocated from the giant 2tb hd.

   Not yet, sorry. It's planned, but nobody's got around to
implementing it.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- I'm on a 30-day diet. So far I've lost 18 days. ---         

--O3RTKUHj+75w1tg5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOpGJ2IKyzvlFcI40RAuKYAKCOPfsrEPQrTQ4mvQKKUAnd2+3bcwCePX+8
PrzR3iW8GX+CwPKyw0dXDLw=
=5qj1
-----END PGP SIGNATURE-----

--O3RTKUHj+75w1tg5--
