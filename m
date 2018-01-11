Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:53318 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753729AbeAKCKf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Jan 2018 21:10:35 -0500
Subject: Re: [PATCH] btrfs: return 0 for success in
 btrfs_alloc_data_chunk_ondemand
To: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Cc: Josef Bacik <jbacik@fb.com>
References: <1515603334-21423-1-git-send-email-josef@toxicpanda.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <52a9ddd8-5637-4f66-42f5-dd3f943ab57a@gmx.com>
Date: Thu, 11 Jan 2018 10:10:23 +0800
MIME-Version: 1.0
In-Reply-To: <1515603334-21423-1-git-send-email-josef@toxicpanda.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WMK2ZGqqFfCXPLpZr8gAehG42vd8WRpYt"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WMK2ZGqqFfCXPLpZr8gAehG42vd8WRpYt
Content-Type: multipart/mixed; boundary="OuxzbXkBul09EOP9ZhhndyFaqqdZxxx4Z";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com
Cc: Josef Bacik <jbacik@fb.com>
Message-ID: <52a9ddd8-5637-4f66-42f5-dd3f943ab57a@gmx.com>
Subject: Re: [PATCH] btrfs: return 0 for success in
 btrfs_alloc_data_chunk_ondemand
References: <1515603334-21423-1-git-send-email-josef@toxicpanda.com>
In-Reply-To: <1515603334-21423-1-git-send-email-josef@toxicpanda.com>

--OuxzbXkBul09EOP9ZhhndyFaqqdZxxx4Z
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8811=E6=97=A5 00:55, Josef Bacik wrote:
> From: Josef Bacik <jbacik@fb.com>
>=20
> My delayed refs rsv patches uncovered a problem in
> btrfs_alloc_data_chunk_ondemand where we don't clear ret before
> returning, so we could have whatever left over value we had from trying=

> to do a chunk allocation or whatever that may have failed.  Since we
> know we've succeeded at this point just unconditionally return 0.  This=

> fixed the xfstests failures I was seeing with my delayed refs rsv
> patches.
>=20
> Signed-off-by: Josef Bacik <jbacik@fb.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

The branch to leave ret =3D 1 would be the "ret =3D do_chunk_alloc()" cal=
l,
which could return 1, and goes to final return.
So the fix is good.

Thanks,
Qu

> ---
>  fs/btrfs/extent-tree.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index dbae25d882de..33c9efbfc9a7 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -4387,8 +4387,7 @@ int btrfs_alloc_data_chunk_ondemand(struct btrfs_=
inode *inode, u64 bytes)
>  	trace_btrfs_space_reservation(fs_info, "space_info",
>  				      data_sinfo->flags, bytes, 1);
>  	spin_unlock(&data_sinfo->lock);
> -
> -	return ret;
> +	return 0;
>  }
> =20
>  int btrfs_check_data_free_space(struct inode *inode,
>=20


--OuxzbXkBul09EOP9ZhhndyFaqqdZxxx4Z--

--WMK2ZGqqFfCXPLpZr8gAehG42vd8WRpYt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpWx5AXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgcfAf/e5rLeaFH1qGoQDnpghRDj9Oe
UOCyXBF1pekTZmreefG7BFYMqEELcWBw/7OfM4VZyZXKluBqTgZrisXRR8Ai+0Lo
ms4/NDuvmFWHpypK4nPdXy9CRbtR/WhF7PA/rcgol1RCBpyo9VUDT+C1VB9e9QTG
XWcsOTJT0/av2jyYU+6JSxB9QiZxoryqIqqkDBRsmdrp7heg43NZEmoPp3Spil3H
6ycvr19TUxw+9jfyfR6mPJ+Y0eRz+YQktk/T5bmiZvwwIBF1Bge3PaQXn15wBUrK
otwlfN6g7b7SBKIaqxXnB07JR+uEqCWSUO95Dsrb/v6mXnuQ/yxmYBjF1Kwjew==
=lVh9
-----END PGP SIGNATURE-----

--WMK2ZGqqFfCXPLpZr8gAehG42vd8WRpYt--
