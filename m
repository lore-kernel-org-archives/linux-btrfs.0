Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:43972 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932313Ab2GAM1l (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Jul 2012 08:27:41 -0400
Date: Sun, 1 Jul 2012 13:27:38 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Waxhead <waxhead@online.no>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs RAID space utilization and bitrot reconstruction
Message-ID: <20120701122738.GA5911@carfax.org.uk>
References: <4FF0398F.3030802@online.no>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
In-Reply-To: <4FF0398F.3030802@online.no>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jul 01, 2012 at 01:50:39PM +0200, Waxhead wrote:
> As far as I understand btrfs stores all data in huge chunks that are
> striped, mirrored or "raid5/6'ed" throughout all the disks added to
> the filesystem/volume.

   Well, RAID-5/6 hasn't landed yet, but yes.

> How does btrfs deal with different sized disks? let's say that you
> for example have 10 different disks that are
> 100GB,200GB,300GB...1000GB and you create a btrfs filesystem with
> all the disks. How will the raid5 implementation distribute chunks
> in such a setup.

   We haven't seen the code for that bit yet.

> I assume the stripe+stripe+parity are separate chunks that are
> placed on separate disks but how does btrfs select the best disk to
> store a chunk on? In short will a slow disk slow down the entire
> "array", parts of it or will btrfs attempt to use the fastest disks
> first?

   Chunks are allocated by ordering the devices by the amount of free
(=unallocated) space left on each, and picking the chunks from devices
in that order. For RAID-1 chunks are picked in pairs. For RAID-0, "as
many as possible" are picked, down to a minimum of 2 (I think). For
RAID-10, the largest even number possible is picked, down to a minimum
of 4. I _believe_ that RAID-5 and -6 will pick as many as possible,
down to some minimum -- but as I said, we haven't seen the code yet.

> Also since btrfs checksums both data and metadata I am thinking that
> at least the raid6 implementation perhaps can (try to) reconstruct
> corrupt data (and try to rewrite it) before reading an alternate
> copy. Can someone please fill me in on the details here?

   Yes, it should be possible to do that with RAID-5 as well. (Read
the data stripes, verify checksums, if one fails, read the parity,
verify that, and reconstruct the bad block from the known-good data).

> Finaly how does btrfs deals with advanced format (4k sectors) drives
> when the entire drive (and not a partition) is used to build a btrfs
> filesystem. Is proper alignment achieved?

   I don't know about that. However, the native block size in btrfs is
4k, so I'd imagine that it's all good.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- You stay in the theatre because you're afraid of having no ---    
                         money? There's irony...                         

--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFP8EI6IKyzvlFcI40RAgioAJ4tv+gMlS7NqDaedSXPr9gCmw/wHQCfV+YD
iHhp09Mbd4vii0u79YBAQ1U=
=ixBj
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
