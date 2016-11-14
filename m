Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:39334 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-OK)
        by vger.kernel.org with ESMTP id S933166AbcKNVKP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Nov 2016 16:10:15 -0500
Date: Mon, 14 Nov 2016 16:10:14 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: James Pharaoh <james@wellbehavedsoftware.com>,
        Mark Fasheh <mfasheh@versity.com>, linux-btrfs@vger.kernel.org
Subject: Re: Announcing btrfs-dedupe
Message-ID: <20161114211013.GJ21290@hungrycats.org>
References: <2855552b-714c-d1de-08f9-89153c293772@wellbehavedsoftware.com>
 <CAAXPY_LJshM+W+xinabu_-=-E6J8UBMRpy7VPLt8tNihpO68Lw@mail.gmail.com>
 <345b3aa4-6644-6730-09dd-549d320f58cb@wellbehavedsoftware.com>
 <20161114180714.GF21290@hungrycats.org>
 <a4e42724-d84a-e4f9-a3ea-d1fec31a5629@wellbehavedsoftware.com>
 <dfb1372d-8bff-93ff-1ba7-d636e6c7fe4d@gmail.com>
 <20161114195102.GI21290@hungrycats.org>
 <4389716b-8082-ef89-7efc-60c2ae6b7db6@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="NIe73rPL8TFc/U1V"
In-Reply-To: <4389716b-8082-ef89-7efc-60c2ae6b7db6@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--NIe73rPL8TFc/U1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 14, 2016 at 02:56:51PM -0500, Austin S. Hemmelgarn wrote:
> On 2016-11-14 14:51, Zygo Blaxell wrote:
> >Deduplicating an extent that may might be concurrently modified during t=
he
> >dedup is a reasonable userspace request.  In the general case there's
> >no way for userspace to ensure that it's not happening.
> I'm not even talking about the locking, I'm talking about the data
> comparison that the ioctl does to ensure they are the same before
> deduplicating them, and specifically that protecting against userspace ju=
st
> passing in two random extents that happen to be the same size but not
> contain the same data (because deduplication _should_ reject such a
> situation, that's what the clone ioctl is for).

If I'm deduping a VM image, and the virtual host is writing to said image
(which is likely since an incremental dedup will be intentionally doing
dedup over recently active data sets), the extent I just compared in
userspace might be different by the time the kernel sees it.

This is an important reason why the whole lock/read/compare/replace step
is an atomic operation from userspace's PoV.

The read also saves having to confirm a short/weak hash isn't a collision.
The RAM savings from using weak hashes (~48 bits) are a huge performance
win.

The locking overhead is very small compared to the reading overhead,
and (in the absence of bugs) it will only block concurrent writes to the
same offset range in the src/dst inodes (based on a read of the code...I
don't know if there's also an inode-level or backref-level barrier that
expands the locking scope).

I'm not sure the ioctl is well designed for simply throwing random
data at it, especially not entire files (it can't handle files over
16MB anyway).  It will read more data than it has to compared to a
block-by-block comparison from userspace with prefetches or a pair of
IO threads.  If userspace reads both copies of the data just before
issuing the extent-same call, the kernel will read the data from cache
reasonably quickly.

> The locking is perfectly reasonable and shouldn't contribute that much to
> the overhead (unless you're being crazy and deduplicating thousands of ti=
ny
> blocks of data).

Why is deduplicating thousands of blocks of data crazy?  I already
deduplicate four orders of magnitude more than that per week.

> >That said, some optimization is possible (although there are good reasons
> >not to bother with optimization in the kernel):
> >
> >	- VFS could recognize when it has two separate references to
> >	the same physical extent and not re-read the same data twice
> >	(but that requires teaching VFS how to do CoW in general, and is
> >	hard for political reasons on top of the obvious technical ones).
> >
> >	- the extent-same ioctl could check to see which extents
> >	are referenced by the src and dst ranges, and return success
> >	immediately without reading data if they are the same (but
> >	userspace should already know this, or it's wasting a huge amount
> >	of time before it even calls the kernel).
> >
> >>TBH, even though it's kind of annoying from a performance perspective, =
it's
> >>a rather nice safety net to have.  For example, one of the cases where =
I do
> >>deduplication is a couple of directories where each directory is an
> >>overlapping partial subset of one large tree which I keep elsewhere.  In
> >>this case, I can tell just by filename exactly what files might be
> >>duplicates, so the ioctl's check lets me just call the ioctl on all
> >>potential duplicates (after checking size, no point in wasting time if =
the
> >>files obviously aren't duplicates), and have it figure out whether or n=
ot
> >>they can be deduplicated.
> >>>
> >>>In any case, I'm considering some digging into the filesystem structur=
es
> >>>to see if I can work this out myself before i do any deduplication. I'm
> >>>fairly sure this should be relatively simple to work out, at least well
> >>>enough for my purposes.
> >>Sadly, there's no way to avoid doing so right now.
> >>
> >>--
> >>To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> >>the body of a message to majordomo@vger.kernel.org
> >>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--NIe73rPL8TFc/U1V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgqKDUACgkQgfmLGlazG5yoJACfcrCwX0+lLnwxJjMsEbjsCau6
BVYAoKUD2xYM0lysYlgIUP//ZQf56Ahy
=ZnrG
-----END PGP SIGNATURE-----

--NIe73rPL8TFc/U1V--
