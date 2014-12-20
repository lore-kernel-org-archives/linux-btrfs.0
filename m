Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:37654 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750750AbaLTFwo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Dec 2014 00:52:44 -0500
Date: Sat, 20 Dec 2014 00:52:43 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Josef Bacik <jbacik@fb.com>
Cc: Daniele Testa <daniele.testa@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs is using 25% more disk than it should
Message-ID: <20141220055242.GB436@hungrycats.org>
References: <CAN6BF2Luf3ERd+ShLyUavzM3bLmy9dT918Zg17xL9T42DNVtVQ@mail.gmail.com>
 <54949454.9020601@fb.com>
 <549495D4.9030800@fb.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CUfgB8w4ZwR/yMy5"
In-Reply-To: <549495D4.9030800@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--CUfgB8w4ZwR/yMy5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 19, 2014 at 04:17:08PM -0500, Josef Bacik wrote:
> >And for your inode you now have this
> >
> >inode 256, file offset 0, size 4k, offset 0, diskebytenr (123+302g),
> >disklen 4k
> >inode 256, file offset 4k, size 302g-4k, offset 4k, diskbytenr 123,
> >disklen 302g
> >
> >and in your extent tree you have
> >
> >extent bytenr 123, len 302g, refs 1
> >extent bytenr whatever, len 4k, refs 1
> >
> >See that?  Your file is still the same size, it is still 302g.  If you
> >cp'ed it right now it would copy 302g of information.  But what you have
> >actually allocated on disk?  Well that's now 302g + 4k.  Now lets say
> >your virt thing decides to write to the middle, lets say at offset 12k,
> >now you have this
> >
> >inode 256, file offset 0, size 4k, offset 0, diskebytenr (123+302g),
> >disklen 4k
> >inode 256, file offset 4k, size 3k, offset 4k, diskbytenr 123, disklen 302g
> >inode 256, file offset 12k, size 4k, offset 0, diskebytenr whatever,
> >disklen 4k
> >inode 256, file offset 16k, size 302g - 16k, offset 16k, diskbytenr 123,
> >disklen 302g
> >
> >and in the extent tree you have this
> >
> >extent bytenr 123, len 302g, refs 2
> >extent bytenr whatever, len 4k, refs 1
> >extent bytenr notimportant, len 4k, refs 1
> >
> >See that refs 2 change?  We split the original extent, so we have 2 file
> >extents pointing to the same physical extents, so we bumped the ref
> >count.  This will happen over and over again until we have completely
> >overwritten the original extent, at which point your space usage will go
> >back down to ~302g.

Wait, *what*?

OK, I did a small experiment, and found that btrfs actually does do
something like this.  Can't argue with fact, though it would be nice if
btrfs could be smarter and drop unused portions of the original extent
sooner.  :-P

The above quoted scenario is a little oversimplified.  Chances are that
302G file is made of much smaller extents (128M..256M).  If the VM is
writing 4K randomly everywhere then those 128M+ extents are not going
away any time soon.  Even the extents that are dropped stick around for
a few btrfs transaction commits before they go away.

I couldn't reproduce this behavior until I realized the extents I was
overwriting in my tests were exactly the same size and position of
the extents on disk.  I changed the offset slightly and found that
partially-overwritten extents do in fact stick around in their entirety.

There seems to be an unexpected benefit for compression here:  compression
keeps the extents small, so many small updates will be less likely to
leave big mostly-unused extents lying around the filesystem.

--CUfgB8w4ZwR/yMy5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlSVDqoACgkQgfmLGlazG5yoMwCeNhYmlGMlDd+t9UyONIveoTTe
FKsAnRDLWM7PaPvSQ9EH0XXKQC6MHr0i
=3hwL
-----END PGP SIGNATURE-----

--CUfgB8w4ZwR/yMy5--
