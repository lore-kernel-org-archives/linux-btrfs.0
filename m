Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:41961 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750841AbeERF2A (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 May 2018 01:28:00 -0400
Subject: Re: [PATCH v2 4/6] Btrfs: remove unused check of skip_locking
To: Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
References: <1526612424-97061-1-git-send-email-bo.liu@linux.alibaba.com>
 <1526612424-97061-5-git-send-email-bo.liu@linux.alibaba.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <36bc953d-f9c7-fb58-d31e-09f610ad90be@gmx.com>
Date: Fri, 18 May 2018 13:27:50 +0800
MIME-Version: 1.0
In-Reply-To: <1526612424-97061-5-git-send-email-bo.liu@linux.alibaba.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="fcJcEEKBLxXSUvR9EJ4ofZW5TvDf2Ckdo"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fcJcEEKBLxXSUvR9EJ4ofZW5TvDf2Ckdo
Content-Type: multipart/mixed; boundary="7aUIXrQnZlllnGEN39AvAIvTuGdBuwIei";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
Message-ID: <36bc953d-f9c7-fb58-d31e-09f610ad90be@gmx.com>
Subject: Re: [PATCH v2 4/6] Btrfs: remove unused check of skip_locking
References: <1526612424-97061-1-git-send-email-bo.liu@linux.alibaba.com>
 <1526612424-97061-5-git-send-email-bo.liu@linux.alibaba.com>
In-Reply-To: <1526612424-97061-5-git-send-email-bo.liu@linux.alibaba.com>

--7aUIXrQnZlllnGEN39AvAIvTuGdBuwIei
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8818=E6=97=A5 11:00, Liu Bo wrote:
> The check is superfluous since all of callers who set search_for_commit=

> also have skip_locking set.
>=20
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Although more obvious comment about search_commit_root and skip_locking
in ctree.h will be much better.

Thanks,
Qu

> ---
>  fs/btrfs/ctree.c | 2 --
>  1 file changed, 2 deletions(-)
>=20
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index d12fc0474e21..8d3b09038f37 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -2623,8 +2623,6 @@ static struct extent_buffer *btrfs_search_slot_ge=
t_root(struct btrfs_root *root,
>  		level =3D btrfs_header_level(b);
>  		if (p->need_commit_sem)
>  			up_read(&fs_info->commit_root_sem);
> -		if (!p->skip_locking)
> -			btrfs_tree_read_lock(b);
> =20
>  		goto out;
>  	}
>=20


--7aUIXrQnZlllnGEN39AvAIvTuGdBuwIei--

--fcJcEEKBLxXSUvR9EJ4ofZW5TvDf2Ckdo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlr+ZFYACgkQwj2R86El
/qgnPQf9Gq3dh1WkWzSLeoKW8iILqLTKlEKguo9mXHPuU5bzvPG8Zfhp9kGXTZ44
4iTtBiKpxPOprOSs6JpHRnK6+CtFzilHlYXnonDQ9Xf7UWVLyCcPjCFRvRyhaubM
YMRfQFvwLsp0bP5qL4yM8aqwrAG/qm4XNxK2+lD6Bl4QYC4KGXZdO+CJ8pDLQJn0
X7Wyr0B6opeTCo5NOhc7/ahBZWMqjTU5tN/0lNnZTdnfHwed8LJNYGwjfR0jgLXp
VE/UigMiz5gU/2OggyyKsTyV/19t4WUCjk55FYhk7Wr4bRQ31Ww8S8YI3kQy8aQ/
bKgODokuksJjBZVWHFcIBGOmbwrP7Q==
=PvOp
-----END PGP SIGNATURE-----

--fcJcEEKBLxXSUvR9EJ4ofZW5TvDf2Ckdo--
