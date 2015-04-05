Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38837 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136AbbDEDQa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 4 Apr 2015 23:16:30 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Yeb2x-0007Ba-98
	for linux-btrfs@vger.kernel.org; Sun, 05 Apr 2015 05:16:27 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 05 Apr 2015 05:16:27 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 05 Apr 2015 05:16:27 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs hangs 3.19-10
Date: Sun, 5 Apr 2015 03:16:21 +0000 (UTC)
Message-ID: <pan$bf795$4bdcf130$e29eb18a$9b854964@cox.net>
References: <CAGqmi74e_U5-UVUy+MHbxc2f-38pRyjK1Zo0Up-V9ndFpv-bXA@mail.gmail.com>
	<20150402191312.1ee31af3@natsu>
	<pan$a9ed6$bb1c7fdd$74534d5d$7b638441@cox.net>
	<201504041255.08052.russell@coker.com.au>
	<20150404130047.GC13864@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Sat, 04 Apr 2015 13:00:47 +0000 as excerpted:

> On Sat, Apr 04, 2015 at 12:55:08PM +0000, Russell Coker wrote:
> 
>> As an aside are there options to mkfs.btrfs that would make a
>> filesystem mountable by kernel 3.2.65?  If so I'll file a Debian/Jessie
>> bug report requesting that a specific mention be added to the man page.
> 
> Yes, there are. It's probably -O^extref, but if you can show the
> dmesg output from the 3.2 kernel on the failed mount (so that it shows
> what the actual failure was), we should be able to give you a more
> precise answer.

So I was thinking about this, and the several other earlier options where 
support wasn't added until kernel X, and had an idea...

How easy and useful might it be to add to mkfs.btrfs appropriate option-
group aliases such that if one knew the oldest kernel one was likely to 
deal with, all one would need to do for the mkfs would be to set for 
example, -O3.2, or even simply --3.2 (or maybe even --32), and have 
mkfs.btrfs automatically set/unset the appropriate options so it would 
"just work" with that kernel and anything newer?

I imagine that could be a very useful feature for some, and I can't 
imagine it being too hard to setup the aliases since after all that 
should be all that's necessary, so what's left is to decide if it'd 
actually be useful enough to enough people to bother implementing and 
documenting...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

