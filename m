From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: kernel 3.3.4 damages filesystem (?)
Date: Tue, 8 May 2012 21:02:29 +0100
Message-ID: <20120508200228.GM8938@carfax.org.uk>
References: <4FA968EB.6050306@gmail.com>
 <C8TGck3eCXB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qySB1iFW++5nzUxH"
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <C8TGck3eCXB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>


--qySB1iFW++5nzUxH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 08, 2012 at 09:34:00PM +0200, Helmut Hullen wrote:
> Hallo, Felix,
> 
> Du meintest am 08.05.12:
> 
> >>>>           adding a bigger disk
> >>>>           deleting/removing a smaller disk
> >>>>
> >>>> with simple commands.
> 
> [...]
> 
> >>> Is it really possible to remove a disk from btrfs (created with -d
> >>> single) without losing the data on that disk?
> >>
> >> When the system is configured with
> >>
> >>          mkfs.btrfs -m raid1 -d raid0
> >>
> >> then the above shown way is possible, it works (now) as expected.
> >> Ok - it needs some time.
> 
> [...]
> 
> > What are the steps you're doing?! If this is really possible then
> > there must be some sort of command that tells btrfs "Hey, I wanne
> > remove this disk from the fs, please copy all data to the other disks
> > and then remove the disk". Is there such a command? Haven't heard of
> > one, but that would be interesting.
> 
>         btrfs device add /dev/$newdisk ...
>         (btrfs fi balance ...)
>         btrfs device delete /dev/$olddisk ...
>         (btrfs fi balance ...)
> 
> I've told these simple steps many times in this mailing list.
> 
> Since some kernel versions (at least since kernel 3.2.x) it seems to  
> work without problems; "btrfs-progs"-packet from 2011-10-30.
> 
> 
> > Otherwise if you remove a disk from a raid0 (doesn't matter if you
> > have 2 or 5 or x disks in the fs, btrfs should stripe above all
> > disks) your fs should be broken.
> 
> 
> Not with btrfs ... there it works even with
> 
>   mkfs.btrfs -m raid1 -d raid0 ...

   There is a big difference between "orderly and planned removal of a
hard disk", and "disk goes away with no warning". This is essentially
the difference you've been talking about at cross-purposes all day.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                 --- My karma has run over my dogma. ---                 

--qySB1iFW++5nzUxH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPqXvUIKyzvlFcI40RAiNJAJ9GbGAEPFfIY0Q5GAWP6isf8FsBoACgtGDp
ckC1rAwnYtEiJggqXHzlO2A=
=2GQB
-----END PGP SIGNATURE-----

--qySB1iFW++5nzUxH--
