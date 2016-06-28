Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:38209 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbcF1B4E (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 21:56:04 -0400
Date: Mon, 27 Jun 2016 21:52:46 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Andrei Borzenkov <arvidjaar@gmail.com>,
        Hugo Mills <hugo@carfax.org.uk>, kreijack@inwind.it,
        Roman Mamedov <rm@romanrm.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Adventures in btrfs raid5 disk recovery
Message-ID: <20160628015245.GI14667@hungrycats.org>
References: <CAA91j0Uqg0FafFTG3NhQt=p8KkYRhTeMU5Bd+JuUxDntP6g8Ng@mail.gmail.com>
 <CAJCQCtQBQAng5_mNJZev+64Z15BSkBkG9f2qmz=ckPRqXRbbWA@mail.gmail.com>
 <576D6C0A.7070502@gmail.com>
 <CAJCQCtSskA4PC_a8tgQopHFNO83NQ=Gkx406haB7G0nBi5e=2A@mail.gmail.com>
 <c2a320a6-261b-723d-ab83-58f883e6315b@gmail.com>
 <CAJCQCtSqO4GNm8kBDuzUXEXYx+54zFgsD6=ARNsRgVUb53LQZw@mail.gmail.com>
 <fd7d250c-0a5a-ea3e-9ea2-ec6e50e14169@gmail.com>
 <CAJCQCtQugDoR6fnPeion37FLS3LarjfP6dt+-Z3jPgLG0Xkmwg@mail.gmail.com>
 <20160627215726.GG14667@hungrycats.org>
 <CAJCQCtRbrLaXSGm9DA6FrHO9Pd9ozaaJpKd6HjMGXCojdxbZoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5vjQsMS/9MbKYGLq"
In-Reply-To: <CAJCQCtRbrLaXSGm9DA6FrHO9Pd9ozaaJpKd6HjMGXCojdxbZoQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--5vjQsMS/9MbKYGLq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 27, 2016 at 04:30:23PM -0600, Chris Murphy wrote:
> On Mon, Jun 27, 2016 at 3:57 PM, Zygo Blaxell
> <ce3g8jdj@umail.furryterror.org> wrote:
> > On Mon, Jun 27, 2016 at 10:17:04AM -0600, Chris Murphy wrote:
> > If anything, I want the timeout to be shorter so that upper layers with
> > redundancy can get an EIO and initiate repair promptly, and admins can
> > get notified to evict chronic offenders from their drive slots, without
> > having to pay extra for hard disk firmware with that feature.
>=20
> The drive totally thwarts this. It doesn't report back to the kernel
> what command is hung, as far as I'm aware. It just hangs and goes into
> a so called "deep recovery" there is no way to know what sector is
> causing the problem

I'm proposing just treat the link reset _as_ an EIO, unless transparent
link resets are required for link speed negotiation or something.
The drive wouldn't be thwarting anything, the host would just ignore it
(unless the drive doesn't respond to a link reset until after its internal
timeout, in which case nothing is saved by shortening the timeout).

> until the drive reports a read error, which will
> include the affected sector LBA.

It doesn't matter which sector.  Chances are good that it was more than
one of the outstanding requested sectors anyway.  Rewrite them all.

We know which sectors they are because somebody has an IO operation
waiting for a status on each of them (unless they're using AIO or some
other API where a request can be fired at a hard drive and the reply
discarded).  Notify all of them that their IO failed and move on.

> Btrfs does have something of a work around for when things get slow,
> and that's balance, read and rewrite everything. The write forces
> sector remapping by the drive firmware for bad sectors.

It's a crude form of "resilvering" as ZFS calls it.

> > The upper layers could time the IOs, and make their own decisions based
> > on the timing (e.g. btrfs or mdadm could proactively repair anything th=
at
> > took more than 10 seconds to read).  That might be a better approach,
> > since shortening the time to an EIO is only useful when you have a
> > redundancy layer in place to do something about them.
>=20
> For RAID with redundancy, that's doable, although I have no idea what
> work is needed, or even if it's possible, to track commands in this
> manner, and fall back to some kind of repair mode as if it were a read
> error.

If btrfs sees EIO from a lower block layer it will try to reconstruct the
missing data (but not repair it).  If that happens during a scrub,
it will also attempt to rewrite the missing data over the original
offending sectors.  This happens every few months in my server pool,
and seems to be working even on btrfs raid5.

Last time I checked all the RAID implementations on Linux (ok, so that's
pretty much just md-raid) had some sort of repair capability.  lvm uses
(or can use) the md-raid implementation.  ext4 and xfs on naked disk
partitions will have problems, but that's because they were designed in
the 1990's when we were young and naive and still believed hard disks
would one day become reliable devices without buggy firmware.

> For single drives and RAID 0, the only possible solution is to not do
> link resets for up to 3 minutes and hope the drive returns the single
> copy of data.

So perhaps the timeout should be influenced by higher layers, e.g. if a
disk becomes part of a raid1, its timeout should be shortened by default,
while a timeout for a disk that is not used in by redundant layer should
be longer.

> Even in the case of Btrfs DUP, it's thwarted without a read error
> reported from the drive (or it returning bad data).

That case gets messy--different timeouts for different parts of the disk.
Probably not practical.


--5vjQsMS/9MbKYGLq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAldx2G0ACgkQgfmLGlazG5yxNACgwOD6665Vg6nqQWE3NhlLmdJr
2FUAn0YXhleWpCfvy84RSBDb5+I2DBI/
=GG60
-----END PGP SIGNATURE-----

--5vjQsMS/9MbKYGLq--
