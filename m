Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41089 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbbGUKNs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jul 2015 06:13:48 -0400
Message-ID: <55AE1B50.6030905@oracle.com>
Date: Tue, 21 Jul 2015 18:13:36 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Zhaolei <zhaolei@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: Show detail information when mount failed on
 missing devices
References: <afa8fe22bb5c6e18046b6a950cea399d31ab5407.1437386077.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <afa8fe22bb5c6e18046b6a950cea399d31ab5407.1437386077.git.zhaolei@cn.fujitsu.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


  Reviewed-by: Anand Jain <anand.jain@oracle.com>

On 07/20/2015 05:55 PM, Zhaolei wrote:
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
>
> dmesg after patch:
>   [  127.050367] BTRFS: missing devices(1) exceeds the limit(0), writeable mount is not allowed
>   [  127.056099] BTRFS: open_ctree failed
>
> Changelog v1->v2:
> 1: Changed to more clear description, suggested-by:
>     Anand Jain <anand.jain@oracle.com>
>
> Suggested-by: Anand Jain <anand.jain@oracle.com>
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---
>   fs/btrfs/disk-io.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 2eda03b..5b44e02 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2950,8 +2950,9 @@ retry_root_backup:
>   	if (fs_info->fs_devices->missing_devices >
>   	     fs_info->num_tolerated_disk_barrier_failures &&
>   	    !(sb->s_flags & MS_RDONLY)) {
> -		printk(KERN_WARNING "BTRFS: "
> -			"too many missing devices, writeable mount is not allowed\n");
> +		pr_warn("BTRFS: missing devices(%llu) exceeds the limit(%d), writeable mount is not allowed\n",
> +			fs_info->fs_devices->missing_devices,
> +			fs_info->num_tolerated_disk_barrier_failures);
>   		goto fail_sysfs;
>   	}
>
>
