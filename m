Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:37437 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752095AbeEPBVl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 May 2018 21:21:41 -0400
Subject: Re: [PATCH] Btrfs: fix the corruption by reading stale btree blocks
To: Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
References: <1526405857-88702-1-git-send-email-bo.liu@linux.alibaba.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <6ba7e9cf-20e9-301f-83d9-0f5c494d4a2e@gmx.com>
Date: Wed, 16 May 2018 09:21:29 +0800
MIME-Version: 1.0
In-Reply-To: <1526405857-88702-1-git-send-email-bo.liu@linux.alibaba.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5CPasHSI6wQvRPgtdieCj8luC8Y8Z5xbd"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5CPasHSI6wQvRPgtdieCj8luC8Y8Z5xbd
Content-Type: multipart/mixed; boundary="mzigj9fMEyvCxDfCEI7e5ClaulwhwZ66G";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
Message-ID: <6ba7e9cf-20e9-301f-83d9-0f5c494d4a2e@gmx.com>
Subject: Re: [PATCH] Btrfs: fix the corruption by reading stale btree blocks
References: <1526405857-88702-1-git-send-email-bo.liu@linux.alibaba.com>
In-Reply-To: <1526405857-88702-1-git-send-email-bo.liu@linux.alibaba.com>

--mzigj9fMEyvCxDfCEI7e5ClaulwhwZ66G
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8816=E6=97=A5 01:37, Liu Bo wrote:
> If a btree block, aka. extent buffer, is not available in the extent
> buffer cache, it'll be read out from the disk instead, i.e.
>=20
> btrfs_search_slot()
>   read_block_for_search()  # hold parent and its lock, go to read child=

>     btrfs_release_path()
>     read_tree_block()  # read child
>=20
> Unfortunately, the parent lock got released before reading child, so
> commit 5bdd3536cbbe ("Btrfs: Fix block generation verification race") h=
ad
> used 0 as parent transid to read the child block.  It forces
> read_tree_block() not to check if parent transid is different with the
> generation id of the child that it reads out from disk.
>=20
> A simple PoC is included in btrfs/124,
>=20
> 0. A two-disk raid1 btrfs,
>=20
> 1. Right after mkfs.btrfs, block A is allocated to be device tree's roo=
t.
>=20
> 2. Mount this filesystem and put it in use, after a while, device tree'=
s
>    root got COW but block A hasn't been allocated/overwritten yet.
>=20
> 3. Umount it and reload the btrfs module to remove both disks from the
>    global @fs_devices list.
>=20
> 4. mount -odegraded dev1 and write some data, so now block A is allocat=
ed
>    to be a leaf in checksum tree.  Note that only dev1 has the latest
>    metadata of this filesystem.
>=20
> 5. Umount it and mount it again normally (with both disks), since raid1=

>    can pick up one disk by the writer task's pid, if btrfs_search_slot(=
)
>    needs to read block A, dev2 which does NOT have the latest metadata
>    might be read for block A, then we got a stale block A.
>=20
> 6. As parent transid is not checked, block A is marked as uptodate and
>    put into the extent buffer cache, so the future search won't bother
>    to read disk again, which means it'll make changes on this stale
>    one and make it dirty and flush it onto disk.
>=20
> To avoid the problem, parent transid needs to be passed to
> read_tree_block().
>=20
> In order to get a valid parent transid, we need to hold the parent's
> lock until finish reading child.

Thanks for the detailed explanation.

It explains the first_key check error reported, thanks a lot!

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

>=20
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> ---
>  fs/btrfs/ctree.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 3fd44835b386..b3f6f300e492 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -2436,10 +2436,8 @@ noinline void btrfs_unlock_up_safe(struct btrfs_=
path *path, int level)
>  	if (p->reada !=3D READA_NONE)
>  		reada_for_search(fs_info, p, level, slot, key->objectid);
> =20
> -	btrfs_release_path(p);
> -
>  	ret =3D -EAGAIN;
> -	tmp =3D read_tree_block(fs_info, blocknr, 0, parent_level - 1,
> +	tmp =3D read_tree_block(fs_info, blocknr, gen, parent_level - 1,
>  			      &first_key);
>  	if (!IS_ERR(tmp)) {
>  		/*
> @@ -2454,6 +2452,8 @@ noinline void btrfs_unlock_up_safe(struct btrfs_p=
ath *path, int level)
>  	} else {
>  		ret =3D PTR_ERR(tmp);
>  	}
> +
> +	btrfs_release_path(p);
>  	return ret;
>  }
> =20
>=20


--mzigj9fMEyvCxDfCEI7e5ClaulwhwZ66G--

--5CPasHSI6wQvRPgtdieCj8luC8Y8Z5xbd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlr7h5oACgkQwj2R86El
/qguIwf/cd0iVMnkdzRyeoqoVpSxymxCwrNeZFptNPW6dVyqZ09GyvSYReoiZ/NF
4S5C24+xgwE897eI0mgKaaym0mvRlN1ftwB42aa4/C0Rjw7pRAlapbQMdHGQEBi2
pRUc/IQIMW7ca1bTxPWDqbYMIpgVIBhuxp3+MnNCWF0b15/klz+NlrS6wzp5oOod
UV+X+64ZEQxMkiH1vx2I04BmgYrySmuaHRWZXGr0pD0OY8Txj5JO3ct/sCkf8xrk
LVPhidQ6I1MeYJO0/ZXkOngo7Q3g9B9QyfwVy7/FH3/WKObn06UpudQMGlPhnL2X
ODXmSsxY0VD8W6FiG3dwqnvoT+8AiQ==
=+JZ1
-----END PGP SIGNATURE-----

--5CPasHSI6wQvRPgtdieCj8luC8Y8Z5xbd--
