Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:53574 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755009AbeAHIVm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Jan 2018 03:21:42 -0500
Subject: Re: [PATCH 3/3] btrfs: add support for SUPER_FLAG_CHANGING_FSID in
 btrfs.ko
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Cc: wqu@suse.com
References: <20180108080421.17668-1-anand.jain@oracle.com>
 <20180108080421.17668-4-anand.jain@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <5895d61c-ba08-7e9d-200b-aa03bcca5e0d@gmx.com>
Date: Mon, 8 Jan 2018 16:21:27 +0800
MIME-Version: 1.0
In-Reply-To: <20180108080421.17668-4-anand.jain@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="y0WR8CVo2OmKYPucnxMRQElFNYzkWqNvc"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--y0WR8CVo2OmKYPucnxMRQElFNYzkWqNvc
Content-Type: multipart/mixed; boundary="OASbXsZdxFcwEtWSqjWs5W7Fx0TGfyXjB";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Cc: wqu@suse.com
Message-ID: <5895d61c-ba08-7e9d-200b-aa03bcca5e0d@gmx.com>
Subject: Re: [PATCH 3/3] btrfs: add support for SUPER_FLAG_CHANGING_FSID in
 btrfs.ko
References: <20180108080421.17668-1-anand.jain@oracle.com>
 <20180108080421.17668-4-anand.jain@oracle.com>
In-Reply-To: <20180108080421.17668-4-anand.jain@oracle.com>

--OASbXsZdxFcwEtWSqjWs5W7Fx0TGfyXjB
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8808=E6=97=A5 16:04, Anand Jain wrote:
> Userland sets SUPER_FLAG_CHANGING_FSID and resets it only when changing=

> fsid is complete. Its not a good idea to mount the device anything in
> between, so this patch fails the mount if SB SUPER_FLAG_CHANGING_FSID
> is set. As we don't add SUPER_FLAG_CHANGING_FSID into
> BTRFS_SUPER_FLAG_SUPP list, so mount will fail if SUPER_FLAG_CHANGING_F=
SID
> is set in the user land.
>=20
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> cc: wqu@suse.com

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  include/uapi/linux/btrfs_tree.h | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs=
_tree.h
> index 38ab0e06259a..aff1356c2bb8 100644
> --- a/include/uapi/linux/btrfs_tree.h
> +++ b/include/uapi/linux/btrfs_tree.h
> @@ -457,6 +457,7 @@ struct btrfs_free_space_header {
>  #define BTRFS_SUPER_FLAG_SEEDING	(1ULL << 32)
>  #define BTRFS_SUPER_FLAG_METADUMP	(1ULL << 33)
>  #define BTRFS_SUPER_FLAG_METADUMP_V2	(1ULL << 34)
> +#define BTRFS_SUPER_FLAG_CHANGING_FSID	(1ULL << 35)
> =20
> =20
>  /*
>=20


--OASbXsZdxFcwEtWSqjWs5W7Fx0TGfyXjB--

--y0WR8CVo2OmKYPucnxMRQElFNYzkWqNvc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpTKgcXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhT0ggAi8vv+tM/qE0GXsNgZscPGX02
i7Ki+LPW3pmZjqAfZkxvcpiTo/lONhsjrLa9GeFXjnF2I2BmQjK2ddz7/QJh1HNL
obt3epCrRyAQp8ZES6C5YXSSyF5TDP9Tkcg2UtEEKQ04Y7121Tyrw6yJ7/lXA4q4
mcej9n9L8M8M/KF3GAvYQycD/ZNLcn0SXpeMbddwuhHjQ5ViFnAfMp+f5HR3efWZ
jM5Vf3Th36D2Gm5RxCzY3HQmOUPIt+ZjoRGxauntHASZIyShqcKft03MsQhcpEiP
FYzWJt9U8AnIl3iIG0ZnzZ6h7GcLqnlthr/kb8tpUVSWkae3a4jcrOLZDxEwQA==
=JspW
-----END PGP SIGNATURE-----

--y0WR8CVo2OmKYPucnxMRQElFNYzkWqNvc--
