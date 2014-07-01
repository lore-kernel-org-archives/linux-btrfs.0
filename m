Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:53117 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751930AbaGAHnq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Jul 2014 03:43:46 -0400
Message-ID: <53B265B2.100@cn.fujitsu.com>
Date: Tue, 1 Jul 2014 15:39:30 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>, <linux-btrfs@vger.kernel.org>
CC: <quwenruo@cn.fujitsu.com>
Subject: Re: [PATCH 2/2] btrfs: check generation as replace duplicates devid+uuid
References: <1402633581-19265-1-git-send-email-Anand.Jain@oracle.com> <1402633581-19265-2-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1402633581-19265-2-git-send-email-Anand.Jain@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Anand,

On 06/13/2014 12:26 PM, Anand Jain wrote:
>   
<..snip..>
> @@ -523,6 +523,16 @@ static noinline int device_list_add(const char *path,
>   
>   		if (fs_devices->opened)
>   			return -EBUSY;
> +		else {
> +			/*
> +			 * That is if the FS is _not_ mounted and if you are here, that
> +			 * means there is more than one disk with same uuid and devid.
> +			 * We keep the one with larger generation number or the last-in
> +			 * if generation are equal.
> +			 */
> +			if (found_transid < device->generation)
> +				return -EINVAL;
> +		}
I tried this patch it outputed the following message if it encounter two 
device with the same uuid and device id:

Scanning for Btrfs filesystems
ERROR: device scan failed '/dev/sdc' - Invalid argument

Same comment as your first patch here.
>   
>   		name = rcu_string_strdup(path, GFP_NOFS);
>   		if (!name)
> @@ -535,6 +545,15 @@ static noinline int device_list_add(const char *path,
>   		}
>   	}
>   
> +	/*
> +	 * Unmount does not free the btrfs_device struct but would zero
> +	 * generation along with most of the other members. So just update
> +	 * it back. We need it to pick the disk with largest generation
> +	 * (as above).
> +	 */
> +	if (!fs_devices->opened)
> +		device->generation = found_transid;
> +
>   	if (found_transid > fs_devices->latest_trans) {
>   		fs_devices->latest_devid = devid;
>   		fs_devices->latest_trans = found_transid;

