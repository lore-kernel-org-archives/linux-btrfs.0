Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:37661 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S964929AbaLME20 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 23:28:26 -0500
Date: Fri, 12 Dec 2014 23:28:24 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Robert White <rwhite@pobox.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: mkfs.btrfs limits "odd" [and maybe a "failed" phantom device?]
Message-ID: <20141213042824.GC25614@hungrycats.org>
References: <5488C6CF.1080608@pobox.com>
 <20141212035651.GD22023@hungrycats.org>
 <548A84A2.4000501@pobox.com>
 <20141212164544.GB25614@hungrycats.org>
 <548B6BF6.2060306@pobox.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Clx92ZfkiYIKRjnr"
In-Reply-To: <548B6BF6.2060306@pobox.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Clx92ZfkiYIKRjnr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 12, 2014 at 02:28:06PM -0800, Robert White wrote:
> On 12/12/2014 08:45 AM, Zygo Blaxell wrote:
> >On Thu, Dec 11, 2014 at 10:01:06PM -0800, Robert White wrote:
> >>So RAID5 with three media M is
> >>
> >>M    MM   MMM
> >>D1   D2   P(a)
> >>D3   P(b) D4
> >>P(c) D5   D6
> >
> >RAID5 with two media is well defined, and looks like this:
> >
> >M    MM
> >D1   P(a)
> >P(b) D2
> >D3   P(c)
>=20
> Like I said in the other fork of this thread... I see (now) that the
> math works but I can find no trace of anyone having ever implemented
> this for arity less than 3 RAID greater than one paradigm (outside
> btrfs and its associated materials).

I've set up mdadm that way (though it does ask you to use '--force'
when you set it up).  mdadm will also ask for --force if you try to set
up RAID1 with one disk.

I don't know of a RAID implementation that _doesn't_ do these modes,
excluding a few ancient proprietary implementations which have no way to
change a layout once created (usually because they shoot themselves in
the foot with bad choices early on, e.g. by picking odd parity for RAID5).

The reason to allow it is future expansion:  below-3-disk RAID5 ensures
that you have the layout constraints *now* for stripe/chunk size so you
can add more disks later.  If RAID5 has a 512K chunk size, and you start
with a linear or RAID1 array and add another disk later, you might lose
part of the last 512K when you switch to RAID5.  So you start with RAID5
on one or two disks so you can scale up without losing any data.

Also, mdadm can grow a two-disk RAID5, but if you try to grow a two-disk
mdadm RAID1 you just get a three-disk RAID1 (i.e. two redudant copies
with no additional capacity).

btrfs doesn't really need this capability for expansion, since it can
just create new RAID5 profile chunks whenever it wants to; however, I'd
expect a complete btrfs RAID5 implementation to borrow some ideas from
ZFS, and dynamically change the number of disks per chunk to maintain
write integrity as drives are added/removed/missing.  That would imply
btrfs-RAID56 profile chunks would have to be able to exist on two or even
one disk, if that was all that was available for writing at the time.
Simply using btrfs-RAID1 chunks wouldn't work since they'd behave the
wrong way when more disks were added later.

> MEANWHILE
>=20
> the system really needs to be able to explicitly express and support
> the "missing" media paradigm.
>=20
>  M     x    MMM
>  D1    .    P(a)
>  D3    .    D4
>  P(c)  .    D6
>=20
> The correct logic here to "remove" (e.g. "replace with nothing"
> instead of "delete") a media just doesn't seem to exist. And it's
> already painfully missing in the RAID1 situation.

There are a number of permanent mistakes a naive admin can make when
dealing with a broken array.  I've destroyed arrays (made them permanently
read-only beyond the ability of btrfs kernel or user tools to recover)
by getting "add" and "replace" confused, or by allowing an offline drive
to rejoin an array that had been mounted read-write,degraded for some time.

The basic functionality works.  btrfs does track missing devices and
can replace them relatively quickly (not as fast as mdadm, but less
than an order of magnitude slower) in RAID1.  The reporting is full
of out-of-date cached data, but when a disk is really failing,
there is usually little doubt which one needs to be replaced.

