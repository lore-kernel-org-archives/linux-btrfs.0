Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48315 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbaBNBeB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Feb 2014 20:34:01 -0500
Received: from m3.gw.fujitsu.co.jp (unknown [10.0.50.73])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 0A3843EE0BC
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Feb 2014 10:34:00 +0900 (JST)
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id EF60945DEB7
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Feb 2014 10:33:59 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.nic.fujitsu.com [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id D843C45DD76
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Feb 2014 10:33:59 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id CADBA1DB803E
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Feb 2014 10:33:59 +0900 (JST)
Received: from m1001.s.css.fujitsu.com (m1001.s.css.fujitsu.com [10.240.81.139])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 76BF21DB803B
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Feb 2014 10:33:59 +0900 (JST)
Message-ID: <52FD726B.2080503@jp.fujitsu.com>
Date: Fri, 14 Feb 2014 10:33:31 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: Anand Jain <Anand.Jain@oracle.com>, clm@fb.com
Subject: Re: [RFC PATCH] btrfs: fix null pointer deference at btrfs_sysfs_add_one+0x105
References: <1389777748-4341-1-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1389777748-4341-1-git-send-email-Anand.Jain@oracle.com>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I still see this trouble on v3.14-rc2.
I confirmed that we cannot do mount with -o degraded without
this patch. Could you pick this up, Chris?

Thanks,
H.Seto

Feel free to add:
Tested-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

(2014/01/15 18:22), Anand Jain wrote:
> bdev is null when disk has disappeared and mounted with
> the degrade option
> 
> stack trace
> ---------
> btrfs_sysfs_add_one+0x105/0x1c0 [btrfs]
> open_ctree+0x15f3/0x1fe0 [btrfs]
> btrfs_mount+0x5db/0x790 [btrfs]
> ? alloc_pages_current+0xa4/0x160
> mount_fs+0x34/0x1b0
> vfs_kern_mount+0x62/0xf0
> do_mount+0x22e/0xa80
> ? __get_free_pages+0x9/0x40
> ? copy_mount_options+0x31/0x170
> SyS_mount+0x7e/0xc0
> system_call_fastpath+0x16/0x1b
> ---------
> 
> reproducer:
> -------
> mkfs.btrfs -draid1 -mraid1 /dev/sdc /dev/sdd
> (detach a disk)
> devmgt detach /dev/sdc [1]
> mount -o degrade /dev/sdd /btrfs
> -------
> 
> [1] github.com/anajain/devmgt.git
> 
> Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
> ---
>  fs/btrfs/sysfs.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> index ba94b27..f20bc1f 100644
> --- a/fs/btrfs/sysfs.c
> +++ b/fs/btrfs/sysfs.c
> @@ -578,8 +578,14 @@ static int add_device_membership(struct btrfs_fs_info *fs_info)
>  		return -ENOMEM;
>  
>  	list_for_each_entry(dev, &fs_devices->devices, dev_list) {
> -		struct hd_struct *disk = dev->bdev->bd_part;
> -		struct kobject *disk_kobj = &part_to_dev(disk)->kobj;
> +		struct hd_struct *disk;
> +		struct kobject *disk_kobj;
> +
> +		if (!dev->bdev)
> +			continue;
> +
> +		disk = dev->bdev->bd_part;
> +		disk_kobj = &part_to_dev(disk)->kobj;
>  
>  		error = sysfs_create_link(fs_info->device_dir_kobj,
>  					  disk_kobj, disk_kobj->name);
> 

