Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:65233 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751812AbdJTJgg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Oct 2017 05:36:36 -0400
Subject: Re: reproducable oops in btrfs/130 with latests mainline
To: Po-Hsu Lin <po-hsu.lin@canonical.com>, Jeff Mahoney <jeffm@suse.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20161125080723.GA12776@infradead.org>
 <20171017111151.4316-1-po-hsu.lin@canonical.com>
 <4bd6e028-a4bf-6749-2894-e5f9a0e0f629@suse.com>
 <86b47125-32e7-d8b5-fe42-0225b8c1d42a@suse.com>
 <CAMy_GT_fRoHtZtWZiH_nh9++tb+woXDi09K+Zn6PLp-aFmhRLA@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <caa184aa-73ee-fd3a-2ac6-61de414567d4@gmx.com>
Date: Fri, 20 Oct 2017 17:36:25 +0800
MIME-Version: 1.0
In-Reply-To: <CAMy_GT_fRoHtZtWZiH_nh9++tb+woXDi09K+Zn6PLp-aFmhRLA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年10月20日 17:25, Po-Hsu Lin wrote:
> Thanks for the info.
> 
> I have checked the comment inside the test case, which state that:
> # And unfortunately, btrfs send is one of these operations, and will cause
> # softlock or OOM on systems with small memory(<4G).
> 
> To my experience, this will stuck on a system with 32G memory too.

Sorry for the confusion, I mean softlock if you have enough memory.
And if you don't have enough memory, you will get an OOM.

> 
> And in the end of the script, it says:
> # send out the subvolume, and it will either:
> # 1) OOM since memory is allocated inside a O(n^3) loop
> # 2) Softlock since time consuming backref walk is called without scheduling.
> 
> I can see the soft lockup behaviour (I guess this is the second result
> listed above?) from dmesg as described in
> https://bugs.launchpad.net/bugs/1718925
> 
> So I'm curious that does anyone know how long it might take if this test works?

Just skip it, or make it dangerous.
(Which I should do it in the very beginning)

Thanks,
Qu

> Tried 8 hours as a timeout limit but no luck. Or maybe this test is
> totally broken?
> 
> Thanks!
> 
> On Tue, Oct 17, 2017 at 9:03 PM, Jeff Mahoney <jeffm@suse.com> wrote:
>> On 10/17/17 8:46 AM, Qu Wenruo wrote:
>>>
>>>
>>> On 2017年10月17日 19:11, Po-Hsu Lin wrote:
>>>> Hello Chris,
>>>>
>>>> I can reproduce this on my side too, with Ubuntu 16.04 + 4.4.0-97 kernel.
>>>
>>> Btrfs/130 is a known bug.
>>>
>>> I submitted it to raise the concern about such situation and purposed
>>> one possible solution (just disable deduped file detection).
>>>
>>> But the solution doesn't get accepted.
>>
>> It also works very well as a performance test for qgroup runtime
>> improvements. :)
>>
>> -Jeff
>>
>>> Thanks,
>>> Qu
>>>>
>>>> PREEMPT config:
>>>> $ cat config-4.4.0-97-generic | grep PREEMPT
>>>> CONFIG_PREEMPT_NOTIFIERS=y
>>>> # CONFIG_PREEMPT_NONE is not set
>>>> CONFIG_PREEMPT_VOLUNTARY=y
>>>> # CONFIG_PREEMPT is not set
>>>>
>>>> Bug reports on launchpad:
>>>> https://bugs.launchpad.net/bugs/1718925
>>>> https://bugs.launchpad.net/bugs/1717443
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>
>>
>>
>> --
>> Jeff Mahoney
>> SUSE Labs
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
