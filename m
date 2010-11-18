From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: SI units
Date: Thu, 18 Nov 2010 13:26:58 +0000
Message-ID: <20101118132658.GA27661@vlad.carfax.org.uk>
References: <Ba6eIYZT1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Ba6eIYZT1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 18, 2010 at 02:13:00PM +0100, Helmut Hullen wrote:
> when I invoke
> 
>         btrfs filesystem show
> 
> then it shows the size of my Terabyte disks in TiByte but tells "TB".  
> It's a difference of about 10% - either there should be a switch like in  
> "df" (option -H or --si), or "TB" should be changed to "TiB" (the same  
> with GiB, MiB etc.)

   I posted patches[1] to do just that, a few weeks ago.

   Hugo.

[1] http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg06517.html

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- "I am the author. You are the audience. I outrank you!" ---     

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFM5SmiIKyzvlFcI40RAk0yAKCzsw8g9HJhoKpYWjleoJddaY4zEgCeNrNb
OqRrc4RD941HzLd5kunc/KI=
=5KFT
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
