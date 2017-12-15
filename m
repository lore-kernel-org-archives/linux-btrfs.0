Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48002 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932168AbdLOPdI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Dec 2017 10:33:08 -0500
Subject: Re: [PATCH 1/6] btrfs: cleanup btrfs_free_stale_device() usage
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20171215034739.26090-1-anand.jain@oracle.com>
 <20171215034739.26090-2-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <fb2e920c-ea90-6ebd-e4a5-c1332cd88688@suse.com>
Date: Fri, 15 Dec 2017 17:33:06 +0200
MIME-Version: 1.0
In-Reply-To: <20171215034739.26090-2-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 15.12.2017 05:47, Anand Jain wrote:
> We call btrfs_free_stale_device() only when we alloc a new
> struct btrfs_device (ret=1), so move it closer to where we
> alloc the new device. Also drop the comments.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/volumes.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index b8ba3de6e9e6..6317a3561ae1 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -788,6 +788,7 @@ static noinline int device_list_add(const char *path,

nit: not directly related to the series in question, but I think you can
add one more patch which sinks the devid argument passed to
device_list_add. We already pass the disk_super and we can get the devid
in device_list_add this reduced the cognitive load when reading the code

>  
>  		ret = 1;
>  		device->fs_devices = fs_devices;
> +		btrfs_free_stale_device(device);
>  	} else if (!device->name || strcmp(device->name->str, path)) {
>  		/*
>  		 * When FS is already mounted.
> @@ -846,13 +847,6 @@ static noinline int device_list_add(const char *path,
>  	if (!fs_devices->opened)
>  		device->generation = found_transid;
>  
> -	/*
> -	 * if there is new btrfs on an already registered device,
> -	 * then remove the stale device entry.
> -	 */
> -	if (ret > 0)
> -		btrfs_free_stale_device(device);
> -
>  	*fs_devices_ret = fs_devices;
>  
>  	return ret;
> 
