Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37925 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754841AbcIIMyv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Sep 2016 08:54:51 -0400
Date: Fri, 9 Sep 2016 14:53:13 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, clm@fb.com,
        idryomov@gmail.com
Subject: Re: [PATCH] btrfs: fix a possible umount deadlock
Message-ID: <20160909125313.GS16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160909083104.10383-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160909083104.10383-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 09, 2016 at 04:31:04PM +0800, Anand Jain wrote:
>  static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
>  {
>  	struct btrfs_device *device, *tmp;
> +	static LIST_HEAD(pending_put);

Why is it static?

> +	INIT_LIST_HEAD(&pending_put);
>  
>  	if (--fs_devices->opened > 0)
>  		return 0;
> @@ -906,9 +904,24 @@ static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
>  	mutex_lock(&fs_devices->device_list_mutex);
>  	list_for_each_entry_safe(device, tmp, &fs_devices->devices, dev_list) {
>  		btrfs_close_one_device(device);
> +		list_add(&device->dev_list, &pending_put);
>  	}
>  	mutex_unlock(&fs_devices->device_list_mutex);
>  
> +	/*
> +	 * btrfs_show_devname() is using the device_list_mutex,
> +	 * sometimes a call to blkdev_put() leads vfs calling
> +	 * into this func. So do put outside of device_list_mutex,
> +	 * as of now.
> +	 */
> +	while (!list_empty(&pending_put)) {
> +		device = list_entry(pending_put.next,
> +					struct btrfs_device, dev_list);
> +		list_del(&device->dev_list);
> +		btrfs_close_bdev(device);
> +		call_rcu(&device->rcu, free_device);
> +	}
> +
>  	WARN_ON(fs_devices->open_devices);
>  	WARN_ON(fs_devices->rw_devices);
>  	fs_devices->opened = 0;
