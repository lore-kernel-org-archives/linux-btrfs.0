Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:46294 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750726AbeFADVF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 May 2018 23:21:05 -0400
Date: Thu, 31 May 2018 23:19:59 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Timofey Titovets <nefelim4ag@gmail.com>, darkbasic@linuxsystems.it,
        David Sterba <dsterba@suse.cz>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Any chance to get snapshot-aware defragmentation?
Message-ID: <20180601031959.GC22356@hungrycats.org>
References: <4428b2eb-796a-4c1b-8527-a05532436da4@linuxsystems.it>
 <20180518162051.GS6649@twin.jikos.cz>
 <99d57070-a1df-45ef-8f7e-df832bd7ad92@linuxsystems.it>
 <de7adf73-ba0b-9154-e3d1-b4e468ad3c96@gmail.com>
 <161bea23-f1ea-4f01-b3ea-2c5e706102a7@linuxsystems.it>
 <07cf6f9b-7d67-93b9-2a6f-6d031ccf5468@gmail.com>
 <b8ac31e3-7c9b-44a7-a286-08f1642e25c6@linuxsystems.it>
 <ebc2865d-2784-0be7-79e2-fe56b624baa5@gmail.com>
 <CAGqmi769vc7W=3WYeqss3_mit2tCNkjyAHVsq-Lhq+j-5XAr_Q@mail.gmail.com>
 <7ba873b7-48f3-ba2f-3e92-3a472e2d59f5@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="XMCwj5IQnwKtuyBG"
In-Reply-To: <7ba873b7-48f3-ba2f-3e92-3a472e2d59f5@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--XMCwj5IQnwKtuyBG
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 21, 2018 at 11:38:28AM -0400, Austin S. Hemmelgarn wrote:
> On 2018-05-21 09:42, Timofey Titovets wrote:
> > =D0=BF=D0=BD, 21 =D0=BC=D0=B0=D1=8F 2018 =D0=B3. =D0=B2 16:16, Austin S=
=2E Hemmelgarn <ahferroin7@gmail.com>:
> > > On 2018-05-19 04:54, Niccol=C3=B2 Belli wrote:
> > > > On venerd=C3=AC 18 maggio 2018 20:33:53 CEST, Austin S. Hemmelgarn =
wrote:
> > > > > With a bit of work, it's possible to handle things sanely.  You c=
an
> > > > > deduplicate data from snapshots, even if they are read-only (you =
need
> > > > > to pass the `-A` option to duperemove and run it as root), so it's
> > > > > perfectly reasonable to only defrag the main subvolume, and then
> > > > > deduplicate the snapshots against that (so that they end up all b=
eing
> > > > > reflinks to the main subvolume).  Of course, this won't work if y=
ou're
> > > > > short on space, but if you're dealing with snapshots, you should =
have
> > > > > enough space that this will work (because even without defrag, it=
's
> > > > > fully possible for something to cause the snapshots to suddenly t=
ake
> > > > > up a lot more space).
> > > >=20
> > > > Been there, tried that. Unfortunately even if I skip the defreg a s=
imple
> > > >=20
> > > > duperemove -drhA --dedupe-options=3Dnoblock --hashfile=3Drootfs.has=
h rootfs
> > > >=20
> > > > is going to eat more space than it was previously available (probab=
ly
> > > > due to autodefrag?).
> > > It's not autodefrag (that doesn't trigger on use of the EXTENT_SAME
> > > ioctl).  There's two things involved here:
> >=20
> > > * BTRFS has somewhat odd and inefficient handling of partial extents.
> > > When part of an extent becomes unused (because of a CLONE ioctl, or an
> > > EXTENT_SAME ioctl, or something similar), that part stays allocated
> > > until the whole extent would be unused.
> > > * You're using the default deduplication block size (128k), which is
> > > larger than your filesystem block size (which is at most 64k, most
> > > likely 16k, but might be 4k if it's an old filesystem), so deduplicat=
ing
> > > can split extents.
> >=20
> > That's a metadata node leaf !=3D fs block size.
> > btrfs fs block size =3D=3D machine page size currently.
> You're right, I keep forgetting about that (probably because BTRFS is pre=
tty
> much the only modern filesystem that doesn't let you change the block siz=
e).
> >=20
> > > Because of this, if a duplicate region happens to overlap the front of
> > > an already shared extent, and the end of said shared extent isn't
> > > aligned with the deduplication block size, the EXTENT_SAME call will
> > > deduplicate the first part, creating a new shared extent, but not the
> > > tail end of the existing shared region, and all of that original shar=
ed
> > > region will stick around, taking up extra space that it wasn't before.
> >=20
> > > Additionally, if only part of an extent is duplicated, then that area=
 of
