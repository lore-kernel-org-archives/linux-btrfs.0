Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34964 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932697AbcLQACH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Dec 2016 19:02:07 -0500
Date: Sat, 17 Dec 2016 01:02:03 +0100
From: Michal Hocko <mhocko@kernel.org>
To: Nils Holland <nholland@tisys.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: OOM: Better, but still there on
Message-ID: <20161217000203.GC23392@dhcp22.suse.cz>
References: <20161216073941.GA26976@dhcp22.suse.cz>
 <20161216155808.12809-1-mhocko@kernel.org>
 <20161216184655.GA5664@boerne.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161216184655.GA5664@boerne.fritz.box>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri 16-12-16 19:47:00, Nils Holland wrote:
[...]
> Despite the fact that I'm no expert, I can see that there's no more
> GFP_NOFS being logged, which seems to be what the patches tried to
> achieve. What the still present OOMs mean remains up for
> interpretation by the experts, all I can say is that in the (pre-4.8?)
> past, doing all of the things I just did would probably slow down my
> machine quite a bit, but I can't remember to have ever seen it OOM or
> even crash completely.
> 
> Dec 16 18:56:24 boerne.fritz.box kernel: Purging GPU memory, 37 pages freed, 10219 pages still pinned.
> Dec 16 18:56:29 boerne.fritz.box kernel: kthreadd invoked oom-killer: gfp_mask=0x27080c0(GFP_KERNEL_ACCOUNT|__GFP_ZERO|__GFP_NOTRACK), nodemask=0, order=1, oom_score_adj=0
> Dec 16 18:56:29 boerne.fritz.box kernel: kthreadd cpuset=/ mems_allowed=0
[...]
> Dec 16 18:56:29 boerne.fritz.box kernel: Normal free:41008kB min:41100kB low:51372kB high:61644kB active_anon:0kB inactive_anon:0kB active_file:470556kB inactive_file:148kB unevictable:0kB writepending:1616kB present:897016kB managed:831480kB mlocked:0kB slab_reclaimable:213172kB slab_unreclaimable:86236kB kernel_stack:1864kB pagetables:3572kB bounce:0kB free_pcp:532kB local_pcp:456kB free_cma:0kB

this is a GFP_KERNEL allocation so it cannot use the highmem zone again.
There is no anonymous memory in this zone but the allocation
context implies the full reclaim context so the file LRU should be
reclaimable. For some reason ~470MB of the active file LRU is still
there. This is quite unexpected. It is harder to tell more without
further data. It would be great if you could enable reclaim related
tracepoints:

mount -t tracefs none /debug/trace
echo 1 > /debug/trace/events/vmscan/enable
cat /debug/trace/trace_pipe > trace.log

should help
[...]

> Dec 16 18:56:31 boerne.fritz.box kernel: xfce4-terminal invoked oom-killer: gfp_mask=0x25000c0(GFP_KERNEL_ACCOUNT), nodemask=0, order=0, oom_score_adj=0

another allocation in a short time. Killing the task has obviously
didn't help because the lowmem memory pressure hasn't been relieved

[...]
> Dec 16 18:56:32 boerne.fritz.box kernel: Normal free:41028kB min:41100kB low:51372kB high:61644kB active_anon:0kB inactive_anon:0kB active_file:472164kB inactive_file:108kB unevictable:0kB writepending:112kB present:897016kB managed:831480kB mlocked:0kB slab_reclaimable:213236kB slab_unreclaimable:86360kB kernel_stack:1584kB pagetables:2564kB bounce:32kB free_pcp:180kB local_pcp:24kB free_cma:0kB

in fact we have even more pages on the file LRUs.

[...]

> Dec 16 18:56:32 boerne.fritz.box kernel: xfce4-terminal invoked oom-killer: gfp_mask=0x25000c0(GFP_KERNEL_ACCOUNT), nodemask=0, order=0, oom_score_adj=0
[...]
> Dec 16 18:56:32 boerne.fritz.box kernel: Normal free:40988kB min:41100kB low:51372kB high:61644kB active_anon:0kB inactive_anon:0kB active_file:472436kB inactive_file:144kB unevictable:0kB writepending:312kB present:897016kB managed:831480kB mlocked:0kB slab_reclaimable:213236kB slab_unreclaimable:86360kB kernel_stack:1584kB pagetables:2464kB bounce:32kB free_pcp:116kB local_pcp:0kB free_cma:0kB

same here. All that suggests that the page cache cannot be reclaimed for
some reason. It is hard to tell why but there is definitely something
bad going on.
-- 
Michal Hocko
SUSE Labs
