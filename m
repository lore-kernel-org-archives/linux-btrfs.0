From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: LABEL only 1 device
Date: Sun, 26 Feb 2012 16:44:00 +0000
Message-ID: <20120226164400.GC18898@carfax.org.uk>
References: <20120226153036.GB18898@carfax.org.uk>
 <C3b12r9i1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IpbVkmxF4tDyP/Kb"
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <C3b12r9i1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>


--IpbVkmxF4tDyP/Kb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Feb 26, 2012 at 05:12:00PM +0100, Helmut Hullen wrote:
> Hallo, Hugo,
> 
> Du meintest am 26.02.12:
> 
> >> Mounting seems to be no problem, but (p.e.) "delete" doesn't kill
> >> the btrfs informations shown with (p.e.) "blkid /dev/sdy1",
> >> especially it doesn't delete the label.
> 
> >    What do you mean by "delete" here?
> 
>    btrfs device delete <device> <path>

   OK.

> >    The label is a *filesystem* label, not a label for the block
> > device(s) it lives on, so it doesn't make much sense to talk about
> > putting an FS label on only one of the devices that the FS is on.
> 
> My (planned) usual work (once a year or so):
> 
>         btrfs device add <biggerdevice> <path>
>         btrfs filesystem balance <path>
>         btrfs device delete <smallerdevice> <path>
> 
> And the "devices" are (p.e.) /dev/sdj1, /dev/sdk1 etc. (partitions on a  
> device).
> 
> Therefor I can see some informations via (p.e.)
> 
>         blkid /dev/sdj1

   OK, the real problem you're seeing is that when btrfs removes a
device from the filesystem, that device is not modified in any way.
This means that the old superblock is left behind on it, containing
the FS label information. What you need to do is, immediately after
removing a device from the FS, zero the first part of the partition
with dd and /dev/zero.

> I prefer LABELling the devices/partitions, and then I'd seen that the  
> option "-L" makes problems when I use it for more than 1 device/ 
> partition.

   As far as I know, you can't label partitions or devices. Labels are
a filesystem thing, and are stored in a FS-dependent manner. There's a
confusion that historically it's been a one-to-one mapping, so people
get *very* sloppy about the distinction (particularly since there's no
real way of referring to a filesystem independently of the block
device(s) it's resident on).

> With other file systems there's no real problem with the same label for  
> several partitions - it doesn't work. But btrfs bundles these partitions  
> (perhaps sometimes/most times regardless of the labels of the other  
> partitions).

   I say again, partitions are not labelled. *Filesystems* are
labelled. I think that with a GPT you can refer to the disk itself and
its partitions by a UUID each, but I'm not 100% certain.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
               --- emacs: Emacs Makes A Computer Slow. ---               

--IpbVkmxF4tDyP/Kb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPSmFQIKyzvlFcI40RAjlIAKCYy47qYd3UeCFJPr9fJkIZNkf5xgCfXMjJ
BJtOynjAC8Uu1QQZs3OCsHQ=
=JLxX
-----END PGP SIGNATURE-----

--IpbVkmxF4tDyP/Kb--
