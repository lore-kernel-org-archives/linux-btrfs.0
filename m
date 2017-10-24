Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:57050 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751920AbdJXMms (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Oct 2017 08:42:48 -0400
Subject: Re: [PATCH 1/6] btrfs: qgroup: Skeleton to support separate qgroup
 reservation type
To: Jeff Mahoney <jeffm@suse.com>, Nikolay Borisov <nborisov@suse.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20171024083941.21428-1-wqu@suse.com>
 <20171024083941.21428-2-wqu@suse.com>
 <5e6a7a3c-21ce-12e4-1bdc-78cdcb69d6c7@suse.com>
 <44cac459-0d68-01e3-e7bd-9e4cf541aabd@gmx.com>
 <3f8c74ef-c65f-21ae-64d5-a38936c2d9b0@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <fc60f686-c39e-70ca-9a93-6b08343fa77a@gmx.com>
Date: Tue, 24 Oct 2017 20:41:54 +0800
MIME-Version: 1.0
In-Reply-To: <3f8c74ef-c65f-21ae-64d5-a38936c2d9b0@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="1hp6V6gCEUWTghplNNDVRV8xwhGtVPd9F"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1hp6V6gCEUWTghplNNDVRV8xwhGtVPd9F
Content-Type: multipart/mixed; boundary="GPDL0sJwcn7gLI7otoHT77nGovFviWdD0";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Jeff Mahoney <jeffm@suse.com>, Nikolay Borisov <nborisov@suse.com>,
 Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Message-ID: <fc60f686-c39e-70ca-9a93-6b08343fa77a@gmx.com>
Subject: Re: [PATCH 1/6] btrfs: qgroup: Skeleton to support separate qgroup
 reservation type
References: <20171024083941.21428-1-wqu@suse.com>
 <20171024083941.21428-2-wqu@suse.com>
 <5e6a7a3c-21ce-12e4-1bdc-78cdcb69d6c7@suse.com>
 <44cac459-0d68-01e3-e7bd-9e4cf541aabd@gmx.com>
 <3f8c74ef-c65f-21ae-64d5-a38936c2d9b0@suse.com>
In-Reply-To: <3f8c74ef-c65f-21ae-64d5-a38936c2d9b0@suse.com>

--GPDL0sJwcn7gLI7otoHT77nGovFviWdD0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B410=E6=9C=8824=E6=97=A5 20:29, Jeff Mahoney wrote:
> On 10/24/17 7:51 AM, Qu Wenruo wrote:
>>
>>
>> On 2017=E5=B9=B410=E6=9C=8824=E6=97=A5 19:00, Nikolay Borisov wrote:
>>>
>>>
>>> On 24.10.2017 11:39, Qu Wenruo wrote:
>>>> Instead of single qgroup->reserved, use a new structure btrfs_qgroup=
_rsv
>>>> to restore different types of reservation.
>>>>
>>>> This patch only updates the header and needed modification to pass
>>>> compile.
>>>>
>>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>>> ---
>>>>  fs/btrfs/qgroup.c | 16 ++++++++++------
>>>>  fs/btrfs/qgroup.h | 27 +++++++++++++++++++++++++--
>>>>  2 files changed, 35 insertions(+), 8 deletions(-)
>>>>
>>>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>>>> index e172d4843eae..fe3adb996883 100644
>>>> --- a/fs/btrfs/qgroup.c
>>>> +++ b/fs/btrfs/qgroup.c
>>>> @@ -2444,7 +2444,8 @@ static int qgroup_reserve(struct btrfs_root *r=
oot, u64 num_bytes, bool enforce)
>>>>  }
>>>> =20
>>>>  void btrfs_qgroup_free_refroot(struct btrfs_fs_info *fs_info,
>>>> -			       u64 ref_root, u64 num_bytes)
>>>> +			       u64 ref_root, u64 num_bytes,
>>>> +			       enum btrfs_qgroup_rsv_type type)
>>>>  {
>>>>  	struct btrfs_root *quota_root;
>>>>  	struct btrfs_qgroup *qgroup;
>>>> @@ -2936,7 +2937,8 @@ static int qgroup_free_reserved_data(struct in=
ode *inode,
>>>>  			goto out;
>>>>  		freed +=3D changeset.bytes_changed;
>>>>  	}
>>>> -	btrfs_qgroup_free_refroot(root->fs_info, root->objectid, freed);
>>>> +	btrfs_qgroup_free_refroot(root->fs_info, root->objectid, freed,
>>>> +				  BTRFS_QGROUP_RSV_DATA);
>>>>  	ret =3D freed;
>>>>  out:
>>>>  	extent_changeset_release(&changeset);
>>>> @@ -2968,7 +2970,7 @@ static int __btrfs_qgroup_release_data(struct =
inode *inode,
>>>>  	if (free)
>>>>  		btrfs_qgroup_free_refroot(BTRFS_I(inode)->root->fs_info,
>>>>  				BTRFS_I(inode)->root->objectid,
>>>> -				changeset.bytes_changed);
>>>> +				changeset.bytes_changed, BTRFS_QGROUP_RSV_DATA);
>>>>  	ret =3D changeset.bytes_changed;
>>>>  out:
>>>>  	extent_changeset_release(&changeset);
>>>> @@ -3045,7 +3047,8 @@ void btrfs_qgroup_free_meta_all(struct btrfs_r=
oot *root)
>>>>  	if (reserved =3D=3D 0)
>>>>  		return;
>>>>  	trace_qgroup_meta_reserve(root, -(s64)reserved);
>>>> -	btrfs_qgroup_free_refroot(fs_info, root->objectid, reserved);
>>>> +	btrfs_qgroup_free_refroot(fs_info, root->objectid, reserved,
>>>> +				  BTRFS_QGROUP_RSV_META);
>>>>  }
>>>> =20
>>>>  void btrfs_qgroup_free_meta(struct btrfs_root *root, int num_bytes)=

