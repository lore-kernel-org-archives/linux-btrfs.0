Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:37167 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727322AbeHWDyn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Aug 2018 23:54:43 -0400
Subject: Re: [PATCH 0/5] rb_first to rb_first_cached conversion
To: Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
References: <1534967513-117382-1-git-send-email-bo.liu@linux.alibaba.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <46cdfa7d-7277-69ac-9aa6-dfb63a6982ad@gmx.com>
Date: Thu, 23 Aug 2018 08:27:32 +0800
MIME-Version: 1.0
In-Reply-To: <1534967513-117382-1-git-send-email-bo.liu@linux.alibaba.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="efaEHiF6tl92yV30g7YEq00FS7tqp8WKg"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--efaEHiF6tl92yV30g7YEq00FS7tqp8WKg
Content-Type: multipart/mixed; boundary="80oGc6yTvW3Ph7gZNDQZLUuLenJNXgbjd";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
Message-ID: <46cdfa7d-7277-69ac-9aa6-dfb63a6982ad@gmx.com>
Subject: Re: [PATCH 0/5] rb_first to rb_first_cached conversion
References: <1534967513-117382-1-git-send-email-bo.liu@linux.alibaba.com>
In-Reply-To: <1534967513-117382-1-git-send-email-bo.liu@linux.alibaba.com>

--80oGc6yTvW3Ph7gZNDQZLUuLenJNXgbjd
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/8/23 =E4=B8=8A=E5=8D=883:51, Liu Bo wrote:
> Several structs in btrfs are using rb_first() in a while loop, it'd be
> more efficient to do this with rb_first_cached() which has the O(1)
> complexity.

I'm a little curious about such rb_first() inside loop usage.

What I can find is mostly deletion + iteration code for rb_tree.
Like btrfs_free_qgroup_config() or btrfs_qgroup_account_extents().

I'm wondering if there is any special way to do it faster for such usage.=

Or rb_tree_cached is the only solution here.

Thanks,
Qu

>=20
> This patch set updates five structs which may have a large rb tree in
> practice
>=20
> Liu Bo (5):
>   Btrfs: href_root: use rb_first_cached
>   Btrfs: href->ref_tree: use rb_first_cached
>   Btrfs: delayed_items: use rb_first_cached
>   Btrfs: extent_map: use rb_first_cached
>   Btrfs: preftree: use rb_first_cached
>=20
>  fs/btrfs/backref.c                | 34 +++++++++++++-------------
>  fs/btrfs/delayed-inode.c          | 29 +++++++++++++----------
>  fs/btrfs/delayed-inode.h          |  4 ++--
>  fs/btrfs/delayed-ref.c            | 50 +++++++++++++++++++++++--------=
--------
>  fs/btrfs/delayed-ref.h            |  4 ++--
>  fs/btrfs/disk-io.c                |  8 +++----
>  fs/btrfs/extent-tree.c            | 19 ++++++++-------
>  fs/btrfs/extent_map.c             | 27 +++++++++++----------
>  fs/btrfs/extent_map.h             |  2 +-
>  fs/btrfs/inode.c                  |  4 ++--
>  fs/btrfs/tests/extent-map-tests.c |  4 ++--
>  fs/btrfs/transaction.c            |  5 ++--
>  fs/btrfs/volumes.c                |  5 ++--
>  13 files changed, 107 insertions(+), 88 deletions(-)
>=20


--80oGc6yTvW3Ph7gZNDQZLUuLenJNXgbjd--

--efaEHiF6tl92yV30g7YEq00FS7tqp8WKg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlt9/3QACgkQwj2R86El
/qjyOggAsUDhBntvTMyYA10Fmz47pOyRPkPYhVfdU00I2T3zLTt2IfA3kjRMXFgq
n4egpetlQ6BNd1htJgtwGadALFmqlwAzxdke+U6TlqQqYgdPkYC4l5reYtsN/BzW
mXBa/X79MUYgjbZjwhAx1arD7a4m0t1AgmamTVLlD0DBlKOiHH2k4fYejUl/uPMN
Y16HgdM9K8NU58fw6DhYtmg6rtpHyu2nmEQJKR0Z/isWxneXembwMkBVsiclbwPb
EATTXyfkVd5v/iMxSgzuBkHEzrluQG5afU5qNB4t4KI4/xd+e8LpyL1NiGvCxMLI
iJtRA8JRqfGP0owtmk+ylu1jA4b82w==
=x7HV
-----END PGP SIGNATURE-----

--efaEHiF6tl92yV30g7YEq00FS7tqp8WKg--
