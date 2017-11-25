Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:58120 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751881AbdKYBDd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Nov 2017 20:03:33 -0500
Subject: Re: [PATCH] btrfs-progs: dump_tree: remove superfluous _TREE
To: Hans van Kranenburg <hans@knorrie.org>, linux-btrfs@vger.kernel.org
References: <20171124202608.11152-1-hans@knorrie.org>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <7166920a-17c1-cd00-23d8-cef0a1693ba5@gmx.com>
Date: Sat, 25 Nov 2017 09:03:26 +0800
MIME-Version: 1.0
In-Reply-To: <20171124202608.11152-1-hans@knorrie.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="PqKhFUAavUjs6So71B0alsdGuWSVMjF70"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PqKhFUAavUjs6So71B0alsdGuWSVMjF70
Content-Type: multipart/mixed; boundary="TA1Ds0nxc1LlobFbr7Kpkw6hVCWR7cduN";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Hans van Kranenburg <hans@knorrie.org>, linux-btrfs@vger.kernel.org
Message-ID: <7166920a-17c1-cd00-23d8-cef0a1693ba5@gmx.com>
Subject: Re: [PATCH] btrfs-progs: dump_tree: remove superfluous _TREE
References: <20171124202608.11152-1-hans@knorrie.org>
In-Reply-To: <20171124202608.11152-1-hans@knorrie.org>

--TA1Ds0nxc1LlobFbr7Kpkw6hVCWR7cduN
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8825=E6=97=A5 04:26, Hans van Kranenburg wrote:
> -# btrfs inspect-internal dump-tree -t fs /dev/block/device
> ERROR: unrecognized tree id: fs
>=20
> Without this fix I can't dump-tree fs, but I can dump-tree fs_tree and
> also fs_tree_tree, which is a bit silly.
> ---
>  cmds-inspect-dump-tree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
> index 4e72c08a..df44bb63 100644
> --- a/cmds-inspect-dump-tree.c
> +++ b/cmds-inspect-dump-tree.c
> @@ -143,7 +143,7 @@ static u64 treeid_from_string(const char *str, cons=
t char **end)
>  		{ "CHUNK", BTRFS_CHUNK_TREE_OBJECTID },
>  		{ "DEVICE", BTRFS_DEV_TREE_OBJECTID },
>  		{ "DEV", BTRFS_DEV_TREE_OBJECTID },
> -		{ "FS_TREE", BTRFS_FS_TREE_OBJECTID },
> +		{ "FS", BTRFS_FS_TREE_OBJECTID },

Considering no other name has the _tree suffix, this looks good to me.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu
>  		{ "CSUM", BTRFS_CSUM_TREE_OBJECTID },
>  		{ "CHECKSUM", BTRFS_CSUM_TREE_OBJECTID },
>  		{ "QUOTA", BTRFS_QUOTA_TREE_OBJECTID },
>=20


--TA1Ds0nxc1LlobFbr7Kpkw6hVCWR7cduN--

--PqKhFUAavUjs6So71B0alsdGuWSVMjF70
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloYwV8XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qibWgf9Ff8J+tY0MjslAB/6frjN/qDx
Mmy7miLf7wsW15kxK2VD9jOSAT02PKlMmROnZh6Tl5ppFA55IeC+tt3Q3/SlO70v
Gp8X3xTrfrievGl/71RMlBOPxskEz4fKktNb3VVd3pq0ON/stCymV8SzOVLbiFT0
/Z1cnzJmS/CIpT6E1pME+6mjBIWYuPnlC8W9DMrtQVVe3dg6Iru9VMklJ3q8WYm8
/KGKCPO1fcGxIxFMe5pePMqZwNasrh1d2uZDs4eaRjnU/0ECH6bnQc8FLmhqeA6V
+7g0Bs7vifWdqH9C3kXlgjmpUnIrB9MN/EdtXJnC+CFRg4OppddHucS9VyhUTA==
=bPnG
-----END PGP SIGNATURE-----

--PqKhFUAavUjs6So71B0alsdGuWSVMjF70--
