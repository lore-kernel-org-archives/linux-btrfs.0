Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:42105 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327Ab3ALC2w (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Jan 2013 21:28:52 -0500
Date: Sat, 12 Jan 2013 02:28:49 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Rick Liu <rickliu@broadcom.com>
Cc: Joshua =?iso-8859-1?Q?Sch=FCler?= <joshua.schueler@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: how to resize (grow) device partition of a multi-device BTRFS
 filesystem?
Message-ID: <20130112022848.GX19051@carfax.org.uk>
References: <7D0754FFADBD2D4785C1D233C497C47B1BCD81D0@SJEXCHMB06.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lRwEuQLrOweSgmPW"
In-Reply-To: <7D0754FFADBD2D4785C1D233C497C47B1BCD81D0@SJEXCHMB06.corp.ad.broadcom.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--lRwEuQLrOweSgmPW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 12, 2013 at 02:18:44AM +0000, Rick Liu wrote:
> > 
> >    You'll need to use something like fdisk or cfdisk to resize the
> > partition first. With (c)fdisk, that involves deleting and recreating
> > the partition with the same starting point. (fdisk gives you more
> > control here). As with most low-level FS-resizing tools, btrfs fi
> > resize doesn't attempt to change the size of the underlying device.
> > 
> >    Hugo.
> [Rick Liu] 
> I see.
> So that means unlike ext4 filesystem,
> which I can use resize2fs on line to grow partition without losing data,
> BTRFS must re-create partition table (fdisk) and loss data.

   No, with resize2fs, you also need to resize the partition, using
the same process. Deleting and enlarging a partition doesn't change
any of the data in it. resize2fs doesn't modify partition tables. (Or
at least, didn't the last time I really looked at it in detail).

   As long as the start of the partition isn't changed, deleting and
resizing in fdisk isn't damaging. It's just... slightly disconcerting.
:) (It's also been the standard way of resizing the device for as long
as I can remember).

   The thing to remember is that a filesystem and a partition are two
different things. The partition is a *container*, and the filesystem
is an area of structured data within that container.

   (c)fdisk changes the definition of the container, but doesn't
modify the bytes stored on the underlying storage device. The
fs-resizing tools (btrfs fi resize / resize2fs) change the limits on
the data structures to match the container.

   Finally, the other thing to remember is that if you're increasing
size, change the block device first, then the filesystem. (i.e. fdisk,
then btrfs fi resize). If you're shrinking, change the filesystem
first, then the block device (i.e. btrfs fi resize, then fdisk).

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- Klytus! Are your men on the right pills? Maybe you should ---    
                         execute their trainer!                          

--lRwEuQLrOweSgmPW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUPDKYL9z9OVl50rAAQIJ/A/+LpJIwzArckp69CYc6FKHBQOSwGIAUc6D
yY6R3joyyazzrPvCorqyE6arlzXGzur5AUIvzcFRadDui8G0ztJUGzDcK1eh7ixx
BTwVWXeRbkvaJXs/Lv2TDN6mLzPTHJWu4zPQHtS5LM6rJURfJ5UKi55JgQ4boysa
I0LThQFeqG5b1BPdkqh6+py0YKHtj8scsYZDYsuWE46SzDMzcrkX84b5Dm8TPTQ5
b66R54G+QPFoyLXOtEj0Z0qZIH+MxvzEkBZDd0eyQ0HBSIja1quZza+SS3zQYemy
BKs5MIVmyzSRVbqyXLN1j06PjRvA+5X/7BDA2BHlutg4tNGF/IoW3jXmIVd0lNky
wPTSxTWZUCkcUmTkDfGhi/5Syc+5qdEFA8PoO+pHAyirTHYD25ybMrIEwZEJtyyO
hkPuxc0GxWm6w6mpNMf6FfkfmE81Ie7dABKMOXKEiVR/XWAPccEIz+fkTxpagmnM
rEZP1cufVFhkZcBjI5OEbzJCBKZKJBM6+Z90L6nXcJJNpIVqQpGz+DPfZURmXqqu
RqgTMu+c8id8I8Xz5+IqJ2MJUmCcaTSLfyagl3dkwriKa6I5UenPJKe9uq/Y1nyy
JegNKzQlLK3p1Ag5x1mD8hQELA51kQskhXauVbmYxXuUfTWSs/jT9o/dnXTDaXHo
09jbVQUXcfg=
=KN/T
-----END PGP SIGNATURE-----

--lRwEuQLrOweSgmPW--
