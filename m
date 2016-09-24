Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:38508 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753144AbcIXC2M (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Sep 2016 22:28:12 -0400
Date: Fri, 23 Sep 2016 22:28:10 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Chris Mason <clm@fb.com>
Cc: Paul Jones <paul@pauljones.id.au>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs rare silent data corruption with kernel data leak
Message-ID: <20160924022810.GP21290@hungrycats.org>
References: <20160921045556.GN21290@hungrycats.org>
 <ME1PR01MB13788B5A79BF88786A1D571D9EF60@ME1PR01MB1378.ausprd01.prod.outlook.com>
 <c47741e6-76d4-0900-e126-2be4862233db@fb.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="s2lX4GznBIrto1wi"
In-Reply-To: <c47741e6-76d4-0900-e126-2be4862233db@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--s2lX4GznBIrto1wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 22, 2016 at 04:42:06PM -0400, Chris Mason wrote:
> On 09/21/2016 07:14 AM, Paul Jones wrote:
> >>-----Original Message-----
> >>From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> >>owner@vger.kernel.org] On Behalf Of Zygo Blaxell
> >>Sent: Wednesday, 21 September 2016 2:56 PM
> >>To: linux-btrfs@vger.kernel.org
> >>Subject: btrfs rare silent data corruption with kernel data leak
> >>
> >>Summary:
> >>
> >>There seem to be two btrfs bugs here: one loses data on writes, and the
> >>other leaks data from the kernel to replace it on reads.  It all happen=
s after
> >>checksums are verified, so the corruption is entirely silent--no EIO er=
rors,
> >>kernel messages, or device event statistics.
> >>
> >>Compressed extents are corrupted with kernel data leak.  Uncompressed
> >>extents may not be corrupted, or may be corrupted by deterministically
> >>replacing data bytes with zero, or may not be corrupted.  No preconditi=
ons
> >>for corruption are known.  Less than one file per hundred thousand seem=
s to
> >>be affected.  Only specific parts of any file can be affected.
> >>Kernels v4.0..v4.5.7 tested, all have the issue.
>=20
> Zygo, could you please bounce me your original email?  Somehow exchange a=
te
> it.

Resent (also archived at http://www.spinics.net/lists/linux-btrfs/msg59102.=
html).

> If you're seeing this databases that use fsync, it could be related to the
> fsync fix I put into the last RC.  On my boxes it caused crashes, but mem=
ory
> corruptions aren't impossible.

Did you mean cbd60aa7cd "Btrfs: remove root_log_ctx from ctx list before
btrfs_sync_log returns"?  If so, I can cherry-pick that onto a previously
tested kernel and see what happens.

> Any chance you can do a controlled experiment to rule out compression?

It took two weeks of mining to find one extent with compression.
I've never seen one that wasn't compressed, which (I'm assuming) means
they're even harder to find if they exist at all.

> -chris

TBH I'm more concerned about the logic here, which came up the last time
inline extents at the beginning of multi-extent files caused problems:

btrfs_get_extent(...) {

	existing =3D search_extent_mapping(em_tree, start, len);
	/*
	 * existing will always be non-NULL, since there must be
	 * extent causing the -EEXIST.
	 */
	if (existing->start =3D=3D em->start &&
	    extent_map_end(existing) =3D=3D extent_map_end(em) &&
	    em->block_start =3D=3D existing->block_start) {
		/*
		 * these two extents are the same, it happens
		 * with inlines especially
		 */
		free_extent_map(em);
		em =3D existing;
		err =3D 0;

	} else if (start >=3D extent_map_end(existing) ||
	    start <=3D existing->start) {
		/*
		 * The existing extent map is the one nearest to
		 * the [start, start + len) range which overlaps
		 */
		err =3D merge_extent_mapping(em_tree, existing,
					   em, start);
		free_extent_map(existing);
		if (err) {  =20
			free_extent_map(em);
			em =3D NULL;
		}
	} else {
		free_extent_map(em);
		em =3D existing;
		err =3D 0;
	}

What is extent_map_end for an inline extent?  Could we end up in the
wrong branch of the if statement?  Is this code relevant at all?


--s2lX4GznBIrto1wi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlfl5LoACgkQgfmLGlazG5wO/QCfSO+oh5+XrcEbvzxJA9z2nzPn
wsAAoMxj9wocGsvlxphtGmZIYptFiNWR
=CZo4
-----END PGP SIGNATURE-----

--s2lX4GznBIrto1wi--
