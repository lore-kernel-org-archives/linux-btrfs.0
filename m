From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: subvolume
Date: Sat, 3 Dec 2011 00:21:57 +0000
Message-ID: <20111203002157.GA6868@carfax.org.uk>
References: <S1752378Ab1LBXvj/20111202235139Z+254@vger.kernel.org>
 <24F36A1E-C86B-4E51-840C-E83F55F0F226@fragstein.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Cc: linux-btrfs@vger.kernel.org
To: Thomas Fragstein <thomas@fragstein.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <24F36A1E-C86B-4E51-840C-E83F55F0F226@fragstein.de>
List-ID: <linux-btrfs.vger.kernel.org>


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Dec 03, 2011 at 01:07:23AM +0100, Thomas Fragstein wrote:
> please can you help me.
> 
> i read that btrfs can create subvolumes.
> that is a great feature but can i limit the filesystem space that the subvolume can be used?

   Look in the mailing list archives for the qgroups patch, which does
exactly that.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- "What's so bad about being drunk?" "You ask a glass of water" ---  
                                                                         

--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFO2WulIKyzvlFcI40RAhW0AJ4nDHu9gtZvHV5tEmuWNP0TxF/NdwCfWhYb
GHs61efg60dnjo89+yZ7lC8=
=R+AY
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--
