Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:41769 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933638AbeBMJFQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Feb 2018 04:05:16 -0500
Subject: Re: [PATCH v2] btrfs: log, when replace, is canceled by the user
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180212153658.19631-1-anand.jain@oracle.com>
 <20180213035343.18128-1-anand.jain@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <91dd9719-28d6-dc4f-9e26-8cfa1f2082c9@gmx.com>
Date: Tue, 13 Feb 2018 17:05:06 +0800
MIME-Version: 1.0
In-Reply-To: <20180213035343.18128-1-anand.jain@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ngZuDZ8yGExxFE8Cc5SCk5bVYrQl74y7G"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ngZuDZ8yGExxFE8Cc5SCk5bVYrQl74y7G
Content-Type: multipart/mixed; boundary="Hb9l7JE8a7JEBfbixERcDh9FfDF4NBXj4";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Message-ID: <91dd9719-28d6-dc4f-9e26-8cfa1f2082c9@gmx.com>
Subject: Re: [PATCH v2] btrfs: log, when replace, is canceled by the user
References: <20180212153658.19631-1-anand.jain@oracle.com>
 <20180213035343.18128-1-anand.jain@oracle.com>
In-Reply-To: <20180213035343.18128-1-anand.jain@oracle.com>

--Hb9l7JE8a7JEBfbixERcDh9FfDF4NBXj4
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8813=E6=97=A5 11:53, Anand Jain wrote:
> For forensic investigations of issues, we would want to know
> if and when the user cancels the replace.
>=20
> Signed-off-by: Anand Jain <anand.jain@oracle.com>> ---
> v1->v2: use btrfs_dev_name() instead of rcu_str_deref()
>         as btrfs_dev_name() also provides "missing" string,
>         if needed.

Would you please provide the branch you're using?

As I couldn't find the function or macro of btrfs_dev_name()

Thanks,
Qu

>=20
>  fs/btrfs/dev-replace.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>=20
> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> index dd717e204b5e..3b0760f7ec8a 100644
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -703,6 +703,7 @@ int btrfs_dev_replace_cancel(struct btrfs_fs_info *=
fs_info)
>  {
>  	struct btrfs_dev_replace *dev_replace =3D &fs_info->dev_replace;
>  	struct btrfs_device *tgt_device =3D NULL;
> +	struct btrfs_device *src_device =3D NULL;
>  	struct btrfs_trans_handle *trans;
>  	struct btrfs_root *root =3D fs_info->tree_root;
>  	int result;
> @@ -724,6 +725,7 @@ int btrfs_dev_replace_cancel(struct btrfs_fs_info *=
fs_info)
>  	case BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED:
>  		result =3D BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR;
>  		tgt_device =3D dev_replace->tgtdev;
> +		src_device =3D dev_replace->srcdev;
>  		dev_replace->tgtdev =3D NULL;
>  		dev_replace->srcdev =3D NULL;
>  		break;
> @@ -741,6 +743,11 @@ int btrfs_dev_replace_cancel(struct btrfs_fs_info =
*fs_info)
>  	}
>  	ret =3D btrfs_commit_transaction(trans);
>  	WARN_ON(ret);
> +
> +	btrfs_info(fs_info, "dev_replace from %s (devid %llu) to %s canceled"=
,
> +		   btrfs_dev_name(src_device), src_device->devid,
> +		   btrfs_dev_name(tgt_device));
> +
>  	if (tgt_device)
>  		btrfs_destroy_dev_replace_tgtdev(fs_info, tgt_device);
> =20
>=20


--Hb9l7JE8a7JEBfbixERcDh9FfDF4NBXj4--

--ngZuDZ8yGExxFE8Cc5SCk5bVYrQl74y7G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqCqkIXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjV7Qf+PhMeHldu1iVC320DhZvCZKYz
yijumBHAZcNcDK8p0owlcR5hCXmTihkY6PhfQuILVsgQ0wnjrVvk4lOB8bXX4NRZ
uUxnvEA+cd8oAsth0c9KWKdjbMQLUL5EqmIz68jC6O642RS8lVCf2L7BH/zNlDsT
fciCsbrFmYHEYc1OEgrST2ocCzF2zpmECWhEK2o62KWOxOZQjfoJJQvkdaYN21XL
xPoXoxk9s487+DYplRAjxjpiC8tbr304diSdXwYVeNpNdr9ELa/qKS/TE0rDkrqQ
jUo3c2TDEXhYG3rgCSZfeJWrRFuwGcCNrCajR8YQ/c7MWwf8l8N7tV3OrrU3Hw==
=Iz3f
-----END PGP SIGNATURE-----

--ngZuDZ8yGExxFE8Cc5SCk5bVYrQl74y7G--
