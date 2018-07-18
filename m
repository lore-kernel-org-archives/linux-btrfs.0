Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:53029 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbeGRIjL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jul 2018 04:39:11 -0400
Subject: Re: [PATCH 13/19] btrfs: qgroup: Drop fs_info parameter from
 btrfs_qgroup_trace_extent
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
References: <20180718064542.2730-1-lufq.fnst@cn.fujitsu.com>
 <20180718064542.2730-14-lufq.fnst@cn.fujitsu.com>
 <ca879289-7a26-e445-210d-0d8c8c9c173e@gmx.com>
 <20180718075431.GI575@fnst.localdomain>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <d5127b6a-5406-6cee-0d23-5d7647011643@gmx.com>
Date: Wed, 18 Jul 2018 16:02:23 +0800
MIME-Version: 1.0
In-Reply-To: <20180718075431.GI575@fnst.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6MDzHcO94zKKQyS0EqXKUg1dxwBxJxQod"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6MDzHcO94zKKQyS0EqXKUg1dxwBxJxQod
Content-Type: multipart/mixed; boundary="Ym8aCLwVv8HVmPygf1doXATkMJzxdtriF";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <d5127b6a-5406-6cee-0d23-5d7647011643@gmx.com>
Subject: Re: [PATCH 13/19] btrfs: qgroup: Drop fs_info parameter from
 btrfs_qgroup_trace_extent
References: <20180718064542.2730-1-lufq.fnst@cn.fujitsu.com>
 <20180718064542.2730-14-lufq.fnst@cn.fujitsu.com>
 <ca879289-7a26-e445-210d-0d8c8c9c173e@gmx.com>
 <20180718075431.GI575@fnst.localdomain>
In-Reply-To: <20180718075431.GI575@fnst.localdomain>

--Ym8aCLwVv8HVmPygf1doXATkMJzxdtriF
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8818=E6=97=A5 15:54, Lu Fengqi wrote:
> On Wed, Jul 18, 2018 at 02:58:06PM +0800, Qu Wenruo wrote:
>>
>>
>> On 2018=E5=B9=B407=E6=9C=8818=E6=97=A5 14:45, Lu Fengqi wrote:
>>> It can be fetched from the transaction handle.
>>>
>>> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
>>> ---
>>>  fs/btrfs/qgroup.c   | 13 ++++++-------
>>>  fs/btrfs/qgroup.h   |  5 ++---
>>>  fs/btrfs/tree-log.c |  2 +-
>>>  3 files changed, 9 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>>> index c85c1a0e933a..01add73cb2aa 100644
>>> --- a/fs/btrfs/qgroup.c
>>> +++ b/fs/btrfs/qgroup.c
>>> @@ -1579,10 +1579,10 @@ int btrfs_qgroup_trace_extent_post(struct btr=
fs_fs_info *fs_info,
>>>  	return 0;
>>>  }
>>> =20
>>> -int btrfs_qgroup_trace_extent(struct btrfs_trans_handle *trans,
>>> -		struct btrfs_fs_info *fs_info, u64 bytenr, u64 num_bytes,
>>> -		gfp_t gfp_flag)
>>> +int btrfs_qgroup_trace_extent(struct btrfs_trans_handle *trans, u64 =
bytenr,
>>> +			      u64 num_bytes, gfp_t gfp_flag)
>>>  {
>>> +	struct btrfs_fs_info *fs_info =3D trans->fs_info;
>>
>> Just lines below, we do extra WARN_ON(trans =3D=3D NULL).
>> So if we really hit some case with NULL trans, this would cause a NULL=

>> pointer dereference.
>>
>> Although I have to admit, I'm a little paranoid about possible NULL
>> trans passed in.
>> So maybe it's a good timing to remove that WARN_ON() too?
>=20
> Sorry, I didn't notice this WARN_ON(trans =3D=3D NULL). However, I have=

> confirmed that the callers of btrfs_qgroup_trace_{extent, leaf_items,
> subtree} should never pass NULL as trans. In my opinion the WARN_ON() c=
an
> be removed without any bad effect.
>=20
Then removing that WARN_ON() would be pretty nice.

Thanks,
Qu


--Ym8aCLwVv8HVmPygf1doXATkMJzxdtriF--

--6MDzHcO94zKKQyS0EqXKUg1dxwBxJxQod
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltO9A8ACgkQwj2R86El
/qgy3AgAg/nZdVLLF1c70wCToXDi3n2mmTOSNa5O1qXjxNRr2PR/bJLx+pYY+iS0
V49BBeMbYTH4eBwjhT7zx0PzWEqPkfU4KvI06bLEDUZLYKfG6bL411ux31eFTLcr
KWL3X4yP2zy63rtxuRO+4DKvKoFtkP+O8uGXCzx2ifjbDdO+H6cO4Z9a/yi9FHXe
xntlkK48KX4s8xl1xAvGjdhZAaxIm9do6jtT/B9SJidwN5ZL7GwnvqJ/80js/pAa
HUF3Cyt2BJflwnXdkkpuJZJV2NbgfkJBNoQGJ8mH+FiRbYeVPBGcx17IXCXDdC12
IPlUthic5rGFiItUJ1iK4RZYLi7MZA==
=R5YT
-----END PGP SIGNATURE-----

--6MDzHcO94zKKQyS0EqXKUg1dxwBxJxQod--
