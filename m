Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:50958 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751530AbdJaFvH (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 31 Oct 2017 01:51:07 -0400
Subject: Re: [PATCH] btrfs-progs: ins: print uuid only if it exists
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <7979b9a1-37d6-9eec-79a7-1730b8338b7f@jp.fujitsu.com>
From: Qu Wenruo <wqu@suse.com>
Message-ID: <d63e1304-654e-ffe5-ef82-d6b976bc779f@suse.com>
Date: Tue, 31 Oct 2017 13:50:51 +0800
MIME-Version: 1.0
In-Reply-To: <7979b9a1-37d6-9eec-79a7-1730b8338b7f@jp.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="FAWXcmqQUcLB2MLgakMh31touTs1JPvCw"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FAWXcmqQUcLB2MLgakMh31touTs1JPvCw
Content-Type: multipart/mixed; boundary="UeWhlxfOP1l7N9KxVeh1fVdHI5uG0NbJu";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.com>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <d63e1304-654e-ffe5-ef82-d6b976bc779f@suse.com>
Subject: Re: [PATCH] btrfs-progs: ins: print uuid only if it exists
References: <7979b9a1-37d6-9eec-79a7-1730b8338b7f@jp.fujitsu.com>
In-Reply-To: <7979b9a1-37d6-9eec-79a7-1730b8338b7f@jp.fujitsu.com>

--UeWhlxfOP1l7N9KxVeh1fVdHI5uG0NbJu
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B410=E6=9C=8831=E6=97=A5 13:39, Misono, Tomohiro wrote:
> UUID of ROOT_ITEM is empty if it is not subvolume (and not created by
> kernel). So, just skip it if it is empty just like parent/received UUID=
=2E
>=20
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu
> ---
>  print-tree.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/print-tree.c b/print-tree.c
> index 8abd760..9d1b862 100644
> --- a/print-tree.c
> +++ b/print-tree.c
> @@ -581,8 +581,10 @@ static void print_root_item(struct extent_buffer *=
leaf, int slot)
>  		flags_str);
> =20
>  	if (root_item.generation =3D=3D root_item.generation_v2) {
> -		uuid_unparse(root_item.uuid, uuid_str);
> -		printf("\t\tuuid %s\n", uuid_str);
> +		if (!empty_uuid(root_item.uuid)) {
> +			uuid_unparse(root_item.uuid, uuid_str);
> +			printf("\t\tuuid %s\n", uuid_str);
> +		}
>  		if (!empty_uuid(root_item.parent_uuid)) {
>  			uuid_unparse(root_item.parent_uuid, uuid_str);
>  			printf("\t\tparent_uuid %s\n", uuid_str);
>=20


--UeWhlxfOP1l7N9KxVeh1fVdHI5uG0NbJu--

--FAWXcmqQUcLB2MLgakMh31touTs1JPvCw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFBBAEBCAArFiEELd9y5aWlW6idqkLhwj2R86El/qgFAln4DzwNHHdxdUBzdXNl
LmNvbQAKCRDCPZHzoSX+qNdqB/94NbLmuhrxy2qMJgG1+DnynSL1wKBGAuG0I/U8
E12vWQt2DMcd/DuwBErh0nh9YHkNiCMEjL0+1q9O1Ojktgqg5fJZcNlxfDyAMW/n
aZ+fpxSRzFkIhaE7aAOHYghNYl/e/hhO8bwHONCIv6E2Etk/etFFHWrKQ5wAenlv
uy41K+x4umKva76cvwgsVhVHT2hpcTr7ouFD/z5Njhx5ojYeIMxCo/5v6UJpz6kt
/8m/HHbxniarkNg/jszGGSws4hn+vrJcn9OaJQEAo+H47DvJ0VczhTWSWEh9Nrxi
RAXzRuKZkt/X2UzdJd0ydCZUqn9WUJ+Lnk5/JDCQqKzRBOOF
=1Cnq
-----END PGP SIGNATURE-----

--FAWXcmqQUcLB2MLgakMh31touTs1JPvCw--
