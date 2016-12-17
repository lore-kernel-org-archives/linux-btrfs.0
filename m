Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www262.sakura.ne.jp ([202.181.97.72]:52958 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755784AbcLQOpP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Dec 2016 09:45:15 -0500
Subject: Re: OOM: Better, but still there on
To: Nils Holland <nholland@tisys.org>, Michal Hocko <mhocko@kernel.org>
References: <20161216073941.GA26976@dhcp22.suse.cz>
 <20161216155808.12809-1-mhocko@kernel.org>
 <20161216184655.GA5664@boerne.fritz.box>
 <20161217000203.GC23392@dhcp22.suse.cz>
 <20161217125950.GA3321@boerne.fritz.box>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-ID: <862a1ada-17f1-9cff-c89b-46c47432e89f@I-love.SAKURA.ne.jp>
Date: Sat, 17 Dec 2016 23:44:45 +0900
MIME-Version: 1.0
In-Reply-To: <20161217125950.GA3321@boerne.fritz.box>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016/12/17 21:59, Nils Holland wrote:
> On Sat, Dec 17, 2016 at 01:02:03AM +0100, Michal Hocko wrote:
>> mount -t tracefs none /debug/trace
>> echo 1 > /debug/trace/events/vmscan/enable
>> cat /debug/trace/trace_pipe > trace.log
>>
>> should help
>> [...]
> 
> No problem! I enabled writing the trace data to a file and then tried
> to trigger another OOM situation. That worked, this time without a
> complete kernel panic, but with only my processes being killed and the
> system becoming unresponsive. When that happened, I let it run for
> another minute or two so that in case it was still logging something
> to the trace file, it could continue to do so some time longer. Then I
> rebooted with the only thing that still worked, i.e. by means of magic
> SysRequest.

Under OOM situation, writing to a file on disk unlikely works. Maybe
logging via network ( "cat /debug/trace/trace_pipe > /dev/udp/$ip/$port"
if your are using bash) works better. (I wish we can do it from kernel
so that /bin/cat is not disturbed by delays due to page fault.)

If you can configure netconsole for logging OOM killer messages and
UDP socket for logging trace_pipe messages, udplogger at
https://osdn.net/projects/akari/scm/svn/tree/head/branches/udplogger/
might fit for logging both output with timestamp into a single file.

