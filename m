Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:62504 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757263AbbLAXoE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Dec 2015 18:44:04 -0500
Subject: Re: [RFC] Btrfs device and pool management (wip)
To: kreijack@inwind.it, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org, Qu Wenruo <quwenruo@cn.fujitsu.com>
References: <565C01F1.5030108@oracle.com> <565C448A.7050601@gmx.com>
 <565DE06B.8060608@inwind.it>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <565E30B0.9050303@gmx.com>
Date: Wed, 2 Dec 2015 07:43:44 +0800
MIME-Version: 1.0
In-Reply-To: <565DE06B.8060608@inwind.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12/02/2015 02:01 AM, Goffredo Baroncelli wrote:
> On 2015-11-30 13:43, Qu Wenruo wrote:
>>
>>
>> On 11/30/2015 03:59 PM, Anand Jain wrote:
>>> (fixed alignment)
>>>
>>>
> [...]
>>
>> I'm overall OK with your *current* hot-spare implement.
>> It's quite small and straightforward.
>> Just hope some more more easy-to-implement features, like hot-remove instead of replace. (for degradable case, it would case less IO).
>> And more test-cases.
>>
>> And per-filesystem hot-spare device. Global one has its limitation, like no priority or choose less proper device.
>> (use a TB device to replace a GB device, eating up the pool quite easily)
>> It should be not hard to do, maybe add fsid into hot-spare device superblock and modify kernel/user-progs a little.
>>
>>
>>
>> But if your ultimate goal of *in-kernel* hot-spare is to do such complicated *in-kernel police*, I would say *NO* right now before things get messed up.
>> (Yeah, maybe another "discussion" just like feature auto-align)
>>
>> Kernel should provide *mechanisim*, not *policy*.
>> (Pretty sure most of us should hear it in one form or another).
>>
>> In this case, btrfs supports for *replace* is a mechanism. (not automatically replace)
>> But *when* to replace a bad device, is *policy*.
>>
>>
>> But if you just want to get to that goal, *not restricted to in-kernel implement*, it would be much easier to do.
>
> +1
>
>>
>> 1) Implement a API(maybe sysfs as you suggested) to allow user-space programs get informed when a btrfs device get sick(including missing or number of IO errors hit a threshold)
>
> This API should be device related and not specific to btrfs: what if the error happens in one partition not used by btrfs, but the disk has another partition used by btrfs ?

My idea is btrfs only reports its own result, like how many crc 
read/write errors.

And block layer provides its own listen interface, reporting errors like 
ATA error.

These two interface has their own goal.
Btrfs one can detect bit error but block layer one can detect more like 
power loss or offline.

As it's quite hard to detect all type of low level errors at btrfs level.

>
>>
>> 2) Write a user-space program listening with that API
>>
>> 3) Trigger a action when device get failed.
>>     Maybe replace, maybe remove, or just do nothing, fully *tunable* and
>>     much *easier* to implement.
>>
>> If use above method, kernel part should be as easy as the following:
>> 1) A new API for user-progs to listen
>>
>> 2) (Optional) Tuning interface for that API
>>     E.g, threshold of IO error before informing user space
>>
>> 3) Kernel fallback behavior for such error
>>     Even no need to trigger replace from kernel, but just put the
>>     filesystem into degraded will be good enough.
>>
>> 3) A user daemon, maybe in btrfs-progs or another project.
>>     Easy to debug, easy to implement, and you will be the
>>     maintainer/leader/author of the new project!!
>>
>> Now all the policy is moved to user-space, kernel is kept small and clean.
>
> This is the most important thing: we should work to stabilize the current kernel implementation before adding further functionality. BTRFS is 8 year old, but it still needs some work to stabilize. I don't think that we should put further code in kernel space if we could add it in user space.
>

Yeah, completely right.

Thanks,
Qu

>
>
