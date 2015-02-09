Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36876 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522AbbBIFwe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Feb 2015 00:52:34 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YKhGq-0000T3-Am
	for linux-btrfs@vger.kernel.org; Mon, 09 Feb 2015 06:52:32 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Feb 2015 06:52:32 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Feb 2015 06:52:32 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Replacing a (or two?) failed drive(s) in RAID-1 btrfs
 filesystem
Date: Mon, 9 Feb 2015 05:52:26 +0000 (UTC)
Message-ID: <pan$85656$96220f39$b610095f$78e833eb@cox.net>
References: <CANcfdL0x_LTSnyL1FP8vVV4=MaFrewT4pd0MZgu3qzxOviXDgg@mail.gmail.com>
	<CAJCQCtT+8+02KkYOcRUOhscj3AP0av8PpNmsK526hvJY=3ucRw@mail.gmail.com>
	<CANcfdL0twe-pi4f1ZVNG=m82gQTKc5QL3pcodY6diJ6uLj2Q9A@mail.gmail.com>
	<CAJCQCtSJ+kgxKb-gGnuOCFEVBsr2UP0aUWg_M60Ts_OQaSL8oQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Sun, 08 Feb 2015 15:43:35 -0700 as excerpted:

> Confusing is that sdd1, sdi1, sdg1 have gen 0 and also have corruptions
> reported, just not anywhere near as many as sdc1. So I don't know what
> problems you have with your hardware, but they're not restricted to just
> one or two drives. Generation 0 makes no sense to me.

There was a btrfs bug along about kernel 3.17 (or was it 3.18), that 
reset the generation count.  Several people posted weird generation 
outputs within a few days, and then there was a fast bug-fix that went 
into the new kernel and stable for the previous kernel (which IIRC was 
the only one affected), almost before we'd figured out that the reports 
were connected and it was a definite bug!

The good news is that the devs are getting MUCH faster at fixing these 
things -- the first widespread bug from a few kernels ago took just over 
a full kernel cycle to trace down and fix, the next one was fixed in the 
same kernel cycle, this one was traced and fixed so fast that even tho we 
had a number of reports, the devs found and fixed the bug at about the 
same time most list users even became aware that there was a bug in the 
first place!

The bad news is that because it was found and fixed so fast, you 
evidently weren't aware of it at all or you'd have seen it in these zero-
gen reports here, and while I was aware of it, I have less details than 
on the other bugs.

Meanwhile, more good news in that there's a fix, and btrfs check from the 
latest btrfs-progs 3.18.x should have no problems fixing it -- on an 
otherwise normal btrfs, anyway.  But the bad news is that I don't know if 
it'll handle it with the one missing device and one failing, as seems to 
be the case here.

So to the problem at hand, and mostly addressing constantine (OP) now...

The lack of a good backup in this case is... unfortunate.  I'd be 
surprised if there's any list regulars that trust the "still stabilizing" 
btrfs without backups for any data they value, yet.  As any good sysadmin 
(and by that I mean anyone administering systems, professional or not, 
IOW, anyone making this sort of decision is a sysadmin) knows, if the 
data's not backed up (and a good sysadmin knows a backup isn't complete 
until it's tested to whatever level they're comfortable with restoring 
from), by definition, the data is considered of low enough value that 
it's not worth the backup hassle and the admin is prepared to do without 
it as a fair price to pay for avoiding the hassle of backup.  And that's 
the general rule, applying even to stable and mature filesystems.  
Because btrfs is still maturing and isn't yet fully stable, the rule 
applies to btrfs more than ever, so indeed, if it's not backed up, by 
definition, you don't care about losing the data.

Which interpreted strictly, means since there wasn't a backup here, the 
data is by definition of actions of the person responsible, worth less 
than the hassle of backing it up, which by definition means it's loss is 
no big deal, no matter any claims to the contrary.  That being the case, 
in the strict sense, call it a loss and be on to something more important.

But back here dealing in reality... well let's just try to retrieve what 
can be retrieved.

As Chris Murphy has said, that means backing up what you can now.  If at 
all possible leave the existing filesystem as it is when you do that (and 
preferably mount it read-only for now, to minimize the chance of anything 
else going bad on it in the mean time), which means... if you have to get 
out the credit card to get enough storage to create a backup... well, 
it's that or very high risk of losing even more of the data by taking 
another drive out of the array and using it for backup.  This is serious 
rock and hard place time, now.

What fails to backup should show in the log.  Hopefully it's not too much 
and not too valuable.  If you can do without it, great.  Otherwise, again 
as Chris suggested, try btrfs restore on the unmounted filesystem... and 
hope.  Because worked properly, restore can let you recover earlier 
states of the files in question, you may be able to do that for otherwise 
unrecoverable files, even if you can't get the current version.

Personally, I'd try those before trying the checksums reset he 
suggested.  Because that's writing to the damaged filesystem, which of 
course means possibly losing more if things go wrong.  Only if both 
normal backup of what's possible, and restore, can't retrieve critical 
files, would I even bother with the checksum zeroing and further rescue 
efforts.


Meanwhile, when you're done and everything's settled down again, 
regardless of whether you stick with btrfs or revert to a more mature 
filesystem, for the love of your data, PLEASE backup anything you 
consider important.  Even if you don't regularly update those backups, a 
backup of most of it losing the last month or six of work still gives you 
SOMEWHERE to start!  Because if it's not backed up, as you've found out, 
it really does mean you consider the risk of its loss of lower value than 
the time/hassle/media-money you'd spend backing it up.  But I doubt I 
have to tell you that... now!

Meanwhile, even if it's all lost as horrible as that would be, NOT all is 
lost, because it's a lesson most people don't have to learn twice, but 
quite a few do end up learning once the hard way as most admins will tell 
you if they're being honest!  So look at it this way, you'll be a much 
better sysadmin from now on, having learned this lesson!

And regardless of how bad the loss might be, it's only data.  You didn't 
lose your house in a fire; you didn't just have your doctor tell you 
you'll never walk again due to this accident, and you're not looking at 
prison for driving head-on, drunk, into a bus full of people.  Put in 
perspective against the TRULY important things in life, you're actually 
still in pretty good shape, even if you lose all the data, but it 
actually looks like you have a good chance at recovering most of it, so 
you're in even BETTER shape! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

