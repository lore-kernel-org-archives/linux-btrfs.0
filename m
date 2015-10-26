Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38709 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905AbbJZJOR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Oct 2015 05:14:17 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Zqdr2-0007EA-Mo
	for linux-btrfs@vger.kernel.org; Mon, 26 Oct 2015 10:14:12 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2015 10:14:12 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2015 10:14:12 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Recover btrfs volume which can only be mounded in read-only
 mode
Date: Mon, 26 Oct 2015 09:14:00 +0000 (UTC)
Message-ID: <pan$5181$c6023994$2cb7128f$59b43d97@cox.net>
References: <CAOGcOQE3_ROtk=2kQkjTUkGE1tz=HEzbeZnrWUOPziW=kNNXBQ@mail.gmail.com>
	<561E6969.40500@oracle.com> <561EBAB1.6030600@gmail.com>
	<pan$21730$7c1e6fa7$932b1831$daf2c6bb@cox.net>
	<CAOGcOQGnHaZeiyuqm+rSX=MBNSFnE-JwSmnhTWZVU42FnSgXmA@mail.gmail.com>
	<pan$e78b7$efe06fb0$f477bf4e$85f224c0@cox.net> <562369E8.60709@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dmitry Katsubo posted on Sun, 18 Oct 2015 11:44:08 +0200 as excerpted:

>> Meanwhile, the present btrfs raid1 read-scheduler is both pretty simple
>> to code up and pretty simple to arrange tests for that run either one
>> side or the other, but not both, or that are well balanced to both.
>> However, it's pretty poor in terms of ensuring optimized real-world
>> deployment read-scheduling.
>> 
>> What it does is simply this.  Remember, btrfs raid1 is specifically two
>> copies.  It chooses which copy of the two will be read very simply,
>> based on the PID making the request.  Odd PIDs get assigned one copy,
>> even PIDs the other.  As I said, simple to code, great for ensuring
>> testing of one copy or the other or both, but not really optimized at
>> all for real-world usage.
>> 
>> If your workload happens to be a bunch of all odd or all even PIDs,
>> well, enjoy your testing-grade read-scheduler, bottlenecking everything
>> reading one copy, while the other sits entirely idle.
> 
> I think PID-based solution is not the best one. Why not simply take a
> random device? Then at least all drives in the volume are equally loaded
> (in average).

Nobody argues that the even/odd-PID-based read-scheduling solution is 
/optimal/, in a production sense at least.  But at the time and for the 
purpose it was written it was pretty good, arguably reasonably close to 
"best", because the implementation is at once simple and transparent for 
debugging purposes, and real easy to test either one side or the other, 
or both, and equally important, to duplicate the results of those tests, 
by simply arranging for the testing to have either all even or all odd 
PIDs, or both.  And for ordinary use, it's good /enough/, as ordinarily, 
PIDs will be evenly distributed even/odd.

In that context, your random device read-scheduling algorithm would be 
far worse, because while being reasonably simple, it's anything *but* 
easy to ensure reads go to only one side or equally to both, or for that 
matter, to duplicate the tests, because randomization, by definition 
does /not/ lend itself to duplication.

And with both simplicity/transparency/debuggability and duplicatability 
of testing being primary factors when the code went in...

And again, the fact that it hasn't been optimized since then, in the 
context of "premature optimization", really says quite a bit about what 
the btrfs devs themselves consider btrfs' status to be -- obviously *not* 
production-grade stable and mature, or optimizations like this would have 
already been done.

Like it or not, that's btrfs' status at the moment.

Actually, the coming N-way-mirroring may very well be why they've not yet 
optimized the even/odd-PID mechanism already, because doing an optimized 
two-way would obviously be premature-optimization given the coming N-way, 
and doing an N-way clearly couldn't be properly tested at present, 
because only two-way is possible.  Introducing an optimized N-way 
scheduler together with the N-way-mirroring code necessary to properly 
test it thus becomes a no-brainer.

> From what you said I believe that certain servers will not benefit from
> btrfs, e.g. dedicated server that runs only one "fat" Java process, or
> one "huge" MySQL database.

Indeed.  But with btrfs still "stabilizing, but not entirely stable and 
mature", and indeed, various features still set to drop, and various 
optimizations still yet to do including this one, nobody, leastwise not 
the btrfs devs and knowledgeable regulars on this list, is /claiming/ 
that btrfs is at this time the be-all and end-all optimal solution for 
every single use-case.  Rather far from it!

As for the claims of salespeople... should any of them be making wild 
claims about btrfs, who in their sane mind takes salespeople's claims at 
face value in any case?

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

