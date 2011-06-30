From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH v4 4/7] btrfs: initial readahead code and prototypes
Date: Thu, 30 Jun 2011 08:49:07 -0400
Message-ID: <4E0C70C3.1000307@redhat.com>
References: <cover.1309375866.git.sensille@gmx.net> <1b900522e83d47aab3d44703804482f839d7543a.1309375866.git.sensille@gmx.net> <4E0B9E04.4010409@redhat.com> <4E0C27A0.7040002@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E0C27A0.7040002@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 06/30/2011 03:37 AM, Arne Jansen wrote:
> On 29.06.2011 23:49, Josef Bacik wrote:
>> On 06/29/2011 04:10 PM, Arne Jansen wrote:

>
>>
>>> +	struct kref		refcnt;
>>> +	wait_queue_head_t	wait;
>>> +};
>>> +
>>> +struct reada_extctl {
>>> +	struct list_head	list;
>>> +	struct reada_control	*rc;
>>> +	u64			generation;
>>> +};
>>> +
>>
>> This is completely useless, kill this struct and just put the generation
>> and the list into reada_control.
>
> This struct is the link between reada_extent and reada_control.
> In case more than one readahead is running, each reada_extent
> can point to multiple reada_controls, so I need this link struct.
>

And this is where I get confused.  Why would we need multiple 
reada_control's for the same extent?  Can't we just say "Oh hey there's 
already a reada control outstanding for this extent, take a ref on the 
control and wait for that"?


