Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:64168 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756244AbcLUIpW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Dec 2016 03:45:22 -0500
Subject: Re: [PATCH 1/2] btrfs: drop trace_btrfs_all_work_done() from
 normal_work_helper()
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
References: <20161214140530.6534-1-bigeasy@linutronix.de>
 <20161220172613.GQ3620@twin.jikos.cz>
 <f6229501-59de-3b53-db19-7b29a53c3342@cn.fujitsu.com>
 <20161221082837.76yw5brgr7wovx6y@linutronix.de>
CC: <dsterba@suse.cz>, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, <linux-btrfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <8e0e7bfd-8066-eb73-5180-376a182d7e60@cn.fujitsu.com>
Date: Wed, 21 Dec 2016 16:45:06 +0800
MIME-Version: 1.0
In-Reply-To: <20161221082837.76yw5brgr7wovx6y@linutronix.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 12/21/2016 04:28 PM, Sebastian Andrzej Siewior wrote:
> On 2016-12-21 08:33:03 [+0800], Qu Wenruo wrote:
>> The trace point only uses the pointer, and this helps us to pair with
>> btrfs_work_queued/sched.
>
> | /* For situiations that the work is freed */
> | DECLARE_EVENT_CLASS(btrfs__work__done,
> |
> |         TP_PROTO(struct btrfs_work *work),
> |
> |         TP_ARGS(work),
> |
> |         TP_STRUCT__entry_btrfs(
> |                 __field(        void *, work                    )
> |         ),
> |
> |         TP_fast_assign_btrfs(btrfs_work_owner(work),
> |                 __entry->work           = work;
> |         ),
> |
> |         TP_printk_btrfs("work->%p", __entry->work)
> | );
>
> and btrfs_work_owner exapnds to:
>
> | struct btrfs_fs_info *
> | btrfs_work_owner(struct btrfs_work *work)
> | {
> |         return work->wq->fs_info;
> | }
>
> voilà

Oh I got it, thanks very much.

The btrfs_work_owner() is newly introduced, no wonder I didn't know that.


I think we can fix it by extracting fs_info pointer before running the 
work, and using the extracted one in the trace point.

Thanks,
Qu


>
>> But I still don't understand why backtrace is triggered.
>> Since we're just recording a pointer, not touching it.
>>
>> Would you please explain the problem with more details on how it trigger the
>> problem?
>
> enabled all events played with the fs which was just an upgrade and git
> tree sync + checkout so nothing special.
>
>>>
>>> So I think we should either remove the tracepoint completely or change
>>> the arguments to take something else than a potentially freed 'work'.
>>
>> I'm mostly OK to remove the tracepoint, but such all_workd_done() trace
>> should still help to determine if it's a workqueue stalled.
>>
>> Thanks,
>> Qu
>
> Sebastian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


