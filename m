Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:19078 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751445AbdF0BFt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Jun 2017 21:05:49 -0400
Subject: Re: [PATCH v3.1 0/7] Chunk level degradable check
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>, <anand.jain@oracle.com>
References: <20170309013442.19957-1-quwenruo@cn.fujitsu.com>
 <20170626185915.GQ2866@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <adc07afe-825a-c1ff-ac5c-057052877378@cn.fujitsu.com>
Date: Tue, 27 Jun 2017 09:05:46 +0800
MIME-Version: 1.0
In-Reply-To: <20170626185915.GQ2866@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 06/27/2017 02:59 AM, David Sterba wrote:
> On Thu, Mar 09, 2017 at 09:34:35AM +0800, Qu Wenruo wrote:
>> Btrfs currently uses num_tolerated_disk_barrier_failures to do global
>> check for tolerated missing device.
>>
>> Although the one-size-fit-all solution is quite safe, it's too strict
>> if data and metadata has different duplication level.
>>
>> For example, if one use Single data and RAID1 metadata for 2 disks, it
>> means any missing device will make the fs unable to be degraded
>> mounted.
>>
>> But in fact, some times all single chunks may be in the existing
>> device and in that case, we should allow it to be rw degraded mounted.
>>
>> Such case can be easily reproduced using the following script:
>>   # mkfs.btrfs -f -m raid1 -d sing /dev/sdb /dev/sdc
>>   # wipefs -f /dev/sdc
>>   # mount /dev/sdb -o degraded,rw
>>
>> If using btrfs-debug-tree to check /dev/sdb, one should find that the
>> data chunk is only in sdb, so in fact it should allow degraded mount.
>>
>> This patchset will introduce a new per-chunk degradable check for
>> btrfs, allow above case to succeed, and it's quite small anyway.
>>
>> And enhance kernel error message for missing device, at least kernel
>> can know what's making mount failed, other than meaningless
>> "failed to read system chunk/chunk tree -5".
> 
> I'd like to get this merged to 4.14. The flush bio changes are now done,
> so the base code should be stable. I've read the previous iterations of
> this patchset, the comments and user feedback. The usecase coverage
> seems to be good and what users expect.

Thank you for the kindly remind.

> 
> There are some bits in the implementation that I do not like, eg.
> reintroducing memory allocation failure to the barrier check, but IIRC
> no fundamental problems. Please refresh the patchset on top of current
> code that's going to 4.13 (equvalent to the current for-next), I'll
> review that and comment. One or more iterations might be needed, but
> 4.14 target is within reach.

I'll check the new flush infrastructure and figure out if we can avoid 
re-introducing such memory allocation failure with the new infrastructure.

Thanks,
Qu


