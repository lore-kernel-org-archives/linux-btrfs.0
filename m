Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:62430 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751427AbeAZF34 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 00:29:56 -0500
Subject: Re: [PATCH 3/6] btrfs-progs: Use fs_info instead of root for
 BTRFS_MAX_INLINE_DATA_SIZE
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <1516936926-18707-1-git-send-email-gujx@cn.fujitsu.com>
 <1516936926-18707-3-git-send-email-gujx@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <ea670ded-f8cb-eb91-a341-7704a0f3f9a5@gmx.com>
Date: Fri, 26 Jan 2018 13:29:49 +0800
MIME-Version: 1.0
In-Reply-To: <1516936926-18707-3-git-send-email-gujx@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6p3vrBF196mCgjVJu2i1dEA0pbb44oFeS"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6p3vrBF196mCgjVJu2i1dEA0pbb44oFeS
Content-Type: multipart/mixed; boundary="q0Onmj4SoQZykqOWb32qVGdyHtrr3otNN";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <ea670ded-f8cb-eb91-a341-7704a0f3f9a5@gmx.com>
Subject: Re: [PATCH 3/6] btrfs-progs: Use fs_info instead of root for
 BTRFS_MAX_INLINE_DATA_SIZE
References: <1516936926-18707-1-git-send-email-gujx@cn.fujitsu.com>
 <1516936926-18707-3-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1516936926-18707-3-git-send-email-gujx@cn.fujitsu.com>

--q0Onmj4SoQZykqOWb32qVGdyHtrr3otNN
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8826=E6=97=A5 11:22, Gu Jinxiang wrote:
> Do a cleanup. Also make it consistent with kernel.
> Use fs_info instead of root for BTRFS_MAX_INLINE_DATA_SIZE, since
> maybe in some situation we do not know root, but just know fs_info.
>=20
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
> ---
>  convert/source-ext2.c     | 2 +-
>  convert/source-reiserfs.c | 2 +-
>  ctree.h                   | 2 +-
>  mkfs/main.c               | 4 ++--
>  4 files changed, 5 insertions(+), 5 deletions(-)
>=20
> diff --git a/convert/source-ext2.c b/convert/source-ext2.c
> index e5c2a943..f5ecd8cf 100644
> --- a/convert/source-ext2.c
> +++ b/convert/source-ext2.c
> @@ -309,7 +309,7 @@ static int ext2_create_file_extents(struct btrfs_tr=
ans_handle *trans,
>  		goto fail;
>  	if ((convert_flags & CONVERT_FLAG_INLINE_DATA) && data.first_block =3D=
=3D 0
>  	    && data.num_blocks > 0
> -	    && inode_size <=3D BTRFS_MAX_INLINE_DATA_SIZE(root)) {
> +	    && inode_size <=3D BTRFS_MAX_INLINE_DATA_SIZE(root->fs_info)) {
>  		u64 num_bytes =3D data.num_blocks * sectorsize;
>  		u64 disk_bytenr =3D data.disk_block * sectorsize;
>  		u64 nbytes;
> diff --git a/convert/source-reiserfs.c b/convert/source-reiserfs.c
> index e3582bda..39d6f072 100644
> --- a/convert/source-reiserfs.c
> +++ b/convert/source-reiserfs.c
> @@ -376,7 +376,7 @@ static int reiserfs_convert_tail(struct btrfs_trans=
_handle *trans,
>  	u64 isize;
>  	int ret;
> =20
> -	if (length >=3D BTRFS_MAX_INLINE_DATA_SIZE(root))
> +	if (length >=3D BTRFS_MAX_INLINE_DATA_SIZE(root->fs_info))
>  		return convert_direct(trans, root, objectid, inode, body,
>  				      length, offset, convert_flags);
> =20
> diff --git a/ctree.h b/ctree.h
> index 9e9d3d22..ace93cc3 100644
> --- a/ctree.h
> +++ b/ctree.h
> @@ -361,7 +361,7 @@ struct btrfs_header {
>  #define __BTRFS_LEAF_DATA_SIZE(bs) ((bs) - sizeof(struct btrfs_header)=
)
>  #define BTRFS_LEAF_DATA_SIZE(fs_info) \
>  				(__BTRFS_LEAF_DATA_SIZE(fs_info->nodesize))
> -#define BTRFS_MAX_INLINE_DATA_SIZE(r) (BTRFS_LEAF_DATA_SIZE(r->fs_info=
) - \
> +#define BTRFS_MAX_INLINE_DATA_SIZE(fs_info) (BTRFS_LEAF_DATA_SIZE(fs_i=
nfo) - \
>  					sizeof(struct btrfs_item) - \
>  					sizeof(struct btrfs_file_extent_item))

