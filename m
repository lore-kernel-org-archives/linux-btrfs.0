Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38326 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934344AbcIUO2Q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Sep 2016 10:28:16 -0400
Date: Wed, 21 Sep 2016 16:26:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, idryomov@gmail.com
Subject: Re: [PATCH v2] btrfs: fix a possible umount deadlock
Message-ID: <20160921142614.GI16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160909083104.10383-1-anand.jain@oracle.com>
 <20160909230338.1493-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160909230338.1493-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 10, 2016 at 07:03:38AM +0800, Anand Jain wrote:
>  static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
>  {
>  	struct btrfs_device *device, *tmp;
> +	LIST_HEAD(pending_put);
> +	INIT_LIST_HEAD(&pending_put);

LIST_HEAD declares and initializes the list to an empty one, not
necessary to call INIT_LIST_HEAD.

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

Could be list_first_entry
> +					struct btrfs_device, dev_list);
> +		list_del(&device->dev_list);
> +		btrfs_close_bdev(device);
> +		call_rcu(&device->rcu, free_device);
> +	}
> +
>  	WARN_ON(fs_devices->open_devices);
>  	WARN_ON(fs_devices->rw_devices);
>  	fs_devices->opened = 0;

After this patch, the function btrfs_close_one_device no longer does
what it says, ie. it does not close the device. I'd have to look closer
why it allocates a new structure and replaces it in the list, but this
looks weird.
