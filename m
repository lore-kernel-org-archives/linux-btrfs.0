Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:40986 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S938710AbcKNVXH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Nov 2016 16:23:07 -0500
Date: Mon, 14 Nov 2016 16:22:07 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: James Pharaoh <james@wellbehavedsoftware.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Mark Fasheh <mfasheh@versity.com>, linux-btrfs@vger.kernel.org
Subject: Re: Announcing btrfs-dedupe
Message-ID: <20161114212206.GK21290@hungrycats.org>
References: <2855552b-714c-d1de-08f9-89153c293772@wellbehavedsoftware.com>
 <CAAXPY_LJshM+W+xinabu_-=-E6J8UBMRpy7VPLt8tNihpO68Lw@mail.gmail.com>
 <345b3aa4-6644-6730-09dd-549d320f58cb@wellbehavedsoftware.com>
 <20161114180714.GF21290@hungrycats.org>
 <a4e42724-d84a-e4f9-a3ea-d1fec31a5629@wellbehavedsoftware.com>
 <dfb1372d-8bff-93ff-1ba7-d636e6c7fe4d@gmail.com>
 <20161114195102.GI21290@hungrycats.org>
 <ab787485-c6ba-cada-07c5-f226d1c395e2@wellbehavedsoftware.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="9b/uWrIH8C2V3aH3"
In-Reply-To: <ab787485-c6ba-cada-07c5-f226d1c395e2@wellbehavedsoftware.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--9b/uWrIH8C2V3aH3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 14, 2016 at 09:07:51PM +0100, James Pharaoh wrote:
> On 14/11/16 20:51, Zygo Blaxell wrote:
> >On Mon, Nov 14, 2016 at 01:39:02PM -0500, Austin S. Hemmelgarn wrote:
> >>On 2016-11-14 13:22, James Pharaoh wrote:
> >>>One thing I am keen to understand is if BTRFS will automatically ignore
> >>>a request to deduplicate a file if it is already deduplicated? Given t=
he
> >>>performance I see when doing a repeat deduplication, it seems to me th=
at
> >>>it can't be doing so, although this could be caused by the CPU usage y=
ou
> >>>mention above.
> >>
> >>What's happening is that the dedupe ioctl does a byte-wise comparison o=
f the
> >>ranges to make sure they're the same before linking them.  This is actu=
ally
> >>what takes most of the time when calling the ioctl, and is part of why =
it
> >>takes longer the larger the range to deduplicate is.  In essence, it's
> >>behaving like an OS should and not trusting userspace to make reasonable
> >>requests (which is also why there's a separate ioctl to clone a range f=
rom
> >>another file instead of deduplicating existing data).
> >
> >	- the extent-same ioctl could check to see which extents
> >	are referenced by the src and dst ranges, and return success
> >	immediately without reading data if they are the same (but
> >	userspace should already know this, or it's wasting a huge amount
> >	of time before it even calls the kernel).
>=20
> Yes, this is what I am talking about. I believe I should be able to read
> data about the BTRFS data structures and determine if this is the case. I
> don't care if there are false matches, due to concurrent updates, but
> there'll be a /lot/ of repeat deduplications unless I do this, because ev=
en
> if the file is identical, the mtime etc hasn't changed, and I have a reco=
rd
> of previously doing a dedupe, there's no guarantee that the file hasn't b=
een
> rewritten in place (eg by rsync), and no way that I know of to reliably
> detect if a file has been changed.
>=20
> I am sure there are libraries out there which can look into the data
> structures of a BTRFS file system, I haven't researched this in detail
> though. I imagine that with some kind of lock on a BTRFS root, this could=
 be
> achieved by simply reading the data from the disk, since I believe that
> everything is copy-on-write, so no existing data should be overwritten un=
til
> all roots referring to it are updated. Perhaps I'm missing something
> though...

FIEMAP (VFS) and SEARCH_V2 (btrfs-specific) will both give you access
to the underlying physical block numbers.  SEARCH_V2 is non-trivial
to use without reverse-engineering significant parts of btrfs-progs.
SEARCH_V2 is a generic tree-searching tool which will give you all kinds
of information about btrfs structures...it's essential for a sophisticated
deduplicator and overkill for a simple one.

For full-file dedup using FIEMAP you only need to look at the "physical"
field of the first extent (if it's zero or the same as the other file, the
files cannot be deduplicated or are already deduplicated, respectively).
The source for 'filefrag' (from e2fsprogs) is good for learning how
FIEMAP works.

For block-level dedup you need to look at each extent individually.
That's much slower and full of additional caveats.  If you're going down
that road it's probably better to just improve duperemove instead.

> James

--9b/uWrIH8C2V3aH3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgqKv4ACgkQgfmLGlazG5xIWQCgsZQ4y59YGF5u/SkSr/TSFsvK
CwIAoIE/fq0d1SfM9so1ng17pDjsfYER
=Hyh6
-----END PGP SIGNATURE-----

--9b/uWrIH8C2V3aH3--
