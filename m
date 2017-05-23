Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:35856 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752114AbdEWRP3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 May 2017 13:15:29 -0400
Date: Tue, 23 May 2017 10:15:24 -0700
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20170523171524.ckyccsvlos3vjzqp@merlins.org>
References: <20170521214733.c62v7el4g66jf63x@merlins.org>
 <20170521234557.pu3vs3igdx7mqjzb@merlins.org>
 <20170522013553.hspdrwpmxe5kyoas@merlins.org>
 <pan$df61e$e305754a$711742a$a2be8e5d@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$df61e$e305754a$711742a$a2be8e5d@cox.net>
Subject: Re: 4.11.1: cannot btrfs check --repair a filesystem, causes heavy
 memory stalls
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 22, 2017 at 09:19:34AM +0000, Duncan wrote:
> btrfs check is userspace, not kernelspace.  The btrfs-transacti threads 

That was my understanding, yes, but since I got it to starve my system,
including in kernel OOM issues I pasted in my last message and just
referenced in https://bugzilla.kernel.org/show_bug.cgi?id=195863 I think
it's not much as black and white as running a userland process that
takes too much RAM and get killed if it does.

> are indeed kernelspace, but the problem would appear to be either IO or 
> memory starvation triggered by the userspace check hogging all available 
> resources, not leaving enough for normal system, including kernel, 
> processes.

Looks like it, but also memory.

> * Keeping the number of snapshots as low as possible is strongly 
> recommended by pretty much everyone here, definitely under 300 per 
> subvolume and if possible, to double-digits per subvolume.

I agree that fewer snapshots is better, but between recovery snapshots
and btrfs snapshots for some amount of subvolumes, things add up :)

gargamel:/mnt/btrfs_pool1# btrfs subvolume list . | wc -l
93
gargamel:/mnt/btrfs_pool2# btrfs subvolume list . | wc -l
103

> * I personally recommend disabling qgroups, unless you're actively 
> working with the devs on improving them.  In addition to the scaling 
> issues, quotas simply aren't reliable enough on btrfs yet to rely on them 
> if the use-case requires them (in which case using a mature filesystem 
> where they're proven to work is recommended), and if it doesn't, there's 
> simply too many remaining issues for the qgroups option to be worth it.
 
I had consider using them at some point for each size of each subvolume
but good to know they're still not ready quite yet.

> * I personally recommend keeping overall filesystem size to something one 
> can reasonably manage.  Most people's use-cases aren't going to allow for 
> an fsck taking days and tens of GiB, but /will/ allow for multi-TB 
> filesystems to be split out into multiple independent filesystems of 
> perhaps a TB or two each, tops, if that's the alternative to multiple-day 
> fscks taking tens of GiB.  (Some use-cases are of course exceptions.)

fsck ran in 6H with bcache, but the lowmem one could take a lot longer.
Running over ndb to another host with more RAM could indeed take days
given the loss of bcache and adding the latency/bandwidth of a
networkg.

> * The low-memory-mode btrfs check is being developed, tho unfortunately 
> it doesn't yet do repairs.  (Another reason is that it's an alternate 
> implementation that provides a very useful second opinion and the ability 
> to cross-check one implementation against the other in hard problem 
> cases.)

True.

> >> Sadly, I tried a scrub on the same device, and it stalled after 6TB.
> >> The scrub process went zombie and the scrub never succeeded, nor could
> >> it be stopped.
> 
> Quite apart from the "... after 6TB" bit setting off my own "it's too big 
> to reasonably manage" alarm, the filesystem obviously is bugged, and 
> scrub as well, since it shouldn't just go zombie regardless of the 
> problem -- it should fail much more gracefully.
 
:)
In this case it's mostly big files, so it's fine metadata wise but takes
a while to scrub (<24H though).

The problem I had is that I copied all of dshelf2 onto dshelf1 while I
blew ds2, and rebuilt it. That extra metadata (many smaller files)
tipped the metadata size of ds1 over the edge.
Once I blew that backup, things became ok again.

> Meanwhile, FWIW, unlike check, scrub /is/ kernelspace.

Correct, just like balance.

> As explained, check is userspace, but as you found, it can still 
> interfere with kernelspace, including unrelated btrfs-transaction 
> threads.  When the system's out of memory, it's out of memory.
 
userspace should not take the entire system down without the OOM killer
even firing.
Also, is the logs I just sent, it showed that none of my swap space had
been used. Why would that be?

> Tho there is ongoing work into better predicting memory allocation needs 
> for btrfs kernel threads and reserving memory space accordingly, so this 
> sort of thing doesn't happen any more.

That would be good.

> Agreed.  Lowmem mode looks like about your only option, beyond simply 
> blowing it away, at this point.  Too bad it doesn't do repair yet, but 

it's not an option since it won't fix the small corruption issue I had.
Thankfully deleting enough metadata allowed it to run within my RAM and
check --repair fixed it now.

> with a bit of luck it should at least give you and the devs some idea 
> what's wrong, information that can in turn be used to fix both scrub and 
> normal check mode, as well as low-mem repair mode, once it's available.

In this case, not useful information for the devs. It's a bad SAS card
that corrupted my data, not a bug in the kernel code.

> Of course your "days" comment is triggering my "it's too big to maintain" 
> reflex again, but obviously it's something you've found to be tolerable 

days would refer to either "lowmem" or "btrfs check over ndb" :)

Cheers,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
