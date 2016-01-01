Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54254 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922AbcAARGD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Jan 2016 12:06:03 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aF39M-0005nF-Fr
	for linux-btrfs@vger.kernel.org; Fri, 01 Jan 2016 18:06:00 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Jan 2016 18:06:00 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Jan 2016 18:06:00 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs scrub failing
Date: Fri, 1 Jan 2016 17:05:55 +0000 (UTC)
Message-ID: <pan$ddf92$7633f36c$14118b68$b87353e3@cox.net>
References: <CAPgWCbQ9HS1N=JCbbHuT9yyTz3JPAizA+DvOAR7_GX73CVix0g@mail.gmail.com>
	<pan$1f21$8d293d0$5b6cd545$34c90ade@cox.net>
	<26CBABB7-7744-4833-A37B-C2380304223F@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

John Center posted on Fri, 01 Jan 2016 11:41:20 -0500 as excerpted:

> Ok, I'll upgrade to 4.3 & see if that resolves the problem with
> scrubbing.
> I was wondering when I compiled the btrfs-tools if there would be a
> problem with them not being in sync with the major kernel version.

FWIW newer (or older either, as long as not too old and you don't need 
any of the features not in the older, and you're not trying to fix 
problems only the newer can deal with) versions of btrfs-progs should be 
fine.  As a rule of thumb I recommend staying at least current to kernel 
version, but that's a rule of thumb, primarily to prevent getting /too/ 
old, only.  Both the btrfs-progs userspace and the kernel itself are 
normally designed to be able to work with both older and newer versions 
of the other one.

So userspace not being in sync with the kernel version shouldn't be a 
problem.

> If this doesn't resolve the problem, what would you recommend my next
> steps should be?  I've been hesitant to run too many of the btrfs-tools,
> mainly because I don't want to accidentally screw things up & I don't
> always know how to interpret the results. (I ran btrfs-debug-tree,
> hoping something obvious would show up.  Big mistake. 😋)

LOLed at that debug-tree remark.  Been there (with other tools) myself.

Well, I'm hoping someone who had the problem can confirm whether it's 
fixed in current kernels (scrub is one of those userspace commands that's 
mostly just a front-end to the kernel code which does the real work, so 
kernel version is the important thing for scrub).  I'm guessing so, and 
that you'll find the problem gone in 4.3.

We'll cross the not-gone bridge if we get to it, but again, if the other 
people who had the similar problem can confirm whether it disappeared for 
them with the new kernel, it would help a lot, as there were enough such 
reports that if it's the same problem and still there for everyone (which 
I doubt as I expect there'd still be way more posts about it if so, but 
confirmation's always good), nothing to do but wait for a fix, while if 
not, and you still have your problem, then it's a different issue and the 
devs will need to work with you on a fix specific to your problem.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

