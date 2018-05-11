Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34470 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753120AbeEKPJg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 11:09:36 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7905BAF8E
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 15:09:35 +0000 (UTC)
Subject: Re: [PATCH] btrfs: qgroup: Finish rescan when hit the last leaf of
 extent tree
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180504055659.1862-1-wqu@suse.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <af55c952-d040-efb2-463b-2f2f069d4f93@suse.com>
Date: Fri, 11 May 2018 11:09:32 -0400
MIME-Version: 1.0
In-Reply-To: <20180504055659.1862-1-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="eG1ngejQrOoTq63tdfwFUFqbxVSYLnmY4"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--eG1ngejQrOoTq63tdfwFUFqbxVSYLnmY4
Content-Type: multipart/mixed; boundary="FESvaXNB1r22VgJQYIeqLDmN56bzc9qe4";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <af55c952-d040-efb2-463b-2f2f069d4f93@suse.com>
Subject: Re: [PATCH] btrfs: qgroup: Finish rescan when hit the last leaf of
 extent tree
References: <20180504055659.1862-1-wqu@suse.com>
In-Reply-To: <20180504055659.1862-1-wqu@suse.com>

--FESvaXNB1r22VgJQYIeqLDmN56bzc9qe4
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 5/4/18 1:56 AM, Qu Wenruo wrote:
> Under the following case, qgroup rescan can double account cowed tree
> blocks:
>=20
> In this case, extent tree only has one tree block.
>=20
> -
> | transid=3D5 last committed=3D4
> | btrfs_qgroup_rescan_worker()
> | |- btrfs_start_transaction()
> | |  transid =3D 5
> | |- qgroup_rescan_leaf()
> |    |- btrfs_search_slot_for_read() on extent tree
> |       Get the only extent tree block from commit root (transid =3D 4)=
=2E
> |       Scan it, set qgroup_rescan_progress to the last
> |       EXTENT/META_ITEM + 1
> |       now qgroup_rescan_progress =3D A + 1.
> |
> | fs tree get CoWed, new tree block is at A + 16K
> | transid 5 get committed
> -
> | transid=3D6 last committed=3D5
> | btrfs_qgroup_rescan_worker()
> | btrfs_qgroup_rescan_worker()
> | |- btrfs_start_transaction()
> | |  transid =3D 5
> | |- qgroup_rescan_leaf()
> |    |- btrfs_search_slot_for_read() on extent tree
> |       Get the only extent tree block from commit root (transid =3D 5)=
=2E
> |       scan it using qgroup_rescan_progress (A + 1).
> |       found new tree block beyong A, and it's fs tree block,
> |       account it to increase qgroup numbers.
> -
>=20
> In above case, tree block A, and tree block A + 16K get accounted twice=
,
> while qgroup rescan should stop when it already reach the last leaf,
> other than continue using its qgroup_rescan_progress.
>=20
> Such case could happen by just looping btrfs/017 and with some
> possibility it can hit such double qgroup accounting problem.
>=20
> Fix it by checking the path to determine if we should finish qgroup
> rescan, other than relying on next loop to exit.
>=20
> Reported-by: Nikolay Borisov <nborisov@suse.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/qgroup.c | 48 +++++++++++++++++++++++++++++++++--------------=

