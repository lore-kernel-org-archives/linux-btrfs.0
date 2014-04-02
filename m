Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51695 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011AbaDCNfV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Apr 2014 09:35:21 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WVgwB-000344-AY
	for linux-btrfs@vger.kernel.org; Thu, 03 Apr 2014 14:40:07 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Apr 2014 14:40:07 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Apr 2014 14:40:07 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS hangs - possibly NFS related?
Date: Wed, 2 Apr 2014 06:58:53 +0000 (UTC)
Message-ID: <pan$1bfd3$d8184f3c$26ab13aa$2e81c88f@cox.net>
References: <019301cf4da9$bf837930$3e8a6b90$@bluemoose.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

kim-btrfs posted on Tue, 01 Apr 2014 13:56:06 +0100 as excerpted:

> Apologies if this is known, but I've been lurking a while on the list
> and not seen anything similar - and I'm running out of ideas on what to
> do next to debug it.
> 
> Small HP microserver box, running Debian, EXT4 system disk plus 4 disk
> BTRFS array shared over NFS (nfs-kernel-server) and SMB - the disks
> recently moved from a different box where they've been running
> faultlessly for months, although that didn't use NFS.

First off I have absolutely zero experience with NFS or SMB, so if it has 
anything at all to do with that, I'd be clueless.  That said, I do know a 
few other things to look at, and some idea of how to look at them.  The 
below is what I'd be looking at were it me.

> Under reasonable combined NFS and SMB load with only a couple of
> clients, the shares lock up, load average on server and clients goes
> high and stays high (10-12) and stays there.     Apparently not actually
> CPU and there's little if any disk activity on the server.

First thing, high load, but little CPU and little I/O.  That's very 
strange, but there's a few things besides that to check to see if you can 
run down where all that load is going.

With the right tools CPU/load can be categorized into several areas, low-
priority/niced, normal, kernel, IRQ, soft-IRQ, IO-wait, steal, guest, 
altho steal and guest are VM related (steal is CPU taken by the hypervisor 
or another guest if measured from within a guest, and thus not available 
to it, quest is of course guests, when measured from the hypervisor) and 
will be zero if you're not running them, and irq and soft-irq won't show 
much either in the normal case.  And of course niced doesn't show either 
unless you're running something niced.

What I'm wondering here is if it's all going to IO-wait as I suspect... 
or something else.

If you don't have a tool that shows all that, one available tool that 
does is htop.  It's a "better" top, ncurses/semi-gui-based so run it in a 
terminal window or text-login VT.

Of course you can see which threads are using all that CPU-time "load" 
that isn't, while you're at it.

Also check out iotop, to see what processes are actually doing IO and the 
total IO speed.  Both these tools have manpages...

What could be interesting is what happens when you do that sync.  Does a 
thread or several threads spring to life momentarily (say in iotop) and 
then idle again, or... ?

> Killing NFS and/or Samba sometimes helps, but it's always back when the
> load comes back on. Chased round NFS and Samba options, then find that
> when the clients hang it's unresponsive on the server directly to the
> disk.
> 
> Notice  a "btrfs-transacti" process hung in "d".    As are all the NFS
> processes:
> 
> 3779 ?        S<     0:00 [nfsd4]
> 3780 ?        S<     0:00 [nfsd4_callbacks]
> 3782 ?        D      0:27 [nfsd]
> 3783 ?        D      0:27 [nfsd]
> 3784 ?        D      0:28 [nfsd]
> 3785 ?        D      0:26 [nfsd]
> 
> "sync" instantly unsticks everything and it all works again for another
> couple of minutes, when it locks up again, same symptoms.     Nothing
> apparently written to kern.log or dmesg, which has been the frustration
> all through - I don't know where to find the culprit!
> 
> As a band-aid I've put btrfs filesystem sync /mnt/btrfs
> 
> In the crontab once a minute which is actually working just fine  and
> has been all morning - every 5 minutes was not enough.
> 
> Any recommendations on where I can look next, or any known holes I've
> fallen in.?  Do I need to force NFS clients to sync in their mount
> options?
> 
> 
> Background:
> Kernel - 3.13-1-amd64 #1 SMP Debian 3.13.7-1 (2014-03-25)    AMD N54L
> with 10GB RAM.
> 
> ##################################################
>	Total devices 4 FS bytes used 848.88GiB
>	devid    2 size 465.76GiB used 319.03GiB path /dev/sdc
>	devid    4 size 465.76GiB used 319.00GiB path /dev/sda
>	devid    5 size 455.76GiB used 309.03GiB path /dev/sdb2
>	devid    6 size 931.51GiB used 785.00GiB path /dev/sdd
> 
> ##################################################

OK, so you're not full allocation.  No problem there.

> Data, RAID1: total=864.00GiB, used=847.86GiB
> System, RAID1: total=32.00MiB, used=128.00KiB
> Metadata, RAID1: total=2.00GiB, used=1009.93MiB

That looks healthy. 

> A "scrub" passes without finding any errors.
> 
> There are a couple of VM images with light traffic which do fragment a
> little but I manually defrag those every day so often and I haven't had
> any problems there - it certainly isn't thrashing.

If you've been following the list, I'm surprised you didn't mention 
whether you're doing snapshotting at all.  I'll assume that means no, or 
only very light/manual snapshotting (as I have here).


My guess is that it might be fragmentation of something other than the 
VMs.  You're not mounting with autodefrag, I take it?  What about 
compress?  Do you have any other large actively written files, perhaps 
databases or pre-allocated-file torrent downloading going on?  How big 
are they if so, and what does filefrag say about them?  (Note that the 
reason I mentioned the compress option is that filefrag doesn't 
understand btrfs compression and counts it as fragmentation, so any files 
over ~128 MiB that btrfs compresses will appear fragmented.  Also, btrfs 
data chunks are 1 GiB in size so anything over a gig will likely show a 
few fragments due simply to data chunk breaks.)

For autodefrag, note that if you try it on a btrfs that has been used 
some time without it and thus has some fragmentation, you'll likely see 
lower performance until it catches up.  One way around that is a 
recursive defrag of everything, so when you turn on autodefrag it only 
has to maintain, not catch up.

And for the VM images (and databases and pre-allocated torrent 
downloads), you can try setting NOCOW (tho if you're doing automated 
snapshots it may not help /that/ much).  I'll assume you've seen some of 
the discussion of that and know why/how to set it on the directory before 
putting the files in it so they inherit the attribute, so I don't have to 
explain that.

Tho the one thing that puzzles me is that sync behavior; nobody else has 
reported anything like that that I'm aware of, so I'd guess it either 
didn't occur to anyone else to try that, or possibly, whatever it is 
you're seeing isn't reported that often, and you may actually be the 
first to report it.

One other thing I've seen the devs mention:  When you see this happening 
and the blocked tasks, try:

echo w > /proc/sysrq-trigger

(or simply use the alt-srq-w combo if you're on x86 and have it 
available, there's more about magic-srq in the kernel's Documentation/
sysrq.txt file).  Assuming the appropriate srq functionality is built 
into your kernel and enabled, that should dump blocked tasks to the 
console.  That can be very useful to the devs looking into your problem.

Anyway, those are kind of broad shots in the dark in the hope they make 
contact with something worth reporting.  Hopefully they do turn up 
something...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

