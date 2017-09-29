Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:36322 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752518AbdI2VLN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Sep 2017 17:11:13 -0400
Received: by mail-wr0-f195.google.com with SMTP id k10so375369wrk.3
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Sep 2017 14:11:13 -0700 (PDT)
Subject: Re: Can't remove device -> I/O error
To: kreijack@inwind.it, linux-btrfs@vger.kernel.org
References: <CACJO8mcmabFc1CdhVr+Xj=NH1h2zy5eMOeD-8+UGkXODH34rVQ@mail.gmail.com>
 <3b9a14cb-a88c-4604-6d36-d2706796acfd@libero.it>
From: DocMAX <docmax1978@gmail.com>
Message-ID: <cc58b693-a7f9-5373-0fdd-542e691de936@gmail.com>
Date: Fri, 29 Sep 2017 23:09:59 +0200
MIME-Version: 1.0
In-Reply-To: <3b9a14cb-a88c-4604-6d36-d2706796acfd@libero.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the reply.

I don't want to replace the drive. I want to remove.

Also tried in degraded mode. I get the exact same error.

I'm not sure but i think i formated the drive on Kernel 4.11.

I am on Kernel 4.13 now.


I have the bad feeling that i will never get rid of that small drive 
unless i re-format.



Am 29.09.2017 um 23:04 schrieb Goffredo Baroncelli:
> On 09/29/2017 10:00 PM, Dirk Diggler wrote:
>> Hi,
>>
>> is there any chance to get my device removed?
> I simulated a device removing in KVM with
>
> 	echo 1 >/sys/block/sdj/device/delete
>
> then
>
> 	btrfs dev del 6 /mnt/....
>
>
> And I got success. But I am not sure if this is the right thing todo.
>
> You can use "btrfs replace start -r ....". But you need another device.
>
> Otherwise, you can shutdown the filesystem, removing (physically) the disk then remount with a "mount -o degraded ...." followed by a "btrfs dev del missing /..."
> Before doing so, please tell us which kernel you are using.
>
> RAID5/6 until few months ago has a lot of bugs, so if you have an old kernel it is very difficult to remove a device with success.
>

