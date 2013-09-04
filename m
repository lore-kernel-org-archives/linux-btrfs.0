Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:15182 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756366Ab3IDHNw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Sep 2013 03:13:52 -0400
Message-ID: <5226DDAB.6030005@giantdisaster.de>
Date: Wed, 04 Sep 2013 09:13:47 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Ilya Dryomov <idryomov@gmail.com>
CC: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>
Subject: Re: [PATCH] Btrfs: do not add replace target to the alloc_list
References: <1378051004-8369-1-git-send-email-idryomov@gmail.com>
In-Reply-To: <1378051004-8369-1-git-send-email-idryomov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun,  1 Sep 2013 18:56:44 +0300, Ilya Dryomov wrote:
> If replace was suspended by the umount, replace target device is added
> to the fs_devices->alloc_list during a later mount.  This is obviously
> wrong.  ->is_tgtdev_for_dev_replace is supposed to guard against that,
> but ->is_tgtdev_for_dev_replace is (and can only ever be) initialized
> *after* everything is opened and fs_devices lists are populated.  Fix
> this by checking the devid instead: for replace targets it's always
> equal to BTRFS_DEV_REPLACE_DEVID.
> 
> Cc: Stefan Behrens <sbehrens@giantdisaster.de>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
> At first I thought this was caused by my btrfs_device rollback patch,
> but no, it just made it easier to spot -- previously one had to reboot
> or rmmod/insmod before mounting a suspended replace.
> 
>  fs/btrfs/volumes.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index c9a0977..5b99f19 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -793,7 +793,8 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
>  			fs_devices->rotating = 1;
>  
>  		fs_devices->open_devices++;
> -		if (device->writeable && !device->is_tgtdev_for_dev_replace) {
> +		if (device->writeable &&
> +		    device->devid != BTRFS_DEV_REPLACE_DEVID) {
>  			fs_devices->rw_devices++;
>  			list_add(&device->dev_alloc_list,
>  				 &fs_devices->alloc_list);
> 

Reviewed-by: Stefan Behrens <sbehrens@giantdisaster.de>

