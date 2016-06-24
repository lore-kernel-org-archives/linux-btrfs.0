Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:46677 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751308AbcFXQja (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 12:39:30 -0400
Date: Fri, 24 Jun 2016 12:39:29 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>, kreijack@inwind.it,
        Roman Mamedov <rm@romanrm.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Adventures in btrfs raid5 disk recovery
Message-ID: <20160624163929.GE14667@hungrycats.org>
References: <CAJCQCtR9uAn58KJKEjCsbyLYJTQVqMx-ghsVp_MjLBF-aiikcg@mail.gmail.com>
 <20160620204049.GA1986@hungrycats.org>
 <CAJCQCtR5pV53mFyGWxRxm69zwF5_sEvNRRRvOSgnZ1t8KZdc3g@mail.gmail.com>
 <20160621015559.GM15597@hungrycats.org>
 <CAJCQCtRUUd+moK25N3704ZG54cFrCw1-Uxm2QO-XF9g0=mHazw@mail.gmail.com>
 <20160622203504.GQ15597@hungrycats.org>
 <5790aea9-0976-1742-7d1b-79dbe44008c3@inwind.it>
 <CAJCQCtRXqSCFZTca+Vwraa0vS-MzLQKEkr=s41Vypc-O0ZDdxQ@mail.gmail.com>
 <20160624014752.GB14667@hungrycats.org>
 <576CB0DA.6030409@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0QFb0wBpEddLcDHQ"
In-Reply-To: <576CB0DA.6030409@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--0QFb0wBpEddLcDHQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 24, 2016 at 07:02:34AM +0300, Andrei Borzenkov wrote:
> >> I don't read code well enough, but I'd be surprised if Btrfs
> >> reconstructs from parity and doesn't then check the resulting
> >> reconstructed data to its EXTENT_CSUM.
> >=20
> > I wouldn't be surprised if both things happen in different code paths,
> > given the number of different paths leading into the raid56 code and
> > the number of distinct failure modes it seems to have.
>=20
> Well, the problem is that parity block cannot be redirected on write as
> data blocks; which makes it impossible to version control it. The only
> solution I see is to always use full stripe writes by either wasting
> time in fixed width stripe or using variable width, so that every stripe
> always gets new version of parity. This makes it possible to keep parity
> checksums like data checksums.

The allocator could try harder to avoid partial stripe writes.  We can
write multiple small extents to the same stripe as long as we always do
it all within one transaction, and then later treat the entire stripe
as read-only until every extent is removed.  It would be possible to do
that by fudging extent lengths (effectively adding a bunch of prealloc-ish
space if we have a partial write after all the delalloc stuff is done),
but it could also waste some blocks on every single transaction, or
create a bunch of "free but unavailable" space that makes df/statvfs
output even more wrong than it usually is.

The raid5 rmw code could try to relocate the other extents sharing a
stripe, but I fear that with the current state of backref walking code
that would make raid5 spectacularly slow if a filesystem is anywhere
near full.

We could also write rmw parity block updates to a journal (like another
log tree).  That would enable us to at least fix up the parity blocks
after a crash, and close the write hole.  That's an on-disk format
change though.


--0QFb0wBpEddLcDHQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAldtYkEACgkQgfmLGlazG5wjNwCgttpH1eo+j5tBuZN2//yVXdjq
XqkAmwXpcl3eZ+oKVNCHopF+2aHxSMsr
=ZAdZ
-----END PGP SIGNATURE-----

--0QFb0wBpEddLcDHQ--
