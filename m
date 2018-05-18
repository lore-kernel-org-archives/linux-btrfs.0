Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:54337 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750763AbeERFVG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 May 2018 01:21:06 -0400
Subject: Re: [PATCH v2 3/6] Btrfs: move get root of btrfs_search_slot to a
 helper
To: Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
References: <1526612424-97061-1-git-send-email-bo.liu@linux.alibaba.com>
 <1526612424-97061-4-git-send-email-bo.liu@linux.alibaba.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <73ee76a8-c036-338d-8743-c40424fa7120@gmx.com>
Date: Fri, 18 May 2018 13:20:58 +0800
MIME-Version: 1.0
In-Reply-To: <1526612424-97061-4-git-send-email-bo.liu@linux.alibaba.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="udvq28Ng05LMb8LbPZ2HHmQfklL3oCnBT"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--udvq28Ng05LMb8LbPZ2HHmQfklL3oCnBT
Content-Type: multipart/mixed; boundary="4yKFYqRLX7ppjR5DSmwzFy5LUdvbm8YoX";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
Message-ID: <73ee76a8-c036-338d-8743-c40424fa7120@gmx.com>
Subject: Re: [PATCH v2 3/6] Btrfs: move get root of btrfs_search_slot to a
 helper
References: <1526612424-97061-1-git-send-email-bo.liu@linux.alibaba.com>
 <1526612424-97061-4-git-send-email-bo.liu@linux.alibaba.com>
In-Reply-To: <1526612424-97061-4-git-send-email-bo.liu@linux.alibaba.com>

--4yKFYqRLX7ppjR5DSmwzFy5LUdvbm8YoX
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8818=E6=97=A5 11:00, Liu Bo wrote:
> It's good to have a helper instead of having all get-root details
> open-coded.
>=20
> The new helper locks (if necessary) and sets root node of the path.
>=20
> Also invert the checks to make the code flow easier to read.
>=20
> There is no functional change in this commit.
>=20
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>

