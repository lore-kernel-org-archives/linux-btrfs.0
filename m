Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:41786 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S934118AbaJ3PXG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Oct 2014 11:23:06 -0400
Date: Thu, 30 Oct 2014 11:23:05 -0400
From: Zygo Blaxell <zblaxell@furryterror.org>
To: Zack Coffey <tech42.clickwir@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: RAID1 fails to recover chunk tree
Message-ID: <20141030152259.GJ17395@hungrycats.org>
References: <544FFD52.6010604@gmail.com>
 <5451699B.4020507@pobox.com>
 <54517338.7090606@pobox.com>
 <54523D86.5040906@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CxDuMX1Cv2n9FQfo"
In-Reply-To: <54523D86.5040906@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--CxDuMX1Cv2n9FQfo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2014 at 09:30:46AM -0400, Zack Coffey wrote:
> Rob, That second drive was immediately put to use elsewhere. I
> figured having only the metadata on that drive, it wouldn't matter.
> The data stayed single and wasn't part of the second drive, only the
> metadata was. I must not be capable of understanding why that
> wouldn't work.
>=20
> I thought all I was doing was removing a duplication of metadata and
> the worst I would see is a message complaining about a drive
> missing.=20

There is a check at mount time that counts the number of disks and the
worst-case maximum number of missing disks for each profile.  That count
says "you have data in single profile, and single profile cannot lose
any disks, and you are missing one disk."  It doesn't check _where_
the data is on the disks.

The check prevents read-write mounting (and therefore balance, adding or
removing drives, resizing the filesystem so you can move the data to a
new LV on the same disk, btrfs send/receive, and any other way you could
fix the filesystem in-place).  As far as I know there is currently no
way to recover from this without writing some new code.  Your filesystem
is now permanently read-only.

If you wrote anything to the filesystem while the second disk was present,
it could be written to the second disk.  Since your data profile was
single, there would be only one copy of that new data on the disk that
is now missing.

You should be able to retrieve most of the data.  Mount the filesystem
read-only (options ro,degraded) and rsync the surviving data to a
new filesystem.  If you have default options with checksums enabled,
rsync will report I/O errors on the missing blocks, so you can make a
note of which files are affected and must be replaced from backups.

> Never thought the data or access to it could be compromised
> in what seemed to be a simple situation.

The simple situation is when *all* your chunks are RAID1, not just the
metadata.  RAID1 does work--I've had to RMA two disks in two btrfs RAID1
arrays _this week alone_ and btrfs is fine with them.

You have a filesystem with a mixture of chunk profiles with different
redundancy levels.  That situation is not simple and will not tolerate
a missing disk.  Your filesystem is now probably genuinely broken, and
you have probably lost some data forever.  Redundant metadata will allow
you to determine with certainty what data you have lost.

> Anand, I get the same output with mount -o recovery,ro.
>=20
> On 10/29/2014 7:07 PM, Robert White wrote:
> >On 10/29/2014 03:26 PM, Robert White wrote:
> >>On 10/28/2014 01:32 PM, Zack Coffey wrote:
> >>>Made a RAID1 with another drive of just the metadata. Was in
> >>>that state for less than 12 hours-ish, removed the second drive and
> >>>now cannot get to any data on the original drive. Data remained single
> >>>while only metadata was RAID1.
> >>
> >>I don't know all the details but I would _never_ suspect the action you
> >>described to _not_ hose up the file system.
> >>You need to put the second drive back in and then coerce all the data
> >>back to the first drive. "btrfs device delete" is what you want. You
> >>_may_ need to switch the metadata back to "single" before the delete.
> >>
> >>--Rob.
> >>
> >
> >P.S. I am/was assuming you said "removed the second drive" in the
> >normal sense of disconnecting and removing, as opposed to the
> >semantic action of deleting the device element.
> >
> >If you did do the btrfs delete, you might have needed to do a
> >"btrfs filesystem sync" to make sure that all the transactions
> >involved in the delete were finished and flushed to disk.
> >
> >Either way, physically reattaching "the second drive" is your
> >first step; presuming again that you haven't destroyed the
> >partition or re-used the drive etc. If the partition will mount
> >once the second drive is in place, do the delete operation (if you
> >didn't) and then the sync (to make sure that everything has
> >finished migrating etc). Then you should be able to re-remove the
> >physical drive.
> >
> >If you already did the delete and sync as part of what you meant
> >by "remove" then sorry for the interruption of your misery. 8-)
> >
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--CxDuMX1Cv2n9FQfo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlRSV9IACgkQgfmLGlazG5wWpwCdGSBraIprkffvYVKbC38MZgNd
egMAoKgZOW8A0Tr2KmY9Pk2ulgJbwVwd
=3mJL
-----END PGP SIGNATURE-----

--CxDuMX1Cv2n9FQfo--
