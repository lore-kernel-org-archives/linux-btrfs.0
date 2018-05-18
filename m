Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:46131 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751105AbeERFCs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 May 2018 01:02:48 -0400
Subject: Re: [PATCH v2] Btrfs: add parent_transid parameter to
 veirfy_level_key
To: Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
References: <1526405857-88702-2-git-send-email-bo.liu@linux.alibaba.com>
 <1526612375-95875-1-git-send-email-bo.liu@linux.alibaba.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <33b32fb5-ac82-35b0-5fcd-af8f771bb364@gmx.com>
Date: Fri, 18 May 2018 13:02:39 +0800
MIME-Version: 1.0
In-Reply-To: <1526612375-95875-1-git-send-email-bo.liu@linux.alibaba.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="9c03UgQaSqmHrujQMg0kZu6kobbvkEgZF"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9c03UgQaSqmHrujQMg0kZu6kobbvkEgZF
Content-Type: multipart/mixed; boundary="BDasEeQLUSr2hgdqbN4zgNVoeV3H7mOxF";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
Message-ID: <33b32fb5-ac82-35b0-5fcd-af8f771bb364@gmx.com>
Subject: Re: [PATCH v2] Btrfs: add parent_transid parameter to
 veirfy_level_key
References: <1526405857-88702-2-git-send-email-bo.liu@linux.alibaba.com>
 <1526612375-95875-1-git-send-email-bo.liu@linux.alibaba.com>
In-Reply-To: <1526612375-95875-1-git-send-email-bo.liu@linux.alibaba.com>

--BDasEeQLUSr2hgdqbN4zgNVoeV3H7mOxF
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8818=E6=97=A5 10:59, Liu Bo wrote:
> As verify_level_key() is checked after verify_parent_transid(), i.e.
>=20
> if (verify_parent_transid())
>    ret =3D -EIO;
> else if (verify_level_key())
>    ret =3D -EUCLEAN;
>=20
> if parent_transid is 0, verify_parent_transid() skips verifying
> parent_transid and considers eb as valid, and if verify_level_key()
> reports something wrong, we're not going to know if it's caused by
> corrupted metadata or non-checkecd eb (e.g. stale eb).
>=20
> @parent_transid is able to tell whether the eb's generation has been
> verified by the caller.
>=20
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
> v2: - more explicit commit log.
>     - adjust the position shown in error msg.
>=20
>  fs/btrfs/disk-io.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
>=20
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 60caa68c3618..ad865176a3ca 100644
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
> @@ -454,10 +454,11 @@ static int verify_level_key(struct btrfs_fs_info =
*fs_info,
>  	if (ret) {
>  		WARN_ON(1);
>  		btrfs_err(fs_info,
> -"tree first key mismatch detected, bytenr=3D%llu key expected=3D(%llu,=
 %u, %llu) has=3D(%llu, %u, %llu)",
> -			  eb->start, first_key->objectid, first_key->type,
> -			  first_key->offset, found_key.objectid,
> -			  found_key.type, found_key.offset);
> +"tree first key mismatch detected, bytenr=3D%llu parent_transid=3D%llu=
 key expected=3D(%llu, %u, %llu) has=3D(%llu, %u, %llu)",
> +			  eb->start, parent_transid, first_key->objectid,
> +			  first_key->type, first_key->offset,
> +			  found_key.objectid, found_key.type,
> +			  found_key.offset);
>  	}
>  #endif
>  	return ret;
> @@ -493,7 +494,7 @@ static int btree_read_extent_buffer_pages(struct bt=
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


--BDasEeQLUSr2hgdqbN4zgNVoeV3H7mOxF--

--9c03UgQaSqmHrujQMg0kZu6kobbvkEgZF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlr+Xm8ACgkQwj2R86El
/qgJTQf8Cdkr5zMMg6JuA4pSDgkkY6MEOfvLnpX9bNx/xl7IBfs7vSsdmOlz4jls
X/WSuIZ4Fz6YuWZQZN84BOqWu0XwAMfER+rHMAnynRkJTrKlIGYpNiFQ8GNdQau6
f61yaVI7N2baw8ZnvOkvlWi5zQv1WUfed6hrOrdzEr5Iz/sHyU12a+30E5qA9aL/
KB8Eoj5uMr7nOvrfCGMOEdVK+xKHDI/KFBmjE4GQ9uWJ4OkO83x9XuNQtb4IQhj5
wfGcC9V1PVE6xiAEmuR8W+01X/UMXmfHBO/THOEJez/3Ghx+tH8RtfNs9bvQtcIU
XTIQSm4L3hvoKEtAzp3MRPwYKsmnzA==
=oJ24
-----END PGP SIGNATURE-----

--9c03UgQaSqmHrujQMg0kZu6kobbvkEgZF--
