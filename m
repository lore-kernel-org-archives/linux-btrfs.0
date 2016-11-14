Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:33078 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-OK)
        by vger.kernel.org with ESMTP id S1754399AbcKNSn5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Nov 2016 13:43:57 -0500
Date: Mon, 14 Nov 2016 13:43:21 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: James Pharaoh <james@wellbehavedsoftware.com>
Cc: Mark Fasheh <mfasheh@versity.com>, linux-btrfs@vger.kernel.org
Subject: Re: Announcing btrfs-dedupe
Message-ID: <20161114184320.GH21290@hungrycats.org>
References: <2855552b-714c-d1de-08f9-89153c293772@wellbehavedsoftware.com>
 <CAAXPY_LJshM+W+xinabu_-=-E6J8UBMRpy7VPLt8tNihpO68Lw@mail.gmail.com>
 <345b3aa4-6644-6730-09dd-549d320f58cb@wellbehavedsoftware.com>
 <20161114180714.GF21290@hungrycats.org>
 <a4e42724-d84a-e4f9-a3ea-d1fec31a5629@wellbehavedsoftware.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="jFijuCULRDbBA23d"
In-Reply-To: <a4e42724-d84a-e4f9-a3ea-d1fec31a5629@wellbehavedsoftware.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--jFijuCULRDbBA23d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 14, 2016 at 07:22:59PM +0100, James Pharaoh wrote:
> On 14/11/16 19:07, Zygo Blaxell wrote:
> >There is also a still-unresolved problem where the filesystem CPU usage
> >rises exponentially for some operations depending on the number of shared
> >references to an extent.  Files which contain blocks with more than a few
> >thousand shared references can trigger this problem.  A file over 1TB can
> >keep the kernel busy at 100% CPU for over 40 minutes at a time.
>=20
> Yes, I see this all the time. For my use cases, I don't really care about
> "shared references" as blocks of files, but am happy to simply deduplicate
> at the whole-file level. I wonder if this still will have the same effect,
> however. I guess that this could be mitigated in a tool, but this is going
> to be both annoying and not the most elegant solution.

If you have huge files (1TB+) this can be a problem even with whole-file
deduplications (which are really just extent-level deduplications applied
to the entire file).  The CPU time is a product of file size and extent
reference count with some other multipliers on top.

I've hacked around it by timing how long it takes to manipulate the data,
and blacklisting any hash value or block address that takes more than
10 seconds to process (if such a block is found after blacklisting, just
skip processing the block/extent/file entirely).  It turns out there are
very few of these in practice (only a few hundred per TB) but these few
hundred block hash values occur millions of times in a large data corpus.

> One thing I am keen to understand is if BTRFS will automatically ignore a
> request to deduplicate a file if it is already deduplicated? Given the
> performance I see when doing a repeat deduplication, it seems to me that =
it
> can't be doing so, although this could be caused by the CPU usage you
> mention above.

As far as I can tell btrfs doesn't do anything different in this
case--it'll happily repeat the entire lock/read/compare/delete/insert
sequence even if the outcome cannot be different from the initial
conditions.  Due to limitations of VFS caching it'll read the same blocks
=66rom storage hardware twice, too.

> In any case, I'm considering some digging into the filesystem structures =
to
> see if I can work this out myself before i do any deduplication. I'm fair=
ly
> sure this should be relatively simple to work out, at least well enough f=
or
> my purposes.

I used FIEMAP (then later replaced it with SEARCH_V2 for speed) to map
the extents to physical addresses before deduping them.  If you're only
going to do whole-file dedup then you only need to care about the physical
address of the first non-hole extent.


--jFijuCULRDbBA23d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgqBcgACgkQgfmLGlazG5xLsACeKLpxwWNHimz+RXQZEkpsnksM
JMEAoMqj5s+MZAPDTUicrFGlubNtS0VV
=Tolz
-----END PGP SIGNATURE-----

--jFijuCULRDbBA23d--
