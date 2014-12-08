Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:41586 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751969AbaLHGnT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Dec 2014 01:43:19 -0500
Date: Mon, 8 Dec 2014 01:43:17 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Shriramana Sharma <samjnaa@gmail.com>, i@hungrycats.org
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Why is the actual disk usage of btrfs considered unknowable?
Message-ID: <20141208064315.GA22023@hungrycats.org>
References: <CAH-HCWU9GEjvZLH=rwYev_O0S4_Cs9FJvRiJgBiOK8gdxqK5CQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
In-Reply-To: <CAH-HCWU9GEjvZLH=rwYev_O0S4_Cs9FJvRiJgBiOK8gdxqK5CQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 07, 2014 at 08:45:59PM +0530, Shriramana Sharma wrote:
> IIUC:
>=20
> 1) btrfs fi df already shows the alloc-ed space and the space used out of=
 that.
>=20
> 2) Despite snapshots, CoW and compression, the tree knows how many
> extents of data and metadata there are, and how many bytes on disk
> these occcupy, no matter what is the total (uncompressed,
> "unsnapshotted") size of all the directories and files on the disk.
>=20
> So this means that btrfs fi df actually shows the real on-disk usage.
> In this case, why do we hear people saying it's not possible to know
> the actual on-disk usage and when a btrfs-formatted disk (or
> partition) will go out of space?

"On-disk usage" is easy--that's about the past, and can be measured
straightforwardly with a single count of bytes.

"When a btrfs filesystem will return ENOSPC" is much more
complicated--that's about the future, and depends heavily on current
structure and upcoming modifications of it.

There were some pretty terrible btrfs bugs and warts that were fixed
only in the last 5 months or so.  Since some of those had been around
for a year or more, they gave btrfs a reputation.

The 'df' command (statvfs(2)) would report raw free space instead of an
estimate based on the current RAID profile.  This confused some badly
designed programs that would use statvfs to determine that N bytes of free
space were avaiable, and be surprised when N bytes were not all available
for their use.  If you had a btrfs using RAID1, it would report double
the amount of space used and available (one for each disk, e.g. 2x1TB
disks 75% full would be reported as 2TB capacity with 1.5TB used and
0.5TB free).  Now statvfs(2) computes more correct values (1TB capacity
with 750GB used and 250GB free).

Some bugs would crash the btrfs cleaner (the thread which removes deleted
snapshots) or balance, and would cause the filesystem to prematurely
report ENOSPC when (in theory) hundreds of gigabytes were available.
These were straight up bugs that are now fixed.

Modifying the filesystem tree requires free metadata blocks into which
to write new CoW nodes for the modified metadata.  When you delete
something, disk usage goes up for a few seconds before it goes down
(if you have snapshots, the "down" part may be delayed until you delete
the snapshots).  This can lead to surprising "No space left on device"
errors from commands like 'rm -rf lots_of_files'.  The GlobalReserve
chunk type was introduced to reserve a few MB of space on the filesystem
to handle such cases.

Thankfully, everything above now seems to be fixed.

There is still an issue with hetergeneous chunk allocation.  The 'df'
command and 'statvfs' syscall only report a single quantity for used
and free space, while in btrfs there are two distinct data types to be
stored in two distinct container types--and for maximum result
irreproducibility, the amount of space allocated to each type is dynamic.

Data (file contents) is allocated 1GB at a time, metadata (directory
structures, inodes, checksums) is allocated 256MB at a time, and
the two types are not interchangeable after allocation.  This can
cause inaccuracies when reporting free space as the last few free GB
are consumed.  256MB might abruptly disappear from free space if you
happen to run out of free metadata space and allocate a new metadata
chunk instead of a data chunk.

The last few KB of a file that does not fill a full 4K block can be
stored 'inline' (next to the inode in the metadata tree).  If you are
low on space in data chunks, you might be able to write a large number
of small files using inline metadata to store the file contents, but
not an equivalent-sized large file using data extent blocks.  If you
have lots of free data space but not enough metadata space, you get the
opposite result (e.g. you can write new large files but not extend small
existing ones).

All that above happens with RAID, compression and quotas turned *off*.
Turning those them on makes space usage even harder to analyze (and
ENOSPC errors harder to predict) with a single-dimension "available
space" metric.

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlSFSIMACgkQgfmLGlazG5xuCwCgtMrdC3wBMAhxkbitwRLYT66v
2lcAoOktHKTvG4HKrxRHIB6EUszFCILK
=qOn9
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
