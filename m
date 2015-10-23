Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:48404 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S965951AbbJWAPA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Oct 2015 20:15:00 -0400
Date: Thu, 22 Oct 2015 20:14:59 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH] btrfs/ioctl.c: Prefer inode with lowest offset as
 source for clone
Message-ID: <20151023001459.GF4400@hungrycats.org>
References: <CAGqmi76ZKv3ezguTyxGL_Jv_xtq5w_SGPvjwTy90Z=oNY73Vmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hK8Uo4Yp55NZU70L"
In-Reply-To: <CAGqmi76ZKv3ezguTyxGL_Jv_xtq5w_SGPvjwTy90Z=oNY73Vmw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--hK8Uo4Yp55NZU70L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 20, 2015 at 04:29:46PM +0300, Timofey Titovets wrote:
> For performance reason, leave data at the start of disk, is preferable
> while deduping
> It's might sense for the reasons:
> 1. Spinning rust - start of the disk is much faster
> 2. Btrfs can deallocate empty data chunk from the end of fs - ie it's com=
pact fs

"src" is the extent that is kept, and "dst" is the extent that is
discarded.  When both extents are shared, the dedup userspace has to
pass a common "src" with many different "dst" over several extent-same
calls in order to get rid of all of the references to the "dst" extent.

If "src" and "dst" are arbitrarily swapped over multiple extent-same calls
then it becomes impossible to dedup shared extents.  Heck, if there are
more than two extents even in one extent-same call then it stops working.

It would be possible to have dedup figure out which extent the kernel
picked after the fact, but that's totally unnecessary extra work in
cases where the userspace has a good reason to pick the extents it did
(e.g. administrator hints about future usage of the files where the
extents were found).

Dedup userspace can figure out the physical addresses of the extents
and rearrange the arguments itself if desired.

> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
> ---
>  fs/btrfs/ioctl.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 3e3e613..3eb77c0 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3074,8 +3074,13 @@ static int btrfs_extent_same(struct inode *src,
> u64 loff, u64 olen,
>=20
>   /* pass original length for comparison so we stay within i_size */
>   ret =3D btrfs_cmp_data(src, loff, dst, dst_loff, olen, &cmp);
> - if (ret =3D=3D 0)
> -     ret =3D btrfs_clone(src, dst, loff, olen, len, dst_loff, 1);
> + if (ret =3D=3D 0) {
> +     /* prefer inode with lowest offset as source for clone*/
> +     if (loff > dest_loff)
> +         ret =3D btrfs_clone(dst, src, dst_loff, olen, len, loff, 1);
> +     else
> +         ret =3D btrfs_clone(src, dst, loff, olen, len, dst_loff, 1);
> + }
>=20
>   if (same_inode)
>   unlock_extent(&BTRFS_I(src)->io_tree, same_lock_start,
> --=20
> 2.6.1

> From 5ed3822bc308c726d91a837fbd97ebacaa51e58d Mon Sep 17 00:00:00 2001
> From: Timofey Titovets <nefelim4ag@gmail.com>
> Date: Tue, 20 Oct 2015 15:53:20 +0300
> Subject: [RFC PATCH] btrfs/ioctl.c: Prefer inode with lowest offset as so=
urce for
>  clone
>=20
> For performance reason, leave data at the start of disk, is preferable
>=20
> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
> ---
>  fs/btrfs/ioctl.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 3e3e613..3eb77c0 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3074,8 +3074,13 @@ static int btrfs_extent_same(struct inode *src, u6=
4 loff, u64 olen,
> =20
>  	/* pass original length for comparison so we stay within i_size */
>  	ret =3D btrfs_cmp_data(src, loff, dst, dst_loff, olen, &cmp);
> -	if (ret =3D=3D 0)
> -		ret =3D btrfs_clone(src, dst, loff, olen, len, dst_loff, 1);
> +	if (ret =3D=3D 0) {
> +		/* prefer inode with lowest offset as source for clone*/
> +		if (loff > dest_loff)
> +			ret =3D btrfs_clone(dst, src, dst_loff, olen, len, loff, 1);
> +		else
> +			ret =3D btrfs_clone(src, dst, loff, olen, len, dst_loff, 1);
> +	}
> =20
>  	if (same_inode)
>  		unlock_extent(&BTRFS_I(src)->io_tree, same_lock_start,
> --=20
> 2.6.1
>=20


--hK8Uo4Yp55NZU70L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlYpfAMACgkQgfmLGlazG5wiiACgif8R4AZx61aVHUsahDqUyhVs
lNgAoL8AF1d+CWPo9meWEUKc47FotsUr
=8lhB
-----END PGP SIGNATURE-----

--hK8Uo4Yp55NZU70L--
