From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: Space used by snapshot
Date: Thu, 17 Feb 2011 11:16:02 +0000
Message-ID: <20110217111602.GF5484@carfax.org.uk>
References: <AANLkTi=LE2poDR5sNyPJF6rQ_TpLv5pjgHRQXG0Wpt-i@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WlEyl6ow+jlIgNUh"
Cc: linux-btrfs@vger.kernel.org
To: Roman Kapusta <roman.kapusta@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=LE2poDR5sNyPJF6rQ_TpLv5pjgHRQXG0Wpt-i@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--WlEyl6ow+jlIgNUh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 17, 2011 at 12:13:53PM +0100, Roman Kapusta wrote:
> Hello all,
> 
> Is there any way how to obtain information how much space is
> physically allocated by given subvolume?
> I cannot find any. I'm interested in two values:
> 
> - physical space allocated by SUBVOLUME INCLUDING all space shared by
> other subvolumes
> 
> - physical space allocated by SUBVOLUME EXCLUDING all space shared by
> other subvolumes
> 
> Currently I can use only du, which is not reporting what I want to know.

   Not at the moment. It shouldn't be too difficult to implement
(certainly to implement the latter), but it's just not been done yet.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- What do you give the man who has everything? -- Penicillin is ---  
                             a good start...                             

--WlEyl6ow+jlIgNUh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNXQNyIKyzvlFcI40RAvYnAJ4keU/+l7sWKIaO0c1upAT5+T9TxgCfRSSw
aBPtUKueIOxC99vjheFerwM=
=YSHc
-----END PGP SIGNATURE-----

--WlEyl6ow+jlIgNUh--
