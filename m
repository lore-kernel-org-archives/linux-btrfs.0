Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:33527 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387819AbeGWHjV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Jul 2018 03:39:21 -0400
Subject: Re: [PATCH] btrfs: extent-tree: Remove dead alignment check
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180723062246.2885-1-wqu@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <6311def9-3441-a703-2a82-3157af1a6f0a@gmx.com>
Date: Mon, 23 Jul 2018 14:39:32 +0800
MIME-Version: 1.0
In-Reply-To: <20180723062246.2885-1-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="fykIguF3JZHoOscLxAEFr79VUuat5Nb33"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fykIguF3JZHoOscLxAEFr79VUuat5Nb33
Content-Type: multipart/mixed; boundary="1ZJwbXJp2MuX6fsBKdiM3hJ7cWfaHz5wD";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <6311def9-3441-a703-2a82-3157af1a6f0a@gmx.com>
Subject: Re: [PATCH] btrfs: extent-tree: Remove dead alignment check
References: <20180723062246.2885-1-wqu@suse.com>
In-Reply-To: <20180723062246.2885-1-wqu@suse.com>

--1ZJwbXJp2MuX6fsBKdiM3hJ7cWfaHz5wD
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8823=E6=97=A5 14:22, Qu Wenruo wrote:
> In find_free_extent() under checks: tag, we have the following code
>=20
> ------
> 		search_start =3D ALIGN(offset, fs_info->stripesize);
> 		/* move on to the next group */
> 		if (search_start + num_bytes >
> 		    block_group->key.objectid + block_group->key.offset) {
> 			btrfs_add_free_space(block_group, offset, num_bytes);
> 			goto loop;
> 		}
> 		if (offset < search_start)
> 			btrfs_add_free_space(block_group, offset,
> 					     search_start - offset);
> 		BUG_ON(offset > search_start);
> ------
>=20
> However ALIGN() is rounding down, thus @search_start <=3D @offset.

Well, ALIGN() is rounding up, so this is completely wrong.

But still we have some conflicting BUG_ON() against ALIGN().

I'll update the patch and hopes no one found my stupid error.

Thanks,
Qu

>=20
> That later (offset < search_start) check will never be true, but that
> BUG_ON(offset > search_start) can be triggered as long as our @offset i=
s
> not aligned to @stripesize.
>=20
> However we never has such report on this BUG_ON(), which means the
> search result @offset is always aligned to @fs_info->stripesize (which
> is also set to sector size at mkfs time), or it's handled by block grou=
p
> range check.
>=20
> Anyway, remove such dead unalignment check.
>=20
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/extent-tree.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
>=20
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index f18e86177067..48a2aec7dc59 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -7754,7 +7754,7 @@ static noinline int find_free_extent(struct btrfs=
_fs_info *fs_info,
>  			goto loop;
>  		}
>  checks:
> -		search_start =3D ALIGN(offset, fs_info->stripesize);
> +		search_start =3D round_down(offset, fs_info->stripesize);
> =20
>  		/* move on to the next group */
>  		if (search_start + num_bytes >
> @@ -7763,11 +7763,6 @@ static noinline int find_free_extent(struct btrf=
s_fs_info *fs_info,
>  			goto loop;
>  		}
> =20
> -		if (offset < search_start)
> -			btrfs_add_free_space(block_group, offset,
> -					     search_start - offset);
> -		BUG_ON(offset > search_start);
> -
>  		ret =3D btrfs_add_reserved_bytes(block_group, ram_bytes,
>  				num_bytes, delalloc);
>  		if (ret =3D=3D -EAGAIN) {
>=20


--1ZJwbXJp2MuX6fsBKdiM3hJ7cWfaHz5wD--

--fykIguF3JZHoOscLxAEFr79VUuat5Nb33
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltVeCQACgkQwj2R86El
/qif/QgAg0zSPn3kRyKiy8Jsoi6eynsUoYbx9PFDnKNmO9KfzfScSPX2/91TOgsP
Olq1UmCKKVgeFqU+kHDzK4e3HaEuSXzq65OIP22IJr7vhw1kcDD1QD2Yq3thpgb4
BiUV47JpV3tg8BGvOIDHdymAf9qQSSntkaojyNDfkU8erbQ0R6Bsz19hRKqnZeR0
7KQi+HwZQg+J7WgfAFsOl9v54lcRPgmhm9k70Y9keZ+VHE1JgML7INLqs8uHX4ew
Nn9aOjak0D4kC5wYsFHDKYJ/nE92wH8v4p9NhWaDzgPf75DFh56Q+c4YFoTdvUYJ
1cPd3PBNydwaggrrhxaOtkWD2xWl1g==
=n+Kl
-----END PGP SIGNATURE-----

--fykIguF3JZHoOscLxAEFr79VUuat5Nb33--
