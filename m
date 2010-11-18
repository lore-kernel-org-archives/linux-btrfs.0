From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: SI units
Date: Thu, 18 Nov 2010 14:00:37 +0000
Message-ID: <20101118140037.GB27661@vlad.carfax.org.uk>
References: <20101118132658.GA27661@vlad.carfax.org.uk>
 <Ba6eWBnD1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uZ3hkaAS1mZxFaxD"
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Ba6eWBnD1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>


--uZ3hkaAS1mZxFaxD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 18, 2010 at 02:53:00PM +0100, Helmut Hullen wrote:
> Du meintest am 18.11.10:
> 
> >> when I invoke
> >>
> >>         btrfs filesystem show
> >>
> >> then it shows the size of my Terabyte disks in TiByte but tells
> >> "TB". It's a difference of about 10% - either there should be a
> >> switch like in "df" (option -H or --si), or "TB" should be changed
> >> to "TiB" (the same with GiB, MiB etc.)
> 
> >    I posted patches[1] to do just that, a few weeks ago.
> 
> I've just compiled btrfs from git (20101117) - at least this patch isn't  
> included.
> 
>   git clone git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git
> 
> as recommended in
> 
>   https://btrfs.wiki.kernel.org/index.php/Btrfs_source_repositories
> 
> Do I use an antique version?

   No, that's the latest version, as far as I know. The patches
haven't been picked up and integrated by Chris yet. (In fact, I should
probably send them again).

   In the meantime, I'm afraid you'll have to apply the patches
manually.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- Questions are a burden, and answers a prison for oneself. ---    

--uZ3hkaAS1mZxFaxD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFM5TGEIKyzvlFcI40RAvaOAKDOdN2bSaguXiWE+1lUzlZETOUESwCfSQZC
+EbAjKYFxw8vXxfGsnZqgp8=
=D5do
-----END PGP SIGNATURE-----

--uZ3hkaAS1mZxFaxD--
