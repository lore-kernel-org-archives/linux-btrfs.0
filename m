Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:39273 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab3ACSdp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jan 2013 13:33:45 -0500
Date: Thu, 3 Jan 2013 18:33:41 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: helmut@hullen.de
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Option LABEL
Message-ID: <20130103183341.GC19051@carfax.org.uk>
References: <20130103170151.GB19051@carfax.org.uk>
 <CO8ipTEeCXB@helmut.hullen.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K3iCROrs1P5jLO0B"
In-Reply-To: <CO8ipTEeCXB@helmut.hullen.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--K3iCROrs1P5jLO0B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 03, 2013 at 06:57:00PM +0100, Helmut Hullen wrote:
> Du meintest am 03.01.13:
> >> But for what purpose offers "mkfs.btrfs" this option?
> 
> >    So that you don't have to run the label command immediately after
> > making the filesystem. Most mkfs implementations for different
> > filesystems have something similar, usually with the -L option.
> 
> But other filesystems don't put the label onto more than 1 device.  
> There's the problem for/with btrfs.

   Aargh. How many times do I have to say this?

   Devices are not given labels.
   *Filesystems* are given labels.

> The label has to be unique for the whole machine.

   Wrong. You can have several filesystems on a machine with the same
label. It doesn't mean that they're easily managable, but there's
nothing that will stop it from happening.

   If you want a unique label for a *device*, take a look at the
symlinks in /dev/disk/by-id, and the udev rules that generate them.
Trying to use filesystem labels to give unique and stable device IDs
is the wrong tool for the job.

> >> Without this double-labelled (?) devices "blkid" shows all devices
> >> with
> 
> >    "Double-labelled"? The filesystem has one label, belonging to the
> > filesystem. I don't see where the "double-labelling" comes in.
> 
> As I described:
> 
>     mkfs.btrfs -d raid0 -m raid1 -l mylabel /dev/sdb /dev/sdc /dev/sdd
> 
> labels all three devices with the same name, and then programs like  
> "blkid" or "findfs" don't find any label (for all labelled devices, not  
> only for btrfs devices).
> 
> And as I have written before:
> 
>         file -s /dev/sdb
>         file -s /dev/sdc
>         file -s /dev/sdd
> 
> shows for each of these devices the same label.

   As I said above, you're expecting something which just isn't true.
Filesystems have labels, not devices. If you want to have unique
labels on devices, then you're going to have to write some udev rules
to generate them for you, and then refer to /dev/helmuts-devices/foo
(or whatever you want to call them). Mucking around with filesystem
labels is not going to give you a unique label for a device, because
the system simply doesn't work like that.

> --------------
> 
> When I run
> 
>       mkfs.btrfs -d raid0 -m raid1 /dev/sdb /dev/sdc /dev/sdd
> 
> and then
> 
>       btrfs filesystem label /dev/sdb mylabel
> 
> then only "/dev/sdb" shows this label (as long as none of the 3 devices  
> is mounted).

   This is probably a (minor) bug. You should be getting all of the
