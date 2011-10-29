From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Find RAID level, Change RAID level.
Date: Sat, 29 Oct 2011 15:13:03 +0100
Message-ID: <20111029141303.GN29548@carfax.org.uk>
References: <CACCfv7q4HkRDnCa3bXEj+fAJA1kikLQ+3G46VH-2unPgT=1DFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yaap9KN+GmBP785v"
Cc: linux-btrfs@vger.kernel.org
To: Jordan Windsor <jordanw2@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CACCfv7q4HkRDnCa3bXEj+fAJA1kikLQ+3G46VH-2unPgT=1DFA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--yaap9KN+GmBP785v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Oct 30, 2011 at 12:28:39AM +1030, Jordan Windsor wrote:
> Hello,
> I was wondering is it possible to find the RAID level currently in use
> by a btrfs volume, also can I change the data & metadata (or either)
> RAID levels after creation.

   To see the RAID levels, use

btrfs fi df /path/to/filesystem

   To change RAID levels, you will need Ilya Dryomov's restriper
patches, which were posted to this list back in August.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
             --- Ceci est un travail pour l'Australien. ---              

--yaap9KN+GmBP785v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOrAnuIKyzvlFcI40RAm4QAJ4tX4SNJ8jKwWK8Q0zs7vtFM4KwEACdFb7r
5R6atSVxOoKx3U5Ce7eqVxI=
=myFG
-----END PGP SIGNATURE-----

--yaap9KN+GmBP785v--
