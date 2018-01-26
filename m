Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:64106 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752918AbeAZJgm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 04:36:42 -0500
Subject: Re: [PATCH 05/15] btrfs-progs: lowmem check: let check_dir_item()
 continue if find wrong inode_item
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
 <20180126083519.28373-6-suy.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <2db3f205-5969-98fd-32b8-1c8e68b89eb9@gmx.com>
Date: Fri, 26 Jan 2018 17:36:34 +0800
MIME-Version: 1.0
In-Reply-To: <20180126083519.28373-6-suy.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="wg75knC3plBk42bDCFCd0b6Q4LdBkfiwX"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wg75knC3plBk42bDCFCd0b6Q4LdBkfiwX
Content-Type: multipart/mixed; boundary="DBxelXm3dN6IupdU6IaBzJfGYFDBYwxqx";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <2db3f205-5969-98fd-32b8-1c8e68b89eb9@gmx.com>
Subject: Re: [PATCH 05/15] btrfs-progs: lowmem check: let check_dir_item()
 continue if find wrong inode_item
References: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
 <20180126083519.28373-6-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180126083519.28373-6-suy.fnst@cn.fujitsu.com>

--DBxelXm3dN6IupdU6IaBzJfGYFDBYwxqx
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8826=E6=97=A5 16:35, Su Yue wrote:
> check_dir_item can handle missed/mismatched inode item well.
> Let it continue to check corresponding dir_item/index and inode_ref.
>=20
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  cmds-check.c | 15 ++++++---------
>  1 file changed, 6 insertions(+), 9 deletions(-)
>=20
> diff --git a/cmds-check.c b/cmds-check.c
> index e33dd7db0048..eb65a18fe64b 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -5984,15 +5984,12 @@ begin:
>  		ret =3D btrfs_search_slot(NULL, root, &location, path, 0, 0);
>  		if (ret) {
>  			tmp_err |=3D INODE_ITEM_MISSING;
> -			goto next;
> -		}
> -
> -		ii =3D btrfs_item_ptr(path->nodes[0], path->slots[0],
> -				    struct btrfs_inode_item);
> -		mode =3D btrfs_inode_mode(path->nodes[0], ii);
> -		if (imode_to_type(mode) !=3D filetype) {
> -			tmp_err |=3D INODE_ITEM_MISMATCH;
> -			goto next;
> +		} else {
> +			ii =3D btrfs_item_ptr(path->nodes[0], path->slots[0],
> +					    struct btrfs_inode_item);
> +			mode =3D btrfs_inode_mode(path->nodes[0], ii);
> +			if (imode_to_type(mode) !=3D filetype)
> +				tmp_err |=3D INODE_ITEM_MISMATCH;
>  		}
> =20
>  		/* Check relative INODE_REF/INODE_EXTREF */
>=20


--DBxelXm3dN6IupdU6IaBzJfGYFDBYwxqx--

--wg75knC3plBk42bDCFCd0b6Q4LdBkfiwX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpq9qIXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qiNXQf/UpDW7KaOrVSsyaBc19H3sUt4
aGzbHRbKY34oiJL3IjkgyBQSyBk5vqXr+Tp6bIFSrJA//7WvDxzwnrGdgpdmVpoO
Z4F6lejArLXmQXd2bIB2B1xztabhbxDRxkOKLde+xCjacQzZ+2n1iTEyYLEgGVQg
J3f8pCOfNFaXD+btiDO9/tiCXHoEzObInPu2OkOq6aTWuMPAVUpGlk2SPZs12IqE
k3c6U2YcJWux2Ct0y3eRLT3MTwKeJXqOpxzr5hl9DddvwD0b0/VSB143TJvVFITw
/tolKcZiI6jg0vQjwjzpdS4nvCCRM5yEvgN+dKBFVhUliOtCdooYgN8rfwwdYA==
=bCXY
-----END PGP SIGNATURE-----

--wg75knC3plBk42bDCFCd0b6Q4LdBkfiwX--
