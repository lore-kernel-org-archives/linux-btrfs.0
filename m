From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: 800 GByte free, but "no space left"
Date: Mon, 6 Dec 2010 15:18:04 +0000
Message-ID: <20101206151804.GE4273@carfax.org.uk>
References: <20101206132817.GD4273@carfax.org.uk>
 <BbNRoIAi1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9crTWz/Z+Zyzu20v"
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BbNRoIAi1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>


--9crTWz/Z+Zyzu20v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   Helmut - 

On Mon, Dec 06, 2010 at 03:45:00PM +0100, Helmut Hullen wrote:
> If/when I install 2.6.37-rc4: should I update btrfs (from the 20101117  
> version)?

   I think that's the latest version.

> How can I see that changing the kernel makes things better? It's more  
> and more difficult to externalize (?) btrfs directories to other disks  
> ...

   Updating the kernel won't fix the problem I'm thinking of (sorry).
It will, however, fix the bug that stops the btrfs tool from reporting
what RAID levels you've got.

   The problem I suspect you may have (because your symptoms seem to
be the same as mine) is that there are some circumstances where the
filesystem can change RAID levels pretty much arbitrarily. Running
"btrfs fi df" with a kernel that reports RAID levels will show whether
that's the case, as you'll have more than one RAID level listed.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- But people have always eaten people,  / what else is there to ---  
         eat?  / If the Juju had meant us not to eat people / he         
                     wouldn't have made us of meat.                      

--9crTWz/Z+Zyzu20v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFM/P6sIKyzvlFcI40RAmh7AKCyvU4q17gh+ebyNjUZKZW8C75UXwCfST5G
E0BwCb+9AdgoIZr1WUMgEbo=
=2MCl
-----END PGP SIGNATURE-----

--9crTWz/Z+Zyzu20v--
