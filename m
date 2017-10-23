Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:51914 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751316AbdJWLnQ (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Mon, 23 Oct 2017 07:43:16 -0400
Subject: Re: [PATCH 1/2] btrfs: Make btrfs_async_run_delayed_root use a loop
 rather than multiple labels
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1508755909-16838-1-git-send-email-nborisov@suse.com>
From: Qu Wenruo <wqu@suse.com>
Message-ID: <5ee8b69c-41ce-af48-773d-b8fb8358e5da@suse.com>
Date: Mon, 23 Oct 2017 19:43:02 +0800
MIME-Version: 1.0
In-Reply-To: <1508755909-16838-1-git-send-email-nborisov@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="A8jDc6i0ClnDd4Wx58ivehqxUKgVe4eOo"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--A8jDc6i0ClnDd4Wx58ivehqxUKgVe4eOo
Content-Type: multipart/mixed; boundary="KHHap55tnkvCQjFrPFvf4itqBGPBd7lap";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <5ee8b69c-41ce-af48-773d-b8fb8358e5da@suse.com>
Subject: Re: [PATCH 1/2] btrfs: Make btrfs_async_run_delayed_root use a loop
 rather than multiple labels
References: <1508755909-16838-1-git-send-email-nborisov@suse.com>
In-Reply-To: <1508755909-16838-1-git-send-email-nborisov@suse.com>

--KHHap55tnkvCQjFrPFvf4itqBGPBd7lap
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B410=E6=9C=8823=E6=97=A5 18:51, Nikolay Borisov wrote:
> Currently btrfs_async_run_delayed_root's implementation uses 3 goto lab=
els to
> mimic the functionality of a simple do {} while loop. Refactor the func=
tion
> to use a do {} while construct, making intention clear and code easier =
to
> follow. No functional changes
>=20
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Looks good to me.

Reviewed-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/delayed-inode.c | 52 +++++++++++++++++++++++++---------------=
--------
>  1 file changed, 27 insertions(+), 25 deletions(-)
>=20
> diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> index 19e4ad2f3f2e..1bfdb90d7633 100644
> --- a/fs/btrfs/delayed-inode.c
> +++ b/fs/btrfs/delayed-inode.c
> @@ -1323,40 +1323,42 @@ static void btrfs_async_run_delayed_root(struct=
 btrfs_work *work)
>  	if (!path)
>  		goto out;
> =20
> -again:
> -	if (atomic_read(&delayed_root->items) < BTRFS_DELAYED_BACKGROUND / 2)=

> -		goto free_path;
> +	do {
> +		if (atomic_read(&delayed_root->items) <
> +		    BTRFS_DELAYED_BACKGROUND / 2)
> +			break;
> =20
> -	delayed_node =3D btrfs_first_prepared_delayed_node(delayed_root);
> -	if (!delayed_node)
> -		goto free_path;
> +		delayed_node =3D btrfs_first_prepared_delayed_node(delayed_root);
> +		if (!delayed_node)
> +			break;
> =20
> -	path->leave_spinning =3D 1;
> -	root =3D delayed_node->root;
> +		path->leave_spinning =3D 1;
> +		root =3D delayed_node->root;
> =20
> -	trans =3D btrfs_join_transaction(root);
> -	if (IS_ERR(trans))
> -		goto release_path;
> +		trans =3D btrfs_join_transaction(root);
> +		if (IS_ERR(trans)) {
> +			btrfs_release_path(path);
> +			btrfs_release_prepared_delayed_node(delayed_node);
> +			total_done++;
> +			continue;
> +		}
> =20
> -	block_rsv =3D trans->block_rsv;
> -	trans->block_rsv =3D &root->fs_info->delayed_block_rsv;
> +		block_rsv =3D trans->block_rsv;
> +		trans->block_rsv =3D &root->fs_info->delayed_block_rsv;
> =20
> -	__btrfs_commit_inode_delayed_items(trans, path, delayed_node);
> +		__btrfs_commit_inode_delayed_items(trans, path, delayed_node);
> =20
> -	trans->block_rsv =3D block_rsv;
> -	btrfs_end_transaction(trans);
> -	btrfs_btree_balance_dirty_nodelay(root->fs_info);
> +		trans->block_rsv =3D block_rsv;
> +		btrfs_end_transaction(trans);
> +		btrfs_btree_balance_dirty_nodelay(root->fs_info);
> =20
> -release_path:
> -	btrfs_release_path(path);
> -	total_done++;
> +		btrfs_release_path(path);
> +		btrfs_release_prepared_delayed_node(delayed_node);
> +		total_done++;
> =20
> -	btrfs_release_prepared_delayed_node(delayed_node);
> -	if ((async_work->nr =3D=3D 0 && total_done < BTRFS_DELAYED_WRITEBACK)=
 ||
> -	    total_done < async_work->nr)
> -		goto again;
> +	} while ((async_work->nr =3D=3D 0 && total_done < BTRFS_DELAYED_WRITE=
BACK)
> +		 || total_done < async_work->nr);
> =20
> -free_path:
>  	btrfs_free_path(path);
>  out:
>  	wake_up(&delayed_root->wait);
>=20


--KHHap55tnkvCQjFrPFvf4itqBGPBd7lap--

--A8jDc6i0ClnDd4Wx58ivehqxUKgVe4eOo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFBBAEBCAArFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnt1cYNHHdxdUBzdXNl
LmNvbQAKCRDCPZHzoSX+qOl8CACR2149dQ+bhyPAf/yX3NI18g71fL3U7qYyJ3Fr
n23nCSqO9k4tjKBcBes3qrNYoLG7sAwN3djVA3v2KO7juLpbd0rwz6Dhn7rj8xpb
RzJCWnrdehPMWtkdYDCfyRG8O6zpnzuVmQmDX9YK/hv9NNWurmXPq8QVpvbRvrUY
+ax2hd78h33xj1QLgey+sw2oPiTMacY8IUkN9UeAn1Zo51WYjfE8xOh/mJRfCb8w
KOu+o8QbM5ISYMwdEDza3rAZhxeRCfWaR0MQBj8mMITM1ZTuoGTr4btiGZl2R913
+w6zH/ToYvWAfXD6u7FGVDHSkCgY3Z3T+QjJ68EU2RZ6WxKm
=AMbt
-----END PGP SIGNATURE-----

--A8jDc6i0ClnDd4Wx58ivehqxUKgVe4eOo--
