Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51757 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab3GCE46 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Jul 2013 00:56:58 -0400
Message-ID: <51D3B02A.5080500@oracle.com>
Date: Wed, 03 Jul 2013 13:01:30 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Wang Sheng-Hui <shhuiw@gmail.com>
CC: Josef Bacik <jbacik@fusionio.com>, chris.mason@fusionio.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: avoid memory leak in btrfs_close_devices
References: <51C994D5.3070509@gmail.com>
In-Reply-To: <51C994D5.3070509@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




  further, you need to free device->label as well.
----
static int device_list_add(const char *path,
                    struct btrfs_super_block *disk_super,
                    u64 devid, struct btrfs_fs_devices **fs_devices_ret)
{
::
                 device->label = kstrdup(disk_super->label, GFP_NOFS);
----

  disk_super->label is never null when disk_super is not null
  since its inline allocation. and kstrdup does  len = strlen(s) + 1;
  which looks like device->label is never NULL, but I havn't traced
  down kmalloc_track_caller until to its end

-----
  22 char *kstrdup(const char *s, gfp_t gfp)
  23 {
  24         size_t len;
  25         char *buf;
  26
  27         if (!s)
  28                 return NULL;
  29
  30         len = strlen(s) + 1;
  31         buf = kmalloc_track_caller(len, gfp);
  32         if (buf)
  33                 memcpy(buf, s, len);
  34         return buf;
  35 }
----------


Thanks, Anand



On 06/25/2013 09:02 PM, Wang Sheng-Hui wrote:
> Three kind of structures need to be freed on close:
>       * All struct btrfs_device managed by fs_devices
>       * The name field for each struct btrfs_device
>       * The above items for seed_devices
>
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
> ---
>   volumes.c |   16 +++++++++++++---
>   1 file changed, 13 insertions(+), 3 deletions(-)
>
> diff --git a/volumes.c b/volumes.c
> index d6f81f8..257b740 100644
> --- a/volumes.c
> +++ b/volumes.c
> @@ -153,6 +153,16 @@ static int device_list_add(const char *path,
>       return 0;
>   }
>
> +static void btrfs_close_device(struct btrfs_device *device)
> +{
> +    close(device->fd);
> +    device->fd = -1;
> +    device->writeable = 0;
> +    if (device->name)
> +        kfree(device->name);
> +    kfree(device);
> +}
> +
>   int btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
>   {
>       struct btrfs_fs_devices *seed_devices;
> @@ -161,17 +171,17 @@ int btrfs_close_devices(struct btrfs_fs_devices
> *fs_devices)
>   again:
>       list_for_each(cur, &fs_devices->devices) {
>           device = list_entry(cur, struct btrfs_device, dev_list);
> -        close(device->fd);
> -        device->fd = -1;
> -        device->writeable = 0;
> +        btrfs_close_device(device);
>       }
>
>       seed_devices = fs_devices->seed;
>       fs_devices->seed = NULL;
>       if (seed_devices) {
> +        kfree(fs_devices);
>           fs_devices = seed_devices;
>           goto again;
>       }
> +    kfree(fs_devices);
>
>       return 0;
>   }
