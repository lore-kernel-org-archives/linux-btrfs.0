Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:51316 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752312AbeAKBOj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Jan 2018 20:14:39 -0500
Subject: Re: [PATCH] btrfs: tree-check: reduce stack consumption in
 check_dir_item
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc: wqu@suse.com
References: <20180110142851.27624-1-dsterba@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <52c544df-b1d7-4c6e-3069-374f55fe9c4e@gmx.com>
Date: Thu, 11 Jan 2018 09:14:26 +0800
MIME-Version: 1.0
In-Reply-To: <20180110142851.27624-1-dsterba@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="HPSRZWoZetsHXGODjti171hIWGfN6dNGv"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HPSRZWoZetsHXGODjti171hIWGfN6dNGv
Content-Type: multipart/mixed; boundary="3q1our2Lrol5vTsCp9LbKA0jZFJLqgUYs";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc: wqu@suse.com
Message-ID: <52c544df-b1d7-4c6e-3069-374f55fe9c4e@gmx.com>
Subject: Re: [PATCH] btrfs: tree-check: reduce stack consumption in
 check_dir_item
References: <20180110142851.27624-1-dsterba@suse.com>
In-Reply-To: <20180110142851.27624-1-dsterba@suse.com>

--3q1our2Lrol5vTsCp9LbKA0jZFJLqgUYs
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8810=E6=97=A5 22:28, David Sterba wrote:
> I've noticed that the updated item checker stack consumption increased
> dramatically in 542f5385e20cf97447 ("btrfs: tree-checker: Add checker
> for dir item")
>=20
> tree-checker.c:check_leaf                    +552 (176 -> 728)
>=20
> The array is 255 bytes long, dynamic allocation would slow down the
> sanity checks so it's more reasonable to keep it on-stack. Moving the
> variable to the scope of use reduces the stack usage again
>=20
> tree-checker.c:check_leaf                    -264 (728 -> 464)
>=20
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  fs/btrfs/tree-checker.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index 7c55e3ba5a6c..c3c8d48f6618 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -259,7 +259,6 @@ static int check_dir_item(struct btrfs_root *root,
> =20
>  	di =3D btrfs_item_ptr(leaf, slot, struct btrfs_dir_item);
>  	while (cur < item_size) {
> -		char namebuf[max(BTRFS_NAME_LEN, XATTR_NAME_MAX)];
>  		u32 name_len;
>  		u32 data_len;
>  		u32 max_name_len;
> @@ -342,6 +341,8 @@ static int check_dir_item(struct btrfs_root *root,
>  		 */
>  		if (key->type =3D=3D BTRFS_DIR_ITEM_KEY ||
>  		    key->type =3D=3D BTRFS_XATTR_ITEM_KEY) {
> +			char namebuf[max(BTRFS_NAME_LEN, XATTR_NAME_MAX)];
> +
>  			read_extent_buffer(leaf, namebuf,
>  					(unsigned long)(di + 1), name_len);
>  			name_hash =3D btrfs_name_hash(namebuf, name_len);
>=20


--3q1our2Lrol5vTsCp9LbKA0jZFJLqgUYs--

--HPSRZWoZetsHXGODjti171hIWGfN6dNGv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpWunIXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qigKAf/YTNlYhvgOOo5g2uUKaWa8Wn/
pY4tsqRWDaudOem7SuFpqUo9GRIWlb8rD4kVtHUuIdySixrf8ZdPBRabXQhY34Sd
eoZJCXYiTGGtDHaM8UXSXptmDP2qT74IuvRWlKqSHuVt/AmkhvwXNxbF+cOdgs/t
7sdC7pAwS2CuQtFNdRhlDiRwpAOOnkIiyeH2Bs5rtBM6LXYQt/qLVX5B6VwiCG5A
B7bE8RzaOH44JtyCcKbqH8m7gSgC7OezBHJhq7WPMYa97eRbWEIKRdht5idgC+/r
uwDhEUV4rmFVW1OBGIxf0lBNXL8wmptb8ZeOMTN9ALzi+YikfvR6FkkiCqfqzw==
=b7mg
-----END PGP SIGNATURE-----

--HPSRZWoZetsHXGODjti171hIWGfN6dNGv--
