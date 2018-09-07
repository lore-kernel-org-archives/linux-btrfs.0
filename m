Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:60087 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725731AbeIHEQk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 8 Sep 2018 00:16:40 -0400
Subject: Re: [PATCH 2/3] btrfs: qgroup: Validate btrfs_qgroup_inherit
 structure before passing it to qgroup
To: Omar Sandoval <osandov@osandov.com>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
References: <20180831022930.3465-1-wqu@suse.com>
 <20180831022930.3465-3-wqu@suse.com> <20180907205039.GD29245@vader>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <e8e63b6c-c88c-9eae-3991-ccf77337d6e3@gmx.com>
Date: Sat, 8 Sep 2018 07:33:08 +0800
MIME-Version: 1.0
In-Reply-To: <20180907205039.GD29245@vader>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7ZGMm8bcvDTUO7SZUXzEUGNuH7lIBbNeQ"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7ZGMm8bcvDTUO7SZUXzEUGNuH7lIBbNeQ
Content-Type: multipart/mixed; boundary="J2u7k9iHfFvd2TBkc869NAiEMJijuzCXz";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Omar Sandoval <osandov@osandov.com>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <e8e63b6c-c88c-9eae-3991-ccf77337d6e3@gmx.com>
Subject: Re: [PATCH 2/3] btrfs: qgroup: Validate btrfs_qgroup_inherit
 structure before passing it to qgroup
References: <20180831022930.3465-1-wqu@suse.com>
 <20180831022930.3465-3-wqu@suse.com> <20180907205039.GD29245@vader>
In-Reply-To: <20180907205039.GD29245@vader>

