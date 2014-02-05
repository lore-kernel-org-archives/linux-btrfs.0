Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from datenkhaos.de ([81.89.99.198]:34284 "EHLO datenkhaos.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932101AbaBEIOc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Feb 2014 03:14:32 -0500
Date: Wed, 5 Feb 2014 09:14:28 +0100
From: Johannes Hirte <johannes.hirte@datenkhaos.de>
To: Josef Bacik <jbacik@fb.com>
Cc: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: throttle delayed refs better
Message-ID: <20140205091428.076fa15c@datenkhaos.de>
In-Reply-To: <52F0F566.1090206@fb.com>
References: <1390500472-15144-1-git-send-email-jbacik@fb.com>
	<20140203192811.72866921@datenkhaos.de>
	<52F00538.3010505@fb.com>
	<20140203235334.791312d1@datenkhaos.de>
	<52F0F566.1090206@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 4 Feb 2014 09:12:54 -0500
Josef Bacik <jbacik@fb.com> wrote:

> Hrm I was hoping that was going to be more helpful.  Can you get perf 
> record -ag and then perf report while it's at full cpu and get the
> first 3 or 4 things with their traces?

Here it comes:

# ========
# captured on: Wed Feb  5 00:11:41 2014
# ========
#
no symbols found in /usr/sbin/acpid, maybe install a debug package?
unexpected end of event stream
# Samples: 168K of event 'cycles'                                                                                                                                           
# Event count (approx.): 126847081763                                                                                                                                       
#                                                                                                                                                                           
# Overhead          Command               Shared Object                                                                                           Symbol                    
# ........  ...............  ..........................  ...............................................................................................                    
#                                                                                                                                                                           
    18.48%  btrfs-freespace  [kernel.kallsyms]           [k] state_store                                                                                                    
            |
            --- state_store

    10.25%  btrfs-freespace  [kernel.kallsyms]           [k] sys_sched_rr_get_interval                                                                  
            |
            --- sys_sched_rr_get_interval

     9.02%  btrfs-freespace  [kernel.kallsyms]           [k] rt_mutex_slowunlock                                                                        
            |
            --- rt_mutex_slowunlock

     8.76%  btrfs-freespace  [kernel.kallsyms]           [k] btrfs_submit_compressed_write                                                              
            |
            --- btrfs_submit_compressed_write

     6.63%  btrfs-freespace  [kernel.kallsyms]           [k] sched_show_task                                                                            
            |
            --- sched_show_task

     5.19%  btrfs-freespace  [kernel.kallsyms]           [k] find_free_extent                                                                           
            |
            --- find_free_extent

     5.15%  btrfs-freespace  [kernel.kallsyms]           [k] trace_print_graph_duration                                                                 
            |
            --- trace_print_graph_duration

> I'm going to try and
> reproduce today, is there anything special about your fs?
> Compression, large blocksizes, skinny metadata?  Thanks,

Filesystem was created with -l 32768 -n 32768 and skinny metadata enabled.

regards,
  Johannes
