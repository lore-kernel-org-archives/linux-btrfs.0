Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35119 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbaASVcr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Jan 2014 16:32:47 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W4zz4-0001FO-0k
	for linux-btrfs@vger.kernel.org; Sun, 19 Jan 2014 22:32:46 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Jan 2014 22:32:46 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Jan 2014 22:32:46 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs and ECC RAM
Date: Sun, 19 Jan 2014 21:32:21 +0000 (UTC)
Message-ID: <pan$ab6b4$b10b0e35$6a4b5887$44030d49@cox.net>
References: <AE93F05D-BEE7-4CE6-970E-137EA41D1C7B@aei.mpg.de>
	<pan$a84be$d3729bcc$cd2b0fdb$783fe765@cox.net>
	<1420240.1BEopi7BrR@merkaba>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin Steigerwald posted on Sun, 19 Jan 2014 20:02:41 +0100 as excerpted:

> I´d probably like if all computers had ECC RAM, but then I heard more
> than once that ECC doesn´t even detect all possible memory errors.

Heh, don't I know it!  I had an original generation dual socket, 3-digit 
AMD Opteron system for many years (it finally bit the dust, bulging/
exploded capacitors, a bit over a year ago).  As all Opterons of that era 
it took registered/ecc RAM, but for a couple years I was running PC3200 
rated RAM that Just. Couldn't'. Quite. Stably. Take. its clock-rating.

At some point a BIOS upgrade gave me the ability to de-clock it slightly, 
and then it was "stable as stone", even with wait-cycles decreased a bit 
to partially make up for the lower clocking.  And later I upgraded memory 
and the new memory was fine at rated clock.

But it took me a long time to figure out what was wrong, because I 
couldn't imagine it was the memory due to the ECC, and memtest86+ passed 
it with flying colors as well.  But I guess memtest86+ checks memory cell 
stability but not really clock sensitivity (data in transit on the memory 
bus), and clock sensitivity is where the problem was.

Interestingly enough, one of the more common failures was when untarring 
a tarball.  Apparently that's checksummed, and every once in awhile it 
would fail that checksum.  At least that failure, unlike some of the 
other fortunately less frequent problems, was user-space-only and 
recoverable by simply running the untar once again.

What amazed me, however, was how thru all that reiserfs was stable as a 
rock.  Well, after data=ordered mode was introduced and became the 
default, anyway.  Before that, not so much. =:^\

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