> If I have a system with N SATA ports, and I have connected N drives,
> and device M is starting to fail... I need to be able to disconnect
> M and then connect M(new). Possibly with a non-trivial amount of
> time in there. For all RAID levels greater than zero this is a
> natural operation in a degraded mode. And for a nearly full
> filesystem the shrink operation that is btrfs device delete would
> not work. And for any nontrivially occupied fiesystem it would be
> way slow, and need to be reversed for another way-slow interval.
>=20
> So I need to be able to "replace" a drive with a "nothing" so that
> the number of active media becomes N-1 but the arity remains N.

btrfs already does that, but it sucks.  In a naive RAID5 implementation,
a write in degraded mode will corrupt your data if it is interrupted.
This is a general property of all RAID5 implementations that don't have
NVRAM journalling or some other way to solve the atomic update problem.

ZFS does this well:  when a device is missing, it leaves old data in
degraded mode, but writes new data striped across the existing disks
in non-degraded mode.  If you have 5 disks, and one dies, your writes
are then spread across 4 disks (3 data + parity) while your reads are
reconstructed from 4 disks (4 data + 1 parity - 1 missing).  This prevents
the degraded mode write data integrity problem.

When the dead disk is replaced you would have the 3 data + parity promoted
to 4 data + parity, or you can elect not to replace the dead disk and
get 3 data + party everywhere (with a loss of capacity).  btrfs could
presumably do that by allocating chunks with different raid56 parameters,
although in this early stage of implementation I'm not sure how much of
any of that has been done yet.

> mdadm has the "missing" keyword. the Device Mapper has the "zero"
> target.=20

dm also has the "ioerror" target, which is much better for this ("zero"
would allow reads to succeed, which is incorrect).  lvm2 uses "ioerror"
for missing pieces of broken LVs in partial mode.

> btrfs replace start /dev/sdc /dev/nothing /
> (time pases, physical device is removed and replace)
> btrfs replace start /dev/nothing /dev/sdc /

Why wouldn't you just remove the physical device (say device #2) and
then run:

	btrfs replace start 2 /dev/sdc /

?  The way it works now seems much less complicated than what you propose.

Granted, I have a feature request here:  we know the sizes of all the
missing disks, and we know the size of /dev/sdc, so why can't we just
write "missing" instead of "2" and have btrfs choose a missing device
to replace by itself?

> Now that's good-ish, but really the first replace is pernicious. The
> internal state for the filesystem should just be able to record that
> device id 3 (assuming /dev/sda is devid1 and b is 2 etc for this
> example) is just gone. The replace-with-nothing becomes more-or-less
> instant.

To clarify:  what is required here is the ability to quickly record that
the device's subuuid is no longer welcome in this filesystem, and never
will be.  Should it reappear in the future, it has to be excluded from
the btrfs.

The underlying physical device could return, but it would have to
be treated as a new empty device with a new subuuid, and its data
reconstructed by btrfs balance or btrfs replace.

This is because btrfs does really awful things when a filesystem gets
assembled out of mirrors of different vintages.  Before allowing writes
on a subset of the disks in a multi-disk btrfs, the disks that are written
have to agree that they are now the only disks that are currently members
of the filesystem.

> [The use of "device delete" and "device add" as changes in arity and
> size, and its inaplicability to cases where failure is being dealt
> with abent a change of arity, could be clearer in the
> documentation.]

Yes.  This is _not_ equivalent to a btrfs replace, although it is very
similar:

	btrfs device add /dev/sdc /
	btrfs device delete missing /

It can work--sometimes--but it needs a surprising amount of free space
(or multiple new drives).


--Clx92ZfkiYIKRjnr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlSLwGgACgkQgfmLGlazG5w4owCfZaco5qhdoUvVQ+IHQbJh6zIK
nLQAnjK/wjpFgbSGJePSt94MCvuxfX5t
=2JfA
-----END PGP SIGNATURE-----

--Clx92ZfkiYIKRjnr--
