Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:36253 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752112AbdF0LUK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Jun 2017 07:20:10 -0400
Received: by mail-io0-f196.google.com with SMTP id h134so2295588iof.3
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Jun 2017 04:20:10 -0700 (PDT)
Subject: Re: [PATCH v3.1 0/7] Chunk level degradable check
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Anand Jain <anand.jain@oracle.com>,
        dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20170309013442.19957-1-quwenruo@cn.fujitsu.com>
 <20170626185915.GQ2866@twin.jikos.cz>
 <adc07afe-825a-c1ff-ac5c-057052877378@cn.fujitsu.com>
 <68165838-80a9-e64b-cad3-fef9b67984d4@oracle.com>
 <0f1ddef7-7d3b-ab2d-da71-a7d6f07d2937@cn.fujitsu.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <97b844cd-7637-8df9-e05b-b0e6ff78f6c8@gmail.com>
Date: Tue, 27 Jun 2017 07:20:06 -0400
MIME-Version: 1.0
In-Reply-To: <0f1ddef7-7d3b-ab2d-da71-a7d6f07d2937@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-06-26 22:49, Qu Wenruo wrote:
> 
> 
> At 06/27/2017 09:59 AM, Anand Jain wrote:
>>
>>
>> On 06/27/2017 09:05 AM, Qu Wenruo wrote:
>>>
>>>
>>> At 06/27/2017 02:59 AM, David Sterba wrote:
>>>> On Thu, Mar 09, 2017 at 09:34:35AM +0800, Qu Wenruo wrote:
>>>>> Btrfs currently uses num_tolerated_disk_barrier_failures to do global
>>>>> check for tolerated missing device.
>>>>>
>>>>> Although the one-size-fit-all solution is quite safe, it's too strict
>>>>> if data and metadata has different duplication level.
>>>>>
>>>>> For example, if one use Single data and RAID1 metadata for 2 disks, it
>>>>> means any missing device will make the fs unable to be degraded
>>>>> mounted.
>>>>>
>>>>> But in fact, some times all single chunks may be in the existing
>>>>> device and in that case, we should allow it to be rw degraded mounted.
>>>>>
>>>>> Such case can be easily reproduced using the following script:
>>>>>   # mkfs.btrfs -f -m raid1 -d sing /dev/sdb /dev/sdc
>>>>>   # wipefs -f /dev/sdc
>>>>>   # mount /dev/sdb -o degraded,rw
>>>>>
>>>>> If using btrfs-debug-tree to check /dev/sdb, one should find that the
>>>>> data chunk is only in sdb, so in fact it should allow degraded mount.
>>>>>
>>>>> This patchset will introduce a new per-chunk degradable check for
>>>>> btrfs, allow above case to succeed, and it's quite small anyway.
>>>>>
>>>>> And enhance kernel error message for missing device, at least kernel
>>>>> can know what's making mount failed, other than meaningless
>>>>> "failed to read system chunk/chunk tree -5".
>>>>
>>>> I'd like to get this merged to 4.14. The flush bio changes are now 
>>>> done,
>>>> so the base code should be stable. I've read the previous iterations of
>>>> this patchset, the comments and user feedback. The usecase coverage
>>>> seems to be good and what users expect.
>>>
>>> Thank you for the kindly remind.
>>>
>>>>
>>>> There are some bits in the implementation that I do not like, eg.
>>>> reintroducing memory allocation failure to the barrier check, but IIRC
>>>> no fundamental problems. Please refresh the patchset on top of current
>>>> code that's going to 4.13 (equvalent to the current for-next), I'll
>>>> review that and comment. One or more iterations might be needed, but
>>>> 4.14 target is within reach.
>>>
>>> I'll check the new flush infrastructure and figure out if we can 
>>> avoid re-introducing such memory allocation failure with the new 
>>> infrastructure.
>>
>>   As this is going to address the raid1 availability issue, its better to
>>   mark this for the stable. IMO. But I wonder if there is any objection ?
> 
> Not sure if stable maintainers (even normal subsystem maintainers) will 
> like it, as it's quite a large modification, including dev flush 
> infrastructure.
> 
> But since v4.14 will be an LTS kernel, we don't need to rush too much to 
> push this feature to stable, as long as the feature is planned to reach 
> v4.14.
I would personally tend to disagree.  It fixes a pretty severe data loss 
bug that arises from what most people for some reason think is 
acceptable normal usage.  I can understand not going too far back, but I 
do think it should probably be marked for at least 4.9.

