Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45720 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943AbaADNDh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 4 Jan 2014 08:03:37 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VzQt5-00059n-2X
	for linux-btrfs@vger.kernel.org; Sat, 04 Jan 2014 14:03:35 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 04 Jan 2014 14:03:35 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 04 Jan 2014 14:03:35 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs raid1 and btrfs raid10 arrays NOT REDUNDANT
Date: Sat, 4 Jan 2014 13:03:11 +0000 (UTC)
Message-ID: <pan$2efb3$5b939250$4914dbcd$c2014fcc@cox.net>
References: <52C73987.7000106@jrs-s.net>
	<7B4E55D1-BA9B-4560-8442-429EDD01C92A@colorremedies.com>
	<pan$4ef1f$8e2a9876$c1faa462$63914453@cox.net> <1511915.CullaLvumH@quad>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Samuel posted on Sat, 04 Jan 2014 22:20:20 +1100 as excerpted:

> On Sat, 4 Jan 2014 06:10:14 AM Duncan wrote:
> 
>> Btrfs remains under development and there are clear warnings about
>> using it without  backups one hasn't tested recovery from or are not
>> otherwise prepared to  actually use.  It's stated in multiple locations
>> on the wiki; it's stated on the kernel btrfs config option, and it's
>> stated in mkfs.btrfs output when you create the filesystem.
> 
> Actually the scary warnings are gone from the Kconfig file for what will
> be the 3.13 kernel.  Removed by this commit:
> 
> commit 4204617d142c0887e45fda2562cb5c58097b918e

FWIW, I'd characterize that as toned down somewhat, not /gone/.  You 
don't see ext4 or other "mature" filesystems saying "The filesystem disk 
format is no longer unstable, and it's not expected to change 
unless" ..., do you?

"Not expected to change" and etc is definitely toned down from what it 
was, no argument there, but it still isn't exactly what one would expect 
in a description from a stable filesystem.  If there's still some chance 
of the disk format changing, what does that say about the code /dealing/ 
with that disk format?  That doesn't sound exactly like something I'd be 
comfortable staking my reputation as a sysadmin on as judged fully 
reliable and ready for my mission-critical data, for sure!

Tho agreed, one certainly has to read between the lines a bit more for 
the kernel option now than they did.

But the real kicker for me was when I redid several of my btrfs 
partitions to take advantage of newer features, 16 KiB nodes, etc, and 
saw the warning it's giving, yes, in btrfs-progs 3.12 after all the 
recent documentation changes, etc.  Not everybody builds their own 
kernel, but it's kind of hard to get a btrfs filesystem without making 
one!  (Yes, I know the installers make the filesystem for many people, 
and may well hide the output, but if so and the distros don't provide a 
similar warning when people choose btrfs, that's entirely on the distros 
at that point.  Not much btrfs as upstream can do about that.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

