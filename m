Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:36901 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751163AbaLSDcV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Dec 2014 22:32:21 -0500
Date: Thu, 18 Dec 2014 22:32:19 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Robert White <rwhite@pobox.com>
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Grzegorz Kowal <custos.mentis@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] Btrfs: get more accurate output in df command.
Message-ID: <20141219033219.GA436@hungrycats.org>
References: <36be817396956bffe981a69ea0b8796c44153fa5.1418203063.git.yangds.fnst@cn.fujitsu.com>
 <548B4117.1040007@inwind.it>
 <CA+qeAOokzptsxMKJaQwtVSFe5UxYuZnx5E22iMjRqM4AsuN8bA@mail.gmail.com>
 <CABmMA7tw9BDsBXGHLO4vjcO4gaYmZPb_BQV8w22griqFvCJpPA@mail.gmail.com>
 <CABmMA7vtHzUYAhnEfpnx3Fx93SJyx=Qqoaz-PyQcivo=51jKsA@mail.gmail.com>
 <548E377D.6030804@cn.fujitsu.com>
 <548E7A7A.90505@pobox.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
In-Reply-To: <548E7A7A.90505@pobox.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 14, 2014 at 10:06:50PM -0800, Robert White wrote:
> ABSTRACT:: Stop being clever, just give the raw values. That's what
> you should be doing anyway. There are no other correct values to
> give that doesn't blow someone's paradigm somewhere.

The trouble is a lot of existing software can't cope with the raw values
without configuration changes and access to a bunch of out-of-band data.
Nor should it.

I thank Robert for providing so many pathological examples in this thread.
They illustrate nicely why it's so important to provide adequately cooked
values through statvfs, especially for f_bavail!

> ITEM #1 :: In my humble opinion (ha ha) the size column should never
> change unless you add or remove actual storage. It should
> approximate the raw block size of the device on initial creation,
> and it should adjust to the size changes that happen when you
> semantically resize the filesystem with e.g. btrfs resize.

The units for f_blocks and f_bavail should be roughly similar because
software does calculate the ratio of those values (i.e. percentage of
disk used); however, there is no strong accuracy requirement--it could
be off by a few percent, and most software won't care.

Some software will start to misbehave if the ratio error is too large,
e.g. btrfs-RAID1 reporting the total disk size instead of the stored
data size.  This makes it necessary to scale f_blocks according to
chunk profiles, at least to within a few percent of actual size.

One critical rule is that (f_blocks - f_bavail) and (f_blocks - f_bfree)
should never be negative, or software will break in assorted ways.

> ITEM #4 :: Blocks available to unprivileged users is pretty "iffy"
> since unprivileged users cannot write to the filesystem. This datum
> doesn't have a "plain reading". I'd start with filesystem total
> blocks, then subtract the total blocks used by all trees nodes in
> all trees. (e.g. Nodes * 0x1000 or whatever node size is) then shave
> off the N superblocks, then subtract the number of blocks already
> allocated in data extents. And you're done.

Blocks available (f_bavail) should be the intersection of all sets of
blocks currently available for allocation by all users (ignoring quota
for now).  It must be an underestimate, so that ENOSPC implies=20
f_bavail =3D=3D 0.  It is acceptable to report f_bavail =3D 0 but allow wri=
tes
and allocations to succeed for a subset of cases (e.g. inline extents,
metadata modifications).

Historically, filesystems reserved arbitrary quantities of blocks that
were available to unprivileged users, but not counted in f_bavail, in
order to ensure the relation holds even in corner cases.  Existing
application software is well adapted to this behavior.

Compressing filesystems underestimate free space on the filesystem,
in the sense that N blocks written may result in M fewer free blocks
where M < N.  Compression in filesystems has been well tolerated by
application software for years now.

