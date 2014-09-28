Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36105 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbaI1Ebv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Sep 2014 00:31:51 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XY69F-0007f8-9y
	for linux-btrfs@vger.kernel.org; Sun, 28 Sep 2014 06:31:49 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Sep 2014 06:31:49 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Sep 2014 06:31:49 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Backup: Compare sent snapshots
Date: Sun, 28 Sep 2014 04:31:36 +0000 (UTC)
Message-ID: <pan$4edea$5f44fdfd$820ac2a1$d635bbcf@cox.net>
References: <8465933.4bvG1Xk5zJ@linuxpc>
	<pan$92371$cf7e2c62$a94a9382$e3e154b@cox.net>
	<CAOsFrTfQHZjUbBcMkx9e30x6fdi216PAMPRo+QoVmqAR0pZH1Q@mail.gmail.com>
	<pan$2cf2e$b466e32e$8c5d4ef4$9a82294f@cox.net>
	<CAOsFrTf6_RySdGH-zhPR6_9hEoa3G69ZJYKkYjbvs2vuSkGc9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

G EO posted on Sat, 27 Sep 2014 12:01:22 +0200 as excerpted:

>> What I had in mind was this [...]:
>> On the main filesystem, you did the first full send, we'll call it A.
>> Then you did an incremental send with a new snapshot, B, using A as its
>> parent, and later another, C, using B as its parent.
>> On the backup, assuming you didn't delete anything and that the
>> receives completed without error, you'd then have copies of all three,
>> A, B, C. Now let's say you decide A is old and you no longer need it,
>> so you delete it on both sides, leaving you with B and C.
>> Now back on the main machine C is damaged.  But you still have B on
>> both machines and C on the backup machine.
>> What I was suggesting was that you could reverse the last send/receive,
>> sending C from the backup with B as its parent (since B exists
>> undamaged on both sides, with C undamaged on the backup but damaged or
>> missing on the main machine), thereby restoring a valid copy of C on
>> the main machine once again.
>> Once you have a valid copy of C on the main machine again, you can now
>> do normal incremental send/receive D, using C as its parent, just as
>> you would have if C had never been damaged in the first place, because
>> you restored a valid C reference on your main machine in ordered to be
>> able to do so.
> 
> Assuming B (nor A) is nonexistent locally anymore and C damaged (or
> nonexistent) locally there would be no way for determining the
> differences (between C on the backup drive and the current active
> subvolume on the root partition) anymore right? At least not with send
> -p right?

To the best of my knowledge that's absolutely correct.  There has to be a 
common parent reference on both sides in ordered to do the incremental 
send/receive based on it.

If you don't have that common base, then the best you can do is a full 
non-incremental send once again.  Either that or switch to some other 
alternative, say rsync, and forget about the btrfs-specific send/receive.

>> That means that when you defrag, you're defragging /just/ the snapshot
>> you happened to point defrag at, and anything it moves in that defrag
>> is effect duplicated, since other snapshots previously sharing that
>> data aren't defragged along with it so they keep a reference to the
>> old, undefragged version, thus doubling the required space for anything
>> moved.
> 
> 
> Is defrag disabled by default?

Defrag must be specifically triggered, either by specifically enabling 
the autodefrag mount option, or by running defrag manually, etc.

Of course it's possible some distros either enable autodefrag by default 
or setup a cron job or systemd timer for it, but that's them, not as 
shipped from btrfs upstream.

> Are "space_cache" and "compress-force=lzo" known to cause trouble with
> snapshots?

No.

Space_cache is enabled automatically these days, so if there's a big 
problem with it it'll affect many many people, and as such, should be 
detected and fixed rather quickly.

Not directly related to your question but FWIW, there was a recent 
deadlock (not snapshot) bug with compress, obviously easier to trigger if 
compress-force is used, but neither compress nor compress-force are 
enabled by default yet due to relatively wide use it still illustrates 
the point I made above about space_cache rather well, because the bug was 
triggered with the switch from dedicated btrfs worker threads in 3.14 to 
generic kworker threads in 3.15.  It did get thru the full 3.15 cycle but 
by the middle of the 3.16 development cycle the fact that there was a 
problem was well known, tho it was quite a tough bug to trace and took to 
the end of the 3.16 cycle to pin down a general culprit and thru the 3.17 
commit window to develop and test a patch.  That patch was applied in 
3.17-rc2 and in 3.16.2.

IOW, while it's not the default, there's enough folks using compress and 
compress-force that a bug affecting it was found, traced and fixed in two 
kernel cycles, the 3.15 commit window introduced it and it was fixed with 
3.17-rc2, thus immediately after the 3.17 commit window.

With space_cache being the default, a similar bug with it would almost 
surely not survive even the development cycle -- if it had been 
introduced in 3.15's commit window, people would have been yelling by rc2 
or 3 at the latest, and if it weren't traced, the entire btrfs patch 
series for 3.15 would have very likely been reverted by rc6 or rc7, thus 
never making it into a full release kernel at all.


Now btrfs is still under heavy development.  However, both snapshots and 
compression are widely enough used both on their own and together that if 
there was a serious existing problem with the combination, it'd be known, 
and any fleeting bug should be detected and made just that, fleeting, 
within I'd say 2-3 kernel cycles.

But meanwhile, other bugs are constantly being fixed, so unless you 
specifically know of such a bug and are avoiding the most current kernel 
or two due to that, staying current, latest kernel of the latest stable 
kernel series at least, is very strongly recommended.  During the 
situation above some folks were retreating to 3.14 since it was both 
before the problem and a long-term-stable-series, but the problem wasn't 
known until early in the 3.16 cycle and was fixed early in the 3.17 
cycle, and that exception can be noted both due to its rarity and the 
fact that it effectively existed only a single kernel cycle.

>> Snapshot size?  That's not as well defined as you might think.  Do you
>> mean the size of everything in that snapshot, including blocks shared
>> with other snapshots, or do you mean just the size of what isn't shared
> 
> 
> The full size of a snapshot, including what is shared with others is
> easy to measure simply using "du", right?

Agreed.

> For the relative size this should work with "qgroup show", right?

I've completely avoided anything having to do with quotas/qgroups here, 
as they're both well outside my use-case and had known issues of their 
own until very recently.  The quotas/qgroups code was in fact recently 
(last kernel cycle I believe) rewritten and /should/ be rather more 
reliable/stable now, but as I'm not directly following it I'm not even 
sure whether that rewrite is yet even entirely committed.  And if it is, 
it's definitely still fresh enough code that its functionality and 
general stability remain open questions.

So except for pure experimental purposes I'd avoid doing anything at all 
with qgroups ATM.  Assuming the new code is in fact all in at this point, 
I'd recommend waiting out the 3.18 kernel cycle and if it appears to be 
stable by the time 3.18 is released and the 3.19 kernel cycle starts, 
consider it then.

Beyond that, definitely compare notes with someone already using
quotas/qgroups, as I simply don't know.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

