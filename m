Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:55450 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751917AbdJ3IUj (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Mon, 30 Oct 2017 04:20:39 -0400
Subject: Re: [PATCH] btrfs-progs: ins: fix arg order in print_inode_item()
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <91513913-9626-da65-5830-b372895f1325@jp.fujitsu.com>
From: Qu Wenruo <wqu@suse.com>
Message-ID: <6ee6b71f-a3a2-380e-8b6c-cb7fd4212186@suse.com>
Date: Mon, 30 Oct 2017 16:20:20 +0800
MIME-Version: 1.0
In-Reply-To: <91513913-9626-da65-5830-b372895f1325@jp.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="jiv4edvbowg9D2xRVUb7iOQOt0amHSFr1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jiv4edvbowg9D2xRVUb7iOQOt0amHSFr1
Content-Type: multipart/mixed; boundary="Tpou5aaRhcV6HagbHGOnmHbWS8oUCf0ca";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.com>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <6ee6b71f-a3a2-380e-8b6c-cb7fd4212186@suse.com>
Subject: Re: [PATCH] btrfs-progs: ins: fix arg order in print_inode_item()
References: <91513913-9626-da65-5830-b372895f1325@jp.fujitsu.com>
In-Reply-To: <91513913-9626-da65-5830-b372895f1325@jp.fujitsu.com>

--Tpou5aaRhcV6HagbHGOnmHbWS8oUCf0ca
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B410=E6=9C=8830=E6=97=A5 16:10, Misono, Tomohiro wrote:
> In the print_inode_item(), the argument order of sequence and flags are=

> reversed:
>=20
> printf("... sequence %llu flags 0x%llx(%s)\n",
> 				...=20
> 	       (unsigned long long)btrfs_inode_flags(eb,ii),
>  	       (unsigned long long)btrfs_inode_sequence(eb, ii),
> 				...)
>=20
> So, just fix it.
>=20
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  print-tree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/print-tree.c b/print-tree.c
> index 3c585e3..8abd760 100644
> --- a/print-tree.c
> +++ b/print-tree.c
> @@ -896,8 +896,8 @@ static void print_inode_item(struct extent_buffer *=
eb,
>  	       btrfs_inode_uid(eb, ii),
>  	       btrfs_inode_gid(eb, ii),
>  	       (unsigned long long)btrfs_inode_rdev(eb,ii),
> -	       (unsigned long long)btrfs_inode_flags(eb,ii),
>  	       (unsigned long long)btrfs_inode_sequence(eb, ii),
> +	       (unsigned long long)btrfs_inode_flags(eb,ii),
>  	       flags_str);
>  	print_timespec(eb, btrfs_inode_atime(ii), "\t\tatime ", "\n");
>  	print_timespec(eb, btrfs_inode_ctime(ii), "\t\tctime ", "\n");
>=20


--Tpou5aaRhcV6HagbHGOnmHbWS8oUCf0ca--

--jiv4edvbowg9D2xRVUb7iOQOt0amHSFr1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFBBAEBCAArFiEELd9y5aWlW6idqkLhwj2R86El/qgFAln24MQNHHdxdUBzdXNl
LmNvbQAKCRDCPZHzoSX+qHEPB/42wpduY00MlgJjMprZqIO+vx82mvNe1a0ut5iF
ornLPb2XJo7DI5tpJ74Z4T19p3lTdz019USKg2A8tv0AbJ7cASrX8gVPCSfeNTT6
ODURGJPrBrMlblR7XVBy7bcq8lPnDBvSedt2LlBrqe5TXQrStasLw88xB/kTBoFz
inP9EzlZVkWLj7SoEFAJQOw5iGL0davztRXEnio3npvLA0pHlUw6ZwKgM35O3OIV
TQLXg1An8jd8QRqg0VTgXZ137tmNbQqFzj0uHBu+JNFXoSe31PxC/0/N649r70mL
jHzLpL13V4/RonW8UdC3BinN7et/DT5nlHTVOemjNjLsDDrJ
=ApOS
-----END PGP SIGNATURE-----

--jiv4edvbowg9D2xRVUb7iOQOt0amHSFr1--
