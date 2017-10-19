Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35467 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752574AbdJSRwL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Oct 2017 13:52:11 -0400
Date: Thu, 19 Oct 2017 19:50:23 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Satoru Takeuchi <satoru.takeuchi@gmail.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz, rich@shroop.net, rrauenza@gmail.com
Subject: Re: [PATCH] btrfs: Remove WARN_ON for unaligned device created
 before v4.13 and adds more user friendly output
Message-ID: <20171019175023.GP3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170920061843.9016-1-quwenruo.btrfs@gmx.com>
 <87bmm25i01.wl-satoru.takeuchi@gmail.com>
 <87a81m5hm1.wl-satoru.takeuchi@gmail.com>
 <ef36c960-d313-84ee-0bf7-fe716b0f73f9@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ef36c960-d313-84ee-0bf7-fe716b0f73f9@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 23, 2017 at 03:22:36PM +0800, Qu Wenruo wrote:
> >>> --- a/fs/btrfs/volumes.c
> >>> +++ b/fs/btrfs/volumes.c
> >>> @@ -6472,15 +6472,23 @@ static int read_one_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
> >>>   	return 0;
> >>>   }
> >>>   
> >>> -static void fill_device_from_item(struct extent_buffer *leaf,
> >>> -				 struct btrfs_dev_item *dev_item,
> >>> -				 struct btrfs_device *device)
> >>> +static void fill_device_from_item(struct btrfs_fs_info *fs_info,
> >>> +				  struct extent_buffer *leaf,
> >>> +				  struct btrfs_dev_item *dev_item,
> >>> +				  struct btrfs_device *device)
> >>>   {
> >>>   	unsigned long ptr;
> >>>   
> >>>   	device->devid = btrfs_device_id(leaf, dev_item);
> >>>   	device->disk_total_bytes = btrfs_device_total_bytes(leaf, dev_item);
> >>>   	device->total_bytes = device->disk_total_bytes;
> >>> +	if (!IS_ALIGNED(device->total_bytes, fs_info->sectorsize)) {
> >>> +		btrfs_warn(fs_info,
> >>> +			   "devid %llu has unaligned total bytes %llu",
> >>> +			   device->devid, device->disk_total_bytes);
> >>> +		btrfs_warn(fs_info,
> >>> +			   "please shrink the device a little and resize back to fix it");
> >>> +	}
> >>
> >> How about telling uses to know device->total_bytes should be alligned
> >> to fs_info->sectorsize here?
> >>
> >> Thanks,
> > 
> > I should make my comment clearer, sorry.
> > 
> > ===
> > +	if (!IS_ALIGNED(device->total_bytes, fs_info->sectorsize)) {
> > +		btrfs_warn(fs_info,
> > +			   "devid %llu: total bytes %llu should be aligned to %u bytes",
> > +			   device->devid, device->disk_total_bytes, fs_info->sectorsize);
> > +		btrfs_warn(fs_info,
> > +			   "please shrink the device a little and resize back to fix it");
> > +	}
> > ===
> 
> That's better.
> 
> But I'm also considering modifying the total_bytes directly here.

Yeah, I think it would be better to fix here, without a warning even.
The rounding error is below 4k and nodesize, we would never use this
space for block groups so no accidental data loss.

> So that any time DEV_ITEM and super block get updated, new aligned value 
> will be written back to disk, and since the value is aligned in memory, 
> it won't cause WARN_ON() any longer.
> 
> I'll test and check the code for confirmation before updating the patch.
