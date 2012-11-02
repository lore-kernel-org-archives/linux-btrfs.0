Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:39249 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab2KBP7p (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Nov 2012 11:59:45 -0400
Date: Fri, 2 Nov 2012 15:59:41 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Kyle Gates <kylegates@hotmail.com>
Cc: Kenneth Johansson <kenneth@southpole.se>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: no space left on device.
Message-ID: <20121102155941.GB28864@carfax.org.uk>
References: <50927A9E.70106@southpole.se>
 <COL002-W179CC749A18F35284E4D01B0670@phx.gbl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="A6N2fC+uXW/VQSAv"
In-Reply-To: <COL002-W179CC749A18F35284E4D01B0670@phx.gbl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--A6N2fC+uXW/VQSAv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 02, 2012 at 10:54:47AM -0500, Kyle Gates wrote:
> > So I have ended up in a state where I can't delete files with rm.
> >
> > the error I get is no space on device. however I'm not even close to empty.
> > /dev/sdb1 38G 27G 9.5G 75%
> > there is about 800k files/dirs in this filesystem
> >
> > extra strange is that I can in another directory create and delete files.
> >
> > So I tried pretty much all I could google my way to but problem
> > persisted. So I decided to do a backup and a format. But when the backup
> > was done I tried one more time and now it was possible to delete the
> > directory and all content?
> >
> > using the 3.5 kernel in ubuntu 12.10. Is this a known issue ? is it
> > fixed in later kernels?
> >
> > fsck /btrfs scrub and kernel log. nothing indicate any problem of any kind.
> >
> 
> First let's see the output of:
> btrfs fi df /mountpoint
> 
> You're probably way over allocated in metadata so a balance should help:
> btrfs bal start -m /mountpoint
> or omit the -m option to run a full balance.

   Or, better, -musage=5 (or 1), which will do even less work.

... but let's see the btrfs fi df output first. Could you also add the
output of "btrfs fi show" (no parameters), please?

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
            --- You're never alone with a rubber duck... ---             

--A6N2fC+uXW/VQSAv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUJPt7b9z9OVl50rAAQIhaxAAg8C0h2+Eim+PdflHUwdWsyuhVJBJBl6N
XYPdiQXP6h8kykOO+oOyyU5MXoJDpBImEn3GFJ+DXVD4UsAmFAkRNGjU1yP6JmH2
YC+T2Kd0MKcEBjg4BlJekrc5GI3vUkyNzXJ2nRnohkg7UiCQ0KoDmWBxqcTpC/iY
f3EZQa0gKfbz2hRcueh+zCgl9TjW2oAB+ZhZaOydAoE+wB76gVaLQq9m76r3iVTo
pSaM4XWWaL9kHOgfxL4yrBLJyVArD+ZcLf9hsXe61/jRbLaze9MRJBshWtQJrjzR
wlJBRoZtPGfEyFRetqqyhFmKq+eaox9PrCrnrzbGVrDGG+Tgdum8WRz2KJ4cM146
AfPLka4fKPdjTaDYqeMcMM8fZMmRb8fWDJKAdf7QNJftk4ro0HRQ23LDPzfi91sa
b8dMJoJxKAcEPEQG9FgpdrGlYlPg5jioNjKu6cYUa3mErTlWYcMDZNXiL2O7PWhd
4MaMNG564BX5axgJyMPrRvawOzFDN9kbTq9fKHFQpa834C6WZlxfwJ9OSmYqiNPz
MGrZ2jB92Eyn1e0JbiMtFWoMXm2tTNnlQqIgfEXcW2lqGAUumztk6HUvhDFfec/p
UTe6baHd7AYZvN5LgyfJySAm8HdF6ejK+nY1iV5qA153M286nI+B2rTY1pH1muuG
k9VEgupWhVc=
=zqCH
-----END PGP SIGNATURE-----

--A6N2fC+uXW/VQSAv--
