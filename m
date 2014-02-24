Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45178 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaBXLYZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Feb 2014 06:24:25 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s1OBOOcp007295
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Feb 2014 11:24:24 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s1OBONns009256
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Feb 2014 11:24:23 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s1OBONI3009057
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Feb 2014 11:24:23 GMT
Message-ID: <530B2BE4.5070906@oracle.com>
Date: Mon, 24 Feb 2014 19:24:20 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs-progs: there is devid 0 when replace is running
References: <1391487810-21545-1-git-send-email-anand.jain@oracle.com> <1391502828-24481-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1391502828-24481-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



kindly ignore this patch. Though it correct that we need to
start from devid 0 to scan. But the individual scan is broken
well before this patch. So to fix all together a patch bundle
is sent to the mailing list including this

Thanks Anand


On 02/04/14 04:33 PM, Anand Jain wrote:
> During disk replacement a new disk is temporarily
> added to the fs devlist with devid 0 and fs num_device is
> incremented by 1. However when progs reads the devlist it
> fail to obtain details of devid 0 because it doesn't query
> devid 0 at all.
>
> reproducer:
>
>   btrfs rep start /dev/sdb /dev/sdf /btrfs
>   btrfs fi show
>   Label: none  uuid: f8fb9819-16c8-47b7-b62f-0ff90f8c56cd
>          Total devices 3 FS bytes used 1.94GiB
>          devid    1 size 1.10GiB used 1.10GiB path /dev/sdb
>          devid    2 size 1.10GiB used 1.08GiB path /dev/sdc
>          devid    0 size 0.00 used 0.00 path
>
>    this patch will make it proper by querying devid 0.
>
>   btrfs repl start /dev/sdb /dev/sdf /btrfs
>   btrfs fi show /btrfs
>   Label: none  uuid: f8fb9819-16c8-47b7-b62f-0ff90f8c56cd
>          Total devices 3 FS bytes used 1.94GiB
>          devid    0 size 1.10GiB used 1.10GiB path /dev/sdf
>          devid    1 size 1.10GiB used 1.10GiB path /dev/sdb
>          devid    2 size 1.10GiB used 1.08GiB path /dev/sdc
>
>   Its fine to query devid 0 when there is no replace
>   activity as well, because we just skip the error ENODEV
>
>   btrfs fi show /btrfs
>   Label: none  uuid: f8fb9819-16c8-47b7-b62f-0ff90f8c56cd
>          Total devices 2 FS bytes used 1.94GiB
>          devid    1 size 1.10GiB used 1.10GiB path /dev/sdf
>          devid    2 size 1.10GiB used 1.08GiB path /dev/sdc
> ---
>
>   v2: fix commit message
>
>   utils.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/utils.c b/utils.c
> index de513b6..a045ffd 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -1696,7 +1696,7 @@ int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
>   		goto out;
>   	}
>
> -	for (; i <= fi_args->max_id; ++i) {
> +	for (i = 0; i <= fi_args->max_id; ++i) {
>   		BUG_ON(ndevs >= fi_args->num_devices);
>   		ret = get_device_info(fd, i, &di_args[ndevs]);
>   		if (ret == -ENODEV)
>
