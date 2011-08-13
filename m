From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: btrfs-progs integration branch updated
Date: Sat, 13 Aug 2011 14:18:06 +0100
Message-ID: <20110813131806.GA6650@carfax.org.uk>
References: <20110804224334.GD8970@carfax.org.uk>
 <loom.20110805T224533-845@post.gmane.org>
 <loom.20110805T225541-260@post.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Cc: linux-btrfs@vger.kernel.org
To: Jan Schubert <Jan.Schubert@GMX.li>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20110805T225541-260@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 05, 2011 at 08:57:01PM +0000, Jan Schubert wrote:
> Jan Schubert <Jan.Schubert <at> GMX.li> writes:
> 
> > Thx Hugo, I hit this error while trying to compile:
> 
> Oh, and kernel is official 3.0, seems there is an "incompatible" ctree.h 
> included...
> 
> Everything else compiles fine.

   Looks like that file hasn't actually compiled properly since at
least the 4th January 2008, which was the last time that the macro
definitions in ctree.h got touched. It might be easiest simply to drop
dir-test.c, if nobody's bothered compiling it in over 3 years...

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- "What's so bad about being drunk?" "You ask a glass of water" ---  
                                                                         

--huq684BweRXVnRxX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFORnmNIKyzvlFcI40RAmPzAJ0TA0flTLPGF7B7dQ6f4PCVv3kO2wCdFds7
loEU+jMKeT4reLCpcPrkm94=
=3LaB
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
