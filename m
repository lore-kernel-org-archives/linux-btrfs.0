Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:61937 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751378AbeA2LJU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Jan 2018 06:09:20 -0500
Subject: Re: [PATCH v2] btrfs: Gracefully handle errors in
 btrfs_qgroup_trace_extent_post
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1517211848-13324-1-git-send-email-nborisov@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <67d1afde-c6f7-ea41-d9d4-35c5d0a1c136@gmx.com>
Date: Mon, 29 Jan 2018 19:09:06 +0800
MIME-Version: 1.0
In-Reply-To: <1517211848-13324-1-git-send-email-nborisov@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="wnChBisNdKBhZwdORZybuSlrd5DU3uNau"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wnChBisNdKBhZwdORZybuSlrd5DU3uNau
Content-Type: multipart/mixed; boundary="GbJNN92P32GaFZR8TGZEFmaVazRwv5YiN";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <67d1afde-c6f7-ea41-d9d4-35c5d0a1c136@gmx.com>
Subject: Re: [PATCH v2] btrfs: Gracefully handle errors in
 btrfs_qgroup_trace_extent_post
References: <1517211848-13324-1-git-send-email-nborisov@suse.com>
In-Reply-To: <1517211848-13324-1-git-send-email-nborisov@suse.com>

--GbJNN92P32GaFZR8TGZEFmaVazRwv5YiN
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8829=E6=97=A5 15:44, Nikolay Borisov wrote:
> Running generic/019 with qgroups on the scratch device enabled is
> almost guaranteed to trigger the BUG_ON in btrfs_free_tree_block. It's
> supposed to trigger only on -ENOMEM, in reality, however, it's possible=

> to get -EIO from btrfs_qgroup_trace_extent_post. This function just
> finds the roots of the extent being tracked and sets the qrecord->old_r=
oots
> list. If this operation fails nothing critical happens except the
> quota accounting can be considered wrong. In such case just set the
> INCONSISTENT flag for the quota and print a warning.
>=20
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>=20
> V2:=20
>  * Always print a warning if btrfs_qgroup_trace_extent_post fails=20
>  * Set quota inconsistent flag if btrfs_qgroup_trace_extent_post fails
>=20
>  fs/btrfs/delayed-ref.c | 7 +++++--
>  fs/btrfs/qgroup.c      | 6 ++++--
>  2 files changed, 9 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
> index a1a40cf382e3..5b2789a28a13 100644
> --- a/fs/btrfs/delayed-ref.c
> +++ b/fs/btrfs/delayed-ref.c
> @@ -820,8 +820,11 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_inf=
o *fs_info,
>  			     num_bytes, parent, ref_root, level, action);
>  	spin_unlock(&delayed_refs->lock);
> =20
> -	if (qrecord_inserted)
> -		return btrfs_qgroup_trace_extent_post(fs_info, record);
> +	if (qrecord_inserted) {
> +		int ret =3D btrfs_qgroup_trace_extent_post(fs_info, record);
> +		if (ret < 0)
> +			btrfs_warn(fs_info, "Error accounting new delayed refs extent (err =
code: %d). Quota inconsistent", ret);

Sorry that I didn't point it out in previous review, there are 2 callers
in delayed-ref.c using btrfs_qgroup_trace_extent_post().

One is the one you're fixing, and the other one is
btrfs_add_delayed_data_ref().

So it would be even better if the warning message can be integrated into
btrfs_qgroup_trace_extent_post().

Also btrfs_qgroup_trace_extent_post() also needs to ignore the return
value from btrfs_qgroup_trace_extent_post().

Thanks,
Qu

> +	}
>  	return 0;
> =20
>  free_head_ref:
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index b2ab5f795816..33f9dba44e92 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -1440,8 +1440,10 @@ int btrfs_qgroup_trace_extent_post(struct btrfs_=
fs_info *fs_info,
>  	int ret;
> =20
>  	ret =3D btrfs_find_all_roots(NULL, fs_info, bytenr, 0, &old_root, fal=
se);
> -	if (ret < 0)
> +	if (ret < 0) {
> +		fs_info->qgroup_flags |=3D BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
>  		return ret;
> +	}
> =20
>  	/*
>  	 * Here we don't need to get the lock of
> @@ -2933,7 +2935,7 @@ static int __btrfs_qgroup_release_data(struct ino=
de *inode,
>  	if (free && reserved)
>  		return qgroup_free_reserved_data(inode, reserved, start, len);
>  	extent_changeset_init(&changeset);
> -	ret =3D clear_record_extent_bits(&BTRFS_I(inode)->io_tree, start,=20
> +	ret =3D clear_record_extent_bits(&BTRFS_I(inode)->io_tree, start,
>  			start + len -1, EXTENT_QGROUP_RESERVED, &changeset);
>  	if (ret < 0)
>  		goto out;
>=20


--GbJNN92P32GaFZR8TGZEFmaVazRwv5YiN--

--wnChBisNdKBhZwdORZybuSlrd5DU3uNau
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpvANIXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qg9cAgApJaeCSmwGQgDgFZtg6nXStTC
keEkD6sJfSbk5xRYyfmTWGl5RRUh5kVE6IMzkgxLrfX9No7RHX5fTIgU+AeKI3y8
VYrKVSxvwCJlp+/gL8ioqlwFjcCQ5SqCL5rXHR4hBkRx5mHz5c2Qma+dc8Hakgi0
AgJOpCWgW4c8kblMQm0aVihmIf3AW4sz6u0kDbQ/EkiiT/Usk01iJyTwzw6lnObR
pQq6HLrZLPwVvxOG1ext50DamdJ8NAQE+nN5aOd/KAeW+Rkc4pkEdci6Feq9u8Fv
K2+4XVMAnNCgItnjgHHzREnBhhVERXKiH7tBiwYJ+rIhn/Tt07C8M77WlySr5w==
=UMbD
-----END PGP SIGNATURE-----

--wnChBisNdKBhZwdORZybuSlrd5DU3uNau--
