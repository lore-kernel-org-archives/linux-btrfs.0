Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44328 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332Ab3J2StX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Oct 2013 14:49:23 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id B544AA5D64
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Oct 2013 19:49:21 +0100 (CET)
Message-ID: <5270032B.3050508@suse.com>
Date: Tue, 29 Oct 2013 14:49:15 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com
Subject: Re: [patch 10/13] btrfs: publish allocation data in sysfs
References: <20131021211940.432195222@suse.com> <20131021212008.047727368@suse.com>
In-Reply-To: <20131021212008.047727368@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="gPSJMRtGBLH46q0bOkPNUSlPd0FDLDJFs"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gPSJMRtGBLH46q0bOkPNUSlPd0FDLDJFs
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/21/13, 5:19 PM, Jeff Mahoney wrote:
> While trying to debug ENOSPC issues, it's helpful to understand what th=
e
> kernel's view of the available space is. We export this information
> via ioctl, but sysfs files are more easily used.
>=20
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  fs/btrfs/ctree.h       |    5 +
>  fs/btrfs/extent-tree.c |   72 ++++++++++++++++++++++-
>  fs/btrfs/sysfs.c       |  148 ++++++++++++++++++++++++++++++++++++++++=
+++++++++
>  fs/btrfs/sysfs.h       |    8 ++
>  4 files changed, 228 insertions(+), 5 deletions(-)
>=20
> --- a/fs/btrfs/ctree.h	2013-10-21 16:10:00.212037722 -0400
> +++ b/fs/btrfs/ctree.h	2013-10-21 16:10:02.743982088 -0400
> @@ -1143,6 +1143,9 @@ struct btrfs_space_info {
>  	spinlock_t lock;
>  	struct rw_semaphore groups_sem;
>  	wait_queue_head_t wait;
> +
> +	struct kobject kobj;
> +	struct kobject block_group_kobjs[BTRFS_NR_RAID_TYPES];
>  };
> =20
>  #define	BTRFS_BLOCK_RSV_GLOBAL		1
> @@ -1518,6 +1521,7 @@ struct btrfs_fs_info {
>  	int thread_pool_size;
> =20
>  	struct kobject super_kobj;
> +	struct kobject *space_info_kobj;
>  	struct completion kobj_unregister;
>  	int do_barriers;
>  	int closing;
> @@ -3171,6 +3175,7 @@ struct btrfs_block_group_cache *btrfs_lo
>  						 struct btrfs_fs_info *info,
>  						 u64 bytenr);
>  void btrfs_put_block_group(struct btrfs_block_group_cache *cache);
> +int get_block_group_index(struct btrfs_block_group_cache *cache);
>  struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle=
 *trans,
>  					struct btrfs_root *root, u32 blocksize,
>  					u64 parent, u64 root_objectid,
> --- a/fs/btrfs/extent-tree.c	2013-10-21 16:09:33.476623940 -0400
> +++ b/fs/btrfs/extent-tree.c	2013-10-21 16:10:02.751981911 -0400
> @@ -36,6 +36,7 @@
>  #include "locking.h"
>  #include "free-space-cache.h"
>  #include "math.h"
> +#include "sysfs.h"
> =20
>  #undef SCRAMBLE_DELAYED_REFS
> =20
> @@ -3389,6 +3390,13 @@ int btrfs_extent_readonly(struct btrfs_r
>  	return readonly;
>  }
> =20
> +static const char * const alloc_names[] =3D {
> +	"data",
> +	"system",
> +	"mixed",
> +	"metadata",
> +};
> +

Sigh. There was a missing quilt refresh here. This obviously doesn't work=
=2E

-Jeff


