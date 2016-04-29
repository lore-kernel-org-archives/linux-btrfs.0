Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657AbcD2Ijo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Apr 2016 04:39:44 -0400
Date: Fri, 29 Apr 2016 04:39:39 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Ming Lei <ming.lei@canonical.com>
cc: Jens Axboe <axboe@fb.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Shaun Tancheff <shaun.tancheff@seagate.com>,
        Alan Cox <alan@linux.intel.com>, Neil Brown <neilb@suse.de>,
        Liu Bo <bo.li.liu@oracle.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v3 3/3] block: avoid to call .bi_end_io() recursively
In-Reply-To: <CACVXFVPSZWMTCOT0F__88pPr4T90t17etCv78EyLtpJjTSETSg@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.1604290430050.11338@file01.intranet.prod.int.rdu2.redhat.com>
References: <1461805789-3632-1-git-send-email-ming.lei@canonical.com> <1461805789-3632-3-git-send-email-ming.lei@canonical.com> <alpine.LRH.2.02.1604281127130.14065@file01.intranet.prod.int.rdu2.redhat.com> <CACVXFVPgPh3snp-B6=G9fShzJwwKz2NyQETSnMJBGp=HzTL_-w@mail.gmail.com>
 <alpine.LRH.2.02.1604281157180.6220@file01.intranet.prod.int.rdu2.redhat.com> <CACVXFVN7bE3tFs9KVGX-M3LCvOr0WuCMwyoGiW4qu5G4h8EzhA@mail.gmail.com> <alpine.LRH.2.02.1604281218180.10827@file01.intranet.prod.int.rdu2.redhat.com>
 <CACVXFVPSZWMTCOT0F__88pPr4T90t17etCv78EyLtpJjTSETSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On Fri, 29 Apr 2016, Ming Lei wrote:

> On Fri, Apr 29, 2016 at 12:59 AM, Mikulas Patocka <mpatocka@redhat.com> wrote:
> >
> >
> > On Fri, 29 Apr 2016, Ming Lei wrote:
> >
> >> On Thu, Apr 28, 2016 at 11:58 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
> >> >
> >> >
> >> > On Thu, 28 Apr 2016, Ming Lei wrote:
> >> >
> >> >> Hi Mikulas,
> >> >>
> >> >> On Thu, Apr 28, 2016 at 11:29 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
> >> >> >
> >> >> >
> >> >> > On Thu, 28 Apr 2016, Ming Lei wrote:
> >> >> >
> >> >> >> There were reports about heavy stack use by recursive calling
> >> >> >> .bi_end_io()([1][2][3]). For example, more than 16K stack is
> >> >> >> consumed in a single bio complete path[3], and in [2] stack
> >> >> >> overflow can be triggered if 20 nested dm-crypt is used.
> >> >> >>
> >> >> >> Also patches[1] [2] [3] were posted for addressing the issue,
> >> >> >> but never be merged. And the idea in these patches is basically
> >> >> >> similar, all serializes the recursive calling of .bi_end_io() by
> >> >> >> percpu list.
> >> >> >>
> >> >> >> This patch still takes the same idea, but uses bio_list to
> >> >> >> implement it, which turns out more simple and the code becomes
> >> >> >> more readable meantime.
> >> >> >>
> >> >> >> One corner case which wasn't covered before is that
> >> >> >> bi_endio() may be scheduled to run in process context(such
> >> >> >> as btrfs), and this patch just bypasses the optimizing for
> >> >> >> that case because one new context should have enough stack space,
> >> >> >> and this approach isn't capable of optimizing it too because
> >> >> >> there isn't easy way to get a per-task linked list head.
> >> >> >
> >> >> > Hi
> >> >> >
> >> >> > You could use preempt_disable() and then you could use per-cpu list even
> >> >> > in the process context.
> >> >>
> >> >> Image why the .bi_end_io() is scheduled to process context, and the only
> >> >> workable/simple way I thought of is to use per-task list because it may sleep.
> >> >
> >> > The bi_end_io callback should not sleep, even if it is called from the
> >> > process context.
> >>
> >> If it shouldn't sleep, why is it scheduled to run in process context by paying
> >> extra context switch cost?
> >
> > Some device mapper (and other) drivers use a worker thread to process
> > bios. So the bio may be finished from the worker thread. It would be
> > advantageous to prevent stack overflow even in this case.
> 
> If the .bi_end_io wouldn't sleep, it can be put back into interrupt context
> for the sake of performance when this patch is merged. The cost of context
> switch in high IOPS case isn't cheap.

If some block device driver in a process context finds out that it needs 
to terminate a bio, it calls bio_endio in a process context. Why would it 
need to trigger an interrupt just to call bio_endio? (and how could it 
trigger an interrupt if that driver perhaps doesn't use interrupts at 
all?) I don't know what are you trying to suggest.

