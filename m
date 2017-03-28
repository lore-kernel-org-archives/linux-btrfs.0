Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53656 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752012AbdC1QUE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Mar 2017 12:20:04 -0400
Date: Tue, 28 Mar 2017 18:19:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, quwenruo@cn.fujitsu.com
Subject: Re: [PATCH V2 4/4] btrfs: cleanup barrier_all_devices() to check dev
 stat flush error
Message-ID: <20170328161905.GB4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170313074214.24123-5-anand.jain@oracle.com>
 <20170314082611.31530-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170314082611.31530-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 14, 2017 at 04:26:11PM +0800, Anand Jain wrote:
> The objective of this patch is to cleanup barrier_all_devices()
> so that the error checking is in a separate loop independent of
> of the loop which submits and waits on the device flush requests.

I think that getting completely rid of the ENOMEM as suggested under
patch 2, the split would not be necessary.

The send failures will be gone so we can simply count failures from the
waiting write_dev_flush(..., 1). There any returned error also implies
the device stat increase for FLUSH_ERRS. Then barrier_all_devices will
be a bit simpler.

> By doing this it helps to further develop patches which would tune
> the error-actions as needed.
> 
> Here functions such as btrfs_dev_stats_dirty() couldn't be used
> because it doesn't monitor the flush errors BTRFS_DEV_STAT_FLUSH_ERRS.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> v2: Address Qu review comments viz..
>      Add meaningful names, like cp_list (for checkpoint_list head).
>      (And actually it does not need a new struct type just to hold
>       the head pointer, list node is already named as device_checkpoint).
>      Check return value of add_device_checkpoint()
>      Check if the device is already added at add_device_checkpoint()
>      Rename fini_devices_checkpoint() to rel_devices_checkpoint()
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 5719e036048b..d0c401884643 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3566,6 +3566,86 @@ static int write_dev_flush(struct btrfs_device *device, int wait)
>  	return 0;
>  }
>  
> +struct device_checkpoint {
> +	struct list_head cp_node;
> +	struct btrfs_device *device;
> +	int stat_value_checkpoint;
> +};

I find this approach particularly bad for several reasons.

You need to store just one int per device but introduce a bloated
temporary structure. If anything, the int could be embeded in
btrfs_device, set and checked at the right points. Instead, you add
memory allocations to a critical context and more potential failure
paths.

> +static int add_device_checkpoint(struct btrfs_device *device,
> +				struct list_head *cp_list)
> +{
...
> +	cdev = kzalloc(sizeof(struct device_checkpoint), GFP_KERNEL);
...
> +}

The memory allocations are GFP_KERNEL, this could lead to strange
lockups if the allocator tries to free memory and asks the filesystem(s)
to flush their data.

Traversing the structures leads to quadratic complexity in
check_barrier_error(), where the checkpoint list is traversed for
each iteration of device list.

> @@ -3574,8 +3654,8 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
>  {
>  	struct list_head *head;
>  	struct btrfs_device *dev;
> -	int dropouts = 0;
>  	int ret;
> +	static LIST_HEAD(cp_list);
        ^^^^^^

What is this supposed to mean? What if several filesystems end up in
barrier_all_devices modifying the list?
