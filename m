From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: btrfs problems and fedora 14
Date: Mon, 22 Nov 2010 23:28:05 +0000
Message-ID: <20101122232805.GA22542@carfax.org.uk>
References: <1290467983.24502.66.camel@main-wireless>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Cc: linux-btrfs@vger.kernel.org
To: david grant <dg@david-grant.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1290467983.24502.66.camel@main-wireless>
List-ID: <linux-btrfs.vger.kernel.org>


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   Hi,

On Tue, Nov 23, 2010 at 10:19:43AM +1100, david grant wrote:
> I thought I would try btrfs on a new installation of f14. yes, I know
> its experimental but stable so it seemed to be a good time to try it.
> I am not sure if I have missed something out of all my searching but am
> I correct in thinking that currently: 
>      I. it is not possible to boot from a snapshot of the operating
>         system and, in particular, the yum snapshots cannot be used for
>         that purpose 

   You can use btrfs subvolume set-default to set the default
subvolume that is mounted if no "subvol=" or "subvolid=" parameter is
given to mount. (And you can then subsequently access the original
root of the filesystem using mount -o subvolid=0).

>     II. it is so easy to create raid arrays of btrfs partitions but they
>         cannot be read by f13 or f14 

   There's no particular reason that this should be the case. How do
you come to this conclusion? What did you try, what did you expect to
happen, and what actually happened?

>    III. it is not possible to copy btrfs partitions with snapshots
>         except possibly by the use of dd.

   Again, I can't see a reason that this shouldn't work. What are you
trying to do, exactly, and how is it failing?

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
           --- I believe that it's closely correlated with ---           
                       the aeroswine coefficient.                        

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFM6vyFIKyzvlFcI40RAgwzAJ4+FnCtSktCFw5sa+2zkrKHs4oMKACeMLGX
jBSYdvNx8eZfqXwaZSAXX+w=
=2hPD
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
