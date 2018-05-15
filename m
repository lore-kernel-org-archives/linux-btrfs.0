Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36773 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751099AbeEOQ32 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 May 2018 12:29:28 -0400
Date: Tue, 15 May 2018 18:26:48 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 10/15] btrfs: drop uuid_mutex in btrfs_free_extra_devids()
Message-ID: <20180515162647.GT6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180412022938.8257-1-anand.jain@oracle.com>
 <20180412022938.8257-11-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180412022938.8257-11-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 12, 2018 at 10:29:33AM +0800, Anand Jain wrote:
> btrfs_free_extra_devids() frees the orphan fsid::devid but its search is
> limited to btrfs_fs_devices::devices, so we dont need uuid_mutex.

>From that it's not clear why there's no locking at all now:

> @@ -897,7 +897,6 @@ void btrfs_free_extra_devids(struct btrfs_fs_devices *fs_devices, int step)
>  	struct btrfs_device *device, *next;
>  	struct btrfs_device *latest_dev = NULL;
>  
> -	mutex_lock(&uuid_mutex);

ie. why is this not replaced by the device_list_lock. Please resend this
patch and explain in the changelog.

>  again:
>  	/* This is the initialized path, it is safe to release the devices. */
>  	list_for_each_entry_safe(device, next, &fs_devices->devices, dev_list) {
> @@ -951,8 +950,6 @@ void btrfs_free_extra_devids(struct btrfs_fs_devices *fs_devices, int step)
>  	}
>  
>  	fs_devices->latest_bdev = latest_dev->bdev;
> -
> -	mutex_unlock(&uuid_mutex);
>  }
>  
>  static void free_device_rcu(struct rcu_head *head)
