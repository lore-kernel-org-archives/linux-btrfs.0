Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:59621 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429AbaJGXpg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Oct 2014 19:45:36 -0400
Date: Tue, 7 Oct 2014 16:45:13 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: 3.16.2 btrfs deadlock
Message-ID: <20141007234513.GC20416@merlins.org>
References: <20141005202937.GK10696@merlins.org>
 <1412716972.2374.1@mail.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1412716972.2374.1@mail.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 07, 2014 at 05:22:52PM -0400, Chris Mason wrote:
> >Here's the trace:
> >SysRq : Show Blocked State
> >  task                        PC stack   pid father
> >md8_raid5       D ffff88017028cb80     0   675      2 0x00000000
> > ffff88020fd67aa8 0000000000000046 ffffffff812f1799 ffff88020fd67fd8
> > ffff880037228410 00000000000140c0 ffff88021e3940c0 ffff880037228410
> > ffff8801f5579bf0 0000000000000004 ffff880211ad07c8 ffff88020fd67ab8
> >Call Trace:
> > [<ffffffff812f1799>] ? blk_flush_plug_list+0x1bc/0x1cb
> > [<ffffffff8163a889>] schedule+0x6e/0x70
> > [<ffffffff8163aa2b>] io_schedule+0x60/0x7a
> > [<ffffffff812ef8f6>] get_request+0x4b8/0x56a
> > [<ffffffff8130ba01>] ? cfq_merge+0x49/0x9e
> > [<ffffffff81087b70>] ? finish_wait+0x65/0x65
> > [<ffffffff812f1921>] blk_queue_bio+0x179/0x262
> > [<ffffffff812eec2c>] generic_make_request+0x9c/0xdb
> > [<ffffffffc042b31d>] handle_stripe+0x1e41/0x2166 [raid456]
> > [<ffffffff81017316>] ? ___preempt_schedule+0x56/0xa8
> > [<ffffffff8163d0d9>] ? _raw_spin_unlock_irqrestore+0x1f/0x32
> > [<ffffffffc042b925>] handle_active_stripes.isra.22+0x2e3/0x359
> >[raid456]
> > [<ffffffff8151d35e>] ? md_wakeup_thread+0x55/0x58
> > [<ffffffffc042bdd6>] raid5d+0x330/0x428 [raid456]
> > [<ffffffff810795b1>] ? get_parent_ip+0xd/0x3c
> > [<ffffffff815202f9>] md_thread+0x11c/0x13a
> > [<ffffffff81087b70>] ? finish_wait+0x65/0x65
> > [<ffffffff815201dd>] ? bb_store+0x55/0x55
> > [<ffffffff8106e3a9>] kthread+0xae/0xb6
> > [<ffffffff8106e2fb>] ? __kthread_parkme+0x61/0x61
> > [<ffffffff8163d8fc>] ret_from_fork+0x7c/0xb0
> > [<ffffffff8106e2fb>] ? __kthread_parkme+0x61/0x61
> 
> This trace shows we're stuck somewhere different from the 3.15
> stalls.  md is waiting for a request, and unfortunately those are
> outside of btrfs completely.  It's likely that if you had let it
> sit, the box would have eventually dig its way out.

Thanks for having a look.
I didn't actually reboot it, it deadlocked and hit a CPU stuck watchdog
and self rebooted.

But as long as it's not btrfs, then that's good :)

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
