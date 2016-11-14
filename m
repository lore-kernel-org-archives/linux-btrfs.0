Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:44326 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S932462AbcKNTvD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Nov 2016 14:51:03 -0500
Date: Mon, 14 Nov 2016 14:51:02 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: James Pharaoh <james@wellbehavedsoftware.com>,
        Mark Fasheh <mfasheh@versity.com>, linux-btrfs@vger.kernel.org
Subject: Re: Announcing btrfs-dedupe
Message-ID: <20161114195102.GI21290@hungrycats.org>
References: <2855552b-714c-d1de-08f9-89153c293772@wellbehavedsoftware.com>
 <CAAXPY_LJshM+W+xinabu_-=-E6J8UBMRpy7VPLt8tNihpO68Lw@mail.gmail.com>
 <345b3aa4-6644-6730-09dd-549d320f58cb@wellbehavedsoftware.com>
 <20161114180714.GF21290@hungrycats.org>
 <a4e42724-d84a-e4f9-a3ea-d1fec31a5629@wellbehavedsoftware.com>
 <dfb1372d-8bff-93ff-1ba7-d636e6c7fe4d@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="8MD1ZCO3r6aZNHwn"
In-Reply-To: <dfb1372d-8bff-93ff-1ba7-d636e6c7fe4d@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--8MD1ZCO3r6aZNHwn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 14, 2016 at 01:39:02PM -0500, Austin S. Hemmelgarn wrote:
> On 2016-11-14 13:22, James Pharaoh wrote:
> >One thing I am keen to understand is if BTRFS will automatically ignore
> >a request to deduplicate a file if it is already deduplicated? Given the
> >performance I see when doing a repeat deduplication, it seems to me that
> >it can't be doing so, although this could be caused by the CPU usage you
> >mention above.
> What's happening is that the dedupe ioctl does a byte-wise comparison of =
the
> ranges to make sure they're the same before linking them.  This is actual=
ly
> what takes most of the time when calling the ioctl, and is part of why it
> takes longer the larger the range to deduplicate is.  In essence, it's
> behaving like an OS should and not trusting userspace to make reasonable
> requests (which is also why there's a separate ioctl to clone a range from
> another file instead of deduplicating existing data).

Deduplicating an extent that may might be concurrently modified during the
dedup is a reasonable userspace request.  In the general case there's
no way for userspace to ensure that it's not happening.

That said, some optimization is possible (although there are good reasons
not to bother with optimization in the kernel):

	- VFS could recognize when it has two separate references to
	the same physical extent and not re-read the same data twice
	(but that requires teaching VFS how to do CoW in general, and is
	hard for political reasons on top of the obvious technical ones).

	- the extent-same ioctl could check to see which extents
	are referenced by the src and dst ranges, and return success
	immediately without reading data if they are the same (but
	userspace should already know this, or it's wasting a huge amount
	of time before it even calls the kernel).

> TBH, even though it's kind of annoying from a performance perspective, it=
's
> a rather nice safety net to have.  For example, one of the cases where I =
do
> deduplication is a couple of directories where each directory is an
> overlapping partial subset of one large tree which I keep elsewhere.  In
> this case, I can tell just by filename exactly what files might be
> duplicates, so the ioctl's check lets me just call the ioctl on all
> potential duplicates (after checking size, no point in wasting time if the
> files obviously aren't duplicates), and have it figure out whether or not
> they can be deduplicated.
> >
> >In any case, I'm considering some digging into the filesystem structures
> >to see if I can work this out myself before i do any deduplication. I'm
> >fairly sure this should be relatively simple to work out, at least well
> >enough for my purposes.
> Sadly, there's no way to avoid doing so right now.
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--8MD1ZCO3r6aZNHwn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgqFaYACgkQgfmLGlazG5yjZQCcCUAgJEUqMncD8/j5/Ik8SxTz
KPwAn2tBmvcLQKG19xI0OeS3s64Drf3w
=7T33
-----END PGP SIGNATURE-----

--8MD1ZCO3r6aZNHwn--
