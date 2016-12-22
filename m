Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from celine.tisys.org ([85.25.117.166]:51788 "EHLO celine.tisys.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751902AbcLVKfa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Dec 2016 05:35:30 -0500
Date: Thu, 22 Dec 2016 11:35:25 +0100
From: Nils Holland <nholland@tisys.org>
To: Michal Hocko <mhocko@kernel.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>,
        linux-btrfs@vger.kernel.org
Subject: Re: OOM: Better, but still there on
Message-ID: <20161222103524.GA14020@ppc-nas.fritz.box>
References: <20161216184655.GA5664@boerne.fritz.box>
 <20161217000203.GC23392@dhcp22.suse.cz>
 <20161217125950.GA3321@boerne.fritz.box>
 <862a1ada-17f1-9cff-c89b-46c47432e89f@I-love.SAKURA.ne.jp>
 <20161217210646.GA11358@boerne.fritz.box>
 <20161219134534.GC5164@dhcp22.suse.cz>
 <20161220020829.GA5449@boerne.fritz.box>
 <20161221073658.GC16502@dhcp22.suse.cz>
 <20161222101028.GA11105@ppc-nas.fritz.box>
 <20161222102725.GG6048@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161222102725.GG6048@dhcp22.suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 22, 2016 at 11:27:25AM +0100, Michal Hocko wrote:
> On Thu 22-12-16 11:10:29, Nils Holland wrote:
> 
> > However, the log comes from machine #2 again today, as I'm
> > unfortunately forced to try this via VPN from work to home today, so I
> > have exactly one attempt per machine before it goes down and locks up
> > (and I can only restart it later tonight).
> 
> This is really surprising to me. Are you sure that you have sysrq
> configured properly. At least sysrq+b shouldn't depend on any memory
> allocations and should allow you to reboot immediately. A sysrq+m right
> before the reboot might turn out being helpful as well.

Well, the issue is that I could only do everything via ssh today and
don't have any physical access to the machines. In fact, both seem to
have suffered a genuine kernel panic, which is also visible in the
last few lines of the log I provided today. So, basically, both
machines are now sitting at my home in panic state and I'll only be
able to resurrect them wheh I'm physically there again tonight. But
that was expected; I could have waited with the test until I'm at
home, which makes things easier, but I thought the sooner I can
provide a log for you to look at, the better. ;-)

Greetings
Nils
