Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46239 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483AbaLADtq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Nov 2014 22:49:46 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XvHzd-0007s0-8i
	for linux-btrfs@vger.kernel.org; Mon, 01 Dec 2014 04:49:45 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 04:49:45 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 04:49:45 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: root subvol id is 0 or 5?
Date: Mon, 1 Dec 2014 03:49:34 +0000 (UTC)
Message-ID: <pan$ce947$5d255e02$2716ded9$f6df99fd@cox.net>
References: <CAH-HCWWVR=g6mZFZyu6wYRfP7Harr5bxokJi+_qW8QHsniFPFg@mail.gmail.com>
	<20141130115908.GF32735@carfax.org.uk>
	<CAH-HCWWk7J6N0M1z=2N__T0TQ1qffORnxdVNrpjGHh1gtQx3dg@mail.gmail.com>
	<20141130135328.GG32735@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Sun, 30 Nov 2014 13:53:28 +0000 as excerpted:

> On Sun, Nov 30, 2014 at 07:08:51PM +0530, Shriramana Sharma wrote:
>> On Sun, Nov 30, 2014 at 5:29 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>> >
>> >    In the data structures on disk, it's 5. The kernel aliases 0 to
>> > mean subvolid 5.
>> 
>> So why 5 and not just 0 which seems a logical choice? On top of this,
>> one needs to alias 0 to 5!
> 
>    All of the trees used in the FS metadata have an ID number. The
> "well-known" trees have small, fixed IDs:

Thanks, Hugo.

You might wish to find a place in the wiki (probably in the FAQ) for 
that, since your explanation was both the clearest I can imagine and 
cleared up some lingering "but why?" questions along that line for me, as 
well.

And if an answer to that basic a btrfs question is still clearing stuff 
up for me, I expect it could be useful to well over 90% of potential 
btrfs wiki FAQ readers...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

