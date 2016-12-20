Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from celine.tisys.org ([85.25.117.166]:56758 "EHLO celine.tisys.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756256AbcLTCIj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Dec 2016 21:08:39 -0500
Date: Tue, 20 Dec 2016 03:08:29 +0100
From: Nils Holland <nholland@tisys.org>
To: Michal Hocko <mhocko@kernel.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>,
        linux-btrfs@vger.kernel.org
Subject: Re: OOM: Better, but still there on
Message-ID: <20161220020829.GA5449@boerne.fritz.box>
References: <20161216073941.GA26976@dhcp22.suse.cz>
 <20161216155808.12809-1-mhocko@kernel.org>
 <20161216184655.GA5664@boerne.fritz.box>
 <20161217000203.GC23392@dhcp22.suse.cz>
 <20161217125950.GA3321@boerne.fritz.box>
 <862a1ada-17f1-9cff-c89b-46c47432e89f@I-love.SAKURA.ne.jp>
 <20161217210646.GA11358@boerne.fritz.box>
 <20161219134534.GC5164@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161219134534.GC5164@dhcp22.suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 19, 2016 at 02:45:34PM +0100, Michal Hocko wrote:

> Unfortunatelly shrink_active_list doesn't have any tracepoint so we do
> not know whether we managed to rotate those pages. If they are referenced
> quickly enough we might just keep refaulting them... Could you try to apply
> the followin diff on top what you have currently. It should add some more
> tracepoint data which might tell us more. We can reduce the amount of
> tracing data by enabling only mm_vmscan_lru_isolate,
> mm_vmscan_lru_shrink_inactive and mm_vmscan_lru_shrink_active.

So, the results are in! I applied your patch and rebuild the kernel,
then I rebooted the machine, set up tracing so that only the three
events you mentioned were being traced, and captured the output over
the network.

Things went a bit different this time: The trace events started to
appear after a while and a whole lot of them were generated, but
suddenly they stopped. A short while later, we get

[ 1661.485568] btrfs-transacti: page alloction stalls for 611058ms, order:0, mode:0x2420048(GFP_NOFS|__GFP_HARDWALL|__GFP_MOVABLE)

along with a backtrace and memory information, and then there was
silence. When I walked up to the machine, it had completely died; it
wouldn't turn on its screen on key press any more, blindly trying to
reboot via SysRequest had no effect, but the caps lock LED also wasn't
blinking, like it normally does when a kernel panic occurs. Good
question what state it was in. The OOM reaper didn't really seem to
kick in and kill processes this time, it seems.

The complete capture is up at:

http://ftp.tisys.org/pub/misc/teela_2016-12-20.log.xz

Greetings
Nils
