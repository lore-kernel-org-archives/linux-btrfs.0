Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44112 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbbFYEBl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jun 2015 00:01:41 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Z7yM4-000382-Hy
	for linux-btrfs@vger.kernel.org; Thu, 25 Jun 2015 06:01:36 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2015 06:01:36 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2015 06:01:36 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: counting fragments takes more time than defragmenting
Date: Thu, 25 Jun 2015 04:01:13 +0000 (UTC)
Message-ID: <pan$c46c7$e4c53f76$44d37440$be0c7aec@cox.net>
References: <20150604084245.GR23272@merlins.org>
	<20150624032008.GF20517@merlins.org>
	<CAA7pwKOA1yyA8kyB+a3iTOp8TnkRzAErF1Mo=2t5M3pFn2tjUw@mail.gmail.com>
	<pan$5335b$94315604$8405c6ac$de90de30@cox.net>
	<CAA7pwKPQfkns_rO0wWkvJsNM3yxHA7neyCH=_jeEY1nHA4Ysfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Patrik Lundquist posted on Wed, 24 Jun 2015 14:05:57 +0200 as excerpted:

> On 24 June 2015 at 12:46, Duncan <1i5t5.duncan@cox.net> wrote:
>> Patrik Lundquist posted on Wed, 24 Jun 2015 10:28:09 +0200 as
>> excerpted:
>>
>> AFAIK, it's set huge to defrag everything,
> 
> It's set to 256K by default.

What I meant is that AFAIK, set it huge to defrag everything...

>> Assuming "set a huge -t to defrag to the maximum extent possible" is
>> correct, that means -t 1G should be exactly as effective as -t 1T...
> 
> 1G is actually more effective because 1T overflows the uint32
> extent_thresh field, so 1T, 0, and 256K are currently the same.

Then the manpage needs some work (in addition to the more serious 
ambiguity over whether 1 or 1G means defrag everything), since it 
mentions upto petabyte (P), without any indication that setting anything 
that large won't work as expected.

If it's uint32 limited, either kill everything above that in both the 
documentation and code, or alias everything above that to 3G (your next 
paragraph) or whatever.

> 3G is the largest value that works with -t as expected (disregarding the
> man page) and is easy to type.
> 
> 
>> But btrfs or ext4, 31 extents ideal or a single extent ideal, 150
>> extents still indicates at least some remaining fragmentation.
> 
> I gave it another shot but I've now got 154 extents instead. :-)

Is it possible there's simply no gig-size free-space holes in the 
filesystem allocation, so it simply /can't/ defrag further than that, 
because there's no place to allocate whole-gig data chunks at a time?

Which brings up a more general defrag functionality question.  For multi-
gig files, does btrfs fi defrag allocate fresh data chunks in ordered to 
create the largest extents possible (possibly after filling the remainder 
of the original first chunk), thereby increasing data chunk allocation 
before fully using currently allocated chunks, or does it try to find the 
biggest extents possible in currently allocated chunks, first, and only 
allocate new chunks when all current allocation is full?

Obviously if it uses up current allocations first, that could explain 
your problem.  OTOH, if either defrag or general allocation strategy 
favors new chunks for large extents when necessary, that would explain 
the "deoptimization" some people report from running balance.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

