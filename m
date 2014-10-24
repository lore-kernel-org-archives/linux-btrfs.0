Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:35142 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752843AbaJXQHF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Oct 2014 12:07:05 -0400
Date: Fri, 24 Oct 2014 12:07:03 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Rich Freeman <r-btrfs@thefreemanclan.net>
Cc: Duncan <1i5t5.duncan@cox.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: device balance times
Message-ID: <20141024160703.GG17395@hungrycats.org>
References: <845c0ca8cc78ed97da487bf7f4b7b122@admin.virtall.com>
 <5446BEC0.8070009@siedziba.pl>
 <02A17DFE-290C-4447-99E9-D39480D7A26A@colorremedies.com>
 <5447A5CF.9060405@siedziba.pl>
 <5448C81E.4060701@cn.fujitsu.com>
 <5448E8F0.7070004@gmail.com>
 <pan$d3176$38668d14$9f498698$7cd4113f@cox.net>
 <20141024023529.GD17395@hungrycats.org>
 <CAGfcS_mVJ0WH0rootEHnXxgHVvRD+oYuF988ZLtV9OABM7x4JQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7lMq7vMTJT4tNk0a"
In-Reply-To: <CAGfcS_mVJ0WH0rootEHnXxgHVvRD+oYuF988ZLtV9OABM7x4JQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--7lMq7vMTJT4tNk0a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 24, 2014 at 06:58:25AM -0400, Rich Freeman wrote:
> On Thu, Oct 23, 2014 at 10:35 PM, Zygo Blaxell
> <ce3g8jdj@umail.furryterror.org> wrote:
> >
> >                 - single profile: we can tolerate zero missing disks,
> >                 so we don't allow rw mounts even if degraded.
>=20
> That seems like the wrong logic here.  By all means mount read-only by
> default for safety, but there should be a way to force a read-write
> mount on any filesystem, precisely because the RAID modes can be mixed
> and even if you lose two devices on a RAID1 system not ALL the data is
> lost if you have more than two drives.

I agree, but https://bugzilla.kernel.org/show_bug.cgi?id=3D60594 does not:

	Stefan Behrens 2013-08-23 13:42:16 UTC
	The way out is to mount read-only, copy the data aside and be
	happy that no data was lost.

	The #1 goal (IMO) is to avoid data loss. Therefore the filesystem
	goes read-only if less devices are functional for writing than
	required by the selected RAID levels. And in order to avoid
	the surprise of a filesystem going read-only 30 seconds after
	mounting it, this is also enforced at mount time. [...]

	We could also leave this as an option to the user "mount -o
	degraded-and-I-want-to-lose-my-data", but in my opinion the use
	case is very, very exceptional.

IMHO the use case is common any time restoring the entire filesystem
=66rom backups is inconvenient.  That covers a *lot* of users.  I never
have a machine with more than 50% of its raw disk space devoted to btrfs
because I need raw space on the disk to do mkfs+rsync from the broken
read-only btrfs filesystems.

Somewhere in the future for btrfs is online fsck; however, we're not there
yet.  The kernel still blows up over relatively minor structural errors.

FWIW I'd like to be able to mount a broken btrfs read-write, add more
storage (either grow existing disks or add new ones), and then use the new
storage as temporary space to build a cleaned copy of the old metadata
with unreachable or broken objects dropped (preferably leaving some
object behind that returns EIO when read, but can be written or deleted).
Once there is clean metadata, we can rebuild free space maps (possibly
collecting allocated orphan extents into lost+found), then the surviving
data can be rebalanced or moved fairly easily.  The grown/added disks
can be shrunk/removed at the end.

> By all means return an error when reading a file that is completely
> missing.  By all means have an extra fsck mode that goes ahead and
> deletes all the missing files (assuming it has metadata) or perhaps
> moves them all to a new "lost+notfound" subvolume or something.
>=20
> Indeed, if the lost device just happens to not actually contain any
> data you might be lucky and not lose any data at all when losing a
> single device in a filesystem that entirely uses the single profile.
> That would be a bit of an edge case though, but one that is
> automatically handled if you give the admin the ability to force
> read-write/etc.
>=20
> --
> Rich

--7lMq7vMTJT4tNk0a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlRKeScACgkQgfmLGlazG5zs5gCgwubYc890btMEvJUvGW6Q4BDl
/c0An0g92wni3NGKk1JrzhzPYDfwp1Zg
=Q13v
-----END PGP SIGNATURE-----

--7lMq7vMTJT4tNk0a--
