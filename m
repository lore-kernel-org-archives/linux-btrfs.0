Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:38213 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab3HWHfU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Aug 2013 03:35:20 -0400
Message-ID: <521710A7.3050401@giantdisaster.de>
Date: Fri, 23 Aug 2013 09:35:03 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Ilya Dryomov <idryomov@gmail.com>
CC: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>
Subject: Re: [PATCH 2/4] Btrfs: add btrfs_alloc_device and switch to it
References: <1376307184-7175-1-git-send-email-idryomov@gmail.com> <1376307184-7175-3-git-send-email-idryomov@gmail.com>
In-Reply-To: <1376307184-7175-3-git-send-email-idryomov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 12 Aug 2013 14:33:02 +0300, Ilya Dryomov wrote:
> Currently btrfs_device is allocated ad-hoc in a few different places,
> and as a result not all fields are initialized properly.  In particular,
> readahead state is only initialized in device_list_add (at scan time),
> and not in btrfs_init_new_device (when the new device is added with
> 'btrfs dev add').  Fix this by adding an allocation helper and switch
> everybody but __btrfs_close_devices to it.  (__btrfs_close_devices is
> dealt with in a later commit.)
> 
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>  fs/btrfs/volumes.c |  150 ++++++++++++++++++++++++++++++++--------------------
>  fs/btrfs/volumes.h |    3 ++
>  2 files changed, 96 insertions(+), 57 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index ae1bcb0..fe52704 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
[...]


> @@ -2142,9 +2133,9 @@ int btrfs_init_dev_replace_tgtdev(struct btrfs_root *root, char *device_path,
>  		}
>  	}
>  
> -	device = kzalloc(sizeof(*device), GFP_NOFS);
> -	if (!device) {
> -		ret = -ENOMEM;
> +	device = btrfs_alloc_device(NULL, BTRFS_DEV_REPLACE_DEVID, NULL);
> +	if (IS_ERR(device)) {
> +		ret = PTR_ERR(device);

BTRFS_DEV_REPLACE_DEVID is not a "const u64 *devid".


> +struct btrfs_device *btrfs_alloc_device(struct btrfs_fs_info *fs_info,
> +					const u64 *devid,
> +					const u8 *uuid)
> +{
> +	struct btrfs_device *dev;
> +	u64 tmp;
> +
> +	if (!devid && !fs_info) {
> +		WARN_ON(1);
> +		return ERR_PTR(-EINVAL);
> +	}

This WARN_ON(1) is triggered with the device replace procedure because
BTRFS_DEV_REPLACE_DEVID is zero.
