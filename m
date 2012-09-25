Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:54052 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753936Ab2IYMvK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Sep 2012 08:51:10 -0400
Date: Tue, 25 Sep 2012 14:50:59 +0200
From: David Sterba <dave@jikos.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: David Sterba <dave@jikos.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: limit thread pool size when remounting
Message-ID: <20120925125059.GU14582@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1348555713-7518-1-git-send-email-bo.li.liu@oracle.com>
 <20120925113938.GT14582@twin.jikos.cz>
 <50619E64.1040808@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50619E64.1040808@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 25, 2012 at 08:07:00PM +0800, Liu Bo wrote:
> On 09/25/2012 07:39 PM, David Sterba wrote:
> > On Tue, Sep 25, 2012 at 02:48:33PM +0800, Liu Bo wrote:
> >> --- a/fs/btrfs/super.c
> >> +++ b/fs/btrfs/super.c
> >> @@ -1158,17 +1158,20 @@ static void btrfs_resize_thread_pool(struct btrfs_fs_info *fs_info,
> >>  	printk(KERN_INFO "btrfs: resize thread pool %d -> %d\n",
> >>  	       old_pool_size, new_pool_size);
> >>  
> >> -	btrfs_set_max_workers(&fs_info->generic_worker, new_pool_size);
> >> +	btrfs_set_max_workers(&fs_info->generic_worker, min(1, new_pool_size));
> > 
> > How could new_pool_size be < 1 ?
> > 
> > There's a check in super.c to pick only values > 0
> 
> I think we just need only 1 generic_worker

I got it reversed, sorry for the noise.

> >>  	btrfs_set_max_workers(&fs_info->workers, new_pool_size);
> >>  	btrfs_set_max_workers(&fs_info->delalloc_workers, new_pool_size);
> >> -	btrfs_set_max_workers(&fs_info->submit_workers, new_pool_size);
> >> -	btrfs_set_max_workers(&fs_info->caching_workers, new_pool_size);
> >> -	btrfs_set_max_workers(&fs_info->fixup_workers, new_pool_size);
> >> +	btrfs_set_max_workers(&fs_info->submit_workers,
> >> +			      min_t(u64, fs_info->fs_devices->num_devices,
> >> +			      new_pool_size));
> > 
> > This ask for update also when a new device is added/removed.
> > 
> 
> Oh, yes, but we should do it in another new patch instead.

Yes, this was just a hint to pair the remount/thread_pool capabilities.

david
