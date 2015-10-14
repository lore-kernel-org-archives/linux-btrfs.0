Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:37482 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750769AbbJNFJS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Oct 2015 01:09:18 -0400
Date: Wed, 14 Oct 2015 01:09:16 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Rich Freeman <r-btrfs@thefreemanclan.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: State of Dedup / Defrag
Message-ID: <20151014050916.GA4400@hungrycats.org>
References: <CAGfcS_kADCxYy2yvTsHLdTTk=OEpx8FyspRfhvjLhbCQwdspKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
In-Reply-To: <CAGfcS_kADCxYy2yvTsHLdTTk=OEpx8FyspRfhvjLhbCQwdspKw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 13, 2015 at 02:59:59PM -0400, Rich Freeman wrote:
> What is the current state of Dedup and Defrag in btrfs?  I seem to
> recall there having been problems a few months ago and I've stopped
> using it, but I haven't seen much news since.

It has been 1 day since a kernel bug leading to data loss was fixed in the
ioctl calls for dedup (commit 6e685a1e3e9054d43fac58f2bc0cd070df915079
=66rom fdmanana yesterday); however, to hit that particular bug you'd
need to be doing something unusual with the ioctls--in particular, a
thing that makes no sense for dedup, and that dedup userspace programs
intentionally avoid doing.  There was another bug for defrag 68 days ago.

I wouldn't try to use dedup on a kernel older than v4.1 because of these
fixes in 4.1 and later:

	- allow dedup of the ends of files when they are not aligned
	to 4K.	Before this was fixed, up to 1GB of space could be wasted
	per file.

	- no mtime update on extent-same.  With the update, rsync
	and backup programs think all the deduped files are modified.
	The next rsync after dedup would immediately un-dedup (redup?) all
	the deduped files.

	- fixes for deadlocks.	If dedup is running at the same time as
	other readers of files (e.g. deduping /usr or a tree on a busy
	file server), a deadlock was inevitable.

IMHO these fixes really made dedup usable for the first time.

There are some other fixes that appeared after v4.1, but they should
not impact cases where mostly static data is deduped without concurrent
modifications.  Do dedup a photo or video file collection.  Don't dedup
a live database server on a filesystem with compression enabled...yet.

Using dedup and defrag at the same time is still a bad idea.  The features
work against each other:  autodefrag skips anything that has been deduped,
while manual defrag un-dedups everything it touches.  The effect of
defrag on dedup depends on the choice of dedup userspace strategy,
so defrag can either be helpful or harmful.

Autodefrag in my experience pushes write latencies up to insane levels.
Data ends up making multiple round-trips to the disk _with_ extra
constraints on the allocator on the second and later passes, and while
this is happening any other writes on the filesystem block an absurdly
long time.  It can easily cost more I/O time than it saves.  That said,
there are some kernel patches floating around to fix the allocator,
so at least we can hope autodefrag will be less bad someday.


--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlYd43wACgkQgfmLGlazG5w6pQCg4r4HxFk3xysh7TrUhF5AolYV
aMQAoI2wL9RzQMjBMPCahUv7Ix59+Vcv
=y4HX
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
