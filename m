Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42600 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751198AbdKTVNo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Nov 2017 16:13:44 -0500
Subject: Re: [PATCH v2] btrfs: handle dynamically reappearing missing device
To: kreijack@inwind.it
Cc: linux-btrfs@vger.kernel.org, Liu Bo <bo.li.liu@oracle.com>
References: <20171112105650.3248-1-anand.jain@oracle.com>
 <20171117123614.11822-1-anand.jain@oracle.com>
 <2e6fd096-43c6-c6c7-90ae-ac4672ac5797@libero.it>
 <c721f8b5-aedb-6f28-5db9-6b48ac0c1014@oracle.com>
 <73ef4477-0497-fe24-ae17-5c4c08992c9c@libero.it>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <decb328d-c1a0-29ee-fd25-702cfdb2f477@oracle.com>
Date: Tue, 21 Nov 2017 05:14:00 +0800
MIME-Version: 1.0
In-Reply-To: <73ef4477-0497-fe24-ae17-5c4c08992c9c@libero.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11/21/2017 03:28 AM, Goffredo Baroncelli wrote:
> On 11/20/2017 09:19 AM, Anand Jain wrote:
>>
>>
>> On 11/18/2017 09:52 PM, Goffredo Baroncelli wrote:
>>> On 11/17/2017 01:36 PM, Anand Jain wrote:
>>>> If the device is not present at the time of (-o degrade) mount,
>>>> the mount context will create a dummy missing struct btrfs_device.
>>>> Later this device may reappear after the FS is mounted and
>>>> then device is included in the device list but it missed the
>>>> open_device part. So this patch handles that case by going
>>>> through the open_device steps which this device missed and finally
>>>> adds to the device alloc list.
>>>
>>> What happens if the first devices got writes before the "last device" is joined ?
>>>
>>> Supposing to have a raid1 pair of devices: sda, sdb
>>>
>>> - sda is dissappeared (usb detached ?)
>>> - the filesystem is mounted as
>>>      mount -o degraded /dev/sdb
>>> - some writes happens on /dev/sdb
>>> - the user reattach /dev/sda
>>> - udev run "btrfs dev scan"
>>> - the system joins /dev/sda to the filesystem disks pool
>>>
>>> Because the filesystem is a raid1, btrfs may read from /dev/sdb (updated data) or /dev/sda (old data), or worse read something from the former and something from the later (metadata from sda and data from sdb ) ???
>>
>>   Thanks for the test scenario, this case is fine as its read from
>>   the disk having highest generation number, so we pick sdb in the
>>   case above.
> 
> Ok, so in this case which is the benefit to add a disk ?
> With a lover number generation, the added will be used at all ?

  It will be used for new writes, it will stripe across both the disks.
  Balance is only for the older single chunks, which in the long term
  would go away when we are able to create a degraded raid1 chunks.

> In this case, would be better an explicit user intervention instead of an automatic one ?

   Without this patch the disk already joins the raid group.

   But it had a bug that it missed joining the alloc group.

Thanks, Anand
> 
>>
>> Thanks, Anand
>>
>>
>>> Am I missing something ?
>>>
>>> BR
>>> G.Baroncelli
>>>
>>
> 
> 
