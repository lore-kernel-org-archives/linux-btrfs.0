Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from celine.tisys.org ([85.25.117.166]:40818 "EHLO celine.tisys.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751962AbcLQRLV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Dec 2016 12:11:21 -0500
Date: Sat, 17 Dec 2016 18:11:13 +0100
From: Nils Holland <nholland@tisys.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Michal Hocko <mhocko@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: OOM: Better, but still there on
Message-ID: <20161217171112.GA7327@boerne.fritz.box>
References: <20161216073941.GA26976@dhcp22.suse.cz>
 <20161216155808.12809-1-mhocko@kernel.org>
 <20161216184655.GA5664@boerne.fritz.box>
 <20161217000203.GC23392@dhcp22.suse.cz>
 <20161217125950.GA3321@boerne.fritz.box>
 <862a1ada-17f1-9cff-c89b-46c47432e89f@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <862a1ada-17f1-9cff-c89b-46c47432e89f@I-love.SAKURA.ne.jp>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 17, 2016 at 11:44:45PM +0900, Tetsuo Handa wrote:
> On 2016/12/17 21:59, Nils Holland wrote:
> > On Sat, Dec 17, 2016 at 01:02:03AM +0100, Michal Hocko wrote:
> >> mount -t tracefs none /debug/trace
> >> echo 1 > /debug/trace/events/vmscan/enable
> >> cat /debug/trace/trace_pipe > trace.log
> >>
> >> should help
> >> [...]
> > 
> > No problem! I enabled writing the trace data to a file and then tried
> > to trigger another OOM situation. That worked, this time without a
> > complete kernel panic, but with only my processes being killed and the
> > system becoming unresponsive.
> > [...]
> 
> Under OOM situation, writing to a file on disk unlikely works. Maybe
> logging via network ( "cat /debug/trace/trace_pipe > /dev/udp/$ip/$port"
> if your are using bash) works better. (I wish we can do it from kernel
> so that /bin/cat is not disturbed by delays due to page fault.)
> 
> If you can configure netconsole for logging OOM killer messages and
> UDP socket for logging trace_pipe messages, udplogger at
> https://osdn.net/projects/akari/scm/svn/tree/head/branches/udplogger/
> might fit for logging both output with timestamp into a single file.

Thanks for the hint, sounds very sane! I'll try to go that route for
the next log / trace I produce. Of course, if Michal says that the
trace file I've already posted, and which has been logged to file, is
useless and would have been better if I had instead logged to a
different machine via the network, I could also repeat the current
experiment and produce a new file at any time. :-)

Greetings
Nils
