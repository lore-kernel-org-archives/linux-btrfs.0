Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:44611 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753484AbeGCFSQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Jul 2018 01:18:16 -0400
Subject: Re: [PATCH] btrfs: Add chunk type check in read a chunk
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Cc: wen.xu@gatech.edu, xuwen.sjtu@gmail.com
References: <1530592056-7940-1-git-send-email-gujx@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <3bece067-d0e1-7e16-1d27-34926a2e2a0a@gmx.com>
Date: Tue, 3 Jul 2018 13:17:52 +0800
MIME-Version: 1.0
In-Reply-To: <1530592056-7940-1-git-send-email-gujx@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="t0PrMikU4PU9JhGBEGPFdpYz1o7YFVfDy"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--t0PrMikU4PU9JhGBEGPFdpYz1o7YFVfDy
Content-Type: multipart/mixed; boundary="mSIWemAo9lKxgfGBbeDBEfPCnmOs9w5R0";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Cc: wen.xu@gatech.edu, xuwen.sjtu@gmail.com
Message-ID: <3bece067-d0e1-7e16-1d27-34926a2e2a0a@gmx.com>
Subject: Re: [PATCH] btrfs: Add chunk type check in read a chunk
References: <1530592056-7940-1-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1530592056-7940-1-git-send-email-gujx@cn.fujitsu.com>

--mSIWemAo9lKxgfGBbeDBEfPCnmOs9w5R0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8803=E6=97=A5 12:27, Gu Jinxiang wrote:
> Reported in https://bugzilla.kernel.org/show_bug.cgi?id=3D199839,
> which has a invalid chunk, not return error opportunlly.
>=20
> Add chunk type check in btrfs_check_chunk_valid,
> to make error be returned in advance.
>=20
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
> ---
>  fs/btrfs/volumes.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>=20
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index e034ad9e23b4..67732c910c3d 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -6439,6 +6439,12 @@ static int btrfs_check_chunk_valid(struct btrfs_=
fs_info *fs_info,
>  			  btrfs_chunk_type(leaf, chunk));
>  		return -EIO;
>  	}
> +
> +	if (!(type & BTRFS_BLOCK_GROUP_TYPE_MASK)) {
> +		btrfs_err(fs_info, "missing chunk type flag: %llu", type);
> +		return -EIO;
> +	}

This is not good enough to catch case like DATA | METADATA | SYSTEM.

You patch reminds me that my block group type check is not good enough.
We allow either single bit set in TYPE_MASK or DATA | METADATA for mixed
block group.

Thanks,
Qu

> +
>  	if ((type & BTRFS_BLOCK_GROUP_RAID10 && sub_stripes !=3D 2) ||
>  	    (type & BTRFS_BLOCK_GROUP_RAID1 && num_stripes < 1) ||
>  	    (type & BTRFS_BLOCK_GROUP_RAID5 && num_stripes < 2) ||
>=20


--mSIWemAo9lKxgfGBbeDBEfPCnmOs9w5R0--

--t0PrMikU4PU9JhGBEGPFdpYz1o7YFVfDy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAls7BwAACgkQwj2R86El
/qgICwf+KAU82aImOWc2UM9WYq+3NmAu1aVWcjAi0X8Zzs7jdbUyuyRtop7pbcmK
y09uUv0T5h0QFI30ZXjwqXEHz+uvDele8jxejOlofx3L+BtsR6EU67X/wjI3YGwU
q/77qztYjB2uITw492rbUiNrl1whU92FLAX/8YlN4bpi+RM01p83oq/XoauSuDhr
KWAx3hN9xOx1IjVWcJaLGIDRrcRXQkaDgnIvkoYHRmXVyVGUQUeIAeEkX3v804bw
C0tZO4NKwLwwY2tu2CIRHhnGaDHbDmGgeA0G/BM/gaQgwHlVjgxxdya9IxA5B3wr
Uuzyl+XeEtr9Nz6lIv5pcYKtVB1eSw==
=P4fp
-----END PGP SIGNATURE-----

--t0PrMikU4PU9JhGBEGPFdpYz1o7YFVfDy--