ENOSPC when f_bavail > 0 is very bad.  Depending on how large f_bavail
was at the ENOSPC failure, it means:

	- admins didn't get alerts triggered by a low space threshold
	and did not take action to avoid ENOSPC

	- software that garbage-collects based on available space wasn't
	activated in time to prevent ENOSPC

	- service applications have been starting transactions they
	believe they can finish because f_bavail is large enough,
	but failing when they hit ENOSPC instead

f_bavail should be the minimum of the free data space and the free
metadata space (counting free space in mixed-mode chunks and non-chunk
disk space that can be used by the current profile in both sets).
This provides a more accurate indication of the amount of free space in
cases where metadata blocks are more scarce than data blocks.  This breaks
a common trap for btrfs users who are blindsided by metadata ENOSPC with
gigabytes "free" in df.

f_bavail should count only free space in chunks that are already allocated
in the current allocation profile, or unallocated space that _could_
become a chunk of the currently selected profile (separately for data and
metadata, then the lower of the two numbers kept).

Free space not allocated to chunks could be difficult to measure
precisely, so guess low. =20

	(Aside:  would it make sense to have btrfs preallocate all
	available space just to make this calculation easier?  We can
	now reallocate empty chunks on demand, so one reason _not_
	to do this is already gone)

Chunks of non-current profiles (e.g. raid0 when the current profile is
raid1) should not be counted in f_bavail because such space can only
become available for use after a balance/convert operation.  Such space
should appear in f_bavail after that operation occurs.

This means that f_bavail will hit zero long before writes to the
filesystem start to fail due to lack of space, so there will be plenty of
warning for the administrator and software before space really runs out.

Free metadata space is harder to deal with through statvfs.  Currently
f_files, f_favail, and f_ffree are all zeros--they could be overloaded
to provide an estimate of metadata space separate from the estimate of
data space.

If the patch isn't taking those cases (and Robert's pathological examples)
into account, it should.

> Just as EXT before us didn't bother trying to put in a fudge factor
> that guessed what percentage of files would end up needing indirect
> blocks, we shouldn't be in the business of trying to back-figure
> cost-of-storage.

That fudge factor is already built into most application software, so
it's not required for btrfs.  0.1% - 1% is the usual overhead for many
filesystems, and most software adds an order of magnitude above that.
100% overhead (for btrfs-RAID1 with raw statvfs numbers) is well outside
the accepted range and will cause problems.

> The raw numbers are _more_ useful in many circumstances. The raw
> blocks used, for example, will tell me what I need to know for thin
> provisioning on other media, for example. Literally nothing else
> exposes that sort of information.

You'd need more structure in the data than statvfs provides to support
that kind of decision, and btrfs has at least two specialized tools to
expose it.

statvfs is not the appropriate place for raw numbers.  The numbers need to
be cooked so existing applications can continue to make useful decisions
with them without having to introduce awareness of the filesystem into
their calculations.

Or put another way, the filesystem should not expose its concrete
implementation details through such an abstract interface.

> Just put a prominent notice that the user needs to remember to
> factor their choice of redundancy et al into the numbers.

Why, when the filesystem knows that choice and can factor it into the
numbers for us?

Also, struct statvfs has no "prominent notice" field.  ;)

> (5c) If your metadata rate is different than your data rate, then there=
=20
> is _absolutely_ no way to _programatically_ predict how the data _might_=
=20
> be used, and this is the _default_ usage model. Literally the hardest=20
> model is the normal model. There is actually no predictive solution. So=
=20

We only need the worst-case prediction for f_bavail, and that is the
lower of two numbers that we certainly can calculate.

> "Blocks available to unprivileged users" is the only tricky one.[...]
> Fortunately (or hopefully) that's not the datum /bin/df usually returns.

I think you'll find that f_bavail *is* the datum /bin/df usually returns.
If you want f_bfree you need to use 'stat -f' or roll your own df.

--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlSTnEMACgkQgfmLGlazG5wQCQCfXBxAO/gWNHWTeJvgJOUCdzhK
JYcAoNWKaayj3urmf0Idzsu3PyYfqZ7u
=D35i
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--
