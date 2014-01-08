Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:49778 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbaAHGYO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Jan 2014 01:24:14 -0500
Message-ID: <52CCEF3E.5010807@cn.fujitsu.com>
Date: Wed, 08 Jan 2014 14:25:02 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 00/18] Replace btrfs_workers with kernel workqueue
 based btrfs_workqueue
References: <1387272719-11889-1-git-send-email-quwenruo@cn.fujitsu.com> <52B3105A.5000102@fb.com> <52B3B4BC.70204@cn.fujitsu.com> <52B44688.5070603@fb.com> <52B7A158.8000503@cn.fujitsu.com>
In-Reply-To: <52B7A158.8000503@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 23 Dec 2013 10:35:04 +0800
, Qu Wenruo wrote:
> On fri, 20 Dec 2013 05:30:48 -0800, Josef Bacik wrote:
>>
>> On 12/19/2013 07:08 PM, Qu Wenruo wrote:
>>> I'm sorry but I failed to reproduce the problem.
>>> Btrfs/012 in xfstests has been run for serveral hours but nothing 
>>> happened.
>>>
>>> Would you please give me some more details about the environment or 
>>> the panic backtrace?
>>>
>>
>> Ok so it wasn't that test, it was just ./check -g auto. It would 
>> sometimes die at btrfs/012, other times it would make it as far as 
>> generic/083 before it keeled over. I bisected it down to
>>
>> btrfs: Replace fs_info->workers with btrfs_workqueue
>>
>> which of course is just the first patch that you start using the new 
>> code which isn't helpful. My dmesg from one of my runs is here
>>
>> http://ur1.ca/g867b
>>
>> All of the initial panics looked exactly the same. I'm just going to 
>> kick the series out for now while you track down the problem. Thanks,
>>
>> Josef
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>
> Thanks for your dmesg a lot.
>
> It's quite sad that I still failed to reproduce the same bug on all my 
> test environment during the weekend.
>
> But according to the dmesg, which is expired now though, I made the 
> following assumption:
>
> There is a possibility that out of order execution made the "work->wq 
> = wq" sentence executed behind the "queue_work()" call,
> and the "normal_work_helper" is executed in another CPU instantly, 
> which caused the problem.
>
> ------
> static inline void __btrfs_queue_work(struct __btrfs_workqueue *wq,
> struct btrfs_work *work)
> {
> unsigned long flags;
>
> work->wq = wq;
> /* There is no memory barrier ensure the work->wq = wq is executed
> before queue_work */
> thresh_queue_hook(wq);
> if (work->ordered_func) {
> spin_lock_irqsave(&wq->list_lock, flags);
> list_add_tail(&work->ordered_list, &wq->ordered_list);
> spin_unlock_irqrestore(&wq->list_lock, flags);
> }
> queue_work(wq->normal_wq, &work->normal_work);
> }
> ------
>
> The memory order problem involves compiler or even CPU hardware (AMD 
> CPUS seems to have a weaker memory order than Intel),
> so to simulate the bug, I used the following codes tried to reproduce 
> the bug, and the result is pretty much the same as your dmesg.
> ------
> static inline void __btrfs_queue_work(struct __btrfs_workqueue *wq,
> struct btrfs_work *work)
> {
> unsigned long flags;
> int in_order = get_random_int() % 1000
>
> if (in_order)
> work->wq = wq;
> thresh_queue_hook(wq);
> if (work->ordered_func) {
> spin_lock_irqsave(&wq->list_lock, flags);
> list_add_tail(&work->ordered_list, &wq->ordered_list);
> spin_unlock_irqrestore(&wq->list_lock, flags);
> }
> queue_work(wq->normal_wq, &work->normal_work);
>
> /* Try make the codes out of order since the Intel CPU
> seems obey the memory order quite well */
> if (!in_order)
> work->wq = wq;
> }
> ------
>
> The fix is as easy as just adding a smp_wmb() behind the "work->wq = 
> wq" sentence, but since I failed to reproduce the bug,
> I can't confirm whether the fix is good or not.
>
> I know it's impolite but would you please first try the smp_wmb() 
> first to confirm the fix?
>
> If the fix is good I'll send the formal V5 patchset.
>
> Thanks
>
> Qu
Happy new year!

Very sorry for disturbing but ithas been some time before my last replay
and no feedback since then (mainly because of the new year holiday).

If itis convenient for you,would you please give some feedback about the 
smp_wmb() fix ?

Also incase that smp_wmb() doesn't work, it would be very nice of you to
also try smp_mb() fix.

Thanks
Qu
