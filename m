Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:57219 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729265AbeHORZy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Aug 2018 13:25:54 -0400
Subject: Re: [PATCH v5] btrfs: qgroup: Remove qgroup items along with
 subvolume deletion
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
References: <cover.1533783766.git.misono.tomohiro@jp.fujitsu.com>
 <055391ff-7137-4210-4eff-f2c3f70cf68b@jp.fujitsu.com>
 <1b5d9d72-5e6b-a88b-0192-8676a19b9732@jp.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <61c07c8b-2c85-5c30-ebb8-49182802367c@gmx.com>
Date: Wed, 15 Aug 2018 22:33:15 +0800
MIME-Version: 1.0
In-Reply-To: <1b5d9d72-5e6b-a88b-0192-8676a19b9732@jp.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3VhrvgBQak7RuX2qZV1SaiEYnjI2ZyPFe"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3VhrvgBQak7RuX2qZV1SaiEYnjI2ZyPFe
Content-Type: multipart/mixed; boundary="6GQwNKpVCaIAtXwhSz13nVBht8Hs7hjh5";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
 linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Message-ID: <61c07c8b-2c85-5c30-ebb8-49182802367c@gmx.com>
Subject: Re: [PATCH v5] btrfs: qgroup: Remove qgroup items along with
 subvolume deletion
References: <cover.1533783766.git.misono.tomohiro@jp.fujitsu.com>
 <055391ff-7137-4210-4eff-f2c3f70cf68b@jp.fujitsu.com>
 <1b5d9d72-5e6b-a88b-0192-8676a19b9732@jp.fujitsu.com>
In-Reply-To: <1b5d9d72-5e6b-a88b-0192-8676a19b9732@jp.fujitsu.com>

--6GQwNKpVCaIAtXwhSz13nVBht8Hs7hjh5
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/8/9 =E4=B8=8B=E5=8D=883:05, Misono Tomohiro wrote:
> When qgroup is on, subvolume deletion does not remove qgroup items
> of the subvolume (qgroup info, limit, relation) from quota tree and
> they need to get removed manually by "btrfs qgroup destroy".
>=20
> Since level 0 qgroup cannot be used/inherited by any other subvolume,
> let's remove them automatically when subvolume is deleted
> (to be precise, when the subvolume root is dropped).
>=20
> Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
> ---
> v4 -> v5:
>   Commit current transaction before calling btrfs_remove_qgroup() to
>   keep qgroup consistency in all case. This resolves the concern in
>   v4 path and there should be no demerit in this patch.
>=20
>  fs/btrfs/extent-tree.c | 45 +++++++++++++++++++++++++++++++++++++++++-=
---
>  1 file changed, 41 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 9e7b237b9547..ed052105e741 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -8871,12 +8871,13 @@ int btrfs_drop_snapshot(struct btrfs_root *root=
,
>  	struct btrfs_root_item *root_item =3D &root->root_item;
>  	struct walk_control *wc;
>  	struct btrfs_key key;
> +	u64 objectid =3D root->root_key.objectid;
>  	int err =3D 0;
>  	int ret;
>  	int level;
>  	bool root_dropped =3D false;
> =20
> -	btrfs_debug(fs_info, "Drop subvolume %llu", root->objectid);
> +	btrfs_debug(fs_info, "Drop subvolume %llu", objectid);
> =20
>  	path =3D btrfs_alloc_path();
>  	if (!path) {
> @@ -9030,7 +9031,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
>  		goto out_end_trans;
>  	}
> =20
> -	if (root->root_key.objectid !=3D BTRFS_TREE_RELOC_OBJECTID) {
> +	if (objectid !=3D BTRFS_TREE_RELOC_OBJECTID) {
>  		ret =3D btrfs_find_root(tree_root, &root->root_key, path,
>  				      NULL, NULL);
>  		if (ret < 0) {
> @@ -9043,8 +9044,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
>  			 *
>  			 * The most common failure here is just -ENOENT.
>  			 */
> -			btrfs_del_orphan_item(trans, tree_root,
> -					      root->root_key.objectid);
> +			btrfs_del_orphan_item(trans, tree_root, objectid);
>  		}
>  	}
> =20
> @@ -9056,6 +9056,43 @@ int btrfs_drop_snapshot(struct btrfs_root *root,=

>  		btrfs_put_fs_root(root);
>  	}
>  	root_dropped =3D true;
> +
> +	if (test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags)) {

I would prefer to put the code even further after the out tag just in cas=
e.
Current implement changed @trans and I'm not 100% sure if it's a good ide=
a.

> +		/*
> +		 * Remove level-0 qgroup items since no other subvolume can
> +		 * use them.
> +		 *
> +		 * First, commit current transaction in order to make sure
> +		 * this subvolume's excl =3D=3D rfer =3D=3D 0. Otherwise removing
> +		 * qgroup relation causes qgroup inconsistency if excl !=3D rfer.
> +		 */
> +		ret =3D btrfs_commit_transaction(trans);
> +		if (ret)
> +			goto out_free;
> +
> +		/* Start new transaction and remove qgroup items */
> +		trans =3D btrfs_start_transaction(tree_root, 0);
> +		if (IS_ERR(trans)) {
> +			err =3D PTR_ERR(trans);
> +			goto out_free;
> +		}
> +

It would be better to add some sanity check for current qgroup's rfer/exc=
l.

If it's not 0/0, something must went wrong.

> +		ret =3D btrfs_remove_qgroup(trans, objectid);
> +		if (ret =3D=3D 1) {

And if we do extra sanity check, return value from btrfs_remove_qgroup()
should never be larger than 0.

Thanks,
Qu
> +			/*
> +			 * This means qgroup becomes inconsistent
> +			 * (should not happen since we did transaction commit)
> +			 */
> +			btrfs_warn(fs_info,
> +			"qgroup inconsistency found, need qgroup rescan");
> +		} else if (ret =3D=3D -EINVAL || ret =3D=3D -ENOENT) {
> +			/* qgroup is already removed, just ignore this */
> +		} else if (ret) {
> +			btrfs_abort_transaction(trans, ret);
> +			err =3D ret;
> +		}
> +	}
> +
>  out_end_trans:
>  	btrfs_end_transaction_throttle(trans);
>  out_free:
>=20


--6GQwNKpVCaIAtXwhSz13nVBht8Hs7hjh5--

--3VhrvgBQak7RuX2qZV1SaiEYnjI2ZyPFe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlt0OasACgkQwj2R86El
/qijjggAiyHLQv7/u79Bh9lFvUEIqjPnH9feuQZj6VXxCFZSvvfaInL2xheGt13o
w8nku9UZx8WhZk0auzuxez95psNuPSWDfp7wU82vQ2OIdHSiErRNftmpfT8RUyu6
rYZm1J1sGWQ68B+OHxufn01Rczer6VoYks4yF1VVkppBgEOwXCsKil3hs6MhFBQL
0g8Mn7pfhwA2fjwc4rxi5ylpRxtiO2QOwSjcLXsoi4T57OLO5N8dYmKmA7d6z2BI
3ho8ZKHpPZFccd/PelHMRKfxGXXpixlPVLfQaRCOJEneMEZGw5GaoN3ME9WyFFtb
EMxuKtj1LPrsDia03YiU0dYOEK6o2A==
=8jTB
-----END PGP SIGNATURE-----

--3VhrvgBQak7RuX2qZV1SaiEYnjI2ZyPFe--
