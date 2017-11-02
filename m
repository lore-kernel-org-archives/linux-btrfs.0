Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44957 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752632AbdKBJtS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Nov 2017 05:49:18 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D5970ABD9
        for <linux-btrfs@vger.kernel.org>; Thu,  2 Nov 2017 09:49:16 +0000 (UTC)
Subject: Re: [PATCH 11/11] btrfs: use non-RCU list traversal in
 write_all_supers callees
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1509471604.git.dsterba@suse.com>
 <8430e9c00d58748f1cb574b686396c8349ac7311.1509471604.git.dsterba@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <f5d61e0d-b9b1-a34f-c3d2-3ba27ab4c448@suse.com>
Date: Thu, 2 Nov 2017 11:49:15 +0200
MIME-Version: 1.0
In-Reply-To: <8430e9c00d58748f1cb574b686396c8349ac7311.1509471604.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 31.10.2017 19:44, David Sterba wrote:
> We take the fs_devices::device_list_mutex mutex in write_all_supers
> which will prevent any add/del changes to the device list. Therefore we
> don't need to use the RCU variant list_for_each_entry_rcu in any of the
> called functions.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/disk-io.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index efce9a2fa9be..042cf46e4cd0 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3396,9 +3396,10 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
>  	int errors_wait = 0;
>  	blk_status_t ret;
>  
> +	WARN_ON(!mutex_is_locked(&info->fs_devices->device_list_mutex));

Don't we want lockdep_assert_held ? I'm assuming enough testing with
lockdep on is performed so it will be caught in time if this invariant
is broken.

>  	/* send down all the barriers */
>  	head = &info->fs_devices->devices;
> -	list_for_each_entry_rcu(dev, head, dev_list) {
> +	list_for_each_entry(dev, head, dev_list) {
>  		if (dev->missing)
>  			continue;
>  		if (!dev->bdev)
> @@ -3411,7 +3412,7 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
>  	}
>  
>  	/* wait for all the barriers */
> -	list_for_each_entry_rcu(dev, head, dev_list) {
> +	list_for_each_entry(dev, head, dev_list) {
>  		if (dev->missing)
>  			continue;
>  		if (!dev->bdev) {
> @@ -3510,7 +3511,7 @@ int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors)
>  		}
>  	}
>  
> -	list_for_each_entry_rcu(dev, head, dev_list) {
> +	list_for_each_entry(dev, head, dev_list) {
>  		if (!dev->bdev) {
>  			total_errors++;
>  			continue;
> @@ -3551,7 +3552,7 @@ int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors)
>  	}
>  
>  	total_errors = 0;
> -	list_for_each_entry_rcu(dev, head, dev_list) {
> +	list_for_each_entry(dev, head, dev_list) {
>  		if (!dev->bdev)
>  			continue;
>  		if (!dev->in_fs_metadata || !dev->writeable)
> 
