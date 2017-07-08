Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:56953 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750910AbdGHUv6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Jul 2017 16:51:58 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dTwhi-0002RZ-6k
        for linux-btrfs@vger.kernel.org; Sat, 08 Jul 2017 22:51:50 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: raid10 array lost with single disk failure?
Date: Sat, 8 Jul 2017 20:51:41 +0000 (UTC)
Message-ID: <pan$b8d9f$672ac146$c6d8fd45$3b1ed204@cox.net>
References: <CACzgC9j026GHxX9m8=1iaYyV9ejFrzaC3nqwgn+j_awXA7D_Lw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Adam Bahe posted on Fri, 07 Jul 2017 23:26:31 -0500 as excerpted:

> I did recently upgrade the kernel a few days ago from
> 4.8.7-1.el7.elrepo.x86_64 to 4.10.6-1.el7.elrepo.x86_64. I had also
> added a new 6TB disk a few days ago but I'm not sure if the balance
> finished as it locked up sometime today when I was at work. Any ideas
> how I can recover? Even if I have 1 bad disk, raid10 should have kept my
> data safe no? Is there anything I can do to recover?

Yes, btrfs raid10 should be fine with a single bad device.  That's 
unlikely to be the issue.

But you did well to bring up the balance.  Have you tried mounting with 
the "skip_balance" mount option?

Sometimes a balance will run into a previously undetected problem with 
the filesystem and crash.  While mounting would otherwise still work, as 
soon as the filesystem goes active at the kernel level and before the 
mount call returns to userspace, the kernel will see the in-progress 
balance and attempt to continue it.  But if it crashed while processing a 
particular block group (aka chunk), of course that's the first one in 
line to continue the balance with, which will naturally crash again as it 
comes to the same inconsistency that triggered the crash the first time.

So the skip_balance mount option was invented to create a work-around and 
allow you to mount the filesystem again. =:^)

The fact that it sits there for awhile trying to do IO on all devices 
before it crashes is another clue it's probably the resumed balance 
crashing things as it comes to the same inconsistency that triggered the 
original crash during balance, so it's very likely that skip_balance will 
help. =:^)

Assuming that lets you mount, the next thing I'd try is a btrfs scrub.  
Chances are it'll find some checksum problems, but given that you're 
running raid10, there's a second copy it can try to use to correct the 
bad one and there's a reasonably good chance scrub will find and fix your 
problems.  Even if it can't fix them all, it should get you closer, with 
less chance at making things worse instead of better than more risky 
options such as btrfs check with --repair.

If a scrub completes with no uncorrected errors, I'd do an umount/mount 
cycle or reboot just to be sure -- don't forget the skip_balance option 
again tho -- and then, ensuring you're not doing anything that a crash 
would interrupt and have taken the opportunity presented to update your 
backups if you need to and assuming you consider the data worth more than 
the time/trouble/resources required for a backup, try a balance resume.

Once the balance resume gets reasonably past the time it otherwise took 
to crash, you can reasonably assume you've safely corrected at least 
/that/ inconsistency, and hope the scrub took care of any others before 
you got to them.

But of course all scrub does is verify checksums and where there's a 
second copy (as there is with dup, raid1 and raid10 modes) attempt a 
repair of the bad copy with the second one, of course verifying it as 
well in the process.  If the second copy of that block is bad too or in 
cases where there isn't such a second copy, it'll detect but not be able 
to fix the block with a bad checksum, and if the block has a valid 
checksum but is logically invalid for other reasons, scrub won't detect 
it, because /all/ it does is verify checksums, not actual filesystem 
consistency.  That's what the somewhat more risky (if --repair or other 
fix option is used, not in read-only mode, which detects but doesn't 
attempt to fix) btrfs check is for.

So if skip_balance doesn't work, or it does but scrub can't fix all the 
errors it finds, or scrub fixes everything it detects but a balance 
resume still crashes, then it's time to try riskier fixes.  I'll let 
others guide you there if needed, but will leave you with one reminder...

Sysadmin's first rule of backups:

Don't test fate and challenge reality!  Have your backups or regardless 
of claims to the contrary you're defining your data as throw-away value, 
and eventually, fate and reality are going to call you on it!

So don't worry too much even if you lose the filesystem.  Either you have 
backups and can restore from them should it be necessary, or you defined 
the data as not worth the trouble of those backups, and losing it isn't a 
big deal, because in either case you saved what was truly important to 
you, either the data because it was important enough to you to have 
backups, or the time/resources/trouble you would have spent doing those 
backups, which you still saved regardless of whether you can save the 
data or not. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

