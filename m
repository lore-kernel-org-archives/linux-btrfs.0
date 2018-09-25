Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:45245 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbeIYMsw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Sep 2018 08:48:52 -0400
Subject: Re: [PATCH v2 0/9] Fix _scratch_mkfs_sized() for btrfs
To: Anand Jain <anand.jain@oracle.com>, fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
References: <1537849462-619-1-git-send-email-anand.jain@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <38de07d5-5e19-fe9a-4520-2f01d2f3f888@gmx.com>
Date: Tue, 25 Sep 2018 14:42:38 +0800
MIME-Version: 1.0
In-Reply-To: <1537849462-619-1-git-send-email-anand.jain@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="8TG2P4su6aazzThaOUU7NeWEVzVRIwSqB"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8TG2P4su6aazzThaOUU7NeWEVzVRIwSqB
Content-Type: multipart/mixed; boundary="HRZVeXRo6xWrSGn4nF4Ua1RWslUJA8Ego";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>, fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Message-ID: <38de07d5-5e19-fe9a-4520-2f01d2f3f888@gmx.com>
Subject: Re: [PATCH v2 0/9] Fix _scratch_mkfs_sized() for btrfs
References: <1537849462-619-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1537849462-619-1-git-send-email-anand.jain@oracle.com>

--HRZVeXRo6xWrSGn4nF4Ua1RWslUJA8Ego
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/9/25 =E4=B8=8B=E5=8D=8812:24, Anand Jain wrote:
> v1->v2: Fix the min size for _scratch_mkfs_sized() to 256MB for btrfs a=
nd
>          add comment about its ref.
> 	Fix _scratch_mkfs_sized() options to use at least 256MB in each
> 	 test case.
>         Update change long.
>=20
> Currently _scratch_mkfs_sized() checks if the requested size is below 1=
G
> for btrfs and forces the --mixed mkfs option. The 1G size cut off is to=
o
> larger where the actual size is ~256mb. The patch 1/9 fixes the
> _scratch_mkfs_sized() to check for 256mb instead.

=46rom the aspect of btrfs, the change to 256m totally makes sense and
avoids complex profile probing.

The patchset looks good to me.

Reviewed-by: Qu Wenruo <wqu@suse.com>

However I'm wondering if other fses is OK to increase the minimal fs size=
=2E
AFAIK btrfs has the largest minimal dev size requirement among
xfs/ext4/btrfs, so it should be OK, but still needs extra confirm from
xfs/ext4 people.

Thanks,
Qu

>=20
> Also fix the test cases requesting to create FS below 256mb. And open
> code the fssize computation where possible (that is the variable used
> is only used once).
>=20
> Further, there are test cases generic/250,252,256,416 which uses
> _scratch_mkfs_sized with < 200mb but its fix isn't straight forward
> and they are not yet ready for the review.
>=20
> The affected testcases (which calls _scratch_mkfs_sized) [1] have
> been tested on btrfs. And the test cases [2] which are being patches
> here are tested on xfs ext4 and btrfs for no regression.
>=20
> [1]
> generic/015 generic/027 generic/077 generic/081 generic/083 generic/085=
 generic/096 generic/102 generic/171 generic/172 generic/173 generic/174 =
generic/204 generic/224 generic/226 generic/250 generic/252 generic/256 g=
eneric/269 generic/270 generic/273 generic/274 generic/275 generic/300 ge=
neric/312 generic/320 generic/333 generic/334 generic/361 generic/371 gen=
eric/387 generic/399 generic/416 generic/427 generic/449 generic/459 gene=
ric/466 generic/488 generic/505 btrfs/004 btrfs/007 btrfs/132 btrfs/170
>=20
> [2]
> generic/015 generic/077 generic/083 generic/387 generic/449
>=20
> Anand Jain (9):
>   fstests: btrfs: _scratch_mkfs_sized fix min size without mixed option=

>   generic/015 fix to test the default non-mixed mode
>   geneirc/077 fix min size for btrfs
>   generic/083 fix btrfs fs size for default mode
>   generic/102 open code dev_size _scratch_mkfs_sized()
>   generic/204 open code SIZE for _scratch_mkfs_sized()
>   generic/312 open code fs_size _scratch_mkfs_sized()
>   generic/449 fix fs size for _scratch_mkfs_sized for btrfs
>   generic/387 fix _scratch_mkfs_sized option for btrfs
>=20
>  common/rc         | 4 +++-
>  tests/generic/015 | 8 +++-----
>  tests/generic/077 | 3 +--
>  tests/generic/083 | 2 +-
>  tests/generic/102 | 3 +--
>  tests/generic/204 | 3 +--
>  tests/generic/312 | 7 +++----
>  tests/generic/387 | 3 ++-
>  tests/generic/449 | 4 ++--
>  9 files changed, 17 insertions(+), 20 deletions(-)
>=20


--HRZVeXRo6xWrSGn4nF4Ua1RWslUJA8Ego--

--8TG2P4su6aazzThaOUU7NeWEVzVRIwSqB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlup2N4ACgkQwj2R86El
/qi9Iwf/Tyy/c0cboPBr/J2AawIMKuA4/bwqtwq6RoScQ+4nMOt8l3GSOtwuoU1h
WWxVGlLFnV4CJ2AFROFtPaCh/enlOrQQtoHIjmgwgXVq+O/ctrhuo402bHFV1ZF+
u0XTDNofyep4gXdfi1CYO8JwPdx3x3mYQILVK9qKZIzaKaTaXd+VphPTiTQMXbFD
8f3Tj8nOTDVNE11f4pO4LBQWFRl7TSDIb1SjQNXQQkyCOi7RKJ1wXQlbbZQTdqFr
nIIzC2KUvnc/Jbd40KPPLDCxJuikCc0XxkHbEA4ZNl7WFLotNB/KPTGJVYTc1WX5
K/6hkY4G17BKPoK/B6//IoS2PwOVnQ==
=fPm2
-----END PGP SIGNATURE-----

--8TG2P4su6aazzThaOUU7NeWEVzVRIwSqB--
