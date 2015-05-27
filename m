Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35039 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129AbbE0Lei (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 May 2015 07:34:38 -0400
Date: Wed, 27 May 2015 13:34:37 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v5.1 24/27] Btrfs: free the stale device
Message-ID: <20150527113437.GQ23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1426845702-6298-25-git-send-email-anand.jain@oracle.com>
 <1432308828-31185-1-git-send-email-Anand.Jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1432308828-31185-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 22, 2015 at 11:33:48PM +0800, Anand Jain wrote:
> +void btrfs_free_stale_device(struct btrfs_device *cur_dev)
> +{
> +	int del = 0;
> +	struct btrfs_fs_devices *fs_devs;
> +	struct btrfs_device *dev;
> +
> +	if (!rcu_str_deref(cur_dev->name))
> +		return;

This looks like rcu-unprotected access, though there's an outer mutext
held in device_list_add that calls btrfs_free_stale_device. I'm not sure
that the device name should be used to do any sorts of checks at all.

> +	list_for_each_entry(fs_devs, &fs_uuids, list) {
> +		if (fs_devs->opened)
> +			continue;
> +		if (fs_devs->seeding)
> +			continue;
> +		list_for_each_entry(dev, &fs_devs->devices, dev_list) {
> +			if (dev == cur_dev)
> +				continue;
> +
> +			/*
> +			 * Todo: This won't be enough. What if same device
> +			 * comes back with new uuid and with its mapper path?
> +			 * But for now, this does helps as mostly an admin will
> +			 * use either mapper or non mapper path throughout.
> +			 */
> +			if (!rcu_str_deref(dev->name))
> +				continue;
> +			if (!strcmp(rcu_str_deref(dev->name),
> +						rcu_str_deref(cur_dev->name))) {
> +				del = 1;
> +				break;
> +			}
> +		}
> +		if (del) {
> +			/* delete the stale */
> +			if (fs_devs->num_devices == 1) {
> +				btrfs_sysfs_remove_fsid(fs_devs);
> +				list_del(&fs_devs->list);
> +				free_fs_devices(fs_devs);
> +			} else {
> +				fs_devs->num_devices--;
> +				list_del(&dev->dev_list);
> +				rcu_string_free(dev->name);
> +				kfree(dev);

Devices are normally freed by the rcu through free_device, this looks
suspicious to mix both approaches.

> +			}
> +			break;
> +		}
> +	}
> +	return;

Unnecessary return

> +}
> +
>  /*
>   * Add new device to list of registered devices
>   *
> @@ -560,6 +609,8 @@ static noinline int device_list_add(const char *path,
>  	if (!fs_devices->opened)
>  		device->generation = found_transid;
>  
> +	btrfs_free_stale_device(device);

It might be safe to do that in the end, but it should be explained
somewhere.

> +
>  	*fs_devices_ret = fs_devices;
>  
>  	return ret;
