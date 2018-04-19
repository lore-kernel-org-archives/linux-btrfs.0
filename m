Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:41100 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753453AbeDSVll (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Apr 2018 17:41:41 -0400
Date: Thu, 19 Apr 2018 17:41:36 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Jayashree Mohan <jayashree2912@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Vijaychidambaram Velayudhan Pillai <vijay@cs.utexas.edu>
Subject: Re: Hard link not persisted on fsync
Message-ID: <20180419214136.GA22356@hungrycats.org>
References: <CA+EzBbDv8GKKgSVwAYwQAn5Q3-MMz2BLUeFcjn3uv6eNBKvs5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
In-Reply-To: <CA+EzBbDv8GKKgSVwAYwQAn5Q3-MMz2BLUeFcjn3uv6eNBKvs5g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 16, 2018 at 09:35:24AM -0500, Jayashree Mohan wrote:
> Hi,
>=20
> The following seems to be a crash consistency bug on btrfs, where in
> the link count is not persisted even after a fsync on the original
> file.
>=20
> Consider the following workload :
> creat foo
> link (foo, A/bar)
> fsync(foo)
> ---Crash---
>=20
> Now, on recovery we expect the metadata of foo to be persisted i.e
> have a link count of 2. However in btrfs, the link count is 1 and file
> A/bar is not persisted. The expected behaviour would be to persist the
> dependencies of inode foo. That is to say, shouldn't fsync of foo
> persist A/bar and correctly update the link count?

Those dependencies are backward.  foo's inode doesn't depend on anything
but the data in the file foo, and foo's inode itself.

"foo" and "A/bar" are dirents that both depend on the inode of foo, which
implies that "A" and "." must be updated atomically with foo's inode.
If you had called fsync(A) then we'd expect A/bar to exist and the inode
to have a link count of 2.  If you'd called fsync(.) then...well, you
didn't modify "." at all, so I guess either outcome is valid as long as
the inode link count matches the number of dirents referencing the inode.

But then...why does foo exist at all?  I'd expect at least some tests
would end without foo on disk either, since all that was fsync()ed was the
foo inode, not the foo dirent in the directory '.'.  Does btrfs combine
creating foo and updating foo's inode into a single atomic operation?
I vaguely recall that it does exactly that, in order to solve a bug
some years ago.  What happens if you add a rename, e.g.

	unlink foo2	# make sure foo2 doesn't exist
	creat foo
	rename(foo, foo2)
	link(foo2, A/bar)
	fsync(foo2)

Do you get foo or foo2?  I'd expect foo since you didn't fsync '.',
but maybe rename implies flush and you get foo2.

That's not to say that fsync is not a rich source of filesystem bugs.
btrfs did once have (and maybe still has?) a bug where renames and fsync
can create a dirent with no inode, e.g.

	loop continuously:
		creat foo
		write(foo, data)
		fsync(foo)
		rename(foo, bar)

and crash somewhere in the middle of the loop, which will create a
dirent "foo" that points to a non-existent inode.

Removing the "fsync" works around the bug.  rename() does a flush anyway,
so the fsync() wasn't needed, but fsync() shouldn't _create_ a filesystem
inconsistency, especially when Googling recommends app developers to
sprinkle fsync()s indiscriminately in their code to prevent their data
=66rom being mangled.

I haven't been tracking to see if that's fixed yet.  I last saw it on
4.11, but I have been aggressively avoiding fsync with eatmydata for
some years now.

> Note that ext4, xfs and f2fs recover to the correct link count of 2
> for the above workload.

Do those filesystems also work if you remove the fsync?  That may be
your answer:  they could be flushing the other metadata earlier, before
you call fsync().

> Let us know what you think about this behavior.
>=20
> Thanks,
> Jayashree Mohan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCWtkNDQAKCRCB+YsaVrMb
nGB/AKCZy5O9xNNg4jQ9QwBHLMXWDC/8UACfcDZy17xFMHrUjOR1/f4NXiqenNI=
=0Z/V
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
