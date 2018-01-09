Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:36137 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759172AbeAIQWV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jan 2018 11:22:21 -0500
Received: by mail-qk0-f195.google.com with SMTP id d21so8214584qkj.3
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jan 2018 08:22:20 -0800 (PST)
Date: Tue, 9 Jan 2018 11:22:19 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/6] btrfs: make btrfs_free_stale_device() argument
 optional
Message-ID: <20180109162218.ufjsxx5v5mpby6z6@destiny>
References: <20180109141314.23795-1-anand.jain@oracle.com>
 <20180109141314.23795-5-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180109141314.23795-5-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 09, 2018 at 10:13:12PM +0800, Anand Jain wrote:
> From: Anand Jain <Anand.Jain@oracle.com>
> 
> This updates btrfs_free_stale_device() helper function to delete all
> unmouted devices, when arg is NULL.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/volumes.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 7b253da6c0a4..7646f8860096 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -611,9 +611,6 @@ static void btrfs_free_stale_device(struct btrfs_device *cur_dev)
>  	struct btrfs_fs_devices *fs_devs, *tmp_fs_devs;
>  	struct btrfs_device *dev, *tmp_dev;
>  
> -	if (!cur_dev->name)
> -		return;
> -
>  	list_for_each_entry_safe(fs_devs, tmp_fs_devs, &fs_uuids, list) {
>  
>  		if (fs_devs->opened)
> @@ -623,9 +620,7 @@ static void btrfs_free_stale_device(struct btrfs_device *cur_dev)
>  				         &fs_devs->devices, dev_list) {
>  			int not_found;

Change this to

int not_found = 0;

>  
> -			if (dev == cur_dev)
> -				continue;
> -			if (!dev->name)
> +			if (cur_dev && (cur_dev == dev || !dev->name))
>  				continue;
>  
>  			/*
> @@ -635,8 +630,11 @@ static void btrfs_free_stale_device(struct btrfs_device *cur_dev)
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

And drop the else part of this.  Thanks,

Josef
