Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:34913 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725975AbeGRHhE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jul 2018 03:37:04 -0400
Subject: Re: [PATCH 00/19] qgroup unused parameter cleanup
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180718064542.2730-1-lufq.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <69f60eb9-5769-45f6-bd9b-a5ac63815c4b@gmx.com>
Date: Wed, 18 Jul 2018 15:00:31 +0800
MIME-Version: 1.0
In-Reply-To: <20180718064542.2730-1-lufq.fnst@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="omnyfSF2Q5ePyxwFhqMK2A1Lpk7JH4Skm"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--omnyfSF2Q5ePyxwFhqMK2A1Lpk7JH4Skm
Content-Type: multipart/mixed; boundary="4DYXdVf3PSOm5t58G4xPtjldM2p2MDFl3";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <69f60eb9-5769-45f6-bd9b-a5ac63815c4b@gmx.com>
Subject: Re: [PATCH 00/19] qgroup unused parameter cleanup
References: <20180718064542.2730-1-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180718064542.2730-1-lufq.fnst@cn.fujitsu.com>

--4DYXdVf3PSOm5t58G4xPtjldM2p2MDFl3
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8818=E6=97=A5 14:45, Lu Fengqi wrote:
> The transaction handler can provide fs_info, so we can fetch fs_info or=

> quota_root(indirectly) from trans. Just remove the redundant parameter
> from qgroup functions.
>=20
> No functional change.

The whole serious looks pretty good.

Although for some call sites, we have extra check on NULL trans and
return -EINVAL (should be ASSERT though).
Maybe it's a good time to remove that paranoid check?

Thanks,
Qu

>=20
> Lu Fengqi (19):
>   btrfs: qgroup: Drop quota_root parameter from add_qgroup_relation_ite=
m
>   btrfs: qgroup: Drop quota_root parameter from del_qgroup_relation_ite=
m
>   btrfs: qgroup: Drop quota_root parameter from del_qgroup_item
>   btrfs: qgroup: Drop root parameter from update_qgroup_limit_item
>   btrfs: qgroup: Drop root parameter from update_qgroup_info_item
>   btrfs: qgroup: Drop quota_root and fs_info parameters from
>     update_qgroup_status_item
>   btrfs: qgroup: Drop fs_info parameter from btrfs_add_qgroup_relation
>   btrfs: qgroup: Drop fs_info parameter from __del_qgroup_relation
>   btrfs: qgroup: Drop fs_info parameter from btrfs_del_qgroup_relation
>   btrfs: qgroup: Drop fs_info parameter from btrfs_create_qgroup
>   btrfs: qgroup: Drop fs_info parameter from btrfs_remove_qgroup
>   btrfs: qgroup: Drop fs_info parameter from btrfs_limit_qgroup
>   btrfs: qgroup: Drop fs_info parameter from btrfs_qgroup_trace_extent
>   btrfs: qgroup: Drop fs_info parameter from
>     btrfs_qgroup_trace_leaf_items
>   btrfs: qgroup: Drop root parameter from btrfs_qgroup_trace_subtree
>   btrfs: qgroup: Drop fs_info parameter from btrfs_qgroup_account_exten=
t
>   btrfs: qgroup: Drop fs_info parameter from btrfs_run_qgroups
>   btrfs: qgroup: Drop fs_info parameter from btrfs_qgroup_inherit
>   btrfs: qgroup: Drop fs_info parameter from qgroup_rescan_leaf
>=20
>  fs/btrfs/extent-tree.c        |   4 +-
>  fs/btrfs/ioctl.c              |  18 ++--
>  fs/btrfs/qgroup.c             | 163 +++++++++++++++++-----------------=

>  fs/btrfs/qgroup.h             |  40 ++++-----
>  fs/btrfs/relocation.c         |   5 +-
>  fs/btrfs/tests/qgroup-tests.c |  24 ++---
>  fs/btrfs/transaction.c        |   5 +-
>  fs/btrfs/tree-log.c           |   2 +-
>  8 files changed, 123 insertions(+), 138 deletions(-)
>=20


--4DYXdVf3PSOm5t58G4xPtjldM2p2MDFl3--

--omnyfSF2Q5ePyxwFhqMK2A1Lpk7JH4Skm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltO5Y8ACgkQwj2R86El
/qgUZQf+ITuyy0sMaMtaomzNBaS9bL3KnNxpr6LrfNeGZDbRcnL5r/ZdPLyYnuZL
pf10oQWAFPjw3cQKHWzoPzixrFoo9btvRqoK+Gw7qByw23CGZ8Cf31+s9ZvjBn1w
ixvUGsUbGVHrt1JdjQKcyLo9YZf6feECZkK4W2/BgtAmnl1qvxCfhw+udAilttoq
u8dA3Q7PGoZt6m6iDn5q+7zvnzHJPyvFrmjmDgzNpAbio9FqZ3oVINRrDtZW2l4l
zZ5WoTmEfMXt9tEStERo6P5O5aXoJdpOAJRL6B8UmGYmD3JbBmNNXxD/o7DPHKwq
LrxbWVJPXIW8CU5KCOoR9ZjUqzyVPg==
=6sFJ
-----END PGP SIGNATURE-----

--omnyfSF2Q5ePyxwFhqMK2A1Lpk7JH4Skm--
