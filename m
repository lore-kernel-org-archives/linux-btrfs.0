Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:33782 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751882AbcKCFRJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Nov 2016 01:17:09 -0400
Date: Thu, 3 Nov 2016 01:17:07 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Saint Germain <saintger@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Identifying reflink / CoW files
Message-ID: <20161103051707.GE21290@hungrycats.org>
References: <20161027133011.631cf1e5@system>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="JVTRtevMO87SusWP"
In-Reply-To: <20161027133011.631cf1e5@system>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--JVTRtevMO87SusWP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 27, 2016 at 01:30:11PM +0200, Saint Germain wrote:
> Hello,
>=20
> Following the previous discussion:
> https://www.spinics.net/lists/linux-btrfs/msg19075.html
>=20
> I would be interested in finding a way to reliably identify reflink /
> CoW files in order to use deduplication programs (like fdupes, jdupes,
> rmlint) efficiently.
>=20
> Using FIEMAP doesn't seem to be reliable according to this discussion
> on rmlint:
> https://github.com/sahib/rmlint/issues/132#issuecomment-157665154

Inline extents have no physical address (FIEMAP returns 0 in that field).
You can't dedup them and each file can have only one, so if you see
the FIEMAP_EXTENT_INLINE bit set, you can just skip processing the entire
file immediately.

You can create a separate non-inline extent in a temporary file then
use dedup to replace _both_ copies of the original inline extent.
Or don't bother, as the savings are negligible.

> Is there another way that deduplication programs can easily use ?

The problem is that it's not files that are reflinked--individual extents
are.  "reflink file copy" really just means "a file whose extents are
100% shared with another file." It's possible for files on btrfs to have
any percentage of shared extents from 0 to 100% in increments of the
host page size.  It's also possible for the blocks to be shared with
different extent boundaries.

The quality of the result therefore depends on the amount of effort
put into measuring it.  If you look for the first non-hole extent in
each file and use its physical address as a physical file identifier,
then you get a fast reflink detector function that has a high risk of
false positives.  If you map out two files and compare physical addresses
block by block, you get a slow function with a low risk of false positives
(but maybe a small risk of false negatives too).

If your dedup program only does full-file reflink copies then the first
extent physical address method is sufficient.  If your program does
block- or extent-level dedup then it shouldn't be using files in its
data model at all, except where necessary to provide a mechanism to
access the physical blocks through the POSIX filesystem API.

FIEMAP will tell you about all the extents (physical address for extents
that have them, zero for other extent types).  It's also slow and has
assorted accuracy problems especially with compressed files.  Any user
can run FIEMAP, and it uses only standard structure arrays.

SEARCH_V2 is root-only and requires parsing variable-length binary
btrfs data encoding, but it's faster than FIEMAP and gives more accurate
results on compressed files.

> Thanks
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--JVTRtevMO87SusWP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgayFMACgkQgfmLGlazG5yxxACcDvG3T4pyNRKKqqrMoiR2Zg/0
+CMAnjgSHzvgilox9lvl51ZbRSBNxuOi
=ckeI
-----END PGP SIGNATURE-----

--JVTRtevMO87SusWP--
