Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:60393 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752299AbeF0XNA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Jun 2018 19:13:00 -0400
Subject: Re: [PATCH] Btrfs: fix mount failure when qgroup rescan is in
 progress
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <20180626234315.15643-1-fdmanana@kernel.org>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <7fe14290-b3c1-ddec-20a4-5b48095ad3ef@gmx.com>
Date: Thu, 28 Jun 2018 07:12:52 +0800
MIME-Version: 1.0
In-Reply-To: <20180626234315.15643-1-fdmanana@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="QHRvfnJbCSR45i0EkijqKnWNUDnkGrp7y"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QHRvfnJbCSR45i0EkijqKnWNUDnkGrp7y
Content-Type: multipart/mixed; boundary="poOARykE7sOps4wsgJWy1LM6CLXmOnKlO";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
Message-ID: <7fe14290-b3c1-ddec-20a4-5b48095ad3ef@gmx.com>
Subject: Re: [PATCH] Btrfs: fix mount failure when qgroup rescan is in
 progress
References: <20180626234315.15643-1-fdmanana@kernel.org>
In-Reply-To: <20180626234315.15643-1-fdmanana@kernel.org>

--poOARykE7sOps4wsgJWy1LM6CLXmOnKlO
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B406=E6=9C=8827=E6=97=A5 07:43, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> If a power failure happens while the qgroup rescan kthread is running,
> the next mount operation will always fail. This is because of a recent
> regression that makes qgroup_rescan_init() incorrectly return -EINVAL
> when we are mounting the filesystem (through btrfs_read_qgroup_config()=
).
> This causes the -EINVAL error to be returned regardless of any qgroup
> flags being set instead of returning the error only when neither of
> the flags BTRFS_QGROUP_STATUS_FLAG_RESCAN nor BTRFS_QGROUP_STATUS_FLAG_=
ON
> are set.

My fault.

>=20
> A test case for fstests follows up soon.
>=20
> Fixes: 9593bf49675e ("btrfs: qgroup: show more meaningful qgroup_rescan=
_init error message")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  fs/btrfs/qgroup.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 1874a6d2e6f5..d4171de93087 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -2784,13 +2784,20 @@ qgroup_rescan_init(struct btrfs_fs_info *fs_inf=
o, u64 progress_objectid,
> =20
>  	if (!init_flags) {
>  		/* we're resuming qgroup rescan at mount time */
> -		if (!(fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN))
> +		if (!(fs_info->qgroup_flags &
> +		      BTRFS_QGROUP_STATUS_FLAG_RESCAN)) {
>  			btrfs_warn(fs_info,
>  			"qgroup rescan init failed, qgroup is not enabled");
> -		else if (!(fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_ON))
> +			ret =3D -EINVAL;
> +		} else if (!(fs_info->qgroup_flags &
> +			     BTRFS_QGROUP_STATUS_FLAG_ON)) {
>  			btrfs_warn(fs_info,
>  			"qgroup rescan init failed, qgroup rescan is not queued");
> -		return -EINVAL;
> +			ret =3D -EINVAL;
> +		}
> +
> +		if (ret)
> +			return ret;
>  	}
> =20
>  	mutex_lock(&fs_info->qgroup_rescan_lock);
>=20


--poOARykE7sOps4wsgJWy1LM6CLXmOnKlO--

--QHRvfnJbCSR45i0EkijqKnWNUDnkGrp7y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAls0GfQACgkQwj2R86El
/qgE7AgAmR6akTLnYNxTsrORaTUTL4Vu0o+4tv3B9bJsBuT2aSpHD3y6FeXmVMJF
o6r53Qh6musdYoxYjCvC7MNydfRc8lyJNuOjwrqj2d77zxCyoRHhPRbLGXAs1waS
F+uy9i22ehnNXaeEVhADoNM0SktAbVlc/QL5JDP3KUc7xrJYL4/Easv4w5OTaJ/e
y539pKZNsTBIhLiNxZrccMJtVOREKG0puTWXiWICsNvpTpMdO4WYhsGP7d9OXxTQ
uneeVJrovVnYOX+xclIVBFkKQ86JYRZPUDCjMJQo/TxqoQiotzpBRDzAQ7RcDddC
dQoqiuOZME4iqCiatbasmQ8I3suspg==
=ZvzN
-----END PGP SIGNATURE-----

--QHRvfnJbCSR45i0EkijqKnWNUDnkGrp7y--
