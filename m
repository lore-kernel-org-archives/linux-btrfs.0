Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49313 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532AbaGDIHj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Jul 2014 04:07:39 -0400
Received: from kw-mxauth.gw.nic.fujitsu.com (unknown [10.0.237.134])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 1E7913EE0EC
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Jul 2014 17:07:37 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.nic.fujitsu.com [10.0.50.94])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 1649CAC0BC5
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Jul 2014 17:07:36 +0900 (JST)
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id B6EE5E08001
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Jul 2014 17:07:33 +0900 (JST)
Message-ID: <53B660B9.3040005@jp.fujitsu.com>
Date: Fri, 4 Jul 2014 17:07:21 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Miao Xie <miaox@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
CC: Anand Jain <anand.jain@oracle.com>,
        Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: Re: [PATCH V4 1/9] Btrfs: device_list_add() should not update list
 when mounted
References: <1404382933-26672-1-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1404382933-26672-1-git-send-email-miaox@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Miao, Anand,

(2014/07/03 19:22), Miao Xie wrote:
> From: Anand Jain <anand.jain@oracle.com>
> 
> device_list_add() is called when user runs btrfs dev scan, which would add
> any btrfs device into the btrfs_fs_devices list.

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Thanks,
Satoru

> 
> Now think of a mounted btrfs. And a new device which contains the a SB
> from the mounted btrfs devices.
> 
> In this situation when user runs btrfs dev scan, the current code would
> just replace existing device with the new device.
> 
> Which is to note that old device is neither closed nor gracefully
> removed from the btrfs.
> 
> The FS is still operational with the old bdev however the device name
> is the btrfs_device is new which is provided by the btrfs dev scan.
> 
> reproducer:
> 
> devmgt[1] detach /dev/sdc
> 
> replace the missing disk /dev/sdc
> 
> btrfs rep start -f 1 /dev/sde /btrfs
> Label: none  uuid: 5dc0aaf4-4683-4050-b2d6-5ebe5f5cd120
>          Total devices 2 FS bytes used 32.00KiB
>          devid    1 size 958.94MiB used 115.88MiB path /dev/sde
>          devid    2 size 958.94MiB used 103.88MiB path /dev/sdd
> 
> make /dev/sdc to reappear
> 
> devmgt attach host2
> 
> btrfs dev scan
> 
> btrfs fi show -m
> Label: none  uuid: 5dc0aaf4-4683-4050-b2d6-5ebe5f5cd120^M
>          Total devices 2 FS bytes used 32.00KiB^M
>          devid    1 size 958.94MiB used 115.88MiB path /dev/sdc <- Wrong.
>          devid    2 size 958.94MiB used 103.88MiB path /dev/sdd
> 
> since /dev/sdc has been replaced with /dev/sde, the /dev/sdc shouldn't be
> part of the btrfs-fsid when it reappears. If user want it to be part of it
> then sys admin should be using btrfs device add instead.
> 
> [1] github.com/anajain/devmgt.git
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
> Changelog v3->v4:
> - Fix the over-80-charactor problem
> ---
>   fs/btrfs/volumes.c | 27 +++++++++++++++++++++++++++
>   1 file changed, 27 insertions(+)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index a9c11a0..16e71a1 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -508,6 +508,33 @@ static noinline int device_list_add(const char *path,
>   		ret = 1;
>   		device->fs_devices = fs_devices;
>   	} else if (!device->name || strcmp(device->name->str, path)) {
> +		/*
> +		 * When FS is already mounted.
> +		 * 1. If you are here and if the device->name is NULL that
> +		 *    means this device was missing at time of FS mount.
> +		 * 2. If you are here and if the device->name is different
> +		 *    from 'path' that means either
> +		 *      a. The same device disappeared and reappeared with
> +		 *         different name. or
> +		 *      b. The missing-disk-which-was-replaced, has
> +		 *         reappeared now.
> +		 *
> +		 * We must allow 1 and 2a above. But 2b would be a spurious
> +		 * and unintentional.
> +		 *
> +		 * Further in case of 1 and 2a above, the disk at 'path'
> +		 * would have missed some transaction when it was away and
> +		 * in case of 2a the stale bdev has to be updated as well.
> +		 * 2b must not be allowed at all time.
> +		 */
> +
> +		/*
> +		 * As of now don't allow update to btrfs_fs_device through
> +		 * the btrfs dev scan cli, after FS has been mounted.
> +		 */
> +		if (fs_devices->opened)
> +			return -EBUSY;
> +
>   		name = rcu_string_strdup(path, GFP_NOFS);
>   		if (!name)
>   			return -ENOMEM;
> 

