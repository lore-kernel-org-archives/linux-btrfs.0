Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:51787 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756268AbeDXGKF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Apr 2018 02:10:05 -0400
Subject: Re: [PATCH 2/3] btrfs-progs: remove useless branch in __merge_refs
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180424055233.6420-1-suy.fnst@cn.fujitsu.com>
 <20180424055233.6420-2-suy.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <5a9026fe-f8bf-b20a-2b1e-0b40cfed890f@gmx.com>
Date: Tue, 24 Apr 2018 14:09:57 +0800
MIME-Version: 1.0
In-Reply-To: <20180424055233.6420-2-suy.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="gMjWD1slV8SDzaXvylOt7BSRvPkpXk9L1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gMjWD1slV8SDzaXvylOt7BSRvPkpXk9L1
Content-Type: multipart/mixed; boundary="koyQOWyM8HEDC1UiCSjpywkAnfOkYewk9";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <5a9026fe-f8bf-b20a-2b1e-0b40cfed890f@gmx.com>
Subject: Re: [PATCH 2/3] btrfs-progs: remove useless branch in __merge_refs
References: <20180424055233.6420-1-suy.fnst@cn.fujitsu.com>
 <20180424055233.6420-2-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180424055233.6420-2-suy.fnst@cn.fujitsu.com>

--koyQOWyM8HEDC1UiCSjpywkAnfOkYewk9
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B404=E6=9C=8824=E6=97=A5 13:52, Su Yue wrote:
> After call of ref_for_same_block, ref1->parent must equals to
> ref2->parent, the block of exchange is never reached.
>=20
> So remove the block of exchange.

Reviewed-by: Qu Wenruo <wqu@suse.com>

The patch looks good, but considering how much difference the kernel and
btrfs-progs have in backref.c, I think it would be much better to start
merging code for it.

Thanks,
Qu

>=20
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>  backref.c | 6 ------
>  1 file changed, 6 deletions(-)
>=20
> diff --git a/backref.c b/backref.c
> index c144dbf060f2..51553c702187 100644
> --- a/backref.c
> +++ b/backref.c
> @@ -497,7 +497,6 @@ static void __merge_refs(struct pref_state *prefsta=
te, int mode)
>  		for (pos2 =3D pos1->next, n2 =3D pos2->next; pos2 !=3D head;
>  		     pos2 =3D n2, n2 =3D pos2->next) {
>  			struct __prelim_ref *ref2;
> -			struct __prelim_ref *xchg;
>  			struct extent_inode_elem *eie;
> =20
>  			ref2 =3D list_entry(pos2, struct __prelim_ref, list);
> @@ -505,11 +504,6 @@ static void __merge_refs(struct pref_state *prefst=
ate, int mode)
>  			if (mode =3D=3D 1) {
>  				if (!ref_for_same_block(ref1, ref2))
>  					continue;> -				if (!ref1->parent && ref2->parent) {
> -					xchg =3D ref1;
> -					ref1 =3D ref2;
> -					ref2 =3D xchg;
> -				}
>  			} else {
>  				if (ref1->parent !=3D ref2->parent)
>  					continue;
>=20


--koyQOWyM8HEDC1UiCSjpywkAnfOkYewk9--

--gMjWD1slV8SDzaXvylOt7BSRvPkpXk9L1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlreyjUACgkQwj2R86El
/qiViQf/cQF+xqtTFnLBlbP7+gedaGle6M4LAe4JzafEJ8KFCm8MU5x9L3p02s8t
mFouabd8ur1+grkr6CO8PAFpwtzQpwHwq9tuMVVXNF+zjtHCXnur8inajig64te4
XR+2X/5Zijt4J6A6Esql+Up8J2P0eiHDuPO8oKSo+GL9CzHDimM6BkFxxBAaTDGK
A89JUmIMjLobE67ZGYEJaKZrILY5IhT8CS9OlCZpkPklfK7XWYlTlQ5oQd3iUW4M
92Ix/xMlgK50DGMxmJ3AFEB/ELuIcmmlb8sGzD8A7bkjxxfAruYrmnsQkbXpaI5I
r8mJhDz5ikmUdA1T3LQrYdrkfFcxIA==
=fGPu
-----END PGP SIGNATURE-----

--gMjWD1slV8SDzaXvylOt7BSRvPkpXk9L1--
