Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:40832 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbeHWUPL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Aug 2018 16:15:11 -0400
Date: Thu, 23 Aug 2018 12:44:36 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Reproducer for "compressed data + hole data corruption bug, 2018
 editiion"
Message-ID: <20180823164436.GG13528@hungrycats.org>
References: <20180823031125.GE13528@hungrycats.org>
 <8273c186-50ec-32d8-ffb3-23bb0b4fe48e@gmx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="lHGcFxmlz1yfXmOs"
In-Reply-To: <8273c186-50ec-32d8-ffb3-23bb0b4fe48e@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--lHGcFxmlz1yfXmOs
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 23, 2018 at 01:10:48PM +0800, Qu Wenruo wrote:
> On 2018/8/23 =E4=B8=8A=E5=8D=8811:11, Zygo Blaxell wrote:
> > This is a repro script for a btrfs bug that causes corrupted data reads
> > when reading a mix of compressed extents and holes.  The bug is
> > reproducible on at least kernels v4.1..v4.18.
>=20
> This bug already sounds more serious than previous nodatasum +
> compression bug.

Maybe.  "compression + holes corruption bug 2017" could be avoided with
the max-inline=3D0 mount option without disabling compression.  This time,
the workaround is more intrusive:  avoid all applications that use dedup
or hole-punching.

> > Some more observations and background follow, but first here is the
> > script and some sample output:
> >=20
> > 	root@rescue:/test# cat repro-hole-corruption-test
> > 	#!/bin/bash
> >=20
> > 	# Write a 4096 byte block of something
> > 	block () { head -c 4096 /dev/zero | tr '\0' "\\$1"; }
> >=20
> > 	# Here is some test data with holes in it:
> > 	for y in $(seq 0 100); do
> > 		for x in 0 1; do
> > 			block 0;
> > 			block 21;
> > 			block 0;
> > 			block 22;
> > 			block 0;
> > 			block 0;
> > 			block 43;
> > 			block 44;
> > 			block 0;
> > 			block 0;
> > 			block 61;
> > 			block 62;
> > 			block 63;
> > 			block 64;
> > 			block 65;
> > 			block 66;> 		done
>=20
> Does the content has any difference on this bug?
> It's just 16 * 4K * 2 * 101 data write *without* any hole so far.

The content of the extents doesn't seem to matter, other than it needs to
be compressible so that the extents on disk are compressed.  The bug is
also triggered by writing non-zero data to all blocks, and then punching
the holes later with "fallocate -p -l 4096 -o $(( insert math here ))".

The layout of the extents matters a lot.  I have to loop hundreds or
thousands of times to hit the bug if the first block in the pattern is
not a hole, or if the non-hole extents are different sizes or positions
than above.

I tried random patterns of holes and extent refs, and most of them have
an order of magnitude lower hit rates than the above.  This might be due
to some relationship between the alignment of read() request boundaries
with extent boundaries, but I haven't done any tests designed to detect
such a relationship.

In the wild, corruption happens on some files much more often than others.
This seems to be correlated with the extent layout as well.

I discovered the bug by examining files that were intermittently but
repeatedly failing routine data integrity checks, and found that in every
case they had similar hole + extent patterns near the point where data
was corrupted.

I did a search on some big filesystems for the
hole-refExtentA-hole-refExtentA pattern and found several files with
this pattern that had passed previous data integrity checks, but would
fail randomly in the sha1sum/drop-caches loop.

> This should indeed cause 101 128K compressed data extent.
> But I'm wondering the description about 'holes'.

The holes are coming, wait for it... ;)

> > 	done > am
> > 	sync
> >=20
> > 	# Now replace those 101 distinct extents with 101 references to the fi=
rst extent
> > 	btrfs-extent-same 131072 $(for x in $(seq 0 100); do echo am $((x * 13=
1072)); done) 2>&1 | tail
>=20
> Will this bug still happen by creating one extent and then reflink it
> 101 times?

