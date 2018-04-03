Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:53789 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754969AbeDCI66 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Apr 2018 04:58:58 -0400
Subject: Re: [PATCH] btrfs-progs: let mkfs return nozero value on thin
 provision device
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Cc: fstests@vger.kernel.org
References: <20180403083945.13485-1-suy.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <17aa9205-f930-9d20-1d2f-8f03341fd440@gmx.com>
Date: Tue, 3 Apr 2018 16:58:36 +0800
MIME-Version: 1.0
In-Reply-To: <20180403083945.13485-1-suy.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="KBobigo9kghjbadXw6FbnjoEVrGa9fyEq"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--KBobigo9kghjbadXw6FbnjoEVrGa9fyEq
Content-Type: multipart/mixed; boundary="yYyj3JxNt6KAN96XHjfOzcshp6Jml4etr";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Cc: fstests@vger.kernel.org
Message-ID: <17aa9205-f930-9d20-1d2f-8f03341fd440@gmx.com>
Subject: Re: [PATCH] btrfs-progs: let mkfs return nozero value on thin
 provision device
References: <20180403083945.13485-1-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180403083945.13485-1-suy.fnst@cn.fujitsu.com>

--yYyj3JxNt6KAN96XHjfOzcshp6Jml4etr
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B404=E6=9C=8803=E6=97=A5 16:39, Su Yue wrote:
> when mkfs.btrfs on a thin provision device which has very small
> backing size and big virtual size, all code works well in
> mkfs.btrfs until close_ctree() is called.
> close_ctree() fails to sync device due to small backing size
> while closing devices.
> However, mkfs returns 0 in such situation which causes failure of
> xfstests generic/405.
>=20
> So, let mkfs returns nonzero value if previous steps succeeded but
> close_ctree() failed.
> Then xfstests generic/405 passes now.
>=20
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  mkfs/main.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>=20
> diff --git a/mkfs/main.c b/mkfs/main.c
> index 5a717f701cd5..9f7f2396df8f 100644
> --- a/mkfs/main.c
> +++ b/mkfs/main.c
> @@ -1285,6 +1285,12 @@ out:
>  		}
>  	}
> =20
> +	if (!ret && close_ret) {
> +		ret =3D close_ret;
> +		error("failed to close ctree, the filesystem may be inconsistent: %d=
",
> +		      ret);
> +	}
> +
>  	btrfs_close_all_devices();
>  	free(label);
> =20
>=20


--yYyj3JxNt6KAN96XHjfOzcshp6Jml4etr--

--KBobigo9kghjbadXw6FbnjoEVrGa9fyEq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrDQjwACgkQwj2R86El
/qjaYggAmY1CVd8maHc0CR0pQnSAwDiwyLAtSfOv/+HGFQRKfhIYMLQNh0LquyKU
pVYjnOu9H8oJBYJ6//gtz1ltBO5iswfEcMDBfVNPp4c3YpafFTt5556X2I4ty/xW
6FpD3BmBwGqoWGtVMchnuRUg3PH+QMuYbsiEHJmYMBYgzII9McC9dTHuO+0BzgYm
kNl9er5jCMMTUpAYIxHqdYOg2SWlWv58KxcIe178pehaoxdSO5kmOvflRspstN9U
eb0N+g2NygWIxtjPR+EZk8t6nyfp+mVqIvOp425obtwUFlLsWultcS8DkZEOVrOa
dtOWEd1G10tdHPPi/+cWrLvQAjxXrg==
=pxGA
-----END PGP SIGNATURE-----

--KBobigo9kghjbadXw6FbnjoEVrGa9fyEq--
