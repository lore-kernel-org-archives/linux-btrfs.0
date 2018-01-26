Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:49237 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751852AbeAZKLI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 05:11:08 -0500
Subject: Re: [PATCH 13/15] btrfs-progs: check: find inode filetype in
 create_inode_item()
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
 <20180126083519.28373-14-suy.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <58ab5c56-62cf-ae11-c1eb-0383820936e6@gmx.com>
Date: Fri, 26 Jan 2018 18:11:01 +0800
MIME-Version: 1.0
In-Reply-To: <20180126083519.28373-14-suy.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="C5kkuxaJ3wqh9WMjYFoBDZWYFKnaCNYp1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--C5kkuxaJ3wqh9WMjYFoBDZWYFKnaCNYp1
Content-Type: multipart/mixed; boundary="OH1cC6i8XFhqIatc7PoVKiUdnNvplBGYu";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <58ab5c56-62cf-ae11-c1eb-0383820936e6@gmx.com>
Subject: Re: [PATCH 13/15] btrfs-progs: check: find inode filetype in
 create_inode_item()
References: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
 <20180126083519.28373-14-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180126083519.28373-14-suy.fnst@cn.fujitsu.com>

--OH1cC6i8XFhqIatc7PoVKiUdnNvplBGYu
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8826=E6=97=A5 16:35, Su Yue wrote:
> Now, find_file_type() doesn't return 0 if mismatched filetype is in a
> backref.
>=20
> Let create_inode_item() first call find_file_type() to get filetype.
> If it failed, then guess filetype.
>=20
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>  cmds-check.c | 29 ++++++++++++++++++++++-------
>  1 file changed, 22 insertions(+), 7 deletions(-)
>=20
> diff --git a/cmds-check.c b/cmds-check.c
> index a83f0a92f48b..6091c7ef3442 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -3140,6 +3140,8 @@ static int create_inode_item_lowmem(struct btrfs_=
trans_handle *trans,
>  	return __create_inode_item(trans, root, ino, 0, 0, 0, mode);
>  }
> =20
> +static u32 btrfs_type_to_imode(u8 type);
> +static int find_file_type(struct inode_record *rec, u8 *type);

Nice to see code shared between original and lowmem mode.

>  static int create_inode_item(struct btrfs_root *root,
>  			     struct inode_record *rec, int root_dir)
>  {
> @@ -3148,14 +3150,19 @@ static int create_inode_item(struct btrfs_root =
*root,
>  	u32 mode =3D 0;
>  	u64 size =3D 0;
>  	int ret;
> +	u8 type =3D 0;
> =20
> -	trans =3D btrfs_start_transaction(root, 1);
> -	if (IS_ERR(trans)) {
> -		ret =3D PTR_ERR(trans);
> -		return ret;
> +	nlink =3D root_dir ? 1 : rec->found_link;
> +	ret =3D find_file_type(rec, &type);
> +	if (!ret) {
> +		mode =3D btrfs_type_to_imode(type) | 0755;
> +		if (type =3D=3D BTRFS_FT_REG_FILE)
> +			size =3D rec->found_size;
> +		else
> +			size =3D rec->extent_end;
> +		goto create_inode;
>  	}

Just a nicpick, here we could use simple if else branch to avoid extra ta=
g:

if (!ret) {
    ...
} else if (rec->found_dir_item) {
    ...
} else if (!rec->found_dir_item) {
    ...
}

Despite that, feel free to add my tag:

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> =20
> -	nlink =3D root_dir ? 1 : rec->found_link;
>  	if (rec->found_dir_item) {
>  		if (rec->found_file_extent)
>  			fprintf(stderr, "root %llu inode %llu has both a dir "
> @@ -3167,7 +3174,14 @@ static int create_inode_item(struct btrfs_root *=
root,
>  		size =3D rec->found_size;
>  	} else if (!rec->found_dir_item) {
>  		size =3D rec->extent_end;
> -		mode =3D  S_IFREG | 0755;
> +		mode =3D S_IFREG | 0755;
> +	}
> +
> +create_inode:
> +	trans =3D btrfs_start_transaction(root, 1);
> +	if (IS_ERR(trans)) {
> +		ret =3D PTR_ERR(trans);
> +		return ret;
>  	}
> =20
>  	ret =3D __create_inode_item(trans, root, rec->ino, size, rec->nbytes,=

> @@ -3307,7 +3321,8 @@ static int find_file_type(struct inode_record *re=
c, u8 *type)
>  	}
> =20
>  	list_for_each_entry(backref, &rec->backrefs, list) {
> -		if (backref->found_dir_index || backref->found_dir_item) {
> +		if ((backref->found_dir_index || backref->found_dir_item) &&
> +		    (!(backref->errors & REF_ERR_FILETYPE_UNMATCH))) {
>  			*type =3D backref->filetype;
>  			return 0;
>  		}
>=20


--OH1cC6i8XFhqIatc7PoVKiUdnNvplBGYu--

--C5kkuxaJ3wqh9WMjYFoBDZWYFKnaCNYp1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpq/rYXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qg52Qf+K0Qw4QZ0lu/Q3WY5izDz+3Sa
z1rHHBj50bIR0WFbXPujXNvPYIWv/ca40FgD31xvRsMxkUaSkpAfkviUJsjiwExD
BTxM3t5MhRRGikLKX7FTzG/oNh6enf2NZZMJNBmkT+V+tmwr+v3EQncvb0I8KDyj
GBxvNT4Xsar44QbudYgPfYWdc3cv1hN8ll9Bo39EOx6O7ouE2rKTggc1rvNHPt5/
c9i94zAZ4KABLl4UhEDID9Ai95gJJHAy6VfZvEs0TBQnxSEIeF5NCLa7lS5JPEdt
fe+9F23yS2/2od35XJh0sCeFhapI3tzXtuu7KasiihvF58CQMZNnAFhIL2fXFQ==
=J8Wj
-----END PGP SIGNATURE-----

--C5kkuxaJ3wqh9WMjYFoBDZWYFKnaCNYp1--
