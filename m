Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:35181 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751771AbeBVCFt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Feb 2018 21:05:49 -0500
Subject: Re: [PATCH] btrfs: qgroups, properly handle no reservations
To: Jeff Mahoney <jeffm@suse.com>, linux-btrfs@vger.kernel.org
References: <20180221201921.17944-1-jeffm@suse.com>
 <2030c88e-328a-8021-3dfd-0631e7429eac@gmx.com>
 <f0c73e34-dc33-d2eb-56d6-2b936f1f967b@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <ac3ffb4b-c60a-fd1e-be50-db99376a6e1e@gmx.com>
Date: Thu, 22 Feb 2018 10:05:36 +0800
MIME-Version: 1.0
In-Reply-To: <f0c73e34-dc33-d2eb-56d6-2b936f1f967b@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="pZVHKqW0YZj2wIbNHJ7QcjpLqKy10eSur"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pZVHKqW0YZj2wIbNHJ7QcjpLqKy10eSur
Content-Type: multipart/mixed; boundary="eZGYIuWxN90mGQoo7KJyxwf3zmPeJtCkR";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Jeff Mahoney <jeffm@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <ac3ffb4b-c60a-fd1e-be50-db99376a6e1e@gmx.com>
Subject: Re: [PATCH] btrfs: qgroups, properly handle no reservations
References: <20180221201921.17944-1-jeffm@suse.com>
 <2030c88e-328a-8021-3dfd-0631e7429eac@gmx.com>
 <f0c73e34-dc33-d2eb-56d6-2b936f1f967b@suse.com>
In-Reply-To: <f0c73e34-dc33-d2eb-56d6-2b936f1f967b@suse.com>

--eZGYIuWxN90mGQoo7KJyxwf3zmPeJtCkR
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8822=E6=97=A5 09:50, Jeff Mahoney wrote:
> On 2/21/18 8:36 PM, Qu Wenruo wrote:
>>
>>
>> On 2018=E5=B9=B402=E6=9C=8822=E6=97=A5 04:19, jeffm@suse.com wrote:
>>> From: Jeff Mahoney <jeffm@suse.com>
>>>
>>> There are several places where we call btrfs_qgroup_reserve_meta and
>>> assume that a return value of 0 means that the reservation was succes=
sful.
>>>
>>> Later, we use the original bytes value passed to that call to free
>>> bytes during error handling or to pass the number of bytes reserved t=
o
>>> the caller.
>>>
>>> This patch returns -ENODATA when we don't perform a reservation so th=
at
>>> callers can make the distinction.  This also lets call sites not
>>> necessarily care whether qgroups are enabled.
>>
>> IMHO if we don't need to reserve, returning 0 seems good enough.
>> Caller doesn't really need to care if it has reserved some bytes.
>>
>> Or is there any special case where we need to distinguish such case?
>=20
> Anywhere where the reservation takes place prior to the transaction
> starting, which is pretty much everywhere.  We wait until transaction
> commit to flip the bit to turn on quotas, which means that if a
> transaction commits that enables quotas lands in between the reservatio=
n
> being take and any error handling that involves freeing the reservation=
,
> we'll end up with an underflow.

So the same case as btrfs_qgroup_reserve_data().

In that case we could use ret > 0 to indicates the real bytes we
reserved, instead of -ENODATA which normally means error.

>=20
> This is the first patch of a series I'm working on, but it can stand
> alone.  The rest is the patch set I mentioned when we talked a few
> months ago where the lifetimes of reservations are incorrect.  We can't=

> just drop all the reservations at the end of the transaction because 1)=

> the lifetime of some reservations can cross transactions and 2) because=

> especially in the start_transaction case, we do the reservation prior t=
o
> waiting to join the transaction.  So if the transaction we're waiting o=
n
> commits, our reservation goes away with it but we continue on as if we
> still have it.

Right, the same problem I also addressed in patchset "[PATCH v2 00/10]
Use split qgroup rsv type".

In 6th patch, "[PATCH v2 06/10] btrfs: qgroup: Use
root->qgroup_meta_rsv_* to record qgroup meta reserved space" qgroup
meta reserve will only be increased if we succeeded in reserving
metadata, so later free won't underflow that number.

Thanks,
Qu


