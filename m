Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:43610 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbcFVEGS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jun 2016 00:06:18 -0400
Date: Wed, 22 Jun 2016 00:06:13 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: Adventures in btrfs raid5 disk recovery - update
Message-ID: <20160622040613.GP15597@hungrycats.org>
References: <20160620034427.GK15597@hungrycats.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Osvg0bgWkLaeQPMj"
In-Reply-To: <20160620034427.GK15597@hungrycats.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Osvg0bgWkLaeQPMj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

TL;DR:

	Kernel 4.6.2 causes a world of pain.  Use 4.5.7 instead.

	'btrfs dev stat' doesn't seem to count "csum failed"
	(i.e. corruption) errors in compressed extents.



On Sun, Jun 19, 2016 at 11:44:27PM -0400, Zygo Blaxell wrote:
> Not so long ago, I had a disk fail in a btrfs filesystem with raid1
> metadata and raid5 data.  I mounted the filesystem readonly, replaced
> the failing disk, and attempted to recover by adding the new disk and
> deleting the missing disk.

> I'm currently using kernel 4.6.2

That turned out to be a mistake.  4.6.2 has some severe problems.

Over the past few days I've been upgrading other machines from 4.5.7
to 4.6.2.  This morning I saw the aggregate data coming back from
those machines, and it's all bad:  stalls in snapshot delete, balance,
and sync; some machines just lock up with no console messages; a lot of
watchdog timeouts.  None of the machines could get to an uptime over 26
hours and still be in a usable state.

I switched to 4.5.7 and the crashes, balance/delete hangs, and some of
the data corruption modes stopped.

> I'm
> getting EIO randomly all over the filesystem, including in files that were
> written entirely _after_ the disk failure.

There were actually four distinct corruption modes happening:

1.  There are some number (16500 so far) "normal" corrupt blocks:  read
repeatably returns EIO, they show up in scrub with sane log messages,
and replacing the files that contain these blocks makes them go away.
These blocks appear to be contained in extents that coincide with the
date of the disk failure.  Interestingly, no matter how many times I
read these blocks, I get no increase in the 'btrfs dev stat' numbers
even though I get kernel csum failure messages.  That looks like a bug.

2.  When attempting to replace corrupted files with rsync, I had used
'rsync --inplace'.  This caused bad blocks to be overwritten within
extents, but does not necessarily replace the _entire_ extent containing a
bad block.  This creates corrupt blocks that show up in scrub, balance,
and device delete, but not when reading files.  It also updates the
timestamps so a file with old corruption looks "new" to an insufficiently
sophisticated analysis tool.

3.  Files were corrupted while they were written and accessed via NFS.
This created files with correct btrfs checksums, but garbage contents.
This would show up as failures during 'git gc' or rsync checksum
mismatches.  During one of the many VM crashes, any writes in progress at
the time of the crash were lost.  This effectively rewound the filesystem
several minutes each time as btrfs reverts to the previous committed
tree on the next mount.  4.6.2's hanging issues made this worse by
delaying btrfs commits indefinitely.  The NFS clients were completely
unaware of this, so when the VM rebooted, files ended up with holes,
or would just disappear while in use.

4.  After a VM crash and the filesystem reverted to the previous
committed tree, files with bad blocks that had been repaired through
the NFS server or with rsync would be "unrepaired" (i.e. the filesystem
would revert back to the original corrupted blocks after the mount).

Combinations of these could occur as well for extra confusion, and some
corrupted blocks are contained in many files thanks to dedup.

With kernel 4.5.7 there have been no lockups during commit and no VM
crashes, so I haven't seen any of corruption modes 3 and 4 since 4.5.7.

Balance is now running normally to move the remaining data off the
missing disk.  ETA is 558 hours.  See you in mid-July!  ;)


--Osvg0bgWkLaeQPMj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAldqDrUACgkQgfmLGlazG5yNGgCgmCYyU71G5Cp7XIoAdXQmsJ9l
iJ8AnRdLbnzoojR2RbnZcYTJk92UWc4w
=dot6
-----END PGP SIGNATURE-----

--Osvg0bgWkLaeQPMj--
