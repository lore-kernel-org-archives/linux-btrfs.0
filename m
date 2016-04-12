Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kolab.zavadatar.com ([46.101.124.0]:51044 "EHLO
	kolab.zavadatar.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965012AbcDLTVp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Apr 2016 15:21:45 -0400
Date: Tue, 12 Apr 2016 22:21:39 +0300
From: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 01/13] btrfs: Introduce a new function to check if all
 chunks a OK for degraded mount
Message-ID: <20160412192139.GA17845@jeknote.loshitsa1.net>
References: <1460470563-752-1-git-send-email-anand.jain@oracle.com>
 <1460470563-752-2-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1460470563-752-2-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 12, 2016 at 10:15:51PM +0800, Anand Jain wrote:
> From: Qu Wenruo <quwenruo@cn.fujitsu.com>
> 
> Introduce a new function, btrfs_check_degradable(), to judge if all chunks
> in btrfs is OK for degraded mount.
> 
> It provides the new basis for accurate btrfs mount/remount and even
> runtime degraded mount check other than old one-size-fit-all method.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  fs/btrfs/volumes.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/volumes.h |  1 +
>  2 files changed, 64 insertions(+)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 9d72dabdddfc..a351c5dd9e9b 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -7039,3 +7039,66 @@ static void btrfs_close_one_device(struct btrfs_device *device)
>  
>  	call_rcu(&device->rcu, free_device);
>  }
> +
> +/*
> + * Check if all chunks in the fs is OK for degraded mount
> + * Caller itself should do extra check if DEGRADED mount option is given
> + * for >0 return value.
> + *
> + * Return 0 if all chunks are OK.
> + * Return >0 if all chunks are degradable but not all OK.
> + * Return <0 if any chunk is not degradable or other bug.
> + */
> +int btrfs_check_degradable(struct btrfs_fs_info *fs_info, unsigned flags)
> +{
> +	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
> +	struct extent_map *em;
> +	u64 next_start = 0;
> +	int ret = 0;
> +
> +	if (flags & MS_RDONLY)
> +		return 0;
> +
> +	read_lock(&map_tree->map_tree.lock);
> +	em = lookup_extent_mapping(&map_tree->map_tree, 0, (u64)(-1));
> +	/* No any chunk? Should be a huge bug */
> +	if (!em) {
> +		ret = -ENOENT;
> +		goto out;
> +	}
> +
> +	while (em) {
> +		struct map_lookup *map;
> +		int missing = 0;
> +		int max_tolerated;
> +		int i;
> +
> +		map = (struct map_lookup *) em->bdev;
> +		max_tolerated =
> +			btrfs_get_num_tolerated_disk_barrier_failures(
> +					map->type);
> +		for (i = 0; i < map->num_stripes; i++) {
> +			if (map->stripes[i].dev->missing)
> +				missing++;
> +		}
> +		if (missing > max_tolerated) {
> +			ret = -EIO;
> +			btrfs_warn(fs_info,
> +				   "missing devices(%d) exceeds the limit(%d), writebale mount is not allowed",
> +				   missing, max_tolerated);

Typo: s/writebale/writeable/


-- 
Yauhen Kharuzhy
