Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:49903 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730180AbeGRAlO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jul 2018 20:41:14 -0400
Subject: Re: btrfs check (not lowmem) and OOM-like hangs (4.17.6)
To: Marc MERLIN <marc@merlins.org>, Su Yue <Damenly_Su@gmx.com>
Cc: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180717203257.GA10237@merlins.org>
 <20180717205905.GB10237@merlins.org>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <8a0fbf2d-ee13-f6d6-a046-5dfba936aa87@gmx.com>
Date: Wed, 18 Jul 2018 08:05:51 +0800
MIME-Version: 1.0
In-Reply-To: <20180717205905.GB10237@merlins.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年07月18日 04:59, Marc MERLIN wrote:
> Ok, I did more testing. Qu is right that btrfs check does not crash the kernel.
> It just takes all the memory until linux hangs everywhere, and somehow (no idea why) 
> the OOM killer never triggers.

No OOM triggers? That's a little strange.
Maybe it's related to how kernel handles memory over-commit?

And for the hang, I think it's related to some memory allocation failure
and error handler just didn't handle it well, so it's causing deadlock
for certain page.

ENOMEM handling is pretty common but hardly verified, so it's not that
strange, but we must locate the problem.

> Details below:
> 
> On Tue, Jul 17, 2018 at 01:32:57PM -0700, Marc MERLIN wrote:
>> Here is what I got when the system was not doing well (it took minutes to run):
>>
>>              total       used       free     shared    buffers     cached
>> Mem:      32643788   32070952     572836          0     102160    4378772
>> -/+ buffers/cache:   27590020    5053768
>> Swap:     15616764     973596   14643168
> 
> ok, the reason it was not that close to 0 was due to /dev/shm it seems.
> I cleared that, and now I can get it to go to near 0 again.
> I'm wrong about the system being fully crashed, it's not, it's just very
> close to being hung.
> I can type killall -9 btrfs in the serial console and wait a few minutes.
> The system eventually recovers, but it's impossible to fix anything via ssh 
> apparently because networking does not get to run when I'm in this state.
> 
> I'm not sure why my system reproduces this easy while Qu's system does not, 
> but Qu was right that the kernel is not dead and that it's merely a problem of userspace
> taking all the RAM and somehow not being killed by OOM

In my system, at least I'm not using btrfs as root fs, and for the
memory eating program I normally ensure it's eating all the memory +
swap, so OOM killer is always triggered, maybe that's the cause.

So in your case, maybe it's btrfs not really taking up all memory, thus
OOM killer not triggered.

> 
> I checked the PID and don't see why it's not being killed:
> gargamel:/proc/31006# grep . oom*
> oom_adj:0
> oom_score:221   << this increases a lot, but OOM never kills it
> oom_score_adj:0
> 
> I have these variables:
> /proc/sys/vm/oom_dump_tasks:1
> /proc/sys/vm/oom_kill_allocating_task:0
> /proc/sys/vm/overcommit_kbytes:0
> /proc/sys/vm/overcommit_memory:0
> /proc/sys/vm/overcommit_ratio:50  << is this bad (seems default)

Any kernel dmesg about OOM killer triggered?

> 
> Here is my system when it virtually died:
> ER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
> root     31006 21.2 90.7 29639020 29623180 pts/19 D+ 13:49   1:35 ./btrfs check /dev/mapper/dshelf2
> 
>              total       used       free     shared    buffers     cached
> Mem:      32643788   32180100     463688          0      44664     119508
> -/+ buffers/cache:   32015928     627860
> Swap:     15616764     443676   15173088

For swap, it looks like only some other program's memory is swapped out,
not btrfs'.

And unfortunately, I'm not so familiar with OOM/MM code outside of
filesystem.
Any help from other experienced developers would definitely help to
solve why memory of 'btrfs check' is not swapped out or why OOM killer
is not triggered.

Thanks,
Qu

> 
> MemTotal:       32643788 kB
> MemFree:          463440 kB
> MemAvailable:      44864 kB
> Buffers:           44664 kB
> Cached:           120360 kB
> SwapCached:        87064 kB
> Active:         30381404 kB
> Inactive:         585952 kB
> Active(anon):   30334696 kB
> Inactive(anon):   474624 kB
> Active(file):      46708 kB
> Inactive(file):   111328 kB
> Unevictable:        5616 kB
> Mlocked:            5616 kB
> SwapTotal:      15616764 kB
> SwapFree:       15173088 kB
> Dirty:              1636 kB
> Writeback:             4 kB
> AnonPages:      30734240 kB
> Mapped:            67236 kB
> Shmem:              3036 kB
> Slab:             267884 kB
> SReclaimable:      51528 kB
> SUnreclaim:       216356 kB
> KernelStack:       10144 kB
> PageTables:        69284 kB
> NFS_Unstable:          0 kB
> Bounce:                0 kB
> WritebackTmp:          0 kB
> CommitLimit:    31938656 kB
> Committed_AS:   32865492 kB
> VmallocTotal:   34359738367 kB
> VmallocUsed:           0 kB
> VmallocChunk:          0 kB
> HardwareCorrupted:     0 kB
> AnonHugePages:         0 kB
> ShmemHugePages:        0 kB
> ShmemPmdMapped:        0 kB
> CmaTotal:          16384 kB
> CmaFree:               0 kB
> HugePages_Total:       0
> HugePages_Free:        0
> HugePages_Rsvd:        0
> HugePages_Surp:        0
> Hugepagesize:       2048 kB
> Hugetlb:               0 kB
> DirectMap4k:      560404 kB
> DirectMap2M:    32692224 kB
> 
> 
