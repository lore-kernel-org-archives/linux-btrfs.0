Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50160 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbbLUDWW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Dec 2015 22:22:22 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aAr3E-0006QL-Af
	for linux-btrfs@vger.kernel.org; Mon, 21 Dec 2015 04:22:20 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Dec 2015 04:22:20 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Dec 2015 04:22:20 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: defrag vs autodefrag
Date: Mon, 21 Dec 2015 03:22:14 +0000 (UTC)
Message-ID: <pan$94ec1$5ff33cfa$9a8b6c78$1c9a4362@cox.net>
References: <CAC=t97A1S6599aHWCCin7KnFWARs_ebfK6GptAXZQbFnSio7eA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Donald Pearson posted on Sun, 20 Dec 2015 19:26:07 -0600 as excerpted:

> I read an implication in a different thread that defrag and autodefrag
> behave differently in that autodefrag is more snapshot friendly for COW
> data.
> 
> Did I understand that correctly?  I have not been doing defrag on my
> virtual machine image directory because I do use a snapshot schedule and
> the way I understood things, a defrag would basically decouple the live
> data from the snapshots and greatly increase utilization.
> 
> It sounded like autodefrag does not have this problem?

I'd definitely like more details on that myself, as Hugo did say that and 
I normally trust his advice as he's one of the few folks who can and does 
actually read the code, but spends most of his time helping admin-level 
users, not coding.  However, without further context, that claim simply 
doesn't make a lot of sense to me, so I don't really know what to make of 
it.  Was he mistaken in this case?  Is he correct and we just don't know 
the mechanism that allows autodefrag to work well here while normal 
defrag doesn't?  Are we using different definitions and thus actually 
talking about different things?  I don't know.  The claim simply doesn't 
make sense on its own, so one way or another, there's gotta be more to 
the story than other list-regular "admin level" people here seem to know.

> If that's true, is there any case where it would not be best practice to
> mount with autodefrag enabled?

The primary issue with autodefrag is performance.  You mentioned VMs, but 
didn't say how busy they are or whether you're spinning rust or SSDs, and 
both factors make a big difference.

In general, the performance issue is due to write amplification due to 
autodefrag queuing up (I believe) entire files for rewrite.  With slow 
enough media and large and rewrite-busy enough files, there simply comes 
a point at which change-writes are coming in faster than the entire file 
can be more or less constantly rewritten due to the autodefrag flag along 
with the busy VM/DB/whatever.

If the VMs/DBs/other-large-file-rewrite-apps aren't particularly busy, 
then obviously it'll take a larger file or slower media to trigger the 
problem.  Similarly, on fast media it'll take a larger file or busier 
file rewriting to trigger the problem, and if the file in question is 
small enough, the problem generally doesn't trigger because it gets 
rewritten fast enough even on slow media with a busy rewriter.

On reasonably fast SSDs, I'd say try it and see, particularly if your VM 
images tend to be under say 4 GiB, as there's a good chance they'll be 
fast enough to eliminate the problem.

Similarly, if your VMs are sitting around doing nothing a lot of the time 
anyway and/or if when they are busy their work isn't time critical so you 
don't care about the autdefrag file rewrite bottlenecking, it's worth at 
least a try.

As for file size, under a quarter GiB (which would I guess be a pretty 
rare VM, but it covers most trivial SQLite databases, like those firefox 
and thunderbird use, quite well) people rarely have problems.  At half a 
GiB, some are reporting issues, and by a GiB size, most on spinning rust 
will be seeing a noticeable slowdown.  Unfortunately, I guess most VM 
images are multiple GiB, so the VM-use-case on spinning rust isn't likely 
to be a good match, unless of course the VMs simply aren't busy enough to 
make it an issue.

Assuming you do decide to try autodefrag...

Note that if you turn on autodefrag on already heavily fragmented files 
such as yours are likely to be, with enough fragmentation that existing 
free space is likely to be quite fragmented as well so the initial 
rewrite isn't going to be able to fix it, you're likely to see a much 
higher initial hit, until fragmentation calms down quite a bit, than you 
would had you been running autodefrag the entire time.

So assuming you have the additional space and time available to do so, it 
may be worth copying the existing VM images over to a fresh btrfs, 
mounted with autodefrag from the get-go, so they start unfragmented and 
you don't have that huge initial hit to take before things calm down.

(That's what I've done with all my btrfs here, mounted with autodefrag 
from the very first mount.  Tho my use-case doesn't involve VMs or 
snapshots, so it's unsurprising I've not personally had to deal with 
this, the primary autodefrag issue, in my own usage.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

