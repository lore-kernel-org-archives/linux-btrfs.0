Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39395 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbaBKHAF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Feb 2014 02:00:05 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WD7K7-0003G3-Pt
	for linux-btrfs@vger.kernel.org; Tue, 11 Feb 2014 08:00:03 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Feb 2014 08:00:03 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Feb 2014 08:00:03 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS with RAID1 cannot boot when removing drive
Date: Tue, 11 Feb 2014 06:59:34 +0000 (UTC)
Message-ID: <pan$e606d$929b6b8a$283bf1a2$38f7ec5@cox.net>
References: <20140209224055.3175e70f@system>
	<191C3349-9491-44B6-8289-C5B1EDF1F59E@colorremedies.com>
	<20140211041527.57ef96c4@system>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Saint Germain posted on Tue, 11 Feb 2014 04:15:27 +0100 as excerpted:

> Ok I need to really understand how my motherboard works (new Z87E-ITX).
> It is written "64Mb AMI UEFI Legal BIOS", so I thought it was really
> UEFI.

I expect it's truly UEFI.  But from what I've read most UEFI based 
firmware(possibly all in theory, with the caveat that there's bugs and 
some might not actually work as intended due to bugs) on x86/amd64 (as 
opposed to arm) has a legacy-BIOS mode fallback.  Provided it's not in 
secure-boot mode, if the storage devices it is presented don't have a 
valid UEFI config, it'll fall back to legacy-BIOS mode and try to detect 
and boot that.

Which may or may not be what your system is actually doing.  As I said, 
since I've not actually experimented with UEFI here, my practical 
knowledge on it is virtually nil, and I don't claim to have studied the 
theory well enough to deduce in that level of detail what your system is 
doing.  But I know that's how it's /supposed/ to be able to work. =:^)

(FWIW, what I /have/ done, deliberately, is read enough about UEFI to 
have a general feel for it, and to have been previously exposed to the 
ideas for some time, so that once I /do/ have it available and decide 
it's time, I'll be able to come up to speed relatively quickly as I've 
had the general ideas turning over in my head for quite some time 
already, so in effect I'll simply be reviewing the theory and doing the 
lab work, while concurrently making logical connections about how it all 
fits together that only happen once one actually does that lab work.  
I've discovered over the years that this is perhaps my most effective way 
to learn, read about the general principles while not really 
understanding it the first time thru, then come back to it some months or 
years later, and I pick it up real fast, because my subconscious has been 
working on the problem the whole time! Come to think of it, that's 
actually how I handled btrfs, too, trying it at one point and deciding it 
didn't fit my needs at the time, leaving it for awhile, then coming back 
to it later when my needs had changed, but I already had an idea what I 
was doing from the previous try, with the result being I really took to 
it fast, the second time!  =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

