From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: Encryption
Date: Thu, 20 Jan 2011 15:14:54 +0000
Message-ID: <20110120151454.GB4178@carfax.org.uk>
References: <201101200705.52547.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H+4ONPRPur6+Ovig"
Cc: linux-btrfs@vger.kernel.org
To: Carl Cook <CACook@quantum-sci.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101200705.52547.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>


--H+4ONPRPur6+Ovig
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 20, 2011 at 07:05:52AM -0800, Carl Cook wrote:
> 
> Does BTRFS have subvolume encryption built in?  If not, why?

   Not at the moment.

   My opinion on why: Getting crypto right is *hard*. There are far
easier features that people are asking for that we can implement
first.

   There may be technical issues that make it hard to implement within
btrfs, although being able to do compression is harder from a FS
structure point of view, so I suspect that the issues are more about
ensuring correctness of the crypto implementation (not just the basic
symmetric algorithm, because we've got those in the kernel, but all
the key management and block chaining and probably a bunch of things I
don't know about because I'm not a cryptographer -- all of which makes
a big difference to the security of the final system).

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- Once is happenstance; twice is coincidence; three times ---     
                            is enemy action.                             

--H+4ONPRPur6+Ovig
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNOFFuIKyzvlFcI40RAs7qAKC6FQcGwqKdt/+gwmf2aNjjBr+DvACgv085
ZU4v8wQK2EJPRThtbdhYQNs=
=19sH
-----END PGP SIGNATURE-----

--H+4ONPRPur6+Ovig--
