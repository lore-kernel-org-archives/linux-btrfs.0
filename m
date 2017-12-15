Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40763 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752660AbdLOPHs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Dec 2017 10:07:48 -0500
Subject: Re: [PATCH 4/6] btrfs: make btrfs_free_stale_device() argument
 optional
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20171215034739.26090-1-anand.jain@oracle.com>
 <20171215034739.26090-5-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <b3a90794-2186-8740-186f-ad84733595d3@suse.com>
Date: Fri, 15 Dec 2017 17:07:47 +0200
MIME-Version: 1.0
In-Reply-To: <20171215034739.26090-5-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 15.12.2017 05:47, Anand Jain wrote:
> This updates btrfs_free_stale_device() helper function to delete all
> unmouted devices, when arg is NULL.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/volumes.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 70db6a1d5658..9aee4f987221 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -613,9 +613,6 @@ static void btrfs_free_stale_device(struct btrfs_device *cur_dev)
>  	struct btrfs_fs_devices *fs_devs, *tmp_fs_devs;
>  	struct btrfs_device *dev, *tmp_dev;
>  
> -	if (!cur_dev->name)
> -		return;
> -
>  	list_for_each_entry_safe(fs_devs, tmp_fs_devs, &fs_uuids, list) {
>  
>  		if (fs_devs->opened)
> @@ -625,9 +622,7 @@ static void btrfs_free_stale_device(struct btrfs_device *cur_dev)
>  				         &fs_devs->devices, dev_list) {
>  			int not_found;
>  
> -			if (dev == cur_dev)
> -				continue;
> -			if (!dev->name)
> +			if (cur_dev && (cur_dev == dev || !dev->name))
>  				continue;
>  
>  			/*
> @@ -637,8 +632,11 @@ static void btrfs_free_stale_device(struct btrfs_device *cur_dev)
>  			 * either use mapper or non mapper path throughout.
>  			 */
>  			rcu_read_lock();
> -			not_found = strcmp(rcu_str_deref(dev->name),
> -						rcu_str_deref(cur_dev->name));
> +			if (cur_dev)
> +				not_found = strcmp(rcu_str_deref(dev->name),
> +						   rcu_str_deref(cur_dev->name));
> +			else
> +				not_found = 0;

nit: Perhaps put a proper documentation header at the beginning of the
function detailing this behavior. I.e.

/*
 * btrfs_free_stale_device
 * ....

>  			rcu_read_unlock();
>  			if (not_found)
>  				continue;
> 
