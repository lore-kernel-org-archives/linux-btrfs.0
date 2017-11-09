Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50085 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752902AbdKIPyA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 9 Nov 2017 10:54:00 -0500
Subject: Re: [PATCH 2/4] btrfs: let variable required be declared inside the
 loop
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20171109154526.23181-1-anand.jain@oracle.com>
 <20171109154526.23181-3-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <a387f7e4-19cb-26be-f9c5-4cd2458cf555@suse.com>
Date: Thu, 9 Nov 2017 17:53:58 +0200
MIME-Version: 1.0
In-Reply-To: <20171109154526.23181-3-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  9.11.2017 17:45, Anand Jain wrote:
> A preparation patch to create the actual device open in a new function.
> 

Just say you are reducing the visibility of some variables to the loop.

> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/volumes.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index ab2f349ee293..ea6e542cb09d 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -970,19 +970,20 @@ int btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
>  static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
>  				fmode_t flags, void *holder)
>  {
> -	struct request_queue *q;
> -	struct block_device *bdev;
>  	struct list_head *head = &fs_devices->devices;
>  	struct btrfs_device *device;
>  	struct btrfs_device *latest_dev = NULL;
> -	struct buffer_head *bh;
> -	struct btrfs_super_block *disk_super;
> -	u64 devid;
>  	int ret = 0;
>  
>  	flags |= FMODE_EXCL;
>  
>  	list_for_each_entry(device, head, dev_list) {
> +		struct request_queue *q;
> +		struct block_device *bdev;
> +		struct buffer_head *bh;
> +		struct btrfs_super_block *disk_super;
> +		u64 devid;
> +
>  		if (device->bdev)
>  			continue;
>  		if (!device->name)
> 
