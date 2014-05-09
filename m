Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:40881 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756903AbaEISBj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 May 2014 14:01:39 -0400
Date: Fri, 9 May 2014 19:01:37 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: laie <laie@halifax.rwth-aachen.de>, linux-btrfs@vger.kernel.org
Subject: Re: destroyed disk in btrfs raid
Message-ID: <20140509180137.GH16185@carfax.org.uk>
References: <2a45648842c071a8e0d3285541d96c6f@halifax.rwth-aachen.de>
 <20140509175827.GG16185@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/Gk0KcsbyUMelFU1"
In-Reply-To: <20140509175827.GG16185@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--/Gk0KcsbyUMelFU1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 09, 2014 at 06:58:27PM +0100, Hugo Mills wrote:
> On Fri, May 09, 2014 at 08:02:45PM +0200, laie wrote:
> > Now I'm looking for a way to tell btrfs to provide me with a list of the
> > corrupted files and delete them afterwards. This would be great, because
> > otherwise it would take very long to get the data back from slow backups.
> 
>    Simple solution: cat every file to /dev/null, and see which ones
> fail with an I/O error. With RAID-0 data, losing a device is going to
> damage most files, though, so don't necessarily expect much to survive.

   Actually, you could cat just the first 256 KiB of each file to
/dev/null -- that should be sufficient, because with RAID-0, the
stripe size is 64 KiB, and 256 KiB is therefore 4 stripes, and so
should cover every device... :)

   Hugo.

> > btrfs fi show
> > Label: userspace  uuid: there is one ;)
> >         Total devices 3 FS bytes used 27.21TiB
> >         devid    1 size 21.83TiB used 13.03TiB path /dev/dm-3
> >         devid    2 size 16.37TiB used 13.01TiB path /dev/dm-2
> >         devid    3 size 8.19TiB used 4.27TiB path

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
             --- UDP jokes: It's OK if no-one gets them. ---             

--/Gk0KcsbyUMelFU1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU20YAVheFHXiqx3kAQLzTQ/9EvCHNnKQCPIazOkkKw/X7GC4WlslVeeA
dp2syBWPGOk+nlbX4Nexoj3NV/Qe7p5w/R60is+Xw3O3i1CKgUSI/mhenGdbGVtX
NbVJ8DBhtxfJuh09fAznf8CDKzeMfwJWbm5fGlNX+LBYlZfmoJcAEL5ittBiDT1Y
t8MetlDRw2GNoa8tYhDAqQFFEBjI/57ZSNLt/5tvUuOKIL2jnvqzTCEIi912hBSS
CsEhsvO7Li40M0ID4VbkqSAE2YHynSJ6L28XLiQe3sIBcOIO7qLjYZ2q6ZqDtaPW
2vZyu5tYxTXAan6ExA1NEmVQRh8aikYw3dN4bEwOwLLOy2x/YVGfPh2+vd2GX1Iu
x5gEtp1n5GjxL33oAmVkzPcRG12PuoGLSu3rc0m2fZ+fD1fQ+pLKXN+qw6hgXSZg
9TdawBv94TbTA9a7pGFKIelA4g/woDO1h/kIW5xI13REgxiiDN5mKrX5Ds5cOVlb
S05fXokY4y1gdPQDgqrlc3Hgmtd9mUD2H+tlaWW1VaqrPcrttbXT2eX5mWF3E+D+
+PlaRBfqDgAGlb5Mg0vBsDUgimER8FSrKphTKipnXAWB54EuSFOVlGrsIvo1pH8G
UtckiiXqV8DlxhBn7QIOLvUV6uo/58l3j8kQpWGAh8nbIAqSyZ1ynyIHvnEfNyB6
hMGc9TShSmU=
=11xq
-----END PGP SIGNATURE-----

--/Gk0KcsbyUMelFU1--
