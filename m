From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: bug: missing snapshot as in the btrfs subvolume list command
Date: Tue, 5 Jul 2011 11:18:46 +0100
Message-ID: <20110705101846.GB5481@carfax.org.uk>
References: <4E12E322.3050404@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f2QGlHpHGjS2mn6Y"
Cc: linux-btrfs@vger.kernel.org
To: Anand Jain <Anand.Jain@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E12E322.3050404@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>


--f2QGlHpHGjS2mn6Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 05, 2011 at 06:10:42PM +0800, Anand Jain wrote:
> A confirmation if the following bug is being taken care will help.
> 
> Have 9 sub-vols `btrfs subvolume list /btrfs`
> ---------------------------------------------
> # btrfs subvolume list /btrfs
> ID 256 top level 5 path sv1
> ID 257 top level 5 path snapy23988
> ID 258 top level 5 path snapi24000
> ID 259 top level 5 path snapC24009
> ID 260 top level 5 path snapo24018
> ID 261 top level 5 path snapm24027
> ID 262 top level 5 path snapx24036
> ID 263 top level 5 path snape24045
> ID 264 top level 5 path snapt24054
> # btrfs subvolume list /btrfs | wc -l
> 9
> ----------------------------------------
> 
> and create 10th subvol
> -------
> # S=`mktemp -u /btrfs/snapXXXXXX`; btrfs subvolume snapshot
> /btrfs/snapt24054 $S
> Create a snapshot of '/btrfs/snapt24054' in '/btrfs/snapm24071'
> ------
> 
> now list fails to report ID 261 (note that last snapshot was
> successfully created)
> ----------------
> # btrfs subvolume list /btrfs
> ID 256 top level 5 path sv1
> ID 257 top level 5 path snapy23988
> ID 258 top level 5 path snapi24000
> ID 259 top level 5 path snapC24009
> ID 260 top level 5 path snapo24018
> ID 262 top level 5 path snapx24036
> ID 263 top level 5 path snape24045
> ID 264 top level 5 path snapt24054
> ID 265 top level 5 path snapm24071
> # btrfs subvolume list /btrfs | wc -l
> 9
> #
> ------------------------------

   Could you try this with the integration branch of the btrfs tools,
available from:

http://git.darksatanic.net/repo/btrfs-progs-unstable.git/

in the "integration-20110703" branch. There's a patch in there that
should deal with this particular problem (if it's what I think it is,
which it probably is).

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- Once is happenstance; twice is coincidence; three times ---     
                            is enemy action.                             

--f2QGlHpHGjS2mn6Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOEuUGIKyzvlFcI40RAqOBAJ4nBe/egasX8MPZoxA2GKzGa8AFyQCeKpQY
7tBo8yi76cjjulgRkVNE8tI=
=Rgtu
-----END PGP SIGNATURE-----

--f2QGlHpHGjS2mn6Y--
