Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31104 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753210AbdCTUpd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Mar 2017 16:45:33 -0400
Date: Mon, 20 Mar 2017 13:44:09 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/7] btrfs: use simpler readahead zone lookups
Message-ID: <20170320204408.GE5540@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1489593696.git.dsterba@suse.com>
 <28edb65e1e98d9f815f3b64cdd2489d4be78e681.1489593696.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <28edb65e1e98d9f815f3b64cdd2489d4be78e681.1489593696.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 15, 2017 at 05:02:26PM +0100, David Sterba wrote:
> No point using radix_tree_gang_lookup if we're looking up just one slot.
> 
Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/reada.c | 52 ++++++++++++++++++++++------------------------------
>  1 file changed, 22 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
> index fdae8ca79401..dd78af5d265d 100644
> --- a/fs/btrfs/reada.c
> +++ b/fs/btrfs/reada.c
> @@ -246,11 +246,9 @@ static struct reada_zone *reada_find_zone(struct btrfs_fs_info *fs_info,
>  	u64 end;
>  	int i;
>  
> -	zone = NULL;
>  	spin_lock(&fs_info->reada_lock);
> -	ret = radix_tree_gang_lookup(&dev->reada_zones, (void **)&zone,
> -				     logical >> PAGE_SHIFT, 1);
> -	if (ret == 1 && logical >= zone->start && logical <= zone->end) {
> +	zone = radix_tree_lookup(&dev->reada_zones, logical >> PAGE_SHIFT);
> +	if (zone && logical >= zone->start && logical <= zone->end) {
>  		kref_get(&zone->refcnt);
>  		spin_unlock(&fs_info->reada_lock);
>  		return zone;
> @@ -297,9 +295,9 @@ static struct reada_zone *reada_find_zone(struct btrfs_fs_info *fs_info,
>  
>  	if (ret == -EEXIST) {
>  		kfree(zone);
> -		ret = radix_tree_gang_lookup(&dev->reada_zones, (void **)&zone,
> -					     logical >> PAGE_SHIFT, 1);
> -		if (ret == 1 && logical >= zone->start && logical <= zone->end)
> +		zone = radix_tree_lookup(&dev->reada_zones,
> +				logical >> PAGE_SHIFT);
> +		if (zone && logical >= zone->start && logical <= zone->end)
>  			kref_get(&zone->refcnt);
>  		else
>  			zone = NULL;
> @@ -604,7 +602,6 @@ static int reada_pick_zone(struct btrfs_device *dev)
>  	u64 top_elems = 0;
>  	u64 top_locked_elems = 0;
>  	unsigned long index = 0;
> -	int ret;
>  
>  	if (dev->reada_curr_zone) {
>  		reada_peer_zones_set_lock(dev->reada_curr_zone, 0);
> @@ -615,9 +612,8 @@ static int reada_pick_zone(struct btrfs_device *dev)
>  	while (1) {
>  		struct reada_zone *zone;
>  
> -		ret = radix_tree_gang_lookup(&dev->reada_zones,
> -					     (void **)&zone, index, 1);
> -		if (ret == 0)
> +		zone = radix_tree_lookup(&dev->reada_zones, index);
> +		if (!zone)
>  			break;
>  		index = (zone->end >> PAGE_SHIFT) + 1;
>  		if (zone->locked) {
> @@ -669,19 +665,18 @@ static int reada_start_machine_dev(struct btrfs_fs_info *fs_info,
>  	 * a contiguous block of extents, we could also coagulate them or use
>  	 * plugging to speed things up
>  	 */
> -	ret = radix_tree_gang_lookup(&dev->reada_extents, (void **)&re,
> -				     dev->reada_next >> PAGE_SHIFT, 1);
> -	if (ret == 0 || re->logical > dev->reada_curr_zone->end) {
> +	re = radix_tree_lookup(&dev->reada_extents,
> +			dev->reada_next >> PAGE_SHIFT);
> +	if (!re || re->logical > dev->reada_curr_zone->end) {
>  		ret = reada_pick_zone(dev);
>  		if (!ret) {
>  			spin_unlock(&fs_info->reada_lock);
>  			return 0;
>  		}
> -		re = NULL;
> -		ret = radix_tree_gang_lookup(&dev->reada_extents, (void **)&re,
> -					dev->reada_next >> PAGE_SHIFT, 1);
> +		re = radix_tree_lookup(&dev->reada_extents,
> +				dev->reada_next >> PAGE_SHIFT);
>  	}
> -	if (ret == 0) {
> +	if (!re) {
>  		spin_unlock(&fs_info->reada_lock);
>  		return 0;
>  	}
> @@ -809,7 +804,6 @@ static void dump_devs(struct btrfs_fs_info *fs_info, int all)
>  	struct btrfs_device *device;
>  	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
>  	unsigned long index;
> -	int ret;
>  	int i;
>  	int j;
>  	int cnt;
> @@ -821,9 +815,9 @@ static void dump_devs(struct btrfs_fs_info *fs_info, int all)
>  		index = 0;
>  		while (1) {
>  			struct reada_zone *zone;
> -			ret = radix_tree_gang_lookup(&device->reada_zones,
> -						     (void **)&zone, index, 1);
> -			if (ret == 0)
> +
> +			zone = radix_tree_lookup(&device->reada_zones, index);
> +			if (!zone)
>  				break;
>  			pr_debug("  zone %llu-%llu elems %llu locked %d devs",
>  				    zone->start, zone->end, zone->elems,
> @@ -841,11 +835,10 @@ static void dump_devs(struct btrfs_fs_info *fs_info, int all)
>  		cnt = 0;
>  		index = 0;
>  		while (all) {
> -			struct reada_extent *re = NULL;
> +			struct reada_extent *re;
>  
> -			ret = radix_tree_gang_lookup(&device->reada_extents,
> -						     (void **)&re, index, 1);
> -			if (ret == 0)
> +			re = radix_tree_lookup(&device->reada_extents, index);
> +			if (!re)
>  				break;
>  			pr_debug("  re: logical %llu size %u empty %d scheduled %d",
>  				re->logical, fs_info->nodesize,
> @@ -870,11 +863,10 @@ static void dump_devs(struct btrfs_fs_info *fs_info, int all)
>  	index = 0;
>  	cnt = 0;
>  	while (all) {
> -		struct reada_extent *re = NULL;
> +		struct reada_extent *re;
>  
> -		ret = radix_tree_gang_lookup(&fs_info->reada_tree, (void **)&re,
> -					     index, 1);
> -		if (ret == 0)
> +		re = radix_tree_lookup(&fs_info->reada_tree, index);
> +		if (!re)
>  			break;
>  		if (!re->scheduled) {
>  			index = (re->logical >> PAGE_SHIFT) + 1;
> -- 
> 2.12.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
