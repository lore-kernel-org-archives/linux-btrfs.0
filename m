Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:47191 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751398AbcAVAcL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jan 2016 19:32:11 -0500
Subject: Re: use-after-free in perf_trace_btrfs__work
To: Chris Mason <clm@fb.com>, Dave Jones <davej@codemonkey.org.uk>,
        <linux-btrfs@vger.kernel.org>, <jbacik@fb.com>, <dsterba@suse.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
References: <20160115030731.GA24109@codemonkey.org.uk>
 <20160121170615.ttsumvs6esf6t332@floor.thefacebook.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56A17878.50207@cn.fujitsu.com>
Date: Fri, 22 Jan 2016 08:31:52 +0800
MIME-Version: 1.0
In-Reply-To: <20160121170615.ttsumvs6esf6t332@floor.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Chris Mason wrote on 2016/01/21 12:06 -0500:
> On Thu, Jan 14, 2016 at 10:07:31PM -0500, Dave Jones wrote:
>> I just hit a bunch of instances of this spew..
>> This is on Linus' tree from a few hours ago
>>
>> ==================================================================
>> BUG: KASAN: use-after-free in perf_trace_btrfs__work+0x1b1/0x2a0 [btrfs] at addr ffff8800b7ea2e60
>> Read of size 8 by task trinity-c14/6745
>> =============================================================================
>> BUG kmalloc-256 (Not tainted): kasan: bad access detected
>> -----------------------------------------------------------------------------
>>
>> Disabling lock debugging due to kernel taint
>> INFO: Allocated in btrfs_wq_submit_bio+0xd1/0x300 [btrfs] age=63 cpu=1 pid=6745
>> 	___slab_alloc.constprop.70+0x4de/0x580
>> 	__slab_alloc.isra.67.constprop.69+0x48/0x80
>> 	kmem_cache_alloc_trace+0x24c/0x2e0
>> 	btrfs_wq_submit_bio+0xd1/0x300 [btrfs]
>> 	btrfs_submit_bio_hook+0x118/0x260 [btrfs]
>> 	neigh_sysctl_register+0x201/0x360
>> 	devinet_sysctl_register+0x73/0xe0
>> 	inetdev_init+0x119/0x1f0
>> 	inetdev_event+0x5b3/0x7e0
>> 	notifier_call_chain+0x4e/0xd0
>> 	raw_notifier_call_chain+0x16/0x20
>> 	call_netdevice_notifiers_info+0x3d/0x70
>> 	register_netdevice+0x62d/0x730
>> 	register_netdev+0x1a/0x30
>> 	loopback_net_init+0x5d/0xd0
>> 	ops_init+0x5b/0x1e0
>> INFO: Freed in run_one_async_free+0x12/0x20 [btrfs] age=177 cpu=1 pid=8018
>> 	__slab_free+0x19e/0x2d0
>> 	kfree+0x24e/0x270
>> 	run_one_async_free+0x12/0x20 [btrfs]
>> 	btrfs_scrubparity_helper+0x38d/0x740 [btrfs]
>> 	btrfs_worker_helper+0xe/0x10 [btrfs]
>> 	process_one_work+0x417/0xa40
>> 	worker_thread+0x8b/0x730
>> 	kthread+0x199/0x1c0
>> 	ret_from_fork+0x3f/0x70
>> INFO: Slab 0xffffea0002dfa800 objects=28 used=28 fp=0x          (null) flags=0x4000000000004080
>> INFO: Object 0xffff8800b7ea2da0 @offset=11680 fp=0xffff8800b7ea2480
>
> static inline void __btrfs_queue_work(struct __btrfs_workqueue *wq,
>                                        struct btrfs_work *work)
> {
>          unsigned long flags;
> 	
>          work->wq = wq;
>          thresh_queue_hook(wq);
>          if (work->ordered_func) {
>                  spin_lock_irqsave(&wq->list_lock, flags);
>                  list_add_tail(&work->ordered_list, &wq->ordered_list);
>                  spin_unlock_irqrestore(&wq->list_lock, flags);
>          }
>          queue_work(wq->normal_wq, &work->normal_work);
>          trace_btrfs_work_queued(work);
> }
>
> Qu, 'work' can be freed before queue_work returns.  I don't see any reason
> here to have it after the queue_work() call, do you?
>
> -chris
>
>
Right, trace_btrfs_work_queued() should be called at the very beginning.

I'll submit the fix soon.

Thanks,
Qu


