Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:58130 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752582AbcLUI2w (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Dec 2016 03:28:52 -0500
Date: Wed, 21 Dec 2016 09:28:37 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: drop trace_btrfs_all_work_done() from
 normal_work_helper()
Message-ID: <20161221082837.76yw5brgr7wovx6y@linutronix.de>
References: <20161214140530.6534-1-bigeasy@linutronix.de>
 <20161220172613.GQ3620@twin.jikos.cz>
 <f6229501-59de-3b53-db19-7b29a53c3342@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <f6229501-59de-3b53-db19-7b29a53c3342@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-12-21 08:33:03 [+0800], Qu Wenruo wrote:
> The trace point only uses the pointer, and this helps us to pair with
> btrfs_work_queued/sched.

| /* For situiations that the work is freed */
| DECLARE_EVENT_CLASS(btrfs__work__done,
| 
|         TP_PROTO(struct btrfs_work *work),
| 
|         TP_ARGS(work),
| 
|         TP_STRUCT__entry_btrfs(
|                 __field(        void *, work                    )
|         ),
| 
|         TP_fast_assign_btrfs(btrfs_work_owner(work),
|                 __entry->work           = work;
|         ),
| 
|         TP_printk_btrfs("work->%p", __entry->work)
| );

and btrfs_work_owner exapnds to:

| struct btrfs_fs_info *
| btrfs_work_owner(struct btrfs_work *work)
| {
|         return work->wq->fs_info;
| }
 
voilà

> But I still don't understand why backtrace is triggered.
> Since we're just recording a pointer, not touching it.
> 
> Would you please explain the problem with more details on how it trigger the
> problem?

enabled all events played with the fs which was just an upgrade and git
tree sync + checkout so nothing special.

> > 
> > So I think we should either remove the tracepoint completely or change
> > the arguments to take something else than a potentially freed 'work'.
> 
> I'm mostly OK to remove the tracepoint, but such all_workd_done() trace
> should still help to determine if it's a workqueue stalled.
> 
> Thanks,
> Qu

Sebastian
