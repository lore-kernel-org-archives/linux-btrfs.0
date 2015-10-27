Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49790 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753048AbbJ0F6a (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Oct 2015 01:58:30 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZqxHA-0005IO-3x
	for linux-btrfs@vger.kernel.org; Tue, 27 Oct 2015 06:58:28 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2015 06:58:28 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2015 06:58:28 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Recover btrfs volume which can only be mounded in read-only
 mode
Date: Tue, 27 Oct 2015 05:58:22 +0000 (UTC)
Message-ID: <pan$e5e2d$4d523be4$45db755c$a34029b2@cox.net>
References: <CAOGcOQE3_ROtk=2kQkjTUkGE1tz=HEzbeZnrWUOPziW=kNNXBQ@mail.gmail.com>
	<561E6969.40500@oracle.com> <561EBAB1.6030600@gmail.com>
	<pan$21730$7c1e6fa7$932b1831$daf2c6bb@cox.net>
	<CAOGcOQGnHaZeiyuqm+rSX=MBNSFnE-JwSmnhTWZVU42FnSgXmA@mail.gmail.com>
	<pan$e78b7$efe06fb0$f477bf4e$85f224c0@cox.net> <562369E8.60709@gmail.com>
	<pan$5181$c6023994$2cb7128f$59b43d97@cox.net>
	<20151026092457.GA11331@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Mon, 26 Oct 2015 09:24:57 +0000 as excerpted:

> On Mon, Oct 26, 2015 at 09:14:00AM +0000, Duncan wrote:
>> Dmitry Katsubo posted on Sun, 18 Oct 2015 11:44:08 +0200 as excerpted:
>> 
>>> I think PID-based solution is not the best one. Why not simply take a
>>> random device? Then at least all drives in the volume are equally
>>> loaded (in average).
>> 
>> Nobody argues that the even/odd-PID-based read-scheduling solution is
>> /optimal/, in a production sense at least.  But [it's near ideal for
>> testing, and "good enough" for the most general case].
> 
> For what it's worth, David tried implementing round-robin (IIRC)
> some time ago, and found that it performed *worse* than the pid-based
> system. (It may have been random, but memory says it was round-robin).

What I'd like to know is what mdraid1 uses, and if btrfs can get that.  
Because some upgrades worth ago, after trying mdraid6 for the main system 
and mdraid0 for some parts (with mdraid1 for boot since grub1 could deal 
with it, but not the others), I eventually settled on 4-way mdraid1 for 
everything, using the same disks I had used for the raid6 and raid0.

And I was rather blown away by the mdraid1 speed, in comparison, 
especially compared to raid0, which I thought would be better than 
raid1.  I guess my use-case is multi-thread read-heavy enough that the 
whatever mdraid1 uses, I was getting upto four separate reads (one per 
spindle) going at once, while writes still happened at single-spindle 
speed as with SATA (as opposed to the older IDE, this was when SATA was 
still new), each spindle had its own channel and they could write in 
parallel with bottleneck being the speed at which the slowest of the four 
completed its write.  So writes were single-spindle-speed, still far 
faster than the raid6 read-modify-write cycle, while reads... it really 
did appear to multitask one per spindle.

Also, the mdraid1 may have actually taken into account spindle head 
location as well, and scheduled reads to the spindle with the head 
already positioned closest to the target, tho I'm not sure on that.

But whatever mdraid1 scheduling does, I was totally astonished at how 
efficient it was, and it really did turn my thinking on most efficient 
raid choices upside down.  So if btrfs could simply take that scheduler 
and modify it as necessary for btrfs specifics, provided the 
modifications weren't /too/ heavy (and the fact that btrfs does read-time 
checksum verification could very well mean the algorithm as directly 
adapted as possible may not reach anything like the same efficiency), I 
really do think that'd be the ideal.  And of course it's freedomware code 
in the same kernel, so reusing the mdraid read-scheduler shouldn't be the 
problem it might be in other circumstances, tho the possible caveat of 
btrfs specific implementation issues does remain.

And of course someone would have to take the time to adapt it to work 
with btrfs, which gets us back onto the practical side of things, the 
"opportunity rich, developer-time poor" situation that is btrfs coding 
reality, premature optimization, possibly doing it at the same time as N-
way-mirroring, etc.

But anyway, mdraid's raid1 read-scheduler really does seem to be 
impressively efficient, the benchmark to try to match, if possible.  If 
that can be done by reusing some of the same code, so much the better. 
=:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

