Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:36214 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbbGSHXq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Jul 2015 03:23:46 -0400
Date: Sun, 19 Jul 2015 03:23:45 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Strange data backref offset?
Message-ID: <20150719072344.GA22025@hungrycats.org>
References: <55A86AA8.6010404@cn.fujitsu.com>
 <20150718113412.GA11450@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
In-Reply-To: <20150718113412.GA11450@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 18, 2015 at 07:35:31PM +0800, Liu Bo wrote:
> On Fri, Jul 17, 2015 at 10:38:32AM +0800, Qu Wenruo wrote:
> > Hi all,
> >=20
> > While I'm developing a new btrfs inband dedup mechanism, I found btrfsc=
k and
> > kernel doing strange behavior for clone.
> >=20
> > [Reproducer]
> > # mount /dev/sdc -t btrfs /mnt/test
> > # dd if=3D/dev/zero of=3D/mnt/test/file1 bs=3D4K count=3D4
> > # sync
> > # ~/xfstests/src/cloner -s 4096 -l 4096 /mnt/test/file1 /mnt/test/file2
> > # sync
> >=20
> > Then btrfs-debug-tree gives quite strange result on the data backref:
> > ------
> > <EXTENT TREE>
> >         item 4 key (12845056 EXTENT_ITEM 16384) itemoff 16047 itemsize =
111
> >                 extent refs 3 gen 6 flags DATA
> >                 extent data backref root 5 objectid 257 offset 0 count 1
> >                 extent data backref root 5 objectid 258 offset
> > 18446744073709547520 count 1
> >=20
> > <FS TREE>
> >         item 8 key (257 EXTENT_DATA 0) itemoff 15743 itemsize 53
> >                 extent data disk byte 12845056 nr 16384
> >                 extent data offset 0 nr 16384 ram 16384
> >                 extent compression 0
> >         item 9 key (257 EXTENT_DATA 16384) itemoff 15690 itemsize 53
> >                 extent data disk byte 12845056 nr 16384
> >                 extent data offset 4096 nr 4096 ram 16384
> >                 extent compression 0
> > ------
> >=20
> > The offset is file extent's key.offset - file exntent's offset,
> > Which is 0 - 4096, causing the overflow result.
> >=20
> > Kernel and fsck all uses that behavior, so fsck can pass the strange th=
ing.
> >=20
> > But shouldn't the offset in data backref matches with the key.offset of=
 the
> > file extent?
> >=20
> > And I'm quite sure the change of behavior can hugely break the fsck and
> > kernel, but I'm wondering is this a known BUG or feature, and will it be
> > handled?
>=20
> Also found this before, one of the benefits is to save metadata in extent
> tree, that is, if we overwrite inside an extent, the extent ref count
> increases to 2 since both use (key.offset - extent_offset).
>=20
> 0k                  12k
> |-------------------|
>      |--------|
>      4k       8k
>=20
> one EXTENT_DATA item is 0k and the other one is 8k, the corresponding
> refs will be (0k - 0) and (8k - 8k).
>=20
> It's a format change so it won't be easy to make a change.  I'd prefer a
> workaround on clone side.

The workaround for dedup currently involves copying data.  It could be
done by manipulating the metadata directly, but btrfs doesn't seem to
provide this.

Suppose our dedup engine has identified duplicate blocks in distinct
extents, and we want to replace them by cloning:

0k                  12k
|AAAAABBBBBBBBCCCCCC|     <- file #1 extent #1
     |BBBBBBBB|           <- file #2 extent #2
     4k       8k

If we clone the "B" part of extent #1 over extent #2, we save one block
by eliminating the last reference to extent #2; however, if file #1 is
later deleted, we waste 8K.  File #2 will refer to only 4K out of extent
#1's 12K.  Any further clones of file #2 will add references to this
12K extent.  The 8K of wasted data cannot be accessed from userspace,
so it's unavailable for allocation and can't be reused by future clones.

Assuming dedup finds many further copies of the "B" data, and they're
all replaced by clones referring to the "B" blocks of extent #1, those
8K are effectively wasted forever.  If extent #1 is larger (up to 1GB),
more space is wasted.  The only way to get the space back after this
failure is to locate every reference to extent #1 in the entire filesystem
(i.e. every instance of the "B" data) and delete it.

0k                  12k
|AAAAABBBBBBBBCCCCCC|     <- file #1 extent #1, "B" shared with file #2
 aaaa|BBBBBBBB|ccccc      <- file #2 "a" and "c" blocks referenced
     4k       8k             but not used (i.e. wasted) in file #2

If we clone extent #2 over extent #1, we avoid the above problem, but
we save nothing.  The refs to extent #1 from file #1 will keep the "B"
blocks from extent #1 on disk even though they are not accessible:

