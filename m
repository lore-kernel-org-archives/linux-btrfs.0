Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:57161 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753443AbdLOLg7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Dec 2017 06:36:59 -0500
Subject: Re: [PATCH] btrfs: Add enospc_debug printing in
 metadata_reserve_bytes
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1513332337-7068-1-git-send-email-nborisov@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <67c2425e-c182-4223-fd04-603fade3bead@gmx.com>
Date: Fri, 15 Dec 2017 19:36:47 +0800
MIME-Version: 1.0
In-Reply-To: <1513332337-7068-1-git-send-email-nborisov@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="MbSikXcjW2vKmBCqDlgAlmOCLd4mCuW4V"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MbSikXcjW2vKmBCqDlgAlmOCLd4mCuW4V
Content-Type: multipart/mixed; boundary="2G46Q8WRKjdCfMebqdCAxE2wLNLWsBjgb";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <67c2425e-c182-4223-fd04-603fade3bead@gmx.com>
Subject: Re: [PATCH] btrfs: Add enospc_debug printing in
 metadata_reserve_bytes
References: <1513332337-7068-1-git-send-email-nborisov@suse.com>
In-Reply-To: <1513332337-7068-1-git-send-email-nborisov@suse.com>

--2G46Q8WRKjdCfMebqdCAxE2wLNLWsBjgb
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8815=E6=97=A5 18:05, Nikolay Borisov wrote:
> Currently when enoscp_debug mount option is turned on we do not print
> any debug info in case metadata reservation failures happen. Fix this
> by adding the necessary hook in reserve_metadata_bytes.

Reviewed-by: Qu Wenruo <wqu@suse.com>

>=20
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/extent-tree.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 4497f937e8fb..7a281fc97bc5 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -5382,10 +5382,15 @@ static int reserve_metadata_bytes(struct btrfs_=
root *root,
>  		    !block_rsv_use_bytes(global_rsv, orig_bytes))
>  			ret =3D 0;
>  	}
> -	if (ret =3D=3D -ENOSPC)
> +	if (ret =3D=3D -ENOSPC) {
>  		trace_btrfs_space_reservation(fs_info, "space_info:enospc",
>  					      block_rsv->space_info->flags,
>  					      orig_bytes, 1);

Nothing related to this patch itself.

But btrfs_space_reservation() seems to be abused.
Every type from delalloc to enospc debug will use it.

What about splitting them into different trace events?

Thanks,
Qu

> +
> +		if (btrfs_test_opt(fs_info, ENOSPC_DEBUG))
> +			dump_space_info(fs_info, block_rsv->space_info,
> +					orig_bytes, 0);
> +	}
>  	return ret;
>  }
> =20
>=20


--2G46Q8WRKjdCfMebqdCAxE2wLNLWsBjgb--

--MbSikXcjW2vKmBCqDlgAlmOCLd4mCuW4V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlozs88XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhy+wf+PLgquL+0GcnhwO+ugCPAblZB
nPjI1FG6zEbmJPpeSsT5Pe5CREs+NO4wsUvY1lX4Xvf7K6dqe/ISU9wMwVXQhOjS
G31Sy+flNP4JAJfndjhw7XxZy4gpGUIdwTSJay8Z2lUo+bxk+tQ6SzGVE1NEFlcX
pjbeSVz20J2CPd5kcy+xmBglfIvTFvUu1NGIAS7rk830NhCs7BuA8LWg9hOjorHo
Bvt095k8nsc9yCY/I9UEczS9WPVMAU4Scwk+YNbQQI2QirDOjoX4pfS3cB5Kl3V3
gqlEmSlBLgD0JoA0UL27Zb+Dkge9MGqvBwV8QK2w6N+D57tP/BSlVPWTYK+pDA==
=vgLL
-----END PGP SIGNATURE-----

--MbSikXcjW2vKmBCqDlgAlmOCLd4mCuW4V--
