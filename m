Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:47720 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751888AbeAJB1c (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jan 2018 20:27:32 -0500
Subject: Re: [PATCH 3/5] btrfs: get device pointer from device_list_add()
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org
References: <20180109144625.28381-1-anand.jain@oracle.com>
 <20180109144625.28381-4-anand.jain@oracle.com>
 <20180109161338.mz7qtwfzbzv5jon6@destiny>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <6ea75b55-88d1-c216-eae8-3319020910c1@oracle.com>
Date: Wed, 10 Jan 2018 09:28:31 +0800
MIME-Version: 1.0
In-Reply-To: <20180109161338.mz7qtwfzbzv5jon6@destiny>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 01/10/2018 12:13 AM, Josef Bacik wrote:
> On Tue, Jan 09, 2018 at 10:46:23PM +0800, Anand Jain wrote:
>> Instead of pointer to btrfs_fs_devices from device_list_add() its
>> better to get pointer to btrfs_device, then we have both, pointer
>> to btrfs_device and btrfs_fs_devices. This is needed in preparation
>> to add handling reappearing missing device feature.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> 
> Can we just change device_list_add to return struct btrfs_device * instead, and
> just do PTR_ERR() if there's a problem?  Thanks,

That's much better. Will do.

Thanks, Anand

> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
