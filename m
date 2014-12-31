Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:38335 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751424AbaLaAPP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Dec 2014 19:15:15 -0500
Date: Tue, 30 Dec 2014 19:15:14 -0500
From: Zygo Blaxell <zblaxell@furryterror.org>
To: Robert White <rwhite@pobox.com>
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Grzegorz Kowal <custos.mentis@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Standards Problems [Was: [PATCH v2 1/3] Btrfs: get more accurate
 output in df command.]
Message-ID: <20141231001514.GA13116@hungrycats.org>
References: <548E377D.6030804@cn.fujitsu.com>
 <548E7A7A.90505@pobox.com>
 <548E929B.2090203@pobox.com>
 <548E9B38.9080202@cn.fujitsu.com>
 <548EABBB.4060204@pobox.com>
 <548FA762.2070504@pobox.com>
 <549017E8.7060107@cn.fujitsu.com>
 <54908D8A.8040101@pobox.com>
 <54916B39.5080409@cn.fujitsu.com>
 <549252FF.10400@pobox.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
In-Reply-To: <549252FF.10400@pobox.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 17, 2014 at 08:07:27PM -0800, Robert White wrote:
>[...]

There are a number of pathological examples in here, but I think there
are justifiable correct answers for each of them that emerge from a
single interpretation of the meanings of f_bavail, f_blocks, and f_bfree.

One gotcha is that some of the numbers required may be difficult to
calculate precisely before all space is allocated to chunks; however,
some error is tolerable as long as free space is not overestimated.
In other words:  when in doubt, guess low.

statvfs(2) gives us six numbers, three of which are block counts.
Very few users or programs ever bother to look at the inode counts
(f_files, f_ffree, f_favail), but they could be overloaded for metadata
block counts.

The f_blocks parameter is mostly irrelevant to application behavior,
except to the extent that the ratio between f_bavail and f_blocks is
used by applications to calculate a percentage of occupied or free space.
f_blocks must always be greater than or equal to f_bavail and f_blocks,
and preferably f_blocks would be scaled to use the same effective unit
size as f_bavail and f_blocks within a percent or two.

Nobody cares about f_bfree since traditionally only root could use the
difference between f_bfree and f_bavail.  f_bfree is effectively space
conditionally available (e.g. if the process euid is root or the process
egid matches a configured group id), while f_bavail is space available
without conditions (e.g. processes without privilege can use it).

The most important number is f_bavail.  It's what a bunch of software
(archive unpackers, assorted garbage collectors, email MTAs, snapshot
remover scripts, download managers, etc) uses to estimate how much space
is available without conditions (except quotas, although arguably those
should be included too).  Applications that are privileged still use
the unprivileged f_bavail number so their decisions based on free space
don't disrupt unprivileged applications.

It's generally better to underestimate than to overestimate f_bavail.
Historically filesystems have reserved extra space to avoid various
problems in low-disk conditions, and application software has adapted
to that well over the years.  Also, admin people are more pleasantly
surprised when it turns out that they had more space than f_bavail,
instead of when they had less.

The rule should be:  if we have some space, but it is not available for
data extents in the current allocation mode, don't add it to f_bavail
in statvfs.  I think this rule handles all of these examples well.

That would mean that we get cases where we add a drive to a full
filesystem and it doesn't immediately give you any new f_bavail space.
That may be an unexpected result for a naive admin, but much less
unexpected than having all the new space show up in f_bavail when it
is not available for allocation in the current data profile!  Better
to have the surprising behavior earlier than later.

On to examples...

> But a more even case is downright common and likely. Say you run a
> nice old-fashoned MUTT mail-spool. "most" of your files are small
> enough to live in metadata. You start with one drive. and allocate 2
> single-data and 10 metatata (5xDup). Then you add a second drive of
> equal size. (the metadata just switched to DUP-as-RAID1-alike mode)
> And then you do a dconvert=3Draid0.
>=20
> That uneven allocation of metadata will be a 2GiB difference between
> the two drives forever.

> So do you shave 2GiB off of your @size?

Yes.  f_blocks is the total size of all allocated chunks plus all free
space allocated by the current data profile.  That 2GiB should disappear
=66rom such a calculation.

> Do you shave @2GiB off your @available?

Yes, because it's _not_ available until something changes to make it
available (e.g. balance to get rid of the dup metadata, change the
metadata profile to dup or single, or change the data profile to single).

The 2GiB could be added to f_bfree, but that might still be confusing
for people and software.

> Do you overreport your available by @2GiB and end up _still_ having
> things "available" when you get your ENOSPC?

No.  ENOSPC when f_bavail > 0 is very bad.  Low-available-space admin
alerts will not be triggered.  Automated mitigation software will not be
activated.  Service daemons will start transactions they cannot complete.

