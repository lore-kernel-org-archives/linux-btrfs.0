Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:39668 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755579AbdCJS5T (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Mar 2017 13:57:19 -0500
Date: Fri, 10 Mar 2017 13:56:40 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs@vger.kernel.org, Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH v3] btrfs: add missing memset while reading compressed
 inline extents
Message-ID: <20170310185640.GB31830@hungrycats.org>
References: <1489025563-8071-1-git-send-email-ce3g8jdj@umail.furryterror.org>
 <446e5250-2a96-5f46-737f-5c142bfc1471@fb.com>
 <20170310044112.GD21290@hungrycats.org>
 <9fdd7187-191d-3308-3259-d6420a18929e@fb.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
In-Reply-To: <9fdd7187-191d-3308-3259-d6420a18929e@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 10, 2017 at 11:19:24AM -0500, Chris Mason wrote:
> On 03/09/2017 11:41 PM, Zygo Blaxell wrote:
> >On Thu, Mar 09, 2017 at 10:39:49AM -0500, Chris Mason wrote:
> >>
> >>
> >>On 03/08/2017 09:12 PM, Zygo Blaxell wrote:
> >>>This is a story about 4 distinct (and very old) btrfs bugs.
> >>>
> >>
> >>Really great write up.
> >>
> >>[ ... ]
> >>
> >>>
> >>>diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> >>>index 25ac2cf..4d41a31 100644
> >>>--- a/fs/btrfs/inode.c
> >>>+++ b/fs/btrfs/inode.c
> >>>@@ -6805,6 +6805,12 @@ static noinline int uncompress_inline(struct bt=
rfs_path *path,
> >>>	max_size =3D min_t(unsigned long, PAGE_SIZE, max_size);
> >>>	ret =3D btrfs_decompress(compress_type, tmp, page,
> >>>			       extent_offset, inline_size, max_size);
> >>>+	WARN_ON(max_size + pg_offset > PAGE_SIZE);
> >>
> >>Can you please drop this WARN_ON and make the math reflect any possible
> >>pg_offset?  I do agree it shouldn't be happening, but its easy to corre=
ct
> >>for and the WARN is likely to get lost.
> >
> >I'm not sure how to do that.  It looks like I'd have to pass pg_offset
> >through btrfs_decompress to the decompress functions?
> >
> >	ret =3D btrfs_decompress(compress_type, tmp, page,
> >		extent_offset, inline_size, max_size, pg_offset);
> >
> >and in the compression functions get pg_offset from the argument list
> >instead of hardcoding zero.
>=20
> Yeah, it's a good point.  Both zlib and lzo are assuming a zero pg_offset
> right now, but just like there are wacky corners allowing inline extents
> followed by more data, there are a few wacky corners allowing inline exte=
nts
> at the end of the file.
>=20
> Lets not mix that change in with this one though.  For now, just get the
> memset right and we can pass pg_offset down in a later patch.

Are you saying "fix the memset in the patch" (and if so, what's wrong
with it?), or are you saying "let's take the patch with its memset as is,
and fix the pg_offset > 0 issues later"?

> -chris
>=20

--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAljC9ugACgkQgfmLGlazG5wdxACg3jqIYu9iJFmM6vM8p5lnHzyb
gUoAnjbVcERzcNP1TTD66Vv7D5XjTNoh
=AlOT
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--
