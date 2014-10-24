Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:46103 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755127AbaJXCfa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Oct 2014 22:35:30 -0400
Date: Thu, 23 Oct 2014 22:35:29 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: device balance times
Message-ID: <20141024023529.GD17395@hungrycats.org>
References: <845c0ca8cc78ed97da487bf7f4b7b122@admin.virtall.com>
 <5446BEC0.8070009@siedziba.pl>
 <02A17DFE-290C-4447-99E9-D39480D7A26A@colorremedies.com>
 <5447A5CF.9060405@siedziba.pl>
 <5448C81E.4060701@cn.fujitsu.com>
 <5448E8F0.7070004@gmail.com>
 <pan$d3176$38668d14$9f498698$7cd4113f@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J5MfuwkIyy7RmF4Q"
In-Reply-To: <pan$d3176$38668d14$9f498698$7cd4113f@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--J5MfuwkIyy7RmF4Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 24, 2014 at 01:05:39AM +0000, Duncan wrote:
> Austin S Hemmelgarn posted on Thu, 23 Oct 2014 07:39:28 -0400 as
> excerpted:
>=20
> > On 2014-10-23 05:19, Miao Xie wrote:
> >>
> >> Now my colleague and I is implementing the scrub/replace for RAID5/6
> >> and I have a plan to reimplement the balance and split it off from the
> >> metadata/file data process. the main idea is
> >> - allocate a new chunk which has the same size as the relocated one,
> >>   but don't insert it into the block group list, so we don't allocate
> >>   the free space from it.
> >> - set the source chunk to be Read-only
> >> - copy the data from the source chunk to the new chunk
> >> - replace the extent map of the source chunk with the one of the new
> >>   chunk(The new chunk has the same logical address and the length as
> >>   the old one)
> >> - release the source chunk
> >>
> >> By this way, we needn't deal the data one extent by one extent, and
> >> needn't do any space reservation, so the speed will be very fast even
> >> [if] we have lots of snapshots.
> >>
> > Even if balance gets re-implemented this way, we should still provide
> > some way to consolidate the data from multiple partially full chunks.
> > Maybe keep the old balance path and have some option (maybe call it
> > aggressive?) that turns it on instead of the new code.
>=20
> IMO:
>=20
> * Keep normal default balance behavior as-is.
>=20
> * Add two new options, --fast, and --aggressive.
>=20
> * --aggressive behaves as today and is the normal default.
>=20
> * --fast is the new chunk-by-chunk behavior.  This becomes the default if=
=20
> the convert filter is used, or if balance detects that it /is/ changing=
=20
> the mode, thus converting or filling in missing chunk copies, even when=
=20
> the convert filter was not specifically set.  Thus, if there's only one=
=20
> chunk copy (single or raid0 mode, or raid1/10 or dup with a missing/
> invalid copy) and the balance would result in two copies, default to
> --fast.  Similarly, if it's raid1/10 and switching to single/raid0,=20
> default to --fast.  If no conversion is being done, keep the normal
> --aggressive default.

My pet peeve:  if balance is converting profiles from RAID1 to single,
the conversion should be *instantaneous* (or at least small_constant *
number_of_block_groups).  Pick one mirror, keep all the chunks on that
mirror, delete all the corresponding chunks on the other mirror.

Sometimes when a RAID1 mirror dies we want to temporarily convert
the remaining disk to single data / DUP metadata while we wait for
a replacement.  Right now if we try to do this, we discover:

	- if the system reboots during the rebalance, btrfs now sees a
	mix of single and RAID1 data profiles on the disk.  The rebalance
	takes a long time, and a hardware replacement has been ordered,
	so the probability of this happening is pretty close to 1.0.

	- one disk is missing, so there's a check in the mount code path
	that counts missing disks like this:

		- RAID1 profile: we can tolerate 1 missing disk so just
		mount rw,degraded

		- single profile: we can tolerate zero missing disks,
		so we don't allow rw mounts even if degraded.

That filesystem is now permanently read-only (or at least it was in 3.14).
It's not even possible to add or replace disks any more since that
requires mounting the filesystem read-write.

> * Users could always specify the behavior they want, overriding the=20
> default, using the appropriate option.
>=20
> * Of course defaults may result in some chunks being rebalanced in fast=
=20
> mode, while others are rebalanced in aggressive mode, if for instance=20
> it's 3+ device raid1 mode filesystem with one device missing, since in=20
> that case there'd be the usual two copies of some chunks and those would=
=20
> default to aggressive, while there'd be one copy of chunks where the=20
> other one was on the missing device.  However, users could always specify=
=20
> the desired behavior using the last point above, thus getting the same=20
> behavior for the entire balance.
>=20
> --=20
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--J5MfuwkIyy7RmF4Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlRJuvEACgkQgfmLGlazG5zM/gCg1rZtD1WbnP7cwZfJNNXD8GKa
xQUAoIvQpDhGfw1JS8QilfHRXdwxcUCv
=P5N5
-----END PGP SIGNATURE-----

--J5MfuwkIyy7RmF4Q--
