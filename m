Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gitanes.rtfm.co.hu ([80.249.171.82]:59641 "EHLO
	gitanes.rtfm.co.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755764Ab3FCL4O (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Jun 2013 07:56:14 -0400
Message-ID: <51AC845A.6000600@martos.bme.hu>
Date: Mon, 03 Jun 2013 13:56:10 +0200
From: Papp Tamas <tompos@martos.bme.hu>
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: Josef Bacik <jbacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: oops at mount
References: <51A73532.6060900@martos.bme.hu> <20130530123235.GA9829@localhost.localdomain> <51A74C5E.4030201@giantdisaster.de>
In-Reply-To: <51A74C5E.4030201@giantdisaster.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/30/2013 02:55 PM, Stefan Behrens wrote:
>
> On Thu, 30 May 2013 08:32:35 -0400, Josef Bacik wrote:
>> On Thu, May 30, 2013 at 05:17:06AM -0600, Papp Tamas wrote:
>>> hi All,
>>>
>>> I'm new on the list.
>>>
>>> System:
>>> Distributor ID:	Ubuntu
>>> Description:	Ubuntu 13.04
>>> Release:	13.04
>>> Codename:	raring
>>>
>>> Linux ctu 3.8.0-19-generic #30-Ubuntu SMP Wed May 1 16:35:23 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
>>>
>>> The symptom is the same with Saucy 3.9 kernel.
>>
>> Can you try btrfs-next
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git
>>
>> if it's still not fixed please file a bug at bugzilla.kernel.org and make sure
>> the component is set to btrfs.  Thanks,
>
> Papp is using an Intel X18-M/X25-M/X25-V G2 SSD. At least with an Intel
> X25 SSD that identifies itself with "INTEL SSDSA2M080" and on one with
> the ID "INTEL SSDSA2M040", I've tested whether they honor the flush
> request. And these two SSDs don't do so, they ignore it. If you cut the
> power after a flush request completes, the data that was written before
> the flush request is gone, the write cache was _not_ flushed.
>
> You can only disable the write cache during/after every boot "hdparm -W
> 0 /dev/sd..." (which reduces the SSDs write speed to about 4 MB/s), or
> avoid such SSDs, or prepare to restore from backup occasionally.

Basically it means it's not safe to use this SSD?
I used it for 2 years with ext4 without any issue, before I switched to btrfs (on the root 
partition). In the meantime btrfs also was quite stable on my /data partition.

After I reinstalled thr system with btrfs, this issue happened two times.
But anyway, I thought cow should be able to handle these kind of issues by design. Am I wrong?


Thanks,
tamas

