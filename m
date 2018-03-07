Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:33235 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754151AbeCGKd0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 05:33:26 -0500
Subject: Re: [PATCH 2/2] Btrfs: fix fiemap extent SHARED flag error with range
 clone.
To: robbieko <robbieko@synology.com>, linux-btrfs@vger.kernel.org
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <2ff9062e-54fa-50dd-8efa-352608746bc5@gmx.com>
Date: Wed, 7 Mar 2018 18:33:05 +0800
MIME-Version: 1.0
In-Reply-To: <1520410819-32405-3-git-send-email-robbieko@synology.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="tUfSnLRoKaFqS4ef83oJG9DdE6mD97kMj"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1520410819-32405-3-git-send-email-robbieko@synology.com>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tUfSnLRoKaFqS4ef83oJG9DdE6mD97kMj
Content-Type: multipart/mixed; boundary="Gnjj7pnqV6cTUfQW46OL8g2ZbAIJQLRsE";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: robbieko <robbieko@synology.com>, linux-btrfs@vger.kernel.org
Message-ID: <2ff9062e-54fa-50dd-8efa-352608746bc5@gmx.com>
Subject: Re: [PATCH 2/2] Btrfs: fix fiemap extent SHARED flag error with range
 clone.
References: <1520410819-32405-1-git-send-email-robbieko@synology.com>
 <1520410819-32405-3-git-send-email-robbieko@synology.com>
In-Reply-To: <1520410819-32405-3-git-send-email-robbieko@synology.com>

