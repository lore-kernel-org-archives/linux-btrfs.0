Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:51381 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726419AbeGTE00 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jul 2018 00:26:26 -0400
Subject: Re: [PATCH v14.8 12/14] btrfs: dedupe: Add ioctl for inband
 deduplication
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>, Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
References: <20180712012553.29431-1-lufq.fnst@cn.fujitsu.com>
 <20180712012553.29431-13-lufq.fnst@cn.fujitsu.com>
 <eb469fdc-4e3c-7fd0-e583-af54bac40e0b@jp.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <c81e24d9-8d55-e323-0fe9-d57bb46d4cae@gmx.com>
Date: Fri, 20 Jul 2018 11:39:50 +0800
MIME-Version: 1.0
In-Reply-To: <eb469fdc-4e3c-7fd0-e583-af54bac40e0b@jp.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="gCKoCvL3dk2JcqAp69itevHEWpMrtczQn"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gCKoCvL3dk2JcqAp69itevHEWpMrtczQn
Content-Type: multipart/mixed; boundary="DFeZ45zfcfxcQYTnSNcvh0cpmFwxVoZet";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>, Lu Fengqi
 <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Message-ID: <c81e24d9-8d55-e323-0fe9-d57bb46d4cae@gmx.com>
Subject: Re: [PATCH v14.8 12/14] btrfs: dedupe: Add ioctl for inband
 deduplication
References: <20180712012553.29431-1-lufq.fnst@cn.fujitsu.com>
 <20180712012553.29431-13-lufq.fnst@cn.fujitsu.com>
 <eb469fdc-4e3c-7fd0-e583-af54bac40e0b@jp.fujitsu.com>
In-Reply-To: <eb469fdc-4e3c-7fd0-e583-af54bac40e0b@jp.fujitsu.com>

