Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zimbra13.linbit.com ([212.69.166.240]:54272 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135AbcDFMB3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Apr 2016 08:01:29 -0400
Date: Wed, 6 Apr 2016 14:01:23 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: NeilBrown <neilb@suse.de>
Cc: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] [RFC] fix potential access after free: return value of
 blk_check_plugged() must be used schedule() safe
Message-ID: <20160406120123.GD3078@soda.linbit>
References: <20160405133657.GA3078@soda.linbit>
 <20160406004956.GA102852@kernel.org>
 <87k2kbo2im.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87k2kbo2im.fsf@notabene.neil.brown.name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 06, 2016 at 01:10:57PM +1000, NeilBrown wrote:
> On Wed, Apr 06 2016, Shaohua Li wrote:
> 
> > On Tue, Apr 05, 2016 at 03:36:57PM +0200, Lars Ellenberg wrote:
> >> blk_check_plugged() will return a pointer
> >> to an object linked on current->plug->cb_list.
> >> 
> >> That list may "at any time" be implicitly cleared by
> >> blk_flush_plug_list()
> >>  flush_plug_callbacks()
> >> either as a result of blk_finish_plug(),
> >> or implicitly by schedule() [and maybe other implicit mechanisms?]
> >> 
> >> If there is no protection against an implicit unplug
> >> between the call to blk_check_plug() and using its return value,
> >> that implicit unplug may have already happened,
> >> even before the plug is actually initialized or populated,
> >> and we may be using a pointer to already free()d data.
> >
> > This isn't correct. flush plug is never called in preemption, which is designed
> > only called when the task is going to sleep. See sched_submit_work. Am I
> > missing anything?
> 
> Ahh yes, thanks.
> 
> Only two places call blk_schedule_flush_plug().
> One is io_schedule_timeout() which must be called explicitly.
> There other is, as you say, sched_submit_work().  It starts:
> 
> static inline void sched_submit_work(struct task_struct *tsk)
> {
>         if (!tsk->state || tsk_is_pi_blocked(tsk))
>                 return;
> 
> so if the task is runnable, then as
> include/linux/sched.h:#define TASK_RUNNING              0
> 
> it will never call blk_schedule_flush_plug().
> 
> So I don't think you are missing anything, we were.
> 
> Lars:  have your concerns been relieved or do you still have reason to
> think there is a problem?

So just don't call anything that might_sleep() between
blk_check_plug() and using its return value.
All good.
I thought I must have overlooked something.

Thanks,

    Lars

