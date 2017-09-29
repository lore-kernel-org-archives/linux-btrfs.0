Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16-i6.italiaonline.it ([213.209.14.16]:56760 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752155AbdI2VtC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Sep 2017 17:49:02 -0400
Reply-To: kreijack@inwind.it
Subject: Re: Can't remove device -> I/O error
To: DocMAX <docmax1978@gmail.com>, linux-btrfs@vger.kernel.org
References: <CACJO8mcmabFc1CdhVr+Xj=NH1h2zy5eMOeD-8+UGkXODH34rVQ@mail.gmail.com>
 <3b9a14cb-a88c-4604-6d36-d2706796acfd@libero.it>
 <cc58b693-a7f9-5373-0fdd-542e691de936@gmail.com>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <1a111a09-b421-baf7-800b-f24dcdc84a82@inwind.it>
Date: Fri, 29 Sep 2017 23:48:59 +0200
MIME-Version: 1.0
In-Reply-To: <cc58b693-a7f9-5373-0fdd-542e691de936@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/29/2017 11:09 PM, DocMAX wrote:
> Thanks for the reply.
> 
> I don't want to replace the drive. I want to remove.
> 
> Also tried in degraded mode. I get the exact same error.

Did you removed the disk before mounting (physically or doing echo 1 >/sys/block/xxx/device/delete)? Which steps you performed ?

> 
> I'm not sure but i think i formated the drive on Kernel 4.11.

This shouldn't matter
> 
> I am on Kernel 4.13 now.

Ok, it is quite recently
> 
> 
> I have the bad feeling that i will never get rid of that small drive unless i re-format.

No, it should not be necessary.

> 
> 
> 
> Am 29.09.2017 um 23:04 schrieb Goffredo Baroncelli:
>> On 09/29/2017 10:00 PM, Dirk Diggler wrote:
>>> Hi,
>>>
>>> is there any chance to get my device removed?
>> I simulated a device removing in KVM with
>>
>>     echo 1 >/sys/block/sdj/device/delete
>>
>> then
>>
>>     btrfs dev del 6 /mnt/....
>>
>>
>> And I got success. But I am not sure if this is the right thing todo.
>>
>> You can use "btrfs replace start -r ....". But you need another device.
>>
>> Otherwise, you can shutdown the filesystem, removing (physically) the disk then remount with a "mount -o degraded ...." followed by a "btrfs dev del missing /..."
>> Before doing so, please tell us which kernel you are using.
>>
>> RAID5/6 until few months ago has a lot of bugs, so if you have an old kernel it is very difficult to remove a device with success.
>>
> 
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
