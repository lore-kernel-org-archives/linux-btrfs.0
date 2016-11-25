Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:40098 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751373AbcKYD4d (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Nov 2016 22:56:33 -0500
Date: Thu, 24 Nov 2016 22:55:43 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Saint Germain <saintger@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Identifying reflink / CoW files
Message-ID: <20161125035543.GZ21290@hungrycats.org>
References: <20161027133011.631cf1e5@system>
 <20161103051707.GE21290@hungrycats.org>
 <20161104154149.754c3eab@system>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="vDz90IqCUeSi4M1R"
In-Reply-To: <20161104154149.754c3eab@system>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--vDz90IqCUeSi4M1R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 04, 2016 at 03:41:49PM +0100, Saint Germain wrote:
> On Thu, 3 Nov 2016 01:17:07 -0400, Zygo Blaxell
> <ce3g8jdj@umail.furryterror.org> wrote :
> > [...]
> > The quality of the result therefore depends on the amount of effort
> > put into measuring it.  If you look for the first non-hole extent in
> > each file and use its physical address as a physical file identifier,
> > then you get a fast reflink detector function that has a high risk of
> > false positives.  If you map out two files and compare physical
> > addresses block by block, you get a slow function with a low risk of
> > false positives (but maybe a small risk of false negatives too).
> >=20
> > If your dedup program only does full-file reflink copies then the
> > first extent physical address method is sufficient.  If your program
> > does block- or extent-level dedup then it shouldn't be using files in
> > its data model at all, except where necessary to provide a mechanism
> > to access the physical blocks through the POSIX filesystem API.
> >=20
> > FIEMAP will tell you about all the extents (physical address for
> > extents that have them, zero for other extent types).  It's also slow
> > and has assorted accuracy problems especially with compressed files.
> > Any user can run FIEMAP, and it uses only standard structure arrays.
> >=20
> > SEARCH_V2 is root-only and requires parsing variable-length binary
> > btrfs data encoding, but it's faster than FIEMAP and gives more
> > accurate results on compressed files.
>=20
> As the dedup program only does full-file reflink, the first extent
> physical address method can be used as a fast first check to identify
> potential files.
>=20
> But how to implement the second check in order to have 0% risk of false
> positive ?
> Because you said that mapping out two files and comparing the physical
> addresses block by block also has a low risk of false positives.

In theory, what you do is call FIEMAP on each file and compare the
physical blocks that come back.  If they are large files you will have
to call FIEMAP multiple times on both files, each time setting the start
position to the end position of the previous run.  Translate each result
record into a range of physical addresses, then compare them.  If there
were no differences, the files are already deduped.

In practice, FIEMAP doesn't provide full accuracy for compressed extents,
and in some cases the physical address data will compare equal when
the files are in fact different.  This is the small risk of false
positives, and the only way to get 100% accuracy is to not use FIEMAP.

Instead you can use the SEARCH ioctl, which dumps out the binary extent
items from btrfs.  If you look up the items corresponding to one inode,
you can get the real physical block address plus the offset from the
beginning of the extent for compressed extents.

In Bees I encode the compressed extent start offset into the same
uint64_t as the physical extent start address using the bottom 6 bits
of the physical (bytenr) address:

	https://github.com/Zygo/bees/blob/master/src/bees-types.cc#L744

This fills in an object which uniquely (and reversibly) identifies
the block on the filesystem.

The raw btrfs extent data is extracted here:

	https://github.com/Zygo/bees/blob/master/lib/extentwalker.cc#L533

BeesAddress gives no false positives, but it's built on top of hundreds
of lines of userspace support code.  :-/

> Thank you very much for the detailed explanation !
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--vDz90IqCUeSi4M1R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlg3tj8ACgkQgfmLGlazG5zOowCg51L5c9lxqEZBLc6vPNap4xoA
7xkAnR4/1hWpb92Jjtqw4YP566aX+qmd
=Eekf
-----END PGP SIGNATURE-----

--vDz90IqCUeSi4M1R--