>>> +
>>> +/* call it with fs_info->reada_lock held */
>>> +static void reada_zone_put(struct reada_zone *zone)
>>> +{
>>> +	if (!kref_put(&zone->refcnt, reada_kref_dummy))
>>> +		return;
>>> +
>>> +	radix_tree_delete(&zone->device->reada_zones,
>>> +			  zone->end>>  PAGE_CACHE_SHIFT);
>>> +
>>
>> Instead of making the callers take the reada_lock, move it into this
>> function so that in the fast case we're not taking an extra spin_lock.
>
> I had to move this out, mainly because reada_start_machine_dev needs to
> hold the lock for several operation, one of which might call zone_put.
> Maybe I can defer the zone_put until afterwards.
> I'd like to wait with these kind of optimizations until there are some
> uses of readahead in more time critical paths, or at least until we have
> settled there will be such uses ;)
>
>> Also if you are going to use the kfref stuff you might as well use the
>> release function stuff.
>
> Right, in the case I can. I didn't do it for symmetrie with the other
> cases, but changed it now.
>
>>
>>> +	kfree(zone);
>>> +
>>> +	return;
>>> +}
>>> +
>>> +static void reada_control_put(struct reada_control *rc)
>>> +{
>>> +	if (kref_put(&rc->refcnt, reada_kref_dummy)) {
>>> +		kfree(rc);
>>> +		return;
>>
>> Don't need the return here.
>
> I killed the whole function and built reada_control_release instead.
>
>>
>>> +	}
>>> +}
>>> +
>>> +static int reada_add_block(struct reada_control *rc, u64 logical,
>>> +			   struct btrfs_key *top, int level, u64 generation)
>>> +{
>>> +	struct btrfs_root *root = rc->root;
>>> +	struct reada_extent *re;
>>> +	struct reada_extctl *rec;
>>> +
>>> +	re = reada_find_extent(root, logical, top, level); /* takes one ref */
>>> +	if (!re)
>>> +		return -1;
>>> +
>>> +	rec = kzalloc(sizeof(*rec), GFP_NOFS);
>>> +	if (!rec) {
>>> +		reada_extent_put(root->fs_info, re);
>>> +		return -1;
>>> +	}
>>> +
>>> +	rec->rc = rc;
>>> +	rec->generation = generation;
>>> +	spin_lock(&rc->lock);
>>> +	++rc->elems;
>>> +	spin_unlock(&rc->lock);
>>> +
>>> +	spin_lock(&re->lock);
>>> +	list_add_tail(&rec->list,&re->extctl);
>>> +	spin_unlock(&re->lock);
>>> +
>>> +	/* leave the ref on the extent */
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +/*
>>> + * called with fs_info->reada_lock held
>>> + */
>>> +static void reada_peer_zones_set_lock(struct reada_zone *zone, int lock)
>>> +{
>>> +	int i;
>>> +	unsigned long index = zone->end>>  PAGE_CACHE_SHIFT;
>>> +
>>> +	for (i = 0; i<  zone->ndevs; ++i) {
>>> +		struct reada_zone *peer;
>>> +		peer = radix_tree_lookup(&zone->devs[i]->reada_zones, index);
>>> +		if (peer&&  peer->device != zone->device)
>>> +			peer->locked = lock;
>>> +	}
>>> +}
>>> +
>>> +/*
>>> + * called with fs_info->reada_lock held
>>> + */
>>> +static int reada_pick_zone(struct btrfs_device *dev)
>>> +{
>>> +	struct reada_zone *top_zone = NULL;
>>> +	struct reada_zone *top_locked_zone = NULL;
>>> +	u64 top_elems = 0;
>>> +	u64 top_locked_elems = 0;
>>> +	unsigned long index = 0;
>>> +	int ret;
>>> +
>>> +	if (dev->reada_curr_zone) {
>>> +		reada_peer_zones_set_lock(dev->reada_curr_zone, 0);
>>> +		reada_zone_put(dev->reada_curr_zone);
>>> +		dev->reada_curr_zone = NULL;
>>> +	}
>>> +	/* pick the zone with the most elements */
>>> +	while (1) {
>>> +		struct reada_zone *zone;
>>> +
>>> +		ret = radix_tree_gang_lookup(&dev->reada_zones,
>>> +					     (void **)&zone, index, 1);
>>> +		if (ret == 0)
>>> +			break;
>>> +		index = (zone->end>>  PAGE_CACHE_SHIFT) + 1;
>>> +		if (zone->locked) {
>>> +			if (zone->elems>  top_locked_elems) {
>>> +				top_locked_elems = zone->elems;
>>> +				top_locked_zone = zone;
>>> +			}
>>> +		} else {
>>> +			if (zone->elems>  top_elems) {
>>> +				top_elems = zone->elems;
>>> +				top_zone = zone;
>>> +			}
>>> +		}
>>> +	}
>>> +	if (top_zone)
>>> +		dev->reada_curr_zone = top_zone;
>>> +	else if (top_locked_zone)
>>> +		dev->reada_curr_zone = top_locked_zone;
>>> +	else
>>> +		return 0;
>>> +
>>> +	dev->reada_next = dev->reada_curr_zone->start;
>>> +	kref_get(&dev->reada_curr_zone->refcnt);
>>> +	reada_peer_zones_set_lock(dev->reada_curr_zone, 1);
>>> +
>>> +	return 1;
>>> +}
>>> +
>>> +static int reada_start_machine_dev(struct btrfs_fs_info *fs_info,
>>> +				   struct btrfs_device *dev)
>>> +{
>>> +	struct reada_extent *re = NULL;
>>> +	int mirror_num = 0;
>>> +	struct extent_buffer *eb = NULL;
>>> +	u64 logical;
>>> +	u32 blocksize;
>>> +	int ret;
>>> +	int i;
>>> +	int need_kick = 0;
>>> +
>>> +	spin_lock(&fs_info->reada_lock);
>>> +	if (dev->reada_curr_zone == NULL) {
>>> +		ret = reada_pick_zone(dev);
>>> +		if (!ret) {
>>> +			spin_unlock(&fs_info->reada_lock);
>>> +			return 0;
>>> +		}
>>> +	}
>>> +	/*
>>> +	 * FIXME currently we issue the reads one extent at a time. If we have
>>> +	 * a contiguous block of extents, we could also coagulate them or use
>>> +	 * plugging to speed things up
>>> +	 */
>>> +	ret = radix_tree_gang_lookup(&dev->reada_extents, (void **)&re,
>>> +				     dev->reada_next>>  PAGE_CACHE_SHIFT, 1);
>>> +	if (ret == 0 || re->logical>= dev->reada_curr_zone->end) {
>>> +		ret = reada_pick_zone(dev);
>>> +		if (!ret) {
>>> +			spin_unlock(&fs_info->reada_lock);
>>> +			return 0;
>>> +		}
>>> +		re = NULL;
>>> +		ret = radix_tree_gang_lookup(&dev->reada_extents, (void **)&re,
>>> +					dev->reada_next>>  PAGE_CACHE_SHIFT, 1);
>>> +	}
>>> +	if (ret == 0) {
>>> +		spin_unlock(&fs_info->reada_lock);
>>> +		return 0;
>>> +	}
>>> +	dev->reada_next = re->logical + re->blocksize;
>>> +	kref_get(&re->refcnt);
>>> +
>>> +	spin_unlock(&fs_info->reada_lock);
>>> +
>>> +	/*
>>> +	 * find mirror num
>>> +	 */
>>> +	for (i = 0; i<  re->nzones; ++i) {
>>> +		if (re->zones[i]->device == dev) {
>>> +			mirror_num = i + 1;
>>> +			break;
>>> +		}
>>> +	}
>>> +	logical = re->logical;
>>> +	blocksize = re->blocksize;
>>> +
>>> +	spin_lock(&re->lock);
>>> +	if (re->scheduled_for == NULL) {
>>> +		re->scheduled_for = dev;
>>> +		need_kick = 1;
>>> +	}
>>> +	spin_unlock(&re->lock);
>>> +
>>> +	reada_extent_put(fs_info, re);
>>> +
>>> +	if (!need_kick)
>>> +		return 0;
>>> +
>>> +	atomic_inc(&dev->reada_in_flight);
>>> +	ret = reada_tree_block_flagged(fs_info->extent_root, logical, blocksize,
>>> +			 mirror_num,&eb);
>>> +	if (eb) {
>>> +		__readahead_hook(fs_info->extent_root, eb, eb->start, ret);
>>> +		free_extent_buffer(eb);
>>> +	}
>>> +
>>> +	return 1;
>>> +
>>> +}
>>> +
>>> +static void reada_start_machine_worker(struct btrfs_work *work)
>>> +{
>>> +	struct reada_machine_work *rmw;
>>> +	struct btrfs_fs_info *fs_info;
>>> +
>>> +	rmw = container_of(work, struct reada_machine_work, work);
>>> +	fs_info = rmw->fs_info;
>>> +
>>> +	kfree(rmw);
>>> +
>>> +	__reada_start_machine(fs_info);
>>> +}
>>> +
>>> +static void __reada_start_machine(struct btrfs_fs_info *fs_info)
>>> +{
>>> +	struct btrfs_device *device;
>>> +	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
>>> +	u64 enqueued;
>>> +	u64 total = 0;
>>> +	int i;
>>> +
>>> +	do {
>>> +		enqueued = 0;
>>> +		list_for_each_entry(device,&fs_devices->devices, dev_list) {
>>> +			if (atomic_read(&device->reada_in_flight)<
>>> +			    MAX_IN_FLIGHT)
>>> +				enqueued += reada_start_machine_dev(fs_info,
>>> +								    device);
>>> +		}
>>> +		total += enqueued;
>>> +	} while (enqueued&&  total<  10000);
>>> +
>>
>> What is this?  Are we doing this so that the worker stays alive so it
>> can continue to process new requests coming in?  If thats the case we
>> need to have a proper kthread that doesn't exit until we unmount or
>> something, not this weirdness.
>
> Hopefully the comment below explains what the intention is. Maybe I
> should move it up to answer the question before it arises :) A kthread
> is not enough, as I want parallelism here.
>
> I'll kill the FIXME as it is done already.
>

Yeah the comment wasn't and still isn't clear to me.  You are using the 
workers here, which means we already have a thread per cpu running here, 
so we don't need to do things to artificially keep one of them running, 
we just give it work to do and the worker threads will dispatch a thread 
to do the work, we have built in parallelism, so this is just confusing 
and unnecessary.

>>
>>> +	if (enqueued == 0)
>>> +		return;
>>> +
>>> +	/*
>>> +	 * If everything is already in the cache, this is effectively single
>>> +	 * threaded. To a) not hold the caller for too long and b) to utilize
>>> +	 * more cores, we broke the loop above after 10000 iterations and now
>>> +	 * enqueue to workers to finish it. This will distribute the load to
>>> +	 * the cores.
>>> +	 * FIXME we might need our own workqueue here, with an idle threshold
>>> +	 * of one. Also these worker are relatively long-running.
>>> +	 */
>>> +	for (i = 0; i<  2; ++i)
>>> +		reada_start_machine(fs_info);
>>> +}
>>> +
>>> +static void reada_start_machine(struct btrfs_fs_info *fs_info)
>>> +{
>>> +	struct reada_machine_work *rmw;
>>> +
>>> +	rmw = kzalloc(sizeof(*rmw), GFP_NOFS);
>>> +	if (!rmw) {
>>> +		/* FIXME we cannot handle this properly right now */
>>> +		BUG();
>>
>> Yes you can, everywhere that calls this can handle failures, so make
>> this return an int and have it return -ENOMEM if it fails.
>
> Just passing up the error isn't enough. We also need to signal the error
> to all waiters and clean up all data structures. Maybe it's easier to
> just keep a small cache of these struct, maybe #CPUs, so we can never
> fail here.

Well this is just used to add the current readahead work right?  We can 
fail here with no problems, it just means the person wanting to add the 
readahead work failed, there is no reason to stop any of the other 
workers who may already have work going on.  Thanks,

Josef
