Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:39469 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752132AbeENLWV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 07:22:21 -0400
Subject: Re: [PATCH 1/3] btrfs-progs: check: check symlinks with
 append/immutable flags
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180514102922.8840-1-suy.fnst@cn.fujitsu.com>
 <20180514102922.8840-2-suy.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <6250dfd4-80c3-1714-27f4-d0091ef411a6@gmx.com>
Date: Mon, 14 May 2018 19:22:13 +0800
MIME-Version: 1.0
In-Reply-To: <20180514102922.8840-2-suy.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="wD8zry1uFnGQxRuCLu66m9paKNWOGjFUz"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wD8zry1uFnGQxRuCLu66m9paKNWOGjFUz
Content-Type: multipart/mixed; boundary="TH54eR0kfgvV8i6JYPtbrpE9MP5esnMDl";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <6250dfd4-80c3-1714-27f4-d0091ef411a6@gmx.com>
Subject: Re: [PATCH 1/3] btrfs-progs: check: check symlinks with
 append/immutable flags
References: <20180514102922.8840-1-suy.fnst@cn.fujitsu.com>
 <20180514102922.8840-2-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180514102922.8840-2-suy.fnst@cn.fujitsu.com>

--TH54eR0kfgvV8i6JYPtbrpE9MP5esnMDl
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8814=E6=97=A5 18:29, Su Yue wrote:
> Define new macro I_ERR_ODD_INODE_FLAGS to represents odd inode flags.
>=20
> Symlinks should never have append/immutable flags.
> While processing inodes, if found a symlink with append/immutable
> flags, mark the inode record with I_ERR_ODD_INODE_FLAGS.
>=20
> This is for original mode.
>=20
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>  check/main.c          | 7 +++++++
>  check/mode-original.h | 1 +
>  2 files changed, 8 insertions(+)
>=20
> diff --git a/check/main.c b/check/main.c
> index 68da994f7ae0..f5f52c406046 100644
> --- a/check/main.c
> +++ b/check/main.c
> @@ -576,6 +576,8 @@ static void print_inode_error(struct btrfs_root *ro=
ot, struct inode_record *rec)
>  		fprintf(stderr, ", link count wrong");
>  	if (errors & I_ERR_FILE_EXTENT_ORPHAN)
>  		fprintf(stderr, ", orphan file extent");
> +	if (errors & I_ERR_ODD_INODE_FLAGS)
> +		fprintf(stderr, ", odd inode flags");
>  	fprintf(stderr, "\n");
>  	/* Print the orphan extents if needed */
>  	if (errors & I_ERR_FILE_EXTENT_ORPHAN)
> @@ -805,6 +807,7 @@ static int process_inode_item(struct extent_buffer =
*eb,
>  {
>  	struct inode_record *rec;
>  	struct btrfs_inode_item *item;
> +	u64 flags;
> =20
>  	rec =3D active_node->current;
>  	BUG_ON(rec->ino !=3D key->objectid || rec->refs > 1);
> @@ -822,6 +825,10 @@ static int process_inode_item(struct extent_buffer=
 *eb,
>  	rec->found_inode_item =3D 1;
>  	if (rec->nlink =3D=3D 0)
>  		rec->errors |=3D I_ERR_NO_ORPHAN_ITEM;
> +	flags =3D btrfs_inode_flags(eb, item);
> +	if (rec->imode & BTRFS_FT_SYMLINK &&
> +	    flags & (BTRFS_INODE_IMMUTABLE | BTRFS_INODE_APPEND))
> +		rec->errors =3D I_ERR_ODD_INODE_FLAGS;

Shouldn't it be "|=3D" instead of "=3D" ?

Thanks,
Qu

>  	maybe_free_inode_rec(&active_node->inode_cache, rec);
>  	return 0;
>  }
> diff --git a/check/mode-original.h b/check/mode-original.h
> index 368de692fdd1..13cfa5b9e1b3 100644
> --- a/check/mode-original.h
> +++ b/check/mode-original.h
> @@ -186,6 +186,7 @@ struct file_extent_hole {
>  #define I_ERR_LINK_COUNT_WRONG		(1 << 13)
>  #define I_ERR_FILE_EXTENT_ORPHAN	(1 << 14)
>  #define I_ERR_FILE_EXTENT_TOO_LARGE	(1 << 15)
> +#define I_ERR_ODD_INODE_FLAGS		(1 << 16)
> =20
>  struct inode_record {
>  	struct list_head backrefs;
>=20


--TH54eR0kfgvV8i6JYPtbrpE9MP5esnMDl--

--wD8zry1uFnGQxRuCLu66m9paKNWOGjFUz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlr5cWUACgkQwj2R86El
/qi0PggAomJrMJ2Hg9/nLbnepGZWeaykWj2lhi4bHYrcERT9fqaVrUgAs1yatp/R
7F7NHmyN/uQCJxVGa0eqL6pwnpGGm9WhVDp1doduscUCRSKbWPxwKkt41yIyFCiY
6sl5vMazoUzUcWNgMRtsnGU0TSb9koJR/hF8hYogO+ywZWLMicixUmT4vIKnfHtw
lI3PwbrJFGDaMqC9RD70XtJdD3gPfoCVFRIJlfAfgQ1SQQRWZpCvtpRxF/kCCUkn
njZMeDl99BS+hf2eyG+7UophqGuCUiCQF059Ot3ykYPEmWavVamr/kjPp/aerSAa
XamNW5os5AbWaaU4m3ohOTJOu1+BhA==
=v50g
-----END PGP SIGNATURE-----

--wD8zry1uFnGQxRuCLu66m9paKNWOGjFUz--