Less indents with better use of goto tag, indeed easier to read.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  fs/btrfs/ctree.c | 115 +++++++++++++++++++++++++++++++++--------------=
--------
>  1 file changed, 70 insertions(+), 45 deletions(-)
>=20
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index a96d308c51b8..d12fc0474e21 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -2598,6 +2598,75 @@ int btrfs_find_item(struct btrfs_root *fs_root, =
struct btrfs_path *path,
>  	return 0;
>  }
> =20
> +static struct extent_buffer *btrfs_search_slot_get_root(struct btrfs_r=
oot *root,
> +							struct btrfs_path *p,
> +							int write_lock_level)
> +{
> +	struct btrfs_fs_info *fs_info =3D root->fs_info;
> +	struct extent_buffer *b;
> +	int root_lock;
> +	int level =3D 0;
> +
> +	/*
> +	 * we try very hard to do read locks on the root
> +	 */
> +	root_lock =3D BTRFS_READ_LOCK;
> +
> +	if (p->search_commit_root) {
> +		/*
> +		 * the commit roots are read only so we always do read locks
> +		 */
> +		if (p->need_commit_sem)
> +			down_read(&fs_info->commit_root_sem);
> +		b =3D root->commit_root;
> +		extent_buffer_get(b);
> +		level =3D btrfs_header_level(b);
> +		if (p->need_commit_sem)
> +			up_read(&fs_info->commit_root_sem);
> +		if (!p->skip_locking)
> +			btrfs_tree_read_lock(b);
> +
> +		goto out;
> +	}
> +
> +	if (p->skip_locking) {
> +		b =3D btrfs_root_node(root);
> +		level =3D btrfs_header_level(b);
> +		goto out;
> +	}
> +
> +	/*
> +	 * we don't know the level of the root node until we actually
> +	 * have it read locked
> +	 */
> +	b =3D btrfs_read_lock_root_node(root);
> +	level =3D btrfs_header_level(b);
> +	if (level > write_lock_level)
> +		goto out;
> +
> +	/*
> +	 * whoops, must trade for write lock
> +	 */
> +	btrfs_tree_read_unlock(b);
> +	free_extent_buffer(b);
> +	b =3D btrfs_lock_root_node(root);
> +	root_lock =3D BTRFS_WRITE_LOCK;
> +	/*
> +	 * the level might have changed, check again
> +	 */
> +	level =3D btrfs_header_level(b);
> +
> +out:
> +	p->nodes[level] =3D b;
> +	if (!p->skip_locking)
> +		p->locks[level] =3D root_lock;
> +	/*
> +	 * Callers are responsible for drop b's refs.
> +	 */
> +	return b;
> +}
> +
> +
>  /*
>   * btrfs_search_slot - look for a key in a tree and perform necessary
>   * modifications to preserve tree invariants.
> @@ -2634,7 +2703,6 @@ int btrfs_search_slot(struct btrfs_trans_handle *=
trans, struct btrfs_root *root,
>  	int err;
>  	int level;
>  	int lowest_unlock =3D 1;
> -	int root_lock;
>  	/* everything at write_lock_level or lower must be write locked */
>  	int write_lock_level =3D 0;
>  	u8 lowest_level =3D 0;
> @@ -2672,50 +2740,7 @@ int btrfs_search_slot(struct btrfs_trans_handle =
*trans, struct btrfs_root *root,
> =20
>  again:
>  	prev_cmp =3D -1;
> -	/*
> -	 * we try very hard to do read locks on the root
> -	 */
> -	root_lock =3D BTRFS_READ_LOCK;
> -	level =3D 0;
> -	if (p->search_commit_root) {
> -		/*
> -		 * the commit roots are read only
> -		 * so we always do read locks
> -		 */
> -		if (p->need_commit_sem)
> -			down_read(&fs_info->commit_root_sem);
> -		b =3D root->commit_root;
> -		extent_buffer_get(b);
> -		level =3D btrfs_header_level(b);
> -		if (p->need_commit_sem)
> -			up_read(&fs_info->commit_root_sem);
> -		if (!p->skip_locking)
> -			btrfs_tree_read_lock(b);
> -	} else {
> -		if (p->skip_locking) {
> -			b =3D btrfs_root_node(root);
> -			level =3D btrfs_header_level(b);
> -		} else {
> -			/* we don't know the level of the root node
> -			 * until we actually have it read locked
> -			 */
> -			b =3D btrfs_read_lock_root_node(root);
> -			level =3D btrfs_header_level(b);
> -			if (level <=3D write_lock_level) {
> -				/* whoops, must trade for write lock */
> -				btrfs_tree_read_unlock(b);
> -				free_extent_buffer(b);
> -				b =3D btrfs_lock_root_node(root);
> -				root_lock =3D BTRFS_WRITE_LOCK;
> -
> -				/* the level might have changed, check again */
> -				level =3D btrfs_header_level(b);
> -			}
> -		}
> -	}
> -	p->nodes[level] =3D b;
> -	if (!p->skip_locking)
> -		p->locks[level] =3D root_lock;
> +	b =3D btrfs_search_slot_get_root(root, p, write_lock_level);
> =20
>  	while (b) {
>  		level =3D btrfs_header_level(b);
>=20


--4yKFYqRLX7ppjR5DSmwzFy5LUdvbm8YoX--

--udvq28Ng05LMb8LbPZ2HHmQfklL3oCnBT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlr+YroACgkQwj2R86El
/qjlHwf/UdfNj28cYWcPrBWztRKrkkhbpyaJXB2VM+X6xoKEvRhN/f+Ym2G/uTgc
4Ee9tWhPLcWtCBVgO0+FcX76QJ8CkmG7BG3BAhAapzRlrv+kiUaRO9oD+I4xlhxB
TT5QaDes91dcV1JKdU9HkCyTfbx0DzoZpDYtE5vZo4YkQSaY4RKDAPHZp+iQkh4i
tatEk45JEB44oNWL6Rn5Pp0qU0vn+LOrxOIjpe6H1Xn8cFP/wn/sD07p20Z7KBa0
d2+oK/LunXgFSM48bTIau17ubNfszGRdWWNR8zBK25D19+y4T/4ou27idt0/9RXo
MrZvr556BBNy9d3XSAq4ziUVv5cd0g==
=3CAS
-----END PGP SIGNATURE-----

--udvq28Ng05LMb8LbPZ2HHmQfklL3oCnBT--
