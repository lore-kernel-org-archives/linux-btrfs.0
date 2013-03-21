Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:55392 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581Ab3CUVny (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Mar 2013 17:43:54 -0400
Date: Thu, 21 Mar 2013 21:43:53 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Joseph Moore <japlha@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Problems with compiling btrfs
Message-ID: <20130321214353.GK19395@carfax.org.uk>
References: <CAGR7nwePCTCF0nz7rNqqS9x=UqLugtPL2wp7rA1SgU81R0mDcA@mail.gmail.com>
 <20130321214213.GJ19395@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Tu8ztk+XgTAiG9Id"
In-Reply-To: <20130321214213.GJ19395@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Tu8ztk+XgTAiG9Id
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 21, 2013 at 09:42:13PM +0000, Hugo Mills wrote:
> On Thu, Mar 21, 2013 at 03:11:56PM -0600, Joseph Moore wrote:
> > I'm trying to compile the btrfs source code but I'm getting an error.
> > Any suggestions?
[snip]
>    You need libblkid-devel (or whatever your distribution calls the
> development package for libblkid). You may also want to check out the
> list of required build packages on the wiki at [1], just in case
> you're missing any others.

   ... or what Eric said. Believe him for this bit.

>    Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- Unix: For controlling fungal diseases in crops. ---         

--Tu8ztk+XgTAiG9Id
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUUt/GL9z9OVl50rAAQIqIA//S22AmCmvDXBDtI79aLU0KJLHYJDAzW1T
Z834btCe0R4ZcMC2TPbCRk6t+TpHGs2reaLeTZki739Cfp1XlWVEcppGLvFeATEU
qj88CYOWi78fLYc+j0F0uZbqVyeI3LtQCD/OewN+u6k9rG4c6dOZ3P+tNtsSgs7j
7daslxriIuMySfwRtiY8Fpm0BRbbFqylkckHiMAbNMTISjYDzC92zd6mljSJG4rR
C4+LlJfgIWC7T5Ka2NkRo0SUDZtIJRBWcQ5iDbf/4Vmew+Xcx4YEFTLLZ4Ucs76C
F3BHz8HHcSEj1puTCU8bzLE8fidrB5s4a5JP6nRi8nahlM/XxpCVnZeRuVKnkvQB
On+GUmMk6Jxy/n3U+dgeNIxnASMHyzOf8jhD7jgbnW2yqxGXxd0NqhG3mIY/0gcw
7ERxeEbJj3s06R4UkekqUHsXR/rH07Ws4oqbz5XXOlY6TlxIAqxNNlsLSPEVe4qM
30mtrYT4mCKU0hA6cNzGaBxHpu23gBjieoNU/SCxImRjtzwYP0UtCU1r16fsUlS1
jt8BQDSVhnk9Y6FHaPlDpUccUXq13F3jKJI0m5p/AlxvctMBFBqdg/Jdv+OWqT6i
sbAGh+m7M3k9tAOCOCXCfnMgTseCcNhR8DkVRA2r+Wj4lKAgu4vJ+Gbx91TX8TB5
wcBJ/4AwioA=
=L+l3
-----END PGP SIGNATURE-----

--Tu8ztk+XgTAiG9Id--
