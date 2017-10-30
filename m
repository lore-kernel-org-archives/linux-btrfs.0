Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:63313 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752517AbdJ3Ijh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Oct 2017 04:39:37 -0400
Subject: Re: [PATCH] btrfs-progs: ins: fix arg order in print_inode_item()
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <91513913-9626-da65-5830-b372895f1325@jp.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <6bfbf8c5-3108-3073-1ef0-26cbba0e356d@gmx.com>
Date: Mon, 30 Oct 2017 16:39:27 +0800
MIME-Version: 1.0
In-Reply-To: <91513913-9626-da65-5830-b372895f1325@jp.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ltm8dM7MJwVsNRi16tshi7VqnwiMjjK6P"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ltm8dM7MJwVsNRi16tshi7VqnwiMjjK6P
Content-Type: multipart/mixed; boundary="wFLrhBMQt0uKsNxginCcDj6J93DIUVH8r";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <6bfbf8c5-3108-3073-1ef0-26cbba0e356d@gmx.com>
Subject: Re: [PATCH] btrfs-progs: ins: fix arg order in print_inode_item()
References: <91513913-9626-da65-5830-b372895f1325@jp.fujitsu.com>
In-Reply-To: <91513913-9626-da65-5830-b372895f1325@jp.fujitsu.com>

--wFLrhBMQt0uKsNxginCcDj6J93DIUVH8r
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

Not related to this patch, but considering you're going to enhance
root_item creation, it's also a good idea to print such info like
c/o/s/r time and parent/receive UUID.

More patches will never be a bad thing.

Thanks,
Qu
>=20
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
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


--wFLrhBMQt0uKsNxginCcDj6J93DIUVH8r--

--ltm8dM7MJwVsNRi16tshi7VqnwiMjjK6P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAln25T8XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgJdwf/R7ISBF1Cys/gk564vymWPowx
9Vz6tGFfN6mdNQx+LFe6qDuMF8OlZGopbJgn8GfXmfhIUKoDb7hlCaZ9nIYuvV8t
Jyo73B4S5B90xgTn9QeC69Lxf6lKcEQ5hVCb3ZfVA+PXa5P96xniCn3RQe5NibHb
rFvCNXNZw6/367e6S0MS6orHY48vl2+F5zmiUrtGs9BW02UuzexZsJ32pinPo7Q/
nk+0SgISg8VK6FZI5MATqfKzZYnQoNBErap7rX1xVBoZHhOKJBoJ4M9AMSZc6328
+Z6aQmw9dwLYpvDpUHghGXAvo8Sldcg6YL4siVU/Zavt2DfdkFuovxLUvQ/+/A==
=XnOh
-----END PGP SIGNATURE-----

--ltm8dM7MJwVsNRi16tshi7VqnwiMjjK6P--
