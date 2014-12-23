Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:41249 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752533AbaLWVvv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Dec 2014 16:51:51 -0500
Date: Tue, 23 Dec 2014 16:51:43 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Josef Bacik <jbacik@fb.com>
Cc: Daniele Testa <daniele.testa@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs is using 25% more disk than it should
Message-ID: <20141223215119.GD436@hungrycats.org>
References: <CAN6BF2Luf3ERd+ShLyUavzM3bLmy9dT918Zg17xL9T42DNVtVQ@mail.gmail.com>
 <54949454.9020601@fb.com>
 <549495D4.9030800@fb.com>
 <20141220055242.GB436@hungrycats.org>
 <54955D56.20900@fb.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a2FkP9tdjPU2nyhF"
In-Reply-To: <54955D56.20900@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--a2FkP9tdjPU2nyhF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 20, 2014 at 06:28:22AM -0500, Josef Bacik wrote:
> We now have two extents
> with the same bytenr but with different lengths. =20
>[...]
> Then there is the problem of actually returning the free space.  Now
> if we drop all of the refs for an extent we know the space is free
> and we return it to the allocator.  With the above example we can't
> do that anymore, we have to check the extent tree for any area that
> is left overlapping the area we just freed.  This add's another
> search to every btrfs_free_extent operation, which slows the whole
> system down and again leaves us with weird corner cases and pain for
> the users.  Plus this would be an incompatible format change so
> would require setting a feature flag in the fs and rolled to
> voluntarily.

Ouchie.

> Now I have another solution, but I'm not convinced it's awesome
> either.  Take the same example above, but instead we split the
> original extent in the extent tree so we avoid all the mess of
> having overlapping ranges

Would this work for a read-only snapshot?  For a read-write snapshot
it would be as if we had modified both (or all, if there are multiple
snapshots) versions of the tree with split extents.

> This wouldn't require a format change so everybody would get
> this behaviour as soon as we turned it on

It could be a mount option, like autodefrag, off by default until the
bugs were worked out.

Arguably there could be a 'garbage-collection tool' similar to 'btrfs
fi defrag', that could be used to clean out any large partially-obscured
extents from specific files.  This might be important for deduplication
as well (although the extent-same code looks like it does split extents?).

Definitely something to think about.  Thanks for the detailed
explanations.


--a2FkP9tdjPU2nyhF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlSZ49cACgkQgfmLGlazG5w8RwCdFOEVaxMOedw2byOF1gknUIqF
zfsAn2bbEAj91weeNL9oi07iS6+uHFjs
=+AT1
-----END PGP SIGNATURE-----

--a2FkP9tdjPU2nyhF--
