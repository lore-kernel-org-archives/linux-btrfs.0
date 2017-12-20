Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:54128 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932124AbdLTFqf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Dec 2017 00:46:35 -0500
Subject: Re: [PATCH v2 07/17] btrfs-progs: lowmem check: introduce
 try_avoid_extents_overwrite()
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20171220045731.19343-1-suy.fnst@cn.fujitsu.com>
 <20171220045731.19343-8-suy.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <9d409201-bad4-9475-af42-8c4dda959086@gmx.com>
Date: Wed, 20 Dec 2017 13:46:27 +0800
MIME-Version: 1.0
In-Reply-To: <20171220045731.19343-8-suy.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mcd9kTYj6j4hGjQvMrOLgFz2feu6xpxZL"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mcd9kTYj6j4hGjQvMrOLgFz2feu6xpxZL
Content-Type: multipart/mixed; boundary="g2REMFYuVJF05yrcncSLeEaA7UHydh5Id";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <9d409201-bad4-9475-af42-8c4dda959086@gmx.com>
Subject: Re: [PATCH v2 07/17] btrfs-progs: lowmem check: introduce
 try_avoid_extents_overwrite()
References: <20171220045731.19343-1-suy.fnst@cn.fujitsu.com>
 <20171220045731.19343-8-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20171220045731.19343-8-suy.fnst@cn.fujitsu.com>

