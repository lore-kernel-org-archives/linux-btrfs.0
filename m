From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH] btrfs: quasi-round-robin for chunk allocation
Date: Wed, 09 Feb 2011 11:03:01 +0800
Message-ID: <4D5203E5.7000902@cn.fujitsu.com>
References: <1297188212-23212-1-git-send-email-sensille@gmx.net>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: chris.mason@oracle.com, josef@redhat.com,
	linux-btrfs@vger.kernel.org
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1297188212-23212-1-git-send-email-sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Arne

Firstly, thanks for your patch.

On tue, 8 Feb 2011 19:03:32 +0100, Arne Jansen wrote:
> In a multi device setup, the chunk allocator currently always allocates
> chunks on the devices in the same order. This leads to a very uneven
> distribution, especially with RAID1 or RAID10 and an uneven number of
> devices.
> This patch always sorts the device before allocating, and allocates the
> stripes on the devices with the most available space, as long as there

Yes, the chunk allocator currently cannot allocates chunks on the devices
on the devices fairly. But your patch doesn't fix this problem, with your patch,
the chunk allocator will allocate chunks on the devices which have the most
available space, if we create btrfs filesystem on the devices with different size,
the chunk allocator will always allocate chunks on the devices with the most
available space, and can't spread the data across all the devices at the beginning.

Besides that, I think we needn't  sort the devices if we can allocate chunks by
the default size.

In fact, we just fix it by using list_splice_tail() instead of list_splice().
just like this(in __btrfs_alloc_chunk()):
-	list_splice(&private_devs, &fs_devices->alloc_list);
+	list_splice_tail(&private_devs, &fs_devices->alloc_list);

> is enough space available. In a low space situation, it first tries to
> maximize striping.

This feature has been implemented.

> The patch also simplifies the allocator and reduces the checks for
> corner cases. Additionally, alloc_start is now always heeded.

Yes, the code of the allocator is complex and ugly, it is necessary to simplify it.

Thanks
Miao

