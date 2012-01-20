From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] Btrfs: fix bitwise vs logical condition
Date: Fri, 20 Jan 2012 18:21:29 +0300
Message-ID: <20120120152129.GO3356@mwanda>
References: <20120120075454.GA2295@elgon.mountain>
 <20120120142437.GA2499@zambezi.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5PFZVUeDPxlnBcQp"
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: Ilya Dryomov <idryomov@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120120142437.GA2499@zambezi.lan>
List-ID: <linux-btrfs.vger.kernel.org>


--5PFZVUeDPxlnBcQp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 20, 2012 at 04:24:37PM +0200, Ilya Dryomov wrote:
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2375,12 +2375,11 @@ static int should_balance_chunk(struct btrfs_root=
 *root,
>  	struct btrfs_balance_control *bctl =3D root->fs_info->balance_ctl;
>  	struct btrfs_balance_args *bargs =3D NULL;
>  	u64 chunk_type =3D btrfs_chunk_type(leaf, chunk);
> +	u64 mask =3D chunk_type & BTRFS_BLOCK_GROUP_TYPE_MASK;
> =20
>  	/* type filter */
> -	if (!((chunk_type & BTRFS_BLOCK_GROUP_TYPE_MASK) &
> -	      (bctl->flags & BTRFS_BALANCE_TYPE_MASK))) {
> +	if (((bctl->flags & BTRFS_BALANCE_TYPE_MASK) & mask) !=3D mask)

I don't know if it matters, but semantically this is not
equivalent to the original.  If mask has no flags set then this will
pass.  This says that every flag in mask but has to be set in
->flags but in the original code, only one needed to be.

The original code was equivalent to:
	if (!(chunk_type & bctl->flags & BTRFS_BLOCK_GROUP_TYPE_MASK &
	      BTRFS_BALANCE_TYPE_MASK)) {...

It's weird that we have BTRFS_BLOCK_GROUP_TYPE_MASK and
BTRFS_BALANCE_TYPE_MASK which are the same except that the bitfields
have been renamed.  Can't we just reuse the first definition?

But really, if this isn't a bug, then I don't care.  The original is
fine, or whatever you choose.

regards,
dan carpenter


--5PFZVUeDPxlnBcQp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPGYZ4AAoJEOnZkXI/YHqRy8wQAI3k50jAPFlSz6rnDHuu6neU
eC8edgYADgVUg7YXAkbh6ECu8PXjJ0M+gSlBw4ftUah093mIN2mILQh0Rm8xc+0b
4tY4iXIRb/Nd8HHRHsCO32+OABwShhrLR77n5nA6h5B0LvLsH6McLsroHAPQvzRL
RGw25/2xJg/XAhEfq6+9++EB63kAMj+7Hi5IDCNmwh25f8m4EAn2TwRbPgdSMbAM
Yb6oHLFGH8RyDlWr+geWd3k/FI5IGjIWZavACTzcwa+tikustNOnXmg5NrTdCRT1
XjsvMkt0J1fYHknL8U1emfqwdmeACFfLJcKHuQ0MuealHFoq+dJhm+d7h73j1Uo2
qxgQlEMA0G4Z2yXtnCZ314sEBEIsKDK1SNPRLJBBmSRXhGzrtj8eogmoi5RTptYg
YwCcdefdx4s0BVreBSqY4bY1LqCl71VKj4e50AZWzN37X809pvva7Ckujc4rhQW5
wYKjfYG1rvKVkejipVeB6l+LeuPtwbbSup4PK7y3FAszOweVhv1UL3hGeZGC8iLT
UOuIVcFgOD6FRJwbY7iSV+1xKYcO+JhZ9PQG1J45A4YCEXRGjHr6KO/B5uPjDmXA
XZen21BG6ycaEMZkym4IYK2M/+UnBZmCMOalPhAB2VJo9Is6z5cDrBKCT6CEqmj0
W0UWqijPUJXfL4VQ3XxI
=pNha
-----END PGP SIGNATURE-----

--5PFZVUeDPxlnBcQp--