--J2u7k9iHfFvd2TBkc869NAiEMJijuzCXz
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/9/8 =E4=B8=8A=E5=8D=884:50, Omar Sandoval wrote:
> On Fri, Aug 31, 2018 at 10:29:29AM +0800, Qu Wenruo wrote:
>> btrfs_qgroup_inherit structure doesn't goes through much validation
>> check.
>>
>> Now do a comprehensive check for it, including:
>> 1) inherit size
>>    Should not exceeding SZ_4K and its num_qgroups should not
>>    exceed its size passed in btrfs_ioctl_vol_args_v2.
>>
>> 2) flags
>>    Should not include any unknown flags
>>    (In fact, no flag is supported at all now)
>>    Btrfs-progs never has such ability to set flags for btrfs_qgroup_in=
herit.
>>
>> 3) limit
>>    Should not contain anything.
>>    Btrfs-progs never has such ability to set limit for btrfs_qgroup_in=
herit.
>>
>> 4) rfer/excl copy
>>    Deprecated feature.
>>    Btrfs-progs has such interface but never documented and we're alrea=
dy
>>    going to remove such ability.
>>    It's the easiest way to screw up qgroup numbers.
>>
>> 3) Qgroupid
>>    Comprehensive check is already in btrfs_qgroup_inherit(), here we
>>    only check if there is any obviously invalid qgroupid (0).
>>
>> Coverity-id: 1021055
>> Reported-by: Nikolay Borisov <nborisov@suse.com>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/ioctl.c           |  3 +++
>>  fs/btrfs/qgroup.c          | 39 +++++++++++++++++++++++++++++++++++++=
+
>>  fs/btrfs/qgroup.h          |  2 ++
>>  include/uapi/linux/btrfs.h | 17 ++++++++---------
>>  4 files changed, 52 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index 5db8680b40a9..4f5f453d5d07 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -1820,6 +1820,9 @@ static noinline int btrfs_ioctl_snap_create_v2(s=
truct file *file,
>>  			ret =3D PTR_ERR(inherit);
>>  			goto free_args;
>>  		}
>> +		ret =3D btrfs_validate_inherit(inherit, vol_args->size);
>> +		if (ret < 0)
>> +			goto free_args;
>>  	}
>> =20
>>  	ret =3D btrfs_ioctl_snap_create_transid(file, vol_args->name,
>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>> index 4353bb69bb86..53daf73b0de9 100644
>> --- a/fs/btrfs/qgroup.c
>> +++ b/fs/btrfs/qgroup.c
>> @@ -2232,6 +2232,45 @@ int btrfs_run_qgroups(struct btrfs_trans_handle=
 *trans)
>>  	return ret;
>>  }
>> =20
>> +/*
>> + * To make sure the inherit passed in is valid
>> + *
>> + * Here we only check flags and rule out some no-longer supported fea=
tures.
>> + * And we only do very basis qgroupid check to ensure there is no obv=
iously
>> + * invalid qgroupid (0). Detailed qgroupid check will be done in
>> + * btrfs_qgroup_inherit().
>> + */
>> +int btrfs_validate_inherit(struct btrfs_qgroup_inherit *inherit,
>> +			   u64 inherit_size)
>> +{
>> +	u64 i;
>> +
>> +	if (inherit->flags & ~BTRFS_QGROUP_INHERIT_FLAGS_SUPP)
>> +		return -ENOTTY;
>> +	/* Qgroup rfer/excl copy is deprecated */
>> +	if (inherit->num_excl_copies || inherit->num_ref_copies)
>> +		return -ENOTTY;
>> +
>> +	/* Since SET_LIMITS is never used, @lim should all be zeroed */
>> +	if (inherit->lim.max_excl || inherit->lim.max_rfer ||
>> +	    inherit->lim.rsv_excl || inherit->lim.rsv_rfer ||
>> +	    inherit->lim.flags)
>> +		return -ENOTTY;
>=20
> Why -ENOTTY? I think these should all be -EINVAL.

Changed in v2.

Now it only outputs warning message.

>=20
>> +	/* Size check */
>> +	if (sizeof(u64) * inherit->num_qgroups + sizeof(*inherit) >
>=20
> This arithmetic can overflow...

Oh, forgot that possibility.

inherit->num_qgroups/excl_copies/rfer_coopies should be checked against
(BTRFS_QGROUP_INHERIT_MAX_SIZE - sizeof(*inherit))/(sizeof(u64).

Thanks,
Qu

>=20
>> +	    min_t(u64, BTRFS_QGROUP_INHERIT_MAX_SIZE, inherit_size))
>> +		return -EINVAL;
>> +
>> +
>> +	/* Qgroup 0/0 is not allowed */
>> +	for (i =3D 0; i < inherit->num_qgroups; i++) {
>> +		if (inherit->qgroups[i] =3D=3D 0)
>=20
> Which means we can access out of bounds here.
>=20
>> +			return -EINVAL;
>> +	}
>> +	return 0;
>> +}
>> +
>>  /*
>>   * Copy the accounting information between qgroups. This is necessary=

>>   * when a snapshot or a subvolume is created. Throwing an error will
>> diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
>> index 54b8bb282c0e..1bf9c584be70 100644
>> --- a/fs/btrfs/qgroup.h
>> +++ b/fs/btrfs/qgroup.h
>> @@ -241,6 +241,8 @@ int btrfs_qgroup_account_extent(struct btrfs_trans=
_handle *trans, u64 bytenr,
>>  				struct ulist *new_roots);
>>  int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans);
>>  int btrfs_run_qgroups(struct btrfs_trans_handle *trans);
>> +int btrfs_validate_inherit(struct btrfs_qgroup_inherit *inherit,
>> +			   u64 inherit_size);
>>  int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans, u64 srcid,=

>>  			 u64 objectid, struct btrfs_qgroup_inherit *inherit);
>>  void btrfs_qgroup_free_refroot(struct btrfs_fs_info *fs_info,
>> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
>> index 311edb65567c..5a5532a20019 100644
>> --- a/include/uapi/linux/btrfs.h
>> +++ b/include/uapi/linux/btrfs.h
>> @@ -74,21 +74,20 @@ struct btrfs_qgroup_limit {
>>  	__u64	rsv_excl;
>>  };
>> =20
>> -/*
>> - * flags definition for qgroup inheritance
>> - *
>> - * Used by:
>> - * struct btrfs_qgroup_inherit.flags
>> - */
>> +/* flags definition for qgroup inheritance (DEPRECATED) */
>>  #define BTRFS_QGROUP_INHERIT_SET_LIMITS	(1ULL << 0)
>> =20
>> +/* No supported flags */
>> +#define BTRFS_QGROUP_INHERIT_FLAGS_SUPP (0)
>> +
>>  #define BTRFS_QGROUP_INHERIT_MAX_SIZE	(SZ_4K)
>> +
>>  struct btrfs_qgroup_inherit {
>>  	__u64	flags;
>>  	__u64	num_qgroups;
>> -	__u64	num_ref_copies;
>> -	__u64	num_excl_copies;
>> -	struct btrfs_qgroup_limit lim;
>> +	__u64	num_ref_copies;		/* DEPRECATED */
>> +	__u64	num_excl_copies;	/* DEPRECATED */
>> +	struct btrfs_qgroup_limit lim;	/* DEPRECATED */
>>  	__u64	qgroups[0];
>>  };
>> =20
>> --=20
>> 2.18.0
>>


--J2u7k9iHfFvd2TBkc869NAiEMJijuzCXz--

--7ZGMm8bcvDTUO7SZUXzEUGNuH7lIBbNeQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAluTCrQACgkQwj2R86El
/qjA7wgAm8Oo6EhxkgS6wqjBx2DjcFcnE/Qfo5UYwx1i/csnvYW6eBoipZU9akiw
1lFl7c/ltsm7OJbBaqHLf6uhw5Sg7c5fzsciXrv4p3/3yovMj7T6s4vovT03UKiW
qPS/ctjuplOPFmVmIT69sNn5IvGqPOLEEQqAAlq3okU/hQ6h/Dj7kYDta4GcfT7Y
V+zeCNHA349v4dAQRYObHbOs0q9Rq4R40lsCnEQg5jg7dlHX+/CTDJf4sk+P+11Z
oBHfHzErjjrVqOCWVjam5aBqsQJibXO/0sRCMaOqLwkWfihWFdqJGuVvEeSx8a3+
eKIK/nJahcB0jPeiM84stAVK/m4f+Q==
=sach
-----END PGP SIGNATURE-----

--7ZGMm8bcvDTUO7SZUXzEUGNuH7lIBbNeQ--
