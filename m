Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47966 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbbLQEfK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Dec 2015 23:35:10 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a9QHS-0003N1-4N
	for linux-btrfs@vger.kernel.org; Thu, 17 Dec 2015 05:35:06 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Dec 2015 05:35:06 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Dec 2015 05:35:06 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [auto-]defrag, nodatacow - general suggestions?(was: btrfs:
 poor performance on deleting many large files?)
Date: Thu, 17 Dec 2015 04:35:00 +0000 (UTC)
Message-ID: <pan$60a5$5c0e446a$85650a60$a532d16d@cox.net>
References: <CA+ve2MYBAPbLPiX4i2oZeDeu+9=JurXHsx5fMef2iV3rRrCKxg@mail.gmail.com>
	<56530DAD.9080607@gmail.com> <1448497439.28195.33.camel@scientia.net>
	<pan$3c463$5dc6ffa1$704b2ca2$141e65cc@cox.net>
	<5667C00B.4010100@scientia.net>
	<pan$7e682$345fe6d2$de13162d$f5ac4118@cox.net>
	<1450303141.6242.50.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Wed, 16 Dec 2015 22:59:01 +0100 as
excerpted:

>> And there very well might be such a tool... five or ten years down the
>> road when btrfs is much more mature and generally stabilized, well
>> beyond the "still maturing and stabilizing" status of the moment.

> Hmm let's hope btrfs isn't finished only when the next-gen default fs
> arrives ;^)

[Again, breaking into smaller point replies...]

Well, given the development history for both zfs and btrfs to date, five 
to ten years down the line, with yet another even newer filesystem then 
already under development, is more being "real", than not.  Also see the 
history in MS' attempt at a next-gen filesystem.  The reality is these 
things take FAR longer than one might think.

FWIW, on the wiki I see feature points and benchmarks for v0.14, 
introduced in April of 2008, and a link to an earlier btree filesystem on 
which btrfs apparently was based, dating to 2006, so while I don't have a 
precise beginning date, and to some extent such a thing would be rather 
arbitrary anyway, as Chris would certainly have done some major thinking, 
preliminary research and coding, before his first announcement, a project 
origin in late 2006 or sometime in 2007 has to be quite close.

And (as I noted in a parenthetical at my discovery in a different 
thread), I switched to btrfs for my main filesystems when I bought my 
first SSDs, in June of 2013, so already a quarter decade ago.  At the 
time btrfs was just starting to remove some of the more dire 
"experimental" warnings.  Obviously it has stabilized quite a bit since 
then, but due to the oft-quoted 80/20 rule and extensions, where the last 
20% of the progress takes 80% of the work, etc...

It could well be another five years before btrfs is at a point I think 
most here would call stable.  That would be 2020 or so, about 13 years 
for the project, and if you look at the similar projects mentioned above, 
that really isn't unrealistic at all.  Ten years minimum, and that's with 
serious corporate level commitments and a lot more dedicated devs than 
btrfs has.  12 years not unusual at all, and a decade and a half still 
well within reasonable range, for a filesystem with this level of 
complexity, scope, and features.

And realistically, by that time, yet another successor filesystem may 
indeed be in the early stages of development, say at the 20/80 point, 20% 
of required effort invested, possibly 80% of the features done, but not 
stabilized.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

