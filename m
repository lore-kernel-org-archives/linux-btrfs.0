Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60656 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1765270AbcLVK13 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Dec 2016 05:27:29 -0500
Date: Thu, 22 Dec 2016 11:27:25 +0100
From: Michal Hocko <mhocko@kernel.org>
To: Nils Holland <nholland@tisys.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>,
        linux-btrfs@vger.kernel.org
Subject: Re: OOM: Better, but still there on
Message-ID: <20161222102725.GG6048@dhcp22.suse.cz>
References: <20161216155808.12809-1-mhocko@kernel.org>
 <20161216184655.GA5664@boerne.fritz.box>
 <20161217000203.GC23392@dhcp22.suse.cz>
 <20161217125950.GA3321@boerne.fritz.box>
 <862a1ada-17f1-9cff-c89b-46c47432e89f@I-love.SAKURA.ne.jp>
 <20161217210646.GA11358@boerne.fritz.box>
 <20161219134534.GC5164@dhcp22.suse.cz>
 <20161220020829.GA5449@boerne.fritz.box>
 <20161221073658.GC16502@dhcp22.suse.cz>
 <20161222101028.GA11105@ppc-nas.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161222101028.GA11105@ppc-nas.fritz.box>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu 22-12-16 11:10:29, Nils Holland wrote:
> On Wed, Dec 21, 2016 at 08:36:59AM +0100, Michal Hocko wrote:
> > TL;DR
> > there is another version of the debugging patch. Just revert the
> > previous one and apply this one instead. It's still not clear what
> > is going on but I suspect either some misaccounting or unexpeted
> > pages on the LRU lists. I have added one more tracepoint, so please
> > enable also mm_vmscan_inactive_list_is_low.
> 
> Right, I did just that and can provide a new log. I was also able, in
> this case, to reproduce the OOM issues again and not just the "page
> allocation stalls" that were the only thing visible in the previous
> log.

Thanks a lot for testing! I will have a look later today.

> However, the log comes from machine #2 again today, as I'm
> unfortunately forced to try this via VPN from work to home today, so I
> have exactly one attempt per machine before it goes down and locks up
> (and I can only restart it later tonight).

This is really surprising to me. Are you sure that you have sysrq
configured properly. At least sysrq+b shouldn't depend on any memory
allocations and should allow you to reboot immediately. A sysrq+m right
before the reboot might turn out being helpful as well.
-- 
Michal Hocko
SUSE Labs
