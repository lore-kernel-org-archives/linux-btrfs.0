Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:37503 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728209AbeHIIKf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 9 Aug 2018 04:10:35 -0400
Subject: Re: [PATCH v4] btrfs: qgroup: Remove qgroup items along with
 subvolume deletion
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
References: <cover.1533783766.git.misono.tomohiro@jp.fujitsu.com>
 <055391ff-7137-4210-4eff-f2c3f70cf68b@jp.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <1c76deaf-af9b-7c8c-e100-058d67f40fb5@gmx.com>
Date: Thu, 9 Aug 2018 13:47:10 +0800
MIME-Version: 1.0
In-Reply-To: <055391ff-7137-4210-4eff-f2c3f70cf68b@jp.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="8TDYUjdcLSJo9DBvOEMsnJJFCtGbrMB47"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8TDYUjdcLSJo9DBvOEMsnJJFCtGbrMB47
Content-Type: multipart/mixed; boundary="ukAR44snF2x7v9Roq9pBPzTwOvpvNDXhD";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
 linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Message-ID: <1c76deaf-af9b-7c8c-e100-058d67f40fb5@gmx.com>
Subject: Re: [PATCH v4] btrfs: qgroup: Remove qgroup items along with
 subvolume deletion
References: <cover.1533783766.git.misono.tomohiro@jp.fujitsu.com>
 <055391ff-7137-4210-4eff-f2c3f70cf68b@jp.fujitsu.com>
In-Reply-To: <055391ff-7137-4210-4eff-f2c3f70cf68b@jp.fujitsu.com>

--ukAR44snF2x7v9Roq9pBPzTwOvpvNDXhD
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 8/9/18 12:12 PM, Misono Tomohiro wrote:
> When qgroup is on, subvolume deletion does not remove qgroup items
> of the subvolume (qgroup info, limit, relation) from quota tree and
> they need to get removed manually by "btrfs qgroup destroy".
>=20
> Since level 0 qgroup cannot be used/inherited by any other subvolume,
> let's remove them automatically when subvolume is deleted
> (to be precise, when the subvolume root is dropped).
>=20
> Note that qgroup becomes inconsistent in following case:
>   1. qgroup relation exists
>   2. and subvolume's excl !=3D rref

That's a little strange.

If a subvolume is completely dropped, its excl should be the same rfer,
all 0, and removing its relationship should not mark qgroup inconsistent.=


So the problem is the timing when btrfs_remove_qgroup() is called.

Since qgroup accounting is only called at transaction commit time, and
we're holding a trans handler, it's almost ensured we can't commit this
transaction, thus the number is not updated yet (still not 0)

So that's why qgroup is inconsistent.

What about commit current transaction and then call btrfs_remove_qgroup()=
?

(Sorry I didn't catch this problem last time I reviewed this patch)

Thanks,
Qu

> In this case manual qgroup rescan is needed.
>=20
> Reviewed-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
> Reviewed-by: Qu Wenruo <wqu@suse.com>
> Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
> ---
> Hi David,
> It turned out that this patch may cause qgroup inconsistency in case
> described above and need manual rescan. Since current code will keep=20
> qgroup items but not break qgroup consistency when deleting subvolume,
> I cannot clearly say which behavior is better for qgroup usability.
> Can I ask your opinion?
>=20
> v3 -> v4:
>   Check return value of btrfs_remove_qgroup() and if it is 1,
>   print message in syslog that fs needs qgroup rescan
>=20
>  fs/btrfs/extent-tree.c | 22 ++++++++++++++++++----
>  1 file changed, 18 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 9e7b237b9547..828d9e68047d 100644
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
> @@ -9056,6 +9056,20 @@ int btrfs_drop_snapshot(struct btrfs_root *root,=

>  		btrfs_put_fs_root(root);
>  	}
>  	root_dropped =3D true;
> +
> +	 /* Remove level-0 qgroup items since no other subvolume can use them=
 */
> +	ret =3D btrfs_remove_qgroup(trans, objectid);
> +	if (ret =3D=3D 1) {
> +		/* This means qgroup becomes inconsistent by removing items */
> +		btrfs_info(fs_info,
> +		    "qgroup inconsistency found, need qgroup rescan");
> +	} else if (ret =3D=3D -EINVAL || ret =3D=3D -ENOENT) {
> +		/* qgroup is not enabled or already removed, just ignore this */
> +	} else if (ret) {
> +		btrfs_abort_transaction(trans, ret);
> +		err =3D ret;
> +	}
> +
>  out_end_trans:
>  	btrfs_end_transaction_throttle(trans);
>  out_free:
>=20


--ukAR44snF2x7v9Roq9pBPzTwOvpvNDXhD--

--8TDYUjdcLSJo9DBvOEMsnJJFCtGbrMB47
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltr1V4ACgkQwj2R86El
/qghsQgAirE+eLdLYOJns+l81kxitBYMpR0w9r3Qu7CxPLrJtp99eRAVLeZ5vUHT
bRby2pIkTXRSOZd8VlGmvmcGQGfaHuAyeDwlbSz5jdDBhm8wrh+kLCYyFWZdUp1U
I3VctnstXKvZoGNswHdeT7WUhhZCQlc1GjbWBVCYcoC8FFfzJK0hSNX8nNaF72Pq
Fyx38rZwfo4bu+Xfg0I1oHSfE5PpD9QNQMQIjTsN6xWEzsb0a0zvacwhE4RHlT+/
lbauEgctsVB+ZT8uS3OTgpMrhHO9K0EgFbJAYzu0QCGLi7hp7j0AK/Ewi+9dszwR
XfCk4PBiSGKHr5i9mh90iozGkijBiQ==
=rIAs
-----END PGP SIGNATURE-----

--8TDYUjdcLSJo9DBvOEMsnJJFCtGbrMB47--
