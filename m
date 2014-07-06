Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:33235 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbaGFO60 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Jul 2014 10:58:26 -0400
Date: Sun, 6 Jul 2014 07:58:15 -0700
From: Marc MERLIN <marc@merlins.org>
To: "Andrew E. Mileski" <andrewm@isoar.ca>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20140706145815.GD15009@merlins.org>
References: <20140704011938.GO11539@merlins.org>
 <53B801DD.5040704@isoar.ca>
 <20140705144318.GT26932@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140705144318.GT26932@merlins.org>
Subject: Re: Is btrfs related to OOM death problems on my 8GB server with
 both 3.15.1 and 3.14?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jul 05, 2014 at 07:43:18AM -0700, Marc MERLIN wrote:
> On Sat, Jul 05, 2014 at 09:47:09AM -0400, Andrew E. Mileski wrote:
> > On 2014-07-03 9:19 PM, Marc MERLIN wrote:
> > >I upgraded my server from 3.14 to 3.15.1 last week, and since then it's been
> > >running out of memory and deadlocking (panic= doesn't even work).
> > >I downgraded back to 3.14, but I already had the problem once since then.
> > 
> > I didn't see any mention of the btrfs utility version in this thread
> > (I may be blind though).
> > 
> > My server was suffering from frequent panics upon scrub / defrag /
> > balance, until I updated the btrfs utility.  That resolved all my
> > issues.
> 
> Really? The userland tool should only send ioctls to the kernel, I
> really can't see how it would cause the kernel code to panic or not.
> 
> gargamel:~# btrfs --version
> Btrfs v3.14.1
> which is the latest in debian unstable.
> 
> As an update, after 1.7 days of scrubbing, the system has started
> getting sluggish, I'm getting synchronization problems/crashes in some of
> my tools that talk to serial ports (likely due to mini deadlocks in the
> kernel), and I'm now getting a few btrfs hangs.

Predictably, it died yesterday afternoon after going into memory death
(it was answering pings, but userspace was dead, and even sysrq-o did
not respond, I had to power cycle the power outlet).

This happened just before my 3rd scrub finished, so I'm now 2 out of 2:
running scrub on my 3 filesystems kills the system half way through the
3rd scrub.

This is the last memory log that reached the disk:
http://marc.merlins.org/tmp/btrfs-oom2.txt

Do those logs point to any possible culprit, or a kernel memory leak
cannot be pointed to its source because the kernel loses track of who
requested the memory that leaked?


Excerpt here:
Sat Jul  5 14:25:04 PDT 2014
             total       used       free     shared    buffers     cached
Mem:       7894792    7712384     182408          0         28     227480
-/+ buffers/cache:    7484876     409916
Swap:     15616764     463732   15153032

Userspace is using 345MB according to ps

Sat Jul  5 14:25:04 PDT 2014
MemTotal:        7894792 kB
MemFree:          184556 kB
MemAvailable:     269568 kB
Buffers:              28 kB
Cached:           228164 kB
SwapCached:        18296 kB
Active:           178196 kB
Inactive:         187016 kB
Active(anon):      70068 kB
Inactive(anon):    71100 kB
Active(file):     108128 kB
Inactive(file):   115916 kB
Unevictable:        5624 kB
Mlocked:            5624 kB
SwapTotal:      15616764 kB
SwapFree:       15152768 kB
Dirty:             17716 kB
Writeback:           516 kB
AnonPages:        140588 kB
Mapped:            21940 kB
Shmem:               688 kB
Slab:             181708 kB
SReclaimable:      59808 kB
SUnreclaim:       121900 kB
KernelStack:        4728 kB
PageTables:         8480 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    19564160 kB
Committed_AS:    1633204 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      358996 kB
VmallocChunk:   34359281468 kB
HardwareCorrupted:     0 kB
AnonHugePages:         0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:      144920 kB
DirectMap2M:     7942144 kB

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
