Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:40566 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751546AbdJ3XkK (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Mon, 30 Oct 2017 19:40:10 -0400
Subject: Re: [PATCH] btrfs: Fix quota reservation leak on preallocated files
To: Justin Maggard <jmaggard10@gmail.com>, linux-btrfs@vger.kernel.org
Cc: Justin Maggard <jmaggard@netgear.com>
References: <20171030222910.21722-1-jmaggard@netgear.com>
From: Qu Wenruo <wqu@suse.com>
Message-ID: <7dd25dd1-d7e1-0e47-5d5d-79c1ea335aa0@suse.com>
Date: Tue, 31 Oct 2017 07:39:50 +0800
MIME-Version: 1.0
In-Reply-To: <20171030222910.21722-1-jmaggard@netgear.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="gX1E0998ERuUgILhr7wxuNh13GUM75alv"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gX1E0998ERuUgILhr7wxuNh13GUM75alv
Content-Type: multipart/mixed; boundary="UWjSqe23M9eFQBmkGQwPsshXfuq0J1A5J";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.com>
To: Justin Maggard <jmaggard10@gmail.com>, linux-btrfs@vger.kernel.org
Cc: Justin Maggard <jmaggard@netgear.com>
Message-ID: <7dd25dd1-d7e1-0e47-5d5d-79c1ea335aa0@suse.com>
Subject: Re: [PATCH] btrfs: Fix quota reservation leak on preallocated files
References: <20171030222910.21722-1-jmaggard@netgear.com>
In-Reply-To: <20171030222910.21722-1-jmaggard@netgear.com>

--UWjSqe23M9eFQBmkGQwPsshXfuq0J1A5J
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B410=E6=9C=8831=E6=97=A5 06:29, Justin Maggard wrote:
> Commit c6887cd11149 (Btrfs: don't do nocow check unless we have to)
> changed the behavior of __btrfs_buffered_write() so that it first tries=

> to get a data space reservation, and then skips the relatively expensiv=
e
> nocow check if the reservation succeeded.
>=20
> If we have quotas enabled, the data space reservation also includes a
> quota reservation.  But in the rewrite case, the space has already been=

> accounted for in qgroups.  So btrfs_check_data_free_space() increases t=
he
> quota reservation, but it never gets decreased when the data actually
> gets written and overwrites the pre-existing data.  So we're left with
> both the qgroup and qgroup reservation accounting for the same space.
>=20
> This commit adds the missing btrfs_qgroup_free_data() call in the case =
of
> BTRFS_ORDERED_PREALLOC extents.
>=20
> Signed-off-by: Justin Maggard <jmaggard@netgear.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu
> ---
>  fs/btrfs/inode.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index d94e3f68b9b1..d7881ccf5310 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -3006,6 +3006,8 @@ static int btrfs_finish_ordered_io(struct btrfs_o=
rdered_extent *ordered_extent)
>  		compress_type =3D ordered_extent->compress_type;
>  	if (test_bit(BTRFS_ORDERED_PREALLOC, &ordered_extent->flags)) {
>  		BUG_ON(compress_type);
> +		btrfs_qgroup_free_data(inode, NULL, ordered_extent->file_offset,
> +				       ordered_extent->len);
>  		ret =3D btrfs_mark_extent_written(trans, BTRFS_I(inode),
>  						ordered_extent->file_offset,
>  						ordered_extent->file_offset +
>=20


--UWjSqe23M9eFQBmkGQwPsshXfuq0J1A5J--

--gX1E0998ERuUgILhr7wxuNh13GUM75alv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFBBAEBCAArFiEELd9y5aWlW6idqkLhwj2R86El/qgFAln3uEcNHHdxdUBzdXNl
LmNvbQAKCRDCPZHzoSX+qG7vB/9K/6v4ZMDzmO+CMtW6abOu5nPOBlbo0wJT2VR+
mBaxuJ9st1r3nPd8+dmtztZ/b9RWm+U62SCnnRwtLPjch+tMPcPPN5byLDGkIBM+
jQYl9tnIAYjp7WcBfp96K2WhdAGvcjQNzsmwBGLtJgjtDzs9JTAiFfeo7RSL3H+S
g9PZD0WJiJtgHTQLoRJ5nRvbkw0Lf8QFZIZKb63hoDymsT+uZQjAmZ4odNX+j4i3
tbXzorSEHzBvGmGJnLRSyPf8gRQ9eDZUo+DFQAC9fga8Tl0C0wwwbj63Fb+p8gGH
qZ1a0zGVgtD2i+sgvbwb9T1oXdWTQQ2rbKIUYX0dkIDYAGSZ
=C1t/
-----END PGP SIGNATURE-----

--gX1E0998ERuUgILhr7wxuNh13GUM75alv--
