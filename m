Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:7474 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751425AbaBEPt1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Feb 2014 10:49:27 -0500
Message-ID: <52F25D7B.90807@fb.com>
Date: Wed, 5 Feb 2014 10:49:15 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Johannes Hirte <johannes.hirte@datenkhaos.de>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: throttle delayed refs better
References: <1390500472-15144-1-git-send-email-jbacik@fb.com>	<20140203192811.72866921@datenkhaos.de>	<52F00538.3010505@fb.com>	<20140203235334.791312d1@datenkhaos.de>	<52F0F566.1090206@fb.com> <20140205091428.076fa15c@datenkhaos.de>
In-Reply-To: <20140205091428.076fa15c@datenkhaos.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 02/05/2014 03:14 AM, Johannes Hirte wrote:
> On Tue, 4 Feb 2014 09:12:54 -0500
> Josef Bacik <jbacik@fb.com> wrote:
>
>> Hrm I was hoping that was going to be more helpful.  Can you get perf
>> record -ag and then perf report while it's at full cpu and get the
>> first 3 or 4 things with their traces?
> Here it comes:
>
> # ========
> # captured on: Wed Feb  5 00:11:41 2014
> # ========
> #
> no symbols found in /usr/sbin/acpid, maybe install a debug package?
> unexpected end of event stream
> # Samples: 168K of event 'cycles'
> # Event count (approx.): 126847081763
> #
> # Overhead          Command               Shared Object                                                                                           Symbol
> # ........  ...............  ..........................  ...............................................................................................
> #
>      18.48%  btrfs-freespace  [kernel.kallsyms]           [k] state_store
>              |
>              --- state_store
>
>      10.25%  btrfs-freespace  [kernel.kallsyms]           [k] sys_sched_rr_get_interval
>              |
>              --- sys_sched_rr_get_interval
>
>       9.02%  btrfs-freespace  [kernel.kallsyms]           [k] rt_mutex_slowunlock
>              |
>              --- rt_mutex_slowunlock
>
>       8.76%  btrfs-freespace  [kernel.kallsyms]           [k] btrfs_submit_compressed_write
>              |
>              --- btrfs_submit_compressed_write
>
>       6.63%  btrfs-freespace  [kernel.kallsyms]           [k] sched_show_task
>              |
>              --- sched_show_task
>
>       5.19%  btrfs-freespace  [kernel.kallsyms]           [k] find_free_extent
>              |
>              --- find_free_extent
>
>       5.15%  btrfs-freespace  [kernel.kallsyms]           [k] trace_print_graph_duration
>              |
>              --- trace_print_graph_duration
>
>> I'm going to try and
>> reproduce today, is there anything special about your fs?
>> Compression, large blocksizes, skinny metadata?  Thanks,
> Filesystem was created with -l 32768 -n 32768 and skinny metadata enabled.
>
Ok none of those make sense which makes me think it may be the ktime 
bits, instead of un-applying the whole patch could you just comment out 
the parts

         ktime_t start = ktime_get();

and

         if (actual_count > 0) {
                 u64 runtime = ktime_to_ns(ktime_sub(ktime_get(), start));
                 u64 avg;

                 /*
                  * We weigh the current average higher than our current 
runtime
                  * to avoid large swings in the average.
                  */
                 spin_lock(&delayed_refs->lock);
                 avg = fs_info->avg_delayed_ref_runtime * 3 + runtime;
                 avg = div64_u64(avg, 4);
                 fs_info->avg_delayed_ref_runtime = avg;
                 spin_unlock(&delayed_refs->lock);
         }

in __btrfs_run_delayed_refs and see if that makes the problem stop? If 
it does will you try chris's for-linus branch to see if it still 
reproduces there?  Maybe some patch changed ktime_get() in -rc1 that is 
causing issues and we're just now exposing it.  Thanks,

Josef
