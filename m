Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:62132 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751696AbeAZFfG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 00:35:06 -0500
Subject: Re: [PATCH 5/6] btrfs-progs: do clean up for redundancy value
 assignment
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <1516936926-18707-1-git-send-email-gujx@cn.fujitsu.com>
 <1516936926-18707-5-git-send-email-gujx@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <fd4a0944-49cd-1f28-8446-757519ba4f12@gmx.com>
Date: Fri, 26 Jan 2018 13:34:59 +0800
MIME-Version: 1.0
In-Reply-To: <1516936926-18707-5-git-send-email-gujx@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="G9XHCzZQituqG4oZeD8UdHYS447ys9n7n"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--G9XHCzZQituqG4oZeD8UdHYS447ys9n7n
Content-Type: multipart/mixed; boundary="Q5gi3t5Jl00pB2BReULuNVAbkHDxLS892";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <fd4a0944-49cd-1f28-8446-757519ba4f12@gmx.com>
Subject: Re: [PATCH 5/6] btrfs-progs: do clean up for redundancy value
 assignment
References: <1516936926-18707-1-git-send-email-gujx@cn.fujitsu.com>
 <1516936926-18707-5-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1516936926-18707-5-git-send-email-gujx@cn.fujitsu.com>

--Q5gi3t5Jl00pB2BReULuNVAbkHDxLS892
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8826=E6=97=A5 11:22, Gu Jinxiang wrote:
> Although skinny_metadata's type is int, its value just can be 0/1.
> And if condition be true only when skinny_metadata equals 1,
> so in if's executive part, set skinny_metadata to 1 is redundancy.
> Remove it.
>=20
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  extent-tree.c | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/extent-tree.c b/extent-tree.c
> index 1ac312a6..53d31ab3 100644
> --- a/extent-tree.c
> +++ b/extent-tree.c
> @@ -1005,7 +1005,6 @@ static int lookup_inline_extent_backref(struct bt=
rfs_trans_handle *trans,
>  		extra_size =3D -1;
> =20
>  	if (owner < BTRFS_FIRST_FREE_OBJECTID && skinny_metadata) {
> -		skinny_metadata =3D 1;
>  		key.type =3D BTRFS_METADATA_ITEM_KEY;
>  		key.offset =3D owner;
>  	} else if (skinny_metadata) {
>=20


--Q5gi3t5Jl00pB2BReULuNVAbkHDxLS892--

--G9XHCzZQituqG4oZeD8UdHYS447ys9n7n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpqvgMXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qho5wf/WPncF8TRSE99cF5qL5mBt32N
Oi513c2XLc/lUimZ2sECrx+ClJY7yABki9/J66QbkHQeQoHOyzQ2Tcvho7sMvT/k
20wy882juCObDc5LrGx0imlNM5HmURi4Lyq6ukZuizHg7Unl/7G5s0p01U3cxApy
umYjrcBoZcKfp3ye9Q9ZiEltMnKm5GAlSg05SV3F0ryfw8Y2Hxlgz5Jbquc9s1Od
ysPNd7FhQUQkB4w1+wQ/6dpxJptmqMs2uXyrVMK5+Bvr4rW4CBzLmQK5klYOJAjK
20jhA9oAhV5ICZmlMHd2VLQaEKWIOwfmUIQ7vTv8u2q5kq1ZZPlTIL6wEzkEhg==
=zoVH
-----END PGP SIGNATURE-----

--G9XHCzZQituqG4oZeD8UdHYS447ys9n7n--
