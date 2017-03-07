Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50298 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755787AbdCGTV0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Mar 2017 14:21:26 -0500
Subject: Re: [PATCH 3/9] btrfs: qgroup: Fix qgroup corruption caused by
 inode_cache mount option
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.com, clm@fb.com
References: <20170227071039.8335-1-quwenruo@cn.fujitsu.com>
 <20170227071039.8335-4-quwenruo@cn.fujitsu.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <b9217275-263f-7a72-8194-3a4f3d72c804@suse.com>
Date: Tue, 7 Mar 2017 14:21:05 -0500
MIME-Version: 1.0
In-Reply-To: <20170227071039.8335-4-quwenruo@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5W5LOiUv8PAQrFmjFHgLXMN1A67ik7Egx"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5W5LOiUv8PAQrFmjFHgLXMN1A67ik7Egx
Content-Type: multipart/mixed; boundary="Mm2X6facICcOsOOlF0K1nHD6COlS3w37P";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
 dsterba@suse.com, clm@fb.com
Message-ID: <b9217275-263f-7a72-8194-3a4f3d72c804@suse.com>
Subject: Re: [PATCH 3/9] btrfs: qgroup: Fix qgroup corruption caused by
 inode_cache mount option
References: <20170227071039.8335-1-quwenruo@cn.fujitsu.com>
 <20170227071039.8335-4-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170227071039.8335-4-quwenruo@cn.fujitsu.com>

--Mm2X6facICcOsOOlF0K1nHD6COlS3w37P
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2/27/17 2:10 AM, Qu Wenruo wrote:
> [BUG]
> The easist way to reproduce the bug is:
> ------
>  # mkfs.btrfs -f $dev -n 16K
>  # mount $dev $mnt -o inode_cache
>  # btrfs quota enable $mnt
>  # btrfs quota rescan -w $mnt
>  # btrfs qgroup show $mnt
> qgroupid         rfer         excl
> --------         ----         ----
> 0/5          32.00KiB     32.00KiB
>              ^^ Twice the correct value
> ------
>=20
> And fstests/btrfs qgroup test group can easily detect them with
> inode_cache mount option.
> Although some of them are false alerts since old test cases are using
> fixed golden output.
> While new test cases will use "btrfs check" to detect qgroup mismatch.
>=20
> [CAUSE]
> Inode_cache mount option will make commit_fs_roots() to call
> btrfs_save_ino_cache() to update fs/subvol trees, and generate new
> delayed refs.
>=20
> However we call btrfs_qgroup_prepare_account_extents() too early, befor=
e
> commit_fs_roots().
> This makes the "old_roots" for newly generated extents are always NULL.=

> For freeing extent case, this makes both new_roots and old_roots to be
> empty, while correct old_roots should not be empty.
> This causing qgroup numbers not decreased correctly.
>=20
> [FIX]
> Modify the timing of calling btrfs_qgroup_prepare_account_extents() to
> just before btrfs_qgroup_account_extents(), and add needed delayed_refs=

> handler.
> So qgroup can handle inode_map mount options correctly.
>=20
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Could we also fix this by excepting the free space inode from qgroups?
It seems like this is something we'd want to do anyway unless we want to
handle EDQUOT there too.

-Jeff

> ---
>  fs/btrfs/transaction.c | 25 ++++++++++++++++++-------
>  1 file changed, 18 insertions(+), 7 deletions(-)
>=20
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 6b3e0fc2fe7a..1ff3ec797356 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -2130,13 +2130,6 @@ int btrfs_commit_transaction(struct btrfs_trans_=
handle *trans)
>  		goto scrub_continue;
>  	}
> =20
> -	/* Reocrd old roots for later qgroup accounting */
> -	ret =3D btrfs_qgroup_prepare_account_extents(trans, fs_info);
> -	if (ret) {
> -		mutex_unlock(&fs_info->reloc_mutex);
> -		goto scrub_continue;
> -	}
> -
>  	/*
>  	 * make sure none of the code above managed to slip in a
>  	 * delayed item
> @@ -2179,6 +2172,24 @@ int btrfs_commit_transaction(struct btrfs_trans_=
handle *trans)
>  	btrfs_free_log_root_tree(trans, fs_info);
> =20
>  	/*
> +	 * commit_fs_roots() can call btrfs_save_ino_cache(), which generates=

> +	 * new delayed refs. Must handle them or qgroup can be wrong.
> +	 */
> +	ret =3D btrfs_run_delayed_refs(trans, fs_info, (unsigned long)-1);
> +	if (ret) {
> +		mutex_unlock(&fs_info->tree_log_mutex);
> +		mutex_unlock(&fs_info->reloc_mutex);
> +		goto scrub_continue;
> +	}
> +
> +	ret =3D btrfs_qgroup_prepare_account_extents(trans, fs_info);
> +	if (ret) {
> +		mutex_unlock(&fs_info->tree_log_mutex);
> +		mutex_unlock(&fs_info->reloc_mutex);
> +		goto scrub_continue;
> +	}
> +
> +	/*
>  	 * Since fs roots are all committed, we can get a quite accurate
>  	 * new_roots. So let's do quota accounting.
>  	 */
>=20


--=20
Jeff Mahoney
SUSE Labs


--Mm2X6facICcOsOOlF0K1nHD6COlS3w37P--

--5W5LOiUv8PAQrFmjFHgLXMN1A67ik7Egx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWL8IIR57S2MheeWyAQigjQ/5AfXBEnyenbW7JgBqxfQnu8PTFPPLpNNT
cLpSueH5xaSGCjmDnD32vnHSpaO1NCrK+JDiAXD1z40PFWhzkJa4O3C7+izbcvVS
xHp9tYNzxSIH7XmDkLwv43cRUZjlJ0kkv1OrYKQylonKHGQQzrQIfRJ0Ld3XqMOx
PdXWnh3uxM9grFbnB+JWujgJSE1eXzuLlvhBfr1dc2yTpPR/8KICIJLei3xPtCQx
GJ4y5ANC/2kpj0fYijKRHoBZKZZPmLGUlBYm2IRvKvNoovjO9WOYk8pJHBnWYnR/
/mG9zQu/GHykcgKFFkJ8ppEviRImq2KXI5hQI0YwhLmDVyIWznqpSHPaMQrF+Jfh
LCItqjwQ2Fd11CemjCRE+pN0TP9aW53IwBmMccMCr5BfdEelHM4tMNuCeVB92OxP
zshnpnAwKrACpQ/FkY7EypXAKl6cXU7w5V4w1JOsywPB1ZAbLf5mqDU4ZO4M8c//
ctD5VHmNQhDhmwl+QFU2U1G3COGqCVO7nZOqQPIk4STFKXsGRZ55O/Jnev0UM3oC
RtdKXZadvikM6MwQohMlQqBJ1U8zRHWSqdKVMre1VzXvfvNpwNhdb2Fe3HLSKPqp
i69udvFvizer8KKE6IP7tefxrC05zYWFoU3K8QCBz8d3mQ0vrAlNsC0FxAioPaBq
kMLDWXItdIw=
=DZa4
-----END PGP SIGNATURE-----

--5W5LOiUv8PAQrFmjFHgLXMN1A67ik7Egx--
