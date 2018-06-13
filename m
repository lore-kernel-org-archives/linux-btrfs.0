Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:43393 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754462AbeFMHYK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Jun 2018 03:24:10 -0400
Subject: Re: [PATCH REBASED 0/2] btrfs: Delay block group auto removal to
 avoid interfering qgroups
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180530044023.9192-1-wqu@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <a6a2c402-e6d5-5081-2ddb-390fb897cfff@gmx.com>
Date: Wed, 13 Jun 2018 15:23:58 +0800
MIME-Version: 1.0
In-Reply-To: <20180530044023.9192-1-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Tl0qWmbt3ZzZ1lZpU7VH2LFt6Y66TyKLw"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Tl0qWmbt3ZzZ1lZpU7VH2LFt6Y66TyKLw
Content-Type: multipart/mixed; boundary="XGOPUokVtmXGGcpQjP7LsdqdPfdMGsZrV";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <a6a2c402-e6d5-5081-2ddb-390fb897cfff@gmx.com>
Subject: Re: [PATCH REBASED 0/2] btrfs: Delay block group auto removal to
 avoid interfering qgroups
References: <20180530044023.9192-1-wqu@suse.com>
In-Reply-To: <20180530044023.9192-1-wqu@suse.com>

--XGOPUokVtmXGGcpQjP7LsdqdPfdMGsZrV
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi David,

Please ignore this patchset.

The fix can only reduce the possibility of the problem, but not really
fix it.

Although the root cause of the problem is still pretty the same, that
btrfs_delete_unused_bgs() deletes some block groups still in usage.

However it's not just about the transid.
It's about the block_group->pinned bytes.

Currently btrfs_delete_unused_bgs() only uses used_bytes in block group
item, while it's still possible for delalloc to pin down some metadata
bytes several transactions ago.

In that case, delayed block group auto removal won't help much.

The true fix should teach btrfs_delete_unused_bgs() to skip block groups
with pinned bytes.

I'll send another fix for this bug.

Thanks,
Qu

On 2018=E5=B9=B405=E6=9C=8830=E6=97=A5 12:40, Qu Wenruo wrote:
> The patchset can be fetched from github:
> https://github.com/adam900710/linux/tree/delayed_bg_removal
>=20
> It's based on David's misc-next branch, HEAD is:
> commit c77a75861d82a497bd1a26054588cd9af59eb5db (david/misc-next)
> Author: Ethan Lien <ethanlien@synology.com>
> Date:   Mon May 28 13:48:20 2018 +0800
>=20
>     btrfs: balance dirty metadata pages in btrfs_finish_ordered_io
>=20
>=20
> This bug is reported from SUSE openQA, although it's pretty hard to hit=

> in real world (even real world VM), it's believed block group auto
> removal (anyway, there isn't much thing can remove a chunk mapping in
> btrfs) could interfere with qgroup's search on commit root.
>=20
> Full details can be found in the 2rd patch.
>=20
> The patchset uses 1 submitted cleanup/refactor patches as basis, and th=
e
> 2nd patch will ensure unused block group will only be deleted after
> current transaction is done.
>=20
>=20
> Qu Wenruo (2):
>   btrfs: Use btrfs_mark_bg_unused() to replace open code
>   btrfs: Delayed empty block group auto removal to next transaction
>=20
>  fs/btrfs/ctree.h       |  2 ++
>  fs/btrfs/extent-tree.c | 62 +++++++++++++++++++++++++++++-------------=

>  fs/btrfs/scrub.c       |  9 +-----
>  fs/btrfs/transaction.c |  7 +++++
>  fs/btrfs/transaction.h | 10 +++++++
>  5 files changed, 63 insertions(+), 27 deletions(-)
>=20


--XGOPUokVtmXGGcpQjP7LsdqdPfdMGsZrV--

--Tl0qWmbt3ZzZ1lZpU7VH2LFt6Y66TyKLw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlsgxo4ACgkQwj2R86El
/qglgQf+Of7xd1we46Q9vy1J2pfY3ksunsB1b3nmP/65iocm9IKTiwf2/H1NWElW
Tw1cGSUSKdtMNYzVVS/rrIISBm5ccpFdWlVVvAw6dmA/aPbWNYX086uLIU789bQ6
sErACMAUNsWnvrHSCtvFAccZhYZkoroysWatcl6zKgohuwoJ0CloG76I3ZI2tFZf
0UMDPMS9zyIKUA5Ul8x1OEeXAokRS07SsXsdWp000EamHkaOXKCO5gHfa+cJ1oer
8LQ8WGTIF+J4iEF3WdiOw3egipel0rtrdfpRIwCJYPgoeqbaHksida4dIF6FBHnB
7fB3xnzkNRp6CAwTiIgxsuAhPAJq4Q==
=TJYK
-----END PGP SIGNATURE-----

--Tl0qWmbt3ZzZ1lZpU7VH2LFt6Y66TyKLw--
