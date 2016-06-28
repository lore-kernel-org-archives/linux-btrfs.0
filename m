Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:41778 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751673AbcF1DR2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 23:17:28 -0400
Date: Mon, 27 Jun 2016 23:17:26 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Andrei Borzenkov <arvidjaar@gmail.com>,
        Hugo Mills <hugo@carfax.org.uk>, kreijack@inwind.it,
        Roman Mamedov <rm@romanrm.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Adventures in btrfs raid5 disk recovery
Message-ID: <20160628031726.GJ14667@hungrycats.org>
References: <576D6C0A.7070502@gmail.com>
 <CAJCQCtSskA4PC_a8tgQopHFNO83NQ=Gkx406haB7G0nBi5e=2A@mail.gmail.com>
 <c2a320a6-261b-723d-ab83-58f883e6315b@gmail.com>
 <CAJCQCtSqO4GNm8kBDuzUXEXYx+54zFgsD6=ARNsRgVUb53LQZw@mail.gmail.com>
 <fd7d250c-0a5a-ea3e-9ea2-ec6e50e14169@gmail.com>
 <CAJCQCtQugDoR6fnPeion37FLS3LarjfP6dt+-Z3jPgLG0Xkmwg@mail.gmail.com>
 <20160627215726.GG14667@hungrycats.org>
 <CAJCQCtRbrLaXSGm9DA6FrHO9Pd9ozaaJpKd6HjMGXCojdxbZoQ@mail.gmail.com>
 <20160628015245.GI14667@hungrycats.org>
 <CAJCQCtTQTo7JRBuWgTWZ=T+EA5P-uRLjoiknTzv9gwy4Z290XQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kH8JNVvasRCCW1Oz"
In-Reply-To: <CAJCQCtTQTo7JRBuWgTWZ=T+EA5P-uRLjoiknTzv9gwy4Z290XQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--kH8JNVvasRCCW1Oz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 27, 2016 at 08:39:21PM -0600, Chris Murphy wrote:
> On Mon, Jun 27, 2016 at 7:52 PM, Zygo Blaxell
> <ce3g8jdj@umail.furryterror.org> wrote:
> > On Mon, Jun 27, 2016 at 04:30:23PM -0600, Chris Murphy wrote:
> >> Btrfs does have something of a work around for when things get slow,
> >> and that's balance, read and rewrite everything. The write forces
> >> sector remapping by the drive firmware for bad sectors.
> >
> > It's a crude form of "resilvering" as ZFS calls it.
>=20
> In what manner is it crude?

Balance relocates extents, looks up backrefs, and rewrites metadata, all
of which are extra work above what is required by resilvering (and extra
work that is proportional to the number of backrefs and the (currently
extremely poor) performance of the backref walking code, so snapshots
and large files multiply the workload).

Resilvering should just read data, reconstruct it from a mirror if
necessary, and write it back to the original location (or read one
mirror and rewrite the other).  That's more like what scrub does, except
scrub rewrites only the blocks it couldn't read (or that failed csum).

> > Last time I checked all the RAID implementations on Linux (ok, so that's
> > pretty much just md-raid) had some sort of repair capability.
>=20
> You can read man 4 md, and you can also look on linux-raid@, it's very
> clearly necessary for the drive to report a read or write error
> explicitly with LBA for md to do repairs. If there are link resets,
> bad sectors accumulate and the obvious inevitably happens.

I am looking at the md code.  It looks at ->bi_error, and nothing else as
far as I can tell.  It doesn't even care if the error is EIO--any non-zero
return value from the lower bio layer seems to trigger automatic recovery.


--kH8JNVvasRCCW1Oz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAldx7EYACgkQgfmLGlazG5zQ0gCdHxjbXoEDW4Axn6GDa1mvNciZ
9o8AnjbE5Pl4YswAJrGkXE3xyPjRTOwk
=+QGH
-----END PGP SIGNATURE-----

--kH8JNVvasRCCW1Oz--
