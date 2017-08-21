Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40864 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753110AbdHUNJS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 09:09:18 -0400
Subject: Re: [PATCH 3/5] btrfs: Use common error handling code in
 btrfs_update_root()
To: SF Markus Elfring <elfring@users.sourceforge.net>,
        linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, Josef Bacik <jbacik@fb.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
References: <1e8e1da2-a9e3-9dc7-6ffe-6c32f8464337@users.sourceforge.net>
 <287b99e6-6562-ea64-e763-6a6808fee12a@users.sourceforge.net>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <d33b6aa8-422b-507e-b004-923a25d235c9@suse.com>
Date: Mon, 21 Aug 2017 09:09:12 -0400
MIME-Version: 1.0
In-Reply-To: <287b99e6-6562-ea64-e763-6a6808fee12a@users.sourceforge.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Lkk2RlAwxwW1lLR4abfnKRsslWU6xocwF"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Lkk2RlAwxwW1lLR4abfnKRsslWU6xocwF
Content-Type: multipart/mixed; boundary="roMe5qNARurX7Vh5b8N4jCcB0LQ5a2IwF";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>,
 linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Josef Bacik <jbacik@fb.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Message-ID: <d33b6aa8-422b-507e-b004-923a25d235c9@suse.com>
Subject: Re: [PATCH 3/5] btrfs: Use common error handling code in
 btrfs_update_root()
References: <1e8e1da2-a9e3-9dc7-6ffe-6c32f8464337@users.sourceforge.net>
 <287b99e6-6562-ea64-e763-6a6808fee12a@users.sourceforge.net>
In-Reply-To: <287b99e6-6562-ea64-e763-6a6808fee12a@users.sourceforge.net>

--roMe5qNARurX7Vh5b8N4jCcB0LQ5a2IwF
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/21/17 8:40 AM, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Mon, 21 Aug 2017 13:10:15 +0200
>=20
> Add a jump target so that a bit of exception handling can be better reu=
sed
> at the end of this function.
>=20
> This issue was detected by using the Coccinelle software.

btrfs_abort_transaction dumps __FILE__:__LINE__ in the log so this patch
makes the code more difficult to debug.

-Jeff

> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  fs/btrfs/root-tree.c | 27 +++++++++++----------------
>  1 file changed, 11 insertions(+), 16 deletions(-)
>=20
> diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
> index 5b488af6f25e..bc497ba9d9d1 100644
> --- a/fs/btrfs/root-tree.c
> +++ b/fs/btrfs/root-tree.c
> @@ -145,10 +145,8 @@ int btrfs_update_root(struct btrfs_trans_handle *t=
rans, struct btrfs_root
>  		return -ENOMEM;
> =20
>  	ret =3D btrfs_search_slot(trans, root, key, path, 0, 1);
> -	if (ret < 0) {
> -		btrfs_abort_transaction(trans, ret);
> -		goto out;
> -	}
> +	if (ret < 0)
> +		goto abort_transaction;
> =20
>  	if (ret !=3D 0) {
>  		btrfs_print_leaf(path->nodes[0]);
> @@ -171,23 +169,17 @@ int btrfs_update_root(struct btrfs_trans_handle *=
trans, struct btrfs_root
>  		btrfs_release_path(path);
>  		ret =3D btrfs_search_slot(trans, root, key, path,
>  				-1, 1);
> -		if (ret < 0) {
> -			btrfs_abort_transaction(trans, ret);
> -			goto out;
> -		}
> +		if (ret < 0)
> +			goto abort_transaction;
> =20
>  		ret =3D btrfs_del_item(trans, root, path);
> -		if (ret < 0) {
> -			btrfs_abort_transaction(trans, ret);
> -			goto out;
> -		}
> +		if (ret < 0)
> +			goto abort_transaction;
>  		btrfs_release_path(path);
>  		ret =3D btrfs_insert_empty_item(trans, root, path,
>  				key, sizeof(*item));
> -		if (ret < 0) {
> -			btrfs_abort_transaction(trans, ret);
> -			goto out;
> -		}
> +		if (ret < 0)
> +			goto abort_transaction;
>  		l =3D path->nodes[0];
>  		slot =3D path->slots[0];
>  		ptr =3D btrfs_item_ptr_offset(l, slot);
> @@ -204,6 +196,9 @@ int btrfs_update_root(struct btrfs_trans_handle *tr=
ans, struct btrfs_root
>  out:
>  	btrfs_free_path(path);
>  	return ret;
> +abort_transaction:
> +	btrfs_abort_transaction(trans, ret);
> +	goto out;
>  }
> =20
>  int btrfs_insert_root(struct btrfs_trans_handle *trans, struct btrfs_r=
oot *root,
>=20


--=20
Jeff Mahoney
SUSE Labs


--roMe5qNARurX7Vh5b8N4jCcB0LQ5a2IwF--

--Lkk2RlAwxwW1lLR4abfnKRsslWU6xocwF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWZrbeB57S2MheeWyAQizfRAAvusG9hOSzzQHTjWYxJ+ii5O+duxu3Zwk
hEG8bms3rC88VS130JH1YuaBea9pqxjSdo9sY0wuNXtAKYmwdvGNGcmN3m4MKxP/
CQ8zfiAXX+ZUkYdiBnYFyLq90jm6a185mAQJmLGxP8bGg5nzriHZZuyXPBMcvs4T
Mfc2RvEvwFVNwddCBJWvu+M06Go/GxOs9nW181rhW4YR2UIGCtAhj/iuA7EA6hTW
2jP8Z+HVzOyI6WfeOVS45VbogjbVe25LDYkK/nbjJ3GWDLEd+JANn+DZf7Rop+A5
l3S5QMq6rwIiN22IXCU6WIkJ+bhqCoJJzZrtPkaAiiwujyObKd6n0523rgwGvXoB
5PT77EpGdpyknyXl2VXLI7HlFuy3dZVB1w+ynkw9uFwX8MdsBl6ZWJwPRaI1qmk9
OkrcRRJezza/V1i0ZMsLrjyJPXXTO/lahAj/O62PfpVqNxOaAGFrWfx9gd74bXQ1
by9zkIrs/z1UFX3SRcmTDisMs6wSYbeiCJ8VDxHVcE7xpcXN5gA/KLatPDwtei0C
mSYEHQ3CDLr/Kw71Nl7l6qQ+ErjgeRwaT4zTTj91sHkyTiJYDUY5l3skrggsOV6f
zSuem6Adrkto8ulwXOrH98pByx3avb5KinpJ7ubfvrOTpZVDEsApWjP+oGdqGwW9
166oJyxhl0w=
=yCAn
-----END PGP SIGNATURE-----

--Lkk2RlAwxwW1lLR4abfnKRsslWU6xocwF--
