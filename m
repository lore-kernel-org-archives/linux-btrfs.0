Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:36343 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756279AbeDXGRX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Apr 2018 02:17:23 -0400
Subject: Re: [PATCH 3/3] btrfs-progs: do not merge tree block refs have
 different root_id
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180424055233.6420-1-suy.fnst@cn.fujitsu.com>
 <20180424055233.6420-3-suy.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <5de2f409-32e4-7e23-3589-e89c2e7510c3@gmx.com>
Date: Tue, 24 Apr 2018 14:17:13 +0800
MIME-Version: 1.0
In-Reply-To: <20180424055233.6420-3-suy.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="wdvjUp9Ae9G5mN1iDTAKEFKg5Yl6efvvb"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wdvjUp9Ae9G5mN1iDTAKEFKg5Yl6efvvb
Content-Type: multipart/mixed; boundary="IrTvJzJ1ZJ9gvgMpdD3A4kgc2YhPiEvb7";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <5de2f409-32e4-7e23-3589-e89c2e7510c3@gmx.com>
Subject: Re: [PATCH 3/3] btrfs-progs: do not merge tree block refs have
 different root_id
References: <20180424055233.6420-1-suy.fnst@cn.fujitsu.com>
 <20180424055233.6420-3-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180424055233.6420-3-suy.fnst@cn.fujitsu.com>

--IrTvJzJ1ZJ9gvgMpdD3A4kgc2YhPiEvb7
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B404=E6=9C=8824=E6=97=A5 13:52, Su Yue wrote:
> For an extent item which contains many tree block backrefs, like
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> In 020-extent-ref-cases/keyed_block_ref.img
>=20
> item 10 key (29470720 METADATA_ITEM 0) itemoff 3450 itemsize 222
>                 refs 23 gen 10 flags TREE_BLOCK
>                 tree block skinny level 0
>                 tree block backref root 278
>                 tree block backref root 277
>                 tree block backref root 276
>                 tree block backref root 275
>                 tree block backref root 274
>                 tree block backref root 273
>                 tree block backref root 272
>                 tree block backref root 271
>                 tree block backref root 270
>                 tree block backref root 269
>                 tree block backref root 268
>                 tree block backref root 267
>                 tree block backref root 266
>                 tree block backref root 265
>                 tree block backref root 264
>                 tree block backref root 263
>                 tree block backref root 262
>                 tree block backref root 261
>                 tree block backref root 260
>                 tree block backref root 259
>                 tree block backref root 258
>                 tree block backref root 257
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> In find_parent_nodes(), these refs's parents are 0, then __merge_refs
> will merge refs to one ref. It causes only one root to be returned.

This is a pretty big problem, and it would cause qgroup verification
code to cause false alerts.

So a new test case would do great help here.

>=20
> So, if both parents are 0, do not merge refs.
>=20
> Lowmem check calls find_parent_nodes frequently to decide whether.
> check an extent buffer or not. These bug influences bytes accounting.

Although it looks good so far, and would fix the problem you found, but
I strongly recommend to port kernel backref code to btrfs-progs here, as
kernel backref code is more tested than btrfs-progs backref code.

I'm pretty sure we have more bugs in btrfs-progs backref, and I'm not a
big fan of playing whac-a-mole here.

>=20
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>  backref.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/backref.c b/backref.c
> index 51553c702187..daadb6299c79 100644
> --- a/backref.c
> +++ b/backref.c
> @@ -507,6 +507,8 @@ static void __merge_refs(struct pref_state *prefsta=
te, int mode)
>  			} else {
>  				if (ref1->parent !=3D ref2->parent)
>  					continue;
> +				if (ref1->parent =3D=3D 0)
> +					continue;

It's better to put it above (ref1->parent !=3D ref2->parent).
As parent =3D=3D 0 means we haven't resolve the parent bytenr yet, so can=
't
be merged nor compared.

Thanks,
Qu

>  			}
> =20
>  			eie =3D ref1->inode_list;
>=20


--IrTvJzJ1ZJ9gvgMpdD3A4kgc2YhPiEvb7--

--wdvjUp9Ae9G5mN1iDTAKEFKg5Yl6efvvb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrey+oACgkQwj2R86El
/qh5OAf+NK+f7VI8KOWtJj05VOF3AMbBtSH57wu5qbOBDkZNrt6aR2JKc71Hj/n5
6yBdT9Seb9pe1G684+zjr+f8yTYrX289gG3N1ujKdDuaAygK3bKRSZVJTk/AGixy
z2qLSHVqKnyjSA68w+emeZzFgLorgmwQ6UhZwxEw4qsWoGYXvTmBJ85kmghCqb2U
3ht0vJyYdQ7A95ahWp5ZWO3QRrxeNPt4EgOnpZ6D5ef4MYp9SeIAuGjItuOcSBCw
yP2/yXCwNGCPXcsKorjzH2M8ha+wkId03hvtdbAYkFMen77vMgZJMQOf1uTGHseh
BqG9S0jFw7912/9FM4lcQZwMSzUUSA==
=AfV+
-----END PGP SIGNATURE-----

--wdvjUp9Ae9G5mN1iDTAKEFKg5Yl6efvvb--
