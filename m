Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:40057 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727650AbeISM7s (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Sep 2018 08:59:48 -0400
Subject: Re: [PATCH RFC] btrfs: delayed-inode: Use spinlock to protect
 btrfs_inode::delayed_node
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180919065958.21153-1-wqu@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <2f4142fc-0b1c-0308-e228-d904bf6b395b@gmx.com>
Date: Wed, 19 Sep 2018 15:22:59 +0800
MIME-Version: 1.0
In-Reply-To: <20180919065958.21153-1-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="jImbxlq46Yyt9XWemdg40G8q3glWEj5Tc"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jImbxlq46Yyt9XWemdg40G8q3glWEj5Tc
Content-Type: multipart/mixed; boundary="ykQtpDSrtpdo7Vr20jggCTZBiWMfpruTO";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <2f4142fc-0b1c-0308-e228-d904bf6b395b@gmx.com>
Subject: Re: [PATCH RFC] btrfs: delayed-inode: Use spinlock to protect
 btrfs_inode::delayed_node
References: <20180919065958.21153-1-wqu@suse.com>
In-Reply-To: <20180919065958.21153-1-wqu@suse.com>

--ykQtpDSrtpdo7Vr20jggCTZBiWMfpruTO
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/9/19 =E4=B8=8B=E5=8D=882:59, Qu Wenruo wrote:
> In the following case, we could trigger a use-after-free bug:
>=20
>          CPU0                    |               CPU1
> -----------------------------------------------------------------------=
--
> btrfs_remove_delayed_node        | btrfs_get_delayed_node
> |- delayed_node =3D                | |- node =3D btrfs_inode->delayed_n=
ode;
> |    btrfs_inode->delayed_node   | |
> |- btrfs_release_delaedy_node()  | |
>    |- ref_count_dev_and_test()   | |
>    |- kmem_cache_free()          | |
>       Now delayed node is freed  | |
>                                  | |- refcount_inc(&node->refs)
>=20
> In that case sine delayed_node is using kmem cache, such use-after-free=

> bug won't directly cause problem, but could leads to corrupted data
> structure of other kmem cache user.
>=20
> Fix it by adding btrfs_inode::delayed_node_lock to protect such
> operation.
>=20
> Reported-by: sunny.s.zhang <sunny.s.zhang@oracle.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> Please don't merge this patch yet.

False alert.

The performance degradation is a false alert, and it's pretty awkward.

Before this test run, I refilled TEST_DEV with a special file layout
(for my qgroup balance test) to increase balance/qgroup overhead.
And the file layout also turns out to be pretty heavy for btrfs check,
which makes the test time increase.

Since it's a false alert, the RFC tag is no longer needed.

Thanks,
Qu

>=20
> The patch caused random slow down for a lot of quick test cases.
> Old tests can be executed in 1s or so now randomly needs near 20s.
>=20
> It looks like the spin_lock() with root->inode_lock hold is causing the=

> problem but I can't see what's going wrong.
> As the operation done with @delayed_node_lock hold is literatly tiny.
>=20
> Any comment on this is welcomed.
> ---
>  fs/btrfs/btrfs_inode.h   |  2 ++
>  fs/btrfs/delayed-inode.c | 18 +++++++++++++++---
>  fs/btrfs/inode.c         |  1 +
>  3 files changed, 18 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index 1343ac57b438..c2f054223588 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -175,6 +175,8 @@ struct btrfs_inode {
>  	 */
>  	unsigned defrag_compress;
> =20
> +	/* lock for grabbing/freeing @delayed_node */
> +	spinlock_t delayed_node_lock;
>  	struct btrfs_delayed_node *delayed_node;
> =20
>  	/* File creation time. */
> diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> index f51b509f2d9b..16c405e54930 100644
> --- a/fs/btrfs/delayed-inode.c
> +++ b/fs/btrfs/delayed-inode.c
> @@ -68,19 +68,24 @@ static struct btrfs_delayed_node *btrfs_get_delayed=
_node(
>  	u64 ino =3D btrfs_ino(btrfs_inode);
>  	struct btrfs_delayed_node *node;
> =20
> -	node =3D READ_ONCE(btrfs_inode->delayed_node);
> +	spin_lock(&btrfs_inode->delayed_node_lock);
> +	node =3D btrfs_inode->delayed_node;
>  	if (node) {
>  		refcount_inc(&node->refs);
> +		spin_unlock(&btrfs_inode->delayed_node_lock);
>  		return node;
>  	}
> +	spin_unlock(&btrfs_inode->delayed_node_lock);
> =20
>  	spin_lock(&root->inode_lock);
>  	node =3D radix_tree_lookup(&root->delayed_nodes_tree, ino);
> =20
>  	if (node) {
> +		spin_lock(&btrfs_inode->delayed_node_lock);
>  		if (btrfs_inode->delayed_node) {
>  			refcount_inc(&node->refs);	/* can be accessed */
>  			BUG_ON(btrfs_inode->delayed_node !=3D node);
> +			spin_unlock(&btrfs_inode->delayed_node_lock);
>  			spin_unlock(&root->inode_lock);
>  			return node;
>  		}
> @@ -108,6 +113,7 @@ static struct btrfs_delayed_node *btrfs_get_delayed=
_node(
>  			node =3D NULL;
>  		}
> =20
> +		spin_unlock(&btrfs_inode->delayed_node_lock);
>  		spin_unlock(&root->inode_lock);
>  		return node;
>  	}
> @@ -152,7 +158,9 @@ static struct btrfs_delayed_node *btrfs_get_or_crea=
te_delayed_node(
>  		radix_tree_preload_end();
>  		goto again;
>  	}
> +	spin_lock(&btrfs_inode->delayed_node_lock);
>  	btrfs_inode->delayed_node =3D node;
> +	spin_unlock(&btrfs_inode->delayed_node_lock);
>  	spin_unlock(&root->inode_lock);
>  	radix_tree_preload_end();
> =20
> @@ -1279,11 +1287,15 @@ void btrfs_remove_delayed_node(struct btrfs_ino=
de *inode)
>  {
>  	struct btrfs_delayed_node *delayed_node;
> =20
> -	delayed_node =3D READ_ONCE(inode->delayed_node);
> -	if (!delayed_node)
> +	spin_lock(&inode->delayed_node_lock);
> +	delayed_node =3D inode->delayed_node;
> +	if (!delayed_node) {
> +		spin_unlock(&inode->delayed_node_lock);
>  		return;
> +	}
> =20
>  	inode->delayed_node =3D NULL;
> +	spin_unlock(&inode->delayed_node_lock);
>  	btrfs_release_delayed_node(delayed_node);
>  }
> =20
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 9357a19d2bff..f438be5fecaf 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -9177,6 +9177,7 @@ struct inode *btrfs_alloc_inode(struct super_bloc=
k *sb)
>  	ei->last_log_commit =3D 0;
> =20
>  	spin_lock_init(&ei->lock);
> +	spin_lock_init(&ei->delayed_node_lock);
>  	ei->outstanding_extents =3D 0;
>  	if (sb->s_magic !=3D BTRFS_TEST_MAGIC)
>  		btrfs_init_metadata_block_rsv(fs_info, &ei->block_rsv,
>=20


--ykQtpDSrtpdo7Vr20jggCTZBiWMfpruTO--

--jImbxlq46Yyt9XWemdg40G8q3glWEj5Tc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAluh+VMACgkQwj2R86El
/qgtXQf/dJDqNi7KXxat1OeJ9tl+OdcX6nMVe7JBoAWT1abpk16AdAaZPFyMxm23
1IUTyfiy3w0E380JZw3ci4+/HLOPXLiggyvHy5OsvnR86n9GGS8MMDI7ud/EgIwF
Mxi6QG7r5cK5ps3boFHa0DgDX5xqVnEfHDIPEgg3z06H6MTlC9I/7LeB8HAxZb8X
FxVKZXqCBd79KXMNelqsyW4vnXaAjrSwVe2a6ixtS30HuelBpW33opHxexcHKY+M
WBainJ9E3VztOQJ/y4KMdvHGBoUvHZVsHUbwJxBjuAf47/kj7O3XSnf+5q8/N5J/
VxUHCKt1VlWMGLh39Mg/K0vmA4Kn8Q==
=npBl
-----END PGP SIGNATURE-----

--jImbxlq46Yyt9XWemdg40G8q3glWEj5Tc--