--Gnjj7pnqV6cTUfQW46OL8g2ZbAIJQLRsE
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8807=E6=97=A5 16:20, robbieko wrote:
> From: Robbie Ko <robbieko@synology.com>
>=20
> [BUG]
> Range clone can cause fiemap to return error result.
> Like:
>  # mount /dev/vdb5 /mnt/btrfs
>  # dd if=3D/dev/zero bs=3D16K count=3D2 oflag=3Ddsync of=3D/mnt/btrfs/f=
ile
>  # xfs_io -c "fiemap -v" /mnt/btrfs/file
>  /mnt/btrfs/file:
>  EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
>    0: [0..63]:         4241424..4241487    64   0x1
>=20
>  # cloner -s $((16*1024)) /mnt/btrfs/file /mnt/btrfs/file_clone
>  # xfs_io -c "fiemap -v" /mnt/btrfs/file
>  /mnt/btrfs/file:
>  EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
>    0: [0..63]:         4241424..4241487    64   0x1
>  If we clone second file extent, we will get error FLAGS,
>  SHARED bit is not set.
>=20
> [REASON]
> Btrfs only checks if the first extent in extent map is shared,
> but extent may merge.
>=20
> [FIX]
> Here we will check each extent with extent map range,
> if one of them is shared, extent map is shared.
>=20
> [PATCH RESULT]
>  # xfs_io -c "fiemap -v" /mnt/btrfs/file
>  /mnt/btrfs/file:
>  EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
>    0: [0..63]:         4241424..4241487    64 0x2001
>=20
> Signed-off-by: Robbie Ko <robbieko@synology.com>
> ---
>  fs/btrfs/extent_io.c | 146 +++++++++++++++++++++++++++++++++++++++++++=
++------
>  1 file changed, 131 insertions(+), 15 deletions(-)
>=20
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 066b6df..5c6dca9 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -4394,8 +4394,8 @@ static int emit_fiemap_extent(struct fiemap_exten=
t_info *fieinfo,
>  	 */
>  	if (cache->offset + cache->len  =3D=3D offset &&
>  	    cache->phys + cache->len =3D=3D phys  &&
> -	    (cache->flags & ~FIEMAP_EXTENT_LAST) =3D=3D
> -			(flags & ~FIEMAP_EXTENT_LAST)) {
> +		(cache->flags & ~(FIEMAP_EXTENT_LAST|FIEMAP_EXTENT_SHARED)) =3D=3D
> +			(flags & ~(FIEMAP_EXTENT_LAST|FIEMAP_EXTENT_SHARED))) {
>  		cache->len +=3D len;
>  		cache->flags |=3D flags;
>  		goto try_submit_last;
> @@ -4450,6 +4450,134 @@ static int emit_last_fiemap_cache(struct btrfs_=
fs_info *fs_info,
>  	return ret;
>  }
>=20
> +/*
> + * Helper to check the file range is shared.
> + *
> + * Fiemap extent will be combined with many extents, so we need to exa=
mine
> + * each extent, and if shared, the results are shared.
> + *
> + * Return: 0 if file range is not shared, 1 if it is shared, < 0 on er=
ror.
> + */
> +static int extent_map_check_shared(struct inode *inode, u64 start, u64=
 end)
> +{
> +	struct btrfs_fs_info *fs_info =3D btrfs_sb(inode->i_sb);
> +	struct btrfs_root *root =3D BTRFS_I(inode)->root;
> +	int ret =3D 0;
> +	struct extent_buffer *leaf;
> +	struct btrfs_path *path;
> +	struct btrfs_file_extent_item *fi;
> +	struct btrfs_key found_key;
> +	int check_prev =3D 1;
> +	int extent_type;
> +	int shared =3D 0;
> +	u64 cur_offset;
> +	u64 extent_end;
> +	u64 ino =3D btrfs_ino(BTRFS_I(inode));
> +	u64 disk_bytenr;
> +
> +	path =3D btrfs_alloc_path();
> +	if (!path) {
> +		return -ENOMEM;
> +	}
> +
> +	cur_offset =3D start;
> +	while (1) {
> +		ret =3D btrfs_lookup_file_extent(NULL, root, path, ino,
> +					       cur_offset, 0);
> +		if (ret < 0)
> +			goto error;
> +		if (ret > 0 && path->slots[0] > 0 && check_prev) {
> +			leaf =3D path->nodes[0];
> +			btrfs_item_key_to_cpu(leaf, &found_key,
> +					      path->slots[0] - 1);
> +			if (found_key.objectid =3D=3D ino &&
> +			    found_key.type =3D=3D BTRFS_EXTENT_DATA_KEY)
> +				path->slots[0]--;
> +		}
> +		check_prev =3D 0;
> +next_slot:
> +		leaf =3D path->nodes[0];
> +		if (path->slots[0] >=3D btrfs_header_nritems(leaf)) {
> +			ret =3D btrfs_next_leaf(root, path);
> +			if (ret < 0)
> +				goto error;
> +			if (ret > 0)
> +				break;
> +			leaf =3D path->nodes[0];
> +		}
> +
> +		disk_bytenr =3D 0;
> +		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
> +
> +		if (found_key.objectid > ino)
> +			break;
> +		if (WARN_ON_ONCE(found_key.objectid < ino) ||
> +		    found_key.type < BTRFS_EXTENT_DATA_KEY) {
> +			path->slots[0]++;
> +			goto next_slot;
> +		}
> +		if (found_key.type > BTRFS_EXTENT_DATA_KEY ||
> +		    found_key.offset > end)
> +			break;
> +
> +		fi =3D btrfs_item_ptr(leaf, path->slots[0],
> +				    struct btrfs_file_extent_item);
> +		extent_type =3D btrfs_file_extent_type(leaf, fi);
> +
> +		if (extent_type =3D=3D BTRFS_FILE_EXTENT_REG ||
> +		    extent_type =3D=3D BTRFS_FILE_EXTENT_PREALLOC) {
> +			disk_bytenr =3D btrfs_file_extent_disk_bytenr(leaf, fi);
> +			extent_end =3D found_key.offset +
> +				btrfs_file_extent_num_bytes(leaf, fi);
> +			if (extent_end <=3D start) {
> +				path->slots[0]++;
> +				goto next_slot;
> +			}
> +			if (disk_bytenr =3D=3D 0) {
> +				path->slots[0]++;
> +				goto next_slot;
> +			}
> +
> +			btrfs_release_path(path);
> +
> +			/*
> +			 * As btrfs supports shared space, this information
> +			 * can be exported to userspace tools via
> +			 * flag FIEMAP_EXTENT_SHARED.  If fi_extents_max =3D=3D 0
> +			 * then we're just getting a count and we can skip the
> +			 * lookup stuff.
> +			 */
> +			ret =3D btrfs_check_shared(root,
> +						 ino, disk_bytenr);
> +			if (ret < 0)
> +				goto error;
> +			if (ret)
> +				shared =3D 1;
> +			ret =3D 0;
> +			if (shared) {
> +				break;
> +			}
> +		} else if (extent_type =3D=3D BTRFS_FILE_EXTENT_INLINE) {
> +			extent_end =3D found_key.offset +
> +				btrfs_file_extent_inline_len(leaf,
> +						     path->slots[0], fi);
> +			extent_end =3D ALIGN(extent_end, fs_info->sectorsize);
> +			path->slots[0]++;
> +			goto next_slot;
> +		} else {
> +			BUG_ON(1);
> +		}
> +		cur_offset =3D extent_end;
> +		if (cur_offset > end)
> +			break;
> +	}
> +
> +	ret =3D 0;
> +error:
> +	btrfs_free_path(path);
> +	return !ret ? shared : ret;
> +}
> +
>  int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fiei=
nfo,
>  		__u64 start, __u64 len, get_extent_t *get_extent)
>  {
> @@ -4587,19 +4715,7 @@ int extent_fiemap(struct inode *inode, struct fi=
emap_extent_info *fieinfo,
>  			flags |=3D (FIEMAP_EXTENT_DELALLOC |
>  				  FIEMAP_EXTENT_UNKNOWN);
>  		} else if (fieinfo->fi_extents_max) {
> -			u64 bytenr =3D em->block_start -
> -				(em->start - em->orig_start);
> -
> -			/*
> -			 * As btrfs supports shared space, this information
> -			 * can be exported to userspace tools via
> -			 * flag FIEMAP_EXTENT_SHARED.  If fi_extents_max =3D=3D 0
> -			 * then we're just getting a count and we can skip the
> -			 * lookup stuff.
> -			 */
> -			ret =3D btrfs_check_shared(root,
> -						 btrfs_ino(BTRFS_I(inode)),
> -						 bytenr);

Since we're going to use the whole extent to determine the SHARED flags,
what about just passing the extent bytenr into btrfs_check_shared?

In that case I think we could get correct shared flag without using
another helper function.
(IIRC it's em->block_start)

Thanks,
Qu

> +			ret =3D extent_map_check_shared(inode, em->start, extent_map_end(em=
) - 1);
>  			if (ret < 0)
>  				goto out_free;
>  			if (ret)
> --
> 1.9.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--Gnjj7pnqV6cTUfQW46OL8g2ZbAIJQLRsE--

--tUfSnLRoKaFqS4ef83oJG9DdE6mD97kMj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqfv+EXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgjfAgAh+H+ctpaIopnbGNmZxjb0d9H
+Gk4+gxnsms850sMnrdhMDGH3wIjLBcuSboUPdBZ5fQ2LDcH4CMR31utPc5DSyWB
VovQ26uctoBuuskc4M8Tuf3eArRhRFkq4FHCS//QFw9VmjyB4NN9EGThsD2jVqs5
kzUBm4p9nsbdUisA8jwwVmeH8/FjCHaObtl1V+10XVsa+/aYB3QWXIwei2xBKEFZ
5t56NeRDqMlHrM/LreBrdO2qPQgdn2utXznWfpganu++tNBkta939RLRZtivSHAG
hH2/ztq+1vWLPqv21FLlm3dpsrN8Iayf4yhnQJlDTl14yYWnxcZRX9sgrp71rw==
=ewlT
-----END PGP SIGNATURE-----

--tUfSnLRoKaFqS4ef83oJG9DdE6mD97kMj--
