Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:55532 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753633AbdLOIE2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Dec 2017 03:04:28 -0500
Subject: Re: [PATCH] btrfs: fix inconsistency during missing device rejoin
From: Anand Jain <anand.jain@oracle.com>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <20171204071939.22878-1-anand.jain@oracle.com>
 <730b01da-a293-1309-e22c-ebfe996c0628@jp.fujitsu.com>
 <3aeb59b8-3ccf-6657-fcf4-167e9c977230@oracle.com>
Message-ID: <6bd7662e-a056-45c2-8270-312375328ab8@oracle.com>
Date: Fri, 15 Dec 2017 16:03:23 +0800
MIME-Version: 1.0
In-Reply-To: <3aeb59b8-3ccf-6657-fcf4-167e9c977230@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>





>>> @@ -715,7 +715,8 @@ static noinline int device_list_add(const char 
>>> *path,
>>>           ret = 1;
>>>           device->fs_devices = fs_devices;
>>> -    } else if (!device->name || strcmp(device->name->str, path)) {
>>> +    } else if (!device->name || strcmp(device->name->str, path) ||
>>> +            test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state)) {
>>>           /*
>>>            * When FS is already mounted.
>>>            * 1. If you are here and if the device->name is NULL that
>>>
>>
>> I read the comments below this and wonder if BTRFS_DEV_STATE_MISSING 
>> is set
>> when device->name is null and therefore the first condition can be 
>> removed.

  On the 2nd thought, actually can not remove device->name, there can
  be a case where degraded FS is unmounted, then device->name is NULL.

Thanks, Anand

>   device->name is null only when missing is set.
> 
>   Will do this optimize in a new patch, as its about clean up and
>   is not about fixing inconsistency as in here.
> 
> Thanks, Anand
