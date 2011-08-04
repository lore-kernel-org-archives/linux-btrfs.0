From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: INSTALL hint: create device btrfs-control
Date: Thu, 4 Aug 2011 22:49:50 +0100
Message-ID: <20110804214950.GC8970@carfax.org.uk>
References: <20110804204219.GB8970@carfax.org.uk>
 <BrDfft7D1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i7F3eY7HS/tUJxUd"
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BrDfft7D1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>


--i7F3eY7HS/tUJxUd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   Hi, Helmut,

On Thu, Aug 04, 2011 at 11:26:00PM +0200, Helmut Hullen wrote:
> Du meintest am 04.08.11:
> >> I'll try to reproduce these messages ...
> 
> >    Thanks. We can add those as symptoms to the solution later.
> 
> I've just run the first test - finding reliable (for only this case)  
> messages is a bad job ...

   Well, it's probably OK just to use this particular symptom for
now. You've generally got to run btrfs dev scan before you run
anything else, so that message should turn up. I wouldn't spend ages
hunting down additional failure messages.

> >    How's this?
> 
> > https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#I_get_the_message
> > _.22failed_to_open_.2Fdev.2Fbtrfs-control_skipping_device_registratio
> > n.22_from_.22btrfs_dev_scan.22
> 
> There's some problem in the Wiki. This new paragraph (?) is not shown  
> when I call the "Problem_FAQ", it ends with the "Copy-on-write doesn't  
> work" question.
> 
> When I look into the source code of that page I can see and read the  
> paragraph, and it looks fine!

   Yes, I think there is a problem with it at the moment. The usual
one that happens every so often. I don't know what's up, but it seems
to be something to do with the MySQL back-end.

   At least the text looks good to you, so we'll leave it at that for
now, and it should be better the next time the kernel.org admins sort
it out.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- "What's so bad about being drunk?" "You ask a glass of water" ---  
                                                                         

--i7F3eY7HS/tUJxUd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOOxP+IKyzvlFcI40RApVvAJ94nYY/8j2wlNu0j9hGojhXpfNfdQCfUH21
8uLqa3+IET+2I/ieD9zq1kQ=
=8tbC
-----END PGP SIGNATURE-----

--i7F3eY7HS/tUJxUd--
