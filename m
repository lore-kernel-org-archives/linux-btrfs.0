Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:59991 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750945AbdJDHBm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Oct 2017 03:01:42 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dzdgI-0001kt-Ue
        for linux-btrfs@vger.kernel.org; Wed, 04 Oct 2017 09:01:22 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Kickstarting snapshot-aware defrag?
Date: Wed, 4 Oct 2017 07:01:10 +0000 (UTC)
Message-ID: <pan$62483$d5c7557$57c5c20e$94893772@cox.net>
References: <ec17105e-5602-4afd-96d5-77b871051184@linuxsystems.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Niccolò Belli posted on Tue, 03 Oct 2017 15:32:22 +0200 as excerpted:

> Hi,
> It seems to me that the proposal[1] for a snapshot-aware defrag has long
> been abandoned. Since most peoples badly need this feature I tought
> about how to possibly speed up the achievement of this goal.

AFAIK it hasn't been /abandoned/, tho agreed it could seem that way on 
the surface.  Rather, it was tried, and it simply didn't scale, making 
defrag slow to effective impracticality (a snapshot-aware defrag that 
takes a month might as well not exist at all), because many of the 
operations it had to do behind the scenes simply didn't scale.

So the first attempt was rolled back so people could at least defrag in 
reasonable time again, even if it was no longer snapshot-aware.

Now before snapshot-aware defrag can work reasonably, all those various 
scaling issues have to be addressed.  That's happening, but it's not 
something that can be done, at least not done /right/, in a day.

Now I'm not a dev, but if I've been following the patches and discussion 
properly, perhaps the biggest scaling issue has been the lack of an 
ability to reverse-trace something in particular -- the lists work one 
way and that's fast, but reversing things means going thru the entire 
list looking for the item(s) of interest... and snapshot-aware-defrag 
isn't the only thing with the problem, just the easiest to disable as a 
workaround.  The same root problem is the reason TB-scale btrfs check 
takes so much memory in normal mode, or so long in low-memory-mode, and 
it's the reason behind the performance issues with qgroup-enabled 
balance, thus the recommendation to disable qgroups if your balance is 
taking unreasonably long, etc.

Without getting too far into stuff I'm not entirely sure about as a non-
dev, I believe a solution is known in general, but it's only recently 
being looked at for implementation, because there were other more 
pressing things that kept coming up, stuff that ended up needing fixed 
first, etc.  And this /might/ be one of the things that's going to take 
an on-device format change as well, that they're saving up in a list so 
they can do them all together, for one more major change before the final 
push to official btrfs stability, something I've seen mentioned in other 
contexts, tho I'm not positive that it applies to this particular issue.

So bottom line, they're working on it, but it's not something that's 
going to be done in a day, or even a year, as time has demonstrated.  
It's /not/ abandoned, and sure, it could be turned back on with little 
effort in a kernel release cycle or two if they wanted, but until the 
scaling issues are fixed, that wouldn't help, because while some of the 
issues have been fixed and it might take a week to do an hour's work now 
instead of a month, or even "only" a day now, that's not going to change 
the fact that it's not going to be particularly practical, and a non-
snapshot-aware defrag that actually works in reasonable time remains far 
more practical than a snapshot-aware defrag that takes that long.

> I know of several bounty-based kickstarting platforms, among them the
> best ones are probably bountysource.com[2] and freedomsponsors.org[3].
> With both platforms everyone interested can place a bounty on the issue
> and if/when there will be someone interested to implement it he will get
> the bounty.
> I created an issue on both of them just to show how the platform will
> handle it.
> 
> Since btrfs is a small community, before actually placing bounties and
> sponsoring it I would like to know if there is someone against this
> development model or someone interested in implementing a feature
> because of a bounty.

Glad you asked first, because...

Honestly, this is going to go over like a lead balloon.  Similar things 
have been tried before, and invariably, they fail, because it horribly 
clashes with existing kernel culture and practices, and because it 
incentivizes the wrong thing.

What happens both with cash bounties, and with similar effect non-cash 
bounties such as (bare) "get a patch accepted into the kernel" 
requirements for development courses or resume puffery, is that it 
clashes with the general kernel developer long view -- the patch series 
may end up going thru 20 revisions over the course of a year or more, 
fixing complaints from first one subsystem maintainer and then another, 
only to finally be rejected in favor of someone else's different approach 
because it's more maintainable, or works better with something else to be 
built on top, or ... .  Or elements of both approaches (or five or six 
approaches) may ultimately be combined, and the person who first proposed 
a feature may not be the one that gets final authorship even if they 
cooperated with the person and approach that did.

Someone interested in a bounty simply isn't going to stick around for all 
that.

Additionally, there's a huge interest in developing kernel devs that will 
stick around, both to help maintain code they've already submitted, and 
to continue to work on other things.  Bounty-type solutions encourage 
"one-shot-wonders" that disappear and are never seen or heard from 
again.  While that might be fine for a one-line or even 10-line fix, and 
there's normally many such one-shot-fixes in every kernel, those are 
trivial fixes that don't normally need a bounty, while the larger 
features where a bounty might appear to be useful, really need someone 
that's going to stick around to maintain it.  But that's not what 
bounties encourage!

So a bounty simply isn't useful for kernel work, and proposing such 
things, as I said, goes over like a lead balloon, because the experience 
with such things has been **BAD**.

OTOH, there's always room for individuals who are using the code 
themselves, want to make it better, and take a longer term interest in 
learning its ins and outs, and starting small, I've seen suggestions here 
to start with the on-disk format and with btrfs-progs, since that doesn't 
involve hard kernel issues such as machine-locking lock-inversions, or 
data corrupting missing-lock concurrency issues.  Similarly for companies 
willing to sponsor devs to take the time to come up to speed and make 
meaningful contributions, even if it's going to take several man-months 
of work before there's going to be much to show for it, and even if those 
"meaningful contributions" end up coming in under someone else's 
authorship, because that turned out to be the better longer-term solution 
to the problem, tho there /was/ significant contribution to the finally 
accepted solution, just not on the authorship line.

But again, that's pretty much the utter antithesis of bounties.

> [1]https://www.spinics.net/lists/linux-btrfs/msg34539.html
> [2]https://www.bountysource.com/issues/50004702-feature-request-
snapshot-aware-defrag
> [3]https://freedomsponsors.org/issue/817/feature-request-snapshot-aware-
defrag?alert=KICKSTART

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

