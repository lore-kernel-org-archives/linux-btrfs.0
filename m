Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:34037 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751678AbdKVJGs (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 22 Nov 2017 04:06:48 -0500
Subject: Re: [PATCH] btrfs: handle errors while updating refcounts in
 update_ref_for_cow
To: jeffm@suse.com, linux-btrfs@vger.kernel.org
Cc: stable@vger.kernel.org
References: <20171121185849.22602-1-jeffm@suse.com>
From: Qu Wenruo <wqu@suse.com>
Message-ID: <2c7b0550-1017-aa3c-b202-ab588da4a9a1@suse.com>
Date: Wed, 22 Nov 2017 17:06:34 +0800
MIME-Version: 1.0
In-Reply-To: <20171121185849.22602-1-jeffm@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="M4s5Ebm7lXpTgonkPu82AV9CxmKxaAt8E"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--M4s5Ebm7lXpTgonkPu82AV9CxmKxaAt8E
Content-Type: multipart/mixed; boundary="wiiWnTjM212lfOao1wm5v42ELubVic8fj";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.com>
To: jeffm@suse.com, linux-btrfs@vger.kernel.org
Cc: stable@vger.kernel.org
Message-ID: <2c7b0550-1017-aa3c-b202-ab588da4a9a1@suse.com>
Subject: Re: [PATCH] btrfs: handle errors while updating refcounts in
 update_ref_for_cow
References: <20171121185849.22602-1-jeffm@suse.com>
In-Reply-To: <20171121185849.22602-1-jeffm@suse.com>

--wiiWnTjM212lfOao1wm5v42ELubVic8fj
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8822=E6=97=A5 02:58, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
>=20
> Since commit fb235dc06fa (btrfs: qgroup: Move half of the qgroup
> accounting time out of commit trans) the assumption that
> btrfs_add_delayed_{data,tree}_ref can only return 0 or -ENOMEM has
> been false.  The qgroup operations call into btrfs_search_slot
> and friends and can now return the full spectrum of error codes.
>=20
> Fortunately, the fix here is easy since update_ref_for_cow failing
> is already handled so we just need to bail early with the error
> code.
>=20
> Fixes: fb235dc06fa (btrfs: qgroup: Move half of the qgroup accounting .=
=2E.)
> Cc: <stable@vger.kernel.org> # v4.11+
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Looks good.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  fs/btrfs/ctree.c | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
>=20
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 531e0a8645b0..1e74cf826532 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -1032,14 +1032,17 @@ static noinline int update_ref_for_cow(struct b=
trfs_trans_handle *trans,
>  		     root->root_key.objectid =3D=3D BTRFS_TREE_RELOC_OBJECTID) &&
>  		    !(flags & BTRFS_BLOCK_FLAG_FULL_BACKREF)) {
>  			ret =3D btrfs_inc_ref(trans, root, buf, 1);
> -			BUG_ON(ret); /* -ENOMEM */
> +			if (ret)
> +				return ret;
> =20
>  			if (root->root_key.objectid =3D=3D
>  			    BTRFS_TREE_RELOC_OBJECTID) {
>  				ret =3D btrfs_dec_ref(trans, root, buf, 0);
> -				BUG_ON(ret); /* -ENOMEM */
> +				if (ret)
> +					return ret;
>  				ret =3D btrfs_inc_ref(trans, root, cow, 1);
> -				BUG_ON(ret); /* -ENOMEM */
> +				if (ret)
> +					return ret;
>  			}
>  			new_flags |=3D BTRFS_BLOCK_FLAG_FULL_BACKREF;
>  		} else {
> @@ -1049,7 +1052,8 @@ static noinline int update_ref_for_cow(struct btr=
fs_trans_handle *trans,
>  				ret =3D btrfs_inc_ref(trans, root, cow, 1);
>  			else
>  				ret =3D btrfs_inc_ref(trans, root, cow, 0);
> -			BUG_ON(ret); /* -ENOMEM */
> +			if (ret)
> +				return ret;
>  		}
>  		if (new_flags !=3D 0) {
>  			int level =3D btrfs_header_level(buf);
> @@ -1068,9 +1072,11 @@ static noinline int update_ref_for_cow(struct bt=
rfs_trans_handle *trans,
>  				ret =3D btrfs_inc_ref(trans, root, cow, 1);
>  			else
>  				ret =3D btrfs_inc_ref(trans, root, cow, 0);
> -			BUG_ON(ret); /* -ENOMEM */
> +			if (ret)
> +				return ret;
>  			ret =3D btrfs_dec_ref(trans, root, buf, 1);
> -			BUG_ON(ret); /* -ENOMEM */
> +			if (ret)
> +				return ret;
>  		}
>  		clean_tree_block(fs_info, buf);
>  		*last_ref =3D 1;
>=20


--wiiWnTjM212lfOao1wm5v42ELubVic8fj--

--M4s5Ebm7lXpTgonkPu82AV9CxmKxaAt8E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFBBAEBCAArFiEELd9y5aWlW6idqkLhwj2R86El/qgFAloVPhoNHHdxdUBzdXNl
LmNvbQAKCRDCPZHzoSX+qKWFB/9vYbR0BPdJQxJCfDJxyW+dYuN4T5QYu1Ng0eNO
ELYzmCT7lS0EU4zXdVKgr/0zGkm+urOKWbVEoNXDJVyJMwH4jBTOJCbEXL+CrN7f
TsyVs9uz2q6eI9px6WLvIEvLBVrzuljNFRbclyWLiTf3lYgDqRrVxnEeB532aywK
A8aJJ70mMscZE3zL2f0s1INybwxkXhm0f4Pw5KoLSYiqZxYDqVNk1wm9HHFV1+UA
frKF1ZBv/W2ZG9+PUOdOiDNCK4YQyn/JhKkL6BcFiBOHkixTM3EqXp2iD7nyPmkK
jjmh+a0vacWhvfBGpt5VPMpDfDH3qS416HnGAlFZPgwaiinc
=4LcK
-----END PGP SIGNATURE-----

--M4s5Ebm7lXpTgonkPu82AV9CxmKxaAt8E--
