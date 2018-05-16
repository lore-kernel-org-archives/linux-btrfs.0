Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:59155 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751402AbeEPBX4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 May 2018 21:23:56 -0400
Subject: Re: [PATCH] Btrfs: add parent_transid parameter to veirfy_level_key
To: Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
References: <1526405857-88702-2-git-send-email-bo.liu@linux.alibaba.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <f812aeb3-ce43-d68e-bb88-e5f57cba86fa@gmx.com>
Date: Wed, 16 May 2018 09:23:46 +0800
MIME-Version: 1.0
In-Reply-To: <1526405857-88702-2-git-send-email-bo.liu@linux.alibaba.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="8dK3nLzb1XuofobcriEAADPia0Me7lbXX"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8dK3nLzb1XuofobcriEAADPia0Me7lbXX
Content-Type: multipart/mixed; boundary="psFN0ie27YR2j4ixiFda6QPHFbOhyzk55";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
Message-ID: <f812aeb3-ce43-d68e-bb88-e5f57cba86fa@gmx.com>
Subject: Re: [PATCH] Btrfs: add parent_transid parameter to veirfy_level_key
References: <1526405857-88702-2-git-send-email-bo.liu@linux.alibaba.com>
In-Reply-To: <1526405857-88702-2-git-send-email-bo.liu@linux.alibaba.com>

--psFN0ie27YR2j4ixiFda6QPHFbOhyzk55
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8816=E6=97=A5 01:37, Liu Bo wrote:
> @parent_transid could tell whether the eb's generation has been verifie=
d
> by the caller.
>=20
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>

Looks pretty useful to debug the btrfs/124 bug you just fixed.

But a small nitpick inlined below:

> ---
>  fs/btrfs/disk-io.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 60caa68c3618..b5d55b0ec19b 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -416,7 +416,7 @@ static int btrfs_check_super_csum(struct btrfs_fs_i=
nfo *fs_info,
> =20
>  static int verify_level_key(struct btrfs_fs_info *fs_info,
>  			    struct extent_buffer *eb, int level,
> -			    struct btrfs_key *first_key)
> +			    struct btrfs_key *first_key, u64 parent_transid)
>  {
>  	int found_level;
>  	struct btrfs_key found_key;
> @@ -454,10 +454,10 @@ static int verify_level_key(struct btrfs_fs_info =
*fs_info,
>  	if (ret) {
>  		WARN_ON(1);
>  		btrfs_err(fs_info,
> -"tree first key mismatch detected, bytenr=3D%llu key expected=3D(%llu,=
 %u, %llu) has=3D(%llu, %u, %llu)",
> +"tree first key mismatch detected, bytenr=3D%llu key expected=3D(%llu,=
 %u, %llu) has=3D(%llu, %u, %llu) parent_transid %llu",

It would look better if parent transid can be before key output.

Despite that, everything looks good.

Thanks,
Qu

>  			  eb->start, first_key->objectid, first_key->type,
>  			  first_key->offset, found_key.objectid,
> -			  found_key.type, found_key.offset);
> +			  found_key.type, found_key.offset, parent_transid);
>  	}
>  #endif
>  	return ret;
> @@ -493,7 +493,7 @@ static int btree_read_extent_buffer_pages(struct bt=
rfs_fs_info *fs_info,
>  						   parent_transid, 0))
>  				ret =3D -EIO;
>  			else if (verify_level_key(fs_info, eb, level,
> -						  first_key))
> +						  first_key, parent_transid))
>  				ret =3D -EUCLEAN;
>  			else
>  				break;
>=20


--psFN0ie27YR2j4ixiFda6QPHFbOhyzk55--

--8dK3nLzb1XuofobcriEAADPia0Me7lbXX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlr7iCIACgkQwj2R86El
/qghNAgAjYSfYaENsI1xLE3YOtOIgtufIgVdT3hTOHu0uMEeJTrN2RS/nGBvtgI5
rKgu50vFWA3kns4MBv70iaPTG86TCe9ss+4Z3x5FX10UqAbiwLEBDbm+Wm0BRGQp
gwV1aQqUY1vlspIB1YvDcADIwgCFSi5oHhOzznv20Dd0SlglIVdzivhrtmI8QcT0
T+bzhuTYAnCmhHq83cTH1kB6+vUpC0KMv7jV9rG835JqrSTMjl3qWk+//MOI2ACF
fd933mcwvxIWHBvNwQ4xU/Ts/8RITwT5dTmn4ThlsY3JjgbmJAJEwSbSDy0S8qhf
nnJGgcKcDGNPFIxKtCSCHhfWJ4pFIw==
=trtb
-----END PGP SIGNATURE-----

--8dK3nLzb1XuofobcriEAADPia0Me7lbXX--