0k   /bbbbbbbb\     12k   <- file #1 unused blocks from extent #1
|AAAA|^wasted^|CCCCC|     <- file #1 blocks "A" and "C" from extent #1
     \BBBBBBBB/           <- file #1 blocks "B" from extent #2
     |BBBBBBBB|           <- file #2 extent #2 shared with file #1
     4k       8k

If extent #2 is larger than 4K, but only 4K of data is duplicate, then
we get the same result as when we replaced extent #2 with a clone of
part of extent #1:  wasted space.

A few popular block values on a filesystem can end up being duplicated
thousands of times, so we can't afford to just ignore them.  Such blocks
are usually part of much larger extents where the extents as a whole are
unique, so we can't get rid of the duplicate blocks without modifying
the extent boundaries.

Dedup has to replace extent #1 (and in some cases also extent #2) with
up to three new extents so that all duplicate extents have matching
boundaries before cloning:

0k                  12k   <- file #1 extent #1 deleted
|AAAA|BBBBBBBB|CCCCC|     <- file #1 extent #3, #4, #5
     |BBBBBBBB|           <- file #2 extent #2
     4k       8k          <- extent boundaries around "B" aligned

Then we can clone extent #2 from file #2 over extent #4 in file #1:

0k                  12k   <- file #1 is now extents #3, #2, #5
|AAAA|BBBBBBBB|CCCCC|     <- replace extent #4 with clone of #2
     |BBBBBBBB|           <- file #2 extent #2 shared with file #1
     4k       8k          <- no wasted space in either file

Since we are just deleting extent #4 in this case, we didn't have to
bother creating it.  An optimized implementation could skip that step.
A differently optimized implementation keeps #4 but deletes #2 because
then file #1 can be read with fewer seeks:

0k                  12k   <- file #1 data physically contiguous
|AAAA|BBBBBBBB|CCCCC|     <- file #1 is now extents #3, #4, #5
     |BBBBBBBB|           <- file #2 extent #4 shared with file #1
     4k       8k          <- file #2 extent #2 replaced by extent #4

Both extents might have other shared references.  When any extent is
split up, all references to the extent have to be split the same way.

How do we split extents into smaller pieces?  Copy the contents to
multiple new extents, then use those new extents to replace the original
extent along the same boundaries as the duplicate data block ranges.

Currently a user-space dedup agent has to rely on ioctls like
FILE_EXTENT_SAME and DEFRAG_RANGE to provide the required atomic
copy-and-replace semantics, and FIEMAP to discover where existing
extent boundaries are.  FIEMAP doesn't provide a complete picture of the
underlying extent structure--in particular, FIEMAP does not tell us when
a logical extent boundary does not match a btrfs physical extent boundary
and a split is required.  DEFRAG_RANGE refuses to split some contiguous
extents into smaller, non-contiguous extents, and even when it does,
there are other heuristics in btrfs that reassemble the carefully sized
smaller extents back into useless larger ones.  FILE_EXTENT_SAME doesn't
split physical extents when it needs to--it just creates broken shared
extent references with all the problems described above.

Copying the data to multiple temporary files in user-space (so they
can't be coalesced into larger extents) seems to create the split extents
required, and FILE_EXTENT_SAME can be used to atomically splice the new
extents back into the original files, replacing the original extents.
Userspace is left to find all the refs itself--there are several ways to
do that with various time/space/complexity trade-offs.  It's _possible_
to implement a working dedup in userspace now, but it's not easy to get
every corner case right.

It's a little easier in the kernel.  FILE_EXTENT_SAME could split
extents as required, and use a non-broken internal implementation
of DEFRAG_RANGE that doesn't refuse to copy data it was asked to.
A flag can be added somewhere to disable the heuristics that coalesce
consecutive extents together when those extents are intentionally split,
but preserve the existing behavior of coalescing consecutive duplicate
extents when they are the maximum length accepted by FILE_EXTENT_SAME.
The kernel can chase all the extent backrefs more easily and completely
than userspace can.  An in-kernel dedup might even be able to make wasted
blocks accessible again if their contents should reappear in new files.

On a heavily defragmented filesystem the data copy required could be a
little under 2GB for a single pair of cloned ranges (in the worst case
of 4K cloned in two maximum-sized extents).  Currently FILE_EXTENT_SAME
refuses to do work involving more than 32MB of reads for a single
extent pair.  There's a pretty big gap between 32MB of reads and 4GB of
reads _and_ writes.  FILE_EXTENT_SAME also takes a vector of extents,
which multiply the work.

It would be better if the kernel could manipulate the metadata directly to
split extents.  Dedup does work now with copies, but quite inefficiently.

> Thanks,
>=20
> -liubo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlWrUIAACgkQgfmLGlazG5yVJACeLws+js7x1SciEwoSGO2i34Za
KEwAn14nnvqEuX45Yd4dsrFc1CrN+T2M
=G9hp
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