>>>> @@ -3060,7 +3063,8 @@ void btrfs_qgroup_free_meta(struct btrfs_root =
*root, int num_bytes)
>>>>  	WARN_ON(atomic64_read(&root->qgroup_meta_rsv) < num_bytes);
>>>>  	atomic64_sub(num_bytes, &root->qgroup_meta_rsv);
>>>>  	trace_qgroup_meta_reserve(root, -(s64)num_bytes);
>>>> -	btrfs_qgroup_free_refroot(fs_info, root->objectid, num_bytes);
>>>> +	btrfs_qgroup_free_refroot(fs_info, root->objectid, num_bytes,
>>>> +				  BTRFS_QGROUP_RSV_META);
>>>>  }
>>>> =20
>>>>  /*
>>>> @@ -3088,7 +3092,7 @@ void btrfs_qgroup_check_reserved_leak(struct i=
node *inode)
>>>>  		}
>>>>  		btrfs_qgroup_free_refroot(BTRFS_I(inode)->root->fs_info,
>>>>  				BTRFS_I(inode)->root->objectid,
>>>> -				changeset.bytes_changed);
>>>> +				changeset.bytes_changed, BTRFS_QGROUP_RSV_DATA);
>>>> =20
>>>>  	}
>>>>  	extent_changeset_release(&changeset);
>>>> diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
>>>> index d9984e87cddf..0b04cbc5b5ce 100644
>>>> --- a/fs/btrfs/qgroup.h
>>>> +++ b/fs/btrfs/qgroup.h
>>>> @@ -61,6 +61,26 @@ struct btrfs_qgroup_extent_record {
>>>>  	struct ulist *old_roots;
>>>>  };
>>>> =20
>>>> +enum btrfs_qgroup_rsv_type {
>>>> +	BTRFS_QGROUP_RSV_DATA =3D 0,
>>>> +	BTRFS_QGROUP_RSV_META =3D 1,
>>>> +	BTRFS_QGROUP_RSV_TYPES =3D 1,
>>>
>>> nit: Why not BTRFS_QGROUP_RSV_TYPES_MAX =3D 2;
>>
>> My original plan is just as the same as yours.
>>
>> However I still remember I did it before and David fixed it by using
>> TYPES, so I follow his naming schema here.
>>
>> Kernel is also using this naming schema else where:
>> d91876496bcf ("btrfs: compress: put variables defined per compress typ=
e
>> in struct to make cache friendly")
>=20
> The COMPRESS_TYPES pattern isn't the right pattern to follow here.
> That's a special case since there's a _NONE that doesn't have anything
> associated with it, so we don't need to take a slot in the array.
>=20
> We also don't care about any of the specific values, just that they
> start at 0.  The BTRFS_COMPRESS_TYPES example also has a
> BTRFS_COMPRESS_LAST item in the enum, which serves the same purpose as
> MAX.

At least in latest mainline kernel, there is no COMPRESS_LAST now.
---
enum btrfs_compression_type {
	BTRFS_COMPRESS_NONE  =3D 0,
	BTRFS_COMPRESS_ZLIB  =3D 1,
	BTRFS_COMPRESS_LZO   =3D 2,
	BTRFS_COMPRESS_ZSTD  =3D 3,
	BTRFS_COMPRESS_TYPES =3D 3,
};
---

>  I don't have a strong opinion on the naming, just that we don't
> play games with +1 when handling arrays since, as you say, that's just
> waiting for subtle bugs later.

Not waiting, already experienced it during coding.

>=20
> enum btrfs_qgroup_rsv_type {
> 	BTRFS_QGROUP_RSV_DATA =3D 0,
> 	BTRFS_QGROUP_RSV_META,
> 	BTRFS_QGROUP_RSV_LAST,
> };
>=20
>>>> +};
>>>> +
>>>> +/*
>>>> + * Represents how many bytes we reserved for this qgroup.
>>>> + *
>>>> + * Each type should have different reservation behavior.
>>>> + * E.g, data follows its io_tree flag modification, while
>>>> + * *currently* meta is just reserve-and-clear during transcation.
>>>> + *
>>>> + * TODO: Add new type for delalloc, which can exist across several
>>>> + * transaction.
>>>> + */
>=20
> Minor nit: It's not just delalloc.  Delayed items and inodes can as
> well.  The general rule is that qgroup reservations aren't essentially
> different from block reservations and follow the same usage patterns
> when operating on leaf nodes.

