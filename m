Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53943 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbaIBGkg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Sep 2014 02:40:36 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XOhlZ-0005v5-Un
	for linux-btrfs@vger.kernel.org; Tue, 02 Sep 2014 08:40:33 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Sep 2014 08:40:33 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Sep 2014 08:40:33 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: kernel 3.17-rc3: task rsync:2524 blocked for more than 120
 seconds
Date: Tue, 2 Sep 2014 06:40:19 +0000 (UTC)
Message-ID: <pan$1b676$93919c37$3c0fae08$71129a93@cox.net>
References: <CANg_oxzqyr3Jcx-8ntPPntjVmRjWqheUqaWOWpkhh5Rrw3Ayrw@mail.gmail.com>
	<540498AF.6030109@fb.com>
	<CANg_oxwNkjZf1gVfOJE72fUyqJvMpF+hQdN-V0_cPAJ9nxPsjQ@mail.gmail.com>
	<pan$efe46$daffbd12$cb4477b6$9a3e7f57@cox.net>
	<CANg_oxz9NGNVnY3rjeYPXqqi0PtcxZkMVyD5marfmXfvCp7VPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

john terragon posted on Tue, 02 Sep 2014 08:12:36 +0200 as excerpted:

> I will definitely try the latest 3.14.x (never had any problem of this
> kind with it). And I'll look into the other possibilities you pointed
> out. However what I can tell you right now is this:
> 
> -the filesystem was "new". I've been bitten by this bug with 3.15 and
> 3.16 and I kept
>  trying to do the same thing (create the fs, rsync or cp the same
> stuff) to see if it
>  got better.

OK.  I had read your post as implying that the filesystem had been around 
since before 3.14, in which case the firmware shuffling could well have 
been a factor.  If it was a brand new filesystem, then likely not, as 
mkfs.btrfs tries to do a trim of the whole filesystem range before it 
sets up.

But that does remind me of one other possibility I had thought to mention 
and then forgot... that's even more likely now that it's known to be a 
new filesystem...

I don't recall the btrfs-progs version, but somewhere along the line one 
other thing of potential interest changed:

Mkfs.btrfs used to default to 4 KiB node/leaf sizes; now days it defaults 
to 16 KiB as that's far better for most usage.  I wonder if USB sticks 
are an exception...

Since this is set at mkfs time, trying a 3.14 series kernel with current 
mkfs.btrfs defaults shouldn't change things; if the 16 KiB nodesize is 
why it's slow, it should still be slow with the 3.14 series kernel.

Conversely, if this is the problem, specifically creating the filesystem 
with --nodeside 4k should fix it, and it should stay fixed regardless of 
what kernel you use with it, 3.14, 3.16, 3.17-rcX, shouldn't matter.

And that'd be a very useful thing to put on the wiki as well, should it 
be found to be the case.  So please test and post if it helps (and feel 
free to put it on the wiki too if it works)!  =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