--g2REMFYuVJF05yrcncSLeEaA7UHydh5Id
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8820=E6=97=A5 12:57, Su Yue wrote:
> Define a global enum extents_operation to record extents are pinned,
> excluded or new chunk is allocated for extents.
> Although global variable is not so graceful, it simplifies codes much.
>=20
> New function try_avoid_extents_overwrite() will try to mark block
> groups full and allocate a new chunk. If it failed because of no space
> or wrong used bytes(fsck-tests/004), then try to exclude metadata
> blocks.
>=20
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>  cmds-check.c | 101 +++++++++++++++++++++++++++++++++++++++++++++++++++=
++++++++
>  1 file changed, 101 insertions(+)
>=20
> diff --git a/cmds-check.c b/cmds-check.c
> index 311c8a9f45e8..9042bab93785 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -84,6 +84,15 @@ enum btrfs_check_mode {
> =20
>  static enum btrfs_check_mode check_mode =3D CHECK_MODE_DEFAULT;
> =20
> +enum lowmem_extents_operation {
> +	EXTENTS_PIN,
> +	EXTENTS_EXCLUDE,
> +	EXTENTS_MARK_BG_FULL,
> +	EXTENTS_NONE
> +};
> +
> +static enum lowmem_extents_operation extents_operation =3D EXTENTS_NON=
E;
> +
>  struct extent_backref {
>  	struct rb_node node;
>  	unsigned int is_data:1;
> @@ -13517,6 +13526,98 @@ out:
>  	return err;
>  }
> =20
> +static void cleanup_excluded_extents(struct btrfs_fs_info *fs_info);
> +static int end_avoid_extents_overwrite(struct btrfs_fs_info *fs_info)
> +{
> +	int ret;
> +
> +	switch (extents_operation) {
> +	case EXTENTS_PIN:
> +		ret =3D btrfs_finish_extent_commit(NULL, fs_info->extent_root,
> +						 &fs_info->pinned_extents);
> +		break;

Any particular reason to support pining down extents?

As I already mentioned in the bug fix patch, pin will cause extent to be
considered as free after transaction commitment.

Or it's only designed to support extent-tree rebuild?

At least I didn't see any where using EXTENT_PIN in the patchset.

Thanks,
Qu

> +	case EXTENTS_EXCLUDE:
> +		cleanup_excluded_extents(fs_info);
> +		ret =3D 0;
> +		break;
> +	case EXTENTS_MARK_BG_FULL:
> +		ret =3D modify_block_groups_cache(fs_info,
> +						BTRFS_BLOCK_GROUP_METADATA, 0);
> +		break;
> +	case EXTENTS_NONE:
> +		ret =3D 0;
> +		break;
> +	default:
> +		ret =3D -EINVAL;
> +	}
> +
> +	if (!ret)
> +		extents_operation =3D EXTENTS_NONE;
> +	return ret;
> +}
> +
> +static int pin_metadata_blocks(struct btrfs_fs_info *fs_info);
> +static int exclude_metadata_blocks(struct btrfs_fs_info *fs_info);
> +/*
> + * NOTE: Do not call this function during transaction.
> + */
> +static int avoid_extents_overwrite(struct btrfs_fs_info *fs_info,
> +				   enum lowmem_extents_operation op)
> +{
> +	int ret;
> +
> +	if (op =3D=3D extents_operation)
> +		return 0;
> +
> +	switch (op) {
> +	case EXTENTS_PIN:
> +		ret =3D pin_metadata_blocks(fs_info);
> +		break;
> +	case EXTENTS_EXCLUDE:
> +		ret =3D exclude_metadata_blocks(fs_info);
> +		break;
> +	case EXTENTS_MARK_BG_FULL:
> +		ret =3D force_cow_in_new_chunk(fs_info);
> +		break;
> +	case EXTENTS_NONE:
> +		ret =3D 0;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	/* extents_operation should be assigned anyway for latter clean up. *=
/
> +	extents_operation =3D op;
> +
> +	if (ret)
> +		end_avoid_extents_overwrite(fs_info);
> +	return ret;
> +}
> +
> +static int try_avoid_extents_overwrite(struct btrfs_fs_info *fs_info)
> +{
> +	int ret;
> +	int mixed =3D btrfs_fs_incompat(fs_info, MIXED_GROUPS);
> +
> +	if (extents_operation !=3D EXTENTS_NONE)
> +		return 0;
> +	ret =3D avoid_extents_overwrite(fs_info, EXTENTS_MARK_BG_FULL);
> +
> +	/*
> +	 * If there is no space left to allocate, try to exclude all metadata=

> +	 * blocks. Mix filesystem is unsupported.
> +	 */
> +	if (ret && ret =3D=3D -ENOSPC && !mixed) {
> +		printf(
> +	"Try to exclude all metadata blcoks and extents, it may be slow\n");
> +		ret =3D avoid_extents_overwrite(fs_info, EXTENTS_EXCLUDE);
> +	}
> +
> +	if (ret)
> +		error("failed to avoid extents overwrite %s", strerror(-ret));
> +	return ret;
> +}
> +
>  /*
>   * Low memory usage version check_chunks_and_extents.
>   */
>=20


--g2REMFYuVJF05yrcncSLeEaA7UHydh5Id--

--mcd9kTYj6j4hGjQvMrOLgFz2feu6xpxZL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlo5+TMXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qiz6gf9FzWb+rO+kuyfm+GcPvfZSlLI
sW622Uf72ekgxmnP+FWf/aoc7hPPbwWs0bZfkv9b0rEZZMZgG9K1MnBgmq3o9tjG
2S696RQryyrbfxNxmoscknmx4hjZ2uYa8/P6oftEJqLJDhI1w4p/RxnPjBdc3d2x
fggD3efU8rk9rHUJt9Ysdbnoo/C9o9S+j/yxoH/3CtiSxx+WlwHfAgRcollk5/4O
G0uZl/TUdxDIH3XTVKql2UFenDIeFrve0KQTFuNkDC1g27j03pRoosAfrmolIyAk
xZKCoc0Eos+beF7qufQahNYUEvKkxCIUAmhqVFf+Qe6hSUvVfu3wgTjQbGBjTQ==
=WM9k
-----END PGP SIGNATURE-----

--mcd9kTYj6j4hGjQvMrOLgFz2feu6xpxZL--
