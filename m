Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50284 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942AbcC1IvX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Mar 2016 04:51:23 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1akStM-0008Bg-GC
	for linux-btrfs@vger.kernel.org; Mon, 28 Mar 2016 10:51:20 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Mar 2016 10:51:20 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Mar 2016 10:51:20 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Raid 0 setup doubt.
Date: Mon, 28 Mar 2016 08:51:12 +0000 (UTC)
Message-ID: <pan$371b2$4e875ee0$31aca9be$a76ec9b6@cox.net>
References: <56F7B77F.9050306@gmail.com>
	<pan$8fc2c$862a26c8$c5af9279$b4bfa8ec@cox.net>
	<001c01d188b2$732fbe40$598f3ac0$@codenest.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

James Johnston posted on Mon, 28 Mar 2016 05:26:56 +0000 as excerpted:

> For me, I use swap on an SSD, which is orders of magnitude faster than
> HDD.
> Swap can still be useful on an SSD and can really close the gap between
> RAM speeds and swap speeds.  (The original poster would do well to use
> one.)

FWIW, swap on ssd is an entirely different beast, and /can/ still make 
quite a lot of sense.  I'll absolutely agree with you there.

However, this wasn't about swap on ssd, it was about swap on hdd, and the 
post was already long enough, without adding in the quite different 
discussion of swap on ssd.  My posts already tend to be longer than most, 
and I have to pick /somewhere/ to draw the line.  This was simply the 
"somewhere" that I drew it in this case.

So thanks for raising the issue and filling in the missing pieces.  I 
think we agree, in general, about swap on ssd.

That said, here for example is a bit of why I ask the question, ssd or no 
ssd (spacing on free shrunk a bit for posting):

$ uptime
 00:07:50 up 11:28,  2 users,  load average: 0.04, 0.43, 1.01

$ free -m
       total   used     free   shared buff/cache available
Mem:   16073    725    12632     1231       2715     13961
Swap:      0      0        0

16 GiB RAM, 12.5 GiB entirely free even with cache and buffers taking a 
bit under 3 GiB of RAM.  That's in kde/plasma5, after nearly 12 hours 
uptime.  (Tho I am running gentoo with more stuff turned off at build-
time than will be the case on most general-purpose binary distros, where 
lots of libraries that most people won't use are linked in for the sake 
of the few that will use them.  Significantly, I also have baloo turned 
off at build time, which still unfortunately requires some trivial 
patching on gentoo/kde, and stay /well/ clear of anything kdepim/akonadi 
related as both too bloated and far too unstable to handle my mail, 
etc.)  Triple full-hd 1080 monitors.

OK, startup firefox playing a full-screen 1080p video and let it run a 
bit... about half a GiB initial difference, 1.2 GiB used, only about 12 
GiB free, then up another 200 MiB used in a few minutes.

Now this is gentoo and it's my build machine.  It's only a six-core so I 
don't go hog-wild with the parallel builds, but portage is pointed at a 
tmpfs for its temporary build environment and my normal build settings 
allow 12 builds at a time, upto a load-average of 6, and each of those 
builds is set for upto 10 parallel jobs to a load average of 8 (thus 
encouraging parallelism at the individual package level first, and only 
where that doesn't utilize all cores does it load more packages to build 
in parallel).  I sometimes see upto 9 packages building at once and 
sometimes a 1-minute load of 10 or higher when build process that are 
already setup push it above the configured load-average of 8.

I don't run any VMs (but for an old DOS game in DOSSHELL, which qualifies 
as a VM, but from an age when machines with memory in the double-digit 
MiB were high-dollar, so it hardly counts), I keep / mounted ro except 
when I'm updating it, and the partition with all the build trees, 
sources, ccache and binpkgs is kept unmounted as well when I'm not using 
it.  Further, my media partition is unmounted by default as well.

But even during a build, I seldom use up all memory and start actually 
dumping cache, so which is when stuff would start getting pushed to swap 
as well if I had it, so I don't bother.

Back on my old machine I had 8 GiB RAM and swap, with swappiness[1] set 
to 100, I'd occasionally see a few hundred MB in swap, but seldom over a 
gig.  That was with a four-device spinning-rust mdraid1 setup, with swap 
similarly set to 4-way-striped via equal swap priority, but that machine 
was an old original dual-socket 3-digit opteron maxed out with dual-core 
Opteron 290s, so 2x2=4-core, and I had it accordingly a bit more limited 
in terms of parallel build jobs.

These days the main system is on dual ssds partitioned up in parallel, 
running multiple separate btrfs-raid1s on the pairs of partitions, one on 
each of the ssds.  Only media and backups is still on spinning rust, but 
given those numbers and the fact that suspend-to-ram works well on this 
machine and I never even tried suspend-to-disk, I just didn't see the 
point of setting up swap.

When I upgraded to the new machine, given the 6-core instead of 4-core, I 
decided I wanted more memory as well.  But altho 16 GiB is the next power-
of-two above the 8 GiB I was running (actually only 6 GiB by the time I 
upgraded, as a stick had died that I hadn't replaced) and I got 16 GiB 
for that reason, 12 GiB would have actually been plenty, and would have 
served my generally don't dump cache rule pretty well.  

That became even more the case when I upgraded to SSDs shortly 
thereafter, as recaching on ssd isn't the big deal it was with spinning 
rust, where I really did hate to reboot and lose all that cache that I'd 
have to read off of slow spinning rust again.

Which I guess goes to support the argument I had thought about making in 
the original post and then left out, intending to followup on it if the 
OP posted memory size and usage, etc, details.  If he's running 16 GiB as 
I am, and is seeing GiB worth of memory sit entirely unused, even for 
cache, most of the time as I am, then really, there's little need for 
swap.  That may actually be the case even with 8 GiB RAM, if his files 
working set is small enough.

OTOH, if he's only running a 4 GiB RAM or less system or his top-line 
free value (before cache and buffers are subtracted) is often under say 
half a GiB to a GiB, then chances are he's dumping cache at times and can 
use either more ram or swap (possibly with a tweaked swappiness), as on 
spinning rust dumped cache can really hurt performance, and thus really 
/hurts/ to see.

OK, here's my free -m now (minus the all-zeros swap line), after running 
a an hour or so of youtube 1080p videos in firefox (45):

      total   used   free  shared buff/cache available
Mem:  16073   1555  11769    1245       2748     13116

Tho it does get up there to around 12 GiB used (incl buffer/cache), only 
about 4 GiB free if I do a big update, sometimes even a bit above that, 
but so seldom does it actually start dumping cache, that as I said, 12 
GiB would have actually been a better use of my money than the 16 I got, 
tho it wouldn't have been that nice round power-of-two.

OTOH, that /will/ let me upgrade to say an 8-core CPU and similarly 
upgrade parallel build-job settings, if I decide to, without bottlenecking 
on memory, always a nice thing. =:^)

---
[1] Swappiness:  The /proc/syst/vm/swappiness knob, configurable via 
sysctl on most distros.  Set to 100 it says always swap out instead of 
dumping cache; set to 0 it says always dump cache to keep apps from 
swapping; the default is normally 60, IIRC.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

