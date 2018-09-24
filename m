Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:40205 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727229AbeIXRDJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Sep 2018 13:03:09 -0400
Subject: Re: [PATCH 2/9] generic/015 fix to test the default non-mixed mode
To: Anand Jain <anand.jain@oracle.com>, fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
References: <1537784193-24431-1-git-send-email-anand.jain@oracle.com>
 <1537784193-24431-3-git-send-email-anand.jain@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <77bfb6a5-f2a7-245c-823c-1c44b15165dc@gmx.com>
Date: Mon, 24 Sep 2018 19:01:28 +0800
MIME-Version: 1.0
In-Reply-To: <1537784193-24431-3-git-send-email-anand.jain@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2adqa8HPFqNrjkRcQIVbnv6m0YiWO9Uaz"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2adqa8HPFqNrjkRcQIVbnv6m0YiWO9Uaz
Content-Type: multipart/mixed; boundary="IeLIUs3QwflpgJfDwr8hTZ55mf9Rgcvp1";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>, fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Message-ID: <77bfb6a5-f2a7-245c-823c-1c44b15165dc@gmx.com>
Subject: Re: [PATCH 2/9] generic/015 fix to test the default non-mixed mode
References: <1537784193-24431-1-git-send-email-anand.jain@oracle.com>
 <1537784193-24431-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1537784193-24431-3-git-send-email-anand.jain@oracle.com>

--IeLIUs3QwflpgJfDwr8hTZ55mf9Rgcvp1
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/9/24 =E4=B8=8B=E5=8D=886:16, Anand Jain wrote:
> commit 97575acd7495 (generic/015: Change the test filesystem size to
> 101mb), created 101mb FS instead of 100mb FS to make sure we create
> a FS which is non mixed mode, which is our default mode.
>=20
> btrfs-progs commit 18e2663db3e1 (btrfs-progs: Add minimum device size
> check) added a more accurate minimum required space to create the btrfs=

> FS in non mixed mode. Which is at 14294784 bytes.
>=20
> So this patch changes the FS size to be created by _scratch_sized_mkfs
> to 200mb so that we create the FS in non mixed mode.
>=20
> To test mixed blockgroup its better we set it using the MKFS_OPTIONS
> explicitly.
>=20
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  tests/generic/015 | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
>=20
> diff --git a/tests/generic/015 b/tests/generic/015
> index 0f4d29800f4f..14941ab6d552 100755
> --- a/tests/generic/015
> +++ b/tests/generic/015
> @@ -37,11 +37,10 @@ _supported_os Linux
>  _require_scratch
>  _require_no_large_scratch_dev
> =20
> -# With filesystems less than 100mb btrfs is created in mixed mode
> -# which can lead to slight accounting errors of 1mb. Having the
> -# fs be at least 101 mb ensures those errors are within the error
> -# tolerance of 1%
> -_scratch_mkfs_sized `expr 101 \* 1024 \* 1024` >/dev/null 2>&1 \
> +# With filesystems less than ~200mb _scratch_mkfs_sized will create
> +# data and metadata mixed mode btrfs, so use 200mb so that we test
> +# the default btrfs.
> +_scratch_mkfs_sized $((200 * 1024 * 1024)) >> $seqres.full 2>&1 \
>      || _fail "mkfs failed"

Just as mentioned in the first patch, the minimal size for non-mixed
btrfs depends on mkfs profile.

Metadata DUP and data DUP would fail using 200M mkfs size:

 $ mkfs.btrfs  -m DUP -d DUP -b 200M /dev/data/btrfs -f
 btrfs-progs v4.17.1
 See http://btrfs.wiki.kernel.org for more information.

 ERROR: size 209715200 is too small to make a usable filesystem
 ERROR: minimum size for btrfs filesystem is 240123904

This problem applies to all patches, unfortunately.

Thanks,
Qu

>  _scratch_mount
>  out=3D$SCRATCH_MNT/fillup.$$
>=20


--IeLIUs3QwflpgJfDwr8hTZ55mf9Rgcvp1--

--2adqa8HPFqNrjkRcQIVbnv6m0YiWO9Uaz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAluoxAkACgkQwj2R86El
/qhUWAf/ZKycoXTiZeR8iO0mdDR612eL2cIVai4ZuubgCMgmJMyytp2zGakU5ABb
KnpRtcdh2grX0ln6gWA0T9VtQltGYC6hVQ0bcUNWGYWPEVQIqANv1undxw9bhSjo
Os/PHRwd3efx0OwlXXIHwUvlY+qrppInJDJ8wWTyVv3p38bN1E9bN/g0VMxrRLiC
EwyGCQWy5FZXEQEsRlMB/jgLxrzSDfvq/qViNUeaqh51YX6Ypg+UwklPcbjh1701
6yfGQmaD0w/v1QjZUSwRbm9wJ7Rva9LMNSSrA0Dfbx24DGWJltL7uzSgXKiSpVci
9pq1ZuQrFYCMmfeQfBJze4FEXpOZxA==
=SDDd
-----END PGP SIGNATURE-----

--2adqa8HPFqNrjkRcQIVbnv6m0YiWO9Uaz--
