Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:58685 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755009AbeAHIVo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Jan 2018 03:21:44 -0500
Subject: Re: [PATCH 2/3] btrfs: define SUPER_FLAG_METADUMP_V2
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Cc: wqu@suse.com
References: <20180108080421.17668-1-anand.jain@oracle.com>
 <20180108080421.17668-3-anand.jain@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <54854609-4a25-2b8b-3bab-ab18c1a14071@gmx.com>
Date: Mon, 8 Jan 2018 16:20:58 +0800
MIME-Version: 1.0
In-Reply-To: <20180108080421.17668-3-anand.jain@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="haJOq1eJE31WadgnzhjzOoQl17MCPiCaI"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--haJOq1eJE31WadgnzhjzOoQl17MCPiCaI
Content-Type: multipart/mixed; boundary="LE1cSYgtTiAbz7mr221rtwWOvy3wV40QM";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Cc: wqu@suse.com
Message-ID: <54854609-4a25-2b8b-3bab-ab18c1a14071@gmx.com>
Subject: Re: [PATCH 2/3] btrfs: define SUPER_FLAG_METADUMP_V2
References: <20180108080421.17668-1-anand.jain@oracle.com>
 <20180108080421.17668-3-anand.jain@oracle.com>
In-Reply-To: <20180108080421.17668-3-anand.jain@oracle.com>

--LE1cSYgtTiAbz7mr221rtwWOvy3wV40QM
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8808=E6=97=A5 16:04, Anand Jain wrote:
> btrfs-progs uses super flag bit BTRFS_SUPER_FLAG_METADUMP_V2 (1ULL << 3=
4).
> So just define that in kernel so that we know its been used. This patch=

> does not add it to BTRFS_SUPER_FLAG_SUPP yet.
>=20
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  include/uapi/linux/btrfs_tree.h | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs=
_tree.h
> index 6d6e5da51527..38ab0e06259a 100644
> --- a/include/uapi/linux/btrfs_tree.h
> +++ b/include/uapi/linux/btrfs_tree.h
> @@ -456,6 +456,7 @@ struct btrfs_free_space_header {
> =20
>  #define BTRFS_SUPER_FLAG_SEEDING	(1ULL << 32)
>  #define BTRFS_SUPER_FLAG_METADUMP	(1ULL << 33)
> +#define BTRFS_SUPER_FLAG_METADUMP_V2	(1ULL << 34)

Please also include this to BTRFS_SUPER_FLAG_SUPP.

It's quite common developers (at least myself) may try to mount a
recovered btrfs image.

(That's also the reason why the patch should be put before the
BTRFS_SUPER_FLAG_SUPP check patch)

Thanks,
Qu
> =20
> =20
>  /*
>=20


--LE1cSYgtTiAbz7mr221rtwWOvy3wV40QM--

--haJOq1eJE31WadgnzhjzOoQl17MCPiCaI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpTKeoXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgWYwgApHSTkUJt/o+W7W+dYnSVbtwa
311ElhR9qRm+HvWGjJo39lrCdsRAuJ6bebSCBS/FxAVePgL0tF6i9vd21EgEQefs
3FNYkkdHqWsn4OVDEl0wC9TSvtpKowZi+oTF/WUeLKil80rKd48qoV8OQy/hcXZw
tTQgDvBntnIvS9d+P5h7n7b2JOq5HXxKD9hjULBs6622t+fQuKsnDjHiV+TzkUax
F3r+yVyyOJgpj0Vk0rC2ay1Mv6TpRfo2NcR4ScKWnQgF+0M+E1uhc6MGPw7eiMFJ
4GUo0yKP/hjirHamM9ON2/9QEP9x544t+zjl2WoWEVvH4bxGcp6xCDiJjfXweA==
=LJ4J
-----END PGP SIGNATURE-----

--haJOq1eJE31WadgnzhjzOoQl17MCPiCaI--
