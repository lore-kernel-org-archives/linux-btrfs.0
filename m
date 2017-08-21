Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40500 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753226AbdHUNHN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 09:07:13 -0400
Subject: Re: [PATCH 5/5] btrfs: Use common error handling code in
 btrfs_mark_extent_written()
To: SF Markus Elfring <elfring@users.sourceforge.net>,
        linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, Josef Bacik <jbacik@fb.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
References: <1e8e1da2-a9e3-9dc7-6ffe-6c32f8464337@users.sourceforge.net>
 <93116379-7a82-733a-6957-4e01b3572d8f@users.sourceforge.net>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <1cff718d-46db-d5cd-1cc4-f7e1d6e1ce2e@suse.com>
Date: Mon, 21 Aug 2017 09:07:00 -0400
MIME-Version: 1.0
In-Reply-To: <93116379-7a82-733a-6957-4e01b3572d8f@users.sourceforge.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="OTENECmdh4alx7W5LrK6CWViB8oWOvagQ"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--OTENECmdh4alx7W5LrK6CWViB8oWOvagQ
Content-Type: multipart/mixed; boundary="56Vfuts0U1X29RRCEO59027wgF2xxPdrB";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>,
 linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Josef Bacik <jbacik@fb.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Message-ID: <1cff718d-46db-d5cd-1cc4-f7e1d6e1ce2e@suse.com>
Subject: Re: [PATCH 5/5] btrfs: Use common error handling code in
 btrfs_mark_extent_written()
References: <1e8e1da2-a9e3-9dc7-6ffe-6c32f8464337@users.sourceforge.net>
 <93116379-7a82-733a-6957-4e01b3572d8f@users.sourceforge.net>
In-Reply-To: <93116379-7a82-733a-6957-4e01b3572d8f@users.sourceforge.net>

--56Vfuts0U1X29RRCEO59027wgF2xxPdrB
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/21/17 8:42 AM, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Mon, 21 Aug 2017 14:15:23 +0200
>=20
> Add jump targets so that a bit of exception handling can be better reus=
ed
> at the end of this function.
>=20
> This issue was detected by using the Coccinelle software.

btrfs_abort_transaction dumps __FILE__:__LINE__ in the log so this patch
makes the code more difficult to debug.

-Jeff

> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  fs/btrfs/file.c | 62 ++++++++++++++++++++++---------------------------=
--------
>  1 file changed, 24 insertions(+), 38 deletions(-)
>=20
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 74fd7756cff3..675683051cbc 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1122,25 +1122,17 @@ int btrfs_mark_extent_written(struct btrfs_tran=
s_handle *trans,
> =20
>  	leaf =3D path->nodes[0];
>  	btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
> -	if (key.objectid !=3D ino ||
> -	    key.type !=3D BTRFS_EXTENT_DATA_KEY) {
> -		ret =3D -EINVAL;
> -		btrfs_abort_transaction(trans, ret);
> -		goto out;
> -	}
> +	if (key.objectid !=3D ino || key.type !=3D BTRFS_EXTENT_DATA_KEY)
> +		goto e_inval;
> +
>  	fi =3D btrfs_item_ptr(leaf, path->slots[0],
>  			    struct btrfs_file_extent_item);
> -	if (btrfs_file_extent_type(leaf, fi) !=3D BTRFS_FILE_EXTENT_PREALLOC)=
 {
> -		ret =3D -EINVAL;
> -		btrfs_abort_transaction(trans, ret);
> -		goto out;
> -	}
> +	if (btrfs_file_extent_type(leaf, fi) !=3D BTRFS_FILE_EXTENT_PREALLOC)=

> +		goto e_inval;
> +
>  	extent_end =3D key.offset + btrfs_file_extent_num_bytes(leaf, fi);
> -	if (key.offset > start || extent_end < end) {
> -		ret =3D -EINVAL;
> -		btrfs_abort_transaction(trans, ret);
> -		goto out;
> -	}
> +	if (key.offset > start || extent_end < end)
> +		goto e_inval;
> =20
>  	bytenr =3D btrfs_file_extent_disk_bytenr(leaf, fi);
>  	num_bytes =3D btrfs_file_extent_disk_num_bytes(leaf, fi);
> @@ -1213,10 +1205,8 @@ int btrfs_mark_extent_written(struct btrfs_trans=
_handle *trans,
>  			btrfs_release_path(path);
>  			goto again;
>  		}
> -		if (ret < 0) {
> -			btrfs_abort_transaction(trans, ret);
> -			goto out;
> -		}
> +		if (ret < 0)
> +			goto abort_transaction;
> =20
>  		leaf =3D path->nodes[0];
>  		fi =3D btrfs_item_ptr(leaf, path->slots[0] - 1,
> @@ -1237,18 +1227,15 @@ int btrfs_mark_extent_written(struct btrfs_tran=
s_handle *trans,
>  		ret =3D btrfs_inc_extent_ref(trans, fs_info, bytenr, num_bytes,
>  					   0, root->root_key.objectid,
>  					   ino, orig_offset);
> -		if (ret) {
> -			btrfs_abort_transaction(trans, ret);
> -			goto out;
> -		}
> +		if (ret)
> +			goto abort_transaction;
> =20
>  		if (split =3D=3D start) {
>  			key.offset =3D start;
>  		} else {
>  			if (start !=3D key.offset) {
>  				ret =3D -EINVAL;
> -				btrfs_abort_transaction(trans, ret);
> -				goto out;
> +				goto abort_transaction;
>  			}
>  			path->slots[0]--;
>  			extent_end =3D end;
> @@ -1271,10 +1258,8 @@ int btrfs_mark_extent_written(struct btrfs_trans=
_handle *trans,
>  		ret =3D btrfs_free_extent(trans, fs_info, bytenr, num_bytes,
>  					0, root->root_key.objectid,
>  					ino, orig_offset);
> -		if (ret) {
> -			btrfs_abort_transaction(trans, ret);
> -			goto out;
> -		}
> +		if (ret)
> +			goto abort_transaction;
>  	}
>  	other_start =3D 0;
>  	other_end =3D start;
> @@ -1291,10 +1276,8 @@ int btrfs_mark_extent_written(struct btrfs_trans=
_handle *trans,
>  		ret =3D btrfs_free_extent(trans, fs_info, bytenr, num_bytes,
>  					0, root->root_key.objectid,
>  					ino, orig_offset);
> -		if (ret) {
> -			btrfs_abort_transaction(trans, ret);
> -			goto out;
> -		}
> +		if (ret)
> +			goto abort_transaction;
>  	}
>  	if (del_nr =3D=3D 0) {
>  		fi =3D btrfs_item_ptr(leaf, path->slots[0],
> @@ -1314,14 +1297,17 @@ int btrfs_mark_extent_written(struct btrfs_tran=
s_handle *trans,
>  		btrfs_mark_buffer_dirty(leaf);
> =20
>  		ret =3D btrfs_del_items(trans, root, path, del_slot, del_nr);
> -		if (ret < 0) {
> -			btrfs_abort_transaction(trans, ret);
> -			goto out;
> -		}
> +		if (ret < 0)
> +			goto abort_transaction;
>  	}
>  out:
>  	btrfs_free_path(path);
>  	return 0;
> +e_inval:
> +	ret =3D -EINVAL;
> +abort_transaction:
> +	btrfs_abort_transaction(trans, ret);
> +	goto out;
>  }
> =20
>  /*
>=20


--=20
Jeff Mahoney
SUSE Labs


--56Vfuts0U1X29RRCEO59027wgF2xxPdrB--

--OTENECmdh4alx7W5LrK6CWViB8oWOvagQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWZra/B57S2MheeWyAQjGWg/8CuIlwUKP/uylKNIYKyL1KFGuItvFfG9p
dL1WpZwMNcJ6d7VRJQgBNlSPCFtkoqJuaglwkA46Nw5pYEqg7C2V5NQVB08M121u
VhYTaBea1zNRMthhQFF1Hy6OjwSqS0IJ48bpYijN8eAb2j000fkXuZtIldsB3MgS
gNLC5o+hdVAiCti6GQqDyegIF6NOyIlXDnFYs6zkYwC90mkymnxN1XZqzEUaWTUx
vsocGFGBml7mronO/rG/CbLIQEieDdzifk7gTpSCD2ZcDH1JuMzK3BeA3NMYrpD1
l/k8V0ZDMkN4yX4TJ/sq1CS+uZ51Us8SzRjdZQ69jfWQkHDEcLTap2JMN/VdLTf3
0znin5102wwR2Vy11fQ0F/PRctE3M+fjHCikiJtLYFZzPrqM02/MrkZWIazniGVX
Akj61R3gRtpvBpOy5oSkDjak3qi25q/U4z6oBLCS0N38m81qnNdGe1la8FOH0FxP
ovXjh4fKl+sM+sSKfjDV+ZqZ88za94wfbUWG8T0WK5nmwBAzvS4/OCIp+EJhWJnO
aUWzL9P9BN7OxEKePYFMV6s6UAoaEaylNL/vY5WMRnBn1Qj06VBplyey2Hj2S0BJ
HcdN2QEArn28y2D8o4c6eh5HuDMmB6c87fpdTJWDyBpCyVYO9QoQxVP2Y8wilvcq
o5Rf8cmP2io=
=G3se
-----END PGP SIGNATURE-----

--OTENECmdh4alx7W5LrK6CWViB8oWOvagQ--
