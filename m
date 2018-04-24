Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:53139 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755919AbeDXGC6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Apr 2018 02:02:58 -0400
Subject: Re: [PATCH 1/3] btrfs-progs: remove comments about delayed ref in
 backref.c
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180424055233.6420-1-suy.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <59c132d1-f6eb-708d-2c8f-96533ac9ce59@gmx.com>
Date: Tue, 24 Apr 2018 14:02:39 +0800
MIME-Version: 1.0
In-Reply-To: <20180424055233.6420-1-suy.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="X0CHMlvfXP0PHsfg31CCzr5ydLZOpHiGT"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--X0CHMlvfXP0PHsfg31CCzr5ydLZOpHiGT
Content-Type: multipart/mixed; boundary="okn8XSUaeNPeQz8dbKKTMVzgnGdsdoRi4";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <59c132d1-f6eb-708d-2c8f-96533ac9ce59@gmx.com>
Subject: Re: [PATCH 1/3] btrfs-progs: remove comments about delayed ref in
 backref.c
References: <20180424055233.6420-1-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180424055233.6420-1-suy.fnst@cn.fujitsu.com>

--okn8XSUaeNPeQz8dbKKTMVzgnGdsdoRi4
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B404=E6=9C=8824=E6=97=A5 13:52, Su Yue wrote:
> There is no delayed ref in btrfs-progs, so remove related comments.
>=20

Indeed.
Delayed ref is only used to speed up extent tree modification with the
cost of code complexity.

For btrfs-progs we don't need to worry about it at all.

Thanks,
Qu

> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>  backref.c | 19 +++----------------
>  1 file changed, 3 insertions(+), 16 deletions(-)
>=20
> diff --git a/backref.c b/backref.c
> index 27309e07a1e9..c144dbf060f2 100644
> --- a/backref.c
> +++ b/backref.c
> @@ -155,19 +155,6 @@ static void init_pref_state(struct pref_state *pre=
fstate)
>   * - if you cannot add the parent or a correct key, then we will look =
into the
>   *   block later to set a correct key
>   *
> - * delayed refs
> - * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> - *        backref type | shared | indirect | shared | indirect
> - * information         |   tree |     tree |   data |     data
> - * --------------------+--------+----------+--------+----------
> - *      parent logical |    y   |     -    |    -   |     -
> - *      key to resolve |    -   |     y    |    y   |     y
> - *  tree block logical |    -   |     -    |    -   |     -
> - *  root for resolving |    y   |     y    |    y   |     y
> - *
> - * - column 1:       we've the parent -> done
> - * - column 2, 3, 4: we use the key to find the parent
> - *
>   * on disk refs (inline or keyed)
>   * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
>   *        backref type | shared | indirect | shared | indirect
> @@ -735,9 +722,9 @@ static int __add_keyed_refs(struct btrfs_fs_info *f=
s_info,
>  }
> =20
>  /*
> - * this adds all existing backrefs (inline backrefs, backrefs and dela=
yed
> - * refs) for the given bytenr to the refs list, merges duplicates and =
resolves
> - * indirect refs to their parent bytenr.
> + * this adds all existing backrefs (inline backrefs, backrefs for the =
given
> + * bytenr to the refs list, merges duplicates and resolves indirect re=
fs to
> + * their parent bytenr.
>   * When roots are found, they're added to the roots list
>   *
>   * FIXME some caching might speed things up
>=20


--okn8XSUaeNPeQz8dbKKTMVzgnGdsdoRi4--

--X0CHMlvfXP0PHsfg31CCzr5ydLZOpHiGT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlreyIAACgkQwj2R86El
/qiXJgf/RVxVGI21vTkKpPHG079ANU4Yz/dXFG6zxzVntoOP0l8vNx1Sa3fWqU2W
UM4vB8xZ+oJHI1rnZ0VpodGa1C7Q0PuIg/bkjj7voVXzeFmTHlJ31Lx6PiHPcmd6
fimXwZN+Dz/4MyztdQjfYHbwSj5sBRZ/x72Nf9SfKUTsixDQg0PiejM5XtQONMHM
bTmRpjMR9D6PY9/pd/ntIY/EsAN4Z08S0cR0SvGYQfQZdbhgg4BKjRg1/WCVGs2/
eCPNNuVaTzRfVp1IeoBaX0/3+h+dcY/yP0REicc+jfZEA8dVdm6tmUr/TS1bnf4W
zYjYvp+AfxEK1LHXcAj+waI/oJXg3g==
=lvSJ
-----END PGP SIGNATURE-----

--X0CHMlvfXP0PHsfg31CCzr5ydLZOpHiGT--
