Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:28440 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932779AbcJNNUD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Oct 2016 09:20:03 -0400
Subject: Re: btrfs and numa - needing drop_caches to keep speed up
To: Julian Taylor <jtaylor.debian@googlemail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <818cbe6c-fe7a-7542-3bc8-76b205c9b80b@profihost.ag>
 <a358938d-aef4-f2c7-942b-6cee3d1d774e@googlemail.com>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Message-ID: <7b334ad0-0842-73ee-bc3e-adc6be41c839@profihost.ag>
Date: Fri, 14 Oct 2016 15:19:58 +0200
MIME-Version: 1.0
In-Reply-To: <a358938d-aef4-f2c7-942b-6cee3d1d774e@googlemail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear julian,

Am 14.10.2016 um 14:26 schrieb Julian Taylor:
> On 10/14/2016 08:28 AM, Stefan Priebe - Profihost AG wrote:
>> Hello list,
>>
>> while running the same workload on two machines (single xeon and a dual
>> xeon) both with 64GB RAM.
>>
>> I need to run echo 3 >/proc/sys/vm/drop_caches every 15-30 minutes to
>> keep the speed as good as on the non numa system. I'm not sure whether
>> this is related to numa.
>>
>> Is there any sysctl parameter to tune?
>>
>> Tested with vanilla v4.8.1
>>
>> Greets,
>> Stefan
> 
> hi,
> why do you think this is related to btrfs?

was just an idea as i couldn't find any other difference between those
systems.

> This is easy to diagnose but recording some kernel stacks during the >
problem with perf.

you just mean perf top? Does it also show locking problems? As i see not
much CPU usage in that case.

> The only known issue that has this type of workaround that I know of are
> transparent huge pages.

I already disabled thp by:
echo never > /sys/kernel/mm/transparent_hugepage/enabled

cat /proc/meminfo says:
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0



Greets,
Stefan

> 
> cheers,
> Julian
