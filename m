Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35270 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726603AbeIJXiU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Sep 2018 19:38:20 -0400
Date: Mon, 10 Sep 2018 20:42:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 1/2] btrfs: Enhance btrfs_trim_fs function to handle
 error better
Message-ID: <20180910184235.GZ24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180829051532.32005-1-wqu@suse.com>
 <20180829051532.32005-2-wqu@suse.com>
 <36543236-61bc-e34f-8be8-2fe7001261ef@suse.com>
 <da32429e-0858-8ca0-fc86-9924c0ed2cfa@gmx.com>
 <6ac6161e-3d26-3bf3-7c4a-088f19a25b9d@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <6ac6161e-3d26-3bf3-7c4a-088f19a25b9d@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 29, 2018 at 05:40:12PM +0300, Nikolay Borisov wrote:
> 
> 
> On 29.08.2018 16:53, Qu Wenruo wrote:
> > 
> > 
> > On 2018/8/29 下午9:43, Nikolay Borisov wrote:
> >>
> >>
> >> On 29.08.2018 08:15, Qu Wenruo wrote:
> >>> Function btrfs_trim_fs() doesn't handle errors in a consistent way, if
> >>> error happens when trimming existing block groups, it will skip the
> >>> remaining blocks and continue to trim unallocated space for each device.
> >>>
> >>> And the return value will only reflect the final error from device
> >>> trimming.
> >>>
> >>> This patch will fix such behavior by:
> >>>
> >>> 1) Recording last error from block group or device trimming
> >>>    So return value will also reflect the last error during trimming.
> >>>    Make developer more aware of the problem.
> >>>
> >>> 2) Continuing trimming if we can
> >>>    If we failed to trim one block group or device, we could still try
> >>>    next block group or device.
> >>>
> >>> 3) Report number of failures during block group and device trimming
> >>>    So it would be less noisy, but still gives user a brief summary of
> >>>    what's going wrong.
> >>>
> >>> Such behavior can avoid confusion for case like failure to trim the
> >>> first block group and then only unallocated space is trimmed.
> >>>
> >>> Reported-by: Chris Murphy <lists@colorremedies.com>
> >>> Signed-off-by: Qu Wenruo <wqu@suse.com>
> >>> ---
> >>>  fs/btrfs/extent-tree.c | 57 ++++++++++++++++++++++++++++++------------
> >>>  1 file changed, 41 insertions(+), 16 deletions(-)
> >>>
> >>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> >>> index de6f75f5547b..7768f206196a 100644
> >>> --- a/fs/btrfs/extent-tree.c
> >>> +++ b/fs/btrfs/extent-tree.c
> >>> @@ -10832,6 +10832,16 @@ static int btrfs_trim_free_extents(struct btrfs_device *device,
> >>>  	return ret;
> >>>  }
> >>>  
> >>> +/*
> >>> + * Trim the whole fs, by:
> >>> + * 1) Trimming free space in each block group
> >>> + * 2) Trimming unallocated space in each device
> >>> + *
> >>> + * Will try to continue trimming even if we failed to trim one block group or
> >>> + * device.
> >>> + * The return value will be the last error during trim.
> >>> + * Or 0 if nothing wrong happened.
> >>> + */
> >>>  int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range)
> >>>  {
> >>>  	struct btrfs_block_group_cache *cache = NULL;
> >>> @@ -10842,6 +10852,10 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range)
> >>>  	u64 end;
> >>>  	u64 trimmed = 0;
> >>>  	u64 total_bytes = btrfs_super_total_bytes(fs_info->super_copy);
> >>> +	u64 bg_failed = 0;
> >>> +	u64 dev_failed = 0;
> >>> +	int bg_ret = 0;
> >>> +	int dev_ret = 0;
> >>>  	int ret = 0;
> >>>  
> >>>  	/*
> >>> @@ -10852,7 +10866,7 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range)
> >>>  	else
> >>>  		cache = btrfs_lookup_block_group(fs_info, range->start);
> >>>  
> >>> -	while (cache) {
> >>> +	for (; cache; cache = next_block_group(fs_info, cache)) {
> >>>  		if (cache->key.objectid >= (range->start + range->len)) {
> >>>  			btrfs_put_block_group(cache);
> >>>  			break;
> >>> @@ -10866,45 +10880,56 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range)
> >>>  			if (!block_group_cache_done(cache)) {
> >>>  				ret = cache_block_group(cache, 0);
> >>>  				if (ret) {
> >>> -					btrfs_put_block_group(cache);
> >>> -					break;
> >>> +					bg_failed++;
> >>> +					bg_ret = ret;
> >>> +					continue;
> >>>  				}
> >>>  				ret = wait_block_group_cache_done(cache);
> >>>  				if (ret) {
> >>> -					btrfs_put_block_group(cache);
> >>> -					break;
> >>> +					bg_failed++;
> >>> +					bg_ret = ret;
> >>> +					continue;
> >>>  				}
> >>>  			}
> >>> -			ret = btrfs_trim_block_group(cache,
> >>> -						     &group_trimmed,
> >>> -						     start,
> >>> -						     end,
> >>> -						     range->minlen);
> >>> +			ret = btrfs_trim_block_group(cache, &group_trimmed,
> >>> +						start, end, range->minlen);
> >>>  
> >>>  			trimmed += group_trimmed;
> >>>  			if (ret) {
> >>> -				btrfs_put_block_group(cache);
> >>> -				break;
> >>> +				bg_failed++;
> >>> +				bg_ret = ret;
> >>> +				continue;
> >>>  			}
> >>>  		}
> >>> -
> >>> -		cache = next_block_group(fs_info, cache);
> >>>  	}
> >>>  
> >>> +	if (bg_failed)
> >>> +		btrfs_warn(fs_info,
> >>> +		"failed to trim %llu block group(s), last error was %d",
> >>> +			   bg_failed, bg_ret);
> >>
> >> IMO this error handling strategy doesn't really bring any value. The
> >> only thing which the user really gathers from that error message is that
> >> N block groups failed. But there is no information whether it failed due
> >> to read failure hence cannot load the freespace cache or there was some
> >> error during the actual trimming.
> >>
> >> I agree that if we fail for 1 bg we shouldn't terminate the whole
> >> process but just skip it. However, a more useful error handling strategy
> >> would be to have btrfs_warns for every failed block group for every
> >> failed function.
> > 
> > Yep, previous version goes that way.
> > 
> > But even for btrfs_warn_rl() it could be too noisy.
> > And just as commented by David, user may not even care, thus such too
> > noisy report makes not much sense.
> > 
> > E.g. if something really went wrong and make the fs RO, then there will
> > be tons of error messages flooding dmesg (although most of them will be
> > rate limited), and really makes no sense.
> 
> Well in that case I don't see value in retaining the last error message
> so you can just leave the "%llu block groups failed to be trimmed"
> messages. The last error is not meaningful.

Do you mean the error value of the last error, saved to the bg_ret
variable? I'd say it's at least something to be returned to the user,
I find the bare "%llu failed to trim" not meaningful.

We had a discussion with Qu last time how to best report the errors from
the trim loops so I'm open to suggestions, but I don't see other options
if we don't want to flood the logs.
