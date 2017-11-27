Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:64951 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751378AbdK0KVl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Nov 2017 05:21:41 -0500
Subject: Re: [PATCH 1/3] btrfs-progs: check: release path in
 repair_extent_data_item()
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20171127031353.9338-1-suy.fnst@cn.fujitsu.com>
 <20171127031353.9338-2-suy.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <9b09984b-efed-8e1a-7685-ced38b6540f1@gmx.com>
Date: Mon, 27 Nov 2017 18:21:30 +0800
MIME-Version: 1.0
In-Reply-To: <20171127031353.9338-2-suy.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="We3TsdQubJla7Lt4acRE9AAra1K4bm9Xf"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--We3TsdQubJla7Lt4acRE9AAra1K4bm9Xf
Content-Type: multipart/mixed; boundary="kV03uWBwhVUuQ4KXsQGnVLs3ArxoWWmFR";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <9b09984b-efed-8e1a-7685-ced38b6540f1@gmx.com>
Subject: Re: [PATCH 1/3] btrfs-progs: check: release path in
 repair_extent_data_item()
References: <20171127031353.9338-1-suy.fnst@cn.fujitsu.com>
 <20171127031353.9338-2-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20171127031353.9338-2-suy.fnst@cn.fujitsu.com>

--kV03uWBwhVUuQ4KXsQGnVLs3ArxoWWmFR
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8827=E6=97=A5 11:13, Su Yue wrote:
> In repair_extent_data_item(), path is not be released if some
> errors occurs which causes extent buffer leak.
>=20
> So release path in end of the function.
>=20
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>  cmds-check.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/cmds-check.c b/cmds-check.c
> index e746ee7b281d..3a72f8e3877d 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -11974,7 +11974,6 @@ static int repair_extent_data_item(struct btrfs=
_trans_handle *trans,
>  		btrfs_mark_buffer_dirty(eb);
>  		ret =3D btrfs_update_block_group(trans, extent_root, disk_bytenr,
>  					       num_bytes, 1, 0);
> -		btrfs_release_path(&path);

Here btrfs_release_path() should not be removed.

Lines below this, btrfs_inc_extent_ref() is called.
In which we will alloc a new path and modify extent tree.

Thanks to the fact that there is no tree locking implemented in
btrfs-progs, it won't cause dead lock, but it's a good habit to make
path allocation deadlock free.

So please keep the path release here.

(And if you find some code holding conflicting path on the same tree,
feel free to fix them, even it won't cause real problem in btrfs right no=
w)

>  	}
> =20
>  	if (nrefs->full_backref[0])
> @@ -11998,6 +11997,7 @@ static int repair_extent_data_item(struct btrfs=
_trans_handle *trans,
> =20
>  	err &=3D ~BACKREF_MISSING;
>  out:
> +	btrfs_release_path(&path);

On the other hand, an empty path can be released as many times as you wis=
h.
So double releasing the path in out branch is not a problem.

Thanks,
Q

>  	if (ret)
>  		error("can't repair root %llu extent data item[%llu %llu]",
>  		      root->objectid, disk_bytenr, num_bytes);
>=20


--kV03uWBwhVUuQ4KXsQGnVLs3ArxoWWmFR--

--We3TsdQubJla7Lt4acRE9AAra1K4bm9Xf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlob5yoXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhAOQf7B7c+KZQIn2waj/DnkKApSMY+
ZSolTCrQg3Y/TPe/tg3tOE5VI7osyea6SmiNG++y5sml64eGygeaWGmqVo8yHi3r
Q4pKaVV6CVd5TJWNw90Ybhn6793PCVrx+fKRga4Z8eJ8TR7HNW7XviUVjHmy2uWk
AMDcq9EVVd1vdA3AzWg037RYO0i6O4rXcctpU8JG6I+WWHBO5w8f4jlVzziPem95
7GltwE/WAm+oDgTWTEJWPDKC7DL5T0VcmOkGkA96iIBY6Yc+neQpT/CLAIvWODPR
edvjMbH/G14h8D86iXVdVQtCByGPQPjf8INyV61CIl2MIE8KZ6BI2ZfP7BSsBQ==
=9QAU
-----END PGP SIGNATURE-----

--We3TsdQubJla7Lt4acRE9AAra1K4bm9Xf--
