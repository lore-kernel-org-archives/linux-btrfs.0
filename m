Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:43307 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751675AbeCWJO5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Mar 2018 05:14:57 -0400
Subject: Re: [PATCH] btrfs-progs: remove BTRFS_CRC32_SIZE definition
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>
References: <ca28000d-f496-8fb6-47a8-48a962a9f172@jp.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <a41c7961-fd69-ddbf-e831-769446868a5c@gmx.com>
Date: Fri, 23 Mar 2018 17:14:40 +0800
MIME-Version: 1.0
In-Reply-To: <ca28000d-f496-8fb6-47a8-48a962a9f172@jp.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Ese6DM5eaWpNoAhAYQdPEIqtBeDsgcYnd"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Ese6DM5eaWpNoAhAYQdPEIqtBeDsgcYnd
Content-Type: multipart/mixed; boundary="owPEUZqsi3XZ4FJqeACXZ6Wubo2dKEuIl";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
 linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>
Message-ID: <a41c7961-fd69-ddbf-e831-769446868a5c@gmx.com>
Subject: Re: [PATCH] btrfs-progs: remove BTRFS_CRC32_SIZE definition
References: <ca28000d-f496-8fb6-47a8-48a962a9f172@jp.fujitsu.com>
In-Reply-To: <ca28000d-f496-8fb6-47a8-48a962a9f172@jp.fujitsu.com>

