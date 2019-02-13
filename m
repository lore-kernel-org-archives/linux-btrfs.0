Return-Path: <SRS0=8r0n=QU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B77D4C282C4
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Feb 2019 02:49:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 833F421934
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Feb 2019 02:49:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389779AbfBMCtS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Feb 2019 21:49:18 -0500
Received: from james.kirk.hungrycats.org ([174.142.39.145]:46900 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389048AbfBMCtQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Feb 2019 21:49:16 -0500
Received: by james.kirk.hungrycats.org (Postfix, from userid 1002)
        id 95924219BEB; Tue, 12 Feb 2019 21:46:45 -0500 (EST)
Date:   Tue, 12 Feb 2019 21:46:12 -0500
From:   Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Reproducer for "compressed data + hole data corruption bug, 2018
 edition" still works on 4.20.7
Message-ID: <20190213024219.GD23918@hungrycats.org>
References: <20180823031125.GE13528@hungrycats.org>
 <20190212030838.GB9995@hungrycats.org>
 <CAL3q7H7T_NX=D8qimRC55g8V-p0k-ygUiW-K5bxF02r-6XT6Rg@mail.gmail.com>
 <20190212165916.GA23918@hungrycats.org>
 <b7d76392-6414-804f-c383-a43dc2d81c1c@gmail.com>
 <CAJCQCtT1K4RY+_nmcWZdzHVSno-ijHZYLfJz4vu-irN4p+ZYxA@mail.gmail.com>
 <20190212221107.GC23918@hungrycats.org>
 <CAJCQCtQcU0CvVf-NGt3ZHZo773meYeW3UVyPS6iP+2C_Kd-jZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Hf61M2y+wYpnELGG"
Content-Disposition: inline
In-Reply-To: <CAJCQCtQcU0CvVf-NGt3ZHZo773meYeW3UVyPS6iP+2C_Kd-jZQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--Hf61M2y+wYpnELGG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 12, 2019 at 03:53:53PM -0700, Chris Murphy wrote:
> And yet the file is delivered to user space, despite the changes, as
> if it's immune to checksum computation or matching. The data is
> clearly difference so how is it bypassing checksumming? Data csums are
> based on original uncompressed data, correct? So any holes are zeros,
> there are still csums for those holes?

csums in btrfs protect data blocks.  Holes are the absence of data blocks,
so there are no csums for holes.

There are no csums for extent references either--only csums on the extent
data that is referenced.  Since this bug affects processing of extent
refs, it must occur long after all the csums are verified.

> > I'm not sure how the zlib library is involved--sha1sum doesn't use one.
> >
> > > And then what happens if you do the exact same test but change to zstd
> > > or lzo? No error? Strictly zlib?
> >
> > Same errors on all three btrfs compression algorithms (as mentioned in
> > the original post from August 2018).
>=20
> Obviously there is a pattern. It's not random. I just don't know what
> it looks like.=20

Without knowing the root cause I can only speculate, but it does seem to
be random, just very heavily biased to some outcomes.  It will produce
more distinct sha1sum values the longer you run it, especially if there
is other activity on the system to perturb the kernel a bit.  If you make
the test file bigger you can have more combinations of outputs.

I also note that since the big batch of btrfs bug fixes that landed
near 4.14.80, the variation between runs seems to be a lot less than
with earlier kernels; however, the full range of random output values
(i.e. which extents of the file disappear) still seems to be possible, it
just takes longer to get distinct values.  I'm not sure that information
helps to form a theory of how the bug operates.

> I use compression, for years now, mostly zstd lately
> and a mix of lzo and zlib before that, but never any errors or
> corruptions. But I also never use holes, no punched holes, and rarely
> use fallocated files which I guess isn't quite the same thing as hole
> punching.

I covered this in August.  The original thread was:

	https://www.spinics.net/lists/linux-btrfs/msg81293.html

TL;DR you won't see this problem unless you have a single compressed
extent that is split by a hole--an artifact that can only be produced by
punching holes, cloning, or dedupe.  The cases users are most likely to
encounter are dedupe and hole-punching--I don't know of any applications
in real-world use that do cloning the right way to trigger this problem.

Also, you haven't mentioned whether you've successfully reproduced this
yourself yet (or not).

> So the bug you're reproducing is for sure 100% not on the media
> itself, it's somehow transiently being interpreted differently roughly
> 1 in 10 reads, but with a pattern. What about scrub? Do you get errors
> every 1 in 10 scrubs? Or how does it manifest? No scrub errors?

No errors in scrub--nor should there be.  The data is correct on disk,
and it can be read reliably if you don't use the kernel btrfs code to
read it through extent refs (scrub reads the data items directly, so
scrub never looks at data through extent refs).

btrfs just drops some of the data when reading it to userspace.

> I know very little about what parts of the kernel a file system
> depends on outside of its own code (e.g. page cache) but I wonder if
> there's something outside of Btrfs that's the source but it never gets
> triggered because no other file systems use compression. Huh - what
> file system uses compression *and* hole punching? squashfs? Is sparse
> file support different than hole punching?

Traditional sparse file support leaves blocks in a file unallocated until
they are written to, i.e. you do something like:

	write(64K)
	seek(80K)
	write(48K)

and you get a 16K hole between two extents (or contiguous block ranges
if your filesystem doesn't have a formal extent concept per se):

	data(64k)
	hole(16k)
	data(48k)

Traditional POSIX sparse files don't have any way to release any extents
in the middle of a file without changing the length of the file.  You can
fill in the holes with data later, but you can't delete existing data and
replace it with holes.  If you want to punch holes in a file, you used to
do it by making a copy of the file, omitting any of the data blocks that
contained all zero, then renaming the copy over the original file.

The hole punch operation adds the capability to delete existing data
in place, e.g. you can say "punch a hole at 24K, length 8K" and the
filesystem will look like:

	data(24k) (originally part of first 64K extent)
	hole(8k)
	data(32k) (originally part of first 64K extent)
	hole(16k)
	data(48k)

On btrfs, the first 32k and 24k chunks of the file are both references
to pieces of the original 64k extent, which is not modified on disk,
but 8K of it is no longer accessible.

> --=20
> Chris Murphy
>=20

--Hf61M2y+wYpnELGG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCXGOEAwAKCRCB+YsaVrMb
nH5WAJ48TpLwEwYfIB9vrWBanckAA/al9ACg58J/q8mNhtskPRqgFIZXK6hlpeU=
=FJDB
-----END PGP SIGNATURE-----

--Hf61M2y+wYpnELGG--
