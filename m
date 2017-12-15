Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40100 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756712AbdLOPGJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Dec 2017 10:06:09 -0500
Subject: Re: [PATCH 3/6] btrfs: make btrfs_free_stale_device() to iterate all
 stales
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20171215034739.26090-1-anand.jain@oracle.com>
 <20171215034739.26090-4-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <72509d75-b878-a349-68f8-628cc8c0d5c4@suse.com>
Date: Fri, 15 Dec 2017 17:06:06 +0200
MIME-Version: 1.0
In-Reply-To: <20171215034739.26090-4-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 15.12.2017 05:47, Anand Jain wrote:
> Let the list iterator iterate further and find other stale
> devices and delete it. This is in preparation to add support
> for user land request-able stale devices cleanup.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

What is the lock protection of this function - uuid_mutex, it's not
really obvious. Perhaps adding a lockdep_assert_held for the correct
lock ? I guess David's earlier patch to document the locking in
volumes.c might shed some light on this one.

> ---
>  fs/btrfs/volumes.c | 20 +++++++++-----------
>  1 file changed, 9 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 0e89409112d5..70db6a1d5658 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -610,19 +610,20 @@ static void pending_bios_fn(struct btrfs_work *work)
>  
>  static void btrfs_free_stale_device(struct btrfs_device *cur_dev)
>  {
> -	struct btrfs_fs_devices *fs_devs;
> -	struct btrfs_device *dev;
> +	struct btrfs_fs_devices *fs_devs, *tmp_fs_devs;
> +	struct btrfs_device *dev, *tmp_dev;
>  
>  	if (!cur_dev->name)
>  		return;
>  
> -	list_for_each_entry(fs_devs, &fs_uuids, list) {
> -		int del = 1;
> +	list_for_each_entry_safe(fs_devs, tmp_fs_devs, &fs_uuids, list) {
>  
>  		if (fs_devs->opened)
>  			continue;
>  
> -		list_for_each_entry(dev, &fs_devs->devices, dev_list) {
> +		list_for_each_entry_safe(dev, tmp_dev,
> +				         &fs_devs->devices, dev_list) {
> +			int not_found;
>  
>  			if (dev == cur_dev)
>  				continue;
> @@ -636,14 +637,12 @@ static void btrfs_free_stale_device(struct btrfs_device *cur_dev)
>  			 * either use mapper or non mapper path throughout.
>  			 */
>  			rcu_read_lock();
> -			del = strcmp(rcu_str_deref(dev->name),
> +			not_found = strcmp(rcu_str_deref(dev->name),
>  						rcu_str_deref(cur_dev->name));
>  			rcu_read_unlock();
> -			if (!del)
> -				break;
> -		}
> +			if (not_found)
> +				continue;
>  
> -		if (!del) {
>  			/* delete the stale device */
>  			if (fs_devs->num_devices == 1) {
>  				btrfs_sysfs_remove_fsid(fs_devs);
> @@ -654,7 +653,6 @@ static void btrfs_free_stale_device(struct btrfs_device *cur_dev)
>  				list_del(&dev->dev_list);
>  				free_device(dev);
>  			}
> -			break;
>  		}
>  	}
>  }
> 
