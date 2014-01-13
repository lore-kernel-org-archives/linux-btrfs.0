Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:21502 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbaAMKGL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jan 2014 05:06:11 -0500
Message-ID: <52D3BA54.6010601@cn.fujitsu.com>
Date: Mon, 13 Jan 2014 18:05:08 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Anand Jain <anand.jain@oracle.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [bug] its messy when missing device reappears after its been
 replaced in RAID1
References: <52CAE033.3020604@oracle.com>
In-Reply-To: <52CAE033.3020604@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Anand,

It seems that other developers did not notice such an important thread.:-)
I gave some of my opinions about this issue.

See more below.....

On 01/07/2014 12:56 AM, Anand Jain wrote:
>
> test case:
[snip]
....
> ----------------------------------------------------
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 2ca91fc..b226284 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -496,14 +496,39 @@ static noinline int device_list_add(const char 
> *path,
>
>                 device->fs_devices = fs_devices;
>         } else if (!device->name || strcmp(device->name->str, path)) {
> -               name = rcu_string_strdup(path, GFP_NOFS);
> -               if (!name)
> -                       return -ENOMEM;
> -               rcu_string_free(device->name);
> -               rcu_assign_pointer(device->name, name);
> -               if (device->missing) {
> -                       fs_devices->missing_devices--;
> -                       device->missing = 0;
> +
> +               struct buffer_head *bh;
> +               struct btrfs_super_block *cur_disk_super;
> +               u64 cur_transid;
> +
> +               if (!device->missing) {
> +                       bh = btrfs_read_dev_super(device->bdev);
> +                       if (!bh)
> +                               return -EINVAL;
> +
> +                       cur_disk_super = (struct btrfs_super_block *)
> +                        bh->b_data;
> +                       cur_transid = btrfs_super_generation(ds);
> +               } else
> +                       cur_transid = 0;
> +
> +               if (found_transid > cur_transid) {

I agree we use transid to find most proper device, but this check is not 
right.
Here @found_transid is the most biggest generation, so a right candidate 
device's
transid should be @found_tranid -1 (power off for example)or same as 
@found_transid.

Anyway, i think the right way should be to check two same id device, and 
we only replace
existed one if new found one's transid > previous one.

Please correct me if i miss something here.^_^

Thanks,
Wang
> +
> +                       name = rcu_string_strdup(path, GFP_NOFS);
> +                       if (!name)
> +                               return -ENOMEM;
> +
> +                       rcu_string_free(device->name);
> +                       rcu_assign_pointer(device->name, name);
> +
> +                       if (device->missing) {
> +                               fs_devices->missing_devices--;
> +                               device->missing = 0;
> +                       }
> +
> +       printk_in_rcu(KERN_INFO "%s tran %llu replaced %s tran %llu\n",
> +                               path, found_transid,
> +                               rcu_str_deref(device->name), tranid);
>                 }
>         }
>
> ---------------------------------------
>
>
> Thanks Anand
>
>
> [1] github.com/anajain/devmgt.git
>
>
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

