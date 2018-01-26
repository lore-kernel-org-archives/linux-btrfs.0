Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:53042 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751256AbeAZKF2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 05:05:28 -0500
Subject: Re: [PATCH 12/15] btrfs-progs: check: increase counter error in
 check_inode_recs()
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
 <20180126083519.28373-13-suy.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <4c3f7527-3120-2c49-2916-82139e23094f@gmx.com>
Date: Fri, 26 Jan 2018 18:05:21 +0800
MIME-Version: 1.0
In-Reply-To: <20180126083519.28373-13-suy.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="YQzA4oR3NfME7rmZSUWk6GyvgClAGeav5"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--YQzA4oR3NfME7rmZSUWk6GyvgClAGeav5
Content-Type: multipart/mixed; boundary="6l1ImqDBaxTNLXCRasMsEIiiDRHkeRqiA";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <4c3f7527-3120-2c49-2916-82139e23094f@gmx.com>
Subject: Re: [PATCH 12/15] btrfs-progs: check: increase counter error in
 check_inode_recs()
References: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
 <20180126083519.28373-13-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180126083519.28373-13-suy.fnst@cn.fujitsu.com>

--6l1ImqDBaxTNLXCRasMsEIiiDRHkeRqiA
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8826=E6=97=A5 16:35, Su Yue wrote:
> Counter @error decides return values of check_inode_recs().
>=20
> Previously, @error won't be incremented even repair_inode_recs() failed=
=2E
> It causes 'btrfs check --repair' prints some error information but
> returns 0.
>=20
> So, if root dir is missing and repair is disabled, @error should be
> incremented.
> And after repair_inode_recs(), increase @error if any errors in inodes
> and backrefs.
>=20
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  cmds-check.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/cmds-check.c b/cmds-check.c
> index b23a4493b12b..a83f0a92f48b 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -4137,6 +4137,7 @@ static int check_inode_recs(struct btrfs_root *ro=
ot,
>  			return -EAGAIN;
>  		}
> =20
> +		error++;
>  		fprintf(stderr, "root %llu root dir %llu not found\n",
>  			(unsigned long long)root->root_key.objectid,
>  			(unsigned long long)root_dirid);
> @@ -4176,10 +4177,9 @@ static int check_inode_recs(struct btrfs_root *r=
oot,
>  				free_inode_rec(rec);
>  				continue;
>  			}
> -			ret =3D 0;
>  		}
> =20
> -		if (!(repair && ret =3D=3D 0))
> +		if (rec->errors)
>  			error++;
>  		print_inode_error(root, rec);
>  		list_for_each_entry(backref, &rec->backrefs, list) {
> @@ -4189,6 +4189,8 @@ static int check_inode_recs(struct btrfs_root *ro=
ot,
>  				backref->errors |=3D REF_ERR_NO_DIR_INDEX;
>  			if (!backref->found_inode_ref)
>  				backref->errors |=3D REF_ERR_NO_INODE_REF;
> +			if (backref->errors)
> +				error++;
>  			fprintf(stderr, "\tunresolved ref dir %llu index %llu"
>  				" namelen %u name %s filetype %d errors %x",
>  				(unsigned long long)backref->dir,
>=20


--6l1ImqDBaxTNLXCRasMsEIiiDRHkeRqiA--

--YQzA4oR3NfME7rmZSUWk6GyvgClAGeav5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpq/WEXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhtzggAkffIlHxcSNjBoEx7c21IxDOK
ECPK+KYBtRfqmOKCpczzEtOCNNnc6sl2hjwH5aUVquMMZ5me2A2wTHzpuvirHYm8
hR6v8YbnJ0OOmEUa7l3OL/rtQuVyOYMKfmU0wlhWuxooR1xgaCpB0oAiwOy6sFw9
XN8r/fhr2EZdRgN9BHRgN6VApzW187tWEr8zQAET8jaWUKCrcEBehtdNeRoHN3Rx
VHi2aPBp1gT2JLHQ+u57Fc8Pp3FSndpTgztjTT91K/qDK9zssKuNApQk5JkrbuqB
I/zQk142LAgNKd38p3BmFuZgjMQ8gUK46TL5GOp7KytkApK1P6PlhXcseZ1/PA==
=AdE5
-----END PGP SIGNATURE-----

--YQzA4oR3NfME7rmZSUWk6GyvgClAGeav5--
