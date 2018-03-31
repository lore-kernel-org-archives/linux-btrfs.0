Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:42836 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750776AbeCaExT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 31 Mar 2018 00:53:19 -0400
Date: Sat, 31 Mar 2018 00:53:18 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Menion <menion@gmail.com>
Cc: Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: Status of RAID5/6
Message-ID: <20180331045317.GD2446@hungrycats.org>
References: <CAJVZm6dkZmSpnV3wz4sfOMzMCP36Mrt+-2J7o0mU4z=dEYQqQQ@mail.gmail.com>
 <CANQeFDDxZSZ4jYDPvW-Q=AoyPrGzpp0fVywjFOJtkeD+Ysgmew@mail.gmail.com>
 <1521662556.4312.39.camel@scientia.net>
 <20180329215011.GC2446@hungrycats.org>
 <CAJVZm6dY9vg15Qxnv8uLAwwPvoiiMZ0gJWARLS_9Ab6LX47ajA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="u65IjBhB3TIa72Vp"
In-Reply-To: <CAJVZm6dY9vg15Qxnv8uLAwwPvoiiMZ0gJWARLS_9Ab6LX47ajA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--u65IjBhB3TIa72Vp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 30, 2018 at 09:21:00AM +0200, Menion wrote:
>  Thanks for the detailed explanation. I think that a summary of this
> should go in the btrfs raid56 wiki status page, because now it is
> completely inconsistent and if a user comes there, ihe may get the
> impression that the raid56 is just broken
> Still I have the 1 bilion dollar question: from your word I understand
> that even in RAID56 the metadata are spread on the devices in a coplex
> way, but shall I assume that the array can survice to the sudden death
> of one (two for raid6) HDD in the array?

I wouldn't assume that.  There is still the write hole, and while there
is a small probability of having a write hole failure, it's a probability
that applies on *every* write in degraded mode, and since disks can fail
at any time, the array can enter degraded mode at any time.

It's similar to lottery tickets--buy one ticket, you probably won't win,
but if you buy millions of tickets, you'll claim the prize eventually.
The "prize" in this case is a severely damaged, possibly unrecoverable
filesystem.

If the data is raid5 and the metadata is raid1, the filesystem can
survive a single disk failure easily; however, some of the data may be
lost if writes to the remaining disks are interrupted by a system crash
or power failure and the write hole issue occurs.  Note that the damage
is not necessarily limited to recently written data--it's any random
data that is merely located adjacent to written data on the filesystem.

I wouldn't use raid6 until the write hole issue is resolved.  There is
no configuration where two disks can fail and metadata can still be
updated reliably.

Some users use the 'ssd_spread' mount option to reduce the probability
of write hole failure, which happens to be helpful by accident on some
array configurations, but it has a fairly high cost when the array is
not degraded due to all the extra balancing required.



> Bye

--u65IjBhB3TIa72Vp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCWr8UOAAKCRCB+YsaVrMb
nA13AJ0X4wVeAKooXWSh0drlj7dGpK19GACfXAcgQPWMD/9pkVuCmtXkgVcwwck=
=+P4h
-----END PGP SIGNATURE-----

--u65IjBhB3TIa72Vp--
