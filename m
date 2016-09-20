Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38031 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752028AbcITNAv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 09:00:51 -0400
Subject: Re: Fs: Btrfs - Fix possible ERR_PTR() dereferencing.
To: Shailendra Verma <shailendra.v@samsung.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, Ravikant Sharma <ravikant.s2@samsung.com>
References: <1474354107-18774-1-git-send-email-shailendra.v@samsung.com>
Cc: linux-kernel@vger.kernel.org, vidushi.koul@samsung.com
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <7050d410-dbf1-15a3-a6ba-2ae28f1fb0ee@suse.com>
Date: Tue, 20 Sep 2016 09:00:44 -0400
MIME-Version: 1.0
In-Reply-To: <1474354107-18774-1-git-send-email-shailendra.v@samsung.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="nR2Hi0wAWAMg0GeRjnoBhu93s7qLFQif8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nR2Hi0wAWAMg0GeRjnoBhu93s7qLFQif8
Content-Type: multipart/mixed; boundary="cUsA7MmLHaL9L586xDCiEM6b1sJ4R5dVx";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Shailendra Verma <shailendra.v@samsung.com>, Chris Mason <clm@fb.com>,
 Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
 linux-btrfs@vger.kernel.org, Ravikant Sharma <ravikant.s2@samsung.com>
Cc: linux-kernel@vger.kernel.org, vidushi.koul@samsung.com
Message-ID: <7050d410-dbf1-15a3-a6ba-2ae28f1fb0ee@suse.com>
Subject: Re: Fs: Btrfs - Fix possible ERR_PTR() dereferencing.
References: <1474354107-18774-1-git-send-email-shailendra.v@samsung.com>
In-Reply-To: <1474354107-18774-1-git-send-email-shailendra.v@samsung.com>

--cUsA7MmLHaL9L586xDCiEM6b1sJ4R5dVx
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/20/16 2:48 AM, Shailendra Verma wrote:
> This is of course wrong to call kfree() if memdup_user() fails,
> no memory was allocated and the error in the error-valued pointer
> should be returned.
>=20
> Reviewed-by: Ravikant Sharma <ravikant.s2@samsung.com>
> Signed-off-by: Shailendra Verma <shailendra.v@samsung.com>

Hi Shailendra -

In all three cases, the return value is set using the error-valued
pointer and the pointer is set to NULL.  kfree() checks to see if the
pointer is NULL and, if so, does nothing.  This allows us to use a
common exit path which is an extremely common pattern in the kernel.  So
there's never any possible ERR_PTR dereferencing happening.

However, in all three cases, the allocation you're checking is the first
in each routine and there's no additional cleanup to do.  So your patch
is an improvement, but it's an improvement in code readability instead
of a bug fix.  I'd ask that you re-submit with a commit message that
reflects that.

Thanks,

-Jeff

> ---
>  fs/btrfs/ioctl.c | 21 ++++++---------------
>  1 file changed, 6 insertions(+), 15 deletions(-)
>=20
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index da94138..58a40f8 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -4512,11 +4512,8 @@ static long btrfs_ioctl_logical_to_ino(struct bt=
rfs_root *root,
>  		return -EPERM;
> =20
>  	loi =3D memdup_user(arg, sizeof(*loi));
> -	if (IS_ERR(loi)) {
> -		ret =3D PTR_ERR(loi);
> -		loi =3D NULL;
> -		goto out;
> -	}
> +	if (IS_ERR(loi))
> +		return PTR_ERR(loi);
> =20
>  	path =3D btrfs_alloc_path();
>  	if (!path) {


> @@ -5143,11 +5140,8 @@ static long btrfs_ioctl_set_received_subvol_32(s=
truct file *file,
>  	int ret =3D 0;
> =20
>  	args32 =3D memdup_user(arg, sizeof(*args32));
> -	if (IS_ERR(args32)) {
> -		ret =3D PTR_ERR(args32);
> -		args32 =3D NULL;
> -		goto out;
> -	}
> +	if (IS_ERR(args32))
> +		return PTR_ERR(args32);
> =20
>  	args64 =3D kmalloc(sizeof(*args64), GFP_NOFS);
>  	if (!args64) {
> @@ -5195,11 +5189,8 @@ static long btrfs_ioctl_set_received_subvol(stru=
ct file *file,
>  	int ret =3D 0;
> =20
>  	sa =3D memdup_user(arg, sizeof(*sa));
> -	if (IS_ERR(sa)) {
> -		ret =3D PTR_ERR(sa);
> -		sa =3D NULL;
> -		goto out;
> -	}
> +	if (IS_ERR(sa))
> +		return PTR_ERR(sa);
> =20
>  	ret =3D _btrfs_ioctl_set_received_subvol(file, sa);
> =20
>=20


--=20
Jeff Mahoney
SUSE Labs


--cUsA7MmLHaL9L586xDCiEM6b1sJ4R5dVx--

--nR2Hi0wAWAMg0GeRjnoBhu93s7qLFQif8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJX4TL8AAoJEB57S2MheeWybwQP/2nD1G8KS5o4FxdYIHnmiJQM
vv5u/A6hmbtc09Bz9JAVB7TZEHygPdGG5fJNAuQhL+FuZq7JL7J5ZWG9v9Eb1lXF
/FHXVgpapWuOS7zDS7kTT5IzgFilGEypkQHusdZDGkpaOMMX0zUc+2R9QD2f7oth
DghgjSAy4pa1USXiUuZfbSvTC2P8IgGTbGzk6XY6wxL4vGK7izwn4AJRQ516QOCC
rFPhH7ND/jQ3pO6T93ascz5d3rJKnz+eNcC9O9hXt+0kyUpIZaS2wyQq9RlbgvLj
izD4xjV4eGzCG8UIdNouxhtf0TvknQWwaVHhfau1lvc0Jo5/HmW3k31JmNn+2BjH
z32MJrHSBo/RCAJBt2qaQl+sjVKpO7EeoIwb0wKpbg06v28KijBW5XFBVLsjz0JY
uF9sUyfZQG+HbYyexZD7L6GN33pVCFl5E6PGGEyPQ6O9x+iDyMVIefmzNmNEg1CU
G1o20bHId1CSuxPttKsCtCHfgPHt9rQGPreB0FQNmuZavrD3kn8o+/CO4x61wPhW
UYA1LEqE07nTkfNFdWMCtoe3KHXypmomk3KcTu1Zkl1OTfRKkHhjPlqNfymxg/6v
h0Du6UAcUEV/KdLR7muDpTT6CZmvnG5JgVqxEePPiZd46Y99VqvOnj3r9DkAKCXL
won0iBfoudLT5rlP5w3y
=ZzFG
-----END PGP SIGNATURE-----

--nR2Hi0wAWAMg0GeRjnoBhu93s7qLFQif8--