> 
> Signed-off-by: Arne Jansen<sensille@gmx.net>
> ---
>   fs/btrfs/super.c   |   25 +++
>   fs/btrfs/volumes.c |  469 +++++++++++++++++-----------------------------------
>   fs/btrfs/volumes.h |   16 +--
>   3 files changed, 181 insertions(+), 329 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index f4e45fd..1664a25 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -864,6 +864,31 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
>   	return 0;
>   }
> 
> +/* Used to sort the devices by max_avail(descending sort) */
> +int btrfs_cmp_device_free_bytes(const void *dev_info1, const void *dev_info2)
> +{
> +	if (((struct btrfs_device_info *)dev_info1)->max_avail>
> +	    ((struct btrfs_device_info *)dev_info2)->max_avail)
> +		return -1;
> +	else if (((struct btrfs_device_info *)dev_info1)->max_avail<
> +	         ((struct btrfs_device_info *)dev_info2)->max_avail)
> +		return 1;
> +	else
> +	return 0;
> +}
> +
> +/*
> + * sort the devices by max_avail, in which max free extent size of each device
> + * is stored.(Descending Sort)
> + */
> +static inline void btrfs_descending_sort_devices(
> +					struct btrfs_device_info *devices,
> +					size_t nr_devices)
> +{
> +	sort(devices, nr_devices, sizeof(struct btrfs_device_info),
> +	     btrfs_cmp_device_free_bytes, NULL);
> +}
> +
>   /*
>    * The helper to calc the free space on the devices that can be used to store
>    * file data.
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index f2d2f4c..a868ca4 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -859,10 +859,7 @@ int find_free_dev_extent(struct btrfs_trans_handle *trans,
>   	/* we don't want to overwrite the superblock on the drive,
>   	 * so we make sure to start at an offset of at least 1MB
>   	 */
> -	search_start = 1024 * 1024;
> -
> -	if (root->fs_info->alloc_start + num_bytes<= search_end)
> -		search_start = max(root->fs_info->alloc_start, search_start);
> +	search_start = max(root->fs_info->alloc_start, 1024ull * 1024);
> 
>   	max_hole_start = search_start;
>   	max_hole_size = 0;
> @@ -2255,418 +2252,262 @@ static int btrfs_add_system_chunk(struct btrfs_trans_handle *trans,
>   	return 0;
>   }
> 
> -static noinline u64 chunk_bytes_by_type(u64 type, u64 calc_size,
> -					int num_stripes, int sub_stripes)
> +/*
> + * sort the devices in descending order by max_avail, total_avail
> + */
> +static int btrfs_cmp_device_info(const void *a, const void *b)
>   {
> -	if (type&  (BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_DUP))
> -		return calc_size;
> -	else if (type&  BTRFS_BLOCK_GROUP_RAID10)
> -		return calc_size * (num_stripes / sub_stripes);
> -	else
> -		return calc_size * num_stripes;
> -}
> +	const struct btrfs_device_info *di_a = a;
> +	const struct btrfs_device_info *di_b = b;
> 
> -/* Used to sort the devices by max_avail(descending sort) */
> -int btrfs_cmp_device_free_bytes(const void *dev_info1, const void *dev_info2)
> -{
> -	if (((struct btrfs_device_info *)dev_info1)->max_avail>
> -	    ((struct btrfs_device_info *)dev_info2)->max_avail)
> +	if (di_a->max_avail>  di_b->max_avail)
>   		return -1;
> -	else if (((struct btrfs_device_info *)dev_info1)->max_avail<
> -		 ((struct btrfs_device_info *)dev_info2)->max_avail)
> +	if (di_a->max_avail<  di_b->max_avail)
>   		return 1;
> -	else
> -		return 0;
> +	if (di_a->total_avail>  di_b->total_avail)
> +		return -1;
> +	if (di_a->total_avail<  di_b->total_avail)
> +		return 1;
> +	return 0;
>   }
> 
> -static int __btrfs_calc_nstripes(struct btrfs_fs_devices *fs_devices, u64 type,
> -				 int *num_stripes, int *min_stripes,
> -				 int *sub_stripes)
> +static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
> +			       struct btrfs_root *extent_root,
> +			       struct map_lookup **map_ret,
> +			       u64 *num_bytes, u64 *stripe_size_out,
> +			       u64 start, u64 type)
>   {
> -	*num_stripes = 1;
> -	*min_stripes = 1;
> -	*sub_stripes = 0;
> +	struct btrfs_fs_info *info = extent_root->fs_info;
> +	struct btrfs_device *device = NULL;
> +	struct btrfs_fs_devices *fs_devices = info->fs_devices;
> +	struct list_head *cur;
> +	struct map_lookup *map = NULL;
> +	struct extent_map_tree *em_tree;
> +	struct extent_map *em;
> +	struct btrfs_device_info *devices_info = NULL;
> +	u64 total_avail;
> +	u64 max_avail;
> +	u64 dev_offset;
> +	int num_stripes;
> +	int sub_stripes;
> +	int dev_stripes;	/* stripes per dev */
> +	int devs_max;
> +	int devs_min;
> +	int devs_increment;
> +	int ncopies;
> +	int ret;
> +	u64 max_stripe_size;
> +	u64 max_chunk_size;
> +	u64 stripe_size;
> +	int ndevs;
> +	int index;
> +	int i;
> +	int j;
> 
> -	if (type&  (BTRFS_BLOCK_GROUP_RAID0)) {
> -		*num_stripes = fs_devices->rw_devices;
> -		*min_stripes = 2;
> -	}
> -	if (type&  (BTRFS_BLOCK_GROUP_DUP)) {
> -		*num_stripes = 2;
> -		*min_stripes = 2;
> -	}
> -	if (type&  (BTRFS_BLOCK_GROUP_RAID1)) {
> -		if (fs_devices->rw_devices<  2)
> -			return -ENOSPC;
> -		*num_stripes = 2;
> -		*min_stripes = 2;
> -	}
> -	if (type&  (BTRFS_BLOCK_GROUP_RAID10)) {
> -		*num_stripes = fs_devices->rw_devices;
> -		if (*num_stripes<  4)
> -			return -ENOSPC;
> -		*num_stripes&= ~(u32)1;
> -		*sub_stripes = 2;
> -		*min_stripes = 4;
> +	if ((type&  BTRFS_BLOCK_GROUP_RAID1)&&
> +	    (type&  BTRFS_BLOCK_GROUP_DUP)) {
> +		WARN_ON(1);
> +		type&= ~BTRFS_BLOCK_GROUP_DUP;
>   	}
> 
> -	return 0;
> -}
> +	if (list_empty(&fs_devices->alloc_list))
> +		return -ENOSPC;
> 
> -static u64 __btrfs_calc_stripe_size(struct btrfs_fs_devices *fs_devices,
> -				    u64 proposed_size, u64 type,
> -				    int num_stripes, int small_stripe)
> -{
> -	int min_stripe_size = 1 * 1024 * 1024;
> -	u64 calc_size = proposed_size;
> -	u64 max_chunk_size = calc_size;
> -	int ncopies = 1;
> 
> -	if (type&  (BTRFS_BLOCK_GROUP_RAID1 |
> -		    BTRFS_BLOCK_GROUP_DUP |
> -		    BTRFS_BLOCK_GROUP_RAID10))
> +	sub_stripes = 1;
> +	dev_stripes = 1;
> +	devs_increment = 1;
> +	ncopies = 1;
> +	devs_max = 0;	/* 0 == as many as possible */
> +	devs_min = 1;
> +
> +	if (type&  (BTRFS_BLOCK_GROUP_DUP)) {
> +		dev_stripes = 2;
> +		ncopies = 2;
> +		devs_max = 1;
> +	} else if (type&  (BTRFS_BLOCK_GROUP_RAID0)) {
> +		devs_min = 2;
> +	} else if (type&  (BTRFS_BLOCK_GROUP_RAID1)) {
> +		devs_increment = 2;
>   		ncopies = 2;
> +		devs_max = 2;
> +		devs_min = 2;
> +	} else if (type&  (BTRFS_BLOCK_GROUP_RAID10)) {
> +		sub_stripes = 2;
> +		devs_increment = 2;
> +		ncopies = 2;
> +		devs_min = 4;
> +	}
> 
>   	if (type&  BTRFS_BLOCK_GROUP_DATA) {
> -		max_chunk_size = 10 * calc_size;
> -		min_stripe_size = 64 * 1024 * 1024;
> +		max_stripe_size = 1024 * 1024 * 1024;
> +		max_chunk_size = 10 * max_stripe_size;
>   	} else if (type&  BTRFS_BLOCK_GROUP_METADATA) {
> -		max_chunk_size = 256 * 1024 * 1024;
> -		min_stripe_size = 32 * 1024 * 1024;
> +		max_stripe_size = 256 * 1024 * 1024;
> +		max_chunk_size = max_stripe_size;
>   	} else if (type&  BTRFS_BLOCK_GROUP_SYSTEM) {
> -		calc_size = 8 * 1024 * 1024;
> -		max_chunk_size = calc_size * 2;
> -		min_stripe_size = 1 * 1024 * 1024;
> +		max_stripe_size = 8 * 1024 * 1024;
> +		max_chunk_size = 2 * max_stripe_size;
> +	} else {
> +		BUG_ON(1);
>   	}
> 
>   	/* we don't want a chunk larger than 10% of writeable space */
>   	max_chunk_size = min(div_factor(fs_devices->total_rw_bytes, 1),
> -			     max_chunk_size);
> +	                     max_chunk_size);
> 
> -	if (calc_size * num_stripes>  max_chunk_size * ncopies) {
> -		calc_size = max_chunk_size * ncopies;
> -		do_div(calc_size, num_stripes);
> -		do_div(calc_size, BTRFS_STRIPE_LEN);
> -		calc_size *= BTRFS_STRIPE_LEN;
> -	}
> +	devices_info = kzalloc(sizeof(*devices_info) * fs_devices->rw_devices,
> +			       GFP_NOFS);
> +	if (!devices_info)
> +		return -ENOMEM;
> 
> -	/* we don't want tiny stripes */
> -	if (!small_stripe)
> -		calc_size = max_t(u64, min_stripe_size, calc_size);
> +	cur = fs_devices->alloc_list.next;
> 
>   	/*
> -	 * we're about to do_div by the BTRFS_STRIPE_LEN so lets make sure
> -	 * we end up with something bigger than a stripe
> +	 * in the first pass through the devices list, we gather information
> +	 * about the available holes on each device.
>   	 */
> -	calc_size = max_t(u64, calc_size, BTRFS_STRIPE_LEN);
> -
> -	do_div(calc_size, BTRFS_STRIPE_LEN);
> -	calc_size *= BTRFS_STRIPE_LEN;
> -
> -	return calc_size;
> -}
> -
> -static struct map_lookup *__shrink_map_lookup_stripes(struct map_lookup *map,
> -						      int num_stripes)
> -{
> -	struct map_lookup *new;
> -	size_t len = map_lookup_size(num_stripes);
> -
> -	BUG_ON(map->num_stripes<  num_stripes);
> -
> -	if (map->num_stripes == num_stripes)
> -		return map;
> -
> -	new = kmalloc(len, GFP_NOFS);
> -	if (!new) {
> -		/* just change map->num_stripes */
> -		map->num_stripes = num_stripes;
> -		return map;
> -	}
> -
> -	memcpy(new, map, len);
> -	new->num_stripes = num_stripes;
> -	kfree(map);
> -	return new;
> -}
> -
> -/*
> - * helper to allocate device space from btrfs_device_info, in which we stored
> - * max free space information of every device. It is used when we can not
> - * allocate chunks by default size.
> - *
> - * By this helper, we can allocate a new chunk as larger as possible.
> - */
> -static int __btrfs_alloc_tiny_space(struct btrfs_trans_handle *trans,
> -				    struct btrfs_fs_devices *fs_devices,
> -				    struct btrfs_device_info *devices,
> -				    int nr_device, u64 type,
> -				    struct map_lookup **map_lookup,
> -				    int min_stripes, u64 *stripe_size)
> -{
> -	int i, index, sort_again = 0;
> -	int min_devices = min_stripes;
> -	u64 max_avail, min_free;
> -	struct map_lookup *map = *map_lookup;
> -	int ret;
> -
> -	if (nr_device<  min_stripes)
> -		return -ENOSPC;
> +	ndevs = 0;
> +	while (cur !=&fs_devices->alloc_list) {
> +		device = list_entry(cur, struct btrfs_device, dev_alloc_list);
> +		BUG_ON(!device->writeable);
> 
> -	btrfs_descending_sort_devices(devices, nr_device);
> +		cur = cur->next;
> 
> -	max_avail = devices[0].max_avail;
> -	if (!max_avail)
> -		return -ENOSPC;
> +		if (!device->in_fs_metadata)
> +			continue;
> 
> -	for (i = 0; i<  nr_device; i++) {
> -		/*
> -		 * if dev_offset = 0, it means the free space of this device
> -		 * is less than what we need, and we didn't search max avail
> -		 * extent on this device, so do it now.
> +		if (device->total_bytes>  device->bytes_used)
> +			total_avail = device->total_bytes - device->bytes_used;
> +		else
> +			total_avail = 0;
> +		/* avail is off by max(alloc_start, 1MB), but that is the same
> +		 * for all devices, so it doesn't hurt the sorting later on
>   		 */
> -		if (!devices[i].dev_offset) {
> -			ret = find_free_dev_extent(trans, devices[i].dev,
> -						   max_avail,
> -						&devices[i].dev_offset,
> -						&devices[i].max_avail);
> -			if (ret != 0&&  ret != -ENOSPC)
> -				return ret;
> -			sort_again = 1;
> -		}
> -	}
> -
> -	/* we update the max avail free extent of each devices, sort again */
> -	if (sort_again)
> -		btrfs_descending_sort_devices(devices, nr_device);
> 
> -	if (type&  BTRFS_BLOCK_GROUP_DUP)
> -		min_devices = 1;
> +		ret = find_free_dev_extent(trans, device,
> +		                           max_stripe_size * dev_stripes,
> +					&dev_offset,&max_avail);
> +		if (ret&&  ret != -ENOSPC)
> +			goto error;
> 
> -	if (!devices[min_devices - 1].max_avail)
> -		return -ENOSPC;
> +		if (ret == 0)
> +			max_avail = max_stripe_size * dev_stripes;
> 
> -	max_avail = devices[min_devices - 1].max_avail;
> -	if (type&  BTRFS_BLOCK_GROUP_DUP)
> -		do_div(max_avail, 2);
> +		if (max_avail<  BTRFS_STRIPE_LEN * dev_stripes)
> +			continue;
> 
> -	max_avail = __btrfs_calc_stripe_size(fs_devices, max_avail, type,
> -					     min_stripes, 1);
> -	if (type&  BTRFS_BLOCK_GROUP_DUP)
> -		min_free = max_avail * 2;
> -	else
> -		min_free = max_avail;
> +		devices_info[ndevs].dev_offset = dev_offset;
> +		devices_info[ndevs].max_avail = max_avail;
> +		devices_info[ndevs].total_avail = total_avail;
> +		devices_info[ndevs].dev = device;
> +		++ndevs;
> +	}
> 
> -	if (min_free>  devices[min_devices - 1].max_avail)
> -		return -ENOSPC;
> +	/*
> +	 * now sort the devices by hole size / available space
> +	 */
> +	sort(devices_info, ndevs, sizeof(struct btrfs_device_info),
> +	     btrfs_cmp_device_info, NULL);
> 
> -	map = __shrink_map_lookup_stripes(map, min_stripes);
> -	*stripe_size = max_avail;
> +	/* round down to number of usable stripes */
> +	ndevs -= ndevs % devs_increment;
> 
> -	index = 0;
> -	for (i = 0; i<  min_stripes; i++) {
> -		map->stripes[i].dev = devices[index].dev;
> -		map->stripes[i].physical = devices[index].dev_offset;
> -		if (type&  BTRFS_BLOCK_GROUP_DUP) {
> -			i++;
> -			map->stripes[i].dev = devices[index].dev;
> -			map->stripes[i].physical = devices[index].dev_offset +
> -						   max_avail;
> -		}
> -		index++;
> +	if (ndevs<  devs_increment * sub_stripes || ndevs<  devs_min) {
> +		ret = -ENOSPC;
> +		goto error;
>   	}
> -	*map_lookup = map;
> 
> -	return 0;
> -}
> -
> -static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
> -			       struct btrfs_root *extent_root,
> -			       struct map_lookup **map_ret,
> -			       u64 *num_bytes, u64 *stripe_size,
> -			       u64 start, u64 type)
> -{
> -	struct btrfs_fs_info *info = extent_root->fs_info;
> -	struct btrfs_device *device = NULL;
> -	struct btrfs_fs_devices *fs_devices = info->fs_devices;
> -	struct list_head *cur;
> -	struct map_lookup *map;
> -	struct extent_map_tree *em_tree;
> -	struct extent_map *em;
> -	struct btrfs_device_info *devices_info;
> -	struct list_head private_devs;
> -	u64 calc_size = 1024 * 1024 * 1024;
> -	u64 min_free;
> -	u64 avail;
> -	u64 dev_offset;
> -	int num_stripes;
> -	int min_stripes;
> -	int sub_stripes;
> -	int min_devices;	/* the min number of devices we need */
> -	int i;
> -	int ret;
> -	int index;
> +	if (devs_max&&  ndevs>  devs_max)
> +		ndevs = devs_max;
> +	/*
> +	 * the primary goal is to maximize the number of stripes, so use as many
> +	 * devices as possible, even if the stripes are not maximum sized.
> +	 */
> +	stripe_size = devices_info[ndevs-1].max_avail;
> +	num_stripes = ndevs * dev_stripes;
> 
> -	if ((type&  BTRFS_BLOCK_GROUP_RAID1)&&
> -	    (type&  BTRFS_BLOCK_GROUP_DUP)) {
> -		WARN_ON(1);
> -		type&= ~BTRFS_BLOCK_GROUP_DUP;
> +	if (stripe_size * num_stripes>  max_chunk_size * ncopies) {
> +		stripe_size = max_chunk_size * ncopies;
> +		do_div(stripe_size, num_stripes);
>   	}
> -	if (list_empty(&fs_devices->alloc_list))
> -		return -ENOSPC;
> 
> -	ret = __btrfs_calc_nstripes(fs_devices, type,&num_stripes,
> -				&min_stripes,&sub_stripes);
> -	if (ret)
> -		return ret;
> +	do_div(stripe_size, dev_stripes);
> +	do_div(stripe_size, BTRFS_STRIPE_LEN);
> +	stripe_size *= BTRFS_STRIPE_LEN;
> 
> -	devices_info = kzalloc(sizeof(*devices_info) * fs_devices->rw_devices,
> -			       GFP_NOFS);
> -	if (!devices_info)
> -		return -ENOMEM;
> +	BUG_ON(!stripe_size);
> 
>   	map = kmalloc(map_lookup_size(num_stripes), GFP_NOFS);
>   	if (!map) {
>   		ret = -ENOMEM;
>   		goto error;
>   	}
>   	map->num_stripes = num_stripes;
> 
> -	cur = fs_devices->alloc_list.next;
>   	index = 0;
> -	i = 0;
> -
> -	calc_size = __btrfs_calc_stripe_size(fs_devices, calc_size, type,
> -					     num_stripes, 0);
> -
> -	if (type&  BTRFS_BLOCK_GROUP_DUP) {
> -		min_free = calc_size * 2;
> -		min_devices = 1;
> -	} else {
> -		min_free = calc_size;
> -		min_devices = min_stripes;
> -	}
> -
> -	INIT_LIST_HEAD(&private_devs);
> -	while (index<  num_stripes) {
> -		device = list_entry(cur, struct btrfs_device, dev_alloc_list);
> -		BUG_ON(!device->writeable);
> -		if (device->total_bytes>  device->bytes_used)
> -			avail = device->total_bytes - device->bytes_used;
> -		else
> -			avail = 0;
> -		cur = cur->next;
> -
> -		if (device->in_fs_metadata&&  avail>= min_free) {
> -			ret = find_free_dev_extent(trans, device, min_free,
> -						&devices_info[i].dev_offset,
> -						&devices_info[i].max_avail);
> -			if (ret == 0) {
> -				list_move_tail(&device->dev_alloc_list,
> -					&private_devs);
> -				map->stripes[index].dev = device;
> -				map->stripes[index].physical =
> -						devices_info[i].dev_offset;
> -				index++;
> -				if (type&  BTRFS_BLOCK_GROUP_DUP) {
> -					map->stripes[index].dev = device;
> -					map->stripes[index].physical =
> -						devices_info[i].dev_offset +
> -						calc_size;
> -					index++;
> -				}
> -			} else if (ret != -ENOSPC)
> -				goto error;
> -
> -			devices_info[i].dev = device;
> -			i++;
> -		} else if (device->in_fs_metadata&&
> -			   avail>= BTRFS_STRIPE_LEN) {
> -			devices_info[i].dev = device;
> -			devices_info[i].max_avail = avail;
> -			i++;
> -		}
> -
> -		if (cur ==&fs_devices->alloc_list)
> -			break;
> -	}
> -
> -	list_splice(&private_devs,&fs_devices->alloc_list);
> -	if (index<  num_stripes) {
> -		if (index>= min_stripes) {
> -			num_stripes = index;
> -			if (type&  (BTRFS_BLOCK_GROUP_RAID10)) {
> -				num_stripes /= sub_stripes;
> -				num_stripes *= sub_stripes;
> -			}
> -
> -			map = __shrink_map_lookup_stripes(map, num_stripes);
> -		} else if (i>= min_devices) {
> -			ret = __btrfs_alloc_tiny_space(trans, fs_devices,
> -						       devices_info, i, type,
> -						&map, min_stripes,
> -						&calc_size);
> -			if (ret)
> -				goto error;
> -		} else {
> -			ret = -ENOSPC;
> -			goto error;
> +	for (i = 0; i<  ndevs; ++i) {
> +		for (j = 0; j<  dev_stripes; ++j) {
> +			int s = i * dev_stripes + j;
> +			map->stripes[s].dev = devices_info[i].dev;
> +			map->stripes[s].physical = devices_info[i].dev_offset +
> +                                                   j * stripe_size;
>   		}
>   	}
>   	map->sector_size = extent_root->sectorsize;
>   	map->stripe_len = BTRFS_STRIPE_LEN;
>   	map->io_align = BTRFS_STRIPE_LEN;
>   	map->io_width = BTRFS_STRIPE_LEN;
>   	map->type = type;
>   	map->sub_stripes = sub_stripes;
> 
>   	*map_ret = map;
> -	*stripe_size = calc_size;
> -	*num_bytes = chunk_bytes_by_type(type, calc_size,
> -					 map->num_stripes, sub_stripes);
> +	*stripe_size_out = stripe_size;
> +	*num_bytes = stripe_size * (num_stripes / ncopies);
> 
>   	em = alloc_extent_map(GFP_NOFS);
>   	if (!em) {
>   		ret = -ENOMEM;
>   		goto error;
>   	}
>   	em->bdev = (struct block_device *)map;
>   	em->start = start;
>   	em->len = *num_bytes;
>   	em->block_start = 0;
>   	em->block_len = em->len;
> 
>   	em_tree =&extent_root->fs_info->mapping_tree.map_tree;
>   	write_lock(&em_tree->lock);
>   	ret = add_extent_mapping(em_tree, em);
>   	write_unlock(&em_tree->lock);
>   	BUG_ON(ret);
>   	free_extent_map(em);
> 
>   	ret = btrfs_make_block_group(trans, extent_root, 0, type,
>   				     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
>   				     start, *num_bytes);
>   	BUG_ON(ret);
> 
>   	index = 0;
>   	while (index<  map->num_stripes) {
>   		device = map->stripes[index].dev;
>   		dev_offset = map->stripes[index].physical;
> 
>   		ret = btrfs_alloc_dev_extent(trans, device,
>   				info->chunk_root->root_key.objectid,
>   				BTRFS_FIRST_CHUNK_TREE_OBJECTID,
> -				start, dev_offset, calc_size);
> +				start, dev_offset, stripe_size);
>   		BUG_ON(ret);
>   		index++;
>   	}
> 
>   	kfree(devices_info);
>   	return 0;
> 
>   error:
> -	kfree(map);
>   	kfree(devices_info);
> +	kfree(map);
> +
>   	return ret;
>   }
> 
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 7af6144..f4fe792 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -144,23 +144,9 @@ struct btrfs_device_info {
>   	struct btrfs_device *dev;
>   	u64 dev_offset;
>   	u64 max_avail;
> +	u64 total_avail;
>   };
> 
> -/* Used to sort the devices by max_avail(descending sort) */
> -int btrfs_cmp_device_free_bytes(const void *dev_info1, const void *dev_info2);
> -
> -/*
> - * sort the devices by max_avail, in which max free extent size of each device
> - * is stored.(Descending Sort)
> - */
> -static inline void btrfs_descending_sort_devices(
> -					struct btrfs_device_info *devices,
> -					size_t nr_devices)
> -{
> -	sort(devices, nr_devices, sizeof(struct btrfs_device_info),
> -	     btrfs_cmp_device_free_bytes, NULL);
> -}
> -
>   int btrfs_account_dev_extents_size(struct btrfs_device *device, u64 start,
>   				   u64 end, u64 *length);
> 

