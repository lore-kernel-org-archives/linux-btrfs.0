Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38497 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787AbaCYNAt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Mar 2014 09:00:49 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WSQyG-0001G9-HL
	for linux-btrfs@vger.kernel.org; Tue, 25 Mar 2014 14:00:48 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Mar 2014 14:00:48 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Mar 2014 14:00:48 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: free space inode generation (0) did not match free space cache
 generation
Date: Tue, 25 Mar 2014 13:00:21 +0000 (UTC)
Message-ID: <pan$8258b$aea97c0c$211631c9$d306a8a9@cox.net>
References: <532DF38B.40409@friedels.name> <532DFDAB.7000600@friedels.name>
	<pan$b7ff$285d59f6$2419371$b3946ebe@cox.net>
	<53309AF9.8090203@friedels.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hendrik Friedel posted on Mon, 24 Mar 2014 21:52:09 +0100 as excerpted:

>> But regardless of my experience with my own usage pattern, I suspect
>> that with reasonable monitoring, you'll eventually become familiar with
>> how fast the chunks are allocated and possibly with what sort of
>> actions beyond the obvious active moving stuff around on the filesystem
>> triggers those allocations, for your specific usage pattern, and can
>> then adapt as necessary.
> 
> Yes, that's a workaround. But really, that makes one the slave to your
> filesystem. That's not really acceptable, is it?

Well, given the relative immaturity of btrfs as a filesystem at this 
point in its lifetime, I think it's acceptable/tolerable.  However, for a 
filesystem feted[1] to ultimately replace the ext* series as an assumed 
Linux default, I'd definitely argue that the current situation should be 
changed such that btrfs can automatically manage its own de-allocation at 
some point, yes, and that said "some point" really needs to come before 
that point at which btrfs can be considered an appropriate replacement 
for ext2/3/4 as the assumed default Linux filesystem of the day.

---
[1] feted: celebrated, honored.  I had to look it up to be sure my 
intuition on usage was correct, and indeed I had spelled it wrong 
(fetted).  Yay for online wictionary and google-define! =:^)  Anyway, for 
others who may not be familiar with the term, since I have the links open 
ATM:
http://en.wiktionary.org/wiki/feted
https://www.google.com/search?q=define:feted

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

