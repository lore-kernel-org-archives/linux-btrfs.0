Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:54808 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752711AbdLEJO4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Dec 2017 04:14:56 -0500
Subject: Re: [PATCH 4/7] btrfs-progs: Use list_for_each_entry in
 write_dev_all_supers
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1512463189-24724-1-git-send-email-nborisov@suse.com>
 <1512463189-24724-5-git-send-email-nborisov@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <21bc180f-83ca-2be8-8c41-ea1e86dca0fe@gmx.com>
Date: Tue, 5 Dec 2017 17:14:47 +0800
MIME-Version: 1.0
In-Reply-To: <1512463189-24724-5-git-send-email-nborisov@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="kurRQhraRbm6qJ086XrARHuIpsWJpoTJe"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kurRQhraRbm6qJ086XrARHuIpsWJpoTJe
Content-Type: multipart/mixed; boundary="2TvUvAA198XtIgHpGtsdXp0nPF1bIk9SW";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <21bc180f-83ca-2be8-8c41-ea1e86dca0fe@gmx.com>
Subject: Re: [PATCH 4/7] btrfs-progs: Use list_for_each_entry in
 write_dev_all_supers
References: <1512463189-24724-1-git-send-email-nborisov@suse.com>
 <1512463189-24724-5-git-send-email-nborisov@suse.com>
In-Reply-To: <1512463189-24724-5-git-send-email-nborisov@suse.com>

--2TvUvAA198XtIgHpGtsdXp0nPF1bIk9SW
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8805=E6=97=A5 16:39, Nikolay Borisov wrote:
> No need to use extra variable and 2 macros when we can succintly use 1.=

>=20
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Straightforward cleanup.

Although I found several other places with the same problem.

It would be better to address them all in one patch.
(3 in volumes.c 1 in utils.c and 1 in cmds-filesystem.c)

Thanks,
Qu
> ---
>  disk-io.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>=20
> diff --git a/disk-io.c b/disk-io.c
> index f5edc4796619..3d8785d5bb37 100644
> --- a/disk-io.c
> +++ b/disk-io.c
> @@ -1556,7 +1556,6 @@ static int write_dev_supers(struct btrfs_fs_info =
*fs_info,
> =20
>  int write_all_supers(struct btrfs_fs_info *fs_info)
>  {
> -	struct list_head *cur;
>  	struct list_head *head =3D &fs_info->fs_devices->devices;
>  	struct btrfs_device *dev;
>  	struct btrfs_super_block *sb;
> @@ -1566,8 +1565,7 @@ int write_all_supers(struct btrfs_fs_info *fs_inf=
o)
> =20
>  	sb =3D fs_info->super_copy;
>  	dev_item =3D &sb->dev_item;
> -	list_for_each(cur, head) {
> -		dev =3D list_entry(cur, struct btrfs_device, dev_list);
> +	list_for_each_entry(dev, head, dev_list) {
>  		if (!dev->writeable)
>  			continue;
> =20
>=20


--2TvUvAA198XtIgHpGtsdXp0nPF1bIk9SW--

--kurRQhraRbm6qJ086XrARHuIpsWJpoTJe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlomY4cXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjbPwf/eAcvD41WYIK3+9fR8GvCeBHW
rhbdO0Efe7lCncOUmsbLh46cAjc5bPuaFcNrkfM7n/TUW4ebJ+cA8DIuTBC3Xy2A
AFavYwU9WBV16ODfQ9QMhdmXhYPAfCPaUFDvUdAymcpoZuEwKmUvllG++FyVacXS
Ch7En32Cme/mO+wx2bFc2kCd/ke8oWsrHtK4+B6Og0rRf40GodrOvmByjGUD8SyG
AY39Qiw3eBgGO4EU4/cqm2mVV0oKm5KbdaVXzrLfEE3spkx5JQArKQqpGddfjwQ3
Chl7I6omG9Meu4gakHsWgiICJl5ASw5NM3Zv/pBiW5qZ4o6UE9tSpF11cTdL6g==
=svhW
-----END PGP SIGNATURE-----

--kurRQhraRbm6qJ086XrARHuIpsWJpoTJe--
