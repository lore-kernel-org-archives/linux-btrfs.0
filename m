Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:58245 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750750AbcLUIzl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Dec 2016 03:55:41 -0500
Date: Wed, 21 Dec 2016 09:55:33 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>
Subject: Re: [PATCH 1/2] btrfs: drop trace_btrfs_all_work_done() from
 normal_work_helper()
Message-ID: <20161221085533.vheebblec2ohygn5@linutronix.de>
References: <20161214140530.6534-1-bigeasy@linutronix.de>
 <20161220172613.GQ3620@twin.jikos.cz>
 <f6229501-59de-3b53-db19-7b29a53c3342@cn.fujitsu.com>
 <20161221082837.76yw5brgr7wovx6y@linutronix.de>
 <8e0e7bfd-8066-eb73-5180-376a182d7e60@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <8e0e7bfd-8066-eb73-5180-376a182d7e60@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-12-21 16:45:06 [+0800], Qu Wenruo wrote:
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

It was introduced in cb001095ca70 ("btrfs: plumb fs_info into
btrfs_work") which is v4.8-rc1. The usage in trace points started in
bc074524e123 ("btrfs: prefix fsid to all trace events") which is also
v4.8-rc1. So whatever is done to get it fixed, it should be pushed
stable for v4.8+.

> Thanks,
> Qu

Sebastian
