From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: subvolumes missing from "btrfs subvolume list" output
Date: Wed, 29 Jun 2011 17:50:20 +0100
Message-ID: <20110629165020.GB11170@carfax.org.uk>
References: <chaz20110629143747.GA28702@seebyte.com>
 <chaz20110629150041.GB28702@seebyte.com>
 <4E0B4FC6.4030006@redhat.com>
 <20110629164741.GA11170@carfax.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eJnRUKwClWJh1Khz"
To: Josef Bacik <josef@redhat.com>,
	Stephane Chazelas <stephane.chazelas@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110629164741.GA11170@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>


--eJnRUKwClWJh1Khz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 29, 2011 at 05:47:41PM +0100, Hugo Mills wrote:
> (*) The limited cases where both behaviours return the same set of
> keys are:
> 
> (i_0, 0, 0) to (i_1, -1UL, -1UL)
I clearly meant  (i_1,  255, -1UL) here...

> (i, t_0, 0) to (i, t_1, -1UL)
> (i, t, o_0) to (i, t, o_1)

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- I get nervous when I see words like 'mayhaps' in a novel, ---    
                because I fear that just round the corner                
                          is lurking 'forsooth'                          

--eJnRUKwClWJh1Khz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOC1fMIKyzvlFcI40RAtFdAJ4mElwheDIUEWpbgEP39RuKU8QsYACcDl7W
O+G1gW/eV1QAbO+AZedF3yI=
=8+Wd
-----END PGP SIGNATURE-----

--eJnRUKwClWJh1Khz--
