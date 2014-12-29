Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:35521 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbaL2VuL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Dec 2014 16:50:11 -0500
Date: Mon, 29 Dec 2014 21:50:08 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: "sys.syphus" <syssyphus@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: I need to P. are we almost there yet?
Message-ID: <20141229215008.GB26040@carfax.org.uk>
References: <CAAe=sHWT9G9PNYUh8yxG0dS7xCjy0Fhv03GATvkQHq64kM0oBA@mail.gmail.com>
 <CAAe=sHUez9eNCSck5do7sBK=6nV1v9ZNNdqDVfnud1j5s1kJzQ@mail.gmail.com>
 <20141229190400.GA26040@carfax.org.uk>
 <CAAe=sHUYJVX5=Xi-r5HOMSLnPJV55z-FOmWWkZSj7yH2_YD1CA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1UWUbFP1cBYEclgG"
In-Reply-To: <CAAe=sHUYJVX5=Xi-r5HOMSLnPJV55z-FOmWWkZSj7yH2_YD1CA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--1UWUbFP1cBYEclgG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 29, 2014 at 02:25:14PM -0600, sys.syphus wrote:
> so am I to read that as if btrfs redundancy isn't really functional?
> if i yank a member of my raid 1 out in live "prod" is it going to take
> a dump on my data?

   Eh? Where did that conclusion some from? I said nothing at all
about RAID-1, only RAID-10.

   So, to clarify:

   In the general case, you can safely lose one device from a btrfs
RAID-10. Also in the general case, losing a second device will break
the filesystem (with very high probability).

   In the case I gave below, with an even number of equal sized
devices, the second device to be lost *may* allow the data to be
recovered with sufficient effort, but the FS in general will probably
not be mountable with two missing devices.

   So, btrfs RAID-10 offers the same *guarantees* as traditional
RAID-10. It's generally less effective with the probabilities of the
failure modes beyond the guarantee.

   Hugo.

> On Mon, Dec 29, 2014 at 1:04 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> > On Mon, Dec 29, 2014 at 01:00:05PM -0600, sys.syphus wrote:
> >> oh, and sorry to bump myself. but is raid10 *ever* more redundant in
> >> btrfs-speak than raid1? I currently use raid1 but i know in mdadm
> >> speak raid10 means you can lose 2 drives assuming they aren't the
> >> "wrong ones", is it safe to say with btrfs / raid 10 you can only lose
> >> one no matter what?
> >
> >    I think that with an even number of identical-sized devices, you
> > get the same "guarantees" (well, behaviour) as you would with
> > traditional RAID-10.
> >
> >    I may be wrong about that -- do test before relying on it. The FS
> > probably won't like losing two devices, though, even if the remaining
> > data is actually enough to reconstruct the FS.
> >
> >    Hugo.
> >

-- 
Hugo Mills             | emacs: Eighty Megabytes And Constantly Swapping.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: 65E74AC0          |

--1UWUbFP1cBYEclgG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUocyQAAoJEFheFHXiqx3k0e4P/ifd/uGiK43YQuZ5NTl+wUr4
GOl15PmUjz/RiHoNkUZRiQ1tjBZ55u347+20GZi+GTR1vef01Y10IRB9jzVu1wAm
Z8cnBsodQ3PC6YfkqORzx86cfYucFCbrT1M3W+qnZWBrNUEgfO/uvys7uJCBF/e1
hRDiivSTcGM+f0uoYax1TXGbkbEWcwKcz93Hzk0bSTzaCvVWVYv5JxeZmEOqQkrj
dO5T3vTglIMZZzFxnxtH0ly7hCVgm3nOwPoW3vHALlYodp6rp/xZY+x6sqRl2Gmy
vnp+zLxWpqzgsakyvfV4AltIPjRUkGm/vgAbJSnx/5RLBlwm6vyduvmCalBngYZc
9MT6Bb+Hx8nrvRfdK0FS+afvxvj4DZoGU7Lo7fz4VxmMCx9KNNFXe/b+Mtbv7dX/
UPSKxXsJoMDcHYF24BYOj6l8UfW/L/i6iav5sHF/wAWQq25wnDinvuOUTotBPFiR
MdreGNtaW8mwc6kV+F/j6Va8eOkxrOyN80PYwCqnNHV7YLlbbUDW4Hp4T0i3jK9W
uzxH0y7uHBG0F6tdM5mfhKmS5xb6M8Zth2RzLc4oUXnr5ia2cVYEzQLKqlJrqYnt
nCfY46mU2FPgCdt1hmGCNmpysyGbb05cXksoF/QtJ5Dp589uFllzoXwxsmCoTe3w
pX3gN/4utLDWew2m5Ezr
=HpWS
-----END PGP SIGNATURE-----

--1UWUbFP1cBYEclgG--
