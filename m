Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:61095 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932111AbdJWLwB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Oct 2017 07:52:01 -0400
Subject: Re: [PATCH 2/2] btrfs: Move checks from btrfs_wq_run_delayed_node to
 btrfs_balance_delayed_items
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1508755909-16838-1-git-send-email-nborisov@suse.com>
 <1508755909-16838-2-git-send-email-nborisov@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <179dd6ce-92fe-d3d5-d124-012e1bcaa894@gmx.com>
Date: Mon, 23 Oct 2017 19:51:19 +0800
MIME-Version: 1.0
In-Reply-To: <1508755909-16838-2-git-send-email-nborisov@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="U7SOgu8L6GoQn7VGRcL67AjTW8dTUNBmB"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--U7SOgu8L6GoQn7VGRcL67AjTW8dTUNBmB
Content-Type: multipart/mixed; boundary="RmaT37akwnDkFaIuHV05kt1NkAGjImHHN";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <179dd6ce-92fe-d3d5-d124-012e1bcaa894@gmx.com>
Subject: Re: [PATCH 2/2] btrfs: Move checks from btrfs_wq_run_delayed_node to
 btrfs_balance_delayed_items
References: <1508755909-16838-1-git-send-email-nborisov@suse.com>
 <1508755909-16838-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1508755909-16838-2-git-send-email-nborisov@suse.com>

--RmaT37akwnDkFaIuHV05kt1NkAGjImHHN
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B410=E6=9C=8823=E6=97=A5 18:51, Nikolay Borisov wrote:
> btrfs_balance_delayed_items is the sole caller of btrfs_wq_run_delayed_=
node and
> already includes one of the checks whether the delayed inodes should be=
 run. On
> the other hand btrfs_wq_run_delayed_node duplicates that check and perf=
orms an
> additional one for wq congestion.
>=20
> Let's remove the duplicate check and move the congestion one in
> btrfs_balance_delayed_items, leaving btrfs_wq_run_delayed_node to only =
care
> about setting up the wq run. No functional changes.
>=20
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
btrfs_workqueue_normal_congested() is moved to the caller and removed
duplicated atomic_read().

Unless delayed_root->items get modified in the period, it should be good.=

But anyway, the original code has nothing to protect different
atomic_read(), so I don't think it will cause any new problem.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu
> ---
>  fs/btrfs/delayed-inode.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>=20
> diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> index 1bfdb90d7633..b7a0ec2c41e6 100644
> --- a/fs/btrfs/delayed-inode.c
> +++ b/fs/btrfs/delayed-inode.c
> @@ -1371,10 +1371,6 @@ static int btrfs_wq_run_delayed_node(struct btrf=
s_delayed_root *delayed_root,
>  {
>  	struct btrfs_async_delayed_work *async_work;
> =20
> -	if (atomic_read(&delayed_root->items) < BTRFS_DELAYED_BACKGROUND ||
> -	    btrfs_workqueue_normal_congested(fs_info->delayed_workers))
> -		return 0;
> -
>  	async_work =3D kmalloc(sizeof(*async_work), GFP_NOFS);
>  	if (!async_work)
>  		return -ENOMEM;
> @@ -1410,7 +1406,8 @@ void btrfs_balance_delayed_items(struct btrfs_fs_=
info *fs_info)
>  {
>  	struct btrfs_delayed_root *delayed_root =3D fs_info->delayed_root;
> =20
> -	if (atomic_read(&delayed_root->items) < BTRFS_DELAYED_BACKGROUND)
> +	if ((atomic_read(&delayed_root->items) < BTRFS_DELAYED_BACKGROUND) ||=

> +		btrfs_workqueue_normal_congested(fs_info->delayed_workers))
>  		return;
> =20
>  	if (atomic_read(&delayed_root->items) >=3D BTRFS_DELAYED_WRITEBACK) {=

>=20


--RmaT37akwnDkFaIuHV05kt1NkAGjImHHN--

--U7SOgu8L6GoQn7VGRcL67AjTW8dTUNBmB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnt17cXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjUFQgAihlJQMQ+y/sAzCDwlL5S6i9N
bkWyNOa4GRMKx86liH4UQCVNPvByxuRu3615ffczurv6MGd579Hn5ykv/jsyAQUw
6HFNNiKP2ocvDTwY45arwXVYQXMMzfKTQCEzJ2tCsCNTXm0785cEZwg3vXxCb7dg
0/y1kpXhuNoGsKvPW2a2wMqAgF6bYrlXUDgf79xwsguBp2/H/wFvjeo1Mcx5sbOA
RpgAg8301JHFO5fof8Bcl95hz0A80M93HVvRmKfQ26RZ4QoWO1h//TZAyl6BJjGW
Gbuj8ADmcgR8T0Qr7mnOtaWGUUeIOUpK3XpPmj5pBVZ0byQVP63ucWyD5llfmg==
=caQA
-----END PGP SIGNATURE-----

--U7SOgu8L6GoQn7VGRcL67AjTW8dTUNBmB--
