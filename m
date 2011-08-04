From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: INSTALL hint: create device btrfs-control
Date: Thu, 4 Aug 2011 18:35:48 +0100
Message-ID: <20110804173548.GA8970@carfax.org.uk>
References: <BrDeAL0D1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BrDeAL0D1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 04, 2011 at 12:10:00PM +0200, Helmut Hullen wrote:
> Hallo,
> 
> you should please add a hint in
> 
>    .../git/mason/btrfs-progs-unstable.git
> 
> in the file "INSTALL" with at least the contents (please excuse my  
> gerlish)
> 
> "btrfs" needs the device "btrfs-control". Perhaps you have to create it:
> 
>         mknod /dev/btrfs-control c 10 234

   This should probably go in the problems FAQ [1] on the wiki
instead, since (a) it's really a problem with your distribution, and
(b) probably quite rare now that the majority of people are running
distributions with udev.

   What are the symptoms of not having the device node? (i.e. how
would I diagnose this particular problem?)

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
          --- What part of "gestalt" don't you understand? ---           

--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOOthzIKyzvlFcI40RAu7RAJ9ZmFgq+0LIq5XBv2nbuKwKKaVmHACgoq5b
uNQBUbi5n8TUqKRS45iSS+w=
=JbtO
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
