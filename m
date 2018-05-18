Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:59297 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751450AbeERFPR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 May 2018 01:15:17 -0400
Subject: Re: [PATCH v2 1/6] Btrfs: remove superfluous free_extent_buffer
To: Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
References: <1526612424-97061-1-git-send-email-bo.liu@linux.alibaba.com>
 <1526612424-97061-2-git-send-email-bo.liu@linux.alibaba.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <af4f5a7a-1e95-e0b4-1e84-0e152774f10c@gmx.com>
Date: Fri, 18 May 2018 13:15:07 +0800
MIME-Version: 1.0
In-Reply-To: <1526612424-97061-2-git-send-email-bo.liu@linux.alibaba.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ZLL742GXNJnIPLRVZxvAYee9ih3G9L87J"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ZLL742GXNJnIPLRVZxvAYee9ih3G9L87J
Content-Type: multipart/mixed; boundary="rm9H6Y1RqVzxodCVsDFba3qk2YoMKWYpp";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
Message-ID: <af4f5a7a-1e95-e0b4-1e84-0e152774f10c@gmx.com>
Subject: Re: [PATCH v2 1/6] Btrfs: remove superfluous free_extent_buffer
References: <1526612424-97061-1-git-send-email-bo.liu@linux.alibaba.com>
 <1526612424-97061-2-git-send-email-bo.liu@linux.alibaba.com>
In-Reply-To: <1526612424-97061-2-git-send-email-bo.liu@linux.alibaba.com>

--rm9H6Y1RqVzxodCVsDFba3qk2YoMKWYpp
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8818=E6=97=A5 11:00, Liu Bo wrote:
> read_block_for_search() can be simplified as,
>=20
> tmp =3D find_extent_buffer();
> if (tmp)
>    return;
>=20
> free_extent_buffer();
> read_tree_block();
>=20
> Apparently, @tmp must be NULL at this point, free_extent_buffer() is no=
t
> needed.>
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>

Reviewed-by: Qu wenruo <wqu@suse.com>

Thanks,
Qu
> ---
>  fs/btrfs/ctree.c | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index b3f6f300e492..9fa3d77c98d4 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -2432,7 +2432,6 @@ noinline void btrfs_unlock_up_safe(struct btrfs_p=
ath *path, int level)
>  	btrfs_unlock_up_safe(p, level + 1);
>  	btrfs_set_path_blocking(p);
> =20
> -	free_extent_buffer(tmp);
>  	if (p->reada !=3D READA_NONE)
>  		reada_for_search(fs_info, p, level, slot, key->objectid);
> =20
>=20


--rm9H6Y1RqVzxodCVsDFba3qk2YoMKWYpp--

--ZLL742GXNJnIPLRVZxvAYee9ih3G9L87J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlr+YVsACgkQwj2R86El
/qjZWgf/Wgi4ZGg1De//hRfI1S6LlQePakp+vnzC8IogMjQxEMXFA9IacpZ5a12U
6yaZu2OTpnUpOAI01wK1Df3wD/yir3iM/eqG9aQpLbwsaXHWmRCHfjqmuX/Ck7TL
kJ/avc/MncacHqbZ15NY6Ap2vA8f+N90ep5vcEYT+3FsMUUIIWcHv1yF6ED/Hk/U
NKJvY2+Q/iFqwxyOWoIk0kPb6ItglRvW1ywtbGhUoTKe7Gw5AcIaK2GWCgC9o5Tw
yGL771fyocHY8l6+ABWXUgHR5AKgP5r6ryHOGl6IJYcgna9LLB/7cauDTfjF65so
ucbRyfSjMy8ZjkkwNvytndq0bcYk4Q==
=1NME
-----END PGP SIGNATURE-----

--ZLL742GXNJnIPLRVZxvAYee9ih3G9L87J--
