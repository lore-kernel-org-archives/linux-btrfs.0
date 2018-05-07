Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:54357 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751940AbeEGI4m (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 May 2018 04:56:42 -0400
Subject: Re: [PATCH 1/2] btrfs-progs: print-tree: Avoid segfault for heavily
 corrupted item pointers
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180507074628.1563-1-wqu@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <c799c7cd-d1bb-e650-4348-e325f13ea421@gmx.com>
Date: Mon, 7 May 2018 16:56:21 +0800
MIME-Version: 1.0
In-Reply-To: <20180507074628.1563-1-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="MxmOPVkhojOwkQBoAQpRGRRuordoAeAkx"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MxmOPVkhojOwkQBoAQpRGRRuordoAeAkx
Content-Type: multipart/mixed; boundary="bPCWFzdnt6rgQuJaqZl0PbwRMw59Mjcth";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <c799c7cd-d1bb-e650-4348-e325f13ea421@gmx.com>
Subject: Re: [PATCH 1/2] btrfs-progs: print-tree: Avoid segfault for heavily
 corrupted item pointers
References: <20180507074628.1563-1-wqu@suse.com>
In-Reply-To: <20180507074628.1563-1-wqu@suse.com>

--bPCWFzdnt6rgQuJaqZl0PbwRMw59Mjcth
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8807=E6=97=A5 15:46, Qu Wenruo wrote:
> Normally corrupted leaf should be caught by csum check, but sometimes
> corrupted item pointers (out of leaf range) can still pass csum check.
> In fact, our fsck/005 test case image has such corrupted item pointer
> and btrfs check can surprisingly fix it.
>=20
> Anyway, make print-tree to skip such item and remaining slots to avoid
> segfault.
>=20
> Please note that, in btrfs-progs we can't put such check into
> check_tree_block() nor do kernel level comprehensive check as under
> certain case, btrfs-progs can handle or even repair it.
> A restrict check_tree_block() or backporting kernel btrfs_check_leaf()
> could break such test cases and reduce the utility of btrfs-progs.
>=20
> Issue: #128
> Reported-by: Hubert Kario <kario@wit.edu.pl>

Mail changed to <hubert@kario.pl> (Github version already updated.)

Thanks,
Qu

> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  print-tree.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>=20
> diff --git a/print-tree.c b/print-tree.c
> index a1a7954abdae..aaff0f618b7e 100644
> --- a/print-tree.c
> +++ b/print-tree.c
> @@ -1179,6 +1179,7 @@ void btrfs_print_leaf(struct extent_buffer *eb)
>  	struct btrfs_item *item;
>  	struct btrfs_disk_key disk_key;
>  	char flags_str[128];
> +	u32 leaf_data_size =3D BTRFS_LEAF_DATA_SIZE(fs_info);
>  	u32 i;
>  	u32 nr;
>  	u64 flags;
> @@ -1207,6 +1208,23 @@ void btrfs_print_leaf(struct extent_buffer *eb)
>  		u32 type;
>  		u64 offset;
> =20
> +		/*
> +		 * Extra check on item pointers
> +		 * Here we don't need to be as restrict as kernel leaf check.
> +		 * Only need to ensure all pointers are pointing range inside
> +		 * the leaf, thus no segfault.
> +		 */
> +		if (btrfs_item_offset_nr(eb, i) > leaf_data_size ||
> +		    btrfs_item_size_nr(eb, i) + btrfs_item_offset_nr(eb, i) >
> +		    leaf_data_size) {
> +			error(
> +"leaf %llu slot %u pointer invalid, offset %u size %u leaf data limit =
%u",
> +			      btrfs_header_bytenr(eb), i,
> +			      btrfs_item_offset_nr(eb, i),
> +			      btrfs_item_size_nr(eb, i), leaf_data_size);
> +			error("skip remaining slots");
> +			break;
> +		}
>  		item =3D btrfs_item_nr(i);
>  		item_size =3D btrfs_item_size(eb, item);
>  		/* Untyped extraction of slot from btrfs_item_ptr */
>=20


--bPCWFzdnt6rgQuJaqZl0PbwRMw59Mjcth--

--MxmOPVkhojOwkQBoAQpRGRRuordoAeAkx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrwFLUACgkQwj2R86El
/qgWxQf7B45t2v4BNV4NOK0TEFAltk7au3NFtwdlNvdfP0jSKyFso+G6tGNb41Sm
8LjWKKZH5jeSzdd2AZ2xRHYKyf8NpZZ/FJEW8Dsp3I5BbD+RkJ3Hs6mYfPfUHw97
xq6HJUi0o/V9bYC50o9Hvj943Ar2Pki1VBRVmucHOBLqvuAl6rMp4bRVFIfa400g
oObWku552XHL9r/Kz/kbAqXbsqgHLHfxwEI7XEkKomIiVoSwIWWf8EgFuXogC4sO
94gWiNVr5i2Fbprr7f1900L9G0j2d6ZoJY958BEB78hSrTVlAo+Ziw+Lskzx9/cZ
L6oHEVTrp6odZSltyuqI/oIHxqPy/Q==
=neZU
-----END PGP SIGNATURE-----

--MxmOPVkhojOwkQBoAQpRGRRuordoAeAkx--