Yep, any reserveration who can survive transaction commit should go here
with a new reservation type.

I'll change the TODO description here.

>=20
>>>> +struct btrfs_qgroup_rsv {
>>>> +	u64 values[BTRFS_QGROUP_RSV_TYPES + 1];
>>>
>>> nit: And here just BTRFS_QGROUP_RSV_TYPES_MAX rather than the +1 here=
,
>>> seems more idiomatic to me.
>>
>> To follow same naming schema from David.
>> (IIRC it was about tree-checker patchset, checking file extent type pa=
rt)
>>
>> In fact, I crashed kernel several times due to the tiny +1, without ev=
en
>> a clue for hours just testing blindly, until latest gcc gives warning
>> about it.
>=20
> BTRFS_QGROUP_RSV_LAST would do the job here.

I'll go with this method.

Thanks,
Qu

>=20
> -Jeff
>=20
>>>
>>>> +};
>>>> +
>>>>  /*
>>>>   * one struct for each qgroup, organized in fs_info->qgroup_tree.
>>>>   */
>>>> @@ -88,6 +108,7 @@ struct btrfs_qgroup {
>>>>  	 * reservation tracking
>>>>  	 */
>>>>  	u64 reserved;
>>>> +	struct btrfs_qgroup_rsv rsv;
>>>> =20
>>>>  	/*
>>>>  	 * lists
>>>> @@ -228,12 +249,14 @@ int btrfs_qgroup_inherit(struct btrfs_trans_ha=
ndle *trans,
>>>>  			 struct btrfs_fs_info *fs_info, u64 srcid, u64 objectid,
>>>>  			 struct btrfs_qgroup_inherit *inherit);
>>>>  void btrfs_qgroup_free_refroot(struct btrfs_fs_info *fs_info,
>>>> -			       u64 ref_root, u64 num_bytes);
>>>> +			       u64 ref_root, u64 num_bytes,
>>>> +			       enum btrfs_qgroup_rsv_type type);
>>>>  static inline void btrfs_qgroup_free_delayed_ref(struct btrfs_fs_in=
fo *fs_info,
>>>>  						 u64 ref_root, u64 num_bytes)
>>>>  {
>>>>  	trace_btrfs_qgroup_free_delayed_ref(fs_info, ref_root, num_bytes);=

>>>> -	btrfs_qgroup_free_refroot(fs_info, ref_root, num_bytes);
>>>> +	btrfs_qgroup_free_refroot(fs_info, ref_root, num_bytes,
>>>> +				  BTRFS_QGROUP_RSV_DATA);
>>>>  }
>>>> =20
>>>>  #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>=20
>=20


--GPDL0sJwcn7gLI7otoHT77nGovFviWdD0--

--1hp6V6gCEUWTghplNNDVRV8xwhGtVPd9F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnvNRIXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhx8Qf9EWMOlNOO7QFXSc4Qu+GRg0So
vgEbzWKH/i7truBasJCGXBeCyGgIblXaeKSvoa37vlElmXgoW2sYt7/dBfCgZHd9
xMdz22RGjGBoAnP0PE3oH2Ae3Fn1GquXdEuSivSiUBeyI7ZsnURIQ7s88ZGJ9LiU
ac6U9beOVf0gz6upjchhoctVH9/Pp9DVZmq22B4Af0B/zfZB8rH845PICOYTSNBF
kRDbYE98wml48nVFK9cVfIq9aggan/+G9oG/VqV7ddXVR8k72dUttYM3yoPYtALl
EpoVuM/iiITTDwdc/jjn0jutZqt3X0SdBI2qafRjmo+tfhO6k203RcrYkbkLBQ==
=lYb9
-----END PGP SIGNATURE-----

--1hp6V6gCEUWTghplNNDVRV8xwhGtVPd9F--
