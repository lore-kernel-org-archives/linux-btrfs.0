Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:60187 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751493AbeAZFbL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 00:31:11 -0500
Subject: Re: [PATCH 4/6] btrfs-progs: Use fs_info instead of root for
 BTRFS_MAX_XATTR_SIZE
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <1516936926-18707-1-git-send-email-gujx@cn.fujitsu.com>
 <1516936926-18707-4-git-send-email-gujx@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <10bbd7df-ab9d-fe3f-b6dc-ef51444d8321@gmx.com>
Date: Fri, 26 Jan 2018 13:31:04 +0800
MIME-Version: 1.0
In-Reply-To: <1516936926-18707-4-git-send-email-gujx@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="C21NyaQWy0h5FuGgwpsYjiJgY1ZTCgGTj"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--C21NyaQWy0h5FuGgwpsYjiJgY1ZTCgGTj
Content-Type: multipart/mixed; boundary="znd1GTdEb3Dnz6uJ9WewggywcgYUzVpuj";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <10bbd7df-ab9d-fe3f-b6dc-ef51444d8321@gmx.com>
Subject: Re: [PATCH 4/6] btrfs-progs: Use fs_info instead of root for
 BTRFS_MAX_XATTR_SIZE
References: <1516936926-18707-1-git-send-email-gujx@cn.fujitsu.com>
 <1516936926-18707-4-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1516936926-18707-4-git-send-email-gujx@cn.fujitsu.com>

--znd1GTdEb3Dnz6uJ9WewggywcgYUzVpuj
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8826=E6=97=A5 11:22, Gu Jinxiang wrote:
> Do a cleanup. Also make it consistent with kernel.
> Use fs_info instead of root for BTRFS_MAX_XATTR_SIZE, since
> maybe in some situation we do not know root, but just know fs_info.
>=20
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
> ---
>  ctree.h    | 2 +-
>  dir-item.c | 3 ++-
>  2 files changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/ctree.h b/ctree.h
> index ace93cc3..c82e7547 100644
> --- a/ctree.h
> +++ b/ctree.h
> @@ -364,7 +364,7 @@ struct btrfs_header {
>  #define BTRFS_MAX_INLINE_DATA_SIZE(fs_info) (BTRFS_LEAF_DATA_SIZE(fs_i=
nfo) - \
>  					sizeof(struct btrfs_item) - \
>  					sizeof(struct btrfs_file_extent_item))
> -#define BTRFS_MAX_XATTR_SIZE(r)	(BTRFS_LEAF_DATA_SIZE(r->fs_info) - \
> +#define BTRFS_MAX_XATTR_SIZE(fs_info)	(BTRFS_LEAF_DATA_SIZE(fs_info) -=
 \
>  				 sizeof(struct btrfs_item) -\
>  				 sizeof(struct btrfs_dir_item))

For sake of consistency, it's better to copy kernel definition here.

Thanks,
Qu

> =20
> diff --git a/dir-item.c b/dir-item.c
> index 462546c0..0b7250c9 100644
> --- a/dir-item.c
> +++ b/dir-item.c
> @@ -311,7 +311,8 @@ static int verify_dir_item(struct btrfs_root *root,=

> =20
>  	/* BTRFS_MAX_XATTR_SIZE is the same for all dir items */
>  	if ((btrfs_dir_data_len(leaf, dir_item) +
> -	     btrfs_dir_name_len(leaf, dir_item)) > BTRFS_MAX_XATTR_SIZE(root)=
) {
> +	     btrfs_dir_name_len(leaf, dir_item)) >
> +			BTRFS_MAX_XATTR_SIZE(root->fs_info)) {
>  		fprintf(stderr, "invalid dir item name + data len: %u + %u\n",
>  		       (unsigned)btrfs_dir_name_len(leaf, dir_item),
>  		       (unsigned)btrfs_dir_data_len(leaf, dir_item));
>=20


--znd1GTdEb3Dnz6uJ9WewggywcgYUzVpuj--

--C21NyaQWy0h5FuGgwpsYjiJgY1ZTCgGTj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpqvRgXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qi/eQf/QTvHytJkZzL3HkPyKPtslzU0
Jx8rcxJOGAVPlX3zjfUnO9k20PCJc4vf04HWdQN5APIg88ij6PJVO+1ff5aVSZWJ
bfcNCg10Sn54JSLyKWncImFt5PPITEfVbrmwj9aJiDsVN02QzciI5IkZjqiVhe1K
c2FY4SRRKA3uhd2N674e3TJ3sBmIzDZ8Uu9xMLtRP8onCLwLYaWRHrd1+okBalIU
dUqPldGW/WG6nvZhSESwMAIng7mqgtaYj30Lbj4AchgJHzOLogZ4koa7plTgwzeK
PwuiGQb6W72OhW4HhYKffNGH5pVadnLbUZZlKtstZDCNO5DM/1iSiey6rgGxFA==
=YtK6
-----END PGP SIGNATURE-----

--C21NyaQWy0h5FuGgwpsYjiJgY1ZTCgGTj--