--owPEUZqsi3XZ4FJqeACXZ6Wubo2dKEuIl
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8823=E6=97=A5 16:20, Misono Tomohiro wrote:
> The kernel code no longer has BTRFS_CRC32_SIZE and only uses
> btrfs_csum_sizes[]. So, update the progs code as well.
>=20
> Suggested-by: Qu Wenruo <wqu@suse.com>
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
> ---
>  convert/common.c |  2 +-
>  convert/main.c   |  2 +-
>  ctree.h          |  3 +--
>  image/main.c     |  4 ++--
>  mkfs/common.c    | 14 +++++++-------
>  5 files changed, 12 insertions(+), 13 deletions(-)
>=20
> diff --git a/convert/common.c b/convert/common.c
> index 3860f3b9..2b944fd8 100644
> --- a/convert/common.c
> +++ b/convert/common.c
> @@ -219,7 +219,7 @@ static inline int write_temp_extent_buffer(int fd, =
struct extent_buffer *buf,
>  {
>  	int ret;
> =20
> -	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
> +	csum_tree_block_size(buf, btrfs_csum_sizes[BTRFS_CSUM_TYPE_CRC32], 0)=
;

I'd say the normal kernel way to do this is like this, other than using
BTRFS_CSUM_TYPE_CRC32:
	u16 csum_size =3D btrfs_super_csum_size(fs_info->super_copy);

Thanks,
Qu

> =20
>  	/* Temporary extent buffer is always mapped 1:1 on disk */
>  	ret =3D pwrite(fd, buf->data, buf->len, bytenr);
> diff --git a/convert/main.c b/convert/main.c
> index b3ea31d7..6bdfab40 100644
> --- a/convert/main.c
> +++ b/convert/main.c
> @@ -1026,7 +1026,7 @@ static int migrate_super_block(int fd, u64 old_by=
tenr)
>  	BUG_ON(btrfs_super_bytenr(super) !=3D old_bytenr);
>  	btrfs_set_super_bytenr(super, BTRFS_SUPER_INFO_OFFSET);
> =20
> -	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
> +	csum_tree_block_size(buf, btrfs_csum_sizes[BTRFS_CSUM_TYPE_CRC32], 0)=
;
>  	ret =3D pwrite(fd, buf->data, BTRFS_SUPER_INFO_SIZE,
>  		BTRFS_SUPER_INFO_OFFSET);
>  	if (ret !=3D BTRFS_SUPER_INFO_SIZE)
> diff --git a/ctree.h b/ctree.h
> index 17cdac76..4175cb85 100644
> --- a/ctree.h
> +++ b/ctree.h
> @@ -167,10 +167,9 @@ struct btrfs_free_space_ctl;
>  /* csum types */
>  #define BTRFS_CSUM_TYPE_CRC32	0
> =20
> +/* four bytes for CRC32 */
>  static int btrfs_csum_sizes[] =3D { 4 };
> =20
> -/* four bytes for CRC32 */
> -#define BTRFS_CRC32_SIZE 4
>  #define BTRFS_EMPTY_DIR_SIZE 0
> =20
>  #define BTRFS_FT_UNKNOWN	0
> diff --git a/image/main.c b/image/main.c
> index 9c75c8b4..5f155c23 100644
> --- a/image/main.c
> +++ b/image/main.c
> @@ -119,11 +119,11 @@ static struct extent_buffer *alloc_dummy_eb(u64 b=
ytenr, u32 size);
> =20
>  static void csum_block(u8 *buf, size_t len)
>  {
> -	u8 result[BTRFS_CRC32_SIZE];
> +	u8 result[btrfs_csum_sizes[BTRFS_CSUM_TYPE_CRC32]];
>  	u32 crc =3D ~(u32)0;
>  	crc =3D crc32c(crc, buf + BTRFS_CSUM_SIZE, len - BTRFS_CSUM_SIZE);
>  	btrfs_csum_final(crc, result);
> -	memcpy(buf, result, BTRFS_CRC32_SIZE);
> +	memcpy(buf, result, btrfs_csum_sizes[BTRFS_CSUM_TYPE_CRC32]);
>  }
> =20
>  static int has_name(struct btrfs_key *key)
> diff --git a/mkfs/common.c b/mkfs/common.c
> index 16916ca2..50b99639 100644
> --- a/mkfs/common.c
> +++ b/mkfs/common.c
> @@ -85,7 +85,7 @@ static int btrfs_create_tree_root(int fd, struct btrf=
s_mkfs_config *cfg,
>  	}
> =20
>  	/* generate checksum */
> -	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
> +	csum_tree_block_size(buf, btrfs_csum_sizes[BTRFS_CSUM_TYPE_CRC32], 0)=
;
> =20
>  	/* write back root tree */
>  	ret =3D pwrite(fd, buf->data, cfg->nodesize, cfg->blocks[MKFS_ROOT_TR=
EE]);
> @@ -276,7 +276,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cf=
g)
>  	btrfs_set_header_bytenr(buf, cfg->blocks[MKFS_EXTENT_TREE]);
>  	btrfs_set_header_owner(buf, BTRFS_EXTENT_TREE_OBJECTID);
>  	btrfs_set_header_nritems(buf, nritems);
> -	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
> +	csum_tree_block_size(buf, btrfs_csum_sizes[BTRFS_CSUM_TYPE_CRC32], 0)=
;
>  	ret =3D pwrite(fd, buf->data, cfg->nodesize, cfg->blocks[MKFS_EXTENT_=
TREE]);
>  	if (ret !=3D cfg->nodesize) {
>  		ret =3D (ret < 0 ? -errno : -EIO);
> @@ -364,7 +364,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cf=
g)
>  	btrfs_set_header_bytenr(buf, cfg->blocks[MKFS_CHUNK_TREE]);
>  	btrfs_set_header_owner(buf, BTRFS_CHUNK_TREE_OBJECTID);
>  	btrfs_set_header_nritems(buf, nritems);
> -	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
> +	csum_tree_block_size(buf, btrfs_csum_sizes[BTRFS_CSUM_TYPE_CRC32], 0)=
;
>  	ret =3D pwrite(fd, buf->data, cfg->nodesize, cfg->blocks[MKFS_CHUNK_T=
REE]);
>  	if (ret !=3D cfg->nodesize) {
>  		ret =3D (ret < 0 ? -errno : -EIO);
> @@ -404,7 +404,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cf=
g)
>  	btrfs_set_header_bytenr(buf, cfg->blocks[MKFS_DEV_TREE]);
>  	btrfs_set_header_owner(buf, BTRFS_DEV_TREE_OBJECTID);
>  	btrfs_set_header_nritems(buf, nritems);
> -	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
> +	csum_tree_block_size(buf, btrfs_csum_sizes[BTRFS_CSUM_TYPE_CRC32], 0)=
;
>  	ret =3D pwrite(fd, buf->data, cfg->nodesize, cfg->blocks[MKFS_DEV_TRE=
E]);
>  	if (ret !=3D cfg->nodesize) {
>  		ret =3D (ret < 0 ? -errno : -EIO);
> @@ -417,7 +417,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cf=
g)
>  	btrfs_set_header_bytenr(buf, cfg->blocks[MKFS_FS_TREE]);
>  	btrfs_set_header_owner(buf, BTRFS_FS_TREE_OBJECTID);
>  	btrfs_set_header_nritems(buf, 0);
> -	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
> +	csum_tree_block_size(buf, btrfs_csum_sizes[BTRFS_CSUM_TYPE_CRC32], 0)=
;
>  	ret =3D pwrite(fd, buf->data, cfg->nodesize, cfg->blocks[MKFS_FS_TREE=
]);
>  	if (ret !=3D cfg->nodesize) {
>  		ret =3D (ret < 0 ? -errno : -EIO);
> @@ -429,7 +429,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cf=
g)
>  	btrfs_set_header_bytenr(buf, cfg->blocks[MKFS_CSUM_TREE]);
>  	btrfs_set_header_owner(buf, BTRFS_CSUM_TREE_OBJECTID);
>  	btrfs_set_header_nritems(buf, 0);
> -	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
> +	csum_tree_block_size(buf, btrfs_csum_sizes[BTRFS_CSUM_TYPE_CRC32], 0)=
;
>  	ret =3D pwrite(fd, buf->data, cfg->nodesize, cfg->blocks[MKFS_CSUM_TR=
EE]);
>  	if (ret !=3D cfg->nodesize) {
>  		ret =3D (ret < 0 ? -errno : -EIO);
> @@ -440,7 +440,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cf=
g)
>  	memset(buf->data, 0, BTRFS_SUPER_INFO_SIZE);
>  	memcpy(buf->data, &super, sizeof(super));
>  	buf->len =3D BTRFS_SUPER_INFO_SIZE;
> -	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
> +	csum_tree_block_size(buf, btrfs_csum_sizes[BTRFS_CSUM_TYPE_CRC32], 0)=
;
>  	ret =3D pwrite(fd, buf->data, BTRFS_SUPER_INFO_SIZE,
>  			cfg->blocks[MKFS_SUPER_BLOCK]);
>  	if (ret !=3D BTRFS_SUPER_INFO_SIZE) {
>=20


--owPEUZqsi3XZ4FJqeACXZ6Wubo2dKEuIl--

--Ese6DM5eaWpNoAhAYQdPEIqtBeDsgcYnd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlq0xYAXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhwxQf+K4VN9yfwKn7Ia09X+USBOtRz
ZafQ4NL+gnEEC8R91hGf0VCxNiqigxprJ9i5eBiOdmTLv/r4SeQEEX+FNQB84OOF
6Hn5zLELUib0kC8tZH4N8H9e3yImqe8MYVdzWnEFZ+oBEw5aMW+Q0mqtKn6jNLHE
Ndj+42m6M9UNtZd9Wo/kGhDr2RHgoUR0ax2rLdgq5ksw+VWWSPW+/Fok9u0d8fuF
/SUs2CFMXkuW6R0qP0B+dxRTCWA+axZ5290dhIh4zHlqlk6Wdd/aNJyHwCWjJsYt
fBMJ/1G7G+UqFf4OeaDyu1JW0G1OUfeavmxN2Dw9ODLxaQVVhAzEFZUD44dTmg==
=pV3n
-----END PGP SIGNATURE-----

--Ese6DM5eaWpNoAhAYQdPEIqtBeDsgcYnd--
