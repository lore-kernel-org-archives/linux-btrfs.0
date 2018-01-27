Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:53143 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751340AbeA0C0k (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 21:26:40 -0500
Subject: Re: [RFC PATCH] btrfs: Gracefully handle errors in
 btrfs_qgroup_trace_extent_post
To: Nikolay Borisov <nborisov@suse.com>, wqu@suse.com
Cc: linux-btrfs@vger.kernel.org
References: <1516976021-11935-1-git-send-email-nborisov@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <c2837c88-1f9b-54c8-347d-a2e5fe2658f1@gmx.com>
Date: Sat, 27 Jan 2018 10:26:26 +0800
MIME-Version: 1.0
In-Reply-To: <1516976021-11935-1-git-send-email-nborisov@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="rWBPKJp35vzQp0JfZgIA9Wq6KpgfQs7ZX"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rWBPKJp35vzQp0JfZgIA9Wq6KpgfQs7ZX
Content-Type: multipart/mixed; boundary="tQT8ztEaJD9eFyGC06YcvasKmrn1kt5UU";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, wqu@suse.com
Cc: linux-btrfs@vger.kernel.org
Message-ID: <c2837c88-1f9b-54c8-347d-a2e5fe2658f1@gmx.com>
Subject: Re: [RFC PATCH] btrfs: Gracefully handle errors in
 btrfs_qgroup_trace_extent_post
References: <1516976021-11935-1-git-send-email-nborisov@suse.com>
In-Reply-To: <1516976021-11935-1-git-send-email-nborisov@suse.com>

--tQT8ztEaJD9eFyGC06YcvasKmrn1kt5UU
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8826=E6=97=A5 22:13, Nikolay Borisov wrote:
> Running generic/019 with qgroups on the scratch device enabled is
> almost guaranteed to trigger the BUG_ON in btrfs_free_tree_block. It's
> supposed to trigger only on -ENOMEM, in reality, however, it's possible=

> to get -EIO from btrfs_qgroup_trace_extent_post. This function just
> finds the roots of the extent being tracked and sets the qrecord->old_r=
oots
> list. If this operation fails nothing critical happens except the
> quota accounting can be considered wrong. In such case just set the
> INCONSISTENT flag for the quota and be done with it.
>=20
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>=20
> Qu,=20
>=20
> This fixes the crash for me, however I'm not entirely sure it's really =
the=20
> best fix since it's leaking the usage of INCONSISTENT out of qgroup.c. =
Ideally
> I'd like to avoid this. Since you have more experience with qgroups and=
 also you
> introduced the extent tracking code in add_delayed_tree_ref how does=20
> look to you?=20
>=20
>=20
>  fs/btrfs/delayed-ref.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
> index a1a40cf382e3..1e9aa18cc0d8 100644
> --- a/fs/btrfs/delayed-ref.c
> +++ b/fs/btrfs/delayed-ref.c
> @@ -820,8 +820,13 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_inf=
o *fs_info,
>  			     num_bytes, parent, ref_root, level, action);
>  	spin_unlock(&delayed_refs->lock);
> =20
> -	if (qrecord_inserted)
> -		return btrfs_qgroup_trace_extent_post(fs_info, record);
> +	if (qrecord_inserted) {
> +		int ret =3D btrfs_qgroup_trace_extent_post(fs_info, record);

Since generic/019 is using make_fail_request, it can cause some tree
reads fail.

And since btrfs_qgroup_trace_extent_post() cause btrfs_find_all_roots()
to fill @old_roots for new extents, it will definitely read tree blocks,
and when its request failed, it returns -EIO as expected.

So yes, the qgroup code break the old assumption that
btrfs_add_delayed_tree|data_ref() could only return -ENOMEM.


But compared to delayed-ref, qgroup is not a critical payload (if
delayed-ref is screwed up, extent tree and possible data extent will be
corrupted, while qgroup failure only affects qgroup), so it's OK to keep
the old assumption.

> +		if (ret !=3D -ENOMEM)
Here we don't really need to handle ENOMEM specially.
Just check ( ret < 0 ) should be enough.

> +			fs_info->qgroup_flags |=3D BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;

And extra btrfs_warn() would help.

> +		else
> +			return -ENOMEM;

Since btrfs is not a critical payload compared to delayed ref, returning
0 should not be a problem as we have already marked qgroup inconsistent.
(With comment explaining why it's OK to return 0)

Thanks,
Qu

> +	}
>  	return 0;
> =20
>  free_head_ref:
>=20


--tQT8ztEaJD9eFyGC06YcvasKmrn1kt5UU--

--rWBPKJp35vzQp0JfZgIA9Wq6KpgfQs7ZX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpr41IXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhcZwf/Wy17NWge6qIvG5X5B2p4tTuY
6+4w01Gsr2O/GGktxPH/ibLOP56eNIVZ7aw27/DuxXSdXeJwUt6w5bbqy8QZeKvw
vgAMYOpUb3AjihYcd2oBOeIUSxUjL0NAV07y050ZQhr5yHuAOcJn/qepqICrLsPq
YByOyUKKHBGlPaqpJhgzrVr1gcjRysWKWF7GgHGf+V2bSNr1LB0E87KBIZrTVVkg
ab5ZfteucM73O/i1OeLrBYpiF8AuwclAuzCqJ31a9Z3lp9tiA5NcSwn8/5YvAh6t
nLdMAZ6Q3xnf9u0a4CDDF2G7u1HHKXMa5H2BEHA5BHC6hpUZtY23fnrCqZnpJg==
=13T3
-----END PGP SIGNATURE-----

--rWBPKJp35vzQp0JfZgIA9Wq6KpgfQs7ZX--
