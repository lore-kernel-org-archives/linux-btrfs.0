From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: Entirely unexpected ENOSPC?
Date: Mon, 9 Mar 2009 13:20:52 +0000
Message-ID: <20090309132052.GA6698@vlad.carfax.org.uk>
References: <2c259a8f0903072332n31d9d20dscad1801b4b468520@mail.gmail.com> <3a7f57190903080035lf10104fq87eca697cc4dfb43@mail.gmail.com> <2c259a8f0903090608r36c50773qaa0bc1606beb5065@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Cc: Dmitri Nikulin <dnikulin@gmail.com>, linux-btrfs@vger.kernel.org
To: Yien Zheng <esprout@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <2c259a8f0903090608r36c50773qaa0bc1606beb5065@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 09, 2009 at 07:08:16AM -0600, Yien Zheng wrote:
> At this point I'm wondering if this is a anomaly or if it has anything
> to do with using an SSD.  It seems the pre-2.7.29-rc7 code had a hard
> stop at 85%.  But the recent patch doesn't seem to have solve the
> issue for me.  Is there another issue that makes btrfs want to reserve
> 2G free?  I see another email with someone growing their filesystem
> from 48G to 70G because they ran out of space on their 50G disk, which
> should still have 2G free.

   Not quite -- I was some 5G free on a 50G filesystem, without
errors. I expanded the filesystem online to 70G because I knew I would
run out within the next few hours. Despite the expansion, it still ran
out at (just short of) 50G.

   Unless you've resized your filesystem online, I think we're seeing
different problems.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Do not meddle in the affairs of system administrators,  for ---   
                  they are subtle,  and quick to anger.                  

--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQFJtRe0IKyzvlFcI40RAqnKAKCfGgGpe+z6RdIighV/w5jRqyJzKwCfZxlq
OnvH9PCz1Q/rv57fkhYI4Hc=
=EtXE
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
