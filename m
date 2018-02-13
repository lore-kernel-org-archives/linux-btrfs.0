Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:33141 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933102AbeBMBrj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Feb 2018 20:47:39 -0500
Subject: Re: [PATCH 1/1] btrfs: log, when replace, is canceled by the user
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180212153658.19631-1-anand.jain@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <55cc08af-67f5-64c3-d5df-0b41d4c2cf57@gmx.com>
Date: Tue, 13 Feb 2018 09:47:27 +0800
MIME-Version: 1.0
In-Reply-To: <20180212153658.19631-1-anand.jain@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="RqfcKksFc29GKO395XrFqXT6M8Kmc8cG7"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RqfcKksFc29GKO395XrFqXT6M8Kmc8cG7
Content-Type: multipart/mixed; boundary="RzyI4W2rVgYsam9AQ1wlPT0QSfg51QngA";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Message-ID: <55cc08af-67f5-64c3-d5df-0b41d4c2cf57@gmx.com>
Subject: Re: [PATCH 1/1] btrfs: log, when replace, is canceled by the user
References: <20180212153658.19631-1-anand.jain@oracle.com>
In-Reply-To: <20180212153658.19631-1-anand.jain@oracle.com>

--RzyI4W2rVgYsam9AQ1wlPT0QSfg51QngA
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8812=E6=97=A5 23:36, Anand Jain wrote:
> For forensic investigations of issues, we would want to know
> if and when the user cancels the replace.
>=20
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/dev-replace.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>=20
> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> index 197be3fe307b..83eb2d32b477 100644
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -711,6 +711,7 @@ static u64 __btrfs_dev_replace_cancel(struct btrfs_=
fs_info *fs_info)
>  {
>  	struct btrfs_dev_replace *dev_replace =3D &fs_info->dev_replace;
>  	struct btrfs_device *tgt_device =3D NULL;
> +	struct btrfs_device *src_device =3D NULL;
>  	struct btrfs_trans_handle *trans;
>  	struct btrfs_root *root =3D fs_info->tree_root;
>  	u64 result;
> @@ -732,6 +733,7 @@ static u64 __btrfs_dev_replace_cancel(struct btrfs_=
fs_info *fs_info)
>  	case BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED:
>  		result =3D BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR;
>  		tgt_device =3D dev_replace->tgtdev;
> +		src_device =3D dev_replace->srcdev;
>  		dev_replace->tgtdev =3D NULL;
>  		dev_replace->srcdev =3D NULL;
>  		break;
> @@ -749,6 +751,11 @@ static u64 __btrfs_dev_replace_cancel(struct btrfs=
_fs_info *fs_info)
>  	}
>  	ret =3D btrfs_commit_transaction(trans);
>  	WARN_ON(ret);
> +
> +	btrfs_info(fs_info, "dev_replace from %s (devid %llu) to %s canceled"=
,
> +		   btrfs_dev_name(src_device), src_device->devid,
> +		   rcu_str_deref(tgt_device->name));

The behavior is quite good.

Although I'm wondering why for @src_device we use btrfs_dev_name() but
rcu_str_deref() for @tgt_device?

Thanks,
Qu


> +
>  	if (tgt_device)
>  		btrfs_destroy_dev_replace_tgtdev(fs_info, tgt_device);
> =20
>=20


--RzyI4W2rVgYsam9AQ1wlPT0QSfg51QngA--

--RqfcKksFc29GKO395XrFqXT6M8Kmc8cG7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqCQ68XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgPZQgAoMDK4A/WRJGLe8Ljc2vNloVT
eK9j5e25icsg0T2xqn4hicOLU4irihF++PNFGCyYCkmq4LP5H4TcxEz4Ayo0ge3E
WHMM4yiZzPMNYSZnvqcPUShulH51duVolm1eN+FTivZMs20j3/r4wHWuLV22NudQ
Phs78XMyBe4tnwmou+GIZJjQctNWFb8rhzBFc22qIFw+BH9oH/zD0bhyrzlQVh7v
Qt9cZAe9s6g9hwAUft3zAWtEHUdy11WBXbyAG4k5dPeBEUWkdFbnRKDy1eEOhySB
KlrqGWXyTkoWwiR+WPUFsMaL+bQO7JHQLoeMLYfZMmpEkCZfIgrZplJJIKVqsg==
=Sy0u
-----END PGP SIGNATURE-----

--RqfcKksFc29GKO395XrFqXT6M8Kmc8cG7--
