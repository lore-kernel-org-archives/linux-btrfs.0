Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:51527 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933102AbeBMBsm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Feb 2018 20:48:42 -0500
Subject: Re: [PATCH 1/1] btrfs: open code
 btrfs_init_dev_replace_tgtdev_for_resume()
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180212153625.19541-1-anand.jain@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <e811c90b-5b90-9735-88a1-ff73428a47a5@gmx.com>
Date: Tue, 13 Feb 2018 09:48:34 +0800
MIME-Version: 1.0
In-Reply-To: <20180212153625.19541-1-anand.jain@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="N1OOWClOPZGRVNxEbUdBGYFsE8tZ5WqKB"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--N1OOWClOPZGRVNxEbUdBGYFsE8tZ5WqKB
Content-Type: multipart/mixed; boundary="IQ7Uqj3HvGQGmswtrFEcFutJzMHFHz60G";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Message-ID: <e811c90b-5b90-9735-88a1-ff73428a47a5@gmx.com>
Subject: Re: [PATCH 1/1] btrfs: open code
 btrfs_init_dev_replace_tgtdev_for_resume()
References: <20180212153625.19541-1-anand.jain@oracle.com>
In-Reply-To: <20180212153625.19541-1-anand.jain@oracle.com>

--IQ7Uqj3HvGQGmswtrFEcFutJzMHFHz60G
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8812=E6=97=A5 23:36, Anand Jain wrote:
> btrfs_init_dev_replace_tgtdev_for_resume()  initializes replace
> target device in few simple steps, so do it at the parent function.
> Moreover, there isn't any other caller so just open code it.
>=20
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  fs/btrfs/dev-replace.c | 10 ++++++++--
>  fs/btrfs/volumes.c     | 13 -------------
>  fs/btrfs/volumes.h     |  2 --
>  3 files changed, 8 insertions(+), 17 deletions(-)
>=20
> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> index 7efbc4d1128b..197be3fe307b 100644
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -174,8 +174,14 @@ int btrfs_init_dev_replace(struct btrfs_fs_info *f=
s_info)
>  			}
>  			set_bit(BTRFS_DEV_STATE_REPLACE_TGT,
>  				&dev_replace->tgtdev->dev_state);
> -			btrfs_init_dev_replace_tgtdev_for_resume(fs_info,
> -				dev_replace->tgtdev);
> +
> +			WARN_ON(fs_info->fs_devices->rw_devices =3D=3D 0);
> +			dev_replace->tgtdev->io_width =3D fs_info->sectorsize;
> +			dev_replace->tgtdev->io_align =3D fs_info->sectorsize;
> +			dev_replace->tgtdev->sector_size =3D fs_info->sectorsize;
> +			dev_replace->tgtdev->fs_info =3D fs_info;
> +			set_bit(BTRFS_DEV_STATE_IN_FS_METADATA,
> +				&dev_replace->tgtdev->dev_state);
>  		}
>  		break;
>  	}
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index bbdcf50cd65b..28c385d6419a 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2681,19 +2681,6 @@ int btrfs_init_dev_replace_tgtdev(struct btrfs_f=
s_info *fs_info,
>  	return ret;
>  }
> =20
> -void btrfs_init_dev_replace_tgtdev_for_resume(struct btrfs_fs_info *fs=
_info,
> -					      struct btrfs_device *tgtdev)
> -{
> -	u32 sectorsize =3D fs_info->sectorsize;
> -
> -	WARN_ON(fs_info->fs_devices->rw_devices =3D=3D 0);
> -	tgtdev->io_width =3D sectorsize;
> -	tgtdev->io_align =3D sectorsize;
> -	tgtdev->sector_size =3D sectorsize;
> -	tgtdev->fs_info =3D fs_info;
> -	set_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &tgtdev->dev_state);
> -}
> -
>  static noinline int btrfs_update_device(struct btrfs_trans_handle *tra=
ns,
>  					struct btrfs_device *device)
>  {
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 7281f55dea05..c69d8b4eb4c6 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -483,8 +483,6 @@ void btrfs_rm_dev_replace_free_srcdev(struct btrfs_=
fs_info *fs_info,
>  				      struct btrfs_device *srcdev);
>  void btrfs_destroy_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
>  				      struct btrfs_device *tgtdev);
> -void btrfs_init_dev_replace_tgtdev_for_resume(struct btrfs_fs_info *fs=
_info,
> -					      struct btrfs_device *tgtdev);
>  void btrfs_scratch_superblocks(struct block_device *bdev, const char *=
device_path);
>  int btrfs_is_parity_mirror(struct btrfs_fs_info *fs_info,
>  			   u64 logical, u64 len);
>=20


--IQ7Uqj3HvGQGmswtrFEcFutJzMHFHz60G--

--N1OOWClOPZGRVNxEbUdBGYFsE8tZ5WqKB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqCQ/IXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qiIEgf7B7ICjqcqwt2wv2Poxz88wMvi
b8Kz1/Eh9JEOVXDXGsHgDAt58JdZSRc8poP5AdwmIay86DRoHIyEuexsVO8r6DUB
waP9F68IyE3RW4Ai+ObQTqUzdAKNfiOJejoCGhRnP/1Wf12iERE81L0RplPcagtu
8KFPUqA68D4bP0ob/TuQ+F15umXq5NGpolovRt4qbUeNspLIMSZm1tIzDmxzvAN9
fLNs1EGsFk6wNSAeNaDwx8cv0FipOckAUUSZr2nui7x3U8Rm0xpsLnHdQW52lejM
yRpr7bkxxt2LhsgzPJeAvlx0EIqq9kqk5SE1fGXGEiTcl3mF+wgfX2JvlP5f+Q==
=IAEE
-----END PGP SIGNATURE-----

--N1OOWClOPZGRVNxEbUdBGYFsE8tZ5WqKB--
