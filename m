Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18052 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757287AbbGQKd3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jul 2015 06:33:29 -0400
Message-ID: <55A8D9DA.7000509@oracle.com>
Date: Fri, 17 Jul 2015 18:32:58 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Zhaolei <zhaolei@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Show detail information when mount failed on missing
 devices
References: <258b89aa6a4d0f3a46f205931a62ebb2d5656309.1437036246.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <258b89aa6a4d0f3a46f205931a62ebb2d5656309.1437036246.git.zhaolei@cn.fujitsu.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/16/2015 04:44 PM, Zhaolei wrote:
> From: Zhao Lei <zhaolei@cn.fujitsu.com>
>
> When mount failed because missing device, we can see following
> dmesg:
>   [ 1060.267743] BTRFS: too many missing devices, writeable mount is not allowed
>   [ 1060.273158] BTRFS: open_ctree failed
>
> This patch add missing_device_number and tolerated_missing_device_number
> to above output, to let user know what really happened, and helps
> bug-report and debug.

  yes.

> dmesg after patch:
>   [  127.912406] BTRFS: too many missing devices(1 > 0), writeable mount is not allowed
>   [  127.918128] BTRFS: open_ctree failed

  it better to change the whole message just (1 > 0) is not more
  informative unless src code is looked into.

  something like

  missing devices 1 max missing 0, writable mount is not allowed.

Thanks, Anand


> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---
>   fs/btrfs/disk-io.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 2eda03b..b6600c7 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2950,8 +2950,9 @@ retry_root_backup:
>   	if (fs_info->fs_devices->missing_devices >
>   	     fs_info->num_tolerated_disk_barrier_failures &&
>   	    !(sb->s_flags & MS_RDONLY)) {
> -		printk(KERN_WARNING "BTRFS: "
> -			"too many missing devices, writeable mount is not allowed\n");
> +		pr_warn("BTRFS: too many missing devices(%llu > %d), writeable mount is not allowed\n",
> +			fs_info->fs_devices->missing_devices,
> +			fs_info->num_tolerated_disk_barrier_failures);
>   		goto fail_sysfs;
>   	}
>
>
