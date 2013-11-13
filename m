Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:33861 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753435Ab3KMAxI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Nov 2013 19:53:08 -0500
Message-ID: <5282CDA5.2060303@cn.fujitsu.com>
Date: Wed, 13 Nov 2013 08:53:57 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 03/17] btrfs: Add high priority workqueue support for
 btrfs_workqueue_struct
References: <1383803527-23736-1-git-send-email-quwenruo@cn.fujitsu.com> <1383803527-23736-4-git-send-email-quwenruo@cn.fujitsu.com> <20131107164134.GJ16662@twin.jikos.cz> <527C35EC.8000307@cn.fujitsu.com> <20131112165923.GE9132@twin.jikos.cz>
In-Reply-To: <20131112165923.GE9132@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 12 Nov 2013 17:59:23 +0100, David Sterba wrote:
> On Fri, Nov 08, 2013 at 08:53:00AM +0800, Qu Wenruo wrote:
>> On Thu, 7 Nov 2013 17:41:34 +0100, David Sterba wrote:
>>> On Thu, Nov 07, 2013 at 01:51:53PM +0800, Qu Wenruo wrote:
>>>> @@ -753,6 +754,19 @@ struct btrfs_workqueue_struct *btrfs_alloc_workqueue(char *name,
>>>>   		}
>>>>   	}
>>>> +	if (high_name) {
>>>> +		ret->high_wq = alloc_workqueue(high_name,
>>>> +					       flags | WQ_HIGHPRI,
>>>> +					       max_active);
>>> I'd really like to add the btrfs- prefix of the workqueue. Quoting our
>>> previous discussion:
>> Sorry, I forgot to add the "btrfs-" prefix.
>> But on the other hand, I prefer to add the prefix outside the
>> alloc_btrfs_workqueue,
>> which means change the strings passed to alloc_btrfs_workqueue.
>> (Maybe add a small macro?)
>>
>> Which way do you prefer?
> It's actually quite simple, alloc_workque takes a printk format string,
> so:
>
> 	alloc_workqueue("%s-%s", flags, max_active, "btrfs", name);
Oh, I forgot the printk format way.
Good idea.
>
> but I consider the following to be harder to get around.
>
>>>>> * the thread names lost the btrfs- prefix, this makes it hard to
>>>>>     identify the processes and we want this, either debugging or
>>>>>     performance monitoring
>>>> Yes, that's right.
>>>> But the problem is, even I added "btrfs-" prefix to the wq,
>>>> the real work executor is kernel workers without any prefix.
>>>> Still hard to debugging due to the workqueue mechanism.
>>> AFAICS the string passed down to alloc_workqueue ends up in the process
>>> name, this is what I'm expecing and don't understand what do you mean.
>>>
>> Sorry for the misunderstanding words.
>> What I mean is that, since we use the kernel workqueue,
>> there will be no kthread named the "btrfs-worker" or something like it.
>> (Only when WQ_MEM_RECLAIM is set, the rescuer kthread will have the name,
>> See kernel/workqueue.c if(flags & WQ_MEM_RECLAIM) para).
> Qu
> You're right, I was not aware of that, and actually checked the
> workqueus that have the MEM_RECLAIM bit set. Most of the btrfs IO
> workers will have to have this bit set, there are some of them that do
> not need it (scrub or readahead).
>
>> The real executor will be something like kworker/u8:6(Unbound workqueue),
>> so even the prefix is added, it's still harder than the original way to
>> debug workqueue.
> Right, the question is if we really need it that way. We can set the
> MEM_RECLAIM bit but it looks like an abuse of the interface.
Also forgot to mention is that, even the MEM_RECLAIM bit is set,
the kthread is just a rescuer thread used for the following situiation:
One kthread uses huge memory so other works can't get memory for a
new kthread, but some works is going to free the memory.
So there will be a deadlock(memory is the resource that being raced).

MEM_RECLAIM bit is used to solve this deadlock by pre-allocating a rescuer
kthread, even no memory can be allocated, the works need to reclaim memory
can directly use the pre-allocated kthread to reclaim memory.

So even the MEM_RECLAIM bit is set, the real executor is still kworker...
And it's true that we are abusing the MEM_RECLAIM bit, but this abusing
is somewhat the same behavior of the original btrfs workers since
it also have at least one kthread even idle.
(But it is easy to distinguish original btrfs workqueue
from new btrfs workqueue and does not waste too much memory :)
>
>> What makes it worse is that, to simulate the thresholding and ordering,
>> I added serveral helper functions, which even makes kernel tracing not so
>> meaningful(all function queued to workqueue will all be normal_helper or
>> ordered_helper).
> That's a valid concern. Can we extend the tracepoints to keep the
> btrfs-worker name?
Not familiar about the kernel tracing mechanism, but I'll try it
in later patches other than this patchset.
(Also after some searching, it seems that btrfs does not have any
tracepoints?!)
>
> So, as a first step, we can add MEM_RECLAIM to all threads, this should
> do the conversion close to the current state. Next we can start tuning the
> workqueue flags. This is an internal change, should be safe to do later.
Yes, when fixing the comment style, I also changed the behavior of
btrfs_alloc_workqueue function that not set the WQ_UNBOUND bit to
allow further flags tunning.
(I think some workqueue may benifit more from locality than distributing
to other CPUs)

Thanks.

Qu
>
>
> david
>


-- 
-----------------------------------------------------
Qu Wenruo
Development Dept.I
Nanjing Fujitsu Nanda Software Tech. Co., Ltd.(FNST)
No. 6 Wenzhu Road, Nanjing, 210012, China
TEL: +86+25-86630566-8526
COINS: 7998-8526
FAX: +86+25-83317685
MAIL: quwenruo@cn.fujitsu.com
-----------------------------------------------------

