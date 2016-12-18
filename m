Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:60778 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932283AbcLRAfC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Dec 2016 19:35:02 -0500
MIME-Version: 1.0
Message-ID: <trinity-d2929a62-d9ee-4778-aad2-cf8a2ae0494f-1482020895677@3capp-mailcom-bs06>
From: "Xin Zhou" <xin.zhou@gmx.com>
To: "Tetsuo Handa" <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: OOM: Better, but still there on
Content-Type: text/plain; charset=UTF-8
Date: Sun, 18 Dec 2016 01:28:15 +0100
In-Reply-To: <862a1ada-17f1-9cff-c89b-46c47432e89f@I-love.SAKURA.ne.jp>
References: <20161216073941.GA26976@dhcp22.suse.cz>
 <20161216155808.12809-1-mhocko@kernel.org>
 <20161216184655.GA5664@boerne.fritz.box>
 <20161217000203.GC23392@dhcp22.suse.cz>
 <20161217125950.GA3321@boerne.fritz.box>,
 <862a1ada-17f1-9cff-c89b-46c47432e89f@I-love.SAKURA.ne.jp>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
The system supposes to have special memory reservation for coredump and other debug info when encountering panic,
the size seems configurable.
Thanks,
Xin
 
 

Sent: Saturday, December 17, 2016 at 6:44 AM
From: "Tetsuo Handa" <penguin-kernel@I-love.SAKURA.ne.jp>
To: "Nils Holland" <nholland@tisys.org>, "Michal Hocko" <mhocko@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, "Chris Mason" <clm@fb.com>, "David Sterba" <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: OOM: Better, but still there on
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

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at http://vger.kernel.org/majordomo-info.html[http://vger.kernel.org/majordomo-info.html]
