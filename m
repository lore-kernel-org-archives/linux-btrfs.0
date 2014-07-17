Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:30535 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753261AbaGQDTc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jul 2014 23:19:32 -0400
Message-ID: <53C74122.7080902@cn.fujitsu.com>
Date: Thu, 17 Jul 2014 11:21:06 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: <miaox@cn.fujitsu.com>
MIME-Version: 1.0
To: <bo.li.liu@oracle.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] Btrfs: fix wrong missing device counter decrease
References: <1405507081-8811-1-git-send-email-miaox@cn.fujitsu.com> <20140717023756.GA4271@localhost.localdomain>
In-Reply-To: <20140717023756.GA4271@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 17 Jul 2014 10:37:57 +0800, Liu Bo wrote:
> On Wed, Jul 16, 2014 at 06:38:01PM +0800, Miao Xie wrote:
>> The missing devices are accounted by its own fs device, for example
>> the missing devices in seed filesystem will be accounted by the fs device
>> of the seed filesystem, not by the new filesystem which is based on
>> the seed filesystem, so when we remove the missing device in the
>> seed filesystem, we should decrease the counter of its own fs device.
>> Fix it.
>>
>> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
>> ---
>> This patch is against:
>> [PATCH 8/9] Btrfs: fix unzeroed members in fs_devices when creating a fs from seed fs
>> ---
>>  fs/btrfs/volumes.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index daecfa5..4cfbe76 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -1723,7 +1723,7 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
>>  	device->fs_devices->total_devices--;
>>  
>>  	if (device->missing)
>> -		root->fs_info->fs_devices->missing_devices--;
>> +		device->fs_devices->missing_devices--;
> 
> But it is 'root->fs_info->fs_devices->missing_devices' that is increased in the
> case of both read_one_dev() and add_missing_dev().
> 
> Well, in add_missing_dev(), they're consistent, but in read_one_dev(),
> device->fs_devices could be a seed one, while root->fs_info->fs_devices is not.

This is another bug, I will fix it later.

Thanks
Miao

> 
> Am I missing?
> 
> -liubo
> 
>>  
>>  	next_device = list_entry(root->fs_info->fs_devices->devices.next,
>>  				 struct btrfs_device, dev_list);
>> -- 
>> 1.9.3
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> .
> 

