Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51375 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbcEAXFN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 May 2016 19:05:13 -0400
Subject: Re: [PATCH] btrfs: cleanup assigning next active device with a check
To: dsterba@suse.cz
References: <1460978752-27375-1-git-send-email-anand.jain@oracle.com>
 <20160425151514.GC29353@twin.jikos.cz>
Cc: linux-btrfs@vger.kernel.org, yauhen.kharuzhy@zavadatar.com
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <57268BA3.3040701@oracle.com>
Date: Mon, 2 May 2016 07:05:07 +0800
MIME-Version: 1.0
In-Reply-To: <20160425151514.GC29353@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/25/2016 11:15 PM, David Sterba wrote:
> On Mon, Apr 18, 2016 at 07:25:52PM +0800, Anand Jain wrote:
>> Creates helper fucntion as needed by the device delete
>> and replace operations. Also now it checks if the next
>> device being assigned is an active device.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -1684,10 +1684,40 @@ out:
>>   	return ret;
>>   }
>>
>> +struct btrfs_device *btrfs_find_next_active_device(struct btrfs_fs_devices *fs_devs,
>> +					struct btrfs_device *device)
>
>> +
>> +void btrfs_assign_next_active_device(struct btrfs_fs_info *fs_info,
>> +		struct btrfs_device *device, struct btrfs_device *this_dev)
>
> Please add comments what the functions do so that one does not need to
> read the whole function to figure it out.

Right. Added comments. and BUG_ON(). Thanks,
Anand

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