>  1 file changed, 34 insertions(+), 14 deletions(-)
>=20
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 829e8fe5c97e..2ee2d21d43ab 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -2579,6 +2579,21 @@ void btrfs_qgroup_free_refroot(struct btrfs_fs_i=
nfo *fs_info,
>  	spin_unlock(&fs_info->qgroup_lock);
>  }
> =20
> +/*
> + * Check if the leaf is the last leaf. Which means all node pointers
> + * are at their last position.
> + */
> +static bool is_last_leaf(struct btrfs_path *path)
> +{
> +	int i;
> +
> +	for (i =3D 1; i < BTRFS_MAX_LEVEL && path->nodes[i]; i++) {
> +		if (path->slots[i] !=3D btrfs_header_nritems(path->nodes[i]) - 1)
> +			return false;
> +	}
> +	return true;
> +}
> +
>  /*
>   * returns < 0 on error, 0 when more leafs are to be scanned.
>   * returns 1 when done.
> @@ -2592,6 +2607,7 @@ qgroup_rescan_leaf(struct btrfs_fs_info *fs_info,=
 struct btrfs_path *path,
>  	struct ulist *roots =3D NULL;
>  	struct seq_list tree_mod_seq_elem =3D SEQ_LIST_INIT(tree_mod_seq_elem=
);
>  	u64 num_bytes;
> +	bool done;
>  	int slot;
>  	int ret;
> =20
> @@ -2606,20 +2622,9 @@ qgroup_rescan_leaf(struct btrfs_fs_info *fs_info=
, struct btrfs_path *path,
>  		fs_info->qgroup_rescan_progress.type,
>  		fs_info->qgroup_rescan_progress.offset, ret);
> =20
> -	if (ret) {
> -		/*
> -		 * The rescan is about to end, we will not be scanning any
> -		 * further blocks. We cannot unset the RESCAN flag here, because
> -		 * we want to commit the transaction if everything went well.
> -		 * To make the live accounting work in this phase, we set our
> -		 * scan progress pointer such that every real extent objectid
> -		 * will be smaller.
> -		 */
> -		fs_info->qgroup_rescan_progress.objectid =3D (u64)-1;
> -		btrfs_release_path(path);
> -		mutex_unlock(&fs_info->qgroup_rescan_lock);
> -		return ret;
> -	}
> +	done =3D is_last_leaf(path);
> +	if (ret)
> +		goto finish;
> =20
>  	btrfs_item_key_to_cpu(path->nodes[0], &found,
>  			      btrfs_header_nritems(path->nodes[0]) - 1);
> @@ -2665,8 +2670,23 @@ qgroup_rescan_leaf(struct btrfs_fs_info *fs_info=
, struct btrfs_path *path,
>  		free_extent_buffer(scratch_leaf);
>  	}
>  	btrfs_put_tree_mod_seq(fs_info, &tree_mod_seq_elem);
> +	if (done && !ret)
> +		goto finish;

This causes a double unlock.  The lock was released prior to iterating
the leaf.  Otherwise, looks good.

-Jeff

> =20
>  	return ret;
> +finish:
> +	/*
> +	 * The rescan is about to end, we will not be scanning any
> +	 * further blocks. We cannot unset the RESCAN flag here, because
> +	 * we want to commit the transaction if everything went well.
> +	 * To make the live accounting work in this phase, we set our
> +	 * scan progress pointer such that every real extent objectid
> +	 * will be smaller.
> +	 */
> +	fs_info->qgroup_rescan_progress.objectid =3D (u64)-1;
> +	btrfs_release_path(path);
> +	mutex_unlock(&fs_info->qgroup_rescan_lock);
> +	return 1;
>  }
> =20
>  static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
>=20


--=20
Jeff Mahoney
SUSE Labs


--FESvaXNB1r22VgJQYIeqLDmN56bzc9qe4--

--eG1ngejQrOoTq63tdfwFUFqbxVSYLnmY4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAlr1si0ACgkQHntLYyF5
5bIVzA/8CO6Yzf+d+n0WvpzA4OWf9G5ds595p60X9zNlYO1OLEf1ylsonQonlV9p
yR7mls+tmnAymYejCkDNQgFHGRVTIt2LizAq7Qrl2YEKMrBPQFbvw5UlBiKec0Yh
NBcY3sJHj9TwL/Q06VQRRBuZSekMP5fW9oM9cUNjmDRStPPb2el6XozNuQm4rOFy
+EDN/zdy51TF1ky0/7D823aCX6V0iTrFM/j2LP+6DWswbMWWLh4oKdjza5Lo4mNR
DM/I38EBEpNINxkPtVcTP5kOvRGc/ERaoGkiLXlejpa7GW1dmYK+Rx0ohv9QKLXL
SSU1gjYkXVxYUZ6FzmY5mItGkX71D56LPvZQ8LSr02VOvqM2fCTsv5dSGW2zIxSs
pEk8f3ANrkACxv5kpquF6PwtsUFBtmHZLi9a2RnGPpqm8hHQfxdl8Ti31HNk9/EG
AVdMsdI0TFnzgzu6YqOoQTOvK1EHO3eb7B7iow8ovxTdnxu1Ru2Wzz7QwiOacBE0
RvjmLfhTKDi8rRIdBleTqZ4odGR57j1qtsLQlSnQOlCbajf93MJwv3F+WqmGT7Gi
eBvnsNRysLuKTXv1uSz8wkGhjO9AM0dmCuJS8qj+c/noOcUsQmb7Gdsgrnk/fm4A
AvmWiNwNMA8g6DFDFq3QIlWVqHhB0Js7wegiUEtJpbrPctDj4i0=
=5n+m
-----END PGP SIGNATURE-----

--eG1ngejQrOoTq63tdfwFUFqbxVSYLnmY4--
