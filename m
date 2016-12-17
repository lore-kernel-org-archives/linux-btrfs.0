Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from celine.tisys.org ([85.25.117.166]:43804 "EHLO celine.tisys.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751539AbcLQVG4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Dec 2016 16:06:56 -0500
Date: Sat, 17 Dec 2016 22:06:47 +0100
From: Nils Holland <nholland@tisys.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Michal Hocko <mhocko@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: OOM: Better, but still there on
Message-ID: <20161217210646.GA11358@boerne.fritz.box>
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

Actually, I decided to give this a try once more on machine #2, i.e.
not the one that produced the previous trace, but the other one.

I logged via netconsole as well as 'cat /debug/trace/trace_pipe' via
the network to another machine running udplogger. After the machine
had been frehsly booted and I had set up the logging, unpacking of the
firefox source tarball started. After it had been unpacking for a
while, the first load of trace messages started to appear. Some time
later, OOMs started to appear - I've got quite a lot of them in my
capture file this time.

Unfortunately, the reclaim trace messages stopped a while after the first
OOM messages show up - most likely my "cat" had been killed at that
point or became unresponsive. :-/

In the end, the machine didn't completely panic, but after nothing new
showed up being logged via the network, I walked up to the
machine and found it in a state where I couldn't really log in to it
anymore, but all that worked was, as always, a magic SysRequest reboot.

The complete log, from machine boot right up to the point where it
wouldn't really do anything anymore, is up again on my web server (~42
MB, 928 KB packed):

http://ftp.tisys.org/pub/misc/teela_2016-12-17.log.xz

Greetings
Nils
