From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: LABEL only 1 device
Date: Sun, 26 Feb 2012 17:14:19 +0000
Message-ID: <20120226171419.GD18898@carfax.org.uk>
References: <20120226164400.GC18898@carfax.org.uk>
 <C3b1BrAT1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="osDK9TLjxFScVI/L"
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <C3b1BrAT1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>


--osDK9TLjxFScVI/L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Feb 26, 2012 at 05:57:00PM +0100, Helmut Hullen wrote:
> Hallo, Hugo,
> 
> Du meintest am 26.02.12:
> 
> >> My (planned) usual work (once a year or so):
> >>
> >>         btrfs device add <biggerdevice> <path>
> >>         btrfs filesystem balance <path>
> >>         btrfs device delete <smallerdevice> <path>
> 
> >    OK, the real problem you're seeing is that when btrfs removes a
> > device from the filesystem, that device is not modified in any way.
> > This means that the old superblock is left behind on it, containing
> > the FS label information. What you need to do is, immediately after
> > removing a device from the FS, zero the first part of the partition
> > with dd and /dev/zero.
> 
> Ok - I'll try again (not today ...).
> If I remember correct in early times deleting only the first block of  
> the partition didn't reach ...

   No, it won't -- the first superblock on btrfs is at 64k into the
device. Most filesystems do something similar, because there's other
things that occasionally put metadata in the first part of the device,
so it avoids having the FS's superblock overwritten accidentally.

> My last try with "delete" let me believe that btrfs had deleted the  
> "critical" informations; I had tested it with "blkid". But looking into  
> the first sector of the partition may be more reliable.

> >> I prefer LABELling the devices/partitions, and then I'd seen that
> >> the option "-L" makes problems when I use it for more than 1 device/
> >> partition.
> 
> [...]
> 
> >    I say again, partitions are not labelled. *Filesystems* are
> > labelled. I think that with a GPT you can refer to the disk itself
> > and its partitions by a UUID each, but I'm not 100% certain.
> 
> My last try:
> 
>         mkfs.btrfs -d raid0 -m raid1 /dev/sdk1 /dev/sdl1 /dev/sdm1
> 
>         mkfs.btrfs -L SCSI /dev/sdk1
> 
> seemed to work.
> 
>         mount LABEL=SCSI /mnt/btr
> 
> worked as expected, the bundle of 3 partitions was mounted. And only "/ 
> dev/sdk1" got this label, no other partition.

   That's because you've just destroyed part of the original
filesystem that was on /dev/sd[klm]1 and created a new single-device
filesystem on /dev/sdk1.

   mkfs.btrfs creates a new filesystem. The -L option sets the label
for the newly-created FS. It *cannot* be used to change the label of
an existing FS. If you want to do that, use "btrfs filesystem label".

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
               --- emacs: Emacs Makes A Computer Slow. ---               

--osDK9TLjxFScVI/L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPSmhqIKyzvlFcI40RAr9dAJ9QzFIx+UJ4RwKqH8EST26OHsScOgCgmhIG
ykQ0mY6sW++0QP4tkMzfq94=
=6LjA
-----END PGP SIGNATURE-----

--osDK9TLjxFScVI/L--
