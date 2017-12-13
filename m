Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:57455 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752880AbdLMAzk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Dec 2017 19:55:40 -0500
Subject: Re: [PATCH 00/14] Qgroup metadata reservation rework
To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, jeffm@suse.com
References: <20171212073436.16447-1-wqu@suse.com>
 <4c56a262-51fb-b66d-3d1b-f4b0a906cef5@suse.com>
 <20171212180157.GO3553@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <8613b2ed-5345-4e21-3b61-0a8da3dcb831@gmx.com>
Date: Wed, 13 Dec 2017 08:54:56 +0800
MIME-Version: 1.0
In-Reply-To: <20171212180157.GO3553@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="8mnNN0s9HaMIIxgC5nwLKCMd7r2HqgB5G"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8mnNN0s9HaMIIxgC5nwLKCMd7r2HqgB5G
Content-Type: multipart/mixed; boundary="LrpeihobKaR0sIkmT2apo5rh4n5PHUD03";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
 Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, jeffm@suse.com
Message-ID: <8613b2ed-5345-4e21-3b61-0a8da3dcb831@gmx.com>
Subject: Re: [PATCH 00/14] Qgroup metadata reservation rework
References: <20171212073436.16447-1-wqu@suse.com>
 <4c56a262-51fb-b66d-3d1b-f4b0a906cef5@suse.com>
 <20171212180157.GO3553@twin.jikos.cz>
In-Reply-To: <20171212180157.GO3553@twin.jikos.cz>

--LrpeihobKaR0sIkmT2apo5rh4n5PHUD03
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8813=E6=97=A5 02:01, David Sterba wrote:
> On Tue, Dec 12, 2017 at 04:16:08PM +0200, Nikolay Borisov wrote:
>>
>>
>> On 12.12.2017 09:34, Qu Wenruo wrote:
>>> [Overall]
>>> The previous rework on qgroup reservation system put a lot of effort =
on
>>> data, which works quite fine.
>>>
>>> But it takes less focus on metadata reservation, causing some problem=

>>> like metadata reservation underflow and noisy kernel warning.
>>>
>>> This patchset will try to address the remaining problem of metadata
>>> reservation.
>>>
>>> The idea of new qgroup metadata reservation is to use 2 types of
>>> metadata reservation:
>>> 1) Per-transaction reservation
>>>    Life span will be inside a transaction. Will be freed at transacti=
on
>>>    commit time.
>>>
>>> 2) Preallocated reservation
>>>    For case where we reserve space before starting a transaction.
>>>    Operation like dealloc and delayed-inode/item belongs to this type=
=2E
>>>
>>>    This works similar to block_rsv, its reservation can be
>>>    reserved/released at any timing caller like.
>>>
>>>    The only point to notice is, if preallocated reservation is used a=
nd
>>>    finished without problem, it should be converted to per-transactio=
n
>>>    type instead of just freeing.
>>>    This is to co-operate with qgroup update at commit time.
>>>
>>> For preallocated type, this patch will integrate them into inode_rsv
>>> mechanism reworked by Josef, and delayed-inode/item reservation.
>>>
>>>
>>> [Problem: Over-reserve]
>>> Currently the patchset addresses metadata underflow quite well, but
>>> due to the over-reserve nature of btrfs and highly bounded to inode_r=
sv,
>>> qgroup metadata reservation also tends to be over-reserved.
>>>
>>> This is especially obvious for small limit.
>>> For 128M limit, it's will only be able to write about 70M before hitt=
ing
>>> quota limit.
>>> Although for larger limit, like 5G limit, it can reach 4.5G or more
>>> before hitting limit.
>>>
>>> Such over-reserved behavior can lead to some problem with existing te=
st
>>> cases (where limit is normally less than 20M).
>>>
>>> While it's also possible to be addressed by use more accurate space o=
ther
>>> than max estimations.
>>>
>>> For example, to calculate metadata needed for delalloc, we use
>>> btrfs_calc_trans_metadata_size(), which always try to reserve space f=
or
>>> CoW a full-height tree, and will also include csum size.
>>> Both calculate is way over-killed for qgroup metadata reservation.
>> In private chat with Chris couple of months ago we discussed making th=
e
>> reservation a lot less pessimistic. One assumption which we could
>> exploit is the fact that upon a tree split it's unlikely we will creat=
e
>> more than 1 additional level in the tree. So we could potentially modi=
fy
>> btrfs_calc_trans_metadata_size to take a root parameter and instead of=

>>
>> BTRFS_MAX_LEVEL * 2 we could change this to root_level * 2. How does
>> that sound?

My plan is more aggressive.
Since qgroup doesn't really need to care about low level space
reservation for extents, here we only needs to care about "net"
modification.

For item insert, it will takes one new tree block for split at most (if
I don't miss something).
So for qgroup, one ordered extent should only reserve one nodesize.

In fact, for per-trans reservation, we have been using this for a long ti=
me.

>=20
> That sounds unsafe for low levels, because the reservations can be made=

> with level N and the tree height can increase at commit time to > N,
> then we'd go ENOSPC. But BTRFS_MAX_LEVEL can be reduced to
> min(root_level + 1, 4) and even the +1 can be dropped for higher levels=

> if the root node is filled up to some percent (say < 50%). The 4 is a
> guess and could be possibly 3, with some more precise calculations.

So the idea only applies to qgroup, nothing is changed for low level
space reservation.
Although this needs extra work in qgroup side.

Current patchset completely rely on current outstanding extent mechanism
to ensure its reservation is reserved and released correctly.

If qgroup is going to do its own reservation calculation, it needs extra
work to handle.

But compared to too early EDQUOT, it's still worthy anyway.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--LrpeihobKaR0sIkmT2apo5rh4n5PHUD03--

--8mnNN0s9HaMIIxgC5nwLKCMd7r2HqgB5G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlowemEXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qiOIggAmFhXyXOVODaJL/Ubxi1MKYI7
LUAAALX0S8nRbv2/hGKrfWWZTZaQ0GFApAL/Askc61hiTn5u4iLotRD3dxx1zT8q
nJpkUBH6QTY4+DDOkA67cs+4Q4KX43pgS69SNzAfgD0A5HAPn4lIIabbQCjHH2SJ
J5XCPv58aEoCJnOhYBMO1oARxPAdTfhXj4fzQIMYpHHyJyU44KuNShqO3yBvaQlm
LyiqXoEa1IXmrAawsB7Yxs7S2f8TkPcEGAsctzCmcHCIftOaiib+zxGy1VU/5P0o
AMdmd9F8tnIfcWBmt3ihX6bw0U7PJokz/V9cCyVQZs7zr68V04Mq9vfOM3CfYw==
=5rDu
-----END PGP SIGNATURE-----

--8mnNN0s9HaMIIxgC5nwLKCMd7r2HqgB5G--