devices with the same label here (since it's the same filesystem). I
suspect that it's down to the label command only updating one
superblock when used offline, or possibly some kind of caching thing.
Does running btrfs dev scan immediately after the label command make a
difference?

> When I then run
> 
>       mount LABEL=mylabel /mnt/btr
> 
> then all works fine. And then (after mounting)
> 
>       blkid /dev/sdb
>       blkid /dev/sdc
>       blkid /dev/sdd
> 
> show the same label.

   This last result is the correct behaviour. All the devices of the
filesystem show the filesystem's label.

>       blkid
> 
> without any device seems to hang - may be I haven't waited long enough.

   It took a little while for it to run on my machine, but no more
than a couple of minutes at the outside.

> >> (if defined) their labels. When I define the same label for more
> >> than 1 device (btrfs or ext2fs or ...) then "blkid" shows nothing.
> >> No output for any of the devices.
> 
> >    This is a fault in the version of blkid you're running, then.
> 
> here: "blkid from until-linux 2.21.2 (libblkid 2.21.0, 25-May-2012)".  
> And older versions.
> 
> > There's nothing to stop me from labelling two ext2 filesystems with
> > the same label.
> 
> That part is right: I can label more than 1 device with the same name,  
> not only under btrfs.

   *Filesystem*, not *device*. You label *filesystems*.

> But then  (I had written this problem) programs like "blkid" don't find  
> any labelled device.

   It terminates with no output? Or you get bored of waiting and hit
^C first? If the former, that's a problem with blkid. If the latter...
it's probably not a problem.

> > If blkid can't handle that, then it's got problems
> > beyond btrfs. On my main machine, it seems to work correctly:
> 
> > $ sudo blkid
> > /dev/sda: LABEL="media" UUID="3993e50e-a926-48a4-867f-36b53d924c35"
> > UUID_SUB="5fd56eec-5e26-4c1f-a02a-f86550e4aefe" TYPE="btrfs"
> > /dev/sdc: LABEL="media" UUID="3993e50e-a926-48a4-867f-36b53d924c35"
> > UUID_SUB="4e392bea-f39a-4cba-b78c-c712479bf3f0" TYPE="btrfs"
> > /dev/sde: LABEL="media" UUID="3993e50e-a926-48a4-867f-36b53d924c35"
> > UUID_SUB="5e2555bd-bf36-430b-af5a-aa81604afc96" TYPE="btrfs"
> > /dev/sdp: LABEL="media" UUID="3993e50e-a926-48a4-867f-36b53d924c35"
> > UUID_SUB="404d13f5-0231-46db-a311-ad7a4f99eef3" TYPE="btrfs"
> > /dev/sdr: LABEL="media" UUID="3993e50e-a926-48a4-867f-36b53d924c35"
> > UUID_SUB="90469059-f012-4b6e-9233-8c591cbeaa80" TYPE="btrfs"
> > /dev/sdq: LABEL="media" UUID="3993e50e-a926-48a4-867f-36b53d924c35"
> > UUID_SUB="646d3d32-5193-4fcd-afb2-43f14122a149" TYPE="btrfs"
> > /dev/sds: LABEL="media" UUID="3993e50e-a926-48a4-867f-36b53d924c35"
> > UUID_SUB="f4d4dbb2-f2bb-4e54-bbf9-4bb5474e9ef1" TYPE="btrfs"
> 
> Is "media" mounted?

   Yes.

> >    My blkid version:
> 
> > blkid from util-linux 2.20.1 (libblkid 2.20.0, 19-Oct-2011)
> 
> It's older than my actual version, but I had found this problem more  
> than a year ago.

   Other than the fact that btrfs fi label doesn't seem to be updating
the label on every device without mounting the FS first, everything
you've reported here is working as it should.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- This chap Anon is writing some perfectly lovely stuff ---      
                             at the moment.                              

--K3iCROrs1P5jLO0B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUOXPBb9z9OVl50rAAQKUVA/+IfhbiW/hLYkQqPIKvusHOFfCjfKw5Cnm
0Urf28n71FaBSfxmule9B4fz3rx2w3ZHByEoXMq/ZIvpGuBhrD+eQ0ZD/wY1KU+s
3+10/xoeW2FZEldn1DePyQe2LHub7UydrRbwQMgZsmXCMiX0/nVikE6lJpa/uS9C
ShUb7uv3fSa6x21ZQmloMsz9LZ8rFWGerOLQP83QdyKEyhfBMDrmF3qV0k+eEhOv
aZX5SwdyjDG3tEu5dPs8fsrt5GZYQGDCHK6yQy+6QvV7VMOXnG7RJkmXy+4WWLga
Daj+wEWQIhN2NmIjngjOKUsOXrOFJYlRuIJiCcQMNx5gO3ylTK6ZxEtSHOL+w2ux
xZc8tkseGuRUZeXNRtw8qZFkS6McUQ3Q83ex9Pi2oUBLhszqHhYiYEmLzCGRiS6K
9r0EM3quFWjUXDM0gNJVnBefiJ76UdDVkA2CFbfZte8OM1VexVn9usK5Nt0rA47H
dXm6HizUyWkTyZhS9c+WPVhhDvovQxsmsruLpyv5D1EuhWC5X3RtU/OFqMW6NdqR
xAoJZxBm2tn11alG539lu+gnq6aA21hiJ2itpkEUQ/bWvlixL1/dFVQnf/PLpjM9
oyu/5XwdbozCIcOLFoFpjnlonHM+kQnm7BMpwbdN6j58V2ZfupGFOFVywyqMXYLI
gsVid1fPFaQ=
=tV54
-----END PGP SIGNATURE-----

--K3iCROrs1P5jLO0B--