Yes.  I used btrfs-extent-same because a binary is included in the
Debian duperemove package, but I use it only for convenience.

It's not necessary to have hundreds of references to the same extent--even
two refs to a single extent plus a hole can trigger the bug sometimes.
100 references in a single file will trigger the bug so often that it
can be detected within the first 20 sha1sum loops.

When the corruption occurs, it affects around 90 of the original 101
extents.  The different sha1sum results are due to different extents
giving bad data on different runs.

> > 	# Punch holes into the extent refs
> > 	fallocate -v -d am
>=20
> Hole-punch in fact happens here.
>=20
> BTW, will add a "sync" here change the result?

No.  You can reboot the machine here if you like, it does not change
anything that happens during reads later.

Looking at the extent tree in btrfs-debug-tree, the data on disk
looks correct, and btrfs does read it correctly most of the time (the
correct sha1sum below is 6926a34e0ab3e0a023e8ea85a650f5b4217acab4).
The corruption therefore comes from btrfs read() producing incorrect
data in some instances.

> > 	# Do some other stuff on the machine while this runs, and watch the sh=
a1sums change!
> > 	while :; do echo $(sha1sum am); sysctl -q vm.drop_caches=3D{1,2,3}; sl=
eep 1; done
> >=20
> > 	root@rescue:/test# ./repro-hole-corruption-test
> > 	i: 91, status: 0, bytes_deduped: 131072
> > 	i: 92, status: 0, bytes_deduped: 131072
> > 	i: 93, status: 0, bytes_deduped: 131072
> > 	i: 94, status: 0, bytes_deduped: 131072
> > 	i: 95, status: 0, bytes_deduped: 131072
> > 	i: 96, status: 0, bytes_deduped: 131072
> > 	i: 97, status: 0, bytes_deduped: 131072
> > 	i: 98, status: 0, bytes_deduped: 131072
> > 	i: 99, status: 0, bytes_deduped: 131072
> > 	13107200 total bytes deduped in this operation
> > 	am: 4.8 MiB (4964352 bytes) converted to sparse holes.
> > 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > 	072a152355788c767b97e4e4c0e4567720988b84 am
> > 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > 	bf00d862c6ad436a1be2be606a8ab88d22166b89 am
> > 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > 	0d44cdf030fb149e103cfdc164da3da2b7474c17 am
> > 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > 	60831f0e7ffe4b49722612c18685c09f4583b1df am
> > 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > 	a19662b294a3ccdf35dbb18fdd72c62018526d7d am
> > 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > 	6926a34e0ab3e0a023e8ea85a650f5b4217acab4 am
> > 	^C
>=20
> It looks like we have something wrong interpreting file extent, maybe
> related to extent map merging.
>=20
> BTW, if without dropping page cache and no read corruption happens, it
> would limit the range of problem we're looking for.

The page cache drop makes reproduction easier/faster.  If you don't drop
caches, you have to wait for the data to be evicted from page cache or
the data from read() will not change.

In the wild, if I do a sha1sum loop on a few hundred GB of data known
to have the hole-extent-hole pattern (so the pages are evicted between
sha1sum runs), I see similar results without explicitly dropping caches.

If you read the file with a cold cache from two processes at once
(e.g. you run 'hd am' while the sha1sum/drop-cache loop is running)
the data changes faster (different on 90% of reads instead of just 20%).

