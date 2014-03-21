Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36251 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbaCUFpJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Mar 2014 01:45:09 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WQsGR-0007jT-Mw
	for linux-btrfs@vger.kernel.org; Fri, 21 Mar 2014 06:45:07 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Mar 2014 06:45:07 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Mar 2014 06:45:07 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH] Btrfs: fix deadlock with nested trans handles
Date: Fri, 21 Mar 2014 05:44:41 +0000 (UTC)
Message-ID: <pan$51664$6e2e2da0$3ae011f3$4e915a26@cox.net>
References: <1394150467-5990-1-git-send-email-jbacik@fb.com>
	<20140307002549.GC16439@lenny.home.zabbo.net>
	<CAGfcS_nPkVR3Z8JHi=g1QFdvqqYBeVSATjyi+4qfyWTs_5_tDQ@mail.gmail.com>
	<53207C4B.6020000@fb.com>
	<CAGfcS_ktoasT-esMTcLbF+o_-4KTirZghtJ5+o4goZDTY4DW0A@mail.gmail.com>
	<CAGfcS_=AZLFtnQfKaoDtnJB9n_PrKsNkhcQFM+g--SCwV+43Fg@mail.gmail.com>
	<pan$3aea$2e15c040$920db11$3a1e73c1@cox.net>
	<CAGfcS_mZ9=gmdxyn0jj_xKFK7XiejCACe84knzoJfC9gkg7CNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rich Freeman posted on Thu, 20 Mar 2014 22:13:51 -0400 as excerpted:

> However, I am my snapshots one at a time at a rate of one every 5-30
> minutes, and while that is creating surprisingly high disk loads on my
> ssd and hard drives, I don't get any panics.  I figured that having only
> one deletion pending per checkpoint would eliminate locking risk.
> 
> I did get some blocked task messages in dmesg, like:
> [105538.121239] INFO: task mysqld:3006 blocked for more than 120
> seconds.

These... are a continuing issue.  The devs are working on it, but...

The people that seem to have it the worst are doing both scripted 
snapshotting and large (gig+) constantly internal-rewritten files such as 
VM images (the most commonly reported case) or databases.  Properly 
setting NOCOW on the files[1] helps, but...

* The key thing to realize about snapshotting continually rewritten NOCOW 
files is that the first change to a block after a snapshot by definition 
MUST be COWed anyway, since the file content has changed from that of the 
snapshot.  Further writes to the same block (until the next snapshot) 
will be rewritten in-place (the existing NOCOW attribute  is maintained 
thru that mandatory COW), but next snapshot and following write, BAM! 
gotta COW again!

So while NOCOW helps, in scenarios such as hourly snapshotting of active 
VM-image data loads its ability to control actual fragmentation is 
unfortunately rather limited.  And it's precisely this fragmentation that 
appears to be the problem! =:^(

It's almost certainly that fragmentation that's triggering your blocked 
for X seconds issues.  But the interesting thing here is the reports even 
from people with fast SSDs where seek-time and even IOPs shouldn't be a 
huge issue.  In at least some cases, the problem has been CPU time, not 
physical media access.

Which is one reason the snapshot-aware-defrag was disabled again 
recently, because it simply wasn't scaling.  (To answer the question, 
yes, defrag still works; it's only the snapshot-awareness that was 
disabled.  Defrag is back to dumbly ignoring other snapshots and simply 
defragging the working file-extent-mapping the defrag is being run on, 
with other snapshots staying untouched.)  They're reworking the whole 
feature now in ordered to scale better.

But while that considerably reduces the pain point, people were seeing 
little or no defrag/balance/restripe progress in /hours/ if they had 
enough snapshots and that problem has been bypassed for the moment, we're 
still left with these nasty N-second stalls at times, especially when 
doing anything else involving those snapshots and the corresponding 
fragmentation they cover, including deleting them.  Hopefully tweaking 
the algorithms and eventually optimizing can do away with much of this 
problem eventually, but I've a feeling it'll be around to some degree for 
some years.

Meanwhile, for data that fits that known problematic profile, the current 
recommendation is, preferably, to isolate it to a subvolume that has only 
very limited or no snapshotting done.

The other alternative, of course, since NOCOW already turns off many of 
the features a lot of people are using btrfs for in the first place 
(checksumming and compression are disabled with NOCOW as well, tho it 
turns out they're not so well suited to VM images in the first place), is 
that given the subvolume isolation already, just stick it on an entirely 
different filesystem, either btrfs with the nocow mount option, or 
arguably something a bit more traditional and mature such as ext4 or xfs, 
where xfs of course is actually targeted at large to huge file use-cases 
so multi-gig VMs should be an ideal fit.  Of course you lose the benefits 
of btrfs doing that, but given its COW nature, btrfs arguably isn't the 
ideal solution for such huge internal-write files in the first place, and 
even when fully mature will likely only have /acceptable/ performance 
with them as suitable for use as a general purpose filesystem, with xfs 
or similar still likely being a better dedicated filesystem for such use-
cases.

Meanwhile, I think everyone agrees that getting that locking down to 
avoid the deadlocks, etc, really must be priority one, at least now that 
the huge scaling blocker of snapshot-aware-defrag is (hopefully 
temporarily) disabled.  Blocking for a couple minutes at a time certainly 
isn't ideal, but since the triggering jobs such as snapshot deletion, 
etc, can be rescheduled to otherwise idle time, that's certainly less 
critical than crashes if people accidentally or in ignorance queue up too 
many snapshot deletions at a time!

---
[1] NOCOW: chattr +C .  With btrfs, this should be done while the file is 
zero-size, before it has content.  The easiest way to do that is to 
create a dedicated directory for these files and set the attribute on the 
directory, such that the files inherit it at file creation.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

