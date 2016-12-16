Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59075 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761875AbcLPPyI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Dec 2016 10:54:08 -0500
Subject: Re: [PATCH] btrfs: fix dereference on inode->i_sb before inode null
 check
To: Colin King <colin.king@canonical.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20161216122056.20607-1-colin.king@canonical.com>
Cc: linux-kernel@vger.kernel.org
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <bdfa5c0f-758c-ad90-37b8-4d14516d5cdc@suse.com>
Date: Fri, 16 Dec 2016 10:03:33 -0500
MIME-Version: 1.0
In-Reply-To: <20161216122056.20607-1-colin.king@canonical.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="hSNvsGjgp5hA1uv43AqOmGWLS9DhndFL0"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hSNvsGjgp5hA1uv43AqOmGWLS9DhndFL0
Content-Type: multipart/mixed; boundary="17huiPkeMR0R8KhTDUiQRkcAcpQSjVqVx";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Colin King <colin.king@canonical.com>, Chris Mason <clm@fb.com>,
 Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
 linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Message-ID: <bdfa5c0f-758c-ad90-37b8-4d14516d5cdc@suse.com>
Subject: Re: [PATCH] btrfs: fix dereference on inode->i_sb before inode null
 check
References: <20161216122056.20607-1-colin.king@canonical.com>
In-Reply-To: <20161216122056.20607-1-colin.king@canonical.com>

--17huiPkeMR0R8KhTDUiQRkcAcpQSjVqVx
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 12/16/16 7:20 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>=20
> inode is being deferenced and then inode is checked to see if it
> is null, implying we potentially could have a null pointer deference
> on inode.
>=20
> Found with static analysis by CoverityScan, CID 1389472
>=20
> Fix this by dereferencing inode only after the inode null check.
>=20
> Fixes: 0b246afa62b0cf5 ("btrfs: root->fs_info cleanup, add fs_info conv=
enience variables")

Hi Colin -

Thanks for the review.  The right fix here is to eliminate the tests for
inode =3D=3D NULL entirely.  This is a callback for exportfs, which will
itself crash if dentry->d_inode or parent->d_inode is NULL.  Removing
the tests would be consistent with other file systems.

-Jeff

> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  fs/btrfs/export.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/btrfs/export.c b/fs/btrfs/export.c
> index 340d907..b746d2b 100644
> --- a/fs/btrfs/export.c
> +++ b/fs/btrfs/export.c
> @@ -223,7 +223,7 @@ static int btrfs_get_name(struct dentry *parent, ch=
ar *name,
>  {
>  	struct inode *inode =3D d_inode(child);
>  	struct inode *dir =3D d_inode(parent);
> -	struct btrfs_fs_info *fs_info =3D btrfs_sb(inode->i_sb);
> +	struct btrfs_fs_info *fs_info;
>  	struct btrfs_path *path;
>  	struct btrfs_root *root =3D BTRFS_I(dir)->root;
>  	struct btrfs_inode_ref *iref;
> @@ -241,6 +241,7 @@ static int btrfs_get_name(struct dentry *parent, ch=
ar *name,
>  	if (!S_ISDIR(dir->i_mode))
>  		return -EINVAL;
> =20
> +	fs_info =3D btrfs_sb(inode->i_sb);
>  	ino =3D btrfs_ino(inode);
> =20
>  	path =3D btrfs_alloc_path();
>=20


--=20
Jeff Mahoney
SUSE Labs


--17huiPkeMR0R8KhTDUiQRkcAcpQSjVqVx--

--hSNvsGjgp5hA1uv43AqOmGWLS9DhndFL0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBCAAGBQJYVAJFAAoJEB57S2MheeWyqbMP/iXeoItP3s3AIhn+yvu6rqSI
8voUKGgs0+E/NlxQQ14H+vWPCCwdxFxXQyx6dkJexPkIhHb2gAYs/fTjwjgnaoUT
DGD0U5Xs3K4qcHKm4y1RgVTy3dfQdNe+HjCOTyU3j/j88GwPLFnOMTQONqR04dom
hp64sQkCXE+S/PxY4/UE1RVtqkPpOfma4QgkR+9rAzUQlRgdYhRaecXxAbHMLY63
9wf0WKpmvPpTwkmv/azPPDoaCrh79KHb0xymCEIwpECEjtU9RzDAJcQBfI00oE7k
QbGkqC/2IxV9+jTbwnjyW3Mexbad/UarZWzEBUxyAIvBLTpPSa1/CPB82YBuHXGB
36eO+pox+bUDaqtLc5NsEy0YeOmtufDM73o7OKVIhjdPJSWlEZaripU4yg1E7Kkt
4cMV04Z47Y0dsx9xjPpXZysGmUDl4S/IfpslHQ8tKvyHamvgkzrXqSxOakYh1f4h
Li/qFtzRv/cyzV89rWsCS+FbePb7yhMhQo2pT7DdLuEDJGrDdNpYm0UjtCgPHsjX
snpuqu2GuEex8DkXh6Bc3ZMGKuu6d4HwINrX2+zHpXMtfF6/QnUYKRhFTthA5oZ5
In+/0bORl5R29+QQLoeoRjDbOAm/Tgq5lYFqFaHeDtG6U+VqFAdvQO7Qz4KmTjfI
gbsu91WG7NP9MP5UDoSh
=FJ3i
-----END PGP SIGNATURE-----

--hSNvsGjgp5hA1uv43AqOmGWLS9DhndFL0--
