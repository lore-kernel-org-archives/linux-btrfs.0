Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:44283 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727162AbeHWDnq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Aug 2018 23:43:46 -0400
Subject: Re: [PATCH] Btrfs: use next_state in find_first_extent_bit
To: Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
References: <1534965293-70614-1-git-send-email-bo.liu@linux.alibaba.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <72f35df2-e1a5-d778-5598-693523f9ed4e@gmx.com>
Date: Thu, 23 Aug 2018 08:16:39 +0800
MIME-Version: 1.0
In-Reply-To: <1534965293-70614-1-git-send-email-bo.liu@linux.alibaba.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WcmxQugJ5aMI0jNP9O0eT7DIbieFWjy8R"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WcmxQugJ5aMI0jNP9O0eT7DIbieFWjy8R
Content-Type: multipart/mixed; boundary="uOUWGpuMZoHbWI7r1ulIBE1jl5tUkbNDw";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
Message-ID: <72f35df2-e1a5-d778-5598-693523f9ed4e@gmx.com>
Subject: Re: [PATCH] Btrfs: use next_state in find_first_extent_bit
References: <1534965293-70614-1-git-send-email-bo.liu@linux.alibaba.com>
In-Reply-To: <1534965293-70614-1-git-send-email-bo.liu@linux.alibaba.com>

--uOUWGpuMZoHbWI7r1ulIBE1jl5tUkbNDw
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/8/23 =E4=B8=8A=E5=8D=883:14, Liu Bo wrote:
> As next_state() is already defined to get the next state, update us to =
use
> the helper.
>=20
> No functional changes.
>=20
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  fs/btrfs/extent_io.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
>=20
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 628f1aef34b0..44397fa909c2 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -1424,20 +1424,15 @@ int find_first_extent_bit(struct extent_io_tree=
 *tree, u64 start,
>  			  struct extent_state **cached_state)
>  {
>  	struct extent_state *state;
> -	struct rb_node *n;
>  	int ret =3D 1;
> =20
>  	spin_lock(&tree->lock);
>  	if (cached_state && *cached_state) {
>  		state =3D *cached_state;
>  		if (state->end =3D=3D start - 1 && extent_state_in_tree(state)) {
> -			n =3D rb_next(&state->rb_node);
> -			while (n) {
> -				state =3D rb_entry(n, struct extent_state,
> -						 rb_node);
> +			while ((state =3D next_state(state)) !=3D NULL) {
>  				if (state->state & bits)
>  					goto got_it;
> -				n =3D rb_next(n);
>  			}
>  			free_extent_state(*cached_state);
>  			*cached_state =3D NULL;
>=20


--uOUWGpuMZoHbWI7r1ulIBE1jl5tUkbNDw--

--WcmxQugJ5aMI0jNP9O0eT7DIbieFWjy8R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlt9/OcACgkQwj2R86El
/qhmFAf/SfNOayA3lXBqrSAs8AYVIMMGjoFIC7AG4gUrAsOySgWYCsYfvOwNh7Eq
nhYqEVqpxqlzR50+jeIE1M3Fh2hjpXZmv3BTGysJp9rJS3uZc1oiXIMjv2O3YpLD
JlPLvzo6Tz8t8qwerEYUA65IwM0mEnq+NylaUnYrat0wH+MYbjlaKy6olUBiAxok
3a7FSh/SYCif8cqI6vqilrApZzJxYsFy7zk2foT40hjBGl8Oh95RinZ1z8MV7ban
DoZ886oort3e8JSpg0VFnugSpTMIDCUvY2RHPk4cqQUgASFhogAfeDohUfYT6+6E
hOfI0Nw0ceD9d0ZOIdaHNk5jJlJCgA==
=HkBv
-----END PGP SIGNATURE-----

--WcmxQugJ5aMI0jNP9O0eT7DIbieFWjy8R--