--DFeZ45zfcfxcQYTnSNcvh0cpmFwxVoZet
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8820=E6=97=A5 08:47, Tsutomu Itoh wrote:
> On 2018/07/12 10:25, Lu Fengqi wrote:
>> From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
>>
>> Add ioctl interface for inband deduplication, which includes:
>> 1) enable
>> 2) disable
>> 3) status
>>
>> And a pseudo RO compat flag, to imply that btrfs now supports inband
>> dedup.
>> However we don't add any ondisk format change, it's just a pseudo RO
>> compat flag.
>>
>> All these ioctl interfaces are state-less, which means caller don't ne=
ed
>> to bother previous dedupe state before calling them, and only need to
>> care the final desired state.
>>
>> For example, if user want to enable dedupe with specified block size a=
nd
>> limit, just fill the ioctl structure and call enable ioctl.
>> No need to check if dedupe is already running.
>>
>> These ioctls will handle things like re-configure or disable quite wel=
l.
>>
>> Also, for invalid parameters, enable ioctl interface will set the fiel=
d
>> of the first encountered invalid parameter to (-1) to inform caller.
>> While for limit_nr/limit_mem, the value will be (0).
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
>> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
>> ---
>>  fs/btrfs/dedupe.c          | 50 ++++++++++++++++++++++++++++
>>  fs/btrfs/dedupe.h          | 17 +++++++---
>>  fs/btrfs/disk-io.c         |  3 ++
>>  fs/btrfs/ioctl.c           | 67 +++++++++++++++++++++++++++++++++++++=
+
>>  fs/btrfs/sysfs.c           |  2 ++
>>  include/uapi/linux/btrfs.h | 12 ++++++-
>>  6 files changed, 145 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/btrfs/dedupe.c b/fs/btrfs/dedupe.c
>> index 14c8d245480e..f068321fdd1c 100644
>> --- a/fs/btrfs/dedupe.c
>> +++ b/fs/btrfs/dedupe.c
>> @@ -29,6 +29,35 @@ static inline struct inmem_hash *inmem_alloc_hash(u=
16 algo)
>>  			GFP_NOFS);
>>  }
>> =20
>> +void btrfs_dedupe_status(struct btrfs_fs_info *fs_info,
>> +			 struct btrfs_ioctl_dedupe_args *dargs)
>> +{
>> +	struct btrfs_dedupe_info *dedupe_info =3D fs_info->dedupe_info;
>> +
>> +	if (!fs_info->dedupe_enabled || !dedupe_info) {
>> +		dargs->status =3D 0;
>> +		dargs->blocksize =3D 0;
>> +		dargs->backend =3D 0;
>> +		dargs->hash_algo =3D 0;
>> +		dargs->limit_nr =3D 0;
>> +		dargs->current_nr =3D 0;
>> +		memset(dargs->__unused, -1, sizeof(dargs->__unused));
>> +		return;
>> +	}
>> +	mutex_lock(&dedupe_info->lock);
>> +	dargs->status =3D 1;
>> +	dargs->blocksize =3D dedupe_info->blocksize;
>> +	dargs->backend =3D dedupe_info->backend;
>> +	dargs->hash_algo =3D dedupe_info->hash_algo;
>> +	dargs->limit_nr =3D dedupe_info->limit_nr;
>> +	dargs->limit_mem =3D dedupe_info->limit_nr *
>> +		(sizeof(struct inmem_hash) +
>> +		 btrfs_hash_sizes[dedupe_info->hash_algo]);
>> +	dargs->current_nr =3D dedupe_info->current_nr;
>> +	mutex_unlock(&dedupe_info->lock);
>> +	memset(dargs->__unused, -1, sizeof(dargs->__unused));
>> +}
>> +
>>  static int init_dedupe_info(struct btrfs_dedupe_info **ret_info,
>>  			    struct btrfs_ioctl_dedupe_args *dargs)
>>  {
>> @@ -409,6 +438,27 @@ static void unblock_all_writers(struct btrfs_fs_i=
nfo *fs_info)
>>  	percpu_up_write(sb->s_writers.rw_sem + SB_FREEZE_WRITE - 1);
>>  }
>> =20
>> +int btrfs_dedupe_cleanup(struct btrfs_fs_info *fs_info)
>> +{
>> +	struct btrfs_dedupe_info *dedupe_info;
>> +
>> +	fs_info->dedupe_enabled =3D 0;
>> +	/* same as disable */
>> +	smp_wmb();
>> +	dedupe_info =3D fs_info->dedupe_info;
>> +	fs_info->dedupe_info =3D NULL;
>> +
>> +	if (!dedupe_info)
>> +		return 0;
>> +
>> +	if (dedupe_info->backend =3D=3D BTRFS_DEDUPE_BACKEND_INMEMORY)
>> +		inmem_destroy(dedupe_info);
>> +
>> +	crypto_free_shash(dedupe_info->dedupe_driver);
>> +	kfree(dedupe_info);
>> +	return 0;
>> +}
>> +
>>  int btrfs_dedupe_disable(struct btrfs_fs_info *fs_info)
>>  {
>>  	struct btrfs_dedupe_info *dedupe_info;
>> diff --git a/fs/btrfs/dedupe.h b/fs/btrfs/dedupe.h
>> index ebcbb89d79a0..85a87093ab04 100644
>> --- a/fs/btrfs/dedupe.h
>> +++ b/fs/btrfs/dedupe.h
>> @@ -96,6 +96,15 @@ static inline struct btrfs_dedupe_hash *btrfs_dedup=
e_alloc_hash(u16 algo)
>>  int btrfs_dedupe_enable(struct btrfs_fs_info *fs_info,
>>  			struct btrfs_ioctl_dedupe_args *dargs);
>> =20
>> +
>> +/*
>> + * Get inband dedupe info
>> + * Since it needs to access different backends' hash size, which
>> + * is not exported, we need such simple function.
>> + */
>> +void btrfs_dedupe_status(struct btrfs_fs_info *fs_info,
>> +			 struct btrfs_ioctl_dedupe_args *dargs);
>> +
>>  /*
>>   * Disable dedupe and invalidate all its dedupe data.
>>   * Called at dedupe disable time.
>> @@ -107,12 +116,10 @@ int btrfs_dedupe_enable(struct btrfs_fs_info *fs=
_info,
>>  int btrfs_dedupe_disable(struct btrfs_fs_info *fs_info);
>> =20
>>  /*
>> - * Get current dedupe status.
>> - * Return 0 for success
>> - * No possible error yet
>> + * Cleanup current btrfs_dedupe_info
>> + * Called in umount time
>>   */
>> -void btrfs_dedupe_status(struct btrfs_fs_info *fs_info,
>> -			 struct btrfs_ioctl_dedupe_args *dargs);
>> +int btrfs_dedupe_cleanup(struct btrfs_fs_info *fs_info);
>> =20
>>  /*
>>   * Calculate hash for dedupe.
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index cf0ddd5d8108..5f0397747832 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -40,6 +40,7 @@
>>  #include "compression.h"
>>  #include "tree-checker.h"
>>  #include "ref-verify.h"
>> +#include "dedupe.h"
>> =20
>>  #ifdef CONFIG_X86
>>  #include <asm/cpufeature.h>
>> @@ -4026,6 +4027,8 @@ void close_ctree(struct btrfs_fs_info *fs_info)
>>  	btrfs_free_qgroup_config(fs_info);
>>  	ASSERT(list_empty(&fs_info->delalloc_roots));
>> =20
>> +	btrfs_dedupe_cleanup(fs_info);
>> +
>>  	if (percpu_counter_sum(&fs_info->delalloc_bytes)) {
>>  		btrfs_info(fs_info, "at unmount delalloc count %lld",
>>  		       percpu_counter_sum(&fs_info->delalloc_bytes));
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index bd6498a9c924..a8220ae9fc29 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -3627,6 +3627,69 @@ ssize_t btrfs_dedupe_file_range(struct file *sr=
c_file, u64 loff, u64 olen,
>>  	return olen;
>>  }
>> =20
>> +static long btrfs_ioctl_dedupe_ctl(struct btrfs_root *root, void __us=
er *args)
>> +{
>> +	struct btrfs_ioctl_dedupe_args *dargs;
>> +	struct btrfs_fs_info *fs_info =3D root->fs_info;
>> +	int ret =3D 0;
>> +
>> +	if (!capable(CAP_SYS_ADMIN))
>> +		return -EPERM;
>> +
>> +	dargs =3D memdup_user(args, sizeof(*dargs));
>> +	if (IS_ERR(dargs)) {
>> +		ret =3D PTR_ERR(dargs);
>> +		return ret;
>> +	}
>> +
>> +	if (dargs->cmd >=3D BTRFS_DEDUPE_CTL_LAST) {
>> +		ret =3D -EINVAL;
>> +		goto out;
>> +	}
>> +	switch (dargs->cmd) {
>> +	case BTRFS_DEDUPE_CTL_ENABLE:
>> +		mutex_lock(&fs_info->dedupe_ioctl_lock);
>> +		ret =3D btrfs_dedupe_enable(fs_info, dargs);
>> +		/*
>> +		 * Also copy the result to caller for further use
>> +		 * if enable succeeded.
>> +		 * For error case, dargs is already set up with
>> +		 * special values indicating error reason.
>> +		 */
>> +		if (!ret)
>> +			btrfs_dedupe_status(fs_info, dargs);
>> +		mutex_unlock(&fs_info->dedupe_ioctl_lock);
>> +		break;
>> +	case BTRFS_DEDUPE_CTL_DISABLE:
>> +		mutex_lock(&fs_info->dedupe_ioctl_lock);
>> +		ret =3D btrfs_dedupe_disable(fs_info);
>> +		btrfs_dedupe_status(fs_info, dargs);
>> +		mutex_unlock(&fs_info->dedupe_ioctl_lock);
>> +		break;
>> +	case BTRFS_DEDUPE_CTL_STATUS:
>> +		mutex_lock(&fs_info->dedupe_ioctl_lock);
>> +		btrfs_dedupe_status(fs_info, dargs);
>> +		mutex_unlock(&fs_info->dedupe_ioctl_lock);
>> +		break;
>> +	default:
>> +		/*
>> +		 * Use this return value to inform progs that kernel
>> +		 * doesn't support such new command.
>> +		 */
>> +		ret =3D -EOPNOTSUPP;
>> +		goto out;
>> +	}
>> +	/*
>> +	 * All ioctl subcommand will modify user dargs,
>> +	 * Don't override return value unless copy fails
>> +	 */
>> +	if (copy_to_user(args, dargs, sizeof(*dargs)))
>> +		ret =3D -EFAULT;
>> +out:
>> +	kfree(dargs);
>> +	return ret;
>> +}
>> +
>>  static int clone_finish_inode_update(struct btrfs_trans_handle *trans=
,
>>  				     struct inode *inode,
>>  				     u64 endoff,
>> @@ -5961,6 +6024,10 @@ long btrfs_ioctl(struct file *file, unsigned in=
t
>>  		return btrfs_ioctl_get_fslabel(file, argp);
>>  	case BTRFS_IOC_SET_FSLABEL:
>>  		return btrfs_ioctl_set_fslabel(file, argp);
>=20
>> +#ifdef CONFIG_BTRFS_DEBUG
>=20
> Is it better to use a different config symbol than CONFIG_BTRFS_DEBUG?
> (For example, CONFIG_BTRFS_INBAND_DEDUPE)

The original idea is, inband dedupe is still an experimental feature,
and at that time, we don't really want end user to try that feature, so
we hide inband dedupe ioctl interface under BTRFS_DEBUG config.
Since most distribution won't select that config, thus only people
compiling their own kernel and enabled that config can access the new
feature.

But since we have gone through so many iterations, I think it's OK to
remove that #ifdef completely.

Thanks,
Qu

>=20
> Thanks,
> Tsutomu
>=20
>> +	case BTRFS_IOC_DEDUPE_CTL:
>> +		return btrfs_ioctl_dedupe_ctl(root, argp);
>> +#endif
>>  	case BTRFS_IOC_GET_SUPPORTED_FEATURES:
>>  		return btrfs_ioctl_get_supported_features(argp);
>>  	case BTRFS_IOC_GET_FEATURES:
>> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
>> index 4a4e960c7c66..bb23b1222fdf 100644
>> --- a/fs/btrfs/sysfs.c
>> +++ b/fs/btrfs/sysfs.c
>> @@ -194,6 +194,7 @@ BTRFS_FEAT_ATTR_INCOMPAT(raid56, RAID56);
>>  BTRFS_FEAT_ATTR_INCOMPAT(skinny_metadata, SKINNY_METADATA);
>>  BTRFS_FEAT_ATTR_INCOMPAT(no_holes, NO_HOLES);
>>  BTRFS_FEAT_ATTR_COMPAT_RO(free_space_tree, FREE_SPACE_TREE);
>> +BTRFS_FEAT_ATTR_COMPAT_RO(dedupe, DEDUPE);
>> =20
>>  static struct attribute *btrfs_supported_feature_attrs[] =3D {
>>  	BTRFS_FEAT_ATTR_PTR(mixed_backref),
>> @@ -207,6 +208,7 @@ static struct attribute *btrfs_supported_feature_a=
ttrs[] =3D {
>>  	BTRFS_FEAT_ATTR_PTR(skinny_metadata),
>>  	BTRFS_FEAT_ATTR_PTR(no_holes),
>>  	BTRFS_FEAT_ATTR_PTR(free_space_tree),
>> +	BTRFS_FEAT_ATTR_PTR(dedupe),
>>  	NULL
>>  };
>> =20
>> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
>> index 77c9219f54fe..95286dc7e683 100644
>> --- a/include/uapi/linux/btrfs.h
>> +++ b/include/uapi/linux/btrfs.h
>> @@ -252,6 +252,7 @@ struct btrfs_ioctl_fs_info_args {
>>   * first mount when booting older kernel versions.
>>   */
>>  #define BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE_VALID	(1ULL << 1)
>> +#define BTRFS_FEATURE_COMPAT_RO_DEDUPE		(1ULL << 2)
>> =20
>>  #define BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF	(1ULL << 0)
>>  #define BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL	(1ULL << 1)
>> @@ -684,7 +685,14 @@ struct btrfs_ioctl_get_dev_stats {
>> =20
>>  /* Default dedupe limit on number of hash */
>>  #define BTRFS_DEDUPE_LIMIT_NR_DEFAULT	(32 * 1024)
>> -
>> +/*
>> + * de-duplication control modes
>> + * For re-config, re-enable will handle it
>> + */
>> +#define BTRFS_DEDUPE_CTL_ENABLE	1
>> +#define BTRFS_DEDUPE_CTL_DISABLE 2
>> +#define BTRFS_DEDUPE_CTL_STATUS	3
>> +#define BTRFS_DEDUPE_CTL_LAST	4
>>  /*
>>   * This structure is used for dedupe enable/disable/configure
>>   * and status ioctl.
>> @@ -960,6 +968,8 @@ enum btrfs_err_code {
>>  				    struct btrfs_ioctl_dev_replace_args)
>>  #define BTRFS_IOC_FILE_EXTENT_SAME _IOWR(BTRFS_IOCTL_MAGIC, 54, \
>>  					 struct btrfs_ioctl_same_args)
>> +#define BTRFS_IOC_DEDUPE_CTL	_IOWR(BTRFS_IOCTL_MAGIC, 55, \
>> +				      struct btrfs_ioctl_dedupe_args)
>>  #define BTRFS_IOC_GET_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 57, \
>>  				   struct btrfs_ioctl_feature_flags)
>>  #define BTRFS_IOC_SET_FEATURES _IOW(BTRFS_IOCTL_MAGIC, 57, \
>>
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--DFeZ45zfcfxcQYTnSNcvh0cpmFwxVoZet--

--gCKoCvL3dk2JcqAp69itevHEWpMrtczQn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltRWYYACgkQwj2R86El
/qj3cAf+MfNI+vejdJGwnVh8TmIdGX5o7nrlXRrzuJZ/7KQZR0hhLTenHbCmTmh5
bJwBfy8g1qOh1weX4YLiF5btSk5EOiNZSmQga9Ws6AGcIqhxhXsaha7RzeuQwy9S
jFa9BLmp33B01E1NBJP2Y1pnU0xg7Q57QB9BtH+4O87jSz5FrDEsMIBuapYoZR4A
OG9HYf0DulqpdR00orCuewEFvtcQNcSsR0oa8Gz5vWE0VuMb/VYaEqK4YOuhVs1/
J8O2eeAaQVVlhFHLBg3v3zGTCnu/59UQ1PhSU/SFCarKZdz9ikIfzWJR9J4BhlFL
/YiTP45bvIjpwXdEQJMdFOn0/XwPIA==
=vC7E
-----END PGP SIGNATURE-----

--gCKoCvL3dk2JcqAp69itevHEWpMrtczQn--