>  static int update_space_info(struct btrfs_fs_info *info, u64 flags,
>  			     u64 total_bytes, u64 bytes_used,
>  			     struct btrfs_space_info **space_info)
> @@ -3444,11 +3452,21 @@ static int update_space_info(struct btrf
>  	found->chunk_alloc =3D 0;
>  	found->flush =3D 0;
>  	init_waitqueue_head(&found->wait);
> +
> +	ret =3D kobject_init_and_add(&found->kobj, &space_info_ktype,
> +				    info->space_info_kobj, "%s",
> +				    alloc_names[found->flags - 1]);
> +	if (ret) {
> +		kfree(found);
> +		return ret;
> +	}
> +
>  	*space_info =3D found;
>  	list_add_rcu(&found->list, &info->space_info);
>  	if (flags & BTRFS_BLOCK_GROUP_DATA)
>  		info->data_sinfo =3D found;
> -	return 0;
> +
> +	return ret;
>  }
> =20
>  static void set_avail_alloc_bits(struct btrfs_fs_info *fs_info, u64 fl=
ags)
> @@ -6090,11 +6108,29 @@ int __get_raid_index(u64 flags)
>  	return BTRFS_RAID_SINGLE; /* BTRFS_BLOCK_GROUP_SINGLE */
>  }
> =20
> -static int get_block_group_index(struct btrfs_block_group_cache *cache=
)
> +int get_block_group_index(struct btrfs_block_group_cache *cache)
>  {
>  	return __get_raid_index(cache->flags);
>  }
> =20
> +static const char *btrfs_raid_type_names[BTRFS_NR_RAID_TYPES] =3D {
> +	[BTRFS_RAID_RAID10]	=3D "raid10",
> +	[BTRFS_RAID_RAID1]	=3D "raid1",
> +	[BTRFS_RAID_DUP]	=3D "dup",
> +	[BTRFS_RAID_RAID0]	=3D "raid0",
> +	[BTRFS_RAID_SINGLE]	=3D "single",
> +	[BTRFS_RAID_RAID5]	=3D "raid5",
> +	[BTRFS_RAID_RAID6]	=3D "raid6",
> +};
> +
> +const char *get_raid_name(enum btrfs_raid_types type)
> +{
> +	if (type >=3D BTRFS_NR_RAID_TYPES)
> +		return NULL;
> +
> +	return btrfs_raid_type_names[type];
> +}
> +
>  enum btrfs_loop_type {
>  	LOOP_CACHING_NOWAIT =3D 0,
>  	LOOP_CACHING_WAIT =3D 1,
> @@ -8272,6 +8308,8 @@ int btrfs_free_block_groups(struct btrfs
>  	release_global_block_rsv(info);
> =20
>  	while(!list_empty(&info->space_info)) {
> +		int i;
> +
>  		space_info =3D list_entry(info->space_info.next,
>  					struct btrfs_space_info,
>  					list);
> @@ -8283,9 +8321,17 @@ int btrfs_free_block_groups(struct btrfs
>  				dump_space_info(space_info, 0, 0);
>  			}
>  		}
> -		percpu_counter_destroy(&space_info->total_bytes_pinned);
>  		list_del(&space_info->list);
> -		kfree(space_info);
> +		for (i =3D 0; i < BTRFS_NR_RAID_TYPES; i++) {
> +			struct kobject *kobj;
> +			kobj =3D &space_info->block_group_kobjs[i];
> +			if (kobj->parent) {
> +				kobject_del(kobj);
> +				kobject_put(kobj);
> +			}
> +		}
> +		kobject_del(&space_info->kobj);
> +		kobject_put(&space_info->kobj);
>  	}
>  	return 0;
>  }
> @@ -8296,6 +8342,19 @@ static void __link_block_group(struct bt
>  	int index =3D get_block_group_index(cache);
> =20
>  	down_write(&space_info->groups_sem);
> +	if (list_empty(&space_info->block_groups[index])) {
> +		struct kobject *kobj =3D &space_info->block_group_kobjs[index];
> +		int ret;
> +
> +		kobject_get(&space_info->kobj); /* put in release */
> +		ret =3D kobject_init_and_add(kobj, &btrfs_raid_ktype,
> +					   &space_info->kobj,
> +					   get_raid_name(index));
> +		if (ret) {
> +			pr_warn("btrfs: failed to add kobject for block cache. ignoring.\n"=
);
> +			kobject_put(&space_info->kobj);
> +		}
> +	}
>  	list_add_tail(&cache->list, &space_info->block_groups[index]);
>  	up_write(&space_info->groups_sem);
>  }
> @@ -8736,8 +8795,11 @@ int btrfs_remove_block_group(struct btrf
>  	 * are still on the list after taking the semaphore
>  	 */
>  	list_del_init(&block_group->list);
> -	if (list_empty(&block_group->space_info->block_groups[index]))
> +	if (list_empty(&block_group->space_info->block_groups[index])) {
> +		kobject_del(&block_group->space_info->block_group_kobjs[index]);
> +		kobject_put(&block_group->space_info->block_group_kobjs[index]);
>  		clear_avail_alloc_bits(root->fs_info, block_group->flags);
> +	}
>  	up_write(&block_group->space_info->groups_sem);
> =20
>  	if (block_group->cached =3D=3D BTRFS_CACHE_STARTED)
> --- a/fs/btrfs/sysfs.c	2013-10-21 16:10:01.856001602 -0400
> +++ b/fs/btrfs/sysfs.c	2013-10-21 16:10:02.751981911 -0400
> @@ -219,6 +219,140 @@ static const struct attribute_group btrf
>  	.attrs =3D btrfs_supported_feature_attrs,
>  };
> =20
> +static ssize_t btrfs_show_u64(u64 *value_ptr, spinlock_t *lock, char *=
buf)
> +{
> +	u64 val;
> +	if (lock)
> +		spin_lock(lock);
> +	val =3D *value_ptr;
> +	if (lock)
> +		spin_unlock(lock);
> +	return snprintf(buf, PAGE_SIZE, "%llu\n", val);
> +}
> +
> +static ssize_t global_rsv_size_show(struct kobject *kobj,
> +				    struct kobj_attribute *ka, char *buf)
> +{
> +	struct btrfs_fs_info *fs_info =3D to_fs_info(kobj->parent);
> +	struct btrfs_block_rsv *block_rsv =3D &fs_info->global_block_rsv;
> +	return btrfs_show_u64(&block_rsv->size, &block_rsv->lock, buf);
> +}
> +BTRFS_ATTR(global_rsv_size, 0444, global_rsv_size_show);
> +
> +static ssize_t global_rsv_reserved_show(struct kobject *kobj,
> +					struct kobj_attribute *a, char *buf)
> +{
> +	struct btrfs_fs_info *fs_info =3D to_fs_info(kobj->parent);
> +	struct btrfs_block_rsv *block_rsv =3D &fs_info->global_block_rsv;
> +	return btrfs_show_u64(&block_rsv->reserved, &block_rsv->lock, buf);
> +}
> +BTRFS_ATTR(global_rsv_reserved, 0444, global_rsv_reserved_show);
> +
> +#define to_space_info(_kobj) container_of(_kobj, struct btrfs_space_in=
fo, kobj)
> +
> +static ssize_t raid_bytes_show(struct kobject *kobj,
> +			       struct kobj_attribute *attr, char *buf);
> +BTRFS_RAID_ATTR(total_bytes, raid_bytes_show);
> +BTRFS_RAID_ATTR(used_bytes, raid_bytes_show);
> +
> +static ssize_t raid_bytes_show(struct kobject *kobj,
> +			       struct kobj_attribute *attr, char *buf)
> +
> +{
> +	struct btrfs_space_info *sinfo =3D to_space_info(kobj->parent);
> +	struct btrfs_block_group_cache *block_group;
> +	int index =3D kobj - sinfo->block_group_kobjs;
> +	u64 val =3D 0;
> +
> +	down_read(&sinfo->groups_sem);
> +	list_for_each_entry(block_group, &sinfo->block_groups[index], list) {=

> +		if (&attr->attr =3D=3D BTRFS_RAID_ATTR_PTR(total_bytes))
> +			val +=3D block_group->key.offset;
> +		else
> +			val +=3D btrfs_block_group_used(&block_group->item);
> +	}
> +	up_read(&sinfo->groups_sem);
> +	return snprintf(buf, PAGE_SIZE, "%llu\n", val);
> +}
> +
> +static struct attribute *raid_attributes[] =3D {
> +	BTRFS_RAID_ATTR_PTR(total_bytes),
> +	BTRFS_RAID_ATTR_PTR(used_bytes),
> +	NULL
> +};
> +
> +static void release_raid_kobj(struct kobject *kobj)
> +{
> +	kobject_put(kobj->parent);
> +}
> +
> +struct kobj_type btrfs_raid_ktype =3D {
> +	.sysfs_ops =3D &kobj_sysfs_ops,
> +	.release =3D release_raid_kobj,
> +	.default_attrs =3D raid_attributes,
> +};
> +
> +#define SPACE_INFO_ATTR(field)						\
> +static ssize_t btrfs_space_info_show_##field(struct kobject *kobj,	\
> +					     struct kobj_attribute *a,	\
> +					     char *buf)			\
> +{									\
> +	struct btrfs_space_info *sinfo =3D to_space_info(kobj);		\
> +	return btrfs_show_u64(&sinfo->field, &sinfo->lock, buf);	\
> +}									\
> +BTRFS_ATTR(field, 0444, btrfs_space_info_show_##field)
> +
> +static ssize_t btrfs_space_info_show_total_bytes_pinned(struct kobject=
 *kobj,
> +						       struct kobj_attribute *a,
> +						       char *buf)
> +{
> +	struct btrfs_space_info *sinfo =3D to_space_info(kobj);
> +	s64 val =3D percpu_counter_sum(&sinfo->total_bytes_pinned);
> +	return snprintf(buf, PAGE_SIZE, "%lld\n", val);
> +}
> +
> +SPACE_INFO_ATTR(flags);
> +SPACE_INFO_ATTR(total_bytes);
> +SPACE_INFO_ATTR(bytes_used);
> +SPACE_INFO_ATTR(bytes_pinned);
> +SPACE_INFO_ATTR(bytes_reserved);
> +SPACE_INFO_ATTR(bytes_may_use);
> +SPACE_INFO_ATTR(disk_used);
> +SPACE_INFO_ATTR(disk_total);
> +BTRFS_ATTR(total_bytes_pinned, 0444, btrfs_space_info_show_total_bytes=
_pinned);
> +
> +static struct attribute *space_info_attrs[] =3D {
> +	BTRFS_ATTR_PTR(flags),
> +	BTRFS_ATTR_PTR(total_bytes),
> +	BTRFS_ATTR_PTR(bytes_used),
> +	BTRFS_ATTR_PTR(bytes_pinned),
> +	BTRFS_ATTR_PTR(bytes_reserved),
> +	BTRFS_ATTR_PTR(bytes_may_use),
> +	BTRFS_ATTR_PTR(disk_used),
> +	BTRFS_ATTR_PTR(disk_total),
> +	BTRFS_ATTR_PTR(total_bytes_pinned),
> +	NULL,
> +};
> +
> +static void space_info_release(struct kobject *kobj)
> +{
> +	struct btrfs_space_info *sinfo =3D to_space_info(kobj);
> +	percpu_counter_destroy(&sinfo->total_bytes_pinned);
> +	kfree(sinfo);
> +}
> +
> +struct kobj_type space_info_ktype =3D {
> +	.sysfs_ops =3D &kobj_sysfs_ops,
> +	.release =3D space_info_release,
> +	.default_attrs =3D space_info_attrs,
> +};
> +
> +static const struct attribute *allocation_attrs[] =3D {
> +	BTRFS_ATTR_PTR(global_rsv_reserved),
> +	BTRFS_ATTR_PTR(global_rsv_size),
> +	NULL,
> +};
> +
>  static void btrfs_release_super_kobj(struct kobject *kobj)
>  {
>  	struct btrfs_fs_info *fs_info =3D to_fs_info(kobj);
> @@ -239,6 +373,9 @@ static inline struct btrfs_fs_info *to_f
> =20
>  void btrfs_sysfs_remove_one(struct btrfs_fs_info *fs_info)
>  {
> +	sysfs_remove_files(fs_info->space_info_kobj, allocation_attrs);
> +	kobject_del(fs_info->space_info_kobj);
> +	kobject_put(fs_info->space_info_kobj);
>  	kobject_del(&fs_info->super_kobj);
>  	kobject_put(&fs_info->super_kobj);
>  	wait_for_completion(&fs_info->kobj_unregister);
> @@ -391,6 +528,17 @@ int btrfs_sysfs_add_one(struct btrfs_fs_
>  	if (error)
>  		goto failure;
> =20
> +	fs_info->space_info_kobj =3D kobject_create_and_add("allocation",
> +						  &fs_info->super_kobj);
> +	if (!fs_info->space_info_kobj) {
> +		error =3D -ENOMEM;
> +		goto failure;
> +	}
> +
> +	error =3D sysfs_create_files(fs_info->space_info_kobj, allocation_att=
rs);
> +	if (error)
> +		goto failure;
> +
>  	return 0;
>  failure:
>  	btrfs_sysfs_remove_one(fs_info);
> --- a/fs/btrfs/sysfs.h	2013-10-21 16:10:01.860001514 -0400
> +++ b/fs/btrfs/sysfs.h	2013-10-21 16:10:02.751981911 -0400
> @@ -22,6 +22,12 @@ static struct kobj_attribute btrfs_attr_
>  	BTRFS_ATTR_RW(_name, _mode, _show, NULL)
>  #define BTRFS_ATTR_PTR(_name)    (&btrfs_attr_##_name.attr)
> =20
> +#define BTRFS_RAID_ATTR(_name, _show)					\
> +static struct kobj_attribute btrfs_raid_attr_##_name =3D			\
> +			__INIT_KOBJ_ATTR(_name, 0444, _show, NULL)
> +#define BTRFS_RAID_ATTR_PTR(_name)    (&btrfs_raid_attr_##_name.attr)
> +
> +
>  struct btrfs_feature_attr {
>  	struct kobj_attribute kobj_attr;
>  	enum btrfs_feature_set feature_set;
> @@ -53,4 +59,6 @@ static struct btrfs_feature_attr btrfs_a
>  			to_btrfs_feature_attr(attr_to_btrfs_attr(a))
>  char *btrfs_printable_features(enum btrfs_feature_set set, u64 flags);=

>  extern const char * const btrfs_feature_set_names[3];
> +extern struct kobj_type space_info_ktype;
> +extern struct kobj_type btrfs_raid_ktype;
>  #endif /* _BTRFS_SYSFS_H_ */
>=20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Jeff Mahoney
SUSE Labs


--gPSJMRtGBLH46q0bOkPNUSlPd0FDLDJFs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJScAMuAAoJEB57S2MheeWyc1kQALIWZtx6sBfUZ+yGT8QV94FL
NVZT0970qwYNVVGdQOeTBwUirsav6NEeczMgqqUSXXg9U+Tvl22nADmT241CaPgU
MPw8ubfAvCEguFLUYdC8mIpuv+5qy9UOLRbwk7+95kG6oD6kDco0MSM3j6BU/CXm
Q4ZyyWfn/P38+kRMvVKg8KXr7W6MrT7rtG67f5ZCuDtHrYa+lx3ilU3XN4N9rZPp
mocdJq6ChnHNZuIbhQYSe/GnGIbx/rZzOsJjvDKhScaVbrkwQx1ss7IGPWkVmlLF
++lrctmZ9dzCtDqB556eqMztHWV40LuxBO/Fy55eYzngq1Xl0BSOEPTJrDPI2ljr
tC6ngAxruFcKo5DKkUF+iRVDXbVVi+51FFHKsD+khkHN8g+21ky2ftKkfSeMXLjb
0axb8NO/dPuoDeVJA37xSPgT2g2DnC+t/NsrOJbYfDUeJ4eL1UFIgtooQcke/ndy
IjlNEh63FTQC7NonGZkdsTIErngyVYw4k4fFomzxXi+BYZqVFbDTyUxWLmd3nMZI
BMaS8FCdCVb8+j66cPVBHZFtvXO+hx1xFpnYqYto8InFZ3BYYAzSC1FcLZf7YvhB
fU8hhOYBisdPymkWgsd3hmwZU8cplwg9PgUdoRzJgsNneJcwnWnPp2KmWzlISVq4
wtsUD+OqnAdgvLDcpKzl
=Aefx
-----END PGP SIGNATURE-----

--gPSJMRtGBLH46q0bOkPNUSlPd0FDLDJFs--
