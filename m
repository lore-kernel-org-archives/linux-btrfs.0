Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39927 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752026AbcLUOJF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Dec 2016 09:09:05 -0500
Date: Wed, 21 Dec 2016 15:08:48 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: drop trace_btrfs_all_work_done() from
 normal_work_helper()
Message-ID: <20161221140848.GB12081@suse.cz>
Reply-To: dsterba@suse.cz
References: <20161214140530.6534-1-bigeasy@linutronix.de>
 <20161220172613.GQ3620@twin.jikos.cz>
 <f6229501-59de-3b53-db19-7b29a53c3342@cn.fujitsu.com>
 <20161221082837.76yw5brgr7wovx6y@linutronix.de>
 <8e0e7bfd-8066-eb73-5180-376a182d7e60@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <8e0e7bfd-8066-eb73-5180-376a182d7e60@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 21, 2016 at 04:45:06PM +0800, Qu Wenruo wrote:
> 
> 
> At 12/21/2016 04:28 PM, Sebastian Andrzej Siewior wrote:
> > On 2016-12-21 08:33:03 [+0800], Qu Wenruo wrote:
> >> The trace point only uses the pointer, and this helps us to pair with
> >> btrfs_work_queued/sched.
> >
> > | /* For situiations that the work is freed */
> > | DECLARE_EVENT_CLASS(btrfs__work__done,
> > |
> > |         TP_PROTO(struct btrfs_work *work),
> > |
> > |         TP_ARGS(work),
> > |
> > |         TP_STRUCT__entry_btrfs(
> > |                 __field(        void *, work                    )
> > |         ),
> > |
> > |         TP_fast_assign_btrfs(btrfs_work_owner(work),
> > |                 __entry->work           = work;
> > |         ),
> > |
> > |         TP_printk_btrfs("work->%p", __entry->work)
> > | );
> >
> > and btrfs_work_owner exapnds to:
> >
> > | struct btrfs_fs_info *
> > | btrfs_work_owner(struct btrfs_work *work)
> > | {
> > |         return work->wq->fs_info;
> > | }
> >
> > voilà
> 
> Oh I got it, thanks very much.
> 
> The btrfs_work_owner() is newly introduced, no wonder I didn't know that.
> 
> 
> I think we can fix it by extracting fs_info pointer before running the 
> work, and using the extracted one in the trace point.

That sounds like an easy fix to preserve the tracepoint.
