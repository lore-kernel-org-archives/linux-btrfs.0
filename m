Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:54778 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750805AbdGLXxt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Jul 2017 19:53:49 -0400
Subject: Re: [PATCH v4 0/6] Chunk level degradable check
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, ahferroin7@gmail.com, kilobyte@angband.pl,
        demfloro@demfloro.ru
References: <20170628054335.18806-1-quwenruo@cn.fujitsu.com>
 <20170712152419.GH2866@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <d8b28a2a-fd1c-9ac9-39d8-300399a3f7ae@gmx.com>
Date: Thu, 13 Jul 2017 07:53:33 +0800
MIME-Version: 1.0
In-Reply-To: <20170712152419.GH2866@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年07月12日 23:24, David Sterba wrote:
> On Wed, Jun 28, 2017 at 01:43:29PM +0800, Qu Wenruo wrote:
>> The patchset can be fetched from my github repo:
>> https://github.com/adam900710/linux/tree/degradable
>>
>> The patchset is based on David's for-4.13-part1 branch.
>>
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
> 
> I've seen wider testing coverage in replies to the previous patchset
> iterations. Can we have that added to fstests?

I'm completely OK to add fstests test case.
While the concern is still the same: we need better wrapper to detect 
chunk layout.

Or we can only have static test case to test chunk-level degradable check.

Thanks,
Qu

> 
> I'm going to add this patchset to the devel queue (ie. not a separate
> for-next branch anymore).
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
