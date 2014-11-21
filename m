Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49092 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189AbaKULri (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Nov 2014 06:47:38 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xrmga-0002D1-5z
	for linux-btrfs@vger.kernel.org; Fri, 21 Nov 2014 12:47:36 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Nov 2014 12:47:36 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Nov 2014 12:47:36 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Changing label few times killed filesystem?
Date: Fri, 21 Nov 2014 11:47:24 +0000 (UTC)
Message-ID: <pan$7841c$b26fafa5$4aa9f26a$1eafaa30@cox.net>
References: <BLU436-SMTP7537F1DDEF63F43667E45CAB770@phx.gbl>
	<CAJCQCtQb-hyYVHvhJkS01EKpr_ekSSsuUPY5hSmd03SoGqiPXA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Thu, 20 Nov 2014 19:20:22 -0700 as excerpted:

> On Thu, Nov 20, 2014 at 6:27 PM, Boris Chernov <aqs1024@hotmail.com>
> wrote:
> 
>>     Since it failed after "checking extents" I decided to try
>> --init-extent-tree:
> 
> There might be hope yet if you didn't use --repair which is said on the
> wiki and many times on this list is kindof a last resort. But at the
> very least before going with the hammer approach you should upgrade your
> btrfs-progs which is kind old. Current is 3.17.2. I suggest upgrading
> and just posting the results from 'btrfs check <device>' without any
> options and see what you get. This check and --repair code are mostly in
> btrfs-progs, whereas the mount time fixing code is in the kernel. So
> upgrading btrfs-progs may be sufficient for your case, but ultimately it
> might be necessary to go to a newer kernel also.
> 
>> Btrfs v3.14.1

I'm with Chris here.

Additionally, I note that you (OP) are using kernel 3.15.x, while the 
entire kernel 3.15 series (which wasn't long-term supported so the last 
kernel update was shortly after 3.16 was released) is effectively 
blacklisted for btrfs, as it had a major btrfs bug in the compression 
handling code.  (However, if you are not now and never did use 
compression on that filesystem, that bug shouldn't affect you, but others 
might.)  The same bug was in 3.16.0 and 3.16.1, but was fixed in 3.16.2 
(or was it 3.16.3) plus.  So later 3.16 series kernels should be 
reasonably good.

Unfortunately, 3.17 added another bug, this time with read-only snapshot 
handling.  I don't do snapshots here and have been running it fine, but 
you'll want 3.17.2 plus if you do read-only snapshots.

I've not yet switched to kernel 3.18 series (late development stage at 
this point) here, but while there was a problem in rc4, rc5 appears to be 
good according to reports I've seen.

Meanwhile, userspace-side, there have been a number of fixes to btrfs 
check and the restore code in the 3.16 and 3.17 series, and while running 
the latest userspace isn't as critical as the kernel for normal 
operations (online operations) since for them the kernel is the 
operational code, for fixup (offline operations like btrfs check and 
btrfs restore), you really do want to be running the latest userspace, 
because in that case it's the userspace code that's actually doing the 
work.


Meanwhile, in the other subthread you mentioned not understanding 
transid.  FWIW transaction ID and generation are used interchangeably in 
btrfs discussions and refer to the the same thing -- a monotonically 
increasing number that gets bumped every time the root tree and 
superblocks are committed.  Normally later generations/transids indicate 
later commits and thus closer a filesystem state closer to current.  Note 
that you can use btrfs-show-super to display information from the 
superblocks including what it thinks the current generation/transid 
should be.

Which brings us to the output.  In most cases when there's problems with 
the transid/generation, wanted will be a bit higher than found, something 
like found 25456, wanted 25459.  That simply means that the three latest 
commits got lost somewhere and you may have to settle for an older one 
(which is where the wiki restore article you mentioned comes in).

But there were a number of reports recently where wanted was *MUCH* 
*LOWER* than found (like wanted 5, found 2753), which is what you're 
seeing.  Unfortunately I don't remember the resolution of those reports, 
or indeed, if the bug has been traced yet.

There is another bug (or possibly the above was after this one hit if it 
didn't stop further commits in some cases, thus resetting the generation 
to zero and increasing it again from there), however, where the transid 
was being zeroed.  Wanted 26473, found 0.  One of the devs mentioned 
tracing that one, tho again I'm not sure current status except that they 
mentioned it so they're obviously working on it.

To my knowledge, these were *NOT* in the context of relabeling, however, 
so it's quite possible you're seeing the one bug, and the relabeling is 
simply coincidence.

Again, however, you're running a 3.15 kernel that's effectively btrfs 
blacklisted, and and an even older 3.14 userspace.  I can't promise 
upgrading will give you an actual fix, but certainly, getting current on 
your kernel and userspace will at least get you on the same page as most 
folks here, so we know we're not dealing with old and in the case of the 
kernel known blacklisted versions, and the bugs in play will at least be 
current ones, not long since fixed ones.  And for the kernel, avoid 3.15 
series entirely, along with early 3.16 (before 3.16.3) and 3.17 (before 
3.17.2), plus early development 3.18 (current rcs should be better).

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

