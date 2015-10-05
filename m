Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18098 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbbJEIva (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Oct 2015 04:51:30 -0400
Message-ID: <561239BE.4050706@oracle.com>
Date: Mon, 05 Oct 2015 16:50:06 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: [PATCH 16/23] Btrfs: device path change must be logged
References: <1439548388-29686-1-git-send-email-anand.jain@oracle.com> <1439548388-29686-17-git-send-email-anand.jain@oracle.com> <20151001134043.GD5885@twin.jikos.cz> <560D3964.7000205@oracle.com>
In-Reply-To: <560D3964.7000205@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi David,

  Kindly note. This is accepted and sent out as part of the patch
  which are dependinding together.

Thanks, Anand

On 10/01/2015 09:47 PM, Anand Jain wrote:
>
>
> On 10/01/2015 09:40 PM, David Sterba wrote:
>> On Fri, Aug 14, 2015 at 06:33:01PM +0800, Anand Jain wrote:
>>> >From the issue diagnosable point of view, log if the device path is
>>> changed.
>>>
>>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>> ---
>>>   fs/btrfs/volumes.c | 4 ++++
>>>   1 file changed, 4 insertions(+)
>>>
>>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>>> index ebf37a9..dcb10fa 100644
>>> --- a/fs/btrfs/volumes.c
>>> +++ b/fs/btrfs/volumes.c
>>> @@ -595,6 +595,10 @@ static noinline int device_list_add(const char
>>> *path,
>>
>>>               return -EEXIST;
>>>           }
>>>
>>> +        printk_in_rcu(KERN_INFO \
>>> +            "BTRFS: device fsid %pU devid %llu old path %s new path
>>> %s\n",
>>> +            disk_super->fsid, devid, rcu_str_deref(device->name),
>>> path);
>>
>> I don't think that the message should be put into device_list_add. Its
>> only callsite in btrfs_scan_one_device prints some device info messages
>> so it would be better to extend and use the return value if possible.
>
>
>   Right. will fix it.
>
> Thanks, Anand
>
>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
