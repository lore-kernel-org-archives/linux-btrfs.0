Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28410 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751704AbdJKGd3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Oct 2017 02:33:29 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9B6XRrH024707
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Oct 2017 06:33:28 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v9B6XRdC030554
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Oct 2017 06:33:27 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v9B6XREO022401
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Oct 2017 06:33:27 GMT
Subject: Re: [PATCH] Btrfs-progs: do not add stale device into fs_devices
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org,
        linux_lkml_grp@oracle.com
References: <20171011002852.2926-1-bo.li.liu@oracle.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <06336b81-6740-63f6-49a2-12ddd670cc07@oracle.com>
Date: Wed, 11 Oct 2017 14:33:13 +0800
MIME-Version: 1.0
In-Reply-To: <20171011002852.2926-1-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/11/2017 08:28 AM, Liu Bo wrote:
> If one of btrfs's devices was pulled out and we've replaced it with a
> new one, then they have the same uuid.
> 
> If that device gets reconnected, 'btrfs filesystem show' will show the
> stale one instead of the new one, but on kernel side btrfs has a fix
> to not include the stale one, this could confuse users as people may
> monitor btrfs by running that cli.
> 
> This does the similar thing to what kernel side has done.

  Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand


> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>   volumes.c | 15 ++++++++++++++-
>   1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/volumes.c b/volumes.c
> index 2f3943d..c7b7a41 100644
> --- a/volumes.c
> +++ b/volumes.c
> @@ -138,7 +138,20 @@ static int device_list_add(const char *path,
>   		list_add(&device->dev_list, &fs_devices->devices);
>   		device->fs_devices = fs_devices;
>   	} else if (!device->name || strcmp(device->name, path)) {
> -		char *name = strdup(path);
> +		char *name;
> +
> +		/*
> +		 * The existing device has newer generation, so this
> +		 * one could be a stale one, don't add it.
> +		 */
> +		if (found_transid < device->generation) {
> +			warning("adding device %s gen %llu but found a existing device %s gen %llu\n",
> +				path, found_transid, device->name,
> +				device->generation, found_transid);
> +			return -EEXIST;
> +		}
> +
> +		name = strdup(path);
>                   if (!name)
>                           return -ENOMEM;
>                   kfree(device->name);
> 
