Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:40945 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbcF0V5n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 17:57:43 -0400
Date: Mon, 27 Jun 2016 17:57:26 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Andrei Borzenkov <arvidjaar@gmail.com>,
        Hugo Mills <hugo@carfax.org.uk>, kreijack@inwind.it,
        Roman Mamedov <rm@romanrm.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Adventures in btrfs raid5 disk recovery
Message-ID: <20160627215726.GG14667@hungrycats.org>
References: <576CB0DA.6030409@gmail.com>
 <20160624085014.GH3325@carfax.org.uk>
 <CAA91j0Uqg0FafFTG3NhQt=p8KkYRhTeMU5Bd+JuUxDntP6g8Ng@mail.gmail.com>
 <CAJCQCtQBQAng5_mNJZev+64Z15BSkBkG9f2qmz=ckPRqXRbbWA@mail.gmail.com>
 <576D6C0A.7070502@gmail.com>
 <CAJCQCtSskA4PC_a8tgQopHFNO83NQ=Gkx406haB7G0nBi5e=2A@mail.gmail.com>
 <c2a320a6-261b-723d-ab83-58f883e6315b@gmail.com>
 <CAJCQCtSqO4GNm8kBDuzUXEXYx+54zFgsD6=ARNsRgVUb53LQZw@mail.gmail.com>
 <fd7d250c-0a5a-ea3e-9ea2-ec6e50e14169@gmail.com>
 <CAJCQCtQugDoR6fnPeion37FLS3LarjfP6dt+-Z3jPgLG0Xkmwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3xoW37o/FfUZJwQG"
In-Reply-To: <CAJCQCtQugDoR6fnPeion37FLS3LarjfP6dt+-Z3jPgLG0Xkmwg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--3xoW37o/FfUZJwQG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 27, 2016 at 10:17:04AM -0600, Chris Murphy wrote:
> On Mon, Jun 27, 2016 at 5:21 AM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
> > On 2016-06-25 12:44, Chris Murphy wrote:
> >> On Fri, Jun 24, 2016 at 12:19 PM, Austin S. Hemmelgarn
> >> <ahferroin7@gmail.com> wrote:
> >>
> >> OK but hold on. During scrub, it should read data, compute checksums
> >> *and* parity, and compare those to what's on-disk - > EXTENT_CSUM in
> >> the checksum tree, and the parity strip in the chunk tree. And if
> >> parity is wrong, then it should be replaced.
> >
> > Except that's horribly inefficient.  With limited exceptions involving
> > highly situational co-processors, computing a checksum of a parity bloc=
k is
> > always going to be faster than computing parity for the stripe.  By usi=
ng
> > that to check parity, we can safely speed up the common case of near ze=
ro
> > errors during a scrub by a pretty significant factor.
>=20
> OK I'm in favor of that. Although somehow md gets away with this by
> computing and checking parity for its scrubs, and still manages to
> keep drives saturated in the process - at least HDDs, I'm not sure how
> it fares on SSDs.

A modest desktop CPU can compute raid6 parity at 6GB/sec, a less-modest
one at more than 10GB/sec.  Maybe a bottleneck is within reach of an
array of SSDs vs. a slow CPU.

> It just came up again in a thread over the weekend on linux-raid@. I'm
> going to ask while people are paying attention if a patch to change
> the 30 second time out to something a lot higher has ever been
> floated, what the negatives might be, and where to get this fixed if
> it wouldn't be accepted in the kernel code directly.

Defaults are defaults, they're not for everyone.  30 seconds is about
two minutes too short for an SMR drive's worst-case write latency, or
28 seconds too long for an OLTP system, or just right for an end-user's
personal machine with a low-energy desktop drive and a long spin-up time.

Once a drive starts taking 30+ seconds to do I/O, I consider the drive
failed in the sense that it's too slow to meet latency requirements.
When the problem is that it's already taking too long, the solution is
not waiting even longer.  To put things in perspective, consider that
server hardware watchdog timeouts are typically 60 seconds by default
(if not maximum).

If anything, I want the timeout to be shorter so that upper layers with
redundancy can get an EIO and initiate repair promptly, and admins can
get notified to evict chronic offenders from their drive slots, without
having to pay extra for hard disk firmware with that feature.

> *Ideally* I think we'd want two timeouts. I'd like to see commands
> have a timer that results in merely a warning that could be used by
> e.g. btrfs scrub to know "hey this sector range is 'slow' I'm going to
> write over those sectors". That's how bad sectors start out, they read
> slower and eventually go beyond 30 seconds and now it's all link
> resets. If the problem could be fixed before then... that's the best
> scenario.

What's the downside of a link reset?  Can the driver not just return
EIO for all the outstanding IOs in progress at reset, and let the upper
layers deal with it?  Or is the problem that the upper layers are all
horribly broken by EIOs, or drive firmware horribly broken by link resets?

The upper layers could time the IOs, and make their own decisions based
on the timing (e.g. btrfs or mdadm could proactively repair anything that
took more than 10 seconds to read).  That might be a better approach,
since shortening the time to an EIO is only useful when you have a
redundancy layer in place to do something about them.

> The 2nd timer would be, OK the controller or drive just face planted, res=
et.
>=20
> --=20
> Chris Murphy
>=20

--3xoW37o/FfUZJwQG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAldxoUYACgkQgfmLGlazG5zynwCgnTaL/gYWxk5XFEpz6Qojx7FB
C2wAoOCa5pxE6gSIsxYE+1R6rhbkVrCY
=mB+I
-----END PGP SIGNATURE-----

--3xoW37o/FfUZJwQG--
