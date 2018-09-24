Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:50645 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728289AbeIXRAd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Sep 2018 13:00:33 -0400
Subject: Re: [PATCH 1/9] fstests: btrfs: _scratch_mkfs_sized fix min size
 without mixed option
To: Anand Jain <anand.jain@oracle.com>, fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
References: <1537784193-24431-1-git-send-email-anand.jain@oracle.com>
 <1537784193-24431-2-git-send-email-anand.jain@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <c770f3ed-a813-74c9-0b9d-04a3ce740185@gmx.com>
Date: Mon, 24 Sep 2018 18:58:46 +0800
MIME-Version: 1.0
In-Reply-To: <1537784193-24431-2-git-send-email-anand.jain@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vZskki89W6w109hCiyNJhrzudyYPuZSHY"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vZskki89W6w109hCiyNJhrzudyYPuZSHY
Content-Type: multipart/mixed; boundary="i6kFtR27mlxEORDsd7Ud9Szl3FDbDA8Ma";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>, fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Message-ID: <c770f3ed-a813-74c9-0b9d-04a3ce740185@gmx.com>
Subject: Re: [PATCH 1/9] fstests: btrfs: _scratch_mkfs_sized fix min size
 without mixed option
References: <1537784193-24431-1-git-send-email-anand.jain@oracle.com>
 <1537784193-24431-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1537784193-24431-2-git-send-email-anand.jain@oracle.com>

--i6kFtR27mlxEORDsd7Ud9Szl3FDbDA8Ma
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/9/24 =E4=B8=8B=E5=8D=886:16, Anand Jain wrote:
> As of now _scratch_mkfs_sized check if the requested size is below 1G
> and forces the --mixed option for the mkfs.btrfs. Well the correct size=

> at which we need to force the mixed option is 114294784bytes. Fix that.=


How this size is get from?
If it's from btrfs_min_dev_size(), I strongly recommend to add reference
here, and don't use the ugly intermediate number.


BTW, this number is related to mkfs profile.
If you really want to use some maximum number, please follow the max
possible value in btrfs_min_dev_size(), which should be 229M other than
106M.

Thanks,
Qu

>=20
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  common/rc | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/common/rc b/common/rc
> index d5bb1feee2c3..bcdbf03e1bf0 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -969,7 +969,9 @@ _scratch_mkfs_sized()
>  	;;
>      btrfs)
>  	local mixed_opt=3D
> -	(( fssize <=3D 1024 * 1024 * 1024 )) && mixed_opt=3D'--mixed'
> +	# minimum size that's needed without the mixed option.
> +	# Non mixed mode is also the default option.
> +	(( fssize < 114294784 )) && mixed_opt=3D'--mixed'
>  	$MKFS_BTRFS_PROG $MKFS_OPTIONS $mixed_opt -b $fssize $SCRATCH_DEV
>  	;;
>      jfs)
>=20


--i6kFtR27mlxEORDsd7Ud9Szl3FDbDA8Ma--

--vZskki89W6w109hCiyNJhrzudyYPuZSHY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAluow2YACgkQwj2R86El
/qgzSAf+LLE8OnzuU/od8l+dxBlf+rEJnFcI83VFMhaWyGfOGXXrDtm4c3vsxOk6
zGZCqqjhpYuPCVK7SdgFd1K+M7+YbXf6k4qKw3BRk6koYq8gZlyj4b0taTw+lcUJ
ukJkeV8VPE+MjyStDaxBaLtqcTgUCiD+LJ4ljZXHbR7xBEw6+fRxD5MLmLrFZkTc
ChIHeOJ16PdBoDbStJ1F6RomOnyoYT3h5M2GsxA/3PHGaG+lDi1JxPp6xIYo584v
HnhAl0gLNV+VuEtiQaNv5E2o66RLdk4a2xUS8PIZPBCukNFIXU0HHJoFzuPjHGDS
EFKegnvK3mVCnfgFcskIiDOtyTIQrQ==
=0Wll
-----END PGP SIGNATURE-----

--vZskki89W6w109hCiyNJhrzudyYPuZSHY--