>=20
> -Jeff
>=20
>> Thanks,
>> Qu
>>
>>>
>>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>>> ---
>>>  fs/btrfs/extent-tree.c | 33 ++++++++++++++++-----------------
>>>  fs/btrfs/qgroup.c      |  4 ++--
>>>  fs/btrfs/transaction.c |  5 ++++-
>>>  3 files changed, 22 insertions(+), 20 deletions(-)
>>>
>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>>> index c1618ab9fecf..2d5e963fae88 100644
>>> --- a/fs/btrfs/extent-tree.c
>>> +++ b/fs/btrfs/extent-tree.c
>>> @@ -5988,20 +5988,18 @@ int btrfs_subvolume_reserve_metadata(struct b=
trfs_root *root,
>>>  				     u64 *qgroup_reserved,
>>>  				     bool use_global_rsv)
>>>  {
>>> -	u64 num_bytes;
>>>  	int ret;
>>>  	struct btrfs_fs_info *fs_info =3D root->fs_info;
>>>  	struct btrfs_block_rsv *global_rsv =3D &fs_info->global_block_rsv;
>>> +	/* One for parent inode, two for dir entries */
>>> +	u64 num_bytes =3D 3 * fs_info->nodesize;
>>> =20
>>> -	if (test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags)) {
>>> -		/* One for parent inode, two for dir entries */
>>> -		num_bytes =3D 3 * fs_info->nodesize;
>>> -		ret =3D btrfs_qgroup_reserve_meta(root, num_bytes, true);
>>> -		if (ret)
>>> -			return ret;
>>> -	} else {
>>> +	ret =3D btrfs_qgroup_reserve_meta(root, num_bytes, true);
>>> +	if (ret =3D=3D -ENODATA) {
>>>  		num_bytes =3D 0;
>>> -	}
>>> +		ret =3D 0;
>>> +	} else if (ret)
>>> +		return ret;
>>> =20
>>>  	*qgroup_reserved =3D num_bytes;
>>> =20
>>> @@ -6057,6 +6055,7 @@ int btrfs_delalloc_reserve_metadata(struct btrf=
s_inode *inode, u64 num_bytes)
>>>  	enum btrfs_reserve_flush_enum flush =3D BTRFS_RESERVE_FLUSH_ALL;
>>>  	int ret =3D 0;
>>>  	bool delalloc_lock =3D true;
>>> +	u64 qgroup_reserved;
>>> =20
>>>  	/* If we are a free space inode we need to not flush since we will =
be in
>>>  	 * the middle of a transaction commit.  We also don't need the dela=
lloc
>>> @@ -6090,17 +6089,17 @@ int btrfs_delalloc_reserve_metadata(struct bt=
rfs_inode *inode, u64 num_bytes)
>>>  	btrfs_calculate_inode_block_rsv_size(fs_info, inode);
>>>  	spin_unlock(&inode->lock);
>>> =20
>>> -	if (test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags)) {
>>> -		ret =3D btrfs_qgroup_reserve_meta(root,
>>> -				nr_extents * fs_info->nodesize, true);
>>> -		if (ret)
>>> -			goto out_fail;
>>> -	}
>>> +	qgroup_reserved =3D nr_extents * fs_info->nodesize;
>>> +	ret =3D btrfs_qgroup_reserve_meta(root, qgroup_reserved, true);
>>> +	if (ret =3D=3D -ENODATA) {
>>> +		ret =3D 0;
>>> +		qgroup_reserved =3D 0;
>>> +	} if (ret)
>>> +		goto out_fail;
>>> =20
>>>  	ret =3D btrfs_inode_rsv_refill(inode, flush);
>>>  	if (unlikely(ret)) {
>>> -		btrfs_qgroup_free_meta(root,
>>> -				       nr_extents * fs_info->nodesize);
>>> +		btrfs_qgroup_free_meta(root, qgroup_reserved);
>>>  		goto out_fail;
>>>  	}
>>> =20
>>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>>> index aa259d6986e1..5d9e011243c6 100644
>>> --- a/fs/btrfs/qgroup.c
>>> +++ b/fs/btrfs/qgroup.c
>>> @@ -3025,7 +3025,7 @@ int btrfs_qgroup_reserve_meta(struct btrfs_root=
 *root, int num_bytes,
>>> =20
>>>  	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags) ||
>>>  	    !is_fstree(root->objectid) || num_bytes =3D=3D 0)
>>> -		return 0;
>>> +		return -ENODATA;
>>> =20
>>>  	BUG_ON(num_bytes !=3D round_down(num_bytes, fs_info->nodesize));
>>>  	trace_qgroup_meta_reserve(root, (s64)num_bytes);
>>> @@ -3057,7 +3057,7 @@ void btrfs_qgroup_free_meta(struct btrfs_root *=
root, int num_bytes)
>>>  	struct btrfs_fs_info *fs_info =3D root->fs_info;
>>> =20
>>>  	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags) ||
>>> -	    !is_fstree(root->objectid))
>>> +	    !is_fstree(root->objectid) || num_bytes =3D=3D 0)
>>>  		return;
>>> =20
>>>  	BUG_ON(num_bytes !=3D round_down(num_bytes, fs_info->nodesize));
>>> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
>>> index 04f07144b45c..ab67b73bd7fa 100644
>>> --- a/fs/btrfs/transaction.c
>>> +++ b/fs/btrfs/transaction.c
>>> @@ -510,7 +510,10 @@ start_transaction(struct btrfs_root *root, unsig=
ned int num_items,
>>>  		qgroup_reserved =3D num_items * fs_info->nodesize;
>>>  		ret =3D btrfs_qgroup_reserve_meta(root, qgroup_reserved,
>>>  						enforce_qgroups);
>>> -		if (ret)
>>> +		if (ret =3D=3D -ENODATA) {
>>> +			ret =3D 0;
>>> +			qgroup_reserved =3D 0;
>>> +		} else if (ret)
>>>  			return ERR_PTR(ret);
>>> =20
>>>  		num_bytes =3D btrfs_calc_trans_metadata_size(fs_info, num_items);
>>>
>>
>=20
>=20


--eZGYIuWxN90mGQoo7KJyxwf3zmPeJtCkR--

--pZVHKqW0YZj2wIbNHJ7QcjpLqKy10eSur
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqOJXAXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qiUmQf/dmZ+N2h63vBoehOQM161u0uq
w3yFMXm8NiQTPSK7kgvW93ikLkxatQf3420Xy17F9bEDUNBn5HIIi6vhxpLVHZrP
EAZXRMNhNeJjt/YvAFAGvEr4/wVJktXWCtvcUCq3rjUVKA2du9fc6GZT6qJfCuXq
iXcXUh9dkWrBQumbY2vspAdSxgEtx68mJ7yowM0OD5DfsOv7qZQDIjBifva859Tx
HyKtOvzJCO1KB0uYdMC/hAqBkUFyl3xsHKC9ZHP3YnGah6KlNB/8c/oNo3t5qxbN
Zw6kc+r1YYBQBw/1jUJi8VOK10OSiBJF8BB33+X7posy4ub6wTRPXpfm1Yy42Q==
=9n8Z
-----END PGP SIGNATURE-----

--pZVHKqW0YZj2wIbNHJ7QcjpLqKy10eSur--
