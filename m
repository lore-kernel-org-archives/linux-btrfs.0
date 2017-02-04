Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:38090 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1753925AbdBDICP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Feb 2017 03:02:15 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cZvIL-0005FZ-B1
        for linux-btrfs@vger.kernel.org; Sat, 04 Feb 2017 09:02:05 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs_drop_snapshot "IO failure" after RAID controller reset
Date: Sat, 4 Feb 2017 08:01:58 +0000 (UTC)
Message-ID: <pan$e7a94$d628e922$db901c46$34e93f33@cox.net>
References: <20170203101652.6AE60121A@mail.linux-ag.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Juergen 'Louis' Fluk posted on Fri, 03 Feb 2017 11:16:51 +0100 as
excerpted:

> The server is running kernel 3.19.0-79-generic (ubuntu 14.04),
> btrfs-tools 3.12-1ubuntu0.1.
> Does it make sense to use newer kernel and/or tools to recover?

I'm not a dev, just a list regular and btrfs user, but I can answer this 
part. =:^)

General list policy is that btrfs is still under heavy development and 
stabilization, not fully stable and mature.  And we're focused on forward 
development, not history.  As such, staying /relatively/ current is 
strongly recommended.  For the kernel, we best support the last two 
kernel release series in one of two tracks, current or LTS.  On the LTS 
track, that's 4.4 and 4.1.  On the current track, 4.9 is out and 4.10 is 
getting close, so it's currently 4.9 and 4.8, but will soon be 4.10 and 
4.9.

For the btrfs userspace (btrfs-progs), during normal operation it's the 
kernel doing most of the work, with userspace simply calling the kernel 
to do it, so userspace doesn't matter quite so much as long as it 
supports the features you are using.  However, once something goes wrong 
and you're trying to recover, userspace code gets its workout, so that's 
when you need newer userspace.  However, get /too/ far out of date and 
the commands have changed enough that someone, either user side or helper 
side, has to translate between old form and new form, making things 
harder.  As a result, given that the kernel and userspace releases are 
version-synced, with similar versions developed with the same problems 
being worked on at the time, a good rule of thumb is use a userspace 
similar in version to your kernel space and it won't get too outdated.

Now we recognize that some distros support btrfs on older code, and 
that's fine, but that's their support, not ours, and they're best 
positioned to give it, since we don't track what patches they may have 
backported and what not, all we see is the old version number and think 
how many bugs have been fixed since then.  So your best bet if you want 
to stay with an older distro supported kernel is to actually use that 
distro support.

Meanwhile, while kernel 3.19 isn't /too/ far back from the oldest LTS 
supported 4.1, the 3.12 userspace is positively /ancient/ /history/!  
Consider that it wasn't until 3.12 or 3.14 (I've forgotten exacty) that 
the experimental, might eat your kids, level label, was stripped from 
btrfs, and we went to heavy development but stabilizing, and you see just 
how bad 3.12 looks... it was basically still experimental level!

So definitely, for this list, trying with something newer, at /least/ 4.1 
LTS and preferably at least 4.4 LTS as it has been out for quite awhile 
now, should be one of the first things to try.  If the problem's still 
there with that, then at least your posted logs, etc, will still have at 
least /some/ relevance to current development, not simply look like 
artifacts from ancient history.

Or as I said, try your distro, as they're best positioned to support the 
longer term stuff they offer.

Meanwhile, a standard point/question I make/ask when people post with 
such stale^H^Hble software, is whether they're actually sure they chose 
the best filesystem for their needs.  As I said, btrfs is still under 
heavy development, stabilizing and maturing, and there are still critical 
bugs showing up from time to time, as well as continuing development 
challenges where existing features stil don't work as well as we'd like.  
By contrast, people generally choose to run such stale^H^Hble distros for 
their long-term stable support.  That would seem to be enough of a mis-
match that it's worth asking yourself whether perhaps you need to 
reevaluate your choices and maybe change one or the other.  If you need 
stable and mature, btrfs isn't likely to be an appropriate choice.  OTOH, 
if you like the new features and can live with a bit less predictability 
in terms of known and tested stability, then btrfs may be correct, but it 
would be the older "stable" distro that may be inappropriate to your 
needs.  They just don't seem to be a particularly good match, at least 
for the general case.  That isn't to say it's the /wrong/ choice for your 
particular use-case, but it's worth considering a reevaluation to be 
sure, if you haven't asked yourself that sort of questions, recently.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