> Thanks,
> Qu
>=20
> >=20
> > Corruption occurs most often when there is a sequence like this in a fi=
le:
> >=20
> > 	ref 1: hole
> > 	ref 2: extent A, offset 0
> > 	ref 3: hole
> > 	ref 4: extent A, offset 8192
> >=20
> > This scenario typically arises due to hole-punching or deduplication.
> > Hole-punching replaces one extent ref with two references to the same
> > extent with a hole between them, so:
> >=20
> > 	ref 1:  extent A, offset 0, length 16384
> >=20
> > becomes:
> >=20
> > 	ref 1:  extent A, offset 0, length 4096
> > 	ref 2:  hole, length 8192
> > 	ref 3:  extent A, offset 12288, length 4096
> >=20
> > Deduplication replaces two distinct extent refs surrounding a hole with
> > two references to one of the duplicate extents, turning this:
> >=20
> > 	ref 1:  extent A, offset 0, length 4096
> > 	ref 2:  hole, length 8192
> > 	ref 3:  extent B, offset 0, length 4096
> >=20
> > into this:
> >=20
> > 	ref 1:  extent A, offset 0, length 4096
> > 	ref 2:  hole, length 8192
> > 	ref 3:  extent A, offset 0, length 4096
> >=20
> > Compression is required (zlib, zstd, or lzo) for corruption to occur.
> > I am not able to reproduce the issue with an uncompressed extent nor
> > have I observed any such corruption in the wild.
> >=20
> > The presence or absence of the no-holes filesystem feature has no effec=
t.
> >=20
> > Ordinary writes can lead to pairs of extent references to the same exte=
nt
> > separated by a reference to a different extent; however, in this case
> > there is data to be read from a real extent, instead of pages that have
> > to be zero filled from a hole.  If ordinary non-hole writes could trigg=
er
> > this bug, every page-oriented database engine would be crashing all the
> > time on btrfs with compression enabled, and it's unlikely that would not
> > have been noticed between 2015 and now.  An ordinary write that splits
> > an extent ref would look like this:
> >=20
> > 	ref 1:  extent A, offset 0, length 4096
> > 	ref 2:  extent C, offset 0, length 8192
> > 	ref 3:  extent A, offset 12288, length 4096
> >=20
> > Sparse writes can lead to pairs of extent references surrounding a hole;
> > however, in this case the extent references will point to different
> > extents, avoiding the bug.  If a sparse write could trigger the bug,
> > the rsync -S option and qemu/kvm 'raw' disk image files (among many
> > other tools that produce sparse files) would be unusable, and it's
> > unlikely that would not have been noticed between 2015 and now either.
> > Sparse writes look like this:
> >=20
> > 	ref 1:  extent A, offset 0, length 4096
> > 	ref 2:  hole, length 8192
> > 	ref 3:  extent B, offset 0, length 4096
> >=20
> > The pattern or timing of read() calls seems to be relevant.  It is very
> > hard to see the corruption when reading files with 'hd', but 'cat | hd'
> > will see the corruption just fine.  Similar problems exist with 'cmp'
> > but not 'sha1sum'.  Two processes reading the same file at the same time
> > seem to trigger the corruption very frequently.
> >=20
> > Some patterns of holes and data produce corruption faster than others.
> > The pattern generated by the script above is based on instances of
> > corruption I've found in the wild, and has a much better repro rate than
> > random holes.
> >=20
> > The corruption occurs during reads, after csum verification and before
> > decompression, so btrfs detects no csum failures.  The data on disk
> > seems to be OK and could be read correctly once the kernel bug is fixed.
> > Repeated reads do eventually return correct data, but there is no way
> > for userspace to distinguish between corrupt and correct data reliably.
> >=20
> > The corrupted data is usually data replaced by a hole or a copy of other
> > blocks in the same extent.
> >=20
> > The behavior is similar to some earlier bugs related to holes and
> > Compressed data in btrfs, but it's new and not fixed yet--hence,
> > "2018 edition."
> >=20
>=20




--lHGcFxmlz1yfXmOs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCW37kcgAKCRCB+YsaVrMb
nKx+AJ9d45J55/GDaiLAJhYUXtpiFizHdQCg1nDqiUe4hFW0iyq9M/9VPahF7Fg=
=3gRi
-----END PGP SIGNATURE-----

--lHGcFxmlz1yfXmOs--
