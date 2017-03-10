Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:39984 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751762AbdCJElP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 9 Mar 2017 23:41:15 -0500
Date: Thu, 9 Mar 2017 23:41:13 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] btrfs: add missing memset while reading compressed
 inline extents
Message-ID: <20170310044112.GD21290@hungrycats.org>
References: <1489025563-8071-1-git-send-email-ce3g8jdj@umail.furryterror.org>
 <446e5250-2a96-5f46-737f-5c142bfc1471@fb.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="L/Gi0eBp0e0wm0FU"
In-Reply-To: <446e5250-2a96-5f46-737f-5c142bfc1471@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--L/Gi0eBp0e0wm0FU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 09, 2017 at 10:39:49AM -0500, Chris Mason wrote:
>=20
>=20
> On 03/08/2017 09:12 PM, Zygo Blaxell wrote:
> >This is a story about 4 distinct (and very old) btrfs bugs.
> >
>=20
> Really great write up.
>=20
> [ ... ]
>=20
> >
> >diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> >index 25ac2cf..4d41a31 100644
> >--- a/fs/btrfs/inode.c
> >+++ b/fs/btrfs/inode.c
> >@@ -6805,6 +6805,12 @@ static noinline int uncompress_inline(struct btrf=
s_path *path,
> > 	max_size =3D min_t(unsigned long, PAGE_SIZE, max_size);
> > 	ret =3D btrfs_decompress(compress_type, tmp, page,
> > 			       extent_offset, inline_size, max_size);
> >+	WARN_ON(max_size + pg_offset > PAGE_SIZE);
>=20
> Can you please drop this WARN_ON and make the math reflect any possible
> pg_offset?  I do agree it shouldn't be happening, but its easy to correct
> for and the WARN is likely to get lost.

I'm not sure how to do that.  It looks like I'd have to pass pg_offset
through btrfs_decompress to the decompress functions?

	ret =3D btrfs_decompress(compress_type, tmp, page,
		extent_offset, inline_size, max_size, pg_offset);

and in the compression functions get pg_offset from the argument list
instead of hardcoding zero.

But how does pg_offset become non-zero for an inline extent?  A micro-hole
before the first byte?  If the offset was >=3D 4096, the data wouldn't
be in the first block so there would never be an inline extent in the
first place.

> >+	if (max_size + pg_offset < PAGE_SIZE) {
> >+		char *map =3D kmap(page);
> >+		memset(map + pg_offset + max_size, 0, PAGE_SIZE - max_size - pg_offse=
t);
> >+		kunmap(page);
> >+	}
>=20
> Both lzo and zlib have a memset to cover the gap between what they actual=
ly
> decompress and the max_size that we pass here.  That's important because
> ram_bytes may not be 100% accurate.
>=20
> Can you also please toss in a comment about how the decompression code is
> responsible for the memset up to max_bytes?
>=20
> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--L/Gi0eBp0e0wm0FU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAljCLmgACgkQgfmLGlazG5yvHwCfR0jG81LcW1Mik77a627fNj/I
gw8AoLoE1tRcNUG9rSMHvMMgCIk51yJE
=1S6d
-----END PGP SIGNATURE-----

--L/Gi0eBp0e0wm0FU--
