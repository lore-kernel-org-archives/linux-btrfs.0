Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:50050 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752232AbeAZITC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 03:19:02 -0500
Subject: Re: [PATCH v2 0/7] btrfs-progs: Do some clean up to be consistent
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <1516951566-21777-1-git-send-email-gujx@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <ea189b02-035e-7e27-20f0-08691bf2b83a@gmx.com>
Date: Fri, 26 Jan 2018 16:18:55 +0800
MIME-Version: 1.0
In-Reply-To: <1516951566-21777-1-git-send-email-gujx@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="0iMSIZUoqAbq171rtMiPOuAKNfsKfPHz0"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0iMSIZUoqAbq171rtMiPOuAKNfsKfPHz0
Content-Type: multipart/mixed; boundary="JUPir69xZMYaNGZnjVa6LOtWbsK6xuBph";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <ea189b02-035e-7e27-20f0-08691bf2b83a@gmx.com>
Subject: Re: [PATCH v2 0/7] btrfs-progs: Do some clean up to be consistent
References: <1516951566-21777-1-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1516951566-21777-1-git-send-email-gujx@cn.fujitsu.com>

--JUPir69xZMYaNGZnjVa6LOtWbsK6xuBph
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8826=E6=97=A5 15:25, Gu Jinxiang wrote:
> Patch 1~4 and 7: clean up use of btrfs_root.
> Patch 5: remove redundancy value assignment.
> Patch 6: remove no longer be used function define.

Overall it looks good, just one small nitpick, which should not need
another update.

> Changelog:
> v2->v1:
> Patch 2,4: To be consistent with kernel, change macro to inline functio=
n.
> Patch 3:
> 	Change macro to inline function to be consistent with kernel.
> 	And change the function body to match kernel.
>=20
> Gu Jinxiang (7):
>   btrfs-progs: Use fs_info instead of root for BTRFS_LEAF_DATA_SIZE
>   btrfs-progs: Use fs_info instead of root for BTRFS_NODEPTRS_PER_BLOCK=

>   btrfs-progs: Use fs_info instead of root for
>     BTRFS_MAX_INLINE_DATA_SIZE

Not only this patch modified the parameter but also sync the code with
kernel.
It would be better to mention it in commit message, but anyway, just a
small nitpick, nothing to worry about.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

>   btrfs-progs: Use fs_info instead of root for BTRFS_MAX_XATTR_SIZE
>   btrfs-progs: do clean up for redundancy value assignment
>   btrfs-progs: remove no longer be used btrfs_alloc_extent
>   btrfs-progs: Cleanup use of root in leaf_data_end
>=20
>  cmds-check.c              | 10 ++---
>  convert/source-ext2.c     |  4 +-
>  convert/source-reiserfs.c |  6 +--
>  ctree.c                   | 96 +++++++++++++++++++++++++--------------=
--------
>  ctree.h                   | 45 +++++++++++++---------
>  dir-item.c                |  3 +-
>  extent-tree.c             |  1 -
>  file-item.c               |  2 +-
>  mkfs/main.c               |  4 +-
>  print-tree.c              |  2 +-
>  quick-test.c              |  2 +-
>  volumes.c                 |  2 +-
>  12 files changed, 97 insertions(+), 80 deletions(-)
>=20


--JUPir69xZMYaNGZnjVa6LOtWbsK6xuBph--

--0iMSIZUoqAbq171rtMiPOuAKNfsKfPHz0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpq5G8XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhabQgAmeRE4nuEgvn3+6UNak1DDKim
sWDAviup+VfzOLpFHMI6fE6MlnKxFI7wPJtTnCEGMSO8Hlo1aDeMWyd0pdK6a/GP
tmSxW/4Bt9d1uykDn4RoyLb+XMJ0kEdiIfGFpxvDzk26l+QhGRq7GXJcqYO3bm5p
+1zP32BtSySY0/9m/y47s3z2YHq/F0xyISkdVsKoxRFHeAYa1l9URl4tumQDPJSz
YJytF7GqAGpwK2p+EAZzA7hRvRyj5Dk9wZDKfIZydJ9+U7oEj/64uc+M3IopxrD/
DpgyKDEXr6VpXd2fb1bhLintbxUIFQ41nhm+2h2YTYH1bdIGMkN0fMYdQVxpzg==
=Uj0v
-----END PGP SIGNATURE-----

--0iMSIZUoqAbq171rtMiPOuAKNfsKfPHz0--