I found this function is different from kernel one, not only in
declaration, but also result:

Kernel one is:
BTRFS_MAX_ITEM_SIZE(info) - BTRFS_FILE_EXTENT_INLINE_DATA_START

Which equals to:
BTRFS_LEAF_DATA_SIZE(info) - sizeof(struct btrfs_item) - =09
(offsetof(struct btrfs_file_extent_item, disk_bytenr))

However in btrfs-progs we have:
BTRFS_LEAF_DATA_SIZE(fs_info) - sizeof(struct btrfs_item) -
sizeof(struct btrfs_file_extent_item).

Although the btrfs-progs definition is safer, but for sake of
consistency, it's better to copy the whole kernel definition here.

Thanks,
Qu

>  #define BTRFS_MAX_XATTR_SIZE(r)	(BTRFS_LEAF_DATA_SIZE(r->fs_info) - \
> diff --git a/mkfs/main.c b/mkfs/main.c
> index d817ad8d..a301efc3 100644
> --- a/mkfs/main.c
> +++ b/mkfs/main.c
> @@ -498,7 +498,7 @@ static int fill_inode_item(struct btrfs_trans_handl=
e *trans,
>  	}
>  	if (S_ISREG(src->st_mode)) {
>  		btrfs_set_stack_inode_size(dst, (u64)src->st_size);
> -		if (src->st_size <=3D BTRFS_MAX_INLINE_DATA_SIZE(root))
> +		if (src->st_size <=3D BTRFS_MAX_INLINE_DATA_SIZE(root->fs_info))
>  			btrfs_set_stack_inode_nbytes(dst, src->st_size);
>  		else {
>  			blocks =3D src->st_size / sectorsize;
> @@ -686,7 +686,7 @@ static int add_file_items(struct btrfs_trans_handle=
 *trans,
>  	if (st->st_size % sectorsize)
>  		blocks +=3D 1;
> =20
> -	if (st->st_size <=3D BTRFS_MAX_INLINE_DATA_SIZE(root)) {
> +	if (st->st_size <=3D BTRFS_MAX_INLINE_DATA_SIZE(root->fs_info)) {
>  		char *buffer =3D malloc(st->st_size);
> =20
>  		if (!buffer) {
>=20


--q0Onmj4SoQZykqOWb32qVGdyHtrr3otNN--

--6p3vrBF196mCgjVJu2i1dEA0pbb44oFeS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpqvM0XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qiUwAf+LjN3dHsb3GlWv4JYblkbwxAi
u9BzXHqQqVmxgRQKjpG6n4ZU8JwJL6D9i9v+8knE/BEBJO6WLyPhx2XQGDUVg2LU
Z91THxlJYZYYE13mIvTCpzaZG7lpYxItT1kcVa+b9skdE5Qq17TfrNpCymjdjR+T
gZ5uempIzyuGMB5PcQpSq+DyO06P+BbsUTbTb0oGpXQCY71GoABjfz5Bb/GAjOQ8
ASbVlGgn4NYpzRiiWcgZ64h1eTazhtKe/f5x+bxNqdQgsc+2ySyzivd+U4EiOxxI
TWdYb+Bkbd5t2+gXnrjQU3czo5E780KJ3xjWwDF3hi9qeChkdazNatSaCJOQGw==
=kQhg
-----END PGP SIGNATURE-----

--6p3vrBF196mCgjVJu2i1dEA0pbb44oFeS--
