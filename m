Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:42173 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaENSoR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 May 2014 14:44:17 -0400
Date: Wed, 14 May 2014 19:44:12 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: laie <laie@halifax.rwth-aachen.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: destroyed disk in btrfs raid
Message-ID: <20140514184412.GH23212@carfax.org.uk>
References: <2a45648842c071a8e0d3285541d96c6f@halifax.rwth-aachen.de>
 <20140509175827.GG16185@carfax.org.uk>
 <20140509180137.GH16185@carfax.org.uk>
 <c1b636dffe4c70c4e15010000e730703@halifax.rwth-aachen.de>
 <20140511141957.GC23212@carfax.org.uk>
 <91b2e7cdfaa8aa12469240cf4a2e3d05@halifax.rwth-aachen.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jRdC2OsRnuV8iIl8"
In-Reply-To: <91b2e7cdfaa8aa12469240cf4a2e3d05@halifax.rwth-aachen.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--jRdC2OsRnuV8iIl8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 14, 2014 at 08:43:41PM +0200, laie wrote:
> On 2014-05-11 16:19, Hugo Mills wrote:
> >On Tue, May 13, 2014 at 10:16:59AM +0200, laie wrote:
> >>On 2014-05-09 20:01, Hugo Mills wrote:
> >>>On Fri, May 09, 2014 at 06:58:27PM +0100, Hugo Mills wrote:
> >>>>On Fri, May 09, 2014 at 08:02:45PM +0200, laie wrote:
> >>>>> Now I'm looking for a way to tell btrfs to provide me with a list of the
> >>>>> corrupted files and delete them afterwards. This would be great, because
> >>>>> otherwise it would take very long to get the data back from slow backups.
> >>>>
> >>>>   Simple solution: cat every file to /dev/null, and see which ones
> >>>>fail with an I/O error. With RAID-0 data, losing a device is going to
> >>>>damage most files, though, so don't necessarily expect much to survive.
> 
> I finished building the List, about 40% of the Data is gone. So far so good.
> 
> As next step I planned to delete these files. This is not possible because
> I'm not able to mount the fs r/w.
> 
> btrfs: allowing degraded mounts
> btrfs: bdev /dev/mapper/luks-0 errs: wr 37519, rd 32783, flush 0, corrupt 0,
> gen 0
> Btrfs: too many missing devices, writeable mount is not allowed
> btrfs: open_ctree failed
> 
> Is it correct remove the missing device now:
> 
> btrfs device delete missing /mnt
> 
> Or do I have to add the replacement first?

   You'd have to mount r/w before you can add a new disk. :)

   You should be able to mount r/w using the -o degraded mount option.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- Attempted murder, now honestly, what is that?  Do they give a ---  
                  Nobel Prize for attempted chemistry?                   

--jRdC2OsRnuV8iIl8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU3O5fFheFHXiqx3kAQJY9g//e4ttolrOh7cInCJT3b4CUSC3o1aPeec6
ZpYLYa5alhbCeb5eyej6nTAlMfXBPMDVV50/3XRISRs86Nj/RALgdoqfIBfrudpH
f0XhjQNFaXfyO2MMgF/ixoXyMpR6rDtnlkLPSbib9fqpgmdXt5ByVMovtvP+KrpJ
voKbN4QisleJ4BwKEl8MLzkEBEmksjAn1u5PXtlcged8VJME0KX7R0EkJadQlVao
5y6tyZ4rKBTPvBHCZwNtKHm91KNqkr99/V9kRbo1EdaI1qBgvBzJnoDEg8BJYgPj
9I6IKUGEt7euMDfGcEwCt/S5rB4TOGP9Amqe9gwc0el1+/b5FBMQmmW9xiyftNtk
kaZ6MTsGcmCKq6PKeYBglsJLhR4nxCVDThAqJTX7NY0+dPC6Y7lItUG+/83JYIyP
7OO/sgjvZi03nfQaWBYHlFC+RkZ8qPuN82PDYhRB4HfyWn9XLRcEcZbZ3DLZ1zw9
kAPhMSSwj2QSADyklQl0OLYCUJUoubExFKax0fciQ1EhXvWgJUhv67yUmdDM9OtM
c1vpf4B+e+CpStsjvJOoGl1Mlk9g2KM9IDEtmjEo8CQUPLoEII+zAJIW+LhkraDJ
7AmOah86d/cgX9CUxBPVJs/ylkajbQJFGVniiy2MZaFMXtMI4u2Q0Igw/NVTur0z
1Y/J0GnbXBg=
=jF6r
-----END PGP SIGNATURE-----

--jRdC2OsRnuV8iIl8--
