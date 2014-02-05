Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from datenkhaos.de ([81.89.99.198]:42595 "EHLO datenkhaos.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753635AbaBEVmx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Feb 2014 16:42:53 -0500
Date: Wed, 5 Feb 2014 22:42:50 +0100
From: Johannes Hirte <johannes.hirte@datenkhaos.de>
To: Josef Bacik <jbacik@fb.com>
Cc: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: throttle delayed refs better
Message-ID: <20140205224250.7876dd16@datenkhaos.de>
In-Reply-To: <52F292C7.7030701@fb.com>
References: <1390500472-15144-1-git-send-email-jbacik@fb.com>
	<20140203192811.72866921@datenkhaos.de>
	<52F00538.3010505@fb.com>
	<20140203235334.791312d1@datenkhaos.de>
	<52F0F566.1090206@fb.com>
	<20140205091428.076fa15c@datenkhaos.de>
	<52F25D7B.90807@fb.com>
	<20140205183406.47023d24@datenkhaos.de>
	<52F28A69.8050804@fb.com>
	<20140205203023.535d6f96@datenkhaos.de>
	<52F292C7.7030701@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 5 Feb 2014 14:36:39 -0500
Josef Bacik <jbacik@fb.com> wrote:

> 
> On 02/05/2014 02:30 PM, Johannes Hirte wrote:
> > On Wed, 5 Feb 2014 14:00:57 -0500
> > Josef Bacik <jbacik@fb.com> wrote:
> >
> >> On 02/05/2014 12:34 PM, Johannes Hirte wrote:
> >>> On Wed, 5 Feb 2014 10:49:15 -0500
> >>> Josef Bacik <jbacik@fb.com> wrote:
> >>>
> >>>> Ok none of those make sense which makes me think it may be the
> >>>> ktime bits, instead of un-applying the whole patch could you just
> >>>> comment out the parts
> >>>>
> >>>>            ktime_t start = ktime_get();
> >>>>
> >>>> and
> >>>>
> >>>>            if (actual_count > 0) {
> >>>>                    u64 runtime =
> >>>> ktime_to_ns(ktime_sub(ktime_get(), start)); u64 avg;
> >>>>
> >>>>                    /*
> >>>>                     * We weigh the current average higher than
> >>>> our current runtime
> >>>>                     * to avoid large swings in the average.
> >>>>                     */
> >>>>                    spin_lock(&delayed_refs->lock);
> >>>>                    avg = fs_info->avg_delayed_ref_runtime * 3 +
> >>>> runtime; avg = div64_u64(avg, 4);
> >>>>                    fs_info->avg_delayed_ref_runtime = avg;
> >>>>                    spin_unlock(&delayed_refs->lock);
> >>>>            }
> >>>>
> >>>> in __btrfs_run_delayed_refs and see if that makes the problem
> >>>> stop? If it does will you try chris's for-linus branch to see if
> >>>> it still reproduces there?  Maybe some patch changed ktime_get()
> >>>> in -rc1 that is causing issues and we're just now exposing it.
> >>>> Thanks,
> >>> With the ktime bits disabled, I wasn't able to reproduce the
> >>> problem anymore. With Chris' for-linus branch it took longer but
> >>> still appeared.
> >>>
> >> Ok can you send your .config, maybe there's some weird time bug
> >> being exposed.  What kind of CPU do you have?  Thanks,
> >>
> >> Josef
> > It's a Core i5-540M, dualcore + hyperthreading
> Ok while I'm doing this can you change 
> btrfs_should_throttle_delayed_refs to _always_ return 1, still with
> all the ktime stuff commented out, and see if that causes the problem
> to happen?  Thanks,

Yes it does. Same behavior as without ktime stuff commented out.

