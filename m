Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:37974 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732243AbeGLX0T (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jul 2018 19:26:19 -0400
Date: Thu, 12 Jul 2018 16:14:31 -0700
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, Su Yue <Damenly_Su@gmx.com>,
        Su Yue <suy.fnst@cn.fujitsu.com>
Subject: Re: Why original mode doesn't use swap? (Original: Re: btrfs check
 lowmem, take 2)
Message-ID: <20180712231431.u4yxi2c2kyv773td@merlins.org>
References: <20180710180915.onnxuak7vb7uywyn@merlins.org>
 <CAJCQCtRQdg56Hxk=U2JMXbE35Jj_Q5Ock_gn43jWxci4Nbs5UA@mail.gmail.com>
 <e0de5098-05ce-28f8-591c-39b87dea63fe@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <e0de5098-05ce-28f8-591c-39b87dea63fe@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 12, 2018 at 01:26:41PM +0800, Qu Wenruo wrote:
> 
> 
> On 2018年07月12日 01:09, Chris Murphy wrote:
> > On Tue, Jul 10, 2018 at 12:09 PM, Marc MERLIN <marc@merlins.org> wrote:
> >> Thanks to Su and Qu, I was able to get my filesystem to a point that
> >> it's mountable.
> >> I then deleted loads of snapshots and I'm down to 26.
> >>
> >> IT now looks like this:
> >> gargamel:~# btrfs fi show /mnt/mnt
> >> Label: 'dshelf2'  uuid: 0f1a0c9f-4e54-4fa7-8736-fd50818ff73d
> >>         Total devices 1 FS bytes used 12.30TiB
> >>         devid    1 size 14.55TiB used 13.81TiB path /dev/mapper/dshelf2
> >>
> >> gargamel:~# btrfs fi df /mnt/mnt
> >> Data, single: total=13.57TiB, used=12.19TiB
> >> System, DUP: total=32.00MiB, used=1.55MiB
> >> Metadata, DUP: total=124.50GiB, used=115.62GiB
> >> Metadata, single: total=216.00MiB, used=0.00B
> >> GlobalReserve, single: total=512.00MiB, used=0.00B
> >>
> >>
> >> Problems
> >> 1) btrfs check --repair _still_ takes all 32GB of RAM and crashes the
> >> server, despite my deleting lots of snapshots.
> >> Is it because I have too many files then?
> > 
> > I think originally needs most of metdata in memory.
> > 
> > I'm not understanding why btrfs check won't use swap like at least
> > xfs_repair and pretty sure e2fsck will as well.
> 
> I don't understand either.
> 
> Isn't memory from malloc() swappable?

I never looked at the code and why/how it crashes, but my guess was
that it somehow causes the kernel to grab a lot of memory in the btrfs
driver and that is what is what is crashing the system.
If it were just malloc() the btrfs user space tool, it should be both
swappable like you said, and should also get OOM'ed.

I suppose I can still be completely wrong, but I can't find another
logical explanation.

I just tried running it again to trigger the problem, but because I
freed a lot of snapshots, btrfs check --repair goes back to only using
10GB instead of 32GB, so I wasn't able to replicate OOM for you.

Incidently, it died with:
gargamel:~# btrfs check --repair /dev/mapper/dshelf2
enabling repair mode
Checking filesystem on /dev/mapper/dshelf2
UUID: 0f1a0c9f-4e54-4fa7-8736-fd50818ff73d
root 18446744073709551607 has a root item with a more recent gen (143376) compared to the found
 root node (139061)
ERROR: failed to repair root items: Invalid argument

That said, when it was using a fair amount of RAM, I captured this:
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root      1376  1.4 25.2 8256368 8240392 pts/18 R+  14:52   1:07 btrfs check --repair /dev/mapper/dshelf2

I don't know how to read /proc/meminfo, but that's what it said:
MemTotal:       32643792 kB
MemFree:         1367516 kB
MemAvailable:   15554836 kB
Buffers:         3491672 kB
Cached:         15900320 kB
SwapCached:         2092 kB
Active:         14577228 kB
Inactive:       15028608 kB
Active(anon):   12122180 kB
Inactive(anon):  2643176 kB
Active(file):    2455048 kB
Inactive(file): 12385432 kB
Unevictable:        8068 kB
Mlocked:            8068 kB
SwapTotal:      15616764 kB   < swap was totally unused and stays unused when I get the system to crash 
SwapFree:       15578020 kB
Dirty:             71956 kB
Writeback:            64 kB
AnonPages:      10219976 kB
Mapped:          4033568 kB
Shmem:           4545552 kB
Slab:             713300 kB
SReclaimable:     395508 kB
SUnreclaim:       317792 kB
KernelStack:       11788 kB
PageTables:        52592 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    31938660 kB
Committed_AS:   20070736 kB
VmallocTotal:   34359738367 kB
VmallocUsed:           0 kB
VmallocChunk:          0 kB
HardwareCorrupted:     0 kB
AnonHugePages:         0 kB
ShmemHugePages:        0 kB
ShmemPmdMapped:        0 kB
CmaTotal:          16384 kB
CmaFree:               0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
Hugetlb:               0 kB
DirectMap4k:     1207572 kB
DirectMap2M:    32045056 kB

Does it help figure out where the memory was going and wehther kernel
memory was being used?

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
