Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57974 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S968690AbeE3HLm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 May 2018 03:11:42 -0400
Subject: Re: [PATCH 6/6] btrfs: rename btrfs_free_stale_devices drop btrfs
 prefix
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180530065821.28385-1-anand.jain@oracle.com>
 <20180530065821.28385-7-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <4c713116-edf0-d421-cda4-61fa5d1630d8@suse.com>
Date: Wed, 30 May 2018 10:11:39 +0300
MIME-Version: 1.0
In-Reply-To: <20180530065821.28385-7-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 30.05.2018 09:58, Anand Jain wrote:
> btrfs_free_stale_devices() is a static function drop the btrfs prefix.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Nit: I think this patch could be dropped, it's not a set-in-stone rule
that static function shouldn't have btrfs_ prefix. Personally, I'd
prefer all subsys function to be prefixed so that in the call stack it's
clear when we are in generic code and when in fs code.

In the end it's the call of the maintainer.

> ---
>  fs/btrfs/volumes.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index a6a23b0185e5..afb3504f4097 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -634,7 +634,7 @@ static void pending_bios_fn(struct btrfs_work *work)
>   *  skip_dev:	Optional. Will skip this device when searching for the stale
>   *		devices.
>   */
> -static void btrfs_free_stale_devices(const char *path,
> +static void free_stale_devices(const char *path,
>  				     struct btrfs_device *skip_device)
>  {
>  	struct btrfs_fs_devices *fs_devices, *tmp_fs_devices;
> @@ -1271,7 +1271,7 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
>  	} else {
>  		*fs_devices_ret = device->fs_devices;
>  		if (new_device_added)
> -			btrfs_free_stale_devices(path, device);
> +			free_stale_devices(path, device);
>  	}
>  	mutex_unlock(&uuid_mutex);
>  
> 
