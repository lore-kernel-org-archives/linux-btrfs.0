Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:43915 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751022AbeDYGQQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Apr 2018 02:16:16 -0400
Subject: Re: [PATCH V2.1] btrfs-progs: do not merge tree block refs have
 different root_id
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180424055233.6420-1-suy.fnst@cn.fujitsu.com>
 <20180425051924.2924-1-suy.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <8b99e4b3-2866-8154-63be-3c34c137f15d@gmx.com>
Date: Wed, 25 Apr 2018 14:15:56 +0800
MIME-Version: 1.0
In-Reply-To: <20180425051924.2924-1-suy.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="sz6dfPbe0LR2s1DHkSXDdr98UA8OfEB9g"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--sz6dfPbe0LR2s1DHkSXDdr98UA8OfEB9g
Content-Type: multipart/mixed; boundary="dDuCQHWInPTnsdqGBJEGgVcTTxsNZIZgg";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <8b99e4b3-2866-8154-63be-3c34c137f15d@gmx.com>
Subject: Re: [PATCH V2.1] btrfs-progs: do not merge tree block refs have
 different root_id
References: <20180424055233.6420-1-suy.fnst@cn.fujitsu.com>
 <20180425051924.2924-1-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180425051924.2924-1-suy.fnst@cn.fujitsu.com>

--dDuCQHWInPTnsdqGBJEGgVcTTxsNZIZgg
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B404=E6=9C=8825=E6=97=A5 13:19, Su Yue wrote:
> For an extent item which contains many tree block backrefs, like
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> In 020-extent-ref-cases/keyed_block_ref.img
>=20
> item 10 key (29470720 METADATA_ITEM 0) itemoff 3450 itemsize 222
>                 refs 23 gen 10 flags TREE_BLOCK
>                 tree block skinny level 0
>                 tree block backref root 278
>                 tree block backref root 277
>                 tree block backref root 276
>                 tree block backref root 275
>                 tree block backref root 274
>                 tree block backref root 273
>                 tree block backref root 272
>                 tree block backref root 271
>                 tree block backref root 270
>                 tree block backref root 269
>                 tree block backref root 268
>                 tree block backref root 267
>                 tree block backref root 266
>                 tree block backref root 265
>                 tree block backref root 264
>                 tree block backref root 263
>                 tree block backref root 262
>                 tree block backref root 261
>                 tree block backref root 260
>                 tree block backref root 259
>                 tree block backref root 258
>                 tree block backref root 257
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> In find_parent_nodes(), these refs's parents are 0, then __merge_refs
> will merge refs to one ref. It causes only one root to be returned.
>=20
> So, if both parents are 0, do not merge refs.
>=20
> Lowmem check calls find_parent_nodes frequently to decide whether
> check an extent buffer or not. The bug influences bytes accounting.
>=20
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Waiting for the kernel port of backref.c to solve the problem permanently=
=2E

Thanks,
Qu

> ---
> Changelog:
> v2:
>   Put judgment of ref->parent above comparison.
>   Add the comment.
>   Fix typos.
> v2.1:
>   Remove the change of adding a new line.
> ---
>  backref.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>=20
> diff --git a/backref.c b/backref.c
> index 51553c702187..23a394edfd02 100644
> --- a/backref.c
> +++ b/backref.c
> @@ -505,6 +505,12 @@ static void __merge_refs(struct pref_state *prefst=
ate, int mode)
>  				if (!ref_for_same_block(ref1, ref2))
>  					continue;
>  			} else {
> +				/*
> +				 * Parent =3D=3D 0 means that the ref is tree block
> +				 * backref or its parent is unresolved.
> +				 */
> +				if (!ref1->parent || !ref2->parent)
> +					continue;
>  				if (ref1->parent !=3D ref2->parent)
>  					continue;
>  			}
>=20


--dDuCQHWInPTnsdqGBJEGgVcTTxsNZIZgg--

--sz6dfPbe0LR2s1DHkSXDdr98UA8OfEB9g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrgHRwACgkQwj2R86El
/qh0Ygf/b8Ft/b4V04UTeEMzBMhqhVzrJ9tEYbP1gGDYzlOKgRuWfpR47A4mIOhe
MY9/VLlKi3LyTig0RZ5aperZBzijS3MzOUcLDC8gcS0oCXWbvgtW8nPg0LI89Kau
wXrA80fAWd5mh4GXbx0gFL3+3xogivRK51UqC1QvFm0pgzGJ07ajH3FbCpInH7GM
yM1koAcuRzjFKE25HWhujpfMnksJegg3Q5IUvo4ZncwbbyBNCN9ZqibQLjPoa4dM
v90hpxYUcxX89tjpJCUOzkEWbMdK3ZSNGESAe5/0YtDXaNRZ27cPGx3j2/4WtH8p
ELZgi6Prz4SnDsbVNy5uBz2PP8bF4g==
=PeCr
-----END PGP SIGNATURE-----

--sz6dfPbe0LR2s1DHkSXDdr98UA8OfEB9g--