> It isn't easy to avoid the recursive calling in process context except you
> can add something 'task_struct' or introduce 'alloca()' in kernel. Or do you
> have better ideas?

preempt_disable around the bi_endio callback should be sufficient.

> >
> >> And you can find that btrfs_subio_endio_read() does sleep for checksum stuff.
> >
> > I'm not an expert on btrfs. What happens if it is called from an
> > interrupt? Do you have an actual stracktrace when this function is called
> 
> What do you expect if sleepable function is called in softirq or
> hardirq handler? :-)
> 
> > from bio_endio and when it sleeps?
> 
> The problem is observed in xfstests generic/323 by this patch v1. Sometimes the
> test hangs, and sometimes kernel oops is triggered. and the issue is
> fixed by introducing 'if (!in_interrupt())' block for handling running
> .bi_end_io() from
> process context.
> 
> If the block of 'if (!in_interrupt())' is removed and
> preempt_disable()/preempt_enable() is added around bio->bi_end_io(),
> the following kernel warning can be seen easily:
> 
> [   51.086303] BUG: sleeping function called from invalid context at
> mm/slab.h:388
> [   51.087442] in_atomic(): 1, irqs_disabled(): 0, pid: 633, name: kworker/u8:4
> [   51.088575] CPU: 3 PID: 633 Comm: kworker/u8:4 Not tainted 4.6.0-rc3+ #2017
> [   51.088578] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
> BIOS rel-1.9.0-0-g01a84be-prebuilt.qemu-project.org 04/01/2014
> [   51.088637] Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
> [   51.088640]  0000000000000000 ffff88007bbebc00 ffffffff813d92d3
> ffff88007ba6ce00
> [   51.088643]  0000000000000184 ffff88007bbebc18 ffffffff810a38bb
> ffffffff81a35310
> [   51.088645]  ffff88007bbebc40 ffffffff810a3949 0000000002400040
> 0000000002400040
> [   51.088648] Call Trace:
> [   51.088651]  [<ffffffff813d92d3>] dump_stack+0x63/0x90
> [   51.088655]  [<ffffffff810a38bb>] ___might_sleep+0xdb/0x120
> [   51.088657]  [<ffffffff810a3949>] __might_sleep+0x49/0x80
> [   51.088659]  [<ffffffff811e98e7>] kmem_cache_alloc+0x1a7/0x210
> [   51.088670]  [<ffffffffc0102741>] ? alloc_extent_state+0x21/0xe0 [btrfs]
> [   51.088680]  [<ffffffffc0102741>] alloc_extent_state+0x21/0xe0 [btrfs]
> [   51.088689]  [<ffffffffc01046ce>] __clear_extent_bit+0x2ae/0x3d0 [btrfs]
> [   51.088698]  [<ffffffffc0104e6a>] clear_extent_bit+0x2a/0x30 [btrfs]
> [   51.088708]  [<ffffffffc00e96d0>] btrfs_endio_direct_read+0x70/0xf0 [btrfs]
> [   51.088711]  [<ffffffff8139f1e7>] bio_endio+0xf7/0x140
> [   51.088718]  [<ffffffffc00dbb9c>] end_workqueue_fn+0x3c/0x40 [btrfs]
> [   51.088728]  [<ffffffffc01184d7>] normal_work_helper+0xc7/0x310 [btrfs]
> [   51.088737]  [<ffffffffc01187f2>] btrfs_endio_helper+0x12/0x20 [btrfs]
> [   51.088740]  [<ffffffff81097b77>] process_one_work+0x157/0x420
> [   51.088742]  [<ffffffff810985ab>] worker_thread+0x12b/0x4d0
> [   51.088744]  [<ffffffff817171a8>] ? __schedule+0x368/0x950
> [   51.088746]  [<ffffffff81098480>] ? rescuer_thread+0x380/0x380
> [   51.088748]  [<ffffffff8109de84>] kthread+0xd4/0xf0
> [   51.088750]  [<ffffffff8171b7a2>] ret_from_fork+0x22/0x40
> [   51.088752]  [<ffffffff8109ddb0>] ? kthread_park+0x60/0x60
> 
> 
> Not mention wait_for_completion() in both __btrfs_correct_data_nocsum()
> and __btrfs_subio_endio_read(), which are called by btrfs_subio_endio_read()
> in btrfs_endio_direct_read().

btrfs is calling bio_endio on bio that it created. So, bio_endio in btrfs 
can be replaced with:
if (bio->bi_end_io == btrfs_endio_direct_read)
	btrfs_endio_direct_read(bio);
else
	bio_endio(bio);

... or just maybe just with this:
bio->bi_end_io(bio);

This could be fixed easily.

Mikulas

> Thanks,
> Ming
> 
> >
> >> Thanks,
> >> Ming
> >
> > Mikulas
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-block" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
