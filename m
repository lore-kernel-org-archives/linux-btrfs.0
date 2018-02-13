Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:58693 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933638AbeBMJB5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Feb 2018 04:01:57 -0500
Subject: Re: [PATCH v2] btrfs: fix endianness compatibility during the SB RW
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180212153749.19705-1-anand.jain@oracle.com>
 <20180213030046.14093-1-anand.jain@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <358780ca-cb85-4de1-f849-3a642d3fc2c7@gmx.com>
Date: Tue, 13 Feb 2018 17:01:42 +0800
MIME-Version: 1.0
In-Reply-To: <20180213030046.14093-1-anand.jain@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="80OCkn8lhhaenVwMvChNzCLl7Kw3ejHk8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--80OCkn8lhhaenVwMvChNzCLl7Kw3ejHk8
Content-Type: multipart/mixed; boundary="65vXKfLw5UIIbhLQyzUzhKy0zFh5bSbd7";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Message-ID: <358780ca-cb85-4de1-f849-3a642d3fc2c7@gmx.com>
Subject: Re: [PATCH v2] btrfs: fix endianness compatibility during the SB RW
References: <20180212153749.19705-1-anand.jain@oracle.com>
 <20180213030046.14093-1-anand.jain@oracle.com>
In-Reply-To: <20180213030046.14093-1-anand.jain@oracle.com>

--65vXKfLw5UIIbhLQyzUzhKy0zFh5bSbd7
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8813=E6=97=A5 11:00, Anand Jain wrote:
> Fixes the endianness bug in the fs_info::super_copy by using its
> btrfs_set_super...() function to set values in the SB, as these
> functions manage the endianness compatibility nicely.
>=20
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Also went through all btrfs_super_block SETGET functions, greping using
\><member name>, seems that there are still some left here:

fs/btrfs/sysfs.c:
In both btrfs_sectorsize_show() and btrfs_clone_alignment_show():
	return snprintf(buf, PAGE_SIZE, "%u\n",
			fs_info->super_copy->sectorsize);

In btrfs_nodesize_show():
	return snprintf(buf, PAGE_SIZE, "%u\n", fs_info->super_copy->nodesize);


And what about cc this to stable kernel?
IIRC it's a very critical problem for btrfs.

Maybe cc: stable@vger.kernel.org # v3.2+?

Thanks,
Qu

> ---
> v1->v2: Update change log. Update $Subject.
>         Old:
>         [PATCH] btrfs: use set functions to update latest refs to the S=
B
>  fs/btrfs/transaction.c | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)
>=20
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 04f07144b45c..9220f004001c 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1722,19 +1722,23 @@ static void update_super_roots(struct btrfs_fs_=
info *fs_info)
> =20
>  	super =3D fs_info->super_copy;
> =20
> +	/* update latest btrfs_super_block::chunk_root refs */
>  	root_item =3D &fs_info->chunk_root->root_item;
> -	super->chunk_root =3D root_item->bytenr;
> -	super->chunk_root_generation =3D root_item->generation;
> -	super->chunk_root_level =3D root_item->level;
> +	btrfs_set_super_chunk_root(super, root_item->bytenr);
> +	btrfs_set_super_chunk_root_generation(super, root_item->generation);
> +	btrfs_set_super_chunk_root_level(super, root_item->level);
> =20
> +	/* update latest btrfs_super_block::root refs */
>  	root_item =3D &fs_info->tree_root->root_item;
> -	super->root =3D root_item->bytenr;
> -	super->generation =3D root_item->generation;
> -	super->root_level =3D root_item->level;
> +	btrfs_set_super_root(super, root_item->bytenr);
> +	btrfs_set_super_generation(super, root_item->generation);
> +	btrfs_set_super_root_level(super, root_item->level);
> +
>  	if (btrfs_test_opt(fs_info, SPACE_CACHE))
> -		super->cache_generation =3D root_item->generation;
> +		btrfs_set_super_cache_generation(super, root_item->generation);
>  	if (test_bit(BTRFS_FS_UPDATE_UUID_TREE_GEN, &fs_info->flags))
> -		super->uuid_tree_generation =3D root_item->generation;
> +		btrfs_set_super_uuid_tree_generation(super,
> +						     root_item->generation);
>  }
> =20
>  int btrfs_transaction_in_commit(struct btrfs_fs_info *info)
>=20


--65vXKfLw5UIIbhLQyzUzhKy0zFh5bSbd7--

--80OCkn8lhhaenVwMvChNzCLl7Kw3ejHk8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqCqXYXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgSuAf+PygFTtY0Po/XLWOqIIOUjJYg
cQ1bMv9UOhlyVO4vGb6p+HDaOtMPTN1pD+pWiaXTeM/zRd1S23FXIyFTBm5WRLEM
2//UWnTNC8IA9Fzq57q8xlD47lh1dcpejz9kze2YPVhY7i5tyy40VOkZov3Erp84
K/sgqxvOaHDxwGtAYjUKxrdXNlgS+78PI17Zg46JKm5QeT3hEO5QBkydjWbL99KE
4EWcLypBcIm8dyUrZqpSKICrCYrH5Mzj8sNzIU68SvV7rbb6tFQk549C1ksq2P8d
jf6cXFRVe7s7lEbiu80vV0spXuXOIVJ01LPSvmtMjJJz7rqriWEb6259qqo6iA==
=mHVZ
-----END PGP SIGNATURE-----

--80OCkn8lhhaenVwMvChNzCLl7Kw3ejHk8--