> > > the extent will stay allocated, because the rest of the extent is sti=
ll
> > > referenced (so you won't necessarily see any actual space savings).
> >=20
> > > You can mitigate this by telling duperemove to use the same block size
> > > as your filesystem using the `-b` option.   Note that using a smaller
> > > block size will also slow down the deduplication process and greatly
> > > increase the size of the hash file.
> >=20
> > duperemove -b control "how hash data", not more or less and only support
> > 4KiB..1MiB
> And you can only deduplicate the data at the granularity you hashed it at.
> In particular:
>=20
> * The total size of a region being deduplicated has to be an exact multip=
le
> of the hash block size (what you pass to `-b`).  So for the default 128k
> size, you can only deduplicate regions that are multiples of 128k long
> (128k, 256k, 384k, 512k, etc).   This is a simple limit derived from how
> blocks are matched for deduplication.
> * Because duperemove uses fixed hash blocks (as opposed to using a rolling
> hash window like many file synchronization tools do), the regions being
> deduplicated also have to be exactly aligned to the hash block size.  So,
> with the default 128k size, you can only deduplicate regions starting at =
0k,
> 128k, 256k, 384k, 512k, etc, but not ones starting at, for example, 64k i=
nto
> the file.
> >=20
> > And size of block for dedup will change efficiency of deduplication,
> > when count of hash-block pairs, will change hash file size and time
> > complexity.
> >=20
> > Let's assume that: 'A' - 1KiB of data 'AAAA' - 4KiB with repeated patte=
rn.
> >=20
> > So, example, you have 2 of 2x4KiB blocks:
> > 1: 'AAAABBBB'
> > 2: 'BBBBAAAA'
> >=20
> > With -b 8KiB hash of first block not same as second.
> > But with -b 4KiB duperemove will see both 'AAAA' and 'BBBB'
> > And then that blocks will be deduped.
> This supports what I'm saying though.  Your deduplication granularity is
> bounded by your hash granularity.  If in addition to the above you have a
> file that looks like:
>=20
> AABBBAA
>=20
> It would not get deduplicated against the first two at either `-b 4k` or =
`-b
> 8k` despite the middle 4k of the file being an exact duplicate of the fin=
al
> 4k of the first file and first 4k of the second one.
>=20
> If instead you have:
>=20
> AABBBBBB
>=20
> And the final 6k is a single on-disk extent, that extent will get split w=
hen
> you go to deduplicate against the first two files with a 4k block size
> because only the final 4k can be deduplicated, and the entire 6k original
> extent will stay completely allocated.

It's the extent *ref* (in the subvol) that gets split.  The original
extent *data* (in the extent tree) is never modified, only deleted when
the last ref to any part of the extent data item is removed.  It looks
like there was intent in early btrfs to support splitting the extent data
too, but any code that might actually do that seems to have been removed
(among other things, there are gotchas with compression--you can't simply
truncate a compressed extent without modifying its data).

bees uses 4K block matching to find a common block in both extents, then
searches blocks adjacent to the matching blocks for more duplicates
until a complete extent is found.  This enables bees to ignore the
dedup-block-size/extent-size alignment problem.  This is similar to
a rolling hash window like rsync, but relying on slightly different
assumptions about how duplicate data is distributed through a typical
filesystem.  To get a bigger block size, bees discards block hashes
(e.g. 32K block size =3D 7 out of 8 4K block hashes discarded) because
bees can find a 32K contiguous duplicate extent with just one 4K hash.

bees replaces the entire extent ref containing a duplicate block with
reflinks to duplicate blocks in other extents.  If some blocks within
an extent are unique, bees creates a duplicate extent containing the
unique data, then dedups the new duplicate blocks over the old ones.
So if you have AABBBBB and AABBBCC, bees will make a copy of CC in a
new extent, then replace AABBBCC with reflinks to AABBB (from AABBBBB)
and the new CC.  This eliminates the entire original AABBBCC extent
=66rom the filesystem.  At the moment bees isn't very smart about that,
which results in increased fragmentation when deduping data with lots
of non-extent-aligned duplication, like VM images and ELF binaries.

In the future bees could combine short extents (not necessarily
duplicates) into larger ones as it goes, making it an integrated
dedup and defrag tool.  This would not really be snapshot-aware per
se--bees would be optimizing the layout of extent data items first,
then rewriting all of the extent ref (subvol/snapshot) trees to point
to the updated extent data items without having to care about whether
the original extent references come from snapshots, clones, or dedup.
I guess you could call that snapshot-agnostic, since a tool could do
this without an understanding of the snapshot concept at all.

Teaching bees that trick is a project I am working on *extremely*
slowly--it's practically a rewrite of bees, and $DAYJOB and home life
keep me stretched pretty thin these days.

> > Even, duperemove have 2 modes of deduping:
> > 1. By extents
> > 2. By blocks
> Yes, you can force it to not collapse runs of duplicate blocks into single
> extents, but that doesn't matter for this at all, you are still limited by
> your hash granularity.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--XMCwj5IQnwKtuyBG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCWxC7RQAKCRCB+YsaVrMb
nDaAAKCI+yVW4OR8py0l4edhZBTJKdmbTQCeLi79p/5yyQWR9VzFUTdujKH8mO0=
=2MzR
-----END PGP SIGNATURE-----

--XMCwj5IQnwKtuyBG--
