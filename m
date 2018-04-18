Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:42391 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751444AbeDRFRC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Apr 2018 01:17:02 -0400
Subject: Re: [PATCH v2 05/10] btrfs-progs: undelete-subvol: introduce
 recover_dead_root
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180327070658.13064-1-lufq.fnst@cn.fujitsu.com>
 <20180327070658.13064-6-lufq.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <e58a8fec-f1b0-ca82-33d8-4e19e7edaaed@gmx.com>
Date: Wed, 18 Apr 2018 13:16:55 +0800
MIME-Version: 1.0
In-Reply-To: <20180327070658.13064-6-lufq.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="MGuarRyjpQmD3sG37gGBqwHHpElGbrwlJ"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MGuarRyjpQmD3sG37gGBqwHHpElGbrwlJ
Content-Type: multipart/mixed; boundary="hZZNlXc7wnoK7OjPAAyHV6gN0xNAAUUTZ";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <e58a8fec-f1b0-ca82-33d8-4e19e7edaaed@gmx.com>
Subject: Re: [PATCH v2 05/10] btrfs-progs: undelete-subvol: introduce
 recover_dead_root
References: <20180327070658.13064-1-lufq.fnst@cn.fujitsu.com>
 <20180327070658.13064-6-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180327070658.13064-6-lufq.fnst@cn.fujitsu.com>

--hZZNlXc7wnoK7OjPAAyHV6gN0xNAAUUTZ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8827=E6=97=A5 15:06, Lu Fengqi wrote:
> The function will find the root_item specified by the subvol_id,
> clear the BTRFS_ROOT_SUBVOL_DEAD flag and set root_refs to one.

Sorry I didn't point it out in btrfs_link_subvol() patch, but at least
to me, refs should only be modified by btrfs_link_subvol(), just like
btrfs_unlink().

Thanks,
Qu

>=20
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
> ---
>  ctree.h           |  1 +
>  undelete-subvol.c | 55 +++++++++++++++++++++++++++++++++++++++++++++++=
++++++++
>  2 files changed, 56 insertions(+)
>=20
> diff --git a/ctree.h b/ctree.h
> index 4bff0b821472..7c0b8150bc4e 100644
> --- a/ctree.h
> +++ b/ctree.h
> @@ -184,6 +184,7 @@ static int btrfs_csum_sizes[] =3D { 4 };
>  #define BTRFS_FT_MAX		9
> =20
>  #define BTRFS_ROOT_SUBVOL_RDONLY	(1ULL << 0)
> +#define BTRFS_ROOT_SUBVOL_DEAD		(1ULL << 48)
> =20
>  /*
>   * the key defines the order in the tree, and so it also defines (opti=
mal)
> diff --git a/undelete-subvol.c b/undelete-subvol.c
> index 00fcc4895778..781057df2b84 100644
> --- a/undelete-subvol.c
> +++ b/undelete-subvol.c
> @@ -12,6 +12,9 @@
>   */
> =20
>  #include "ctree.h"
> +#include "transaction.h"
> +#include "disk-io.h"
> +#include "messages.h"
> =20
>  /*
>   * Determines whether the subvolume is intact, according to the drop_p=
rogress
> @@ -51,3 +54,55 @@ out:
>  	btrfs_release_path(&path);
>  	return ret;
>  }
> +
> +/*
> + * Clear BTRFS_ROOT_SUBVOL_DEAD flag and set the root_refs to one.
> + *
> + * @root	the root of root tree.
> + * @subvol_id	specify the root_item which will be modified.
> + *
> + * Return 0 if no error occurred.
> + */
> +static int recover_dead_root(struct btrfs_trans_handle *trans,
> +			     struct btrfs_root *root, u64 subvol_id)
> +{
> +	struct btrfs_key key;
> +	struct btrfs_path path;
> +	struct extent_buffer *leaf;
> +	struct btrfs_root_item root_item;
> +	u64 root_flags;
> +	u64 offset;
> +	int ret;
> +
> +	key.objectid =3D subvol_id;
> +	key.type =3D BTRFS_ROOT_ITEM_KEY;
> +	key.offset =3D 0;
> +
> +	btrfs_init_path(&path);
> +	ret =3D btrfs_search_slot(trans, root, &key, &path, 0, 0);
> +	if (ret) {
> +		error("couldn't find ROOT_ITEM for %llu failed: %d",
> +				subvol_id, ret);
> +		goto out;
> +	}
> +
> +	leaf =3D path.nodes[0];
> +
> +	offset =3D btrfs_item_ptr_offset(leaf, path.slots[0]);
> +	read_extent_buffer(leaf, &root_item, offset, sizeof(root_item));
> +
> +	/* Clear BTRFS_ROOT_SUBVOL_DEAD */
> +	root_flags =3D btrfs_root_flags(&root_item);
> +	btrfs_set_root_flags(&root_item,
> +			     root_flags & ~BTRFS_ROOT_SUBVOL_DEAD);
> +
> +	/* Increase the refs */
> +	btrfs_set_root_refs(&root_item, 1);
> +
> +	write_extent_buffer(leaf, &root_item, offset, sizeof(root_item));
> +	btrfs_mark_buffer_dirty(leaf);
> +
> +out:
> +	btrfs_release_path(&path);
> +	return ret;
> +}
>=20


--hZZNlXc7wnoK7OjPAAyHV6gN0xNAAUUTZ--

--MGuarRyjpQmD3sG37gGBqwHHpElGbrwlJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrW1McACgkQwj2R86El
/qi4nwf+KRL6ziULSpa3X+gcfv8Lw3sd5SRX4AuiXtkKdJHQVvfe/L+tRelckwe9
lEbN6RxwcURcIXy1bjydkfjhiQW7KeFJs6kHpgYVX9HNBVveZTsBCsIX8AueBb7A
eE+FGL8YOUCBRBxksKk6ZWkVZjrHaYo5iMuJzESnz4C4+5m/wmIiuTGtHAIIkFyY
MZ2j4C2l88BBQhD+haEG2UW+RRgsmmCBaLauHwX5UAotF+mVtY4LEmPV71GgiSWs
XmsQlGEnEXfw5jyaq8+agLY/un2BlqvxbDRRdX7SWDyGrSSzP2LLRVpM9gsqfnpZ
iJ2Vpwcool++VFyQFqQ8JFGFQuG60Q==
=XSgf
-----END PGP SIGNATURE-----

--MGuarRyjpQmD3sG37gGBqwHHpElGbrwlJ--
