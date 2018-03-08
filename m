Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:43637 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755117AbeCHILV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Mar 2018 03:11:21 -0500
Subject: Re: [PATCH 2/3] btrfs-progs: check/lowmem: Fix false alert of data
 extent backref lost for snapshot
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180228101323.25442-1-lufq.fnst@cn.fujitsu.com>
 <20180228101323.25442-2-lufq.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <0f503ab2-70f0-6141-a85b-f4de19c2af18@gmx.com>
Date: Thu, 8 Mar 2018 16:11:07 +0800
MIME-Version: 1.0
In-Reply-To: <20180228101323.25442-2-lufq.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mOnB61G2kX6VVtlJq3toWOkKD7ZEgKgLR"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mOnB61G2kX6VVtlJq3toWOkKD7ZEgKgLR
Content-Type: multipart/mixed; boundary="6ejY9QYnDZENeNyS9pXvYmGsCQOZQIWhw";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <0f503ab2-70f0-6141-a85b-f4de19c2af18@gmx.com>
Subject: Re: [PATCH 2/3] btrfs-progs: check/lowmem: Fix false alert of data
 extent backref lost for snapshot
References: <20180228101323.25442-1-lufq.fnst@cn.fujitsu.com>
 <20180228101323.25442-2-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180228101323.25442-2-lufq.fnst@cn.fujitsu.com>

--6ejY9QYnDZENeNyS9pXvYmGsCQOZQIWhw
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8828=E6=97=A5 18:13, Lu Fengqi wrote:
> Btrfs lowmem check reports the following false alert:
> ------
> ERROR: file extent[267 2162688] root 256 owner 5 backref lost
> ------
>=20
> The file extent is in the leaf which is shared by file tree 256 and fs
> tree.
> ------
> leaf 30605312 items 46 free space 4353 generation 7 owner 5
> ......
>         item 45 key (267 EXTENT_DATA 2162688) itemoff 5503 itemsize 53
>                 generation 7 type 2 (prealloc)
>                 prealloc data disk byte 13631488 nr 65536
>                 prealloc data offset 32768 nr 32768
> ------
>=20
> And there is the corresponding extent_data_ref item in the extent tree.=

> ------
>         item 1 key (13631488 EXTENT_DATA_REF 1007496934287921081) itemo=
ff 15274 itemsize 28
>                 extent data backref root 5 objectid 267 offset 2129920 =
count 1
> ------
>=20
> The offset of EXTENT_DATA_REF which is the hash of the owner root objec=
tid,
> the inode number and the calculated offset (file offset - extent offset=
).
>=20
> What caused the false alert is the code mix up the owner root objectid =
and
> the file tree objectid.
>=20
> Fixes: b0d360b541f0 ("btrfs-progs: check: introduce function to check d=
ata backref in extent tree")
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Looks good.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  check/mode-lowmem.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
> index f37b1b2c1571..6f1ea8db341d 100644
> --- a/check/mode-lowmem.c
> +++ b/check/mode-lowmem.c
> @@ -2689,8 +2689,8 @@ static int check_extent_data_item(struct btrfs_ro=
ot *root,
>  		/* Didn't find inlined data backref, try EXTENT_DATA_REF_KEY */
>  		dbref_key.objectid =3D btrfs_file_extent_disk_bytenr(eb, fi);
>  		dbref_key.type =3D BTRFS_EXTENT_DATA_REF_KEY;
> -		dbref_key.offset =3D hash_extent_data_ref(root->objectid,
> -				fi_key.objectid, fi_key.offset - offset);
> +		dbref_key.offset =3D hash_extent_data_ref(owner, fi_key.objectid,
> +							fi_key.offset - offset);
> =20
>  		ret =3D btrfs_search_slot(NULL, root->fs_info->extent_root,
>  					&dbref_key, &path, 0, 0);
>=20


--6ejY9QYnDZENeNyS9pXvYmGsCQOZQIWhw--

--mOnB61G2kX6VVtlJq3toWOkKD7ZEgKgLR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqg8BsXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qg2Fgf/WH63Zo7Ugf7yw/AGGlWeX4bC
H2QM4nJtJJj2/wtzgrwvu1T5wa33s/E5YVDcISZMrpCSc9VwHHq7HUOsRGtfkoub
iGxXBg0Pqcv4oTOqubGOCpmDCgIwBCoI5M1dTQYW6M3ZyEerS4XOO2Zo1wkc7srX
z9R3QjAGnzJ/5eopZbylvMuoy4DBwcbuQlGQoJKH6hhvUkPxznWIRmhwI8j3Uk/d
ITsT6zwGxHwH0wvuKh51+G3xVZV7OB+Jq5EPr/6VDwuqnEE6wcgDkHcpI1WkN0HI
fRI9uaYDye81/H1ETgdj3JTcXkuJ205a/yb06Rx6lAt9xiZLXRHdSiGdnKgx3A==
=CQm3
-----END PGP SIGNATURE-----

--mOnB61G2kX6VVtlJq3toWOkKD7ZEgKgLR--
