Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-33-i6.italiaonline.it ([213.209.14.33]:35794 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752107AbdKTT2W (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Nov 2017 14:28:22 -0500
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH v2] btrfs: handle dynamically reappearing missing device
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, Liu Bo <bo.li.liu@oracle.com>
References: <20171112105650.3248-1-anand.jain@oracle.com>
 <20171117123614.11822-1-anand.jain@oracle.com>
 <2e6fd096-43c6-c6c7-90ae-ac4672ac5797@libero.it>
 <c721f8b5-aedb-6f28-5db9-6b48ac0c1014@oracle.com>
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <73ef4477-0497-fe24-ae17-5c4c08992c9c@libero.it>
Date: Mon, 20 Nov 2017 20:28:19 +0100
MIME-Version: 1.0
In-Reply-To: <c721f8b5-aedb-6f28-5db9-6b48ac0c1014@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/20/2017 09:19 AM, Anand Jain wrote:
> 
> 
> On 11/18/2017 09:52 PM, Goffredo Baroncelli wrote:
>> On 11/17/2017 01:36 PM, Anand Jain wrote:
>>> If the device is not present at the time of (-o degrade) mount,
>>> the mount context will create a dummy missing struct btrfs_device.
>>> Later this device may reappear after the FS is mounted and
>>> then device is included in the device list but it missed the
>>> open_device part. So this patch handles that case by going
>>> through the open_device steps which this device missed and finally
>>> adds to the device alloc list.
>>
>> What happens if the first devices got writes before the "last device" is joined ?
>>
>> Supposing to have a raid1 pair of devices: sda, sdb
>>
>> - sda is dissappeared (usb detached ?)
>> - the filesystem is mounted as
>>     mount -o degraded /dev/sdb
>> - some writes happens on /dev/sdb
>> - the user reattach /dev/sda
>> - udev run "btrfs dev scan"
>> - the system joins /dev/sda to the filesystem disks pool
>>
>> Because the filesystem is a raid1, btrfs may read from /dev/sdb (updated data) or /dev/sda (old data), or worse read something from the former and something from the later (metadata from sda and data from sdb ) ???
> 
>  Thanks for the test scenario, this case is fine as its read from
>  the disk having highest generation number, so we pick sdb in the
>  case above.

Ok, so in this case which is the benefit to add a disk ? With a lover number generation, the added will be used at all ?
In this case, would be better an explicit user intervention instead of an automatic one ?


> 
> Thanks, Anand
> 
> 
>> Am I missing something ?
>>
>> BR
>> G.Baroncelli
>>
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