> How about this ::
>=20
> /dev/sda =3D=3D |Sf|Sf|Mf|Mf|Mf|Mf|Sf|Sf|Sp|Mp|Mp| .5GiB free|
> /dev/sdb =3D=3D |10 GiB free                                 |
>=20
> Operator fills his drive, then adds a second one, then _foolishly_
> tries to convert it to RAID0 when the power fails. In order to check
> the FS he boots with no_balance. Then his maintenance window closes
> and he has to go back into production, at which point he forgets (or
> isn't allowed) to do the balance. The flags are set but now no more
> extents can be allocated.
>=20
> Size is 20GiB, slack is 10.5GiB. Operator is about to get ENOSPACE.

f_bavail should be 0.5GB or so.  Operator is now aware that ENOSPC is
imminent, and can report to whoever grants permission to do things that
the machine will be continuing to balance outside of the maintenance
window.  This is much better than the alternative, which is that the
lack of available space is detected by application failure outside of
a maintenance window.

Even better:  if f_bavail is reflective of reality, the operator can
minimize out-of-window balance time by monitoring f_bavail and pausing
the balance when there is enough space to operate without ENOSPC until
the next maintenance window.

> Yes a balance would fix it, but that's not the question.

The question is "how much space is available at this time?" and the
correct answer is "almost none," and it stays that way until and unless
someone runs a balance, adds more drives, deletes a lot of data, etc.

balance changes the way space will be allocated, so it also changes
the output of df to match.

> In the meantime what does your patch report?

It should report that there's almost no available space.
If the patch doesn't report that, the patch needs rework.

> Or...
>=20
> /dev/sda =3D=3D |Sf|Sf|Mf|Mf|Mf|Mf|Sf|Sf|Sp|Mp|Mp| .5GiB free|
> /dev/sdb =3D=3D |10 GiB free                                 |
> /dev/sdc =3D=3D |10 GiB free                                 |
>=20
> Does a -dconvert=3Draid5 and immediately gets ENOSPC for all the
> blocks. According to the flags we've got 10GiB free...

10.5GiB is correct:  1.0GiB in a 3-way RAID5 on sd[abc] (2x 0.5GiB
data, 1x 0.5GiB parity), and 9.5GiB in a 2-way RAID5 (1x 9.5GiB data,
1x 9.5GiB parity) on sd[bc].  The current RAID5 implementation might
not use space that way, but if that's true, that's arguably a bug in
the current RAID5 implementation.

If it was -dconvert=3Draid6, there would be only 0.5GiB in f_bavail (1x
0.5GiB data, 2x 0.5GiB parity) since raid6 requires 3 disks per chunk.

> Or we end up with an egregious metadata history from lots of small
> files and we've got a perfectly fine RAID1 with several GiB of slack
> but none of that slack is 1GiB contiguous. All the slack has just
> come from reclaiming metadata.
>=20
> /dev/sda =3D=3D |Sf|Sf|Mp|Mp|Rx|Rx|Mp|Mp|Rx|Rx|Mp|Mp| N-free slack|
>=20
> (R =3D=3D reclaimed, e.g. avalable to extent-tree.c for allocation)
>=20
> We have a 1.5GB of "poisoned" space here; it can hold metadata but
> not data. So is that 1.5 in your @available calculation? How do you
> mark it up as used.

Overload f_favail to report metadata space maybe?  That's kind of ugly,
though, and nobody looks at f_favail anyway (or, everyone who looks at
f_favail is going to be aware enough to look at btrfs fi df too).

The metadata chunk free space could also go in f_bfree:  it's available
for use under some but not all conditions.

In all cases, leave such space out of f_bavail.  The space is only
available under some conditions, and f_bavail is effectively about space
available without conditions.  Space allocated to metadata-only chunks
should never be reported as available through f_bavail in statvfs.

Also note that if free space in metadata chunks could be limiting
allocations then it should be reported in f_bavail instead of free space
in data chunks.  That can be as simple as reporting the lesser of the two
numbers when there is no free space on the filesystem left to allocate
to chunks.

> And I've been ingoring the Mp(s) completely. What if I've got a good
> two GiB of partial space in the metadata, but that's all I've got.
> You write a file of any size and you'll get ENOSPC even though
> you've got that GiB.  Was it in @size? Is it in @avail?

@size should be the sum of the sizes of all allocated chunks in the
filesystem, and all free space as if it was allocated with the current
raid profile.  It should change if there was unallocated space and the
default profile changed, or if there was a balance converting existing
chunks to a new profile, or if disks were added or removed.

Don't report that GiB of metadata noise in f_bavail.  This may mean that
f_bavail is zero, but data can still be written in metadata chunks.
That's OK--f_bavail is an underestimate.

It's OK for the filesystem to report f_bavail =3D 0 but not ENOSPC--
people like storing bonus data without losing any "available" space,
and we really can't know whether that space is available until after
we've committed data to it.  Since we can't commit in advance, that
space isn't unconditionally available, and shouldn't be in f_bavail.

It's not OK to report ENOSPC when f_bavail > 0.  People hate failing to
store data when they appear to have "free" space.

> See you keep giving me these examples where the history of the
> filesystem is uniform. It was made a certain way and stayed that
> way. But in real life this sort of thing is going to happen and your
> patch simply report's a _different_ _wrong_ number. A _friendlier_
> wrong number, I'll grant you that, but still wrong.

Who cares if the number is wrong, as long as useful decisions can still be
made with it?  It doesn't have to be byte-accurate in all possible cases.

Existing software and admin practice is OK with underreporting free
space, but not overreporting it.  All the errors should be biased in
that direction.


--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlSjQBIACgkQgfmLGlazG5xw7ACglDpMDUPXAiEPA7X9uZ2so9UE
OrAAoIGeMfovS6tukoR4CLn8HPo/gPTQ
=HiCu
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
