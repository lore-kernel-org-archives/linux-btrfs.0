Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:54165 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752039AbeENL1o (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 07:27:44 -0400
Subject: Re: [PATCH 2/3] btrfs-progs: lowmem: check symlinks with
 append/immutable flags
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180514102922.8840-1-suy.fnst@cn.fujitsu.com>
 <20180514102922.8840-3-suy.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <bbc5f0a1-a95e-7a8d-d2d1-9a123bc50d60@gmx.com>
Date: Mon, 14 May 2018 19:27:30 +0800
MIME-Version: 1.0
In-Reply-To: <20180514102922.8840-3-suy.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="9mpsdguNLHpjDAie8ymSCoe91NQgAhzCL"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9mpsdguNLHpjDAie8ymSCoe91NQgAhzCL
Content-Type: multipart/mixed; boundary="gsKWG6E95o4w8EC9IL9apJOk0A69sp3w3";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <bbc5f0a1-a95e-7a8d-d2d1-9a123bc50d60@gmx.com>
Subject: Re: [PATCH 2/3] btrfs-progs: lowmem: check symlinks with
 append/immutable flags
References: <20180514102922.8840-1-suy.fnst@cn.fujitsu.com>
 <20180514102922.8840-3-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180514102922.8840-3-suy.fnst@cn.fujitsu.com>

--gsKWG6E95o4w8EC9IL9apJOk0A69sp3w3
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8814=E6=97=A5 18:29, Su Yue wrote:
> Symlinks should never have append/immutable flags.
> While checking inodes, if found a symlink with append/immutable
> flags, report and record the fatal error.
>=20
> This is for lowmem mode.
>=20
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>  check/mode-lowmem.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>=20
> diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
> index 9890180d1d3c..61c4e7f23d47 100644
> --- a/check/mode-lowmem.c
> +++ b/check/mode-lowmem.c
> @@ -2274,6 +2274,7 @@ static int check_inode_item(struct btrfs_root *ro=
ot, struct btrfs_path *path)
>  	struct btrfs_key last_key;
>  	u64 inode_id;
>  	u32 mode;
> +	u64 flags;
>  	u64 nlink;
>  	u64 nbytes;
>  	u64 isize;
> @@ -2307,10 +2308,19 @@ static int check_inode_item(struct btrfs_root *=
root, struct btrfs_path *path)
>  	isize =3D btrfs_inode_size(node, ii);
>  	nbytes =3D btrfs_inode_nbytes(node, ii);
>  	mode =3D btrfs_inode_mode(node, ii);
> +	flags =3D btrfs_inode_flags(node, ii);
>  	dir =3D imode_to_type(mode) =3D=3D BTRFS_FT_DIR;
>  	nlink =3D btrfs_inode_nlink(node, ii);
>  	nodatasum =3D btrfs_inode_flags(node, ii) & BTRFS_INODE_NODATASUM;
> =20
> +	if (mode & BTRFS_FT_SYMLINK &&
> +	    (flags & (BTRFS_INODE_IMMUTABLE | BTRFS_INODE_APPEND))) {
> +		err =3D FATAL_ERROR;

Where is the FATAL_ERROR defined?
I can't find it anyway on v4.16 branch.

And I assume that FATAL_ERROR is defined to abort check, if so, in that
case the corruption is not that serious, just some unexpected behavior,
not a fatal error.

If not, just ignore this comment.

Thanks,
Qu

> +		error(
> +"symlinks shall never be with immutable/append, root %llu inode item [=
%llu] flags %llu may be corrupted",
> +		      root->objectid, inode_id, flags);
> +	}
> +
>  	while (1) {
>  		btrfs_item_key_to_cpu(path->nodes[0], &last_key, path->slots[0]);
>  		ret =3D btrfs_next_item(root, path);
>=20


--gsKWG6E95o4w8EC9IL9apJOk0A69sp3w3--

--9mpsdguNLHpjDAie8ymSCoe91NQgAhzCL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlr5cqIACgkQwj2R86El
/qj9kgf/X02ybfWUvgIhBKo4uvgyuGFw4dm3aYs9nNm8DLrDhVYlVyWJP2W1KBZ8
qTmTT+zxshhhllWQ9gArOxDVipUrcntFVAGVJUzvPrKcXhRHI0+wAxVh6hjDqgbQ
3wGiWf9pVucKwDdEnSWK3/F77KHDVM70LH5+0mOCPVvx28AB6bnIuDOCmjl6nbDE
QfoWCaJI1ziMgPCUSlgEu2rBu87hcyLR3ull3YOC47NgPvkgCBBzfW4FtxgAipCj
VpdBomfgn7i1mcdAgJwmSJNNoJla+PDQeJlGX11LeLVcwzTHiFzHNRK8kYKppOFL
vrg2KYwRWEjRrSm5w2Y2dlQa/bxiig==
=1Cls
-----END PGP SIGNATURE-----

--9mpsdguNLHpjDAie8ymSCoe91NQgAhzCL--
