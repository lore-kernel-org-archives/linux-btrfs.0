Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60125 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465AbaECDKf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 2 May 2014 23:10:35 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WgQLQ-0002ig-JG
	for linux-btrfs@vger.kernel.org; Sat, 03 May 2014 05:10:32 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 03 May 2014 05:10:32 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 03 May 2014 05:10:32 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: btrfs raid56 Was: "csum failed" that was not detected by scrub
Date: Sat, 3 May 2014 03:10:15 +0000 (UTC)
Message-ID: <pan$7fdf7$8b1d584a$86e500d9$23690ab4@cox.net>
References: <CAOwjQU4GP5PjdPZx8HPihS7GQOA74M+DexwMWoh1FOQP0tCTcw@mail.gmail.com>
	<pan$ba09e$4b80fc30$5f891c70$5774c32f@cox.net>
	<loom.20140502T194216-357@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jaap Pieroen posted on Fri, 02 May 2014 17:48:13 +0000 as excerpted:

> Duncan <1i5t5.duncan <at> cox.net> writes:
> 
> 
>> To those that know the details, this tells the story.
>> 
>> Btrfs raid5/6 modes are not yet code-complete, and scrub is one of the
>> incomplete bits.  btrfs scrub doesn't know how to deal with raid5/6
>> properly just yet.

>> The raid5/6 page (which I didn't otherwise see conveniently linked, I
>> dug it out of the recent changes list since I knew it was there from
>> on-list discussion):
>> 
>> https://btrfs.wiki.kernel.org/index.php/RAID56

> So raid5 is much more useless than I assumed. I read Marc's blog and
> figured that btrfs was ready enough.
> 
> I' really in trouble now. I tried to get rid of raid5 by doing a convert
> balance to raid1. But of course this triggered the same issue. And now I
> have a dead system because the first thing btrfs does after mounting is
> continue the balance which will crash the system and send me into a
> vicious loop.
> 
> - How can I stop btrfs from continuing balancing?

That one's easy.  See the Documentation/filesystems/btrfs.txt file in the 
kernel tree or the wiki for btrfs mount options, one of which is 
"skip_balance", to address this very sort of problem! =:^)

Alternatively, mounting it read-only should prevent further changes 
including the balance, at least allowing you to get the data off the 
filesystem.

> - How can I salvage this situation and convert to raid1?
> 
> Unfortunately I have little spare drives left. Not enough to contain
> 4.7TiB of data.. :(

[OK, this goes a bit philosophical, but it's something to think about...]

If you've done your research and followed the advice of the warnings when 
you do a mkfs.btrfs or on the wiki, not a problem, since you know that 
btrfs is still under heavy development and that as a result, it's even 
more critical to have current tested backups for anything you value 
anyway.  Simply use those backups.

Which, by definition, means that if you don't have such backups, you 
didn't consider the data all that valuable after all, actions perhaps 
giving the lie to your claims.  And no excuse for not doing the research 
either, since if you really care about your data, you research a 
filesystem you're not familiar with before trusting your data to it.  So 
again, if you didn't know btrfs was experimental and thus didn't have 
those backups, by definition your actions say you didn't really care 
about the data you put on it, no matter what your words might say.

OTOH, there *IS* such a thing as not realizing the value of something 
until you're in the process of losing it... that I do understand.  But of 
course try telling that to, for instance, someone who has just lost a 
loved one that they never actually /told/ them that...  Sometimes it's 
simply too late.  Tho if it's going to happen, at least here I'd much 
rather it happen to some data, than one of my own loved ones...


Anyway, at least for now you should still be able to recover most of the 
data using skip_balance or read-only mounting.  My guess is that if push 
comes to shove you can either prioritize that data and give up a TiB or 
two if it comes to that, or scrimp here and there, putting a few gigs on 
the odd blank DVD you may have lying around or downgrading a few meals to 
Raman-noodle to afford the $100 or so shipped that pricewatch says a new 
3 TB drive costs, these days.  I've been there, and have found that if I 
think I need it bad enough, that $100 has a way of appearing, like I said 
even if I'm noodling it for a few meals to do it.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

