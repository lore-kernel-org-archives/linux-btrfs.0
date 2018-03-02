Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:53227 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1164179AbeCBCel (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Mar 2018 21:34:41 -0500
Subject: Re: [PATCH 1/3] btrfs: Embed sector size check into
 BTRFS_MAX_INLINE_DATA_SIZE()
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20180302020948.24816-1-wqu@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <8d7bfa19-a17e-744d-2bb0-f1183721e044@gmx.com>
Date: Fri, 2 Mar 2018 10:34:23 +0800
MIME-Version: 1.0
In-Reply-To: <20180302020948.24816-1-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Qj7SyNhYF61INWykWp9Eq0NjXmW3jaa2d"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Qj7SyNhYF61INWykWp9Eq0NjXmW3jaa2d
Content-Type: multipart/mixed; boundary="2PZ0epdOjTbkngxafJrUdsdS3qTSOL02V";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Message-ID: <8d7bfa19-a17e-744d-2bb0-f1183721e044@gmx.com>
Subject: Re: [PATCH 1/3] btrfs: Embed sector size check into
 BTRFS_MAX_INLINE_DATA_SIZE()
References: <20180302020948.24816-1-wqu@suse.com>
In-Reply-To: <20180302020948.24816-1-wqu@suse.com>

--2PZ0epdOjTbkngxafJrUdsdS3qTSOL02V
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

This patch along with any one uses sector/node size in
btrfs_parse_options() should only use them after it get initialized.

Unfortunately at this point, nodesize is not initialized in open_ctree().=


So unfortunately, this patch needs extra work to move
btrfs_parse_options() after basic fs_info initialization, and please
ignore this version.

Thanks,
Qu

On 2018=E5=B9=B403=E6=9C=8802=E6=97=A5 10:09, Qu Wenruo wrote:
> We have extra sector size check in cow_file_range_inline(), but doesn't=

> implement it in BTRFS_MAX_INLINE_DATA_SIZE().
>=20
> The biggest reason is that btrfs_symlink() also uses this macro to chec=
k
> name length.
>=20
> In fact such behavior makes max_inline calculation quite confusing, and=

> cause unexpected large extent for symbol link.
>=20
> Here we embed sector size check into BTRFS_MAX_INLINE_DATA_SIZE() so
> that it will never exceed sector size.
>=20
> The downside is, for symbol link, we will reduce max symbol link length=

> from 16K- to 4095, but it won't affect current system using that long
> name, but only prevent later creation.
>=20
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/ctree.h | 5 +++--
>  fs/btrfs/inode.c | 1 -
>  2 files changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 13c260b525a1..90948096c00f 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1297,8 +1297,9 @@ static inline u32 BTRFS_NODEPTRS_PER_BLOCK(const =
struct btrfs_fs_info *info)
>  		(offsetof(struct btrfs_file_extent_item, disk_bytenr))
>  static inline u32 BTRFS_MAX_INLINE_DATA_SIZE(const struct btrfs_fs_inf=
o *info)
>  {
> -	return BTRFS_MAX_ITEM_SIZE(info) -
> -	       BTRFS_FILE_EXTENT_INLINE_DATA_START;
> +	return min_t(u32, info->sectorsize - 1,
> +		     BTRFS_MAX_ITEM_SIZE(info) -
> +		     BTRFS_FILE_EXTENT_INLINE_DATA_START);
>  }
> =20
>  static inline u32 BTRFS_MAX_XATTR_SIZE(const struct btrfs_fs_info *inf=
o)
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index e1a7f3cb5be9..0f7041e10c67 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -299,7 +299,6 @@ static noinline int cow_file_range_inline(struct bt=
rfs_root *root,
> =20
>  	if (start > 0 ||
>  	    actual_end > fs_info->sectorsize ||
> -	    data_len > BTRFS_MAX_INLINE_DATA_SIZE(fs_info) ||
>  	    (!compressed_size &&
>  	    (actual_end & (fs_info->sectorsize - 1)) =3D=3D 0) ||
>  	    end + 1 < isize ||
>=20


--2PZ0epdOjTbkngxafJrUdsdS3qTSOL02V--

--Qj7SyNhYF61INWykWp9Eq0NjXmW3jaa2d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqYuC8XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qh6XQf/UXVSRs4t+ztN+jtJuBPO6D/N
TA0UFoQyJa1R5KYHFtWGkJsSRGVwVX7VeHUxUY2DZjfR3/EKlU2UDOY33du4fwHS
sSl4LkWMIgtQn3BJMM2YZn6DE9l6j5PxvCpIs8idxQl4D8V9M4DETaURA8l6GIpf
WZwDMmHpPjsFz/Jeo6ZIVEvy/NNyI8RtYSaMFT7ewZwgWJwg2SglvqLGo/HkDOI0
KvoAT3RNvV1BzMWm6g07WaiiffoAa+u1KclAJSf72LLiys4sHWyD0kC7yEy3LLIx
Ht0u/yyTTXc4/3V6Id734sGl+gS+P2Oi63MOObHmZXOwMR8Ac2CKMFFYo54mVA==
=G6ZL
-----END PGP SIGNATURE-----

--Qj7SyNhYF61INWykWp9Eq0NjXmW3jaa2d--
