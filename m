Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:55098 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933724AbdLRJrQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Dec 2017 04:47:16 -0500
Subject: Re: [PATCH] btrfs: factor btrfs_check_rw_degradable() to check given
 device
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20171218090859.8141-1-anand.jain@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <00433e34-a56e-3898-80b9-32a304fe32e2@gmx.com>
Date: Mon, 18 Dec 2017 17:46:59 +0800
MIME-Version: 1.0
In-Reply-To: <20171218090859.8141-1-anand.jain@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="lpgsJrSnSDC1qVh4CVsLCgcXoiAwfQJwt"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lpgsJrSnSDC1qVh4CVsLCgcXoiAwfQJwt
Content-Type: multipart/mixed; boundary="7nRqdCm09Bvt6vQv9kHRTi07Cat0TEtSN";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Message-ID: <00433e34-a56e-3898-80b9-32a304fe32e2@gmx.com>
Subject: Re: [PATCH] btrfs: factor btrfs_check_rw_degradable() to check given
 device
References: <20171218090859.8141-1-anand.jain@oracle.com>
In-Reply-To: <20171218090859.8141-1-anand.jain@oracle.com>

--7nRqdCm09Bvt6vQv9kHRTi07Cat0TEtSN
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8818=E6=97=A5 17:08, Anand Jain wrote:
> Update btrfs_check_rw_degradable() to check against the given
> device if its lost.
>=20
> We can use this function to know if the volume is going to be
> in degraded mode OR failed state, when the given device fails.
> Which is needed when we are handling the device failed state.
>=20
> A preparatory patch does not affect the flow as such.
>=20
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Looks good.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  fs/btrfs/disk-io.c | 4 ++--
>  fs/btrfs/super.c   | 2 +-
>  fs/btrfs/volumes.c | 8 ++++++--
>  fs/btrfs/volumes.h | 4 ++--
>  4 files changed, 11 insertions(+), 7 deletions(-)
>=20
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 55bc6c846671..5604f5e1873e 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2904,7 +2904,7 @@ int open_ctree(struct super_block *sb,
>  		goto fail_sysfs;
>  	}
> =20
> -	if (!sb_rdonly(sb) && !btrfs_check_rw_degradable(fs_info)) {
> +	if (!sb_rdonly(sb) && !btrfs_check_rw_degradable(fs_info, NULL)) {
>  		btrfs_warn(fs_info,
>  		"writeable mount is not allowed due to too many missing devices");
>  		goto fail_sysfs;
> @@ -3423,7 +3423,7 @@ static blk_status_t wait_dev_flush(struct btrfs_d=
evice *device)
> =20
>  static int check_barrier_error(struct btrfs_fs_info *fs_info)
>  {
> -	if (!btrfs_check_rw_degradable(fs_info))
> +	if (!btrfs_check_rw_degradable(fs_info, NULL))
>  		return -EIO;
>  	return 0;
>  }
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index f8129ebad963..cb6d62cf83ec 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1855,7 +1855,7 @@ static int btrfs_remount(struct super_block *sb, =
int *flags, char *data)
>  			goto restore;
>  		}
> =20
> -		if (!btrfs_check_rw_degradable(fs_info)) {
> +		if (!btrfs_check_rw_degradable(fs_info, NULL)) {
>  			btrfs_warn(fs_info,
>  				"too many missing devices, writeable remount is not allowed");
>  			ret =3D -EACCES;
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index b881fc2b2225..9c4868d6fd9a 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -6923,7 +6923,8 @@ int btrfs_read_sys_array(struct btrfs_fs_info *fs=
_info)
>   * Return true if all chunks meet the minimal RW mount requirements.
>   * Return false if any chunk doesn't meet the minimal RW mount require=
ments.
>   */
> -bool btrfs_check_rw_degradable(struct btrfs_fs_info *fs_info)
> +bool btrfs_check_rw_degradable(struct btrfs_fs_info *fs_info,
> +					struct btrfs_device *failing_dev)
>  {
>  	struct btrfs_mapping_tree *map_tree =3D &fs_info->mapping_tree;
>  	struct extent_map *em;
> @@ -6955,9 +6956,12 @@ bool btrfs_check_rw_degradable(struct btrfs_fs_i=
nfo *fs_info)
>  			    test_bit(BTRFS_DEV_STATE_MISSING, &dev->dev_state) ||
>  			    dev->last_flush_error)
>  				missing++;
> +			else if (failing_dev && failing_dev =3D=3D dev)
> +				missing++;
>  		}
>  		if (missing > max_tolerated) {
> -			btrfs_warn(fs_info,
> +			if (!failing_dev)
> +				btrfs_warn(fs_info,
>  	"chunk %llu missing %d devices, max tolerance is %d for writeable mou=
nt",
>  				   em->start, missing, max_tolerated);
>  			free_extent_map(em);
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index c7484da44ca4..e707fb39b2d4 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -555,7 +555,7 @@ void btrfs_update_commit_device_bytes_used(struct b=
trfs_fs_info *fs_info,
>  struct list_head *btrfs_get_fs_uuids(void);
>  void btrfs_set_fs_info_ptr(struct btrfs_fs_info *fs_info);
>  void btrfs_reset_fs_info_ptr(struct btrfs_fs_info *fs_info);
> -
> -bool btrfs_check_rw_degradable(struct btrfs_fs_info *fs_info);
> +bool btrfs_check_rw_degradable(struct btrfs_fs_info *fs_info,
> +					struct btrfs_device *failing_dev);
> =20
>  #endif
>=20


--7nRqdCm09Bvt6vQv9kHRTi07Cat0TEtSN--

--lpgsJrSnSDC1qVh4CVsLCgcXoiAwfQJwt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlo3jpMXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjIqQf/TjEUyX4CTLUHAM+PvjgE9Wzd
CzzOBJwJgpmM9rISdo+4irfg9ZqvjCA2/nP/sqKv07PwsjIxwWc7FTn1TsA9puWt
T6xTeGprBJ05p4ZfF7B6DZoI2Bb6doFThteL9vheJ3ZU6hoVig2oB9cIaZB6aion
jwXrKyRQeiwxMzbvjjXoVaeHNvyrb++rFSaFMpQmRurHytQOosNYANQuUY30rnzb
690flzEEFDmfLMuzScYiYn3felp+105V6U2c1j5U/uX0Nf6cROHRr1AxIIolmyo0
GhQF0vjw2YEN0I/FjSKKBQnodSD1he+ynUyxHeofZ4A7SXgAhR11k9sUQKeZPA==
=iIJn
-----END PGP SIGNATURE-----

--lpgsJrSnSDC1qVh4CVsLCgcXoiAwfQJwt--
