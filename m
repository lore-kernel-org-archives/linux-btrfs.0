Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:39299 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726563AbeIKQyG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 12:54:06 -0400
Subject: Re: [RFC PATCH v2 2/4] btrfs: don't BUG_ON() in btrfs_link_subvol()
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180911112903.25985-1-lufq.fnst@cn.fujitsu.com>
 <20180911112903.25985-3-lufq.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <e0c7e7fb-b99a-5fde-7017-d3abea5c7ff6@gmx.com>
Date: Tue, 11 Sep 2018 19:54:58 +0800
MIME-Version: 1.0
In-Reply-To: <20180911112903.25985-3-lufq.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="zH3rXsOv8GdLjaGECJ02BovoJ91lWRc7L"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--zH3rXsOv8GdLjaGECJ02BovoJ91lWRc7L
Content-Type: multipart/mixed; boundary="M2ux0JwShtN8GLPIX9uTyRhJYcVw5J0ID";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <e0c7e7fb-b99a-5fde-7017-d3abea5c7ff6@gmx.com>
Subject: Re: [RFC PATCH v2 2/4] btrfs: don't BUG_ON() in btrfs_link_subvol()
References: <20180911112903.25985-1-lufq.fnst@cn.fujitsu.com>
 <20180911112903.25985-3-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180911112903.25985-3-lufq.fnst@cn.fujitsu.com>

--M2ux0JwShtN8GLPIX9uTyRhJYcVw5J0ID
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/9/11 =E4=B8=8B=E5=8D=887:29, Lu Fengqi wrote:
> Both of btrfs_update_inode() and btrfs_add_root_ref() may fail because
> of ENOMEM.

Not only ENOMEM, but also EEXIST/EIO from btrfs_insert_empty_item().

> So there's no reason to panic here, we can replace BUG_ON()
> with btrfs_abort_transaction() here.

Valid cleanup.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

>=20
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/ioctl.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 1b03d07acde2..f6173d4e7ced 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -572,11 +572,17 @@ static int btrfs_link_subvol(struct btrfs_trans_h=
andle *trans,
> =20
>  	btrfs_i_size_write(BTRFS_I(dir), dir->i_size + namelen * 2);
>  	ret =3D btrfs_update_inode(trans, root, dir);
> -	BUG_ON(ret);
> +	if (ret) {
> +		btrfs_abort_transaction(trans, ret);
> +		return ret;
> +	}
> =20
>  	ret =3D btrfs_add_root_ref(trans, objectid, root->root_key.objectid,
>  				 btrfs_ino(BTRFS_I(dir)), index, name, namelen);
> -	BUG_ON(ret);
> +	if (ret) {
> +		btrfs_abort_transaction(trans, ret);
> +		return ret;
> +	}
> =20
>  	return ret;
>  }
>=20


--M2ux0JwShtN8GLPIX9uTyRhJYcVw5J0ID--

--zH3rXsOv8GdLjaGECJ02BovoJ91lWRc7L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAluXrRIACgkQwj2R86El
/qiXSwgAochk/m+wTkuXGEbvK8G+rGhgArP3h1tX0DrqHFSwJtqptz0AWzQ0z/uQ
W6+/B+CHbQxRDINT+kJYB5LjC/RLxDn5/gCh9Wih/xVwxabm/SJmDSQhlNYcM++o
/8wOl2sidNygQ0lx1G+ltvpeQ5T38FBCMGQ1ys52GziR+Y0yGspC6npj7aKpkmX4
HTT5bl8fy6EPELVr1tmIjbCTBAKekudRw45Rg2LuIGOfn+HLXRDxSdTsTu/RRCw5
HOAUwQgcKBMvowK72K+bbyxp1KNMGvsbj7meFR7z728QPOX9EzzJWPwN1yEJqP/m
MDh5GgAhLAqMdfbpCw42JiAg1KlTRQ==
=KNaf
-----END PGP SIGNATURE-----

--zH3rXsOv8GdLjaGECJ02BovoJ91lWRc7L--
