From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] Btrfs: fix oops when calling statfs on readonly device
Date: Mon, 28 Nov 2011 11:04:54 +0100
Message-ID: <20111128100454.GJ12759@twin.jikos.cz>
References: <4ED34994.6020006@cn.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4ED34994.6020006@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 28, 2011 at 04:43:00PM +0800, Li Zefan wrote:
> To reproduce this bug:
> 
>   # dd if=/dev/zero of=img bs=1M count=256
>   # mkfs.btrfs img
>   # losetup -r /dev/loop1 img
>   # mount /dev/loop1 /mnt
>   OOPS!!
> 
> It triggered BUG_ON(!nr_devices) in btrfs_calc_avail_data_space().

FYI, A patch fixing this has been sent long ago but the was not picked
up. I have collected and pushed it to Chris last week.

http://lkml.indiana.edu/hypermail/linux/kernel/1108.0/00157.html

> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1083,7 +1083,7 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
>  	int i = 0, nr_devices;
>  	int ret;
>  
> -	nr_devices = fs_info->fs_devices->rw_devices;
> +	nr_devices = fs_info->fs_devices->open_devices;
>  	BUG_ON(!nr_devices);

This what the referenced patch does ...

>  
>  	devices_info = kmalloc(sizeof(*devices_info) * nr_devices,
> @@ -1105,8 +1105,8 @@ static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
>  	else
>  		min_stripe_size = BTRFS_STRIPE_LEN;
>  
> -	list_for_each_entry(device, &fs_devices->alloc_list, dev_alloc_list) {
> -		if (!device->in_fs_metadata)
> +	list_for_each_entry(device, &fs_devices->devices, dev_list) {
> +		if (!device->in_fs_metadata || !device->bdev)
>  			continue;

... but misses this part, so you patch is more complete and should be
picked instead.


david
