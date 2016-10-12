Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:45400 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-OK)
        by vger.kernel.org with ESMTP id S1750989AbcJLEid (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 00:38:33 -0400
Date: Wed, 12 Oct 2016 00:37:19 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Chris Murphy <lists@colorremedies.com>, Hugo Mills <hugo@carfax.org.uk>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Austin Hemmelgarn <ahferroin7@gmail.com>
Subject: Re: RAID system with adaption to changed number of disks
Message-ID: <20161012043718.GW21290@hungrycats.org>
References: <D379E551-1272-4548-9601-0CE4C1A8C012@unige.ch>
 <20161011160601.GI7683@carfax.org.uk>
 <CAJCQCtSY2Y5AsW2FC5FGP3x3Vaz6Y10=EbAE-0FKFQAqg0oGkg@mail.gmail.com>
 <3da9a459-c63b-570c-5b42-c7186b3a74fd@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="yPlaimQd/TpiYx8R"
In-Reply-To: <3da9a459-c63b-570c-5b42-c7186b3a74fd@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--yPlaimQd/TpiYx8R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 12, 2016 at 09:32:17AM +0800, Qu Wenruo wrote:
> >But consider the identical scenario with md or LVM raid5, or any
> >conventional hardware raid5. A scrub check simply reports a mismatch.
> >It's unknown whether data or parity is bad, so the bad data strip is
> >propagated upward to user space without error. On a scrub repair, the
> >data strip is assumed to be good, and good parity is overwritten with
> >bad.
>=20
> Totally true.
>=20
> Original RAID5/6 design is only to handle missing device, not rotted bits.

Missing device is the _only_ thing the current design handles.  i.e. you
umount the filesystem cleanly, remove a disk, and mount it again degraded,
and then the only thing you can safely do with the filesystem is delete
or replace a device.  There is also a probability of being able to repair
bitrot under some circumstances.

If your disk failure looks any different from this, btrfs can't handle it.
If a disk fails while the array is running and the filesystem is writing,
the filesystem is likely to be severely damaged, possibly unrecoverably.

A btrfs -dsingle -mdup array on a mdadm raid[56] device might have a
snowball's chance in hell of surviving a disk failure on a live array
with only data losses.  This would work if mdadm and btrfs successfully
arrange to have each dup copy of metadata updated separately, and one
of the copies survives the raid5 write hole.  I've never tested this
configuration, and I'd test the heck out of it before considering
using it.

> >So while I agree in total that Btrfs raid56 isn't mature or tested
> >enough to consider it production ready, I think that's because of the
> >UNKNOWN causes for problems we've seen with raid56. Not the parity
> >scrub bug which - yeah NOT good, not least of which is the data
> >integrity guarantees Btrfs is purported to make are substantially
> >negated by this bug. I think the bark is worse than the bite. It is
> >not the bark we'd like Btrfs to have though, for sure.
> >
>=20
> Current btrfs RAID5/6 scrub problem is, we don't take full usage of tree =
and
> data checksum.
[snip]

This leads directly to a variety of problems with the diagnostic tools,
e.g.  scrub reports errors randomly across devices, and cannot report the
path of files containing corrupted blocks if it's the parity block that
gets corrupted.

btrfs also doesn't avoid the raid5 write hole properly.  After a crash,
a btrfs filesystem (like mdadm raid[56]) _must_ be scrubbed (resynced)
to reconstruct any parity that was damaged by an incomplete data stripe
update.  As long as all disks are working, the parity can be reconstructed
=66rom the data disks.  If a disk fails prior to the completion of the
scrub, any data stripes that were written during previous crashes may
be destroyed.  And all that assumes the scrub bugs are fixed first.

If writes occur after a disk fails, they all temporarily corrupt small
amounts of data in the filesystem.  btrfs cannot tolerate any metadata
corruption (it relies on redundant metadata to self-repair), so when a
write to metadata is interrupted, the filesystem is instantly doomed
(damaged beyond the current tools' ability to repair and mount
read-write).

Currently the upper layers of the filesystem assume that once data
blocks are written to disk, they are stable.  This is not true in raid5/6
because the parity and data blocks within each stripe cannot be updated
atomically.  btrfs doesn't avoid writing new data in the same RAID stripe
as old data (it provides a rmw function for raid56, which is simply a bug
in a CoW filesystem), so previously committed data can be lost.  If the
previously committed data is part of the metadata tree, the filesystem
is doomed; for ordinary data blocks there are just a few dozen to a few
thousand corrupted files for the admin to clean up after each crash.

It might be possible to hack up the allocator to pack writes into empty
stripes to avoid the write hole, but every time I think about this it
looks insanely hard to do (or insanely wasteful of space) for data
stripes.


--yPlaimQd/TpiYx8R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlf9vf0ACgkQgfmLGlazG5zFxwCfXJZ55mQl0OzoVFfOSt+OwJDj
g9MAmgK6x48ywUhwmgl2c+JZbRUyN/ho
=dfDt
-----END PGP SIGNATURE-----

--yPlaimQd/TpiYx8R--
