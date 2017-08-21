Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40589 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753387AbdHUNHw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 09:07:52 -0400
Subject: Re: [PATCH 2/5] btrfs: Use common error handling code in
 __btrfs_free_extent()
To: SF Markus Elfring <elfring@users.sourceforge.net>,
        linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, Josef Bacik <jbacik@fb.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
References: <1e8e1da2-a9e3-9dc7-6ffe-6c32f8464337@users.sourceforge.net>
 <5c87a777-0772-456c-d094-9ca3f819a182@users.sourceforge.net>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <5a10445b-763a-29a3-aa34-32e5381fdade@suse.com>
Date: Mon, 21 Aug 2017 09:07:47 -0400
MIME-Version: 1.0
In-Reply-To: <5c87a777-0772-456c-d094-9ca3f819a182@users.sourceforge.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7AV6IC0JS4dHwfFa82wXRaOW9hg7DiUer"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7AV6IC0JS4dHwfFa82wXRaOW9hg7DiUer
Content-Type: multipart/mixed; boundary="FWNTH7ckMqqWh6NcHKtJD21eVfeIvsS5E";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>,
 linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Josef Bacik <jbacik@fb.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Message-ID: <5a10445b-763a-29a3-aa34-32e5381fdade@suse.com>
Subject: Re: [PATCH 2/5] btrfs: Use common error handling code in
 __btrfs_free_extent()
References: <1e8e1da2-a9e3-9dc7-6ffe-6c32f8464337@users.sourceforge.net>
 <5c87a777-0772-456c-d094-9ca3f819a182@users.sourceforge.net>
In-Reply-To: <5c87a777-0772-456c-d094-9ca3f819a182@users.sourceforge.net>

--FWNTH7ckMqqWh6NcHKtJD21eVfeIvsS5E
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/21/17 8:38 AM, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Mon, 21 Aug 2017 10:03:00 +0200
>=20
> Add a jump target so that a bit of exception handling can be better reu=
sed
> at the end of this function.
>=20
> This issue was detected by using the Coccinelle software.

btrfs_abort_transaction dumps __FILE__:__LINE__ in the log so this patch
makes the code more difficult to debug.

-Jeff


> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  fs/btrfs/extent-tree.c | 69 ++++++++++++++++++++----------------------=
--------
>  1 file changed, 27 insertions(+), 42 deletions(-)
>=20
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 116c5615d6c2..c6b7aca88491 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -6913,10 +6913,9 @@ static int __btrfs_free_extent(struct btrfs_tran=
s_handle *trans,
>  			ret =3D remove_extent_backref(trans, info, path, NULL,
>  						    refs_to_drop,
>  						    is_data, &last_ref);
> -			if (ret) {
> -				btrfs_abort_transaction(trans, ret);
> -				goto out;
> -			}
> +			if (ret)
> +				goto abort_transaction;
> +
>  			btrfs_release_path(path);
>  			path->leave_spinning =3D 1;
> =20
> @@ -6962,10 +6961,9 @@ static int __btrfs_free_extent(struct btrfs_tran=
s_handle *trans,
>  				if (ret > 0)
>  					btrfs_print_leaf(path->nodes[0]);
>  			}
> -			if (ret < 0) {
> -				btrfs_abort_transaction(trans, ret);
> -				goto out;
> -			}
> +			if (ret < 0)
> +				goto abort_transaction;
> +
>  			extent_slot =3D path->slots[0];
>  		}
>  	} else if (WARN_ON(ret =3D=3D -ENOENT)) {
> @@ -6974,11 +6972,9 @@ static int __btrfs_free_extent(struct btrfs_tran=
s_handle *trans,
>  			"unable to find ref byte nr %llu parent %llu root %llu  owner %llu =
offset %llu",
>  			bytenr, parent, root_objectid, owner_objectid,
>  			owner_offset);
> -		btrfs_abort_transaction(trans, ret);
> -		goto out;
> +		goto abort_transaction;
>  	} else {
> -		btrfs_abort_transaction(trans, ret);
> -		goto out;
> +		goto abort_transaction;
>  	}
> =20
>  	leaf =3D path->nodes[0];
> @@ -6988,10 +6984,8 @@ static int __btrfs_free_extent(struct btrfs_tran=
s_handle *trans,
>  		BUG_ON(found_extent || extent_slot !=3D path->slots[0]);
>  		ret =3D convert_extent_item_v0(trans, info, path, owner_objectid,
>  					     0);
> -		if (ret < 0) {
> -			btrfs_abort_transaction(trans, ret);
> -			goto out;
> -		}
> +		if (ret < 0)
> +			goto abort_transaction;
> =20
>  		btrfs_release_path(path);
>  		path->leave_spinning =3D 1;
> @@ -7008,10 +7002,8 @@ static int __btrfs_free_extent(struct btrfs_tran=
s_handle *trans,
>  				ret, bytenr);
>  			btrfs_print_leaf(path->nodes[0]);
>  		}
> -		if (ret < 0) {
> -			btrfs_abort_transaction(trans, ret);
> -			goto out;
> -		}
> +		if (ret < 0)
> +			goto abort_transaction;
> =20
>  		extent_slot =3D path->slots[0];
>  		leaf =3D path->nodes[0];
> @@ -7035,8 +7027,7 @@ static int __btrfs_free_extent(struct btrfs_trans=
_handle *trans,
>  			  "trying to drop %d refs but we only have %Lu for bytenr %Lu",
>  			  refs_to_drop, refs, bytenr);
>  		ret =3D -EINVAL;
> -		btrfs_abort_transaction(trans, ret);
> -		goto out;
> +		goto abort_transaction;
>  	}
>  	refs -=3D refs_to_drop;
> =20
> @@ -7057,10 +7048,8 @@ static int __btrfs_free_extent(struct btrfs_tran=
s_handle *trans,
>  			ret =3D remove_extent_backref(trans, info, path,
>  						    iref, refs_to_drop,
>  						    is_data, &last_ref);
> -			if (ret) {
> -				btrfs_abort_transaction(trans, ret);
> -				goto out;
> -			}
> +			if (ret)
> +				goto abort_transaction;
>  		}
>  	} else {
>  		if (found_extent) {
> @@ -7078,37 +7067,33 @@ static int __btrfs_free_extent(struct btrfs_tra=
ns_handle *trans,
>  		last_ref =3D 1;
>  		ret =3D btrfs_del_items(trans, extent_root, path, path->slots[0],
>  				      num_to_del);
> -		if (ret) {
> -			btrfs_abort_transaction(trans, ret);
> -			goto out;
> -		}
> +		if (ret)
> +			goto abort_transaction;
> +
>  		btrfs_release_path(path);
> =20
>  		if (is_data) {
>  			ret =3D btrfs_del_csums(trans, info, bytenr, num_bytes);
> -			if (ret) {
> -				btrfs_abort_transaction(trans, ret);
> -				goto out;
> -			}
> +			if (ret)
> +				goto abort_transaction;
>  		}
> =20
>  		ret =3D add_to_free_space_tree(trans, info, bytenr, num_bytes);
> -		if (ret) {
> -			btrfs_abort_transaction(trans, ret);
> -			goto out;
> -		}
> +		if (ret)
> +			goto abort_transaction;
> =20
>  		ret =3D update_block_group(trans, info, bytenr, num_bytes, 0);
> -		if (ret) {
> -			btrfs_abort_transaction(trans, ret);
> -			goto out;
> -		}
> +		if (ret)
> +			goto abort_transaction;
>  	}
>  	btrfs_release_path(path);
> =20
>  out:
>  	btrfs_free_path(path);
>  	return ret;
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


--FWNTH7ckMqqWh6NcHKtJD21eVfeIvsS5E--

--7AV6IC0JS4dHwfFa82wXRaOW9hg7DiUer
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWZrbIx57S2MheeWyAQhDAg//daNMdizs6+kkJxiY0SWTBS8fZX4C0GrU
ZAj9wvQoM4GM3nBj725MfpHGZg5qoMJXFHuo7lV+ywBBwHXLGDL6rVk6ZLYRQLWn
MftssKBckTRUnQDjfR2PseAif7NTpHzLj+1ISpvHcJwx5ohZb6McqwxZoPlNkTl+
l1HF5mQBpHmyO3dWhbzDYb5fGOfnQ20fkQh7KbFN3Jjm5UI4hCdkbRD7rlcvXHOR
am/rkFReAi4loEvDaZUGBhpG2Y8vnhYr1ekT8eAsSktTsSFZWI25P84t9f0KcqHw
7I2cmZMaB+PjTz+LPDZkAsO1HTv0DZ+XPsAYA3VJUVu1fodi36tDz1A5zWQMnhlO
DD0AMWrl7RMmjUz+db7wWcYq/1rkxkzQQVhz7CqCaMvNeLgeMa5OV+bP44nyWEpH
V09pWnwyhbh05csCmgQwvZaQveU9c0HSZomcjwn/+fvAbR9t8M/zuDFydNNcVsIx
DlNPslG/pbwEm4CX/eHoz9pAl3760M3HDRN0+4cpa7efkoudgGqJ+THtIuc97kPF
gXGneX41h7HyxDFpww9Ttq25PMt06RtlMl7z7QWPHqN9IwX6LpA0BcdPZNmyH3DC
EBZNAN9PNY+dDzV06wSn85iDfRndv3tigYWB8w2/Sjf2ILSKkhAYKQeV6mylKLmW
UMUh3Xj2KWs=
=y1YY
-----END PGP SIGNATURE-----

--7AV6IC0JS4dHwfFa82wXRaOW9hg7DiUer--
