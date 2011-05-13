From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH v3 3/3] btrfs: quasi-round-robin for chunk allocation
Date: Fri, 13 May 2011 13:43:25 +0200
Message-ID: <20110513114325.GR12709@twin.jikos.cz>
References: <cover.1304325641.git.sensille@gmx.net>
 <7b29f229ee19377ddb6dd8ae2d10a7428b7418f6.1304325641.git.sensille@gmx.net>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <7b29f229ee19377ddb6dd8ae2d10a7428b7418f6.1304325641.git.sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

here are my comments, after first review round, mostly on code itself,
not the functionality/quality of the allocator (although after this
patch the allocator code looks quite straightforward a better to read
and understand).

Reviewing the patch directly does not work, Arne's advice was to look at
the new code only, which did work, at the function __btrfs_alloc_chunk.

I found several categories of similar issues:
* move declarations from function-level to local scopes; makes the func
  declaration block less scary :)
* BUG_ONs -- a number of new ones -- I'd rather get rid of them now
* a few more comments would help
* misc code transformations or identifier renames

On Mon, May 02, 2011 at 10:47:42AM +0200, Arne Jansen wrote:
> In a multi device setup, the chunk allocator currently always allocates
> chunks on the devices in the same order. This leads to a very uneven
> distribution, especially with RAID1 or RAID10 and an uneven number of
> devices.
> This patch always sorts the devices before allocating, and allocates the
> stripes on the devices with the most available space, as long as there
> is enough space available. In a low space situation, it first tries to
> maximize striping.
> The patch also simplifies the allocator and reduces the checks for
> corner cases.
> The simplification is done by several means. First, it defines the
> properties of each RAID type upfront. These properties are used afterwards
> instead of differentiating cases in several places.
> Second, the old allocator defined a minimum stripe size for each block
> group type, tried to find a large enough chunk, and if this fails just
> allocates a smaller one. This is now done in one step. The largest possible
> chunk (up to max_chunk_size) is searched and allocated.
> Because we now have only one pass, the allocation of the map (struct
> map_lookup) is moved down to the point where the number of stripes is
> already known. This way we avoid reallocation of the map.
> We still avoid allocating stripes that are not a multiple of STRIPE_SIZE.
> 
> Changes from v2:
>  - bugfix for 'single' raid type; the initial parameter initialization lacked
>    a case for the 'single' type, thus leaving devs_max at the wrong value
> 
> Signed-off-by: Arne Jansen <sensille@gmx.net>
> ---
>  fs/btrfs/volumes.c |  476 +++++++++++++++++++---------------------------------
>  fs/btrfs/volumes.h |    1 +
>  2 files changed, 171 insertions(+), 306 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 45c592a..77eb763 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2268,349 +2268,213 @@ static int btrfs_add_system_chunk(struct btrfs_trans_handle *trans,
>  	return 0;
>  }
>  
> -static noinline u64 chunk_bytes_by_type(u64 type, u64 calc_size,
> -					int num_stripes, int sub_stripes)
> -{
> -	if (type & (BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_DUP))
> -		return calc_size;
> -	else if (type & BTRFS_BLOCK_GROUP_RAID10)
> -		return calc_size * (num_stripes / sub_stripes);
> -	else
> -		return calc_size * num_stripes;
> -}
> -
> -static int __btrfs_calc_nstripes(struct btrfs_fs_devices *fs_devices, u64 type,
> -				 int *num_stripes, int *min_stripes,
> -				 int *sub_stripes)
> -{
> -	*num_stripes = 1;
> -	*min_stripes = 1;
> -	*sub_stripes = 0;
> -
> -	if (type & (BTRFS_BLOCK_GROUP_RAID0)) {
> -		*num_stripes = fs_devices->rw_devices;
> -		*min_stripes = 2;
> -	}
> -	if (type & (BTRFS_BLOCK_GROUP_DUP)) {
> -		*num_stripes = 2;
> -		*min_stripes = 2;
> -	}
> -	if (type & (BTRFS_BLOCK_GROUP_RAID1)) {
> -		if (fs_devices->rw_devices < 2)
> -			return -ENOSPC;
> -		*num_stripes = 2;
> -		*min_stripes = 2;
> -	}
> -	if (type & (BTRFS_BLOCK_GROUP_RAID10)) {
> -		*num_stripes = fs_devices->rw_devices;
> -		if (*num_stripes < 4)
> -			return -ENOSPC;
> -		*num_stripes &= ~(u32)1;
> -		*sub_stripes = 2;
> -		*min_stripes = 4;
> -	}
> -
> -	return 0;
> -}
> -
> -static u64 __btrfs_calc_stripe_size(struct btrfs_fs_devices *fs_devices,
> -				    u64 proposed_size, u64 type,
> -				    int num_stripes, int small_stripe)
> -{
> -	int min_stripe_size = 1 * 1024 * 1024;
> -	u64 calc_size = proposed_size;
> -	u64 max_chunk_size = calc_size;
> -	int ncopies = 1;
> -
> -	if (type & (BTRFS_BLOCK_GROUP_RAID1 |
> -		    BTRFS_BLOCK_GROUP_DUP |
> -		    BTRFS_BLOCK_GROUP_RAID10))
> -		ncopies = 2;
> -
> -	if (type & BTRFS_BLOCK_GROUP_DATA) {
> -		max_chunk_size = 10 * calc_size;
> -		min_stripe_size = 64 * 1024 * 1024;
> -	} else if (type & BTRFS_BLOCK_GROUP_METADATA) {
> -		max_chunk_size = 256 * 1024 * 1024;
> -		min_stripe_size = 32 * 1024 * 1024;
> -	} else if (type & BTRFS_BLOCK_GROUP_SYSTEM) {
> -		calc_size = 8 * 1024 * 1024;
> -		max_chunk_size = calc_size * 2;
> -		min_stripe_size = 1 * 1024 * 1024;
> -	}
> -
> -	/* we don't want a chunk larger than 10% of writeable space */
> -	max_chunk_size = min(div_factor(fs_devices->total_rw_bytes, 1),
> -			     max_chunk_size);
> -
> -	if (calc_size * num_stripes > max_chunk_size * ncopies) {
> -		calc_size = max_chunk_size * ncopies;
> -		do_div(calc_size, num_stripes);
> -		do_div(calc_size, BTRFS_STRIPE_LEN);
> -		calc_size *= BTRFS_STRIPE_LEN;
> -	}
> -
> -	/* we don't want tiny stripes */
> -	if (!small_stripe)
> -		calc_size = max_t(u64, min_stripe_size, calc_size);
> -
> -	/*
> -	 * we're about to do_div by the BTRFS_STRIPE_LEN so lets make sure
> -	 * we end up with something bigger than a stripe
> -	 */
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
> -	BUG_ON(map->num_stripes < num_stripes);
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
>  /*
> - * helper to allocate device space from btrfs_device_info, in which we stored
> - * max free space information of every device. It is used when we can not
> - * allocate chunks by default size.
> - *
> - * By this helper, we can allocate a new chunk as larger as possible.
> + * sort the devices in descending order by max_avail, total_avail
>   */
> -static int __btrfs_alloc_tiny_space(struct btrfs_trans_handle *trans,
> -				    struct btrfs_fs_devices *fs_devices,
> -				    struct btrfs_device_info *devices,
> -				    int nr_device, u64 type,
> -				    struct map_lookup **map_lookup,
> -				    int min_stripes, u64 *stripe_size)
> +static int btrfs_cmp_device_info(const void *a, const void *b)
>  {
> -	int i, index, sort_again = 0;
> -	int min_devices = min_stripes;
> -	u64 max_avail, min_free;
> -	struct map_lookup *map = *map_lookup;
> -	int ret;
> -
> -	if (nr_device < min_stripes)
> -		return -ENOSPC;
> -
> -	btrfs_descending_sort_devices(devices, nr_device);
> -
> -	max_avail = devices[0].max_avail;
> -	if (!max_avail)
> -		return -ENOSPC;
> -
> -	for (i = 0; i < nr_device; i++) {
> -		/*
> -		 * if dev_offset = 0, it means the free space of this device
> -		 * is less than what we need, and we didn't search max avail
> -		 * extent on this device, so do it now.
> -		 */
> -		if (!devices[i].dev_offset) {
> -			ret = find_free_dev_extent(trans, devices[i].dev,
> -						   max_avail,
> -						   &devices[i].dev_offset,
> -						   &devices[i].max_avail);
> -			if (ret != 0 && ret != -ENOSPC)
> -				return ret;
> -			sort_again = 1;
> -		}
> -	}
> -
> -	/* we update the max avail free extent of each devices, sort again */
> -	if (sort_again)
> -		btrfs_descending_sort_devices(devices, nr_device);
> -
> -	if (type & BTRFS_BLOCK_GROUP_DUP)
> -		min_devices = 1;
> -
> -	if (!devices[min_devices - 1].max_avail)
> -		return -ENOSPC;
> -
> -	max_avail = devices[min_devices - 1].max_avail;
> -	if (type & BTRFS_BLOCK_GROUP_DUP)
> -		do_div(max_avail, 2);
> -
> -	max_avail = __btrfs_calc_stripe_size(fs_devices, max_avail, type,
> -					     min_stripes, 1);
> -	if (type & BTRFS_BLOCK_GROUP_DUP)
> -		min_free = max_avail * 2;
> -	else
> -		min_free = max_avail;
> -
> -	if (min_free > devices[min_devices - 1].max_avail)
> -		return -ENOSPC;
> -
> -	map = __shrink_map_lookup_stripes(map, min_stripes);
> -	*stripe_size = max_avail;
> -
> -	index = 0;
> -	for (i = 0; i < min_stripes; i++) {
> -		map->stripes[i].dev = devices[index].dev;
> -		map->stripes[i].physical = devices[index].dev_offset;
> -		if (type & BTRFS_BLOCK_GROUP_DUP) {
> -			i++;
> -			map->stripes[i].dev = devices[index].dev;
> -			map->stripes[i].physical = devices[index].dev_offset +
> -						   max_avail;
> -		}
> -		index++;
> -	}
> -	*map_lookup = map;
> -
> +	const struct btrfs_device_info *di_a = a;
> +	const struct btrfs_device_info *di_b = b;
> +
> +	if (di_a->max_avail > di_b->max_avail)
> +		return -1;
> +	if (di_a->max_avail < di_b->max_avail)
> +		return 1;
> +	if (di_a->total_avail > di_b->total_avail)
> +		return -1;
> +	if (di_a->total_avail < di_b->total_avail)
> +		return 1;
>  	return 0;
>  }
>  
>  static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
>  			       struct btrfs_root *extent_root,
>  			       struct map_lookup **map_ret,
                                                   map_out

> -			       u64 *num_bytes, u64 *stripe_size,
> +			       u64 *num_bytes, u64 *stripe_size_out,
                                    num_bytes_out

there seems to be no formal convention to name outgoing parameters, but
at least this makes things more consistent

>  			       u64 start, u64 type)
>  {
>  	struct btrfs_fs_info *info = extent_root->fs_info;
>  	struct btrfs_device *device = NULL;
this variable can be declared in local scope block ...

>  	struct btrfs_fs_devices *fs_devices = info->fs_devices;
>  	struct list_head *cur;
> -	struct map_lookup *map;
> +	struct map_lookup *map = NULL;
>  	struct extent_map_tree *em_tree;
>  	struct extent_map *em;
> -	struct btrfs_device_info *devices_info;
> -	struct list_head private_devs;
> -	u64 calc_size = 1024 * 1024 * 1024;
> -	u64 min_free;
> -	u64 avail;
> +	struct btrfs_device_info *devices_info = NULL;
> +	u64 total_avail;
this

> +	u64 max_avail;
this

>  	u64 dev_offset;
and this should go to local scope

> -	int num_stripes;
> -	int min_stripes;
> -	int sub_stripes;
> -	int min_devices;	/* the min number of devices we need */
> -	int i;
> +	int num_stripes;	/* total number of stripes to allocate */
> +	int sub_stripes;	/* sub_stripes info for map */
> +	int dev_stripes;	/* stripes per dev */
> +	int devs_max;		/* max devs to use */
> +	int devs_min;		/* min devs needed */
> +	int devs_increment;	/* ndevs has to be a multiple of this */
> +	int ncopies;		/* how many copies to data has */
>  	int ret;
> +	u64 max_stripe_size;
> +	u64 max_chunk_size;
> +	u64 stripe_size;
> +	int ndevs;
>  	int index;
            ^^^^^
remove, unused or can be substituted with existing var (i)

> +	int i;
> +	int j;
>  
>  	if ((type & BTRFS_BLOCK_GROUP_RAID1) &&
>  	    (type & BTRFS_BLOCK_GROUP_DUP)) {
>  		WARN_ON(1);
>  		type &= ~BTRFS_BLOCK_GROUP_DUP;
>  	}

comment please, why this combination is bad

> +
(extra newline)

>  	if (list_empty(&fs_devices->alloc_list))
>  		return -ENOSPC;
>  
> -	ret = __btrfs_calc_nstripes(fs_devices, type, &num_stripes,
> -				    &min_stripes, &sub_stripes);
> -	if (ret)
> -		return ret;
> +
> +	sub_stripes = 1;
> +	dev_stripes = 1;
> +	devs_increment = 1;
> +	ncopies = 1;
> +	devs_max = 0;	/* 0 == as many as possible */
> +	devs_min = 1;
> +
> +	/*
> +	 * define the properties of each RAID type.
> +	 * FIXME: move this to a global table and use it in all RAID
> +	 * calculation code
> +	 */
agreed with the FIXME, Hugo Mills' balance patches have the refactoring
code, so let's keep this as-is for now

> +	if (type & (BTRFS_BLOCK_GROUP_DUP)) {
> +		dev_stripes = 2;
> +		ncopies = 2;
> +		devs_max = 1;
> +	} else if (type & (BTRFS_BLOCK_GROUP_RAID0)) {
> +		devs_min = 2;
> +	} else if (type & (BTRFS_BLOCK_GROUP_RAID1)) {
> +		devs_increment = 2;
> +		ncopies = 2;
> +		devs_max = 2;
> +		devs_min = 2;
> +	} else if (type & (BTRFS_BLOCK_GROUP_RAID10)) {
> +		sub_stripes = 2;
> +		devs_increment = 2;
> +		ncopies = 2;
> +		devs_min = 4;
> +	} else {
> +		devs_max = 1;
> +	}
> +
> +	if (type & BTRFS_BLOCK_GROUP_DATA) {
> +		max_stripe_size = 1024 * 1024 * 1024;
> +		max_chunk_size = 10 * max_stripe_size;
> +	} else if (type & BTRFS_BLOCK_GROUP_METADATA) {
> +		max_stripe_size = 256 * 1024 * 1024;
> +		max_chunk_size = max_stripe_size;
> +	} else if (type & BTRFS_BLOCK_GROUP_SYSTEM) {
> +		max_stripe_size = 8 * 1024 * 1024;
> +		max_chunk_size = 2 * max_stripe_size;
> +	} else {
> +		BUG_ON(1);
a printk would be good, this may catch a bug eg. in alloc_profile bit
handling

> +	}
> +
> +	/* we don't want a chunk larger than 10% of writeable space */
> +	max_chunk_size = min(div_factor(fs_devices->total_rw_bytes, 1),
> +	                     max_chunk_size);
>  
>  	devices_info = kzalloc(sizeof(*devices_info) * fs_devices->rw_devices,
>  			       GFP_NOFS);
>  	if (!devices_info)
>  		return -ENOMEM;
>  
> -	map = kmalloc(map_lookup_size(num_stripes), GFP_NOFS);
> -	if (!map) {
> -		ret = -ENOMEM;
> -		goto error;
> -	}
> -	map->num_stripes = num_stripes;
> -
>  	cur = fs_devices->alloc_list.next;
> -	index = 0;
> -	i = 0;
>  
> -	calc_size = __btrfs_calc_stripe_size(fs_devices, calc_size, type,
> -					     num_stripes, 0);
> -
> -	if (type & BTRFS_BLOCK_GROUP_DUP) {
> -		min_free = calc_size * 2;
> -		min_devices = 1;
> -	} else {
> -		min_free = calc_size;
> -		min_devices = min_stripes;
> -	}
> -
> -	INIT_LIST_HEAD(&private_devs);
> -	while (index < num_stripes) {
> +	/*
> +	 * in the first pass through the devices list, we gather information
> +	 * about the available holes on each device.
> +	 */
> +	ndevs = 0;
> +	while (cur != &fs_devices->alloc_list) {
>  		device = list_entry(cur, struct btrfs_device, dev_alloc_list);
                ^^^^^^
declare locally, and add max_avail and total_avail

>  		BUG_ON(!device->writeable);

not a newly added BUG_ON, but I wonder if this is the best what can be
done here, a printk would be helpful too.
I do not see any locking of the device list here, and did not have a
deeper look, but I think this could race with device removal, when the
device is still in the list, but the racing thread managed to set
device->writable to zero. In this case, a WARN would do, and skipping
the device will not break things (too much).

> +
> +		cur = cur->next;
> +
> +		if (!device->in_fs_metadata)
> +			continue;
> +
>  		if (device->total_bytes > device->bytes_used)
> -			avail = device->total_bytes - device->bytes_used;
> +			total_avail = device->total_bytes - device->bytes_used;
>  		else
> -			avail = 0;
> -		cur = cur->next;
> -
> -		if (device->in_fs_metadata && avail >= min_free) {
> -			ret = find_free_dev_extent(trans, device, min_free,
> -						   &devices_info[i].dev_offset,
> -						   &devices_info[i].max_avail);
> -			if (ret == 0) {
> -				list_move_tail(&device->dev_alloc_list,
> -					       &private_devs);
> -				map->stripes[index].dev = device;
> -				map->stripes[index].physical =
> -						devices_info[i].dev_offset;
> -				index++;
> -				if (type & BTRFS_BLOCK_GROUP_DUP) {
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
> -		} else if (device->in_fs_metadata &&
> -			   avail >= BTRFS_STRIPE_LEN) {
> -			devices_info[i].dev = device;
> -			devices_info[i].max_avail = avail;
> -			i++;
> -		}
> -
> -		if (cur == &fs_devices->alloc_list)
> -			break;
> -	}
> -
> -	list_splice(&private_devs, &fs_devices->alloc_list);
> -	if (index < num_stripes) {
> -		if (index >= min_stripes) {
> -			num_stripes = index;
> -			if (type & (BTRFS_BLOCK_GROUP_RAID10)) {
> -				num_stripes /= sub_stripes;
> -				num_stripes *= sub_stripes;
> -			}
> -
> -			map = __shrink_map_lookup_stripes(map, num_stripes);
> -		} else if (i >= min_devices) {
> -			ret = __btrfs_alloc_tiny_space(trans, fs_devices,
> -						       devices_info, i, type,
> -						       &map, min_stripes,
> -						       &calc_size);
> -			if (ret)
> -				goto error;
> -		} else {
> -			ret = -ENOSPC;
> +			total_avail = 0;
> +		/* avail is off by max(alloc_start, 1MB), but that is the same
> +		 * for all devices, so it doesn't hurt the sorting later on
> +		 */
> +
> +		ret = find_free_dev_extent(trans, device,
> +		                           max_stripe_size * dev_stripes,
> +					   &dev_offset, &max_avail);
> +		if (ret && ret != -ENOSPC)
>  			goto error;
> +
> +		if (ret == 0)
> +			max_avail = max_stripe_size * dev_stripes;
> +
> +		if (max_avail < BTRFS_STRIPE_LEN * dev_stripes)
> +			continue;
> +
> +		devices_info[ndevs].dev_offset = dev_offset;
> +		devices_info[ndevs].max_avail = max_avail;
> +		devices_info[ndevs].total_avail = total_avail;
> +		devices_info[ndevs].dev = device;
> +		++ndevs;
> +	}
> +
> +	/*
> +	 * now sort the devices by hole size / available space
> +	 */
> +	sort(devices_info, ndevs, sizeof(struct btrfs_device_info),
> +	     btrfs_cmp_device_info, NULL);
> +
> +	/* round down to number of usable stripes */
> +	ndevs -= ndevs % devs_increment;
> +
> +	if (ndevs < devs_increment * sub_stripes || ndevs < devs_min) {
> +		ret = -ENOSPC;
> +		goto error;
> +	}
> +
> +	if (devs_max && ndevs > devs_max)
> +		ndevs = devs_max;
> +	/*
> +	 * the primary goal is to maximize the number of stripes, so use as many
> +	 * devices as possible, even if the stripes are not maximum sized.
> +	 */
> +	stripe_size = devices_info[ndevs-1].max_avail;
> +	num_stripes = ndevs * dev_stripes;
> +
> +	if (stripe_size * num_stripes > max_chunk_size * ncopies) {
> +		stripe_size = max_chunk_size * ncopies;
> +		do_div(stripe_size, num_stripes);
> +	}
> +
> +	do_div(stripe_size, dev_stripes);
> +	do_div(stripe_size, BTRFS_STRIPE_LEN);
> +	stripe_size *= BTRFS_STRIPE_LEN;
> +
> +	BUG_ON(!stripe_size);

what does this catch, in words? stripe_size was smaller than
BTRFS_STRIPE_LEN. Old code made sure that this does not happen, doing

  calc_size = max_t(u64, calc_size, BTRFS_STRIPE_LEN)

before the final do_div. Is there really a reason to crash?

> +
> +	map = kmalloc(map_lookup_size(num_stripes), GFP_NOFS);
> +	if (!map) {
> +		ret = -ENOMEM;
> +		goto error;
> +	}
> +	map->num_stripes = num_stripes;
> +
> +	index = 0;

not used, probably intended as a linear counter of the 'int s = ... '
expression below. the compiler 'strength-reduce' pass will probably
deduce this too.

> +	for (i = 0; i < ndevs; ++i) {
> +		for (j = 0; j < dev_stripes; ++j) {
> +			int s = i * dev_stripes + j;
> +			map->stripes[s].dev = devices_info[i].dev;
> +			map->stripes[s].physical = devices_info[i].dev_offset +
> +                                                   j * stripe_size;
>  		}
>  	}

not really an issue here, but the devices_info[i] could be moved out of
the for( j ) loop (assigned to a tmp var), but an optimizing compiler
will do this too :)

>  	map->sector_size = extent_root->sectorsize;
> @@ -2621,9 +2485,8 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
>  	map->sub_stripes = sub_stripes;
>  
>  	*map_ret = map;
> -	*stripe_size = calc_size;
> -	*num_bytes = chunk_bytes_by_type(type, calc_size,
> -					 map->num_stripes, sub_stripes);
> +	*stripe_size_out = stripe_size;
> +	*num_bytes = stripe_size * (num_stripes / ncopies);
>  
>  	trace_btrfs_chunk_alloc(info->chunk_root, map, start, *num_bytes);

...

[inserted from patched file]

2482         index = 0;
2483         while (index < map->num_stripes) {
2484                 device = map->stripes[index].dev;
2485                 dev_offset = map->stripes[index].physical;
2486
2487                 ret = btrfs_alloc_dev_extent(trans, device,
2488                                 info->chunk_root->root_key.objectid,
2489                                 BTRFS_FIRST_CHUNK_TREE_OBJECTID,
2490                                 start, dev_offset, stripe_size);
2491                 BUG_ON(ret);
2492                 index++;
2493         }

can you please transform this to a for loop for me? I know this is not
your original code, but this cleanup seems worth while changing the
whole function.

(and make those device and def_offset local declarations)

>  
> @@ -2658,7 +2521,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
>  		ret = btrfs_alloc_dev_extent(trans, device,
>  				info->chunk_root->root_key.objectid,
>  				BTRFS_FIRST_CHUNK_TREE_OBJECTID,
> -				start, dev_offset, calc_size);
> +				start, dev_offset, stripe_size);
>  		BUG_ON(ret);
>  		index++;
>  	}
> @@ -2667,8 +2530,9 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
>  	return 0;
>  
>  error:
> +	kfree(devices_info);
>  	kfree(map);
> -	kfree(devices_info);
> +

unnecessary hunk

>  	return ret;
>  }
>  
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index b502f01..37ae6e2 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -144,6 +144,7 @@ struct btrfs_device_info {
>  	struct btrfs_device *dev;
>  	u64 dev_offset;
>  	u64 max_avail;
> +	u64 total_avail;
>  };
>  
>  struct map_lookup {
> -- 

and I'm going to test this a bit too :)

david
